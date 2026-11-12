// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kinyarwanda (`rw`).
class AppLocalizationsRw extends AppLocalizations {
  AppLocalizationsRw([String locale = 'rw']) : super(locale);

  @override
  String get appName => 'Donzela';

  @override
  String get langRw => 'Ikinyarwanda';

  @override
  String get langEn => 'English';

  @override
  String get langFr => 'Français';

  @override
  String get chooseLanguage => 'Hitamo ururimi';

  @override
  String get welcomeTitle => 'Menya umubiri wawe';

  @override
  String get welcomeBody =>
      'Inshuti igufasha gukurikirana ukwezi kwawe, yakorewe buri mugore wo mu Rwanda.';

  @override
  String get dataStaysNote => 'Amakuru yawe aguma muri telefoni yawe';

  @override
  String get continueBtn => 'Komeza';

  @override
  String get backBtn => 'Subira inyuma';

  @override
  String get skipBtn => 'Simbuka';

  @override
  String stepOf(int current, int total) {
    return '$current kuri $total';
  }

  @override
  String get privacyTitle => 'Umubiri wawe, amakuru yawe';

  @override
  String get privacySubtitle => 'Amakuru yawe ni ayawe. Dore isezerano ryacu.';

  @override
  String get privacy1Title => 'Aguma muri telefoni yawe';

  @override
  String get privacy1Body =>
      'Ibyo wanditse ku kwezi kwawe bibikwa muri iyi telefoni, ntibijya kuri seriveri zacu.';

  @override
  String get privacy2Title => 'Kubika kopi ni wowe uhitamo';

  @override
  String get privacy2Body =>
      'Ushobora kubifungura nyuma mu Igenamiterere. Mu ntangiriro birafunze.';

  @override
  String get privacy3Title => 'Ntazigera agurishwa';

  @override
  String get privacy3Body =>
      'Ntituzigera tugurisha amakuru y\'ubuzima bwawe. Ushobora gusiba byose igihe cyose.';

  @override
  String get agreeContinue => 'Ndemeye, komeza';

  @override
  String get readPolicy => 'Soma politiki y\'ibanga';

  @override
  String get policyTitle => 'Politiki y\'ibanga';

  @override
  String get policyBody =>
      'Donzela ibika amakuru y\'ukwezi kwawe muri telefoni yawe gusa.\n\nNta makuru y\'ubuzima yoherezwa mu bikoresho by\'isesengura (analytics) cyangwa mu magambo y\'amakosa.\n\nKubika kopi kuri interineti birafunze kugeza ubifunguye. Iyo ubifunguye, amakuru yoherezwa ku mugaragaro ku kwemerera kwawe, kandi ushobora kuyasiba igihe cyose.\n\nUshobora gusiba amakuru yose igihe cyose mu Igenamiterere.';

  @override
  String get lastPeriodTitle => 'Imihango yawe iheruka yatangiye ryari?';

  @override
  String get lastPeriodBody =>
      'Bifasha Donzela kugereranya igihe imihango yawe itaha izazira. Ushobora kubihindura igihe cyose.';

  @override
  String get sinibuka => 'Sinibuka';

  @override
  String get sinibukaNote =>
      'Igereranya rito: itariki ni iminsi 14 uvuye none.';

  @override
  String get cycleLengthTitle => 'Ukwezi kwawe kumara iminsi ingahe?';

  @override
  String get cycleLengthBody =>
      'Ukwezi gutangira ku munsi wa mbere w\'imihango kugeza ku munsi ubanziriza imihango ikurikira. Ntubizi neza? Siga imibare isanzwe; Donzela izagenda yiga uko wandika.';

  @override
  String get cycleLengthLabel => 'Uburebure bw\'umuzunguruko';

  @override
  String get periodLengthLabel => 'Iminsi y\'imihango';

  @override
  String get daysUnit => 'iminsi';

  @override
  String get cycleRangeNote =>
      'Ukwezi kwinshi kumara hagati y\'iminsi 21 na 35';

  @override
  String get pinSetupTitle => 'Rinda ibanga rya Donzela';

  @override
  String get pinSetupBody =>
      'Bifasha niba usangira telefoni n\'abandi. Ushobora kubihindura nyuma mu Igenamiterere.';

  @override
  String get pinToggle => 'Funga ukoresheje PIN y\'imibare 4';

  @override
  String get pinHint => 'Hitamo PIN itari itariki y\'amavuko yawe.';

  @override
  String get remindersTitle => 'Ibyibutsa';

  @override
  String get reminderPeriod => 'Imihango iri hafi';

  @override
  String get reminderFertile => 'Iminsi y\'uburumbuke';

