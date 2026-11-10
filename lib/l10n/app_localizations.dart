import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_rw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('rw'),
  ];

  /// No description provided for @appName.
  ///
  /// In rw, this message translates to:
  /// **'Donzela'**
  String get appName;

  /// No description provided for @langRw.
  ///
  /// In rw, this message translates to:
  /// **'Ikinyarwanda'**
  String get langRw;

  /// No description provided for @langEn.
  ///
  /// In rw, this message translates to:
  /// **'English'**
  String get langEn;

  /// No description provided for @langFr.
  ///
  /// In rw, this message translates to:
  /// **'Français'**
  String get langFr;

  /// No description provided for @chooseLanguage.
  ///
  /// In rw, this message translates to:
  /// **'Hitamo ururimi'**
  String get chooseLanguage;

  /// No description provided for @welcomeTitle.
  ///
  /// In rw, this message translates to:
  /// **'Menya umubiri wawe'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In rw, this message translates to:
  /// **'Inshuti igufasha gukurikirana ukwezi kwawe, yakorewe buri mugore wo mu Rwanda.'**
  String get welcomeBody;

  /// No description provided for @dataStaysNote.
  ///
  /// In rw, this message translates to:
  /// **'Amakuru yawe aguma muri telefoni yawe'**
  String get dataStaysNote;

  /// No description provided for @continueBtn.
  ///
  /// In rw, this message translates to:
  /// **'Komeza'**
  String get continueBtn;

  /// No description provided for @backBtn.
  ///
  /// In rw, this message translates to:
  /// **'Subira inyuma'**
  String get backBtn;

  /// No description provided for @skipBtn.
  ///
  /// In rw, this message translates to:
  /// **'Simbuka'**
  String get skipBtn;

  /// No description provided for @stepOf.
  ///
  /// In rw, this message translates to:
  /// **'{current} kuri {total}'**
  String stepOf(int current, int total);

  /// No description provided for @privacyTitle.
  ///
  /// In rw, this message translates to:
  /// **'Umubiri wawe, amakuru yawe'**
  String get privacyTitle;

  /// No description provided for @privacySubtitle.
  ///
  /// In rw, this message translates to:
  /// **'Amakuru yawe ni ayawe. Dore isezerano ryacu.'**
  String get privacySubtitle;

  /// No description provided for @privacy1Title.
  ///
  /// In rw, this message translates to:
  /// **'Aguma muri telefoni yawe'**
  String get privacy1Title;

  /// No description provided for @privacy1Body.
  ///
  /// In rw, this message translates to:
  /// **'Ibyo wanditse ku kwezi kwawe bibikwa muri iyi telefoni, ntibijya kuri seriveri zacu.'**
  String get privacy1Body;

  /// No description provided for @privacy2Title.
  ///
  /// In rw, this message translates to:
  /// **'Kubika kopi ni wowe uhitamo'**
  String get privacy2Title;

  /// No description provided for @privacy2Body.
  ///
  /// In rw, this message translates to:
  /// **'Ushobora kubifungura nyuma mu Igenamiterere. Mu ntangiriro birafunze.'**
  String get privacy2Body;

  /// No description provided for @privacy3Title.
  ///
  /// In rw, this message translates to:
  /// **'Ntazigera agurishwa'**
  String get privacy3Title;

  /// No description provided for @privacy3Body.
  ///
  /// In rw, this message translates to:
  /// **'Ntituzigera tugurisha amakuru y\'ubuzima bwawe. Ushobora gusiba byose igihe cyose.'**
  String get privacy3Body;

  /// No description provided for @agreeContinue.
  ///
  /// In rw, this message translates to:
  /// **'Ndemeye, komeza'**
  String get agreeContinue;

  /// No description provided for @readPolicy.
  ///
  /// In rw, this message translates to:
  /// **'Soma politiki y\'ibanga'**
  String get readPolicy;

  /// No description provided for @policyTitle.
  ///
  /// In rw, this message translates to:
  /// **'Politiki y\'ibanga'**
  String get policyTitle;

  /// No description provided for @policyBody.
  ///
  /// In rw, this message translates to:
  /// **'Donzela ibika amakuru y\'ukwezi kwawe muri telefoni yawe gusa.\n\nNta makuru y\'ubuzima yoherezwa mu bikoresho by\'isesengura (analytics) cyangwa mu magambo y\'amakosa.\n\nKubika kopi kuri interineti birafunze kugeza ubifunguye. Iyo ubifunguye, amakuru yoherezwa ku mugaragaro ku kwemerera kwawe, kandi ushobora kuyasiba igihe cyose.\n\nUshobora gusiba amakuru yose igihe cyose mu Igenamiterere.'**
  String get policyBody;

  /// No description provided for @lastPeriodTitle.
  ///
  /// In rw, this message translates to:
  /// **'Imihango yawe iheruka yatangiye ryari?'**
  String get lastPeriodTitle;

  /// No description provided for @lastPeriodBody.
  ///
  /// In rw, this message translates to:
  /// **'Bifasha Donzela kugereranya igihe imihango yawe itaha izazira. Ushobora kubihindura igihe cyose.'**
  String get lastPeriodBody;

  /// No description provided for @sinibuka.
  ///
  /// In rw, this message translates to:
  /// **'Sinibuka'**
  String get sinibuka;

  /// No description provided for @sinibukaNote.
  ///
  /// In rw, this message translates to:
  /// **'Igereranya rito: itariki ni iminsi 14 uvuye none.'**
  String get sinibukaNote;

  /// No description provided for @cycleLengthTitle.
  ///
  /// In rw, this message translates to:
  /// **'Ukwezi kwawe kumara iminsi ingahe?'**
  String get cycleLengthTitle;

  /// No description provided for @cycleLengthBody.
  ///
  /// In rw, this message translates to:
  /// **'Ukwezi gutangira ku munsi wa mbere w\'imihango kugeza ku munsi ubanziriza imihango ikurikira. Ntubizi neza? Siga imibare isanzwe; Donzela izagenda yiga uko wandika.'**
  String get cycleLengthBody;

  /// No description provided for @cycleLengthLabel.
  ///
  /// In rw, this message translates to:
  /// **'Uburebure bw\'ukwezi'**
  String get cycleLengthLabel;

  /// No description provided for @periodLengthLabel.
  ///
  /// In rw, this message translates to:
  /// **'Iminsi y\'imihango'**
  String get periodLengthLabel;

  /// No description provided for @daysUnit.
  ///
  /// In rw, this message translates to:
  /// **'iminsi'**
  String get daysUnit;

  /// No description provided for @cycleRangeNote.
  ///
  /// In rw, this message translates to:
  /// **'Ukwezi kwinshi kumara hagati y\'iminsi 21 na 35'**
  String get cycleRangeNote;

  /// No description provided for @pinSetupTitle.
  ///
  /// In rw, this message translates to:
  /// **'Rinda ibanga rya Donzela'**
  String get pinSetupTitle;

  /// No description provided for @pinSetupBody.
  ///
  /// In rw, this message translates to:
  /// **'Bifasha niba usangira telefoni n\'abandi. Ushobora kubihindura nyuma mu Igenamiterere.'**
  String get pinSetupBody;

  /// No description provided for @pinToggle.
  ///
  /// In rw, this message translates to:
  /// **'Funga ukoresheje PIN y\'imibare 4'**
  String get pinToggle;

  /// No description provided for @pinHint.
  ///
  /// In rw, this message translates to:
  /// **'Hitamo PIN itari itariki y\'amavuko yawe.'**
  String get pinHint;

  /// No description provided for @remindersTitle.
  ///
  /// In rw, this message translates to:
  /// **'Ibyibutsa'**
  String get remindersTitle;

  /// No description provided for @reminderPeriod.
  ///
  /// In rw, this message translates to:
  /// **'Imihango iri hafi'**
  String get reminderPeriod;

  /// No description provided for @reminderFertile.
  ///
  /// In rw, this message translates to:
  /// **'Iminsi y\'uburumbuke'**
  String get reminderFertile;

  /// No description provided for @reminderPill.
  ///
  /// In rw, this message translates to:
  /// **'Ikinini cya buri munsi'**
  String get reminderPill;

  /// No description provided for @reminderNote.
  ///
  /// In rw, this message translates to:
  /// **'Ubutumwa ntibugaragaza ibisobanuro: buvuga gusa ngo \"Icyibutsa cya Donzela\".'**
  String get reminderNote;

  /// No description provided for @startApp.
  ///
  /// In rw, this message translates to:
  /// **'Tangira gukoresha Donzela'**
  String get startApp;

  /// No description provided for @pinEnterTitle.
  ///
  /// In rw, this message translates to:
  /// **'Andika PIN yawe'**
  String get pinEnterTitle;

  /// No description provided for @pinNewTitle.
  ///
  /// In rw, this message translates to:
  /// **'Shyiraho PIN nshya'**
  String get pinNewTitle;

  /// No description provided for @pinConfirmTitle.
  ///
  /// In rw, this message translates to:
  /// **'Ongera wandike PIN'**
  String get pinConfirmTitle;

  /// No description provided for @pinWrong.
  ///
  /// In rw, this message translates to:
  /// **'PIN si yo. Gerageza nanone.'**
  String get pinWrong;

  /// No description provided for @pinLockedFor.
  ///
  /// In rw, this message translates to:
  /// **'Gerageza nyuma y\'amasegonda {seconds}'**
  String pinLockedFor(int seconds);

  /// No description provided for @forgotPin.
  ///
  /// In rw, this message translates to:
  /// **'Wibagiwe PIN?'**
  String get forgotPin;

  /// No description provided for @resetPinTitle.
  ///
  /// In rw, this message translates to:
  /// **'Wibagiwe PIN?'**
  String get resetPinTitle;

  /// No description provided for @resetPinBody.
  ///
  /// In rw, this message translates to:
  /// **'Ushobora gusiba amakuru yose kuri telefoni. Niba kopi yo kuri interineti iriho, ushobora kuyisubizaho.'**
  String get resetPinBody;

  /// No description provided for @deleteBtn.
  ///
  /// In rw, this message translates to:
  /// **'Siba'**
  String get deleteBtn;

  /// No description provided for @cancelBtn.
  ///
  /// In rw, this message translates to:
  /// **'Hagarika'**
  String get cancelBtn;

  /// No description provided for @confirmBtn.
  ///
  /// In rw, this message translates to:
  /// **'Emeza'**
  String get confirmBtn;

  /// No description provided for @yes.
  ///
  /// In rw, this message translates to:
  /// **'Yego'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In rw, this message translates to:
  /// **'Oya'**
  String get no;

  /// No description provided for @saveBtn.
  ///
  /// In rw, this message translates to:
  /// **'Bika'**
  String get saveBtn;

  /// No description provided for @greetingMorning.
  ///
  /// In rw, this message translates to:
  /// **'Mwaramutse'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In rw, this message translates to:
  /// **'Mwiriwe'**
  String get greetingAfternoon;

  /// No description provided for @onWeekday.
  ///
  /// In rw, this message translates to:
  /// **'Ku wa'**
  String get onWeekday;

  /// No description provided for @todayCycleDay.
  ///
  /// In rw, this message translates to:
  /// **'Umunsi w\'ukwezi'**
  String get todayCycleDay;

  /// No description provided for @phasePeriod.
  ///
  /// In rw, this message translates to:
  /// **'Imihango'**
  String get phasePeriod;

  /// No description provided for @phaseFertile.
  ///
  /// In rw, this message translates to:
  /// **'Iminsi y\'uburumbuke'**
  String get phaseFertile;

  /// No description provided for @phaseOvulation.
  ///
  /// In rw, this message translates to:
  /// **'Irekurwa ry\'intanga'**
  String get phaseOvulation;

  /// No description provided for @phaseNormal.
  ///
  /// In rw, this message translates to:
  /// **'Ibisanzwe'**
  String get phaseNormal;

  /// No description provided for @phasePredictedPeriod.
  ///
  /// In rw, this message translates to:
  /// **'Imihango iteganyijwe'**
  String get phasePredictedPeriod;

  /// No description provided for @nextPeriodIn.
  ///
  /// In rw, this message translates to:
  /// **'Imihango itaha mu minsi {days} · ahagana {date}'**
  String nextPeriodIn(int days, String date);

  /// No description provided for @nextPeriodLate.
  ///
  /// In rw, this message translates to:
  /// **'Imihango iratinze · yari iteganyijwe {date}'**
  String nextPeriodLate(String date);

  /// No description provided for @estimateChip.
  ///
  /// In rw, this message translates to:
  /// **'Igereranya'**
  String get estimateChip;

  /// No description provided for @firstEstimate.
  ///
  /// In rw, this message translates to:
  /// **'Igereranya rya mbere'**
  String get firstEstimate;

  /// No description provided for @getStartedTitle.
  ///
  /// In rw, this message translates to:
  /// **'Tangira'**
  String get getStartedTitle;

  /// No description provided for @checkOnboarding.
  ///
  /// In rw, this message translates to:
  /// **'Wujuje kwiyandikisha'**
  String get checkOnboarding;

  /// No description provided for @checkFirstCycle.
  ///
  /// In rw, this message translates to:
  /// **'Itariki y\'imihango iheruka yanditswe'**
  String get checkFirstCycle;

  /// No description provided for @checkPrediction.
  ///
  /// In rw, this message translates to:
  /// **'Igereranya ryatangiye'**
  String get checkPrediction;

  /// No description provided for @checkLogToday.
  ///
  /// In rw, this message translates to:
  /// **'Wanditse uyu munsi'**
  String get checkLogToday;

  /// No description provided for @firstUseBody.
  ///
  /// In rw, this message translates to:
  /// **'Andika imihango yawe 2 itaha, Donzela imenye uko umubiri wawe ugenda.'**
  String get firstUseBody;

  /// No description provided for @upcomingNotice.
  ///
  /// In rw, this message translates to:
  /// **'Ibiteganywa bizagenda binonoka'**
  String get upcomingNotice;

  /// No description provided for @estimatesOnly.
  ///
  /// In rw, this message translates to:
  /// **'Ibiteganyijwe ni igereranya gusa, ntibigamije kuboneza urubyaro.'**
  String get estimatesOnly;

  /// No description provided for @tipTitle.
  ///
  /// In rw, this message translates to:
  /// **'Inama y\'uyu munsi'**
  String get tipTitle;

  /// No description provided for @tipPeriod.
  ///
  /// In rw, this message translates to:
  /// **'Shyushya amazi cyangwa ushyire umufuka w\'ubushyuhe ku nda ushobora kugabanya uburibwe. Ruhuka igihe ukeneye.'**
  String get tipPeriod;

  /// No description provided for @tipFollicular.
  ///
  /// In rw, this message translates to:
  /// **'Mu minsi ibanza y\'ukwezi ushobora kumva ufite imbaraga. Ni igihe cyiza cyo gukora imyitozo yoroheje.'**
  String get tipFollicular;

  /// No description provided for @tipFertile.
  ///
  /// In rw, this message translates to:
  /// **'Mu minsi y\'uburumbuke ushobora kumva ufite imbaraga nyinshi kandi ukabona ururenda rworoshye rurambuka. Ibyo ni ibisanzwe.'**
  String get tipFertile;

  /// No description provided for @tipLuteal.
  ///
  /// In rw, this message translates to:
  /// **'Ushobora kumva unaniwe cyangwa ufite impungenge. Kunywa amazi no kuruhuka bifasha.'**
  String get tipLuteal;

  /// No description provided for @readMore.
  ///
  /// In rw, this message translates to:
  /// **'Soma birambuye'**
  String get readMore;

  /// No description provided for @todayTitle.
  ///
  /// In rw, this message translates to:
  /// **'Uyu munsi'**
  String get todayTitle;

  /// No description provided for @calendarTab.
  ///
  /// In rw, this message translates to:
  /// **'Kalendari'**
  String get calendarTab;

  /// No description provided for @learnTab.
  ///
  /// In rw, this message translates to:
  /// **'Iga'**
  String get learnTab;

  /// No description provided for @helpTab.
  ///
  /// In rw, this message translates to:
  /// **'Ubufasha'**
  String get helpTab;

  /// No description provided for @calendarTitle.
  ///
  /// In rw, this message translates to:
  /// **'Kalendari'**
  String get calendarTitle;

  /// No description provided for @legendPeriod.
  ///
  /// In rw, this message translates to:
  /// **'Imihango'**
  String get legendPeriod;

  /// No description provided for @legendPredicted.
  ///
  /// In rw, this message translates to:
  /// **'Iteganyijwe'**
  String get legendPredicted;

  /// No description provided for @legendFertile.
  ///
  /// In rw, this message translates to:
  /// **'Uburumbuke'**
  String get legendFertile;

  /// No description provided for @legendOvulation.
  ///
  /// In rw, this message translates to:
  /// **'Irekurwa ry\'intanga'**
  String get legendOvulation;

  /// No description provided for @historyTitle.
  ///
  /// In rw, this message translates to:
  /// **'Amateka y\'ukwezi'**
  String get historyTitle;

  /// No description provided for @avgCycle.
  ///
  /// In rw, this message translates to:
  /// **'Ukwezi, ku kigereranyo'**
  String get avgCycle;

  /// No description provided for @avgPeriod.
  ///
  /// In rw, this message translates to:
  /// **'Imihango, ku kigereranyo'**
  String get avgPeriod;

  /// No description provided for @daysCount.
  ///
  /// In rw, this message translates to:
  /// **'{n} iminsi'**
  String daysCount(int n);

  /// No description provided for @reportBtn.
  ///
  /// In rw, this message translates to:
  /// **'Raporo y\'umuganga'**
  String get reportBtn;

  /// No description provided for @confLow.
  ///
  /// In rw, this message translates to:
  /// **'Igereranya rito'**
  String get confLow;

  /// No description provided for @confMedium.
  ///
  /// In rw, this message translates to:
  /// **'Igereranya ryo hagati'**
  String get confMedium;

  /// No description provided for @confHigh.
  ///
  /// In rw, this message translates to:
  /// **'Igereranya rihamye'**
  String get confHigh;

  /// No description provided for @flagIrregular.
  ///
  /// In rw, this message translates to:
  /// **'Ukwezi kwawe guhindagurika. Soma inyandiko ku mihango ihindagurika.'**
  String get flagIrregular;

  /// No description provided for @flagLate.
  ///
  /// In rw, this message translates to:
  /// **'Imihango iratinze kurenza iminsi 7.'**
  String get flagLate;

  /// No description provided for @monthPrev.
  ///
  /// In rw, this message translates to:
  /// **'Ukwezi kubanza'**
  String get monthPrev;

  /// No description provided for @monthNext.
  ///
  /// In rw, this message translates to:
  /// **'Ukwezi gutaha'**
  String get monthNext;

  /// No description provided for @dayStartQ.
  ///
  /// In rw, this message translates to:
  /// **'Imihango yawe yatangiye uyu munsi?'**
  String get dayStartQ;

  /// No description provided for @periodStartHere.
  ///
  /// In rw, this message translates to:
  /// **'Tangira imihango hano'**
  String get periodStartHere;

  /// No description provided for @periodEndHere.
  ///
  /// In rw, this message translates to:
  /// **'Imihango irangiriye hano'**
  String get periodEndHere;

  /// No description provided for @periodEnded.
  ///
  /// In rw, this message translates to:
  /// **'Imihango yarangiye'**
  String get periodEnded;

  /// No description provided for @logSheetTitle.
  ///
  /// In rw, this message translates to:
  /// **'Andika uyu munsi'**
  String get logSheetTitle;

  /// No description provided for @flowTitle.
  ///
  /// In rw, this message translates to:
  /// **'Ingano y\'amaraso'**
  String get flowTitle;

  /// No description provided for @flowNone.
  ///
  /// In rw, this message translates to:
  /// **'Nta yo'**
  String get flowNone;

  /// No description provided for @flowSpotting.
  ///
  /// In rw, this message translates to:
  /// **'Make'**
  String get flowSpotting;

  /// No description provided for @flowMedium.
  ///
  /// In rw, this message translates to:
  /// **'Hagati'**
  String get flowMedium;

  /// No description provided for @flowHeavy.
  ///
  /// In rw, this message translates to:
  /// **'Menshi'**
  String get flowHeavy;

  /// No description provided for @symptomsTitle.
  ///
  /// In rw, this message translates to:
  /// **'Ibimenyetso'**
  String get symptomsTitle;

  /// No description provided for @moodTitle.
  ///
  /// In rw, this message translates to:
  /// **'Uko wiyumva'**
  String get moodTitle;

  /// No description provided for @notesTitle.
  ///
  /// In rw, this message translates to:
  /// **'Inyandiko'**
  String get notesTitle;

  /// No description provided for @notesHint.
  ///
  /// In rw, this message translates to:
  /// **'Hari ikindi wifuza kwandika?'**
  String get notesHint;

  /// No description provided for @symptomCramps.
  ///
  /// In rw, this message translates to:
  /// **'Kuribwa mu nda'**
  String get symptomCramps;

  /// No description provided for @symptomHeadache.
  ///
  /// In rw, this message translates to:
  /// **'Kubabara umutwe'**
  String get symptomHeadache;

  /// No description provided for @symptomBackache.
  ///
  /// In rw, this message translates to:
  /// **'Kubabara umugongo'**
  String get symptomBackache;

  /// No description provided for @symptomBloating.
  ///
  /// In rw, this message translates to:
  /// **'Kubyimba inda'**
  String get symptomBloating;

  /// No description provided for @symptomAcne.
  ///
  /// In rw, this message translates to:
  /// **'Ibiheri'**
  String get symptomAcne;

  /// No description provided for @symptomBreast.
  ///
  /// In rw, this message translates to:
  /// **'Amabere aryana'**
  String get symptomBreast;

  /// No description provided for @symptomFatigue.
  ///
  /// In rw, this message translates to:
  /// **'Umunaniro'**
  String get symptomFatigue;

  /// No description provided for @moodCalm.
  ///
  /// In rw, this message translates to:
  /// **'Ntuje'**
  String get moodCalm;

  /// No description provided for @moodHappy.
  ///
  /// In rw, this message translates to:
  /// **'Nishimye'**
  String get moodHappy;

  /// No description provided for @moodSad.
  ///
  /// In rw, this message translates to:
  /// **'Mbabaye'**
  String get moodSad;

  /// No description provided for @moodIrritable.
  ///
  /// In rw, this message translates to:
  /// **'Ndarakara vuba'**
  String get moodIrritable;

  /// No description provided for @moodAnxious.
  ///
  /// In rw, this message translates to:
  /// **'Mfite impungenge'**
  String get moodAnxious;

  /// No description provided for @reportTitle.
  ///
  /// In rw, this message translates to:
  /// **'Raporo yo kwereka umuganga'**
  String get reportTitle;

  /// No description provided for @reportSummary.
  ///
  /// In rw, this message translates to:
  /// **'Incamake y\'ukwezi'**
  String get reportSummary;

  /// No description provided for @reportCycleCol.
  ///
  /// In rw, this message translates to:
  /// **'Ukwezi (iminsi)'**
  String get reportCycleCol;

  /// No description provided for @reportPeriodCol.
  ///
  /// In rw, this message translates to:
  /// **'Imihango (iminsi)'**
  String get reportPeriodCol;

  /// No description provided for @reportLast.
  ///
  /// In rw, this message translates to:
  /// **'Iheruka'**
  String get reportLast;

  /// No description provided for @reportStartCol.
  ///
  /// In rw, this message translates to:
  /// **'Itangiriro'**
  String get reportStartCol;

  /// No description provided for @reportLengthCol.
  ///
  /// In rw, this message translates to:
  /// **'Uburebure'**
  String get reportLengthCol;

  /// No description provided for @reportPeriodLenCol.
  ///
  /// In rw, this message translates to:
  /// **'Imihango'**
  String get reportPeriodLenCol;

  /// No description provided for @reportSymptoms.
  ///
  /// In rw, this message translates to:
  /// **'Ibimenyetso byanditswe kenshi'**
  String get reportSymptoms;

  /// No description provided for @reportFooter.
  ///
  /// In rw, this message translates to:
  /// **'Byakozwe na Donzela. Ni igereranya gusa, si isuzuma rya muganga.'**
  String get reportFooter;

  /// No description provided for @reportNoData.
  ///
  /// In rw, this message translates to:
  /// **'Nta mihango irandikwa irahari.'**
  String get reportNoData;

  /// No description provided for @sharePdf.
  ///
  /// In rw, this message translates to:
  /// **'Sangiza nka PDF'**
  String get sharePdf;

  /// No description provided for @showOnPhone.
  ///
  /// In rw, this message translates to:
  /// **'Erekana kuri telefoni'**
  String get showOnPhone;

  /// No description provided for @learnTitle.
  ///
  /// In rw, this message translates to:
  /// **'Iga'**
  String get learnTitle;

  /// No description provided for @learnSubtitle.
  ///
  /// In rw, this message translates to:
  /// **'Buri nyandiko isuzumwa n\'umuganga'**
  String get learnSubtitle;

  /// No description provided for @searchHint.
  ///
  /// In rw, this message translates to:
  /// **'urugero: uburibwe bw\'imihango'**
  String get searchHint;

  /// No description provided for @filterAll.
  ///
  /// In rw, this message translates to:
  /// **'Byose'**
  String get filterAll;

  /// No description provided for @filterMine.
  ///
  /// In rw, this message translates to:
  /// **'Ukwezi kwawe'**
  String get filterMine;

  /// No description provided for @filterHygiene.
  ///
  /// In rw, this message translates to:
  /// **'Isuku mu mihango'**
  String get filterHygiene;

  /// No description provided for @filterContraception.
  ///
  /// In rw, this message translates to:
  /// **'Kuboneza urubyaro'**
  String get filterContraception;

  /// No description provided for @reviewedBy.
  ///
  /// In rw, this message translates to:
  /// **'Byasuzumwe na {name}, {date}'**
  String reviewedBy(String name, String date);

  /// No description provided for @noArticles.
  ///
  /// In rw, this message translates to:
  /// **'Nta nyandiko zisuzumwe zirahari ubu.'**
  String get noArticles;

  /// No description provided for @saveArticle.
  ///
  /// In rw, this message translates to:
  /// **'Bika inyandiko'**
  String get saveArticle;

  /// No description provided for @savedArticle.
  ///
  /// In rw, this message translates to:
  /// **'Yabitswe'**
  String get savedArticle;

  /// No description provided for @helpTitle.
  ///
  /// In rw, this message translates to:
  /// **'Shaka ubufasha'**
  String get helpTitle;

  /// No description provided for @helpSubtitle.
  ///
  /// In rw, this message translates to:
  /// **'Serivisi z\'ubuntu kandi zibika ibanga, hafi yawe'**
  String get helpSubtitle;

  /// No description provided for @emergencyTitle.
  ///
  /// In rw, this message translates to:
  /// **'Ubufasha bwihutirwa'**
  String get emergencyTitle;

  /// No description provided for @isangeCentre.
  ///
  /// In rw, this message translates to:
  /// **'Isange One Stop Centre'**
  String get isangeCentre;

  /// No description provided for @ambulance.
  ///
  /// In rw, this message translates to:
  /// **'Imbangukiragutabara (SAMU)'**
  String get ambulance;

  /// No description provided for @yourDistrict.
  ///
  /// In rw, this message translates to:
  /// **'Akarere kawe'**
  String get yourDistrict;

  /// No description provided for @centresNone.
  ///
  /// In rw, this message translates to:
  /// **'Ibigo nderabuzima by\'aka karere ntibirashyirwamo ubu.'**
  String get centresNone;

  /// No description provided for @callBtn.
  ///
  /// In rw, this message translates to:
  /// **'Hamagara'**
  String get callBtn;

  /// No description provided for @settingsTitle.
  ///
  /// In rw, this message translates to:
  /// **'Igenamiterere'**
  String get settingsTitle;

  /// No description provided for @sectionPrefs.
  ///
  /// In rw, this message translates to:
  /// **'IBYIFUZO'**
  String get sectionPrefs;

  /// No description provided for @sectionPrivacy.
  ///
  /// In rw, this message translates to:
  /// **'IBANGA'**
  String get sectionPrivacy;

  /// No description provided for @languageSetting.
  ///
  /// In rw, this message translates to:
  /// **'Ururimi'**
  String get languageSetting;

  /// No description provided for @pinSetting.
  ///
  /// In rw, this message translates to:
  /// **'Gufunga na PIN'**
  String get pinSetting;

  /// No description provided for @changePin.
  ///
  /// In rw, this message translates to:
  /// **'Hindura PIN'**
  String get changePin;

  /// No description provided for @analyticsSetting.
  ///
  /// In rw, this message translates to:
  /// **'Imibare y\'ikoreshwa'**
  String get analyticsSetting;

  /// No description provided for @analyticsNote.
  ///
  /// In rw, this message translates to:
  /// **'Imibare idafite amakuru y\'ubuzima, yo gufasha Donzela gutera imbere. Ushobora kuyifunga.'**
  String get analyticsNote;

  /// No description provided for @backupSetting.
  ///
  /// In rw, this message translates to:
  /// **'Kubika kopi kuri interineti'**
  String get backupSetting;

  /// No description provided for @backupNote.
  ///
  /// In rw, this message translates to:
  /// **'Amakuru y\'ukwezi kwawe abikwa muri iyi telefoni gusa. Fungura kubika kopi kugira ngo atazabura nuhindura telefoni.'**
  String get backupNote;

  /// No description provided for @backupExplain.
  ///
  /// In rw, this message translates to:
  /// **'Kubika kopi bizohereza ku murongo amakuru y\'ukwezi kwawe. Turabanza tukubaze uburenganzira.'**
  String get backupExplain;

  /// No description provided for @backupConsentBtn.
  ///
  /// In rw, this message translates to:
  /// **'Ndemeye'**
  String get backupConsentBtn;

  /// No description provided for @backupUnavailable.
  ///
  /// In rw, this message translates to:
  /// **'Kubika kopi ntibiraboneka kuri iyi verisiyo.'**
  String get backupUnavailable;

  /// No description provided for @deleteAllBtn.
  ///
  /// In rw, this message translates to:
  /// **'Siba amakuru yanjye yose'**
  String get deleteAllBtn;

  /// No description provided for @deleteAllTitle.
  ///
  /// In rw, this message translates to:
  /// **'Siba amakuru yose?'**
  String get deleteAllTitle;

  /// No description provided for @deleteAllBody.
  ///
  /// In rw, this message translates to:
  /// **'Ibi bizasiba amakuru yose kuri telefoni n\'ayo kuri interineti. Ntibisubira inyuma.'**
  String get deleteAllBody;

  /// No description provided for @privacyPolicyLink.
  ///
  /// In rw, this message translates to:
  /// **'Politiki y\'ibanga'**
  String get privacyPolicyLink;

  /// No description provided for @firstNameLabel.
  ///
  /// In rw, this message translates to:
  /// **'Izina ryawe (ntibiba ngombwa)'**
  String get firstNameLabel;

  /// No description provided for @setPinBtn.
  ///
  /// In rw, this message translates to:
  /// **'Shyiraho PIN'**
  String get setPinBtn;

  /// No description provided for @remindersOff.
  ///
  /// In rw, this message translates to:
  /// **'Ibyibutsa bizimije'**
  String get remindersOff;

  /// No description provided for @reminderPeriodText.
  ///
  /// In rw, this message translates to:
  /// **'Ibyibutsa by\'imihango'**
  String get reminderPeriodText;

  /// No description provided for @notifTitle.
  ///
  /// In rw, this message translates to:
  /// **'Icyibutsa cya Donzela'**
  String get notifTitle;

  /// No description provided for @notifBody.
  ///
  /// In rw, this message translates to:
  /// **'Fungura Donzela urebe'**
  String get notifBody;

  /// No description provided for @pillTimeLabel.
  ///
  /// In rw, this message translates to:
  /// **'Igihe cy\'ikinini'**
  String get pillTimeLabel;

  /// No description provided for @genericError.
  ///
  /// In rw, this message translates to:
  /// **'Habaye ikibazo. Gerageza nanone.'**
  String get genericError;

  /// No description provided for @deleteDone.
  ///
  /// In rw, this message translates to:
  /// **'Amakuru yasibwe.'**
  String get deleteDone;

  /// No description provided for @m1.
  ///
  /// In rw, this message translates to:
  /// **'Mutarama'**
  String get m1;

  /// No description provided for @m2.
  ///
  /// In rw, this message translates to:
  /// **'Gashyantare'**
  String get m2;

  /// No description provided for @m3.
  ///
  /// In rw, this message translates to:
  /// **'Werurwe'**
  String get m3;

  /// No description provided for @m4.
  ///
  /// In rw, this message translates to:
  /// **'Mata'**
  String get m4;

  /// No description provided for @m5.
  ///
  /// In rw, this message translates to:
  /// **'Gicurasi'**
  String get m5;

  /// No description provided for @m6.
  ///
  /// In rw, this message translates to:
  /// **'Kamena'**
  String get m6;

  /// No description provided for @m7.
  ///
  /// In rw, this message translates to:
  /// **'Nyakanga'**
  String get m7;

  /// No description provided for @m8.
  ///
  /// In rw, this message translates to:
  /// **'Kanama'**
  String get m8;

  /// No description provided for @m9.
  ///
  /// In rw, this message translates to:
  /// **'Nzeri'**
  String get m9;

  /// No description provided for @m10.
  ///
  /// In rw, this message translates to:
  /// **'Ukwakira'**
  String get m10;

  /// No description provided for @m11.
  ///
  /// In rw, this message translates to:
  /// **'Ugushyingo'**
  String get m11;

  /// No description provided for @m12.
  ///
  /// In rw, this message translates to:
  /// **'Ukuboza'**
  String get m12;

  /// No description provided for @w1.
  ///
  /// In rw, this message translates to:
  /// **'Mb'**
  String get w1;

  /// No description provided for @w2.
  ///
  /// In rw, this message translates to:
  /// **'Kb'**
  String get w2;

  /// No description provided for @w3.
  ///
  /// In rw, this message translates to:
  /// **'Gt'**
  String get w3;

  /// No description provided for @w4.
  ///
  /// In rw, this message translates to:
  /// **'Kn'**
  String get w4;

  /// No description provided for @w5.
  ///
  /// In rw, this message translates to:
  /// **'Gn'**
  String get w5;

  /// No description provided for @w6.
  ///
  /// In rw, this message translates to:
  /// **'Gd'**
  String get w6;

  /// No description provided for @w7.
  ///
  /// In rw, this message translates to:
  /// **'Cy'**
  String get w7;

  /// No description provided for @d1.
  ///
  /// In rw, this message translates to:
  /// **'mbere'**
  String get d1;

  /// No description provided for @d2.
  ///
  /// In rw, this message translates to:
  /// **'kabiri'**
  String get d2;

  /// No description provided for @d3.
  ///
  /// In rw, this message translates to:
  /// **'gatatu'**
  String get d3;

  /// No description provided for @d4.
  ///
  /// In rw, this message translates to:
  /// **'kane'**
  String get d4;

  /// No description provided for @d5.
  ///
  /// In rw, this message translates to:
  /// **'gatanu'**
  String get d5;

  /// No description provided for @d6.
  ///
  /// In rw, this message translates to:
  /// **'gatandatu'**
  String get d6;

  /// No description provided for @d7.
  ///
  /// In rw, this message translates to:
  /// **'cyumweru'**
  String get d7;

  /// No description provided for @appFooter.
  ///
  /// In rw, this message translates to:
  /// **'Donzela 1.0 · Yakozwe i Kigali na Hova AI'**
  String get appFooter;

  /// No description provided for @logToday.
  ///
  /// In rw, this message translates to:
  /// **'Andika uyu munsi'**
  String get logToday;

  /// No description provided for @draftBadge.
  ///
  /// In rw, this message translates to:
  /// **'Inyandiko y\'igerageza, ntirasuzumwa'**
  String get draftBadge;

  /// No description provided for @logsTitle.
  ///
  /// In rw, this message translates to:
  /// **'Ibyo nanditse'**
  String get logsTitle;

  /// No description provided for @logsOpenBtn.
  ///
  /// In rw, this message translates to:
  /// **'Ibyo nanditse'**
  String get logsOpenBtn;

  /// No description provided for @tabLogs.
  ///
  /// In rw, this message translates to:
  /// **'Ibyanditswe'**
  String get tabLogs;

  /// No description provided for @tabInsights.
  ///
  /// In rw, this message translates to:
  /// **'Imibare'**
  String get tabInsights;

  /// No description provided for @noLogs.
  ///
  /// In rw, this message translates to:
  /// **'Nta munsi wanditse urabona hano.'**
  String get noLogs;

  /// No description provided for @logDeleteTitle.
  ///
  /// In rw, this message translates to:
  /// **'Siba iyi nyandiko?'**
  String get logDeleteTitle;

  /// No description provided for @logDeleteBody.
  ///
  /// In rw, this message translates to:
  /// **'Ibyanditswe kuri uyu munsi bizasibwa. Ntibisubira inyuma.'**
  String get logDeleteBody;

  /// No description provided for @insightsDaysLogged.
  ///
  /// In rw, this message translates to:
  /// **'Iminsi wanditse: {n}'**
  String insightsDaysLogged(int n);

  /// No description provided for @insightsCyclesTracked.
  ///
  /// In rw, this message translates to:
  /// **'Imizunguruko yanditswe: {n}'**
  String insightsCyclesTracked(int n);

  /// No description provided for @insightsCycleRange.
  ///
  /// In rw, this message translates to:
  /// **'Uburebure bw\'ukwezi: iminsi {min}–{max}'**
  String insightsCycleRange(int min, int max);

  /// No description provided for @insightsSymptoms.
  ///
  /// In rw, this message translates to:
  /// **'Ibimenyetso bikunze kugaragara'**
  String get insightsSymptoms;

  /// No description provided for @insightsMoods.
  ///
  /// In rw, this message translates to:
  /// **'Uko wiyumvaga cyane'**
  String get insightsMoods;

  /// No description provided for @insightsFlow.
  ///
  /// In rw, this message translates to:
  /// **'Ingano y\'amaraso mu mihango'**
  String get insightsFlow;

  /// No description provided for @insightsByPhase.
  ///
  /// In rw, this message translates to:
  /// **'Ukurikije icyiciro cy\'ukwezi'**
  String get insightsByPhase;

  /// No description provided for @insightsCountOf.
  ///
  /// In rw, this message translates to:
  /// **'{count} mu minsi {total}'**
  String insightsCountOf(int count, int total);

  /// No description provided for @insightsNoData.
  ///
  /// In rw, this message translates to:
  /// **'Andika iminsi mike kugira ngo ubone imibare.'**
  String get insightsNoData;

  /// No description provided for @insightsDisclaimer.
  ///
  /// In rw, this message translates to:
  /// **'Iyi mibare ni iy\'ibyo wanditse gusa, si isuzuma rya muganga.'**
  String get insightsDisclaimer;

  /// No description provided for @noteEmpty.
  ///
  /// In rw, this message translates to:
  /// **'Nta nyandiko'**
  String get noteEmpty;

  /// No description provided for @authSignIn.
  ///
  /// In rw, this message translates to:
  /// **'Injira ukoresheje Google'**
  String get authSignIn;

  /// No description provided for @authSignOut.
  ///
  /// In rw, this message translates to:
  /// **'Sohoka'**
  String get authSignOut;

  /// No description provided for @authSignedInAs.
  ///
  /// In rw, this message translates to:
  /// **'Winjiriye nka {email}'**
  String authSignedInAs(String email);

  /// No description provided for @authSignInFailed.
  ///
  /// In rw, this message translates to:
  /// **'Kwinjira ntibyakunze. Gerageza nanone.'**
  String get authSignInFailed;

  /// No description provided for @cloudUnavailable.
  ///
  /// In rw, this message translates to:
  /// **'Kopi ntiraboneka ubu. Gerageza nyuma.'**
  String get cloudUnavailable;

  /// No description provided for @restoreHint.
  ///
  /// In rw, this message translates to:
  /// **'Usanzwe ukoresha Donzela? Injira ugarure amakuru yawe.'**
  String get restoreHint;

  /// No description provided for @restoreFound.
  ///
  /// In rw, this message translates to:
  /// **'Amakuru yawe yagaruwe.'**
  String get restoreFound;

  /// No description provided for @restoreNone.
  ///
  /// In rw, this message translates to:
  /// **'Nta makuru yabitswe kuri iyi konti. Komeza wiyandikishe.'**
  String get restoreNone;

  /// No description provided for @backupStarted.
  ///
  /// In rw, this message translates to:
  /// **'Kopi yatangiye. Amakuru yoherezwa uko ahinduka.'**
  String get backupStarted;

  /// No description provided for @legendToday.
  ///
  /// In rw, this message translates to:
  /// **'Uyu munsi'**
  String get legendToday;

  /// No description provided for @centreNextPeriodLabel.
  ///
  /// In rw, this message translates to:
  /// **'Imihango mu'**
  String get centreNextPeriodLabel;

  /// No description provided for @centreDaysUnit.
  ///
  /// In rw, this message translates to:
  /// **'iminsi'**
  String get centreDaysUnit;

  /// No description provided for @centreLate.
  ///
  /// In rw, this message translates to:
  /// **'Imihango yatinze'**
  String get centreLate;

  /// No description provided for @fertileWindowLine.
  ///
  /// In rw, this message translates to:
  /// **'Iminsi y\'uburumbuke: {from} – {to}'**
  String fertileWindowLine(String from, String to);

  /// No description provided for @todayLoggedLine.
  ///
  /// In rw, this message translates to:
  /// **'Wanditse uyu munsi: {items}'**
  String todayLoggedLine(String items);

  /// No description provided for @insightsShortcut.
  ///
  /// In rw, this message translates to:
  /// **'Reba imibare yawe'**
  String get insightsShortcut;

  /// No description provided for @entryTimeLabel.
  ///
  /// In rw, this message translates to:
  /// **'Igihe'**
  String get entryTimeLabel;

  /// No description provided for @editEntryTitle.
  ///
  /// In rw, this message translates to:
  /// **'Hindura ibyanditswe'**
  String get editEntryTitle;

  /// No description provided for @entriesToday.
  ///
  /// In rw, this message translates to:
  /// **'Ibyanditswe uyu munsi'**
  String get entriesToday;

  /// No description provided for @filterByDate.
  ///
  /// In rw, this message translates to:
  /// **'Shakisha ukurikije itariki'**
  String get filterByDate;

  /// No description provided for @clearFilter.
  ///
  /// In rw, this message translates to:
  /// **'Siba akayunguro'**
  String get clearFilter;

  /// No description provided for @addEntryBtn.
  ///
  /// In rw, this message translates to:
  /// **'Ongeraho'**
  String get addEntryBtn;

  /// No description provided for @noEntriesOnDay.
  ///
  /// In rw, this message translates to:
  /// **'Nta munsi wanditse uyu munsi.'**
  String get noEntriesOnDay;

  /// No description provided for @goToday.
  ///
  /// In rw, this message translates to:
  /// **'Uyu munsi'**
  String get goToday;

  /// No description provided for @regularCycles.
  ///
  /// In rw, this message translates to:
  /// **'Ukwezi guhoraho'**
  String get regularCycles;

  /// No description provided for @irregularCycles.
  ///
  /// In rw, this message translates to:
  /// **'Ukwezi guhindagurika'**
  String get irregularCycles;

  /// No description provided for @navAccount.
  ///
  /// In rw, this message translates to:
  /// **'Konti'**
  String get navAccount;

  /// No description provided for @accountTitle.
  ///
  /// In rw, this message translates to:
  /// **'Konti'**
  String get accountTitle;

  /// No description provided for @accountSignedOutBody.
  ///
  /// In rw, this message translates to:
  /// **'Injira ukoresheje Google kugira ngo ubike kopi y\'amakuru yawe, uyasangize hagati ya telefoni, kandi uyagarure igihe ukeneye.'**
  String get accountSignedOutBody;

  /// No description provided for @accountBackupOff.
  ///
  /// In rw, this message translates to:
  /// **'Kopi ntiriho. Amakuru yawe abikwa kuri telefoni gusa.'**
  String get accountBackupOff;

  /// No description provided for @accountBackupOn.
  ///
  /// In rw, this message translates to:
  /// **'Kopi iriho. Amakuru yoherezwa uko ahinduka.'**
  String get accountBackupOn;

  /// No description provided for @accountLastSync.
  ///
  /// In rw, this message translates to:
  /// **'Byasangijwe bwa nyuma: {when}'**
  String accountLastSync(String when);

  /// No description provided for @accountNeverSynced.
  ///
  /// In rw, this message translates to:
  /// **'Ntibirasangizwa na rimwe'**
  String get accountNeverSynced;

  /// No description provided for @accountPending.
  ///
  /// In rw, this message translates to:
  /// **'Bitarasangizwa: {n}'**
  String accountPending(int n);

  /// No description provided for @accountSyncNow.
  ///
  /// In rw, this message translates to:
  /// **'Sangiza ubu'**
  String get accountSyncNow;

  /// No description provided for @accountSyncDone.
  ///
  /// In rw, this message translates to:
  /// **'Byasangijwe.'**
  String get accountSyncDone;

  /// No description provided for @accountPull.
  ///
  /// In rw, this message translates to:
  /// **'Gusubiza amakuru mashya'**
  String get accountPull;

  /// No description provided for @accountPullBody.
  ///
  /// In rw, this message translates to:
  /// **'Zana amakuru yawe, ibyanditswe, uburyo wakoresheje n\'amakuru mashya ku bigo nderabuzima n\'inyandiko. Ubikora wowe ubwawe.'**
  String get accountPullBody;

  /// No description provided for @accountPulled.
  ///
  /// In rw, this message translates to:
  /// **'Byagarutse: {n}'**
  String accountPulled(int n);

  /// No description provided for @accountNothingNew.
  ///
  /// In rw, this message translates to:
  /// **'Nta kintu gishya.'**
  String get accountNothingNew;

  /// No description provided for @accountTurnOnBackup.
  ///
  /// In rw, this message translates to:
  /// **'Fungura kopi'**
  String get accountTurnOnBackup;

  /// No description provided for @accountBusy.
  ///
  /// In rw, this message translates to:
  /// **'Biragenda...'**
  String get accountBusy;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'rw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'rw':
      return AppLocalizationsRw();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
