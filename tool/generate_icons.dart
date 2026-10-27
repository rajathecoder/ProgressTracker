// Generates the app's launcher icons, notification icon and in-app logo from
// assets/brand/logo_source.png.
//
// The source is a greyscale render with a transparent background. It is
// recoloured here rather than by hand so the brand stays in one place: the two
// brand colours below are the only knobs.
//
//   dart run tool/generate_icons.dart
import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

/// Deep teal for the ring and the looping stroke.
const _teal = (r: 26, g: 92, b: 108);
const _tealLight = (r: 62, g: 155, b: 176);

/// Green for the arrow and the checkmark - the brightest parts of the source.
const _green = (r: 34, g: 197, b: 122);
const _greenLight = (r: 74, g: 222, b: 150);

/// Luminance above this is treated as "arrow / check" rather than "ring".
const _greenThreshold = 0.60;

void main() async {
  final source = File('assets/brand/logo_source.png');
  if (!source.existsSync()) {
    stderr.writeln('Missing ${source.path}');
    exit(1);
  }

  final decoded = img.decodePng(source.readAsBytesSync());
  if (decoded == null) {
    stderr.writeln('Could not decode ${source.path}');
    exit(1);
  }

  final trimmed = _trimTransparent(decoded);
  final coloured = _recolour(trimmed);

  // ---------------------------------------------------------------- in-app
  _write('assets/brand/logo.png', _square(coloured, 512));
  _write('assets/brand/logo_mono.png', _monochrome(_square(trimmed, 512)));

  // -------------------------------------------------------------- Android
  const launcher = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
  };
  for (final entry in launcher.entries) {
    final dir = 'android/app/src/main/res/${entry.key}';
    Directory(dir).createSync(recursive: true);
    // Launcher icons need an opaque backing plate; a transparent PNG renders
    // as a floating glyph on most launchers.
    _write(
      '$dir/ic_launcher.png',
      _onPlate(_square(coloured, entry.value), entry.value),
    );
    // The adaptive foreground keeps the safe-zone padding the system expects.
    _write(
      '$dir/ic_launcher_foreground.png',
      _square(coloured, entry.value, insetFactor: 0.62),
    );
  }

  // Notification icons must be a white silhouette on transparency: Android
  // masks them to a single colour, so any detail in the source is lost and a
  // full-colour icon shows up as a solid white blob.
  const notif = {
    'drawable-mdpi': 24,
    'drawable-hdpi': 36,
    'drawable-xhdpi': 48,
    'drawable-xxhdpi': 72,
    'drawable-xxxhdpi': 96,
  };
  for (final entry in notif.entries) {
    final dir = 'android/app/src/main/res/${entry.key}';
    Directory(dir).createSync(recursive: true);
    _write(
      '$dir/ic_notification.png',
      _silhouette(_square(trimmed, entry.value)),
    );
  }

  // ------------------------------------------------------------------ iOS
  const ios = [20, 29, 40, 58, 60, 76, 80, 87, 120, 152, 167, 180, 1024];
  const iosDir = 'ios/Runner/Assets.xcassets/AppIcon.appiconset';
  Directory(iosDir).createSync(recursive: true);
  for (final size in ios) {
    // iOS rejects alpha in app icons outright.
    _write('$iosDir/Icon-App-$size.png', _flatten(_square(coloured, size)));
  }
  File('$iosDir/Contents.json').writeAsStringSync(_iosContents());

  stdout.writeln('Generated launcher, notification and in-app icons.');
}

// --------------------------------------------------------------- helpers

void _write(String path, img.Image image) {
  File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(img.encodePng(image));
}

/// Crops away fully transparent margins so the glyph fills its canvas.
img.Image _trimTransparent(img.Image src) {
  var minX = src.width, minY = src.height, maxX = -1, maxY = -1;
  for (var y = 0; y < src.height; y++) {
    for (var x = 0; x < src.width; x++) {
      if (src.getPixel(x, y).a > 12) {
        if (x < minX) minX = x;
        if (y < minY) minY = y;
        if (x > maxX) maxX = x;
        if (y > maxY) maxY = y;
      }
    }
  }
  if (maxX < 0) return src;
  return img.copyCrop(
    src,
    x: minX,
    y: minY,
    width: maxX - minX + 1,
    height: maxY - minY + 1,
  );
}