  @override
  String get reminderPill => 'Ikinini cya buri munsi';

  @override
  String get reminderNote =>
      'Ubutumwa ntibugaragaza ibisobanuro: buvuga gusa ngo \"Icyibutsa cya Donzela\".';

  @override
  String get startApp => 'Tangira gukoresha Donzela';

  @override
  String get pinEnterTitle => 'Andika PIN yawe';

  @override
  String get pinNewTitle => 'Shyiraho PIN nshya';

  @override
  String get pinConfirmTitle => 'Ongera wandike PIN';

  @override
  String get pinWrong => 'PIN si yo. Gerageza nanone.';

  @override
  String pinLockedFor(int seconds) {
    return 'Gerageza nyuma y\'amasegonda $seconds';
  }

  @override
  String get forgotPin => 'Wibagiwe PIN?';

  @override
  String get resetPinTitle => 'Wibagiwe PIN?';

  @override
  String get resetPinBody =>
      'Ushobora gusiba amakuru yose kuri telefoni. Niba kopi yo kuri interineti iriho, ushobora kuyisubizaho.';

  @override
  String get deleteBtn => 'Siba';

  @override
  String get cancelBtn => 'Hagarika';

  @override
  String get confirmBtn => 'Emeza';

  @override
  String get yes => 'Yego';

  @override
  String get no => 'Oya';

  @override
  String get saveBtn => 'Bika';

  @override
  String get greetingMorning => 'Mwaramutse';

  @override
  String get greetingAfternoon => 'Mwiriwe';

  @override
  String get onWeekday => 'Ku wa';

  @override
  String get todayCycleDay => 'Umunsi w\'ukwezi';

  @override
  String get phasePeriod => 'Imihango';

  @override
  String get phaseFertile => 'Iminsi y\'uburumbuke';

  @override
  String get phaseOvulation => 'Irekurwa ry\'intanga';

  @override
  String get phaseNormal => 'Ibisanzwe';

  @override
  String get phasePredictedPeriod => 'Imihango iteganyijwe';

  @override
  String nextPeriodIn(int days, String date) {
    return 'Imihango itaha mu minsi $days · ahagana $date';
  }

  @override
  String nextPeriodLate(String date) {
    return 'Imihango iratinze · yari iteganyijwe $date';
  }

  @override
  String get estimateChip => 'Igereranya';

  @override
  String get firstEstimate => 'Igereranya rya mbere';

  @override
  String get getStartedTitle => 'Tangira';

  @override
  String get checkOnboarding => 'Wujuje kwiyandikisha';

  @override
  String get checkFirstCycle => 'Itariki y\'imihango iheruka yanditswe';

  @override
  String get checkPrediction => 'Igereranya ryatangiye';

  @override
  String get checkLogToday => 'Wanditse uyu munsi';

  @override
  String get firstUseBody =>
      'Andika imihango yawe 2 itaha, Donzela imenye uko umubiri wawe ugenda.';

  @override
  String get upcomingNotice => 'Ibiteganywa bizagenda binonoka';

  @override
  String get estimatesOnly =>
      'Ibiteganyijwe ni igereranya gusa, ntibigamije kuboneza urubyaro.';

  @override
  String get tipTitle => 'Inama y\'uyu munsi';

  @override
  String get tipPeriod =>
      'Shyushya amazi cyangwa ushyire umufuka w\'ubushyuhe ku nda ushobora kugabanya uburibwe. Ruhuka igihe ukeneye.';

  @override
  String get tipFollicular =>
      'Mu minsi ibanza y\'ukwezi ushobora kumva ufite imbaraga. Ni igihe cyiza cyo gukora imyitozo yoroheje.';

  @override
  String get tipFertile =>
      'Mu minsi y\'uburumbuke ushobora kumva ufite imbaraga nyinshi kandi ukabona ururenda rworoshye rurambuka. Ibyo ni ibisanzwe.';

  @override
  String get tipLuteal =>
      'Ushobora kumva unaniwe cyangwa ufite impungenge. Kunywa amazi no kuruhuka bifasha.';

  @override
  String get readMore => 'Soma birambuye';

  @override
  String get todayTitle => 'Uyu munsi';

  @override
  String get calendarTab => 'Kalendari';

  @override
  String get learnTab => 'Iga';

  @override
  String get helpTab => 'Ubufasha';

  @override
  String get calendarTitle => 'Kalendari';

  @override
  String get legendPeriod => 'Imihango';

  @override
  String get legendPredicted => 'Iteganyijwe';

  @override
  String get legendFertile => 'Uburumbuke';

  @override
  String get legendOvulation => 'Irekurwa ry\'intanga';

