// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Happy Days';

  @override
  String get appName => 'Happy Days';

  @override
  String get morningAlertTitle => '起床，去征服';

  @override
  String get morningAlertBody => '征程不会等你。起床吧。';

  @override
  String get middayAlertTitle => '补给检查';

  @override
  String get middayAlertBody => '只喝水。盘子吃干净。保持专注。';

  @override
  String get eveningWorkoutTitle => '动起来';

  @override
  String get eveningWorkoutBody => '健身房或散步30分钟，任选一项。';

  @override
  String get nightReviewTitle => '夜间复盘';

  @override
  String get nightReviewBody => '记录今天，并写下一件你感恩的事。';

  @override
  String get habitEarlyWake => '早起';

  @override
  String get habitWaterOnly => '只喝水';

  @override
  String get habitNoJunkFood => '不吃垃圾食品';

  @override
  String get habitSleepTarget => '睡眠7-8小时';

  @override
  String get habitGymWorkout => '每周健身4-5天';

  @override
  String get habitStepsGoal => '1万步';

  @override
  String get habitNoPhoneMeals => '吃饭不看手机';

  @override
  String get habitWalking => '步行30分钟';

  @override
  String get habitGratitude => '每天感恩神';

  @override
  String get habitNoteProgress => '记录你的进展';

  @override
  String get habitRead => '阅读20页';

  @override
  String get habitMeditate => '冥想10分钟';

  @override
  String get habitColdShower => '冷水澡';

  @override
  String get habitStretch => '拉伸10分钟';

  @override
  String get habitNoSocialMedia => '不刷社交媒体';

  @override
  String get habitDeepWork => '90分钟深度工作';

  @override
  String get habitJournal => '写日记';

  @override
  String get habitLearnSkill => '练习你的技艺';

  @override
  String get habitPlanTomorrow => '今晚规划明天';

  @override
  String get habitNoScreensBed => '睡前不看屏幕';

  @override
  String get habitProtein => '达到蛋白质目标';

  @override
  String get habitVitamins => '服用维生素';

  @override
  String get habitFloss => '使用牙线';

  @override
  String get habitSunlight => '晒太阳15分钟';

  @override
  String get habitCallFamily => '给你爱的人打电话';

  @override
  String get habitActOfKindness => '做一件善事';

  @override
  String get habitTidySpace => '整理你的空间';

  @override
  String get habitNoAlcohol => '不喝酒';

  @override
  String get habitBudgetCheck => '检查你的预算';

  @override
  String get habitPray => '祷告或反思';

  @override
  String get habitLanguage => '练习一门语言';

  @override
  String get habitSideProject => '发布一个小项目';

  @override
  String get statDiscipline => '自律';

  @override
  String get statVitality => '活力';

  @override
  String get statStrength => '力量';

  @override
  String get statFocus => '专注';

  @override
  String get statSpirit => '精神';

  @override
  String get categoryBody => '身体';

  @override
  String get categoryMind => '心智';

  @override
  String get categorySpirit => '精神';

  @override
  String get categoryCraft => '技艺';

  @override
  String get categorySocial => '社交';

  @override
  String get welcomeGreetingMorning => '早上好';

  @override
  String get welcomeGreetingAfternoon => '下午好';

  @override
  String get welcomeGreetingEvening => '晚上好';

  @override
  String get welcomeTagline => '小小的日子，好好地累积。';

  @override
  String get welcomeGetStartedHint => '让我们设置你的第一个征程。';

  @override
  String get onboardingWelcome => '欢迎使用 Happy Days';

  @override
  String get onboardingSubtitle => '建立你想记住的日子。一切都保留在你的设备上。';

  @override
  String get enterFullName => '输入你的全名';

  @override
  String get enterNickname => '我们该怎么称呼你？';

  @override
  String get onboardingIdentityTitle => '谁在主导这段征程？';

  @override
  String get onboardingArcTitle => '你的征程持续多久？';

  @override
  String get onboardingHabitsTitle => '选择你的初始习惯';

  @override
  String get onboardingHabitsSubtitle => '想选多少都可以。以后可以随时添加、编辑或归档。';

  @override
  String get onboardingThemeTitle => '选择你的外观';

  @override
  String get onboardingPermissionTitle => '保持按时进行';

  @override
  String onboardingSelectedCount(int count) {
    return '已选择$count项';
  }

  @override
  String get arcLength90 => '90天';

  @override
  String get arcLength122 => '122天';

  @override
  String get arcLengthCustom => '自定义';

  @override
  String get getStarted => '开始';

  @override
  String get next => '下一步';

  @override
  String get back => '返回';

  @override
  String get skip => '跳过';

  @override
  String dashboardGreeting(String nickname) {
    return '今天一起去征服吧，$nickname';
  }

  @override
  String get dashboardTitle => '协议';

  @override
  String get todaysProtocol => '今日协议';

  @override
  String get characterSheet => '角色卡';

  @override
  String get settingsThemeLight => '浅色主题';

  @override
  String get settingsThemeDark => '深色主题';

  @override
  String get settingsThemeSystem => '跟随系统';

  @override
  String settingsProfileName(String fullName) {
    return '姓名：$fullName';
  }

  @override
  String arcDayCounter(int current, int total) {
    return '第$current天，共$total天';
  }

  @override
  String arcNotStarted(int days) {
    return '你的征程将在$days天后开始';
  }

  @override
  String streakCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '连续$count天',
      one: '连续1天',
      zero: '还没有连续记录',
    );
    return '$_temp0';
  }

  @override
  String shieldCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count个护盾',
      one: '1个护盾',
      zero: '没有护盾',
    );
    return '$_temp0';
  }

  @override
  String shieldConsumed(int remaining) {
    return '一个护盾抵消了昨天的失误，剩余$remaining个。';
  }

  @override
  String multiplierActive(String value) {
    return '$value倍经验值倍数生效中';
  }

  @override
  String levelUpTitle(int level) {
    return '等级$level';
  }

  @override
  String rankUnlocked(String rankName) {
    return '解锁段位：$rankName';
  }

  @override
  String get achievementUnlocked => '解锁成就';

  @override
  String bossWeekTitle(String name) {
    return '首领周：$name';
  }

  @override
  String bossWeekProgress(int completed, int required) {
    return '已完成$completed/$required';
  }

  @override
  String get notScheduledToday => '今天未安排';

  @override
  String backfillTitle(String date) {
    return '$date的记录';
  }

  @override
  String get backfillLate => '延迟记录';

  @override
  String get backfillWindowClosed => '这一天已超出你的补记窗口';

  @override
  String metricEntryLabel(String value, String target, String unit) {
    return '$value / $target $unit';
  }

  @override
  String partialCredit(int percent) {
    return '部分完成：$percent%';
  }

  @override
  String xpEarned(int xp) {
    return '+$xp 经验';
  }

  @override
  String xpToNextLevel(int current, int target) {
    return '$current / $target 经验';
  }

  @override
  String todayComplete(int completed, int total) {
    return '已完成$completed/$total';
  }

  @override
  String get perfectDay => '完美的一天';

  @override
  String get matrixTitle => '矩阵';

  @override
  String get matrixZoomWeek => '周';

  @override
  String get matrixZoomMonth => '月';

  @override
  String get matrixZoomArc => '征程';

  @override
  String get jumpToToday => '今天';

  @override
  String get matrixLinearView => '列表视图';

  @override
  String get matrixGridView => '网格视图';

  @override
  String get filterAll => '全部';

  @override
  String get cellStateComplete => '已完成';

  @override
  String get cellStatePartial => '部分完成';

  @override
  String get cellStateIncomplete => '未完成';

  @override
  String get cellStateMissed => '已错过';

  @override
  String get cellStateNotScheduled => '未安排';

  @override
  String cellSemanticLabel(String habit, String date, String state) {
    return '$habit, $date, $state';
  }

  @override
  String habitCompletionRate(int percent) {
    return '$percent%';
  }

  @override
  String get analyticsTitle => '洞察';

  @override
  String analyticsBestDay(String weekday) {
    return '你表现最强的一天是$weekday';
  }

  @override
  String analyticsWeakestDay(String weekday) {
    return '你最常错过的是$weekday';
  }

  @override
  String analyticsCorrelation(String habitA, String multiplier) {
    return '在你完成$habitA的日子里，你总体完成的习惯多$multiplier倍';
  }

  @override
  String analyticsProjection(int percent) {
    return '按此速度，你将以$percent%完成征程';
  }

  @override
  String get analyticsNotEnoughData => '记录7天后再回来看看';

  @override
  String get analyticsHeatmap => '贡献热力图';

  @override
  String get analyticsWeekly => '每周一致性';

  @override
  String get analyticsStatProgression => '属性进展';

  @override
  String get analyticsWeekday => '按星期分类';

  @override
  String get analyticsCorrelationTitle => '习惯相关性';

  @override
  String get analyticsTimeOfDay => '你的记录时间';

  @override
  String get analyticsProjectionTitle => '征程预测';

  @override
  String get analyticsNoCorrelations => '尚无明显相关性，继续记录吧。';

  @override
  String get habitLibraryTitle => '习惯库';

  @override
  String get createCustomHabit => '创建你自己的习惯';

  @override
  String get editHabit => '编辑习惯';

  @override
  String get habitFrequencyDaily => '每天';

  @override
  String habitFrequencyWeekly(int count) {
    return '每周$count次';
  }

  @override
  String get habitFrequencyCustom => '指定日期';

  @override
  String habitFrequencyInterval(int count) {
    return '每$count天一次';
  }

  @override
  String get archiveHabit => '归档习惯';

  @override
  String get archiveHabitWarning => '过去的记录会保留，只是不会再出现在未来的日子里。';

  @override
  String get unarchiveHabit => '恢复习惯';

  @override
  String get activeHabits => '进行中';

  @override
  String get archivedHabits => '已归档';

  @override
  String get habitTitleLabel => '习惯名称';

  @override
  String get habitIconLabel => '图标';

  @override
  String get habitCategoryLabel => '类别';

  @override
  String get habitStatLabel => '属性';

  @override
  String get habitXpLabel => '经验奖励';

  @override
  String get habitMetricLabel => '计量单位';

  @override
  String get habitTargetLabel => '每日目标';

  @override
  String get habitReminderLabel => '提醒';

  @override
  String get habitFrequencyLabel => '频率';

  @override
  String get noReminder => '无提醒';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get confirm => '确认';

  @override
  String get emptyHabitsTitle => '还没有习惯';

  @override
  String get emptyHabitsBody => '从习惯库中添加一些，开始你的征程。';

  @override
  String get unitBoolean => '已完成';

  @override
  String get unitSteps => '步';

  @override
  String get unitLiters => '升';

  @override
  String get unitMinutes => '分钟';

  @override
  String get unitHours => '小时';

  @override
  String get unitCount => '次';

  @override
  String get journalTitle => '日记';

  @override
  String get journalSearchHint => '搜索你的记录';

  @override
  String get journalMoodPrompt => '今天过得怎么样？';

  @override
  String get journalOnThisDay => '在这一天';

  @override
  String get journalGratitudeLabel => '一件你感恩的事';

  @override
  String get journalNotesLabel => '今天过得如何？';

  @override
  String get journalTagsLabel => '标签';

  @override
  String get journalAddPhoto => '添加照片';

  @override
  String get journalSaved => '已保存';

  @override
  String get emptyJournalTitle => '还没有写下任何内容';

  @override
  String get emptyJournalBody => '你的复盘将在这里累积。';

  @override
  String get mood1 => '艰难';

  @override
  String get mood2 => '低落';

  @override
  String get mood3 => '平稳';

  @override
  String get mood4 => '不错';

  @override
  String get mood5 => '极好';

  @override
  String get appLockTitle => '解锁你的日记';

  @override
  String get appLockPinFallback => '改用PIN码';

  @override
  String get appLockSetPin => '设置PIN码';

  @override
  String get appLockEnterPin => '输入你的PIN码';

  @override
  String get appLockWrongPin => 'PIN码错误';

  @override
  String get appLockUnlock => '解锁';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsDayRollover => '新一天从此时开始';

  @override
  String settingsRetroWindow(int days) {
    return '允许补记最多$days天前';
  }

  @override
  String get settingsHardcoreMode => '硬核模式';

  @override
  String get settingsHardcoreModeDesc => '没有护盾，不能补记。当天记录的才算数。';

  @override
  String get settingsPartialCredit => '部分完成计分';

  @override
  String get settingsPartialCreditDesc => '未达到数值目标时按比例给予经验值。';

  @override
  String get settingsReduceMotion => '减少动效';

  @override
  String get settingsHighContrast => '高对比度';

  @override
  String get settingsSound => '音效';

  @override
  String get settingsHaptics => '震动反馈';

  @override
  String get settingsBatteryWarning => '你的设备可能会停止提醒。点击以允许后台活动。';

  @override
  String get settingsSectionProfile => '个人资料';

  @override
  String get settingsSectionAppearance => '外观';

  @override
  String get settingsSectionReminders => '提醒';

  @override
  String get settingsSectionArc => '征程规则';

  @override
  String get settingsSectionAccessibility => '无障碍';

  @override
  String get settingsSectionPrivacy => '隐私';

  @override
  String get settingsSectionData => '数据';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageSystem => '系统默认';

  @override
  String get settingsAppLock => '应用锁';

  @override
  String get settingsAppLockScopeJournal => '仅日记';

  @override
  String get settingsAppLockScopeApp => '整个应用';

  @override
  String get settingsExactAlarms => '精确闹钟';

  @override
  String get settingsExactAlarmsDesc => '精确到分钟的起床提醒需要此权限。';

  @override
  String get settingsNotifications => '通知';

  @override
  String get settingsReminderTimes => '提醒时间';

  @override
  String get remindersStatusTitle => '提醒状态';

  @override
  String remindersHealthy(int count) {
    return '已启用$count个提醒';
  }

  @override
  String get remindersBlocked => 'Happy Days的通知已被阻止';

  @override
  String get remindersNoneArmed => '没有已启用的提醒';

  @override
  String get remindersExactOn => '精确闹钟已开启';

  @override
  String get remindersExactOff => '闹钟不精确 - 时间可能会偏差几分钟';

  @override
  String remindersTimezone(String zone) {
    return '锚定于$zone';
  }

  @override
  String get sendTestReminder => '发送测试提醒';

  @override
  String get testReminderQueued => '测试提醒将在10秒后发送 - 关闭应用查看';

  @override
  String get testReminderFailed => '无法安排测试提醒';

  @override
  String get testReminderTitle => '测试提醒';

  @override
  String get testReminderBody => '如果你看到这条消息，说明你的提醒正常工作。';

  @override
  String get remindersFixPermission => '开启通知';

  @override
  String get backgroundRefresh => '后台刷新';

  @override
  String get backgroundRefreshDesc => '在应用关闭时保持小组件和每日备份为最新状态。';

  @override
  String get backgroundRunNow => '立即运行';

  @override
  String get backgroundRanNow => '已刷新';

  @override
  String get editProfile => '编辑资料';

  @override
  String get profileSaved => '资料已更新';

  @override
  String get languageSearchHint => '搜索语言';

  @override
  String get languageIndian => '印度语言';

  @override
  String get languageWorld => '更多语言';

  @override
  String get languageTranslated => '已翻译';

  @override
  String get languageFallbackNote => '没有翻译的语言将显示英文文本。';

  @override
  String get focusTitle => '专注';

  @override
  String get menuTitle => '菜单';

  @override
  String get focusSubtitle => '专注计时器';

  @override
  String get focusSetDuration => '会话时长';

  @override
  String get focusStart => '开始';

  @override
  String get focusPause => '暂停';

  @override
  String get focusResume => '继续';

  @override
  String get focusReset => '重置';

  @override
  String get focusDone => '会话完成';

  @override
  String focusDoneBody(int minutes) {
    return '已记录$minutes分钟的专注时间。';
  }

  @override
  String get focusRunning => '专注进行中';

  @override
  String focusTodayTotal(int minutes) {
    return '今天$minutes分钟';
  }

  @override
  String focusSessions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count个会话',
      one: '1个会话',
      zero: '还没有会话',
    );
    return '$_temp0';
  }

  @override
  String get focusPickPreset => '快速选择';

  @override
  String focusMinutesShort(int minutes) {
    return '$minutes分钟';
  }

  @override
  String get focusKeepScreenOn => '保持屏幕常亮';

  @override
  String get focusAbandon => '放弃此会话？';

  @override
  String get focusAbandonBody => '此会话的进度将不会被保存。';

  @override
  String get widgetPreviewTitle => '主屏幕小组件';

  @override
  String get widgetPreviewSubtitle => '从你主屏幕的小组件选择器中添加这些。';

  @override
  String get widgetRingTitle => '习惯环';

  @override
  String get widgetTimerTitle => '专注计时器';

  @override
  String get widgetStreakTitle => '连续记录';

  @override
  String get widgetTodayTitle => '今天';

  @override
  String get widgetWaterTitle => '进度';

  @override
  String insightsPartial(int logged, int needed) {
    return '已记录$needed天中的$logged天';
  }

  @override
  String get insightsEarlyTitle => '你的洞察正在生成中';

  @override
  String get journalToday => '今日记录';

  @override
  String get journalPast => '以往记录';

  @override
  String get journalEdit => '编辑';

  @override
  String get journalDelete => '清除记录';

  @override
  String get journalUnsaved => '未保存的更改';

  @override
  String get backupTitle => '备份与恢复';

  @override
  String backupLast(String timestamp) {
    return '上次备份：$timestamp';
  }

  @override
  String get backupNever => '尚无备份';

  @override
  String get backupEncrypt => '用密码保护';

  @override
  String get backupExportJson => '导出JSON';

  @override
  String get backupExportCsv => '导出CSV';

  @override
  String get backupRestore => '从备份恢复';

  @override
  String get restoreConfirm => '用此备份替换所有当前数据？';

  @override
  String get restoreVersionMismatch => '此备份来自更新版本的应用';

  @override
  String get restoreChecksumFailed => '此文件已损坏或被修改';

  @override
  String get restoreMerge => '合并';

  @override
  String get restoreReplace => '替换';

  @override
  String restoreDryRun(int days, int habits, int journals) {
    return '$days天，$habits个习惯，$journals条日记';
  }

  @override
  String get restoreSuccess => '已恢复';

  @override
  String get passphrasePrompt => '输入密码';

  @override
  String get trophyHallTitle => '荣誉殿堂';

  @override
  String get trophyLocked => '已锁定';

  @override
  String trophyUnlockedOn(String date) {
    return '于$date解锁';
  }

  @override
  String get emptyTrophyTitle => '还没有奖杯';

  @override
  String get emptyTrophyBody => '完成你的第一个习惯以开启殿堂。';

  @override
  String achievementProgress(int current, int target) {
    return '$current / $target';
  }

  @override
  String get arcCompleteTitle => '征程完成';

  @override
  String arcCompleteSubtitle(int days) {
    return '$days天。这是你建立的成果。';
  }

  @override
  String get startNewArc => '开始新征程';

  @override
  String get carryHabits => '延续我的习惯';

  @override
  String get carryStats => '保留我的属性';

  @override
  String get shareCard => '分享';

  @override
  String get recapTotalXp => '总经验值';

  @override
  String get recapBestStreak => '最佳连续记录';

  @override
  String get recapCompletionRate => '完成率';

  @override
  String get recapPerfectDays => '完美天数';

  @override
  String get recapDay1 => '第1天';

  @override
  String get recapFinal => '最终';

  @override
  String get arcHistoryTitle => '过往征程';

  @override
  String get permissionNotificationRationale =>
      'Happy Days需要通知权限来提醒你。任何信息都不会离开你的设备。';

  @override
  String get permissionExactAlarmRationale => '精确闹钟能让你5:30的起床提醒准时响起。';

  @override
  String get permissionActivityRationale => '步数追踪读取你设备内置的计步器，不使用任何位置信息。';

  @override
  String get permissionAllow => '允许';

  @override
  String get permissionNotNow => '暂不';

  @override
  String get permissionOpenSettings => '打开设置';

  @override
  String get errorGeneric => '出错了';

  @override
  String get undo => '撤销';

  @override
  String get close => '关闭';

  @override
  String get done => '完成';

  @override
  String get loading => '加载中';

  @override
  String get retry => '重试';

  @override
  String get achievementNamePrefix => '成就';

  @override
  String get achFirstBlood => '首战告捷';

  @override
  String get achFirstBloodDesc => '完成你的第一个习惯';

  @override
  String get achPerfectDay => '无懈可击';

  @override
  String get achPerfectDayDesc => '在一天内完成所有安排的习惯';

  @override
  String get achStreak3 => '点火';

  @override
  String get achStreak3Desc => '连续3天';

  @override
  String get achStreak7 => '第一周达成';

  @override
  String get achStreak7Desc => '连续7天';

  @override
  String get achStreak14 => '两周';

  @override
  String get achStreak14Desc => '连续14天';

  @override
  String get achStreak30 => '习惯已养成';

  @override
  String get achStreak30Desc => '连续30天';

  @override
  String get achStreak60 => '坚不可摧';

  @override
  String get achStreak60Desc => '连续60天';

  @override
  String get achStreak100 => '百日';

  @override
  String get achStreak100Desc => '连续100天';

  @override
  String get achPerfectArc => '完整征程';

  @override
  String get achPerfectArcDesc => '完成整个征程，没有一次未受保护的失误';

  @override
  String get achTenPerfectDays => '两位数';

  @override
  String get achTenPerfectDaysDesc => '共10个完美天';

  @override
  String get achEarlyRiser30 => '晨曦巡逻';

  @override
  String get achEarlyRiser30Desc => '记录了30次早起';

  @override
  String get achGym50 => '钢铁契约';

  @override
  String get achGym50Desc => '记录了50次健身训练';

  @override
  String get achSteps500k => '五十万';

  @override
  String get achSteps500kDesc => '累计50万步';

  @override
  String get achGratitude100 => '感恩之心';

  @override
  String get achGratitude100Desc => '100条感恩记录';

  @override
  String get achClean30 => '清洁引擎';

  @override
  String get achClean30Desc => '30天不吃垃圾食品';

  @override
  String get achHydrated60 => '只喝水';

  @override
  String get achHydrated60Desc => '60天只喝水';

  @override
  String get achLevel10 => '霜之新兵';

  @override
  String get achLevel10Desc => '达到等级10';

  @override
  String get achLevel25 => '钢铁苦行者';

  @override
  String get achLevel25Desc => '达到等级25';

  @override
  String get achLevel50 => '冬日统治者';

  @override
  String get achLevel50Desc => '达到等级50';

  @override
  String get achBalanced => '全面发展';

  @override
  String get achBalancedDesc => '五项属性同时超过50';

  @override
  String get achPhoenix => '凤凰协议';

  @override
  String get achPhoenixDesc => '错过一天后回归，并连续完成7天';

  @override
  String get achNoShields30 => '赤手空拳';

  @override
  String get achNoShields30Desc => '连续30天未使用任何护盾';

  @override
  String get achFirstBackup => '保险';

  @override
  String get achFirstBackupDesc => '创建你的第一份备份';

  @override
  String get achArchitect => '建筑师';

  @override
  String get achArchitectDesc => '创建你的第一个自定义习惯';

  @override
  String get rankEmberSpark => '余烬火花';

  @override
  String get rankFrostInitiate => '霜之新兵';

  @override
  String get rankIronAscetic => '钢铁苦行者';

  @override
  String get rankStormWarden => '风暴守护者';

  @override
  String get rankArcChampion => '征程冠军';

  @override
  String get rankWinterSovereign => '冬日统治者';

  @override
  String get bossWeekBanner => '首领周进行中';

  @override
  String bossWeekReward(int xp) {
    return '完成后+$xp经验';
  }

  @override
  String get notifActionWakeDone => '标记起床已完成';

  @override
  String get notifActionSnooze => '推迟15分钟';

  @override
  String get notifActionLogWorkout => '记录训练';

  @override
  String get notifActionRestDay => '休息日';

  @override
  String get notifActionOpenDebrief => '打开复盘';

  @override
  String get notifActionQuickGratitude => '快速感恩';

  @override
  String radarSemanticSummary(String summary) {
    return '属性雷达图。$summary';
  }

  @override
  String statScoreLabel(String stat, int score) {
    return '$stat：$score/100';
  }

  @override
  String get tabularFallback => '以表格查看';
}
