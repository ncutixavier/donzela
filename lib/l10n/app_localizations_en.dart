// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Donzela';

  @override
  String get langRw => 'Ikinyarwanda';

  @override
  String get langEn => 'English';

  @override
  String get langFr => 'Français';

  @override
  String get chooseLanguage => 'Choose a language';

  @override
  String get welcomeTitle => 'Know your body';

  @override
  String get welcomeBody =>
      'A friend that helps you follow your cycle, made for every woman in Rwanda.';

  @override
  String get dataStaysNote => 'Your data stays on your phone';

  @override
  String get continueBtn => 'Continue';

  @override
  String get backBtn => 'Back';

  @override
  String get skipBtn => 'Skip';

  @override
  String stepOf(int current, int total) {
    return '$current of $total';
  }

  @override
  String get privacyTitle => 'Your body, your data';

  @override
  String get privacySubtitle =>
      'Your data belongs to you. Here is our promise.';

  @override
  String get privacy1Title => 'Stays on your phone';

  @override
  String get privacy1Body =>
      'What you record about your cycle is kept on this phone. It does not go to our servers.';

  @override
  String get privacy2Title => 'You choose whether to back up';

  @override
  String get privacy2Body =>
      'You can turn it on later in Settings. It starts off.';

  @override
  String get privacy3Title => 'Never sold';

  @override
  String get privacy3Body =>
      'We will never sell your health data. You can delete everything at any time.';

  @override
  String get agreeContinue => 'I agree, continue';

  @override
  String get readPolicy => 'Read the privacy policy';

  @override
  String get policyTitle => 'Privacy policy';

  @override
  String get policyBody =>
      'Donzela keeps your cycle data on your phone only.\n\nNo health information is sent to analytics events or crash reports.\n\nCloud backup is off until you turn it on. When you do, your data is uploaded with your consent, and you can delete it at any time.\n\nYou can delete all data at any time in Settings.';

  @override
  String get lastPeriodTitle => 'When did your last period start?';

  @override
  String get lastPeriodBody =>
      'This helps Donzela estimate when your next period will come. You can change it at any time.';

  @override
  String get sinibuka => 'I don\'t remember';

  @override
  String get sinibukaNote =>
      'Low confidence estimate: the date is 14 days before today.';

  @override
  String get cycleLengthTitle => 'How many days is your cycle?';

  @override
  String get cycleLengthBody =>
      'A cycle runs from the first day of your period to the day before the next one. Not sure? Keep the usual numbers; Donzela will learn as you log.';

  @override
  String get cycleLengthLabel => 'Cycle length';

  @override
  String get periodLengthLabel => 'Period length';

  @override
  String get daysUnit => 'days';

  @override
  String get cycleRangeNote => 'Most cycles last between 21 and 35 days';

  @override
  String get pinSetupTitle => 'Protect Donzela';

  @override
  String get pinSetupBody =>
      'Helpful if you share your phone. You can change this later in Settings.';

  @override
  String get pinToggle => 'Lock with a 4-digit PIN';

  @override
  String get pinHint => 'Choose a PIN that is not your birthday.';

  @override
  String get remindersTitle => 'Reminders';

  @override
  String get reminderPeriod => 'Period coming';

  @override
  String get reminderFertile => 'Fertile window';

  @override
  String get reminderPill => 'Daily pill';

  @override
  String get reminderNote =>
      'Notifications never show health details. They only say \"Donzela reminder\".';

  @override
  String get startApp => 'Start using Donzela';

  @override
  String get pinEnterTitle => 'Enter your PIN';

  @override
  String get pinNewTitle => 'Set a new PIN';

  @override
  String get pinConfirmTitle => 'Enter the PIN again';

  @override
  String get pinWrong => 'Wrong PIN. Try again.';

  @override
  String pinLockedFor(int seconds) {
    return 'Try again in $seconds seconds';
  }

  @override
  String get forgotPin => 'Forgot PIN?';

  @override
  String get resetPinTitle => 'Forgot PIN?';

  @override
  String get resetPinBody =>
      'You can delete all data on this phone. If a cloud backup exists, you can restore it.';

  @override
  String get deleteBtn => 'Delete';

  @override
  String get cancelBtn => 'Cancel';

  @override
  String get confirmBtn => 'Confirm';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get saveBtn => 'Save';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get onWeekday => 'On';

  @override
  String get todayCycleDay => 'Cycle day';

  @override
  String get phasePeriod => 'Period';

  @override
  String get phaseFertile => 'Fertile window';

  @override
  String get phaseOvulation => 'Ovulation';

  @override
  String get phaseNormal => 'Normal';

  @override
  String get phasePredictedPeriod => 'Predicted period';

  @override
  String nextPeriodIn(int days, String date) {
    return 'Next period in $days days · around $date';
  }

  @override
  String nextPeriodLate(String date) {
    return 'Period is late · expected $date';
  }

  @override
  String get estimateChip => 'Estimate';

  @override
  String get firstEstimate => 'First estimate';

  @override
  String get getStartedTitle => 'Get started';

  @override
  String get checkOnboarding => 'Finished setup';

  @override
  String get checkFirstCycle => 'Last period date saved';

  @override
  String get checkPrediction => 'First estimate ready';

  @override
  String get checkLogToday => 'Logged today';

  @override
  String get firstUseBody =>
      'Log your next 2 periods and Donzela will learn how your body works.';

  @override
  String get upcomingNotice => 'Predictions get sharper over time';

  @override
  String get estimatesOnly =>
      'Predictions are estimates only and are not contraception advice.';

  @override
  String get tipTitle => 'Tip for today';

  @override
  String get tipPeriod =>
      'A warm compress on your belly can ease cramps. Rest when you need to.';

  @override
  String get tipFollicular =>
      'Early in the cycle you may feel more energy. It is a good time for light exercise.';

  @override
  String get tipFertile =>
      'In the fertile days you may feel more energy and notice clear, slippery discharge. This is normal.';

  @override
  String get tipLuteal =>
      'You may feel tired or anxious. Drinking water and resting helps.';

  @override
  String get readMore => 'Read more';

  @override
  String get todayTitle => 'Today';

  @override
  String get calendarTab => 'Calendar';

  @override
  String get learnTab => 'Learn';

  @override
  String get helpTab => 'Help';

  @override
  String get calendarTitle => 'Calendar';

  @override
  String get legendPeriod => 'Period';

  @override
  String get legendPredicted => 'Predicted';

  @override
  String get legendFertile => 'Fertile';

  @override
  String get legendOvulation => 'Ovulation';

  @override
  String get historyTitle => 'Cycle history';

  @override
  String get avgCycle => 'Average cycle';

  @override
  String get avgPeriod => 'Average period';

  @override
  String daysCount(int n) {
    return '$n days';
  }

  @override
  String get reportBtn => 'Nurse report';

  @override
  String get confLow => 'Low confidence';

  @override
  String get confMedium => 'Medium confidence';

  @override
  String get confHigh => 'High confidence';

  @override
  String get flagIrregular =>
      'Your cycles vary a lot. Read about irregular cycles.';

  @override
  String get flagLate => 'Your period is more than 7 days late.';

  @override
  String get monthPrev => 'Previous month';

  @override
  String get monthNext => 'Next month';

  @override
  String get dayStartQ => 'Did your period start today?';

  @override
  String get periodStartHere => 'Period starts here';

  @override
  String get periodEndHere => 'Period ends here';

  @override
  String get periodEnded => 'Period ended';

  @override
  String get logSheetTitle => 'Log today';

  @override
  String get flowTitle => 'Flow';

  @override
  String get flowNone => 'None';

  @override
  String get flowSpotting => 'Spotting';

  @override
  String get flowMedium => 'Medium';

  @override
  String get flowHeavy => 'Heavy';

  @override
  String get symptomsTitle => 'Symptoms';

  @override
  String get moodTitle => 'How you feel';

  @override
  String get notesTitle => 'Notes';

  @override
  String get notesHint => 'Anything else you want to write?';

  @override
  String get symptomCramps => 'Cramps';

  @override
  String get symptomHeadache => 'Headache';

  @override
  String get symptomBackache => 'Backache';

  @override
  String get symptomBloating => 'Bloating';

  @override
  String get symptomAcne => 'Acne';

  @override
  String get symptomBreast => 'Sore breasts';

  @override
  String get symptomFatigue => 'Fatigue';

  @override
  String get moodCalm => 'Calm';

  @override
  String get moodHappy => 'Happy';

  @override
  String get moodSad => 'Sad';

  @override
  String get moodIrritable => 'Irritable';

  @override
  String get moodAnxious => 'Anxious';

  @override
  String get reportTitle => 'Report for your nurse';

  @override
  String get reportSummary => 'Cycle summary';

  @override
  String get reportCycleCol => 'Cycle (days)';

  @override
  String get reportPeriodCol => 'Period (days)';

  @override
  String get reportLast => 'Last';

  @override
  String get reportStartCol => 'Start';

  @override
  String get reportLengthCol => 'Length';

  @override
  String get reportPeriodLenCol => 'Period';

  @override
  String get reportSymptoms => 'Most logged symptoms';

  @override
  String get reportFooter =>
      'Made by Donzela. Estimates only, not a medical diagnosis.';

  @override
  String get reportNoData => 'No periods logged yet.';

  @override
  String get sharePdf => 'Share as PDF';

  @override
  String get showOnPhone => 'Show on phone';

  @override
  String get learnTitle => 'Learn';

  @override
  String get learnSubtitle => 'Every article is reviewed by a midwife';

  @override
  String get searchHint => 'e.g. period pain';

  @override
  String get filterAll => 'All';

  @override
  String get filterMine => 'Your cycle';

  @override
  String get filterHygiene => 'Period hygiene';

  @override
  String get filterContraception => 'Contraception';

  @override
  String reviewedBy(String name, String date) {
    return 'Reviewed by $name, $date';
  }

  @override
  String get noArticles => 'No reviewed articles are available yet.';

  @override
  String get saveArticle => 'Save article';

  @override
  String get savedArticle => 'Saved';

  @override
  String get helpTitle => 'Find help';

  @override
  String get helpSubtitle => 'Free services that keep your privacy, near you';

  @override
  String get emergencyTitle => 'Emergency help';

  @override
  String get isangeCentre => 'Isange One Stop Centre';

  @override
  String get ambulance => 'Ambulance (SAMU)';

  @override
  String get yourDistrict => 'Your district';

  @override
  String get centresNone =>
      'Health centres for this district are not listed yet.';

  @override
  String get callBtn => 'Call';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get sectionPrefs => 'PREFERENCES';

  @override
  String get sectionPrivacy => 'PRIVACY';

  @override
  String get languageSetting => 'Language';

  @override
  String get pinSetting => 'Lock with PIN';

  @override
  String get changePin => 'Change PIN';

  @override
  String get analyticsSetting => 'Usage numbers';

  @override
  String get analyticsNote =>
      'Numbers with no health information, to help improve Donzela. You can turn this off.';

  @override
  String get backupSetting => 'Cloud backup';

  @override
  String get backupNote =>
      'Your cycle data is stored only on this phone. Turn on backup so it is not lost if you change phones.';

  @override
  String get backupExplain =>
      'Backup uploads your cycle data to the cloud. We will ask for your consent first.';

  @override
  String get backupConsentBtn => 'I agree';

  @override
  String get backupUnavailable =>
      'Cloud backup is not available in this version yet.';

  @override
  String get deleteAllBtn => 'Delete all my data';

  @override
  String get deleteAllTitle => 'Delete all data?';

  @override
  String get deleteAllBody =>
      'This deletes all data on this phone and in the cloud. It cannot be undone.';

  @override
  String get privacyPolicyLink => 'Privacy policy';

  @override
  String get firstNameLabel => 'Your first name (optional)';

  @override
  String get setPinBtn => 'Set PIN';

  @override
  String get remindersOff => 'Reminders are off';

  @override
  String get reminderPeriodText => 'Period reminders';

  @override
  String get notifTitle => 'Donzela reminder';

  @override
  String get notifBody => 'Open Donzela to see';

  @override
  String get pillTimeLabel => 'Pill time';

  @override
  String get genericError => 'Something went wrong. Try again.';

  @override
  String get deleteDone => 'Data deleted.';

  @override
  String get m1 => 'January';

  @override
  String get m2 => 'February';

  @override
  String get m3 => 'March';

  @override
  String get m4 => 'April';

  @override
  String get m5 => 'May';

  @override
  String get m6 => 'June';

  @override
  String get m7 => 'July';

  @override
  String get m8 => 'August';

  @override
  String get m9 => 'September';

  @override
  String get m10 => 'October';

  @override
  String get m11 => 'November';

  @override
  String get m12 => 'December';

  @override
  String get w1 => 'Mo';

  @override
  String get w2 => 'Tu';

  @override
  String get w3 => 'We';

  @override
  String get w4 => 'Th';

  @override
  String get w5 => 'Fr';

  @override
  String get w6 => 'Sa';

  @override
  String get w7 => 'Su';

  @override
  String get d1 => 'Monday';

  @override
  String get d2 => 'Tuesday';

  @override
  String get d3 => 'Wednesday';

  @override
  String get d4 => 'Thursday';

  @override
  String get d5 => 'Friday';

  @override
  String get d6 => 'Saturday';

  @override
  String get d7 => 'Sunday';

  @override
  String get appFooter => 'Donzela 1.0 · Made in Kigali';

  @override
  String get logToday => 'Log today';

  @override
  String get draftBadge => 'Draft, not yet reviewed';

  @override
  String get logsTitle => 'Your logs';

  @override
  String get logsOpenBtn => 'Your logs';

  @override
  String get tabLogs => 'Logs';

  @override
  String get tabInsights => 'Insights';

  @override
  String get noLogs => 'No days logged yet. Days you log will appear here.';

  @override
  String get logDeleteTitle => 'Delete this entry?';

  @override
  String get logDeleteBody =>
      'What you logged for this day will be deleted. This cannot be undone.';

  @override
  String insightsDaysLogged(int n) {
    return 'Days logged: $n';
  }

  @override
  String insightsCyclesTracked(int n) {
    return 'Cycles tracked: $n';
  }

  @override
  String insightsCycleRange(int min, int max) {
    return 'Cycle length: $min–$max days';
  }

  @override
  String get insightsSymptoms => 'Most common symptoms';

  @override
  String get insightsMoods => 'Most common moods';

  @override
  String get insightsFlow => 'Flow during periods';

  @override
  String get insightsByPhase => 'By cycle phase';

  @override
  String insightsCountOf(int count, int total) {
    return '$count of $total days';
  }

  @override
  String get insightsNoData => 'Log a few days to see your patterns.';

  @override
  String get insightsDisclaimer =>
      'These numbers come only from what you logged. They are not a medical diagnosis.';

  @override
  String get noteEmpty => 'No note';

  @override
  String get authSignIn => 'Sign in with Google';

  @override
  String get authSignOut => 'Sign out';

  @override
  String authSignedInAs(String email) {
    return 'Signed in as $email';
  }

  @override
  String get authSignInFailed => 'Sign-in did not work. Try again.';

  @override
  String get cloudUnavailable =>
      'Backup is not available right now. Try again later.';

  @override
  String get restoreHint =>
      'Already use Donzela? Sign in to restore your data.';

  @override
  String get restoreFound => 'Your data is back.';

  @override
  String get restoreNone =>
      'No backup was found for this account. Continue setting up.';

  @override
  String get backupStarted =>
      'Backup is on. Changes are uploaded as you make them.';

  @override
  String get legendToday => 'Today';

  @override
  String get centreNextPeriodLabel => 'Period in';

  @override
  String get centreDaysUnit => 'days';

  @override
  String get centreLate => 'Period is late';

  @override
  String fertileWindowLine(String from, String to) {
    return 'Fertile window: $from – $to';
  }

  @override
  String todayLoggedLine(String items) {
    return 'Logged today: $items';
  }

  @override
  String get insightsShortcut => 'See your insights';

  @override
  String get entryTimeLabel => 'Time';

  @override
  String get editEntryTitle => 'Edit entry';

  @override
  String get entriesToday => 'Entries for this day';

  @override
  String get filterByDate => 'Filter by date';

  @override
  String get clearFilter => 'Clear filter';

  @override
  String get addEntryBtn => 'Add entry';

  @override
  String get noEntriesOnDay => 'Nothing logged on this day.';

  @override
  String get goToday => 'Today';

  @override
  String get regularCycles => 'Regular cycles';

  @override
  String get irregularCycles => 'Irregular cycles';

  @override
  String get navAccount => 'Account';

  @override
  String get accountTitle => 'Account';

  @override
  String get accountSignedOutBody =>
      'Sign in with Google to back up your data, share it between phones, and restore it when you need it.';

  @override
  String get accountBackupOff =>
      'Backup is off. Your data stays on this phone only.';

  @override
  String get accountBackupOn =>
      'Backup is on. Changes upload as you make them.';

  @override
  String accountLastSync(String when) {
    return 'Last synced: $when';
  }

  @override
  String get accountNeverSynced => 'Not synced yet';

  @override
  String accountPending(int n) {
    return 'Waiting to sync: $n';
  }

  @override
  String get accountSyncNow => 'Sync now';

  @override
  String get accountSyncDone => 'Synced.';

  @override
  String get accountPull => 'Pull recent updates';

  @override
  String get accountPullBody =>
      'Bring back your logs, cycles and settings from the cloud, plus the latest articles and health centres. You choose when.';

  @override
  String accountPulled(int n) {
    return 'Restored: $n records';
  }

  @override
  String get accountNothingNew => 'Nothing new.';

  @override
  String get accountTurnOnBackup => 'Turn on backup';

  @override
  String get accountBusy => 'Working...';

  @override
  String get adminBadge => 'Super-admin';

  @override
  String get adminOnlyBadgeBody =>
      'You are the super-admin: you can add, edit and delete Learn articles and everything in Help.';

  @override
  String get adminAddArticle => 'Add article';

  @override
  String get adminEditArticle => 'Edit article';

  @override
  String get adminDeleteBody => 'This will be removed for everyone.';

  @override
  String get fieldTitle => 'Title';

  @override
  String get fieldBody => 'Full text (Markdown)';

  @override
  String get fieldCategory => 'Category';

  @override
  String get fieldLanguage => 'Language';

  @override
  String get fieldReviewer => 'Reviewed by (leave empty if not reviewed)';

  @override
  String get adminEditHelp => 'Edit emergency numbers';

  @override
  String get fieldIsangeNumber => 'Isange One Stop Centre number';

  @override
  String get fieldAmbulanceNumber => 'Ambulance number';

  @override
  String get adminAddCentre => 'Add health centre';

  @override
  String get adminEditCentre => 'Edit health centre';

  @override
  String get fieldDistrict => 'District';

  @override
  String get fieldSector => 'Sector';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldPhone => 'Phone';

  @override
  String get fieldServices => 'Services';

  @override
  String get adminSaved => 'Saved.';

  @override
  String get adminRequired => 'Fill in the title and text.';

  @override
  String accountProgress(int percent) {
    return '$percent% done';
  }

  @override
  String get backupNotOnTitle => 'Backup is not on';

  @override
  String get backupNotOnBody =>
      'Backup could not be turned on because Google sign-in did not finish. Try again.';

  @override
  String get backupRetryBtn => 'Try again';

  @override
  String get okBtn => 'OK';

  @override
  String get adminSavedLocal =>
      'Saved on this phone. It will go to the cloud when you are online.';

  @override
  String get newDistrictNote =>
      'New district. It will be added to the list when you save.';

  @override
  String get districtPickNote => 'Pick a district, or type another one.';

  @override
  String get categoryHint => 'Pick a category, or type a new one.';

  @override
  String get editTab => 'Write';

  @override
  String get previewTab => 'Preview';

  @override
  String get previewEmpty => 'Nothing to preview yet.';

  @override
  String get boldTip => 'Bold';

  @override
  String get italicTip => 'Italic';

  @override
  String get headingTip => 'Heading';

  @override
  String get listTip => 'Bulleted list';

  @override
  String get quoteTip => 'Quote';

  @override
  String get linkTip => 'Link';

  @override
  String get emergencyManage => 'Emergency numbers';

  @override
  String get emergencyAdd => 'Add number';

  @override
  String get emergencyEdit => 'Edit number';

  @override
  String get emergencyNone => 'No emergency numbers yet.';

  @override
  String get translationsTitle => 'Languages';

  @override
  String get statusPublished => 'Published';

  @override
  String get statusDraft => 'Draft';

  @override
  String get statusMissing => 'Missing';

  @override
  String get translateNow => 'Translate';

  @override
  String get translateArticle => 'Translate article';

  @override
  String get saveDraftBtn => 'Save draft';

  @override
  String get publishAllBtn => 'Publish in all languages';

  @override
  String get publishedAll => 'Published in all languages.';

  @override
  String get publishNotReady => 'Not ready to publish';

  @override
  String get reviewerLabel => 'Reviewer (this language)';

  @override
  String get reviewerHint => 'Leave empty to show Donzela Team.';

  @override
  String writtenBy(String name) {
    return 'Written by $name';
  }

  @override
  String get accountPullPublicBody =>
      'Get the latest articles and Help numbers from Donzela.';

  @override
  String get accountContentUpdated =>
      'Latest articles and Help information are up to date.';

  @override
  String get adminUsersTitle => 'Admins';

  @override
  String get adminUsersBody =>
      'Admins can edit Learn and Help. A person becomes admin when you add their email here.';

  @override
  String get adminUsersEmailLabel => 'Google email';

  @override
  String get adminUsersEmailHint => 'For example: name@gmail.com';

  @override
  String get adminUsersAdd => 'Add admin';

  @override
  String get adminUsersListTitle => 'People with admin rights';

  @override
  String get adminUsersNone => 'No other admins yet.';

  @override
  String get adminUsersRemove => 'Remove admin';

  @override
  String get adminUsersRemoveTitle => 'Remove this admin?';

  @override
  String get adminUsersInvalid => 'Enter a valid email';

  @override
  String get adminUsersOwner =>
      'This is the owner account and cannot be removed';

  @override
  String get adminUsersRoleOwner => 'Owner';

  @override
  String get adminUsersRoleAdmin => 'Admin';

  @override
  String get adminUsersRoleUser => 'Member';

  @override
  String get adminUsersMakeAdmin => 'Make admin';

  @override
  String accountWelcome(String name) {
    return 'Welcome, $name';
  }

  @override
  String createdOn(String date) {
    return 'Created $date';
  }

  @override
  String publishedOn(String date) {
    return 'Published $date';
  }

  @override
  String updatedOn(String date) {
    return 'Updated $date';
  }

  @override
  String get onboardingPullContent => 'Get latest articles and Help info';

  @override
  String get contentPullFailed =>
      'Could not get the latest content. Check your connection.';

  @override
  String get lastPeriodOptional =>
      'You can skip this and add it later from the calendar.';

  @override
  String get refreshContent => 'Refresh articles and Help';

  @override
  String get accountSyncNowBody =>
      'Your data stays on this phone. Sync now uploads your latest changes to your Google account and records when it finished.';

  @override
  String get accountSyncOffBody =>
      'Turn on backup in Settings first. Then your changes can be uploaded to your Google account.';

  @override
  String get healthTitle => 'Health tools';

  @override
  String get healthSubtitle =>
      'Quick estimates from the dates you enter. They update as you change them.';

  @override
  String get healthSectionCycle => 'Your cycle';

  @override
  String get healthSectionPregnancy => 'Pregnancy';

  @override
  String get healthDisclaimer =>
      'These are estimates, not medical advice. Talk to a health worker about decisions for your health.';

  @override
  String get toolNextPeriodTitle => 'Next period';

  @override
  String get toolNextPeriodBody =>
      'When your next period is likely to start, based on your usual cycle length.';

  @override
  String get toolFertileTitle => 'Fertile days';

  @override
  String get toolFertileBody =>
      'The days when pregnancy is possible, and when ovulation is likely.';

  @override
  String get toolImplantTitle => 'Implantation window';

  @override
  String get toolImplantBody =>
      'When an embryo would usually implant in the womb after ovulation.';

  @override
  String get toolCycleLengthTitle => 'Cycle length';

  @override
  String get toolCycleLengthBody =>
      'Count the days between the start of two periods.';

  @override
  String get toolDueDateTitle => 'Due date';

  @override
  String get toolDueDateBody =>
      'Estimated due date, counted from the first day of your last period.';

  @override
  String get toolWeeksTitle => 'Weeks to months';

  @override
  String get toolWeeksBody =>
      'Convert weeks of pregnancy into months and weeks.';

  @override
  String get healthLastPeriod => 'First day of your last period';

  @override
  String get healthUsualCycle => 'Usual cycle length';

  @override
  String get healthPreviousPeriod => 'First day of the period before';

  @override
  String get healthNextPeriodStart => 'First day of the next period';

  @override
  String get healthWeeksPregnant => 'Weeks pregnant';

  @override
  String get healthWeeksUnit => 'weeks';

  @override
  String get healthResultNextPeriod => 'Next period around';

  @override
  String get healthResultOvulation => 'Ovulation around';

  @override
  String get healthResultFertile => 'Fertile days';

  @override
  String get healthResultImplant => 'Implantation likely between';

  @override
  String get healthResultCycleLength => 'Cycle length';

  @override
  String get healthResultDue => 'Estimated due date';

  @override
  String get healthResultAge => 'Pregnant for';

  @override
  String get healthResultMonths => 'About';

  @override
  String get healthCycleOut =>
      'A cycle is usually 21 to 45 days. Check the two dates.';

  @override
  String get healthTo => 'to';

  @override
  String get healthLess => 'Decrease';

  @override
  String get healthMore => 'Increase';

  @override
  String healthDays(int n) {
    return '$n days';
  }

  @override
  String healthWeekDays(int weeks, int days) {
    return '$weeks weeks and $days days';
  }

  @override
  String healthMonthsWeeks(int months, int weeks) {
    return '$months months and $weeks weeks';
  }
}
