// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Happy Days';

  @override
  String get appName => 'Happy Days';

  @override
  String get morningAlertTitle => 'Levante-se e conquiste';

  @override
  String get morningAlertBody => 'O arco não espera. Levante-se.';

  @override
  String get middayAlertTitle => 'Controle de combustível';

  @override
  String get middayAlertBody => 'Só água. Prato limpo. Mantenha o foco.';

  @override
  String get eveningWorkoutTitle => 'Mexa o corpo';

  @override
  String get eveningWorkoutBody =>
      'Academia ou 30 minutos de caminhada. Escolha um.';

  @override
  String get nightReviewTitle => 'Balanço da noite';

  @override
  String get nightReviewBody =>
      'Registre o dia e anote algo pelo qual é grato.';

  @override
  String get habitEarlyWake => 'Acordar cedo';

  @override
  String get habitWaterOnly => 'Só água';

  @override
  String get habitNoJunkFood => 'Sem comida lixo';

  @override
  String get habitSleepTarget => '7-8 horas de sono';

  @override
  String get habitGymWorkout => 'Academia 4-5 dias por semana';

  @override
  String get habitStepsGoal => '10 mil passos';

  @override
  String get habitNoPhoneMeals => 'Sem celular nas refeições';

  @override
  String get habitWalking => '30 minutos de caminhada';

  @override
  String get habitGratitude => 'Agradecer a Deus todos os dias';

  @override
  String get habitNoteProgress => 'Anote seu progresso';

  @override
  String get habitRead => 'Ler 20 páginas';

  @override
  String get habitMeditate => 'Meditar 10 minutos';

  @override
  String get habitColdShower => 'Banho frio';

  @override
  String get habitStretch => 'Alongar 10 minutos';

  @override
  String get habitNoSocialMedia => 'Sem redes sociais';

  @override
  String get habitDeepWork => '90 minutos de trabalho focado';

  @override
  String get habitJournal => 'Escrever no seu diário';

  @override
  String get habitLearnSkill => 'Pratique seu ofício';

  @override
  String get habitPlanTomorrow => 'Planeje amanhã hoje à noite';

  @override
  String get habitNoScreensBed => 'Sem telas antes de dormir';

  @override
  String get habitProtein => 'Atinja sua meta de proteína';

  @override
  String get habitVitamins => 'Tome suas vitaminas';

  @override
  String get habitFloss => 'Use fio dental';

  @override
  String get habitSunlight => '15 minutos de sol';

  @override
  String get habitCallFamily => 'Ligue para alguém que ama';

  @override
  String get habitActOfKindness => 'Um ato de bondade';

  @override
  String get habitTidySpace => 'Organize seu espaço';

  @override
  String get habitNoAlcohol => 'Sem álcool';

  @override
  String get habitBudgetCheck => 'Confira seu orçamento';

  @override
  String get habitPray => 'Oração ou reflexão';

  @override
  String get habitLanguage => 'Pratique um idioma';

  @override
  String get habitSideProject => 'Lance algo pequeno';

  @override
  String get statDiscipline => 'Disciplina';

  @override
  String get statVitality => 'Vitalidade';

  @override
  String get statStrength => 'Força';

  @override
  String get statFocus => 'Foco';

  @override
  String get statSpirit => 'Espírito';

  @override
  String get categoryBody => 'Corpo';

  @override
  String get categoryMind => 'Mente';

  @override
  String get categorySpirit => 'Espírito';

  @override
  String get categoryCraft => 'Ofício';

  @override
  String get categorySocial => 'Social';

  @override
  String get welcomeGreetingMorning => 'Bom dia';

  @override
  String get welcomeGreetingAfternoon => 'Boa tarde';

  @override
  String get welcomeGreetingEvening => 'Boa noite';

  @override
  String get welcomeTagline => 'Dias pequenos, bem empilhados.';

  @override
  String get welcomeGetStartedHint => 'Vamos configurar seu primeiro arco.';

  @override
  String get onboardingWelcome => 'Bem-vindo ao Happy Days';

  @override
  String get onboardingSubtitle =>
      'Construa os dias que você quer lembrar. Tudo fica no seu dispositivo.';

  @override
  String get enterFullName => 'Digite seu nome completo';

  @override
  String get enterNickname => 'Como devemos te chamar?';

  @override
  String get onboardingIdentityTitle => 'Quem está no comando deste arco?';

  @override
  String get onboardingArcTitle => 'Quanto tempo dura seu arco?';

  @override
  String get onboardingHabitsTitle => 'Escolha seus hábitos iniciais';

  @override
  String get onboardingHabitsSubtitle =>
      'Escolha quantos quiser. Você pode adicionar, editar ou arquivar depois.';

  @override
  String get onboardingThemeTitle => 'Escolha sua aparência';

  @override
  String get onboardingPermissionTitle => 'Mantenha-se no horário';

  @override
  String onboardingSelectedCount(int count) {
    return '$count selecionados';
  }

  @override
  String get arcLength90 => '90 dias';

  @override
  String get arcLength122 => '122 dias';

  @override
  String get arcLengthCustom => 'Personalizado';

  @override
  String get getStarted => 'Começar';

  @override
  String get next => 'Próximo';

  @override
  String get back => 'Voltar';

  @override
  String get skip => 'Pular';

  @override
  String dashboardGreeting(String nickname) {
    return 'Vamos conquistar hoje, $nickname';
  }

  @override
  String get dashboardTitle => 'Protocolo';

  @override
  String get todaysProtocol => 'Protocolo de hoje';

  @override
  String get characterSheet => 'Ficha de personagem';

  @override
  String get settingsThemeLight => 'Tema claro';

  @override
  String get settingsThemeDark => 'Tema escuro';

  @override
  String get settingsThemeSystem => 'Seguir sistema';

  @override
  String settingsProfileName(String fullName) {
    return 'Nome: $fullName';
  }

  @override
  String arcDayCounter(int current, int total) {
    return 'Dia $current de $total';
  }

  @override
  String arcNotStarted(int days) {
    return 'Seu arco começa em $days dias';
  }

  @override
  String streakCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sequência de $count dias',
      one: 'Sequência de 1 dia',
      zero: 'Ainda sem sequência',
    );
    return '$_temp0';
  }

  @override
  String shieldCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count escudos',
      one: '1 escudo',
      zero: 'Sem escudos',
    );
    return '$_temp0';
  }

  @override
  String shieldConsumed(int remaining) {
    return 'Um escudo absorveu a falha de ontem. Restam $remaining.';
  }

  @override
  String multiplierActive(String value) {
    return 'Multiplicador de XP ${value}x ativo';
  }

  @override
  String levelUpTitle(int level) {
    return 'Nível $level';
  }

  @override
  String rankUnlocked(String rankName) {
    return 'Rank desbloqueado: $rankName';
  }

  @override
  String get achievementUnlocked => 'Conquista desbloqueada';

  @override
  String bossWeekTitle(String name) {
    return 'Semana chefe: $name';
  }

  @override
  String bossWeekProgress(int completed, int required) {
    return '$completed de $required concluídos';
  }

  @override
  String get notScheduledToday => 'Não programado hoje';

  @override
  String backfillTitle(String date) {
    return 'Registro de $date';
  }

  @override
  String get backfillLate => 'Registrado com atraso';

  @override
  String get backfillWindowClosed =>
      'Este dia está fora da sua janela de registro';

  @override
  String metricEntryLabel(String value, String target, String unit) {
    return '$value de $target $unit';
  }

  @override
  String partialCredit(int percent) {
    return 'Crédito parcial: $percent%';
  }

  @override
  String xpEarned(int xp) {
    return '+$xp XP';
  }

  @override
  String xpToNextLevel(int current, int target) {
    return '$current / $target XP';
  }

  @override
  String todayComplete(int completed, int total) {
    return '$completed de $total feitos';
  }

  @override
  String get perfectDay => 'Dia impecável';

  @override
  String get matrixTitle => 'Matriz';

  @override
  String get matrixZoomWeek => 'Semana';

  @override
  String get matrixZoomMonth => 'Mês';

  @override
  String get matrixZoomArc => 'Arco';

  @override
  String get jumpToToday => 'Hoje';

  @override
  String get matrixLinearView => 'Visão em lista';

  @override
  String get matrixGridView => 'Visão em grade';

  @override
  String get filterAll => 'Todos';

  @override
  String get cellStateComplete => 'concluído';

  @override
  String get cellStatePartial => 'parcialmente concluído';

  @override
  String get cellStateIncomplete => 'não concluído';

  @override
  String get cellStateMissed => 'perdido';

  @override
  String get cellStateNotScheduled => 'não programado';

  @override
  String cellSemanticLabel(String habit, String date, String state) {
    return '$habit, $date, $state';
  }

  @override
  String habitCompletionRate(int percent) {
    return '$percent%';
  }

  @override
  String get analyticsTitle => 'Percepções';

  @override
  String analyticsBestDay(String weekday) {
    return 'Seu dia mais forte é $weekday';
  }

  @override
  String analyticsWeakestDay(String weekday) {
    return 'Você mais falha em $weekday';
  }

  @override
  String analyticsCorrelation(String habitA, String multiplier) {
    return 'Nos dias em que você completa $habitA, você completa ${multiplier}x mais hábitos no total';
  }

  @override
  String analyticsProjection(int percent) {
    return 'Nesse ritmo, você terminará o arco em $percent%';
  }

  @override
  String get analyticsNotEnoughData => 'Volte após 7 dias de registro';

  @override
  String get analyticsHeatmap => 'Mapa de contribuições';

  @override
  String get analyticsWeekly => 'Consistência semanal';

  @override
  String get analyticsStatProgression => 'Progressão de estatísticas';

  @override
  String get analyticsWeekday => 'Detalhamento por dia';

  @override
  String get analyticsCorrelationTitle => 'Correlações de hábitos';

  @override
  String get analyticsTimeOfDay => 'Quando você registra';

  @override
  String get analyticsProjectionTitle => 'Projeção do arco';

  @override
  String get analyticsNoCorrelations =>
      'Ainda sem correlações fortes. Continue registrando.';

  @override
  String get habitLibraryTitle => 'Biblioteca de hábitos';

  @override
  String get createCustomHabit => 'Crie o seu';

  @override
  String get editHabit => 'Editar hábito';

  @override
  String get habitFrequencyDaily => 'Todos os dias';

  @override
  String habitFrequencyWeekly(int count) {
    return '$count vezes por semana';
  }

  @override
  String get habitFrequencyCustom => 'Dias selecionados';

  @override
  String habitFrequencyInterval(int count) {
    return 'A cada $count dias';
  }

  @override
  String get archiveHabit => 'Arquivar hábito';

  @override
  String get archiveHabitWarning =>
      'Os registros passados são mantidos. Ele simplesmente não aparecerá em dias futuros.';

  @override
  String get unarchiveHabit => 'Restaurar hábito';

  @override
  String get activeHabits => 'Ativos';

  @override
  String get archivedHabits => 'Arquivados';

  @override
  String get habitTitleLabel => 'Nome do hábito';

  @override
  String get habitIconLabel => 'Ícone';

  @override
  String get habitCategoryLabel => 'Categoria';

  @override
  String get habitStatLabel => 'Estatística';

  @override
  String get habitXpLabel => 'Recompensa de XP';

  @override
  String get habitMetricLabel => 'Medido em';

  @override
  String get habitTargetLabel => 'Meta diária';

  @override
  String get habitReminderLabel => 'Lembrete';

  @override
  String get habitFrequencyLabel => 'Frequência';

  @override
  String get noReminder => 'Sem lembrete';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get confirm => 'Confirmar';

  @override
  String get emptyHabitsTitle => 'Ainda sem hábitos';

  @override
  String get emptyHabitsBody =>
      'Adicione alguns da biblioteca para começar seu arco.';

  @override
  String get unitBoolean => 'feito';

  @override
  String get unitSteps => 'passos';

  @override
  String get unitLiters => 'litros';

  @override
  String get unitMinutes => 'minutos';

  @override
  String get unitHours => 'horas';

  @override
  String get unitCount => 'vezes';

  @override
  String get journalTitle => 'Diário';

  @override
  String get journalSearchHint => 'Pesquisar suas entradas';

  @override
  String get journalMoodPrompt => 'Como foi hoje?';

  @override
  String get journalOnThisDay => 'Neste dia';

  @override
  String get journalGratitudeLabel => 'Algo pelo qual você é grato';

  @override
  String get journalNotesLabel => 'Como foi o dia?';

  @override
  String get journalTagsLabel => 'Tags';

  @override
  String get journalAddPhoto => 'Adicionar foto';

  @override
  String get journalSaved => 'Salvo';

  @override
  String get emptyJournalTitle => 'Nada escrito ainda';

  @override
  String get emptyJournalBody => 'Seus balanços vão se acumular aqui.';

  @override
  String get mood1 => 'Difícil';

  @override
  String get mood2 => 'Baixo';

  @override
  String get mood3 => 'Estável';

  @override
  String get mood4 => 'Bom';

  @override
  String get mood5 => 'Excelente';

  @override
  String get appLockTitle => 'Desbloqueie seu diário';

  @override
  String get appLockPinFallback => 'Usar PIN';

  @override
  String get appLockSetPin => 'Definir um PIN';

  @override
  String get appLockEnterPin => 'Digite seu PIN';

  @override
  String get appLockWrongPin => 'PIN incorreto';

  @override
  String get appLockUnlock => 'Desbloquear';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsDayRollover => 'O novo dia começa às';

  @override
  String settingsRetroWindow(int days) {
    return 'Permitir registro até $days dias atrás';
  }

  @override
  String get settingsHardcoreMode => 'Modo hardcore';

  @override
  String get settingsHardcoreModeDesc =>
      'Sem escudos, sem registro retroativo. O que você registra naquele dia é o que conta.';

  @override
  String get settingsPartialCredit => 'Crédito parcial';

  @override
  String get settingsPartialCreditDesc =>
      'Concede XP proporcional quando você não atinge uma meta numérica.';

  @override
  String get settingsReduceMotion => 'Reduzir movimento';

  @override
  String get settingsHighContrast => 'Alto contraste';

  @override
  String get settingsSound => 'Efeitos sonoros';

  @override
  String get settingsHaptics => 'Vibração';

  @override
  String get settingsBatteryWarning =>
      'Seu dispositivo pode interromper os lembretes. Toque para permitir atividade em segundo plano.';

  @override
  String get settingsSectionProfile => 'Perfil';

  @override
  String get settingsSectionAppearance => 'Aparência';

  @override
  String get settingsSectionReminders => 'Lembretes';

  @override
  String get settingsSectionArc => 'Regras do arco';

  @override
  String get settingsSectionAccessibility => 'Acessibilidade';

  @override
  String get settingsSectionPrivacy => 'Privacidade';

  @override
  String get settingsSectionData => 'Dados';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Padrão do sistema';

  @override
  String get settingsAppLock => 'Bloqueio do app';

  @override
  String get settingsAppLockScopeJournal => 'Somente diário';

  @override
  String get settingsAppLockScopeApp => 'App inteiro';

  @override
  String get settingsExactAlarms => 'Alarmes exatos';

  @override
  String get settingsExactAlarmsDesc =>
      'Necessários para lembretes de despertar precisos ao minuto.';

  @override
  String get settingsNotifications => 'Notificações';

  @override
  String get settingsReminderTimes => 'Horários dos lembretes';

  @override
  String get remindersStatusTitle => 'Status dos lembretes';

  @override
  String remindersHealthy(int count) {
    return '$count lembretes ativos';
  }

  @override
  String get remindersBlocked =>
      'As notificações estão bloqueadas para o Happy Days';

  @override
  String get remindersNoneArmed => 'Nenhum lembrete ativo';

  @override
  String get remindersExactOn => 'Alarmes exatos ativados';

  @override
  String get remindersExactOff =>
      'Alarmes inexatos - os horários podem variar alguns minutos';

  @override
  String remindersTimezone(String zone) {
    return 'Ancorado em $zone';
  }

  @override
  String get sendTestReminder => 'Enviar lembrete de teste';

  @override
  String get testReminderQueued =>
      'Lembrete de teste em 10 segundos - feche o app para conferir';

  @override
  String get testReminderFailed =>
      'Não foi possível agendar o lembrete de teste';

  @override
  String get testReminderTitle => 'Lembrete de teste';

  @override
  String get testReminderBody =>
      'Se você está vendo isso, seus lembretes estão funcionando.';

  @override
  String get remindersFixPermission => 'Ativar notificações';

  @override
  String get backgroundRefresh => 'Atualização em segundo plano';

  @override
  String get backgroundRefreshDesc =>
      'Mantém o widget e o backup diário atualizados com o app fechado.';

  @override
  String get backgroundRunNow => 'Executar agora';

  @override
  String get backgroundRanNow => 'Atualizado';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get profileSaved => 'Perfil atualizado';

  @override
  String get languageSearchHint => 'Pesquisar idiomas';

  @override
  String get languageIndian => 'Idiomas indianos';

  @override
  String get languageWorld => 'Mais idiomas';

  @override
  String get languageTranslated => 'Traduzido';

  @override
  String get languageFallbackNote =>
      'Idiomas sem tradução mostram o texto em inglês.';

  @override
  String get focusTitle => 'Foco';

  @override
  String get menuTitle => 'Menu';

  @override
  String get focusSubtitle => 'Cronômetro de concentração';

  @override
  String get focusSetDuration => 'Duração da sessão';

  @override
  String get focusStart => 'Iniciar';

  @override
  String get focusPause => 'Pausar';

  @override
  String get focusResume => 'Retomar';

  @override
  String get focusReset => 'Reiniciar';

  @override
  String get focusDone => 'Sessão concluída';

  @override
  String focusDoneBody(int minutes) {
    return '$minutes minutos de foco registrados.';
  }

  @override
  String get focusRunning => 'Foco em andamento';

  @override
  String focusTodayTotal(int minutes) {
    return '$minutes min hoje';
  }

  @override
  String focusSessions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessões',
      one: '1 sessão',
      zero: 'Ainda sem sessões',
    );
    return '$_temp0';
  }

  @override
  String get focusPickPreset => 'Seleção rápida';

  @override
  String focusMinutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get focusKeepScreenOn => 'Manter a tela ligada';

  @override
  String get focusAbandon => 'Descartar sessão?';

  @override
  String get focusAbandonBody => 'O progresso desta sessão não será salvo.';

  @override
  String get widgetPreviewTitle => 'Widgets da tela inicial';

  @override
  String get widgetPreviewSubtitle =>
      'Adicione-os pelo seletor de widgets da sua tela inicial.';

  @override
  String get widgetRingTitle => 'Anel de hábitos';

  @override
  String get widgetTimerTitle => 'Cronômetro de foco';

  @override
  String get widgetStreakTitle => 'Sequências';

  @override
  String get widgetTodayTitle => 'Hoje';

  @override
  String get widgetWaterTitle => 'Progresso';

  @override
  String insightsPartial(int logged, int needed) {
    return '$logged de $needed dias registrados';
  }

  @override
  String get insightsEarlyTitle => 'Suas percepções estão se formando';

  @override
  String get journalToday => 'Entrada de hoje';

  @override
  String get journalPast => 'Entradas anteriores';

  @override
  String get journalEdit => 'Editar';

  @override
  String get journalDelete => 'Apagar entrada';

  @override
  String get journalUnsaved => 'Alterações não salvas';

  @override
  String get backupTitle => 'Backup e restauração';

  @override
  String backupLast(String timestamp) {
    return 'Último backup: $timestamp';
  }

  @override
  String get backupNever => 'Ainda sem backup';

  @override
  String get backupEncrypt => 'Proteger com uma frase secreta';

  @override
  String get backupExportJson => 'Exportar JSON';

  @override
  String get backupExportCsv => 'Exportar CSV';

  @override
  String get backupRestore => 'Restaurar de backup';

  @override
  String get restoreConfirm =>
      'Substituir todos os dados atuais por este backup?';

  @override
  String get restoreVersionMismatch =>
      'Este backup é de uma versão mais nova do app';

  @override
  String get restoreChecksumFailed =>
      'Este arquivo está corrompido ou foi modificado';

  @override
  String get restoreMerge => 'Mesclar';

  @override
  String get restoreReplace => 'Substituir';

  @override
  String restoreDryRun(int days, int habits, int journals) {
    return '$days dias, $habits hábitos, $journals entradas de diário';
  }

  @override
  String get restoreSuccess => 'Restaurado';

  @override
  String get passphrasePrompt => 'Digite a frase secreta';

  @override
  String get trophyHallTitle => 'Salão de troféus';

  @override
  String get trophyLocked => 'Bloqueado';

  @override
  String trophyUnlockedOn(String date) {
    return 'Desbloqueado em $date';
  }

  @override
  String get emptyTrophyTitle => 'Ainda sem troféus';

  @override
  String get emptyTrophyBody =>
      'Complete seu primeiro hábito para abrir o salão.';

  @override
  String achievementProgress(int current, int target) {
    return '$current / $target';
  }

  @override
  String get arcCompleteTitle => 'Arco concluído';

  @override
  String arcCompleteSubtitle(int days) {
    return '$days dias. Veja o que você construiu.';
  }

  @override
  String get startNewArc => 'Começar um novo arco';

  @override
  String get carryHabits => 'Manter meus hábitos';

  @override
  String get carryStats => 'Manter minhas estatísticas';

  @override
  String get shareCard => 'Compartilhar';

  @override
  String get recapTotalXp => 'XP total';

  @override
  String get recapBestStreak => 'Melhor sequência';

  @override
  String get recapCompletionRate => 'Conclusão';

  @override
  String get recapPerfectDays => 'Dias perfeitos';

  @override
  String get recapDay1 => 'Dia 1';

  @override
  String get recapFinal => 'Final';

  @override
  String get arcHistoryTitle => 'Arcos anteriores';

  @override
  String get permissionNotificationRationale =>
      'O Happy Days precisa de notificações para te lembrar. Nada sai do seu dispositivo.';

  @override
  String get permissionExactAlarmRationale =>
      'Alarmes exatos mantêm seu despertar das 5:30 pontual.';

  @override
  String get permissionActivityRationale =>
      'A contagem de passos lê o contador de passos embutido do seu dispositivo. Nenhuma localização é usada.';

  @override
  String get permissionAllow => 'Permitir';

  @override
  String get permissionNotNow => 'Agora não';

  @override
  String get permissionOpenSettings => 'Abrir configurações';

  @override
  String get errorGeneric => 'Algo deu errado';

  @override
  String get undo => 'Desfazer';

  @override
  String get close => 'Fechar';

  @override
  String get done => 'Concluído';

  @override
  String get loading => 'Carregando';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get achievementNamePrefix => 'Conquista';

  @override
  String get achFirstBlood => 'Primeiro Sangue';

  @override
  String get achFirstBloodDesc => 'Complete seu primeiro hábito';

  @override
  String get achPerfectDay => 'Impecável';

  @override
  String get achPerfectDayDesc =>
      'Complete todos os hábitos programados em um dia';

  @override
  String get achStreak3 => 'Ignição';

  @override
  String get achStreak3Desc => 'Sequência de 3 dias';

  @override
  String get achStreak7 => 'Primeira semana';

  @override
  String get achStreak7Desc => 'Sequência de 7 dias';

  @override
  String get achStreak14 => 'Quinzena';

  @override
  String get achStreak14Desc => 'Sequência de 14 dias';

  @override
  String get achStreak30 => 'Hábito formado';

  @override
  String get achStreak30Desc => 'Sequência de 30 dias';

  @override
  String get achStreak60 => 'Inabalável';

  @override
  String get achStreak60Desc => 'Sequência de 60 dias';

  @override
  String get achStreak100 => 'Centenário';

  @override
  String get achStreak100Desc => 'Sequência de 100 dias';

  @override
  String get achPerfectArc => 'O arco completo';

  @override
  String get achPerfectArcDesc =>
      'Complete todo o arco sem nenhuma falha desprotegida';

  @override
  String get achTenPerfectDays => 'Dois dígitos';

  @override
  String get achTenPerfectDaysDesc => '10 dias perfeitos no total';

  @override
  String get achEarlyRiser30 => 'Patrulha do amanhecer';

  @override
  String get achEarlyRiser30Desc => '30 despertares matinais registrados';

  @override
  String get achGym50 => 'Contrato de ferro';

  @override
  String get achGym50Desc => '50 sessões de academia registradas';

  @override
  String get achSteps500k => 'Meio milhão';

  @override
  String get achSteps500kDesc => '500.000 passos acumulados';

  @override
  String get achGratitude100 => 'Coração grato';

  @override
  String get achGratitude100Desc => '100 entradas de gratidão';

  @override
  String get achClean30 => 'Motor limpo';

  @override
  String get achClean30Desc => '30 dias sem comida lixo';

  @override
  String get achHydrated60 => 'Só água';

  @override
  String get achHydrated60Desc => '60 dias só com água';

  @override
  String get achLevel10 => 'Iniciado da geada';

  @override
  String get achLevel10Desc => 'Alcance o nível 10';

  @override
  String get achLevel25 => 'Asceta de ferro';

  @override
  String get achLevel25Desc => 'Alcance o nível 25';

  @override
  String get achLevel50 => 'Soberano do inverno';

  @override
  String get achLevel50Desc => 'Alcance o nível 50';

  @override
  String get achBalanced => 'Equilibrado';

  @override
  String get achBalancedDesc =>
      'As cinco estatísticas acima de 50 ao mesmo tempo';

  @override
  String get achPhoenix => 'Protocolo Fênix';

  @override
  String get achPhoenixDesc =>
      'Volte após um dia perdido e complete 7 seguidos';

  @override
  String get achNoShields30 => 'Sem escudos';

  @override
  String get achNoShields30Desc => '30 dias consecutivos sem consumir escudos';

  @override
  String get achFirstBackup => 'Seguro';

  @override
  String get achFirstBackupDesc => 'Crie seu primeiro backup';

  @override
  String get achArchitect => 'Arquiteto';

  @override
  String get achArchitectDesc => 'Crie seu primeiro hábito personalizado';

  @override
  String get rankEmberSpark => 'Faísca de brasa';

  @override
  String get rankFrostInitiate => 'Iniciado da geada';

  @override
  String get rankIronAscetic => 'Asceta de ferro';

  @override
  String get rankStormWarden => 'Guardião da tempestade';

  @override
  String get rankArcChampion => 'Campeão do arco';

  @override
  String get rankWinterSovereign => 'Soberano do inverno';

  @override
  String get bossWeekBanner => 'Semana chefe ativa';

  @override
  String bossWeekReward(int xp) {
    return '+$xp XP ao concluir';
  }

  @override
  String get notifActionWakeDone => 'Marcar despertar como feito';

  @override
  String get notifActionSnooze => 'Soneca de 15 min';

  @override
  String get notifActionLogWorkout => 'Registrar treino';

  @override
  String get notifActionRestDay => 'Dia de descanso';

  @override
  String get notifActionOpenDebrief => 'Abrir balanço';

  @override
  String get notifActionQuickGratitude => 'Gratidão rápida';

  @override
  String radarSemanticSummary(String summary) {
    return 'Radar de estatísticas. $summary';
  }

  @override
  String statScoreLabel(String stat, int score) {
    return '$stat: $score de 100';
  }

  @override
  String get tabularFallback => 'Ver como tabela';
}