  @override
  String get historyTitle => 'Amateka y\'ukwezi';

  @override
  String get avgCycle => 'Ukwezi, ku kigereranyo';

  @override
  String get avgPeriod => 'Imihango, ku kigereranyo';

  @override
  String daysCount(int n) {
    return '$n iminsi';
  }

  @override
  String get reportBtn => 'Raporo y\'umuganga';

  @override
  String get confLow => 'Igereranya rito';

  @override
  String get confMedium => 'Igereranya ryo hagati';

  @override
  String get confHigh => 'Igereranya rihamye';

  @override
  String get flagIrregular =>
      'Ukwezi kwawe guhindagurika. Soma inyandiko ku mihango ihindagurika.';

  @override
  String get flagLate => 'Imihango iratinze kurenza iminsi 7.';

  @override
  String get monthPrev => 'Ukwezi kubanza';

  @override
  String get monthNext => 'Ukwezi gutaha';

  @override
  String get dayStartQ => 'Imihango yawe yatangiye uyu munsi?';

  @override
  String get periodStartHere => 'Tangira imihango hano';

  @override
  String get periodEndHere => 'Imihango irangiriye hano';

  @override
  String get periodEnded => 'Imihango yarangiye';

  @override
  String get logSheetTitle => 'Andika uyu munsi';

  @override
  String get flowTitle => 'Ingano y\'amaraso';

  @override
  String get flowNone => 'Nta yo';

  @override
  String get flowSpotting => 'Make';

  @override
  String get flowMedium => 'Hagati';

  @override
  String get flowHeavy => 'Menshi';

  @override
  String get symptomsTitle => 'Ibimenyetso';

  @override
  String get moodTitle => 'Uko wiyumva';

  @override
  String get notesTitle => 'Inyandiko';

  @override
  String get notesHint => 'Hari ikindi wifuza kwandika?';

  @override
  String get symptomCramps => 'Kuribwa mu nda';

  @override
  String get symptomHeadache => 'Kubabara umutwe';

  @override
  String get symptomBackache => 'Kubabara umugongo';

  @override
  String get symptomBloating => 'Kubyimba inda';

  @override
  String get symptomAcne => 'Ibiheri';

  @override
  String get symptomBreast => 'Amabere aryana';

  @override
  String get symptomFatigue => 'Umunaniro';

  @override
  String get moodCalm => 'Ntuje';

  @override
  String get moodHappy => 'Nishimye';

  @override
  String get moodSad => 'Mbabaye';

  @override
  String get moodIrritable => 'Ndarakara vuba';

  @override
  String get moodAnxious => 'Mfite impungenge';

  @override
  String get reportTitle => 'Raporo yo kwereka umuganga';

  @override
  String get reportSummary => 'Incamake y\'ukwezi';

  @override
  String get reportCycleCol => 'Ukwezi (iminsi)';

  @override
  String get reportPeriodCol => 'Imihango (iminsi)';

  @override
  String get reportLast => 'Iheruka';

  @override
  String get reportStartCol => 'Itangiriro';

  @override
  String get reportLengthCol => 'Uburebure';

  @override
  String get reportPeriodLenCol => 'Imihango';

  @override
  String get reportSymptoms => 'Ibimenyetso byanditswe kenshi';

  @override
  String get reportFooter =>
      'Byakozwe na Donzela. Ni igereranya gusa, si isuzuma rya muganga.';

  @override
  String get reportNoData => 'Nta mihango irandikwa irahari.';

  @override
  String get sharePdf => 'Sangiza nka PDF';

  @override
  String get showOnPhone => 'Erekana kuri telefoni';

  @override
  String get learnTitle => 'Iga';

  @override
  String get learnSubtitle => 'Buri nyandiko isuzumwa n\'umuganga';

  @override
  String get searchHint => 'urugero: uburibwe bw\'imihango';

  @override
  String get filterAll => 'Byose';

  @override
  String get filterMine => 'Ukwezi kwawe';

  @override
  String get filterHygiene => 'Isuku mu mihango';

  @override
  String get filterContraception => 'Kuboneza urubyaro';

  @override
  String reviewedBy(String name, String date) {
    return 'Byasuzumwe na $name, $date';
  }

  @override
  String get noArticles => 'Nta nyandiko zisuzumwe zirahari ubu.';

  @override
  String get saveArticle => 'Bika inyandiko';

  @override
  String get savedArticle => 'Yabitswe';

  @override
  String get helpTitle => 'Shaka ubufasha';

  @override
  String get helpSubtitle =>
      'Serivisi z\'ubuntu kandi zibika ibanga, hafi yawe';

  @override
  String get emergencyTitle => 'Ubufasha bwihutirwa';