/// Maps source luminance onto the two brand ramps.
img.Image _recolour(img.Image src) {
  final out = img.Image.from(src);
  for (var y = 0; y < out.height; y++) {
    for (var x = 0; x < out.width; x++) {
      final p = out.getPixel(x, y);
      if (p.a <= 0) continue;
      final lum = (0.2126 * p.r + 0.7152 * p.g + 0.0722 * p.b) / 255.0;
      final isHighlight = lum >= _greenThreshold;
      final base = isHighlight ? _green : _teal;
      final light = isHighlight ? _greenLight : _tealLight;
      // Re-spread the local luminance across the ramp so the metal shading
      // survives the recolour instead of flattening to one tone.
      final t = isHighlight
          ? ((lum - _greenThreshold) / (1 - _greenThreshold)).clamp(0.0, 1.0)
          : (lum / _greenThreshold).clamp(0.0, 1.0);
      final eased = 0.25 + 0.75 * t;
      out.setPixelRgba(
        x,
        y,
        _lerp(base.r, light.r, eased),
        _lerp(base.g, light.g, eased),
        _lerp(base.b, light.b, eased),
        p.a.toInt(),
      );
    }
  }
  return out;
}

int _lerp(int a, int b, double t) => (a + (b - a) * t).round().clamp(0, 255);

/// Centres the glyph on a transparent square of [size], leaving a margin.
img.Image _square(img.Image src, int size, {double insetFactor = 0.86}) {
  final canvas = img.Image(width: size, height: size, numChannels: 4);
  img.fill(canvas, color: img.ColorRgba8(0, 0, 0, 0));

  final target = (size * insetFactor).round();
  final scale = math.min(target / src.width, target / src.height);
  final w = math.max(1, (src.width * scale).round());
  final h = math.max(1, (src.height * scale).round());
  final resized = img.copyResize(
    src,
    width: w,
    height: h,
    interpolation: img.Interpolation.cubic,
  );
  img.compositeImage(
    canvas,
    resized,
    dstX: ((size - w) / 2).round(),
    dstY: ((size - h) / 2).round(),
  );
  return canvas;
}

/// Opaque rounded plate behind the glyph for the legacy launcher icon.
img.Image _onPlate(img.Image glyph, int size) {
  final canvas = img.Image(width: size, height: size, numChannels: 4);
  img.fill(canvas, color: img.ColorRgba8(10, 13, 20, 255));
  img.compositeImage(canvas, glyph);
  return canvas;
}

img.Image _flatten(img.Image src) {
  final canvas = img.Image(width: src.width, height: src.height);
  img.fill(canvas, color: img.ColorRgb8(10, 13, 20));
  img.compositeImage(canvas, src);
  return canvas;
}

/// Solid white where the source is opaque - what Android needs for a status
/// bar icon.
img.Image _silhouette(img.Image src) {
  final out = img.Image.from(src);
  for (var y = 0; y < out.height; y++) {
    for (var x = 0; x < out.width; x++) {
      final p = out.getPixel(x, y);
      if (p.a <= 0) continue;
      // Drop near-transparent antialiasing so the silhouette stays crisp.
      final alpha = p.a < 40 ? 0 : p.a.toInt();
      out.setPixelRgba(x, y, 255, 255, 255, alpha);
    }
  }
  return out;
}

img.Image _monochrome(img.Image src) => _silhouette(src);

String _iosContents() => '''
{
  "images" : [
    {"size":"20x20","idiom":"iphone","filename":"Icon-App-40.png","scale":"2x"},
    {"size":"20x20","idiom":"iphone","filename":"Icon-App-60.png","scale":"3x"},
    {"size":"29x29","idiom":"iphone","filename":"Icon-App-58.png","scale":"2x"},
    {"size":"29x29","idiom":"iphone","filename":"Icon-App-87.png","scale":"3x"},
    {"size":"40x40","idiom":"iphone","filename":"Icon-App-80.png","scale":"2x"},
    {"size":"40x40","idiom":"iphone","filename":"Icon-App-120.png","scale":"3x"},
    {"size":"60x60","idiom":"iphone","filename":"Icon-App-120.png","scale":"2x"},
    {"size":"60x60","idiom":"iphone","filename":"Icon-App-180.png","scale":"3x"},
    {"size":"20x20","idiom":"ipad","filename":"Icon-App-20.png","scale":"1x"},
    {"size":"20x20","idiom":"ipad","filename":"Icon-App-40.png","scale":"2x"},
    {"size":"29x29","idiom":"ipad","filename":"Icon-App-29.png","scale":"1x"},
    {"size":"29x29","idiom":"ipad","filename":"Icon-App-58.png","scale":"2x"},
    {"size":"40x40","idiom":"ipad","filename":"Icon-App-40.png","scale":"1x"},
    {"size":"40x40","idiom":"ipad","filename":"Icon-App-80.png","scale":"2x"},
    {"size":"76x76","idiom":"ipad","filename":"Icon-App-76.png","scale":"1x"},
    {"size":"76x76","idiom":"ipad","filename":"Icon-App-152.png","scale":"2x"},
    {"size":"83.5x83.5","idiom":"ipad","filename":"Icon-App-167.png","scale":"2x"},
    {"size":"1024x1024","idiom":"ios-marketing","filename":"Icon-App-1024.png","scale":"1x"}
  ],
  "info" : {"version":1,"author":"xcode"}
}
''';
