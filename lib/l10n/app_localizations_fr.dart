// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Donzela';

  @override
  String get langRw => 'Ikinyarwanda';

  @override
  String get langEn => 'English';

  @override
  String get langFr => 'Français';

  @override
  String get chooseLanguage => 'Choisissez une langue';

  @override
  String get welcomeTitle => 'Connaître votre corps';

  @override
  String get welcomeBody =>
      'Une amie qui vous aide à suivre votre cycle, conçue pour chaque femme au Rwanda.';

  @override
  String get dataStaysNote => 'Vos données restent sur votre téléphone';

  @override
  String get continueBtn => 'Continuer';

  @override
  String get backBtn => 'Retour';

  @override
  String get skipBtn => 'Passer';

  @override
  String stepOf(int current, int total) {
    return '$current sur $total';
  }

  @override
  String get privacyTitle => 'Votre corps, vos données';

  @override
  String get privacySubtitle =>
      'Vos données vous appartiennent. Voici notre engagement.';

  @override
  String get privacy1Title => 'Reste sur votre téléphone';

  @override
  String get privacy1Body =>
      'Ce que vous notez sur votre cycle est gardé sur ce téléphone. Rien ne part sur nos serveurs.';

  @override
  String get privacy2Title => 'Vous choisissez la sauvegarde';

  @override
  String get privacy2Body =>
      'Vous pouvez l\'activer plus tard dans les Paramètres. Elle est désactivée au départ.';

  @override
  String get privacy3Title => 'Jamais vendues';

  @override
  String get privacy3Body =>
      'Nous ne vendrons jamais vos données de santé. Vous pouvez tout supprimer à tout moment.';

  @override
  String get agreeContinue => 'J\'accepte, continuer';

  @override
  String get readPolicy => 'Lire la politique de confidentialité';

  @override
  String get policyTitle => 'Politique de confidentialité';

  @override
  String get policyBody =>
      'Donzela garde les données de votre cycle uniquement sur votre téléphone.\n\nAucune information de santé n\'est envoyée aux statistiques ni aux rapports d\'erreurs.\n\nLa sauvegarde en ligne est désactivée jusqu\'à ce que vous l\'activiez. Dans ce cas, vos données sont envoyées avec votre accord, et vous pouvez les supprimer à tout moment.\n\nVous pouvez tout supprimer à tout moment dans les Paramètres.';

  @override
  String get lastPeriodTitle =>
      'Quand vos dernières règles ont-elles commencé ?';

  @override
  String get lastPeriodBody =>
      'Cela aide Donzela à estimer quand vos prochaines règles arriveront. Vous pouvez le modifier à tout moment.';

  @override
  String get sinibuka => 'Je ne me souviens pas';

  @override
  String get sinibukaNote =>
      'Estimation peu fiable : la date est fixée à 14 jours avant aujourd\'hui.';

  @override
  String get cycleLengthTitle => 'Combien de jours dure votre cycle ?';

  @override
  String get cycleLengthBody =>
      'Un cycle va du premier jour de vos règles au jour précédant les suivantes. Vous ne savez pas ? Gardez les valeurs habituelles ; Donzela apprendra au fil de vos notes.';

  @override
  String get cycleLengthLabel => 'Durée du cycle';

  @override
  String get periodLengthLabel => 'Durée des règles';

  @override
  String get daysUnit => 'jours';

  @override
  String get cycleRangeNote =>
      'La plupart des cycles durent entre 21 et 35 jours';

  @override
  String get pinSetupTitle => 'Protégez Donzela';

  @override
  String get pinSetupBody =>
      'Utile si vous partagez votre téléphone. Vous pourrez le modifier dans les Paramètres.';

  @override
  String get pinToggle => 'Verrouiller avec un code à 4 chiffres';

  @override
  String get pinHint =>
      'Choisissez un code qui n\'est pas votre date de naissance.';

  @override
  String get remindersTitle => 'Rappels';

  @override
  String get reminderPeriod => 'Règles bientôt';

  @override
  String get reminderFertile => 'Fenêtre fertile';

  @override
  String get reminderPill => 'Pilule quotidienne';

  @override
  String get reminderNote =>
      'Les notifications n\'affichent jamais de détails de santé. Elles disent seulement « Rappel Donzela ».';

  @override
  String get startApp => 'Commencer à utiliser Donzela';

  @override
  String get pinEnterTitle => 'Saisissez votre PIN';

  @override
  String get pinNewTitle => 'Choisissez un nouveau PIN';

  @override
  String get pinConfirmTitle => 'Ressaisissez le PIN';

  @override
  String get pinWrong => 'PIN incorrect. Réessayez.';

  @override
  String pinLockedFor(int seconds) {
    return 'Réessayez dans $seconds secondes';
  }

  @override
  String get forgotPin => 'PIN oublié ?';

  @override
  String get resetPinTitle => 'PIN oublié ?';

  @override
  String get resetPinBody =>
      'Vous pouvez supprimer toutes les données de ce téléphone. Si une sauvegarde en ligne existe, vous pouvez la restaurer.';

  @override
  String get deleteBtn => 'Supprimer';

  @override
  String get cancelBtn => 'Annuler';

  @override
  String get confirmBtn => 'Confirmer';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get saveBtn => 'Enregistrer';

  @override
  String get greetingMorning => 'Bonjour';

  @override
  String get greetingAfternoon => 'Bon après-midi';

  @override
  String get onWeekday => 'Le';

  @override
  String get todayCycleDay => 'Jour du cycle';

  @override
  String get phasePeriod => 'Règles';

  @override
  String get phaseFertile => 'Fenêtre fertile';

  @override
  String get phaseOvulation => 'Ovulation';

  @override
  String get phaseNormal => 'Normal';

  @override
  String get phasePredictedPeriod => 'Règles prévues';

  @override
  String nextPeriodIn(int days, String date) {
    return 'Prochaines règles dans $days jours · vers le $date';
  }

  @override
  String nextPeriodLate(String date) {
    return 'Règles en retard · prévues le $date';
  }

  @override
  String get estimateChip => 'Estimation';

  @override
  String get firstEstimate => 'Première estimation';

  @override
  String get getStartedTitle => 'Premiers pas';

  @override
  String get checkOnboarding => 'Inscription terminée';

  @override
  String get checkFirstCycle => 'Date des dernières règles enregistrée';

  @override
  String get checkPrediction => 'Première estimation prête';

  @override
  String get checkLogToday => 'Noté aujourd\'hui';

  @override
  String get firstUseBody =>
      'Notez vos 2 prochaines règles et Donzela apprendra comment fonctionne votre corps.';

  @override
  String get upcomingNotice =>
      'Les prévisions gagnent en précision avec le temps';

  @override
  String get estimatesOnly =>
      'Les prévisions sont des estimations et ne constituent pas un conseil contraceptif.';

  @override
  String get tipTitle => 'Conseil du jour';

  @override
  String get tipPeriod =>
      'Une bouillotte sur le ventre peut soulager les crampes. Reposez-vous si besoin.';

  @override
  String get tipFollicular =>
      'En début de cycle, vous pouvez vous sentir plus d\'énergie. C\'est un bon moment pour une activité légère.';

  @override
  String get tipFertile =>
      'Pendant les jours fertiles, vous pouvez vous sentir plus énergique et remarquer une glaire claire et filante. C\'est normal.';

  @override
  String get tipLuteal =>
      'Vous pouvez vous sentir fatiguée ou anxieuse. Boire de l\'eau et se reposer aide.';

  @override
  String get readMore => 'Lire la suite';

  @override
  String get todayTitle => 'Aujourd\'hui';

  @override
  String get calendarTab => 'Calendrier';

  @override
  String get learnTab => 'Apprendre';

  @override
  String get helpTab => 'Aide';

  @override
  String get calendarTitle => 'Calendrier';

  @override
  String get legendPeriod => 'Règles';

  @override
  String get legendPredicted => 'Prévues';

  @override
  String get legendFertile => 'Fertile';

  @override
  String get legendOvulation => 'Ovulation';

  @override
  String get historyTitle => 'Historique du cycle';

  @override
  String get avgCycle => 'Cycle moyen';

  @override
  String get avgPeriod => 'Règles moyennes';

  @override
  String daysCount(int n) {
    return '$n jours';
  }

  @override
  String get reportBtn => 'Rapport infirmier';

  @override
  String get confLow => 'Confiance faible';

  @override
  String get confMedium => 'Confiance moyenne';

  @override
  String get confHigh => 'Confiance élevée';

  @override
  String get flagIrregular =>
      'Vos cycles varient beaucoup. Lisez l\'article sur les cycles irréguliers.';

  @override
  String get flagLate => 'Vos règles ont plus de 7 jours de retard.';

  @override
  String get monthPrev => 'Mois précédent';

  @override
  String get monthNext => 'Mois suivant';

  @override
  String get dayStartQ => 'Vos règles ont-elles commencé aujourd\'hui ?';

  @override
  String get periodStartHere => 'Début des règles ici';

  @override
  String get periodEndHere => 'Fin des règles ici';

  @override
  String get periodEnded => 'Règles terminées';

  @override
  String get logSheetTitle => 'Noter aujourd\'hui';

  @override
  String get flowTitle => 'Flux';

  @override
  String get flowNone => 'Aucun';

  @override
  String get flowSpotting => 'Léger';

  @override
  String get flowMedium => 'Moyen';

  @override
  String get flowHeavy => 'Abondant';

  @override
  String get symptomsTitle => 'Symptômes';

  @override
  String get moodTitle => 'Comment vous vous sentez';

  @override
  String get notesTitle => 'Notes';

  @override
  String get notesHint => 'Autre chose à écrire ?';

  @override
  String get symptomCramps => 'Crampes';

  @override
  String get symptomHeadache => 'Maux de tête';

  @override
  String get symptomBackache => 'Mal de dos';

  @override
  String get symptomBloating => 'Ballonnements';

  @override
  String get symptomAcne => 'Acné';

  @override
  String get symptomBreast => 'Seins sensibles';

  @override
  String get symptomFatigue => 'Fatigue';

  @override
  String get moodCalm => 'Calme';

  @override
  String get moodHappy => 'Heureuse';

  @override
  String get moodSad => 'Triste';

  @override
  String get moodIrritable => 'Irritable';

  @override
  String get moodAnxious => 'Anxieuse';

  @override
  String get reportTitle => 'Rapport pour votre infirmier';

  @override
  String get reportSummary => 'Résumé du cycle';

  @override
  String get reportCycleCol => 'Cycle (jours)';

  @override
  String get reportPeriodCol => 'Règles (jours)';

  @override
  String get reportLast => 'Dernier';

  @override
  String get reportStartCol => 'Début';

  @override
  String get reportLengthCol => 'Durée';

  @override
  String get reportPeriodLenCol => 'Règles';

  @override
  String get reportSymptoms => 'Symptômes les plus notés';

  @override
  String get reportFooter =>
      'Créé par Donzela. Estimations uniquement, pas un diagnostic médical.';

  @override
  String get reportNoData => 'Aucunes règles enregistrées pour l\'instant.';

  @override
  String get sharePdf => 'Partager en PDF';

  @override
  String get showOnPhone => 'Afficher sur le téléphone';

  @override
  String get learnTitle => 'Apprendre';

  @override
  String get learnSubtitle => 'Chaque article est relu par une sage-femme';

  @override
  String get searchHint => 'ex. douleur des règles';

  @override
  String get filterAll => 'Tout';

  @override
  String get filterMine => 'Votre cycle';

  @override
  String get filterHygiene => 'Hygiène menstruelle';

  @override
  String get filterContraception => 'Contraception';

  @override
  String reviewedBy(String name, String date) {
    return 'Relu par $name, $date';
  }

  @override
  String get noArticles =>
      'Aucun article relu n\'est disponible pour l\'instant.';

  @override
  String get saveArticle => 'Enregistrer l\'article';

  @override
  String get savedArticle => 'Enregistré';

  @override
  String get helpTitle => 'Trouver de l\'aide';

  @override
  String get helpSubtitle =>
      'Services gratuits qui respectent votre vie privée, près de vous';

  @override
  String get emergencyTitle => 'Aide d\'urgence';

  @override
  String get isangeCentre => 'Isange One Stop Centre';

  @override
  String get ambulance => 'Ambulance (SAMU)';

  @override
  String get yourDistrict => 'Votre district';

  @override
  String get centresNone =>
      'Les centres de santé de ce district ne sont pas encore listés.';

  @override
  String get callBtn => 'Appeler';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get sectionPrefs => 'PRÉFÉRENCES';

  @override
  String get sectionPrivacy => 'CONFIDENTIALITÉ';

  @override
  String get languageSetting => 'Langue';

  @override
  String get pinSetting => 'Verrouillage par PIN';

  @override
  String get changePin => 'Modifier le PIN';

  @override
  String get analyticsSetting => 'Statistiques d\'utilisation';

  @override
  String get analyticsNote =>
      'Chiffres sans information de santé, pour aider à améliorer Donzela. Vous pouvez les désactiver.';

  @override
  String get backupSetting => 'Sauvegarde en ligne';

  @override
  String get backupNote =>
      'Vos données de cycle sont uniquement sur ce téléphone. Activez la sauvegarde pour ne pas les perdre si vous changez de téléphone.';

  @override
  String get backupExplain =>
      'La sauvegarde envoie les données de votre cycle en ligne. Nous vous demanderons d\'abord votre accord.';

  @override
  String get backupConsentBtn => 'J\'accepte';

  @override
  String get backupUnavailable =>
      'La sauvegarde en ligne n\'est pas encore disponible dans cette version.';

  @override
  String get deleteAllBtn => 'Supprimer toutes mes données';

  @override
  String get deleteAllTitle => 'Supprimer toutes les données ?';

  @override
  String get deleteAllBody =>
      'Cela supprime toutes les données de ce téléphone et du cloud. Action irréversible.';

  @override
  String get privacyPolicyLink => 'Politique de confidentialité';

  @override
  String get firstNameLabel => 'Votre prénom (facultatif)';

  @override
  String get setPinBtn => 'Définir le PIN';

  @override
  String get remindersOff => 'Rappels désactivés';

  @override
  String get reminderPeriodText => 'Rappels des règles';

  @override
  String get notifTitle => 'Rappel Donzela';

  @override
  String get notifBody => 'Ouvrez Donzela pour voir';

  @override
  String get pillTimeLabel => 'Heure de la pilule';

  @override
  String get genericError => 'Une erreur s\'est produite. Réessayez.';

  @override
  String get deleteDone => 'Données supprimées.';

  @override
  String get m1 => 'janvier';

  @override
  String get m2 => 'février';

  @override
  String get m3 => 'mars';

  @override
  String get m4 => 'avril';

  @override
  String get m5 => 'mai';

  @override
  String get m6 => 'juin';

  @override
  String get m7 => 'juillet';

  @override
  String get m8 => 'août';

  @override
  String get m9 => 'septembre';

  @override
  String get m10 => 'octobre';

  @override
  String get m11 => 'novembre';

  @override
  String get m12 => 'décembre';

  @override
  String get w1 => 'Lu';

  @override
  String get w2 => 'Ma';

  @override
  String get w3 => 'Me';

  @override
  String get w4 => 'Je';

  @override
  String get w5 => 'Ve';

  @override
  String get w6 => 'Sa';

  @override
  String get w7 => 'Di';

  @override
  String get d1 => 'lundi';

  @override
  String get d2 => 'mardi';

  @override
  String get d3 => 'mercredi';

  @override
  String get d4 => 'jeudi';

  @override
  String get d5 => 'vendredi';

  @override
  String get d6 => 'samedi';

  @override
  String get d7 => 'dimanche';

  @override
  String get appFooter => 'Donzela 1.0 · Conçu à Kigali';

  @override
  String get logToday => 'Noter aujourd\'hui';

  @override
  String get draftBadge => 'Brouillon, pas encore relu';

  @override
  String get logsTitle => 'Mes notes';

  @override
  String get logsOpenBtn => 'Mes notes';

  @override
  String get tabLogs => 'Journal';

  @override
  String get tabInsights => 'Statistiques';

  @override
  String get noLogs =>
      'Aucune journée notée pour l\'instant. Vos notes apparaîtront ici.';

  @override
  String get logDeleteTitle => 'Supprimer cette note ?';

  @override
  String get logDeleteBody =>
      'Ce que vous avez noté pour ce jour sera supprimé. Action irréversible.';

  @override
  String insightsDaysLogged(int n) {
    return 'Jours notés : $n';
  }

  @override
  String insightsCyclesTracked(int n) {
    return 'Cycles suivis : $n';
  }

  @override
  String insightsCycleRange(int min, int max) {
    return 'Durée du cycle : $min–$max jours';
  }

  @override
  String get insightsSymptoms => 'Symptômes les plus fréquents';

  @override
  String get insightsMoods => 'Humeurs les plus fréquentes';

  @override
  String get insightsFlow => 'Flux pendant les règles';

  @override
  String get insightsByPhase => 'Selon la phase du cycle';

  @override
  String insightsCountOf(int count, int total) {
    return '$count jours sur $total';
  }

  @override
  String get insightsNoData => 'Notez quelques jours pour voir vos tendances.';

  @override
  String get insightsDisclaimer =>
      'Ces chiffres ne viennent que de vos notes. Ce n\'est pas un diagnostic médical.';

  @override
  String get noteEmpty => 'Aucune note';

  @override
  String get authSignIn => 'Se connecter avec Google';

  @override
  String get authSignOut => 'Se déconnecter';

  @override
  String authSignedInAs(String email) {
    return 'Connecté en tant que $email';
  }

  @override
  String get authSignInFailed => 'La connexion n\'a pas abouti. Réessayez.';

  @override
  String get cloudUnavailable =>
      'La sauvegarde n\'est pas disponible pour le moment. Réessayez plus tard.';

  @override
  String get restoreHint =>
      'Vous utilisez déjà Donzela ? Connectez-vous pour restaurer vos données.';

  @override
  String get restoreFound => 'Vos données sont restaurées.';

  @override
  String get restoreNone =>
      'Aucune sauvegarde pour ce compte. Continuez l\'inscription.';

  @override
  String get backupStarted =>
      'Sauvegarde activée. Les changements sont envoyés au fur et à mesure.';

  @override
  String get legendToday => 'Aujourd\'hui';

  @override
  String get centreNextPeriodLabel => 'Règles dans';

  @override
  String get centreDaysUnit => 'jours';

  @override
  String get centreLate => 'Règles en retard';

  @override
  String fertileWindowLine(String from, String to) {
    return 'Fenêtre fertile : $from – $to';
  }

  @override
  String todayLoggedLine(String items) {
    return 'Notée aujourd\'hui : $items';
  }

  @override
  String get insightsShortcut => 'Voir vos statistiques';

  @override
  String get entryTimeLabel => 'Heure';

  @override
  String get editEntryTitle => 'Modifier la note';

  @override
  String get entriesToday => 'Notes de la journée';

  @override
  String get filterByDate => 'Filtrer par date';

  @override
  String get clearFilter => 'Effacer le filtre';

  @override
  String get addEntryBtn => 'Ajouter';

  @override
  String get noEntriesOnDay => 'Rien noté ce jour.';

  @override
  String get goToday => 'Aujourd\'hui';

  @override
  String get regularCycles => 'Cycles réguliers';

  @override
  String get irregularCycles => 'Cycles irréguliers';

  @override
  String get navAccount => 'Compte';

  @override
  String get accountTitle => 'Compte';

  @override
  String get accountSignedOutBody =>
      'Connectez-vous avec Google pour sauvegarder vos données, les partager entre téléphones et les restaurer au besoin.';

  @override
  String get accountBackupOff =>
      'Sauvegarde désactivée. Vos données restent sur ce téléphone.';

  @override
  String get accountBackupOn =>
      'Sauvegarde activée. Les changements sont envoyés au fil de l\'eau.';

  @override
  String accountLastSync(String when) {
    return 'Dernière synchronisation : $when';
  }

  @override
  String get accountNeverSynced => 'Pas encore synchronisé';

  @override
  String accountPending(int n) {
    return 'En attente : $n';
  }

  @override
  String get accountSyncNow => 'Synchroniser';

  @override
  String get accountSyncDone => 'Synchronisé.';

  @override
  String get accountPull => 'Récupérer les mises à jour';

  @override
  String get accountPullBody =>
      'Récupère vos notes, cycles et réglages depuis le cloud, ainsi que les derniers articles et centres de santé. Vous choisissez quand.';

  @override
  String accountPulled(int n) {
    return 'Restauré : $n éléments';
  }

  @override
  String get accountNothingNew => 'Rien de nouveau.';

  @override
  String get accountTurnOnBackup => 'Activer la sauvegarde';

  @override
  String get accountBusy => 'En cours...';

  @override
  String get adminBadge => 'Super-administrateur';

  @override
  String get adminOnlyBadgeBody =>
      'Vous êtes super-administrateur : vous pouvez ajouter, modifier et supprimer les articles Apprendre et tout le contenu Aide.';

  @override
  String get adminAddArticle => 'Ajouter un article';

  @override
  String get adminEditArticle => 'Modifier l\'article';

  @override
  String get adminDeleteBody => 'Cela sera supprimé pour tout le monde.';

  @override
  String get fieldTitle => 'Titre';

  @override
  String get fieldBody => 'Texte complet (Markdown)';

  @override
  String get fieldCategory => 'Catégorie';

  @override
  String get fieldLanguage => 'Langue';

  @override
  String get fieldReviewer => 'Relu par (vide si non relu)';

  @override
  String get adminEditHelp => 'Modifier les numéros d\'urgence';

  @override
  String get fieldIsangeNumber => 'Numéro d\'Isange One Stop Centre';

  @override
  String get fieldAmbulanceNumber => 'Numéro de l\'ambulance';

  @override
  String get adminAddCentre => 'Ajouter un centre de santé';

  @override
  String get adminEditCentre => 'Modifier le centre de santé';

  @override
  String get fieldDistrict => 'District';

  @override
  String get fieldSector => 'Secteur';

  @override
  String get fieldName => 'Nom';

  @override
  String get fieldPhone => 'Téléphone';

  @override
  String get fieldServices => 'Services';

  @override
  String get adminSaved => 'Enregistré.';

  @override
  String get adminRequired => 'Remplissez le titre et le texte.';

  @override
  String accountProgress(int percent) {
    return '$percent % terminé';
  }

  @override
  String get backupNotOnTitle => 'La sauvegarde n\'est pas activée';

  @override
  String get backupNotOnBody =>
      'La sauvegarde n\'a pas pu être activée car la connexion Google n\'a pas abouti. Réessayez.';

  @override
  String get backupRetryBtn => 'Réessayer';

  @override
  String get okBtn => 'OK';

  @override
  String get adminSavedLocal =>
      'Enregistré sur ce téléphone. Il sera envoyé dans le cloud dès que vous serez en ligne.';

  @override
  String get newDistrictNote =>
      'Nouveau district. Il sera ajouté à la liste à l\'enregistrement.';

  @override
  String get districtPickNote => 'Choisissez un district ou tapez-en un autre.';

  @override
  String get categoryHint =>
      'Choisissez une catégorie ou tapez-en une nouvelle.';

  @override
  String get editTab => 'Écrire';

  @override
  String get previewTab => 'Aperçu';

  @override
  String get previewEmpty => 'Rien à afficher pour l\'instant.';

  @override
  String get boldTip => 'Gras';

  @override
  String get italicTip => 'Italique';

  @override
  String get headingTip => 'Titre';

  @override
  String get listTip => 'Liste à puces';

  @override
  String get quoteTip => 'Citation';

  @override
  String get linkTip => 'Lien';

  @override
  String get emergencyManage => 'Numéros d\'urgence';

  @override
  String get emergencyAdd => 'Ajouter un numéro';

  @override
  String get emergencyEdit => 'Modifier le numéro';

  @override
  String get emergencyNone => 'Aucun numéro d\'urgence pour l\'instant.';

  @override
  String get translationsTitle => 'Langues';

  @override
  String get statusPublished => 'Publié';

  @override
  String get statusDraft => 'Brouillon';

  @override
  String get statusMissing => 'Manquant';

  @override
  String get translateNow => 'Traduire';

  @override
  String get translateArticle => 'Traduire l\'article';

  @override
  String get saveDraftBtn => 'Enregistrer le brouillon';

  @override
  String get publishAllBtn => 'Publier dans toutes les langues';

  @override
  String get publishedAll => 'Publié dans toutes les langues.';

  @override
  String get publishNotReady => 'Pas prêt à publier';

  @override
  String get reviewerLabel => 'Relecteur (cette langue)';

  @override
  String get reviewerHint => 'Laisser vide pour afficher l\'équipe Donzela.';

  @override
  String writtenBy(String name) {
    return 'Écrit par $name';
  }

  @override
  String get accountPullPublicBody =>
      'Récupérez les derniers articles et numéros d\'aide de Donzela.';

  @override
  String get accountContentUpdated =>
      'Les derniers articles et informations d\'aide sont à jour.';

  @override
  String get adminUsersTitle => 'Administrateurs';

  @override
  String get adminUsersBody =>
      'Les administrateurs peuvent modifier Apprendre et Aide. Une personne le devient quand vous ajoutez son e-mail ici.';

  @override
  String get adminUsersEmailLabel => 'E-mail Google';

  @override
  String get adminUsersEmailHint => 'Par exemple : nom@gmail.com';

  @override
  String get adminUsersAdd => 'Ajouter un administrateur';

  @override
  String get adminUsersListTitle =>
      'Personnes avec des droits d\'administration';

  @override
  String get adminUsersNone => 'Aucun autre administrateur pour l\'instant.';

  @override
  String get adminUsersRemove => 'Retirer l\'administrateur';

  @override
  String get adminUsersRemoveTitle => 'Retirer cet administrateur ?';

  @override
  String get adminUsersInvalid => 'Saisissez un e-mail valide';

  @override
  String get adminUsersOwner =>
      'C\'est le compte propriétaire, il ne peut pas être retiré';

  @override
  String get adminUsersRoleOwner => 'Propriétaire';

  @override
  String get adminUsersRoleAdmin => 'Administrateur';

  @override
  String get adminUsersRoleUser => 'Membre';

  @override
  String get adminUsersMakeAdmin => 'Rendre administrateur';

  @override
  String accountWelcome(String name) {
    return 'Bienvenue, $name';
  }

  @override
  String createdOn(String date) {
    return 'Créé le $date';
  }

  @override
  String publishedOn(String date) {
    return 'Publié le $date';
  }

  @override
  String updatedOn(String date) {
    return 'Mis à jour le $date';
  }

  @override
  String get onboardingPullContent =>
      'Télécharger les derniers articles et l\'aide';

  @override
  String get contentPullFailed =>
      'Impossible de récupérer le contenu. Vérifiez votre connexion.';

  @override
  String get lastPeriodOptional =>
      'Vous pouvez passer cette étape et l\'ajouter plus tard depuis le calendrier.';

  @override
  String get refreshContent => 'Actualiser les articles et l\'aide';

  @override
  String get accountSyncNowBody =>
      'Vos données restent sur ce téléphone. Synchroniser envoie vos dernières modifications sur votre compte Google et enregistre l\'heure de fin.';

  @override
  String get accountSyncOffBody =>
      'Activez d\'abord la sauvegarde dans les Réglages. Vos modifications pourront ensuite être envoyées sur votre compte Google.';

  @override
  String get healthTitle => 'Outils santé';

  @override
  String get healthSubtitle =>
      'Estimations rapides à partir des dates saisies. Elles se mettent à jour quand vous les modifiez.';

  @override
  String get healthSectionCycle => 'Votre cycle';

  @override
  String get healthSectionPregnancy => 'Grossesse';

  @override
  String get healthDisclaimer =>
      'Ce sont des estimations, pas des conseils médicaux. Parlez à un agent de santé pour les décisions concernant votre santé.';

  @override
  String get toolNextPeriodTitle => 'Prochaines règles';

  @override
  String get toolNextPeriodBody =>
      'Quand vos prochaines règles devraient commencer, selon la durée habituelle de votre cycle.';

  @override
  String get toolFertileTitle => 'Jours fertiles';

  @override
  String get toolFertileBody =>
      'Les jours où une grossesse est possible, et quand l\'ovulation est probable.';

  @override
  String get toolImplantTitle => 'Période d\'implantation';

  @override
  String get toolImplantBody =>
      'Quand un embryon s\'implante habituellement dans l\'utérus après l\'ovulation.';

  @override
  String get toolCycleLengthTitle => 'Durée du cycle';

  @override
  String get toolCycleLengthBody =>
      'Comptez les jours entre le début de deux règles.';

  @override
  String get toolDueDateTitle => 'Date prévue d\'accouchement';

  @override
  String get toolDueDateBody =>
      'Date estimée d\'accouchement, comptée à partir du premier jour de vos dernières règles.';

  @override
  String get toolWeeksTitle => 'Semaines en mois';

  @override
  String get toolWeeksBody =>
      'Convertissez les semaines de grossesse en mois et semaines.';

  @override
  String get healthLastPeriod => 'Premier jour de vos dernières règles';

  @override
  String get healthUsualCycle => 'Durée habituelle du cycle';

  @override
  String get healthPreviousPeriod => 'Premier jour des règles précédentes';

  @override
  String get healthNextPeriodStart => 'Premier jour des règles suivantes';

  @override
  String get healthWeeksPregnant => 'Semaines de grossesse';

  @override
  String get healthWeeksUnit => 'semaines';

  @override
  String get healthResultNextPeriod => 'Prochaines règles vers le';

  @override
  String get healthResultOvulation => 'Ovulation vers le';

  @override
  String get healthResultFertile => 'Jours fertiles';

  @override
  String get healthResultImplant => 'Implantation probable entre le';

  @override
  String get healthResultCycleLength => 'Durée du cycle';

  @override
  String get healthResultDue => 'Date prévue d\'accouchement';

  @override
  String get healthResultAge => 'Enceinte depuis';

  @override
  String get healthResultMonths => 'Environ';

  @override
  String get healthCycleOut =>
      'Un cycle dure en général 21 à 45 jours. Vérifiez les deux dates.';

  @override
  String get healthTo => 'au';

  @override
  String get healthLess => 'Diminuer';

  @override
  String get healthMore => 'Augmenter';

  @override
  String healthDays(int n) {
    return '$n jours';
  }

  @override
  String healthWeekDays(int weeks, int days) {
    return '$weeks semaines et $days jours';
  }

  @override
  String healthMonthsWeeks(int months, int weeks) {
    return '$months mois et $weeks semaines';
  }
}