  @override
  String get isangeCentre => 'Isange One Stop Centre';

  @override
  String get ambulance => 'Imbangukiragutabara (SAMU)';

  @override
  String get yourDistrict => 'Akarere kawe';

  @override
  String get centresNone =>
      'Ibigo nderabuzima by\'aka karere ntibirashyirwamo ubu.';

  @override
  String get callBtn => 'Hamagara';

  @override
  String get settingsTitle => 'Igenamiterere';

  @override
  String get sectionPrefs => 'IBYIFUZO';

  @override
  String get sectionPrivacy => 'IBANGA';

  @override
  String get languageSetting => 'Ururimi';

  @override
  String get pinSetting => 'Gufunga na PIN';

  @override
  String get changePin => 'Hindura PIN';

  @override
  String get analyticsSetting => 'Imibare y\'ikoreshwa';

  @override
  String get analyticsNote =>
      'Imibare idafite amakuru y\'ubuzima, yo gufasha Donzela gutera imbere. Ushobora kuyifunga.';

  @override
  String get backupSetting => 'Kubika kopi kuri interineti';

  @override
  String get backupNote =>
      'Amakuru y\'ukwezi kwawe abikwa muri iyi telefoni gusa. Fungura kubika kopi kugira ngo atazabura nuhindura telefoni.';

  @override
  String get backupExplain =>
      'Kubika kopi bizohereza ku murongo amakuru y\'ukwezi kwawe. Turabanza tukubaze uburenganzira.';

  @override
  String get backupConsentBtn => 'Ndemeye';

  @override
  String get backupUnavailable =>
      'Kubika kopi ntibiraboneka kuri iyi verisiyo.';

  @override
  String get deleteAllBtn => 'Siba amakuru yanjye yose';

  @override
  String get deleteAllTitle => 'Siba amakuru yose?';

  @override
  String get deleteAllBody =>
      'Ibi bizasiba amakuru yose kuri telefoni n\'ayo kuri interineti. Ntibisubira inyuma.';

  @override
  String get privacyPolicyLink => 'Politiki y\'ibanga';

  @override
  String get firstNameLabel => 'Izina ryawe (ntibiba ngombwa)';

  @override
  String get setPinBtn => 'Shyiraho PIN';

  @override
  String get remindersOff => 'Ibyibutsa bizimije';

  @override
  String get reminderPeriodText => 'Ibyibutsa by\'imihango';

  @override
  String get notifTitle => 'Icyibutsa cya Donzela';

  @override
  String get notifBody => 'Fungura Donzela urebe';

  @override
  String get pillTimeLabel => 'Igihe cy\'ikinini';

  @override
  String get genericError => 'Habaye ikibazo. Gerageza nanone.';

  @override
  String get deleteDone => 'Amakuru yasibwe.';

  @override
  String get m1 => 'Mutarama';

  @override
  String get m2 => 'Gashyantare';

  @override
  String get m3 => 'Werurwe';

  @override
  String get m4 => 'Mata';

  @override
  String get m5 => 'Gicurasi';

  @override
  String get m6 => 'Kamena';

  @override
  String get m7 => 'Nyakanga';

  @override
  String get m8 => 'Kanama';

  @override
  String get m9 => 'Nzeri';

  @override
  String get m10 => 'Ukwakira';

  @override
  String get m11 => 'Ugushyingo';

  @override
  String get m12 => 'Ukuboza';

  @override
  String get w1 => 'Mb';

  @override
  String get w2 => 'Kb';

  @override
  String get w3 => 'Gt';

  @override
  String get w4 => 'Kn';

  @override
  String get w5 => 'Gn';

  @override
  String get w6 => 'Gd';

  @override
  String get w7 => 'Cy';

  @override
  String get d1 => 'mbere';

  @override
  String get d2 => 'kabiri';

  @override
  String get d3 => 'gatatu';

  @override
  String get d4 => 'kane';

  @override
  String get d5 => 'gatanu';

  @override
  String get d6 => 'gatandatu';

  @override
  String get d7 => 'cyumweru';

  @override
  String get appFooter => 'Donzela 1.0 · Yakozwe i Kigali';

  @override
  String get logToday => 'Andika uyu munsi';

  @override
  String get draftBadge => 'Inyandiko y\'igerageza, ntirasuzumwa';

  @override
  String get logsTitle => 'Ibyo nanditse';

  @override
  String get logsOpenBtn => 'Ibyo nanditse';

  @override
  String get tabLogs => 'Ibyanditswe';

  @override
  String get tabInsights => 'Imibare';

  @override
  String get noLogs => 'Nta munsi wanditse urabona hano.';

