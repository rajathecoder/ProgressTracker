import 'package:isar_community/isar.dart';

import '../models/arc.dart';

class ArcRepository {
  ArcRepository(this._isar);
  final Isar _isar;

  Stream<List<Arc>> watchAll() =>
      _isar.arcs.where().watch(fireImmediately: true).map(_sorted);

  Future<List<Arc>> all() async => _sorted(await _isar.arcs.where().findAll());

  Future<Arc?> byId(int id) => _isar.arcs.get(id);

  Future<Arc?> active() =>
      _isar.arcs.filter().statusEqualTo(ArcStatus.active).findFirst();

  Future<int> save(Arc arc) => _isar.writeTxn(() => _isar.arcs.put(arc));

  Future<void> deleteAll() =>
      _isar.writeTxn(() => _isar.arcs.where().deleteAll());

  static List<Arc> _sorted(List<Arc> arcs) {
    final list = List<Arc>.from(arcs);
    list.sort((a, b) => b.startDate.compareTo(a.startDate));
    return list;
  }
}