  @override
  String get logDeleteTitle => 'Siba iyi nyandiko?';

  @override
  String get logDeleteBody =>
      'Ibyanditswe kuri uyu munsi bizasibwa. Ntibisubira inyuma.';

  @override
  String insightsDaysLogged(int n) {
    return 'Iminsi wanditse: $n';
  }

  @override
  String insightsCyclesTracked(int n) {
    return 'Imizunguruko yanditswe: $n';
  }

  @override
  String insightsCycleRange(int min, int max) {
    return 'Uburebure bw\'ukwezi: iminsi $min–$max';
  }

  @override
  String get insightsSymptoms => 'Ibimenyetso bikunze kugaragara';

  @override
  String get insightsMoods => 'Uko wiyumvaga cyane';

  @override
  String get insightsFlow => 'Ingano y\'amaraso mu mihango';

  @override
  String get insightsByPhase => 'Ukurikije icyiciro cy\'ukwezi';

  @override
  String insightsCountOf(int count, int total) {
    return '$count mu minsi $total';
  }

  @override
  String get insightsNoData => 'Andika iminsi mike kugira ngo ubone imibare.';

  @override
  String get insightsDisclaimer =>
      'Iyi mibare ni iy\'ibyo wanditse gusa, si isuzuma rya muganga.';

  @override
  String get noteEmpty => 'Nta nyandiko';

  @override
  String get authSignIn => 'Injira ukoresheje Google';

  @override
  String get authSignOut => 'Sohoka';

  @override
  String authSignedInAs(String email) {
    return 'Winjiriye nka $email';
  }

  @override
  String get authSignInFailed => 'Kwinjira ntibyakunze. Gerageza nanone.';

  @override
  String get cloudUnavailable => 'Kopi ntiraboneka ubu. Gerageza nyuma.';

  @override
  String get restoreHint =>
      'Usanzwe ukoresha Donzela? Injira ugarure amakuru yawe.';

  @override
  String get restoreFound => 'Amakuru yawe yagaruwe.';

  @override
  String get restoreNone =>
      'Nta makuru yabitswe kuri iyi konti. Komeza wiyandikishe.';

  @override
  String get backupStarted => 'Kopi yatangiye. Amakuru yoherezwa uko ahinduka.';

  @override
  String get legendToday => 'Uyu munsi';

  @override
  String get centreNextPeriodLabel => 'Imihango mu';

  @override
  String get centreDaysUnit => 'iminsi';

  @override
  String get centreLate => 'Imihango yatinze';

  @override
  String fertileWindowLine(String from, String to) {
    return 'Iminsi y\'uburumbuke: $from – $to';
  }

  @override
  String todayLoggedLine(String items) {
    return 'Wanditse uyu munsi: $items';
  }

  @override
  String get insightsShortcut => 'Reba imibare yawe';

  @override
  String get entryTimeLabel => 'Igihe';

  @override
  String get editEntryTitle => 'Hindura ibyanditswe';

  @override
  String get entriesToday => 'Ibyanditswe uyu munsi';

  @override
  String get filterByDate => 'Shakisha ukurikije itariki';

  @override
  String get clearFilter => 'Siba akayunguro';

  @override
  String get addEntryBtn => 'Ongeraho';

  @override
  String get noEntriesOnDay => 'Nta munsi wanditse uyu munsi.';

  @override
  String get goToday => 'Uyu munsi';

  @override
  String get regularCycles => 'Ukwezi guhoraho';

  @override
  String get irregularCycles => 'Ukwezi guhindagurika';

  @override
  String get navAccount => 'Konti';

  @override
  String get accountTitle => 'Konti';

  @override
  String get accountSignedOutBody =>
      'Injira ukoresheje Google kugira ngo ubike kopi y\'amakuru yawe, uyasangize hagati ya telefoni, kandi uyagarure igihe ukeneye.';

  @override
  String get accountBackupOff =>
      'Kopi ntiriho. Amakuru yawe abikwa kuri telefoni gusa.';

  @override
  String get accountBackupOn => 'Kopi iriho. Amakuru yoherezwa uko ahinduka.';

  @override
  String accountLastSync(String when) {
    return 'Byasangijwe bwa nyuma: $when';
  }

  @override
  String get accountNeverSynced => 'Ntibirasangizwa na rimwe';

  @override
  String accountPending(int n) {
    return 'Bitarasangizwa: $n';
  }

  @override
  String get accountSyncNow => 'Ohereza amakuru';

  @override
  String get accountSyncDone => 'Byasangijwe.';

  @override
  String get accountPull => 'Kurura amakuru mashya';

  @override
  String get accountPullBody =>
      'Zana amakuru yawe, ibyanditswe, uburyo wakoresheje n\'amakuru mashya ku bigo nderabuzima n\'inyandiko. Ubikora wowe ubwawe.';

  @override
  String accountPulled(int n) {
    return 'Byagarutse: $n';
  }

  @override
  String get accountNothingNew => 'Nta kintu gishya.';

  @override
  String get accountTurnOnBackup => 'Ohereza amakuru mu bubiko';

  @override
  String get accountBusy => 'Biragenda...';

  @override
  String get adminBadge => 'Umuyobozi mukuru';

  @override
  String get adminOnlyBadgeBody =>
      'Uri umuyobozi mukuru: ushobora kongeramo, guhindura no gusiba inyandiko za Learn n\'ibyo muri Help.';

  @override
  String get adminAddArticle => 'Ongeraho inyandiko';

  @override
  String get adminEditArticle => 'Hindura inyandiko';

  @override
  String get adminDeleteBody => 'Iyi nyandiko izasibwa ku bantu bose.';

  @override
  String get fieldTitle => 'Umutwe';

  @override
  String get fieldBody => 'Inyandiko yuzuye';

  @override
  String get fieldCategory => 'Icyiciro';

  @override
  String get fieldLanguage => 'Ururimi';

  @override
  String get fieldReviewer => 'Yasuzumwe na (ubirangiza iyo ari byiza)';

  @override
  String get adminEditHelp => 'Hindura nimero z\'ihutirwa';

  @override
  String get fieldIsangeNumber => 'Nimero ya Isange One Stop Centre';

  @override
  String get fieldAmbulanceNumber => 'Nimero y\'imbangukiragutabara';

  @override
  String get adminAddCentre => 'Ongeraho ikigo nderabuzima';

  @override
  String get adminEditCentre => 'Hindura ikigo nderabuzima';

  @override
  String get fieldDistrict => 'Akarere';

  @override
  String get fieldSector => 'Umurenge';

  @override
  String get fieldName => 'Izina';

  @override
  String get fieldPhone => 'Telefoni';

  @override
  String get fieldServices => 'Serivisi';

  @override
  String get adminSaved => 'Byabitswe.';

  @override
  String get adminRequired => 'Uzuza umutwe n\'inyandiko.';

  @override
  String accountProgress(int percent) {
    return 'Bigeze kuri $percent%';
  }

  @override
  String get backupNotOnTitle => 'Backup ntiyafunguwe';

  @override
  String get backupNotOnBody =>
      'Backup ntiyafunguwe kuko kwinjira muri Google bitarangiye. Ongera ugerageze.';

  @override
  String get backupRetryBtn => 'Ongera ugerageze';

  @override
  String get okBtn => 'Sawa';

  @override
  String get adminSavedLocal =>
      'Byabitswe kuri telefone. Bizajya kuri cloud igihe uri kuri internet.';

  @override
  String get newDistrictNote =>
      'Akarere gashya. Kazongerwa ku rutonde igihe ubitse.';

  @override
  String get districtPickNote => 'Hitamo akarere cyangwa wandike irindi.';

  @override
  String get categoryHint => 'Hitamo icyiciro cyangwa wandike gishya.';

  @override
  String get editTab => 'Andika';

  @override
  String get previewTab => 'Reba uko bigaragara';

  @override
  String get previewEmpty => 'Nta nyandiko irimo.';

  @override
  String get boldTip => 'Mugari';

  @override
  String get italicTip => 'Iyegamiye';

  @override
  String get headingTip => 'Umutwe';

  @override
  String get listTip => 'Urutonde';

  @override
  String get quoteTip => 'Interuro';

  @override
  String get linkTip => 'Ihuza';

  @override
  String get emergencyManage => 'Nimero z\'ihutirwa';

  @override
  String get emergencyAdd => 'Ongeraho nimero';

  @override
  String get emergencyEdit => 'Hindura nimero';

  @override
  String get emergencyNone => 'Nta nimero z\'ihutirwa zirahari.';

  @override
  String get translationsTitle => 'Izindi ndimi';

  @override
  String get statusPublished => 'Yasohotse';

  @override
  String get statusDraft => 'Yanditswe';

  @override
  String get statusMissing => 'Ntiyanditswe';

  @override
  String get translateNow => 'Hindura';

  @override
  String get translateArticle => 'Hindura iyi nyandiko';

  @override
  String get saveDraftBtn => 'Bika nk\'igitabo';

  @override
  String get publishAllBtn => 'Sohora mu ndimi zose';

  @override
  String get publishedAll => 'Yasohotse mu ndimi zose.';

  @override
  String get publishNotReady => 'Ntibishobora gusohoka';

  @override
  String get reviewerLabel => 'Uwasuzumye (ururimi rwa none)';

  @override
  String get reviewerHint => 'Ntugire icyo wandika: ni Donzela Team.';

  @override
  String writtenBy(String name) {
    return 'Yanditswe na $name';
  }

  @override
  String get accountPullPublicBody =>
      'Fata amakuru mashya ku ngingo z\'ubufasha no ku nyandiko';

  @override
  String get accountContentUpdated =>
      'Amakuru mashya y\'inyandiko n\'ubufasha yamaze kuzanwa.';

  @override
  String get adminUsersTitle => 'Abayobozi';

  @override
  String get adminUsersBody =>
      'Abayobozi bashobora guhindura Learn na Help. Umuntu ahabwa ubu burenganzira igihe wanditse imeri ye hano.';

  @override
  String get adminUsersEmailLabel => 'Imeri ya Google';

  @override
  String get adminUsersEmailHint => 'Urugero: izina@gmail.com';

  @override
  String get adminUsersAdd => 'Ongeraho umuyobozi';

  @override
  String get adminUsersListTitle => 'Abafite uburenganzira';

  @override
  String get adminUsersNone => 'Nta bandi bayobozi bongeweho.';

  @override
  String get adminUsersRemove => 'Kuramo umuyobozi';

  @override
  String get adminUsersRemoveTitle => 'Kuramo uyu muyobozi?';

  @override
  String get adminUsersInvalid => 'Andika imeri nyayo';

  @override
  String get adminUsersOwner =>
      'Iyi ni imeri ya nyirubwite, ntishobora gukurwaho';

  @override
  String get adminUsersRoleOwner => 'Nyir\'urugo';

  @override
  String get adminUsersRoleAdmin => 'Umuyobozi';

  @override
  String get adminUsersRoleUser => 'Umunyamuryango';

  @override
  String get adminUsersMakeAdmin => 'Shyira umuyobozi';

  @override
  String accountWelcome(String name) {
    return 'Murakaza neza, $name';
  }

  @override
  String createdOn(String date) {
    return 'Yatangiwe $date';
  }

  @override
  String publishedOn(String date) {
    return 'Yasohotse $date';
  }

  @override
  String updatedOn(String date) {
    return 'Yavuguruwe $date';
  }

  @override
  String get onboardingPullContent => 'Kuramo inyandiko n\'ubufasha bya none';

  @override
  String get contentPullFailed =>
      'Ntibyakunze kuramo amakuru. Reba internet yawe.';

  @override
  String get lastPeriodOptional =>
      'Ushobora kubisiga none cyangwa ukabyongera nyuma kuri kalendari.';

  @override
  String get refreshContent => 'Kuvugurura inyandiko n\'ubufasha';

  @override
  String get accountSyncNowBody =>
      'Ibyo wanditse bisigara kuri telefone yawe. Kanda hano ubu bioherezwa kuri konte yawe ya Google, kandi igihe byarangiriye kirandikwa.';

  @override
  String get accountSyncOffBody =>
      'Kugira ngo ibyo ukora byoherezwe kuri konte yawe, banza ushyireho backup muri Igenamiterere.';

  @override
  String get healthTitle => 'Ibikoresho by\'ubuzima';

  @override
  String get healthSubtitle =>
      'Ibipimo bigereranya ukurikije amatariki wanditse. Bihinduka uko uyahindura.';

  @override
  String get healthSectionCycle => 'Imihango';

  @override
  String get healthSectionPregnancy => 'Gutwita';

  @override
  String get healthDisclaimer =>
      'Ibi ni ibipimo bigereranya, ntabwo ari inama z\'ubuvuzi. Baza umuganga ku byerekeye ubuzima bwawe.';

  @override
  String get toolNextPeriodTitle => 'Imihango itaha';

  @override
  String get toolNextPeriodBody =>
      'Igihe imihango yawe itaha ishobora gutangira, ukurikije uburebure bw\'umuzunguruko wawe.';

  @override
  String get toolFertileTitle => 'Iminsi yo gusama';

  @override
  String get toolFertileBody =>
      'Iminsi gutwita bishoboka, n\'igihe intanga ishobora gusohoka.';

  @override
  String get toolImplantTitle => 'Igihe cyo gushinga inda';

  @override
  String get toolImplantBody =>
      'Igihe intanga ishobora gushingwa mu nda nyuma yo gusohoka kw\'intanga.';

  @override
  String get toolCycleLengthTitle => 'Uburebure bw\'umuzunguruko';

  @override
  String get toolCycleLengthBody =>
      'Bara iminsi hagati y\'itangiriro ry\'imihango ebyiri.';

  @override
  String get toolDueDateTitle => 'Itariki yo kubyara';

  @override
  String get toolDueDateBody =>
      'Itariki igereranyijwe yo kubyara, ibarwa uhereye ku itangiriro ry\'imihango yawe ya nyuma.';

  @override
  String get toolWeeksTitle => 'Ibyumweru mu mezi';

  @override
  String get toolWeeksBody =>
      'Hindura ibyumweru byo gutwita mu mezi n\'ibyumweru.';

  @override
  String get healthLastPeriod => 'Itangiriro ry\'imihango ya nyuma';

  @override
  String get healthUsualCycle => 'Uburebure bw\'umuzunguruko usanzwe';

  @override
  String get healthPreviousPeriod => 'Itangiriro ry\'imihango yabanje';

  @override
  String get healthNextPeriodStart => 'Itangiriro ry\'imihango ikurikira';

  @override
  String get healthWeeksPregnant => 'Ibyumweru umaze utwite';

  @override
  String get healthWeeksUnit => 'ibyumweru';

  @override
  String get healthResultNextPeriod => 'Imihango itaha izaza hafi';

  @override
  String get healthResultOvulation => 'Intanga izasohoka hafi';

  @override
  String get healthResultFertile => 'Iminsi yo gusama';

  @override
  String get healthResultImplant => 'Gushinga inda bishobora kuba hagati ya';

  @override
  String get healthResultCycleLength => 'Uburebure bw\'umuzunguruko';

  @override
  String get healthResultDue => 'Itariki igereranyijwe yo kubyara';

  @override
  String get healthResultAge => 'Umaze utwite';

  @override
  String get healthResultMonths => 'Bingana na';

  @override
  String get healthCycleOut =>
      'Umuzunguruko usanzwe ufata iminsi 21 kugeza 45. Reba amatariki yombi.';

  @override
  String get healthTo => 'kugeza';

  @override
  String get healthLess => 'Gabanya';

  @override
  String get healthMore => 'Ongera';

  @override
  String healthDays(int n) {
    return '$n iminsi';
  }

  @override
  String healthWeekDays(int weeks, int days) {
    return 'ibyumweru $weeks n\'iminsi $days';
  }

  @override
  String healthMonthsWeeks(int months, int weeks) {
    return 'amezi $months n\'ibyumweru $weeks';
  }

  @override
  String get cycleSheetTitle => 'Umuzunguruko wawe';

  @override
  String get cycleLastStart => 'Itangiriro ry\'imihango ya nyuma';

  @override
  String get cycleLengthNote =>
      'Iyi ni yo ikoreshwa kugeza wanditse imizunguruko myinshi.';

  @override
  String get cycleSheetSave => 'Bika';

  @override
  String reviewedByName(String name) {
    return 'Byasuzumwe na $name';
  }

  @override
  String get toolCycleCalcTitle => 'Igenzura ry\'umuzunguruko';

  @override
  String get toolCycleCalcBody =>
      'Andika itangiriro ry\'imihango ya nyuma, imihango imara iminsi ingahe n\'uburebure bw\'umuzunguruko. Uzabona intanga, imihango itaha, iminsi yo gusama n\'ibyiciro byombi.';

  @override
  String get healthPeriodDays => 'Imihango imara iminsi ingahe';

  @override
  String get healthResultPeriod => 'Imihango itaha';

  @override
  String get healthResultFollicular => 'Icyiciro cya mbere';

  @override
  String get healthResultLuteal => 'Icyiciro cya kabiri';

  @override
  String get healthOvulationNote => 'Intanga isohoka hafi aha.';

  @override
  String healthPeriodNote(int days) {
    return 'Imihango imara iminsi $days.';
  }

  @override
  String get healthFertileNote =>
      'Iminsi ushobora gusama, kuva ku minsi itanu mbere y\'intanga kugeza ku munsi umwe nyuma yayo.';

  @override
  String get healthFollicularNote =>
      'Kuva ku itangiriro ry\'imihango kugeza intanga isohotse.';

  @override
  String get healthLutealNote =>
      'Kuva nyuma y\'intanga kugeza umunsi umwe mbere y\'imihango itaha.';

  @override
  String get toolPeriodCalcTitle => 'Igenzura ry\'imihango itaha';

  @override
  String get toolPeriodCalcBody =>
      'Igihe imihango yawe itaha ishobora gutangira n\'igihe izamara.';

  @override
  String get toolOvulationTitle => 'Igenzura ry\'intanga';

  @override
  String get toolOvulationBody =>
      'Igihe intanga ishobora gusohoka n\'iminsi yo gusama.';
}
