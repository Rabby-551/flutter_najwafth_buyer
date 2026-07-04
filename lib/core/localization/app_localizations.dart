import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [
    Locale('en'),
    Locale('fr'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(localizations != null, 'AppLocalizations not found in context.');
    return localizations!;
  }

  bool get isFrench => locale.languageCode == 'fr';

  String get appName => isFrench ? 'Books on Wheels' : 'Books on Wheels';
  String get home => isFrench ? 'Accueil' : 'Home';
  String get order => isFrench ? 'Commande' : 'Order';
  String get cart => isFrench ? 'Panier' : 'Cart';
  String get profile => isFrench ? 'Profil' : 'Profile';
  String get retry => isFrench ? 'Réessayer' : 'Retry';
  String get save => isFrench ? 'Enregistrer' : 'Save';
  String get cancel => isFrench ? 'Annuler' : 'Cancel';
  String get post => isFrench ? 'Publier' : 'Post';
  String get continueLabel => isFrench ? 'Continuer' : 'Continue';
  String get seeAll => isFrench ? 'Voir tout' : 'See all';
  String get searchResults => isFrench ? 'Résultats de recherche' : 'Search Results';
  String get goodMorning => isFrench ? 'Bonjour !' : 'Hi, Good Morning!';
  String get featuredBookstores =>
      isFrench ? 'Librairies en vedette' : 'Featured Bookstores';
  String get categories => isFrench ? 'Catégories' : 'Categories';
  String get popularBooks => isFrench ? 'Livres populaires' : 'Popular Books';
  String get noPopularBooksAvailable =>
      isFrench ? 'Aucun livre populaire disponible' : 'No popular books available';
  String get noBooksMatchSearch =>
      isFrench ? 'Aucun livre ne correspond à votre recherche.' : 'No books match your search.';
  String get searchHint =>
      isFrench ? 'Rechercher des livres, auteurs, boutiques...' : 'Search books, authors, stores...';
  String get couldNotLoadBooks =>
      isFrench ? 'Impossible de charger les livres' : 'Could not load books';

  String get userEmail => isFrench ? 'E-mail utilisateur' : 'User Email';
  String get yourEmail => isFrench ? 'Votre e-mail' : 'Your Email';
  String get enterYourEmail => isFrench ? 'Entrez votre e-mail' : 'Enter your Email';
  String get password => isFrench ? 'Mot de passe' : 'Password';
  String get enterYourPassword =>
      isFrench ? 'Entrez votre mot de passe' : 'Enter your Password';
  String get rememberMe => isFrench ? 'Se souvenir de moi' : 'Remember me';
  String get forgotPassword =>
      isFrench ? 'Mot de passe oublié ?' : 'Forgot password?';
  String get signIn => isFrench ? 'Se connecter' : 'Sign in';
  String get signUp => isFrench ? 'S’inscrire' : 'Sign up';
  String get dontHaveAccount =>
      isFrench ? 'Vous n’avez pas de compte ?' : 'Don’t have an account?';
  String get alreadyHaveAccount =>
      isFrench ? 'Vous avez déjà un compte ?' : 'Already have an account?';
  String get signUpHere => isFrench ? 'Inscrivez-vous ici' : 'Sign Up Here';
  String get signInHere => isFrench ? 'Connectez-vous ici' : 'Sign In Here';
  String get continueWithGoogle =>
      isFrench ? 'Continuer avec Google' : 'Continue with Google';
  String get continueWithFacebook =>
      isFrench ? 'Continuer avec Facebook' : 'Continue with Facebook';
  String get googleNotConfigured =>
      isFrench ? 'La connexion Google n’est pas encore configurée.' : 'Google sign-in is not configured yet.';
  String get facebookNotConfigured =>
      isFrench ? 'La connexion Facebook n’est pas encore configurée.' : 'Facebook sign-in is not configured yet.';
  String get letsGetStarted =>
      isFrench ? 'Commençons !' : 'Let’s Get Started!';
  String get createAnAccount =>
      isFrench ? 'Créer un compte' : 'Create an account';
  String get userName => isFrench ? 'Nom d’utilisateur' : 'User Name';
  String get enterYourFirstName =>
      isFrench ? 'Entrez votre prénom' : 'Enter your First Name';
  String get enterYourName =>
      isFrench ? 'Entrez votre nom' : 'Enter your name';
  String get phoneNumber => isFrench ? 'Numéro de téléphone' : 'Phone Number';
  String get enterYourPhoneNumber =>
      isFrench ? 'Entrez votre numéro de téléphone' : 'Enter your phone number';
  String get enterYourAddress =>
      isFrench ? 'Entrez votre adresse' : 'Enter your address';
  String get confirmPassword =>
      isFrench ? 'Confirmer le mot de passe' : 'Confirm Password';
  String get currentPassword =>
      isFrench ? 'Mot de passe actuel' : 'Current Password';
  String get confirmNewPassword =>
      isFrench ? 'Confirmer le nouveau mot de passe' : 'Confirm New Password';
  String get enterConfirmPassword =>
      isFrench ? 'Entrez la confirmation du mot de passe' : 'Enter Confirm Password';
  String get resetPassword =>
      isFrench ? 'Réinitialiser le mot de passe' : 'Reset password';
  String get resetPasswordTitle =>
      isFrench ? 'Réinitialiser le mot de passe' : 'Reset Password';
  String get enterEmailToReceiveOtp =>
      isFrench ? 'Entrez votre e-mail pour recevoir le code OTP' : 'Enter your email to receive the OTP';
  String get sendOtp => isFrench ? 'Envoyer le code OTP' : 'Send OTP';
  String get otpSentToEmail =>
      isFrench ? 'Un code OTP a été envoyé à votre adresse e-mail.' : 'An OTP has been sent to your email address.';
  String get enterOtp => isFrench ? 'Entrer le code OTP' : 'Enter OTP';
  String get enterCompleteOtp =>
      isFrench ? 'Entrez le code OTP complet à 6 chiffres.' : 'Enter the complete 6-digit OTP.';
  String waitBeforeResendingOtp(int seconds) => isFrench
      ? 'Veuillez attendre ${seconds}s avant de renvoyer le code OTP.'
      : 'Please wait ${seconds}s before resending OTP.';
  String get newOtpSent =>
      isFrench ? 'Un nouveau code OTP a été envoyé à votre adresse e-mail.' : 'A new OTP has been sent to your email address.';
  String get sendingNewOtp =>
      isFrench ? 'Envoi d’un nouveau code OTP...' : 'Sending a new OTP...';
  String resendCodeIn(int seconds) =>
      isFrench ? 'Renvoyer le code dans ${seconds}s' : 'Resend code in ${seconds}s';
  String get canResendOtpNow =>
      isFrench ? 'Vous pouvez renvoyer le code OTP maintenant' : 'You can resend the OTP now';
  String get didntReceiveOtp =>
      isFrench ? 'Vous n’avez pas reçu le code OTP ?' : 'Didn’t Receive OTP?';
  String get resendOtp => isFrench ? 'RENVOYER LE CODE OTP' : 'RESEND OTP';
  String get verifyNow => isFrench ? 'Vérifier maintenant' : 'Verify Now';
  String get enterAndConfirmNewPassword =>
      isFrench ? 'Entrez et confirmez votre nouveau mot de passe' : 'Enter and confirm your new password';
  String get newPassword => isFrench ? 'Nouveau mot de passe' : 'New Password';
  String get passwordResetSuccessfully =>
      isFrench ? 'Mot de passe réinitialisé avec succès.' : 'Password reset successfully.';
  String get fillRequiredPasswordFields => isFrench
      ? 'Veuillez remplir tous les champs de mot de passe requis.'
      : 'Please fill in all required password fields.';
  String get newAndConfirmPasswordDoNotMatch => isFrench
      ? 'Le nouveau mot de passe et sa confirmation ne correspondent pas.'
      : 'New password and confirm password do not match.';
  String get passwordChangedSuccessfully =>
      isFrench ? 'Mot de passe modifié avec succès.' : 'Password changed successfully.';

  String get skip => isFrench ? 'Passer' : 'Skip';
  String get getStarted => isFrench ? 'Commencer' : 'Get Started';
  String get next => isFrench ? 'Suivant' : 'Next';
  String get discoverBooks => isFrench ? 'Découvrir des livres' : 'Discover Books';
  String get discoverBooksSubtitle => isFrench
      ? 'Parcourez une sélection de livres et trouvez votre prochaine lecture favorite en quelques secondes.'
      : 'Browse a curated collection and find your next favorite read in seconds.';
  String get quickDelivery => isFrench ? 'Livraison rapide' : 'Quick Delivery';
  String get quickDeliverySubtitle => isFrench
      ? 'Recevez rapidement les livres sélectionnés, de manière fiable, directement à votre porte.'
      : 'Get your selected books delivered fast, reliably, and right to your door.';
  String get trackOrders => isFrench ? 'Suivre les commandes' : 'Track Orders';
  String get trackOrdersSubtitle => isFrench
      ? 'Suivez votre commande du paiement à la livraison grâce à un suivi simple.'
      : 'Stay updated from checkout to doorstep with a simple order tracking flow.';

  String get myCart => isFrench ? 'Mon panier' : 'My Cart';
  String get yourCartIsEmpty =>
      isFrench ? 'Votre panier est vide' : 'Your cart is empty';
  String get cartEmptyMessage => isFrench
      ? 'Il semble que vous n’ayez pas encore ajouté de livres à votre panier.'
      : 'Looks like you haven\'t added any books to your cart yet.';
  String get browseBooks => isFrench ? 'Parcourir les livres' : 'Browse Books';
  String get totalPrice => isFrench ? 'Prix total' : 'Total Price';
  String get proceedToCheckout =>
      isFrench ? 'Passer au paiement' : 'Proceed to Checkout';
  String get paymentDetails =>
      isFrench ? 'Détails du paiement' : 'Payment details';
  String get checkout => isFrench ? 'Paiement' : 'Checkout';
  String get completeOrderDetails =>
      isFrench ? 'Complétez les détails de votre commande' : 'Complete your order details';
  String get name => isFrench ? 'Nom' : 'Name';
  String get address => isFrench ? 'Adresse' : 'Address';
  String get orderSummary => isFrench ? 'Récapitulatif de commande' : 'Order Summary';
  String get subtotal => isFrench ? 'Sous-total' : 'Subtotal';
  String get deliveryFee => isFrench ? 'Frais de livraison' : 'Delivery fee';
  String get total => isFrench ? 'Total' : 'Total';
  String get payment => isFrench ? 'Paiement' : 'Payment';
  String get placeOrder => isFrench ? 'Passer la commande' : 'Place Order';
  String get cartIsEmpty => isFrench ? 'Le panier est vide' : 'Cart is empty';
  String get orderConfirmed =>
      isFrench ? 'Commande confirmée' : 'Order Confirmed';
  String get orderPlacedSuccessfully =>
      isFrench ? 'Votre commande a été passée avec succès !' : 'Your order has been placed successfully!';
  String get status => isFrench ? 'Statut' : 'Status';
  String get backToHome => isFrench ? 'Retour à l’accueil' : 'Back to Home';
  String get stripe => 'Stripe';
  String get paypal => 'PayPal';

  String get myOrders => isFrench ? 'Mes commandes' : 'My Orders';
  String get all => isFrench ? 'Toutes' : 'All';
  String get pending => isFrench ? 'En attente' : 'Pending';
  String get processing => isFrench ? 'En cours' : 'Processing';
  String get picked => isFrench ? 'Récupérée' : 'Picked';
  String get delivered => isFrench ? 'Livrée' : 'Delivered';
  String get cancelled => isFrench ? 'Annulée' : 'Cancelled';
  String get failedToLoadOrders =>
      isFrench ? 'Échec du chargement des commandes' : 'Failed to load orders';
  String get noOrdersFound =>
      isFrench ? 'Aucune commande trouvée' : 'No orders found';
  String get completed => isFrench ? 'Terminée' : 'Completed';
  String get orderDetails => isFrench ? 'Détails de la commande' : 'Order Details';
  String get orderStatus => isFrench ? 'Statut de la commande' : 'Order Status';
  String get deliveryAddress =>
      isFrench ? 'Adresse de livraison' : 'Delivery Address';
  String get contactInformation =>
      isFrench ? 'Coordonnées' : 'Contact Information';
  String get orderDate => isFrench ? 'Date de commande :' : 'Order Date:';
  String get phone => isFrench ? 'Téléphone :' : 'Phone:';
  String get orderId => isFrench ? 'ID de commande :' : 'Order ID:';
  String itemsCount(int count) => isFrench ? 'Articles ($count)' : 'Items ($count)';
  String get leaveAReview =>
      isFrench ? 'Laisser un avis' : 'Leave a Review';
  String get unknownItem => isFrench ? 'Article inconnu' : 'Unknown Item';
  String itemCount(int count) => isFrench ? '$count article(s)' : '$count items';
  String get orderReceivedByStore =>
      isFrench ? 'Commande reçue par la boutique' : 'Order received by store';
  String get storePreparingOrder =>
      isFrench ? 'La boutique prépare votre commande' : 'Store is preparing your order';
  String get deliveryPartnerPickedUpOrder =>
      isFrench ? 'Le livreur a récupéré la commande' : 'Delivery partner picked up order';
  String get orderDeliveredSuccessfully =>
      isFrench ? 'Commande livrée avec succès' : 'Order delivered successfully';

  String get general => isFrench ? 'Général' : 'General';
  String get description => isFrench ? 'Description' : 'Description';
  String get noDescriptionAvailable =>
      isFrench ? 'Aucune description disponible.' : 'No description available.';
  String get noBooksFoundInCategory =>
      isFrench ? 'Aucun livre trouvé dans cette catégorie' : 'No books found in this category';
  String get showLess => isFrench ? 'Voir moins' : 'Show less';
  String get readMore => isFrench ? 'Lire plus' : 'Read more';
  String get addToCart => isFrench ? 'Ajouter au panier' : 'Add to Cart';
  String get outOfStock => isFrench ? 'Rupture de stock' : 'Out of Stock';
  String addedToCart(String title) =>
      isFrench ? '$title ajouté au panier' : '$title added to cart';

  String get editProfile => isFrench ? 'Modifier le profil' : 'Edit Profile';
  String get changePassword =>
      isFrench ? 'Changer le mot de passe' : 'Change Password';
  String get orderHistory => isFrench ? 'Historique des commandes' : 'Order History';
  String get aboutApp => isFrench ? 'À propos de l’application' : 'About App';
  String get privacyPolicy =>
      isFrench ? 'Politique de confidentialité' : 'Privacy Policy';
  String get termsAndConditions =>
      isFrench ? 'Conditions générales' : 'Terms & Conditions';
  String get language => isFrench ? 'Langue' : 'Language';
  String get pushNotifications =>
      isFrench ? 'Notifications push' : 'Push Notifications';
  String get logOut => isFrench ? 'Se déconnecter' : 'Log Out';
  String get chooseLanguage =>
      isFrench ? 'Choisir la langue' : 'Choose Language';
  String get english => 'English';
  String get france => 'France';
  String get unitedKingdom => isFrench ? 'Royaume-Uni' : 'United Kingdom';
  String get franceCountry => 'France';
  String get aboutAppContent => isFrench
      ? 'Najwafth Buyer vous aide à découvrir, commander et suivre facilement vos livres préférés depuis une seule application.'
      : 'Najwafth Buyer helps you discover, order, and track your favorite books from a single app experience.';
  String get privacyPolicyContent => isFrench
      ? 'Nous utilisons vos informations uniquement pour traiter les commandes, améliorer l’expérience de l’application et fournir une assistance client sécurisée.'
      : 'We use your information only to process orders, improve the app experience, and provide secure customer support.';
  String get termsAndConditionsContent => isFrench
      ? 'En utilisant cette application, vous acceptez de fournir des informations exactes, de respecter les règles de la plateforme et de suivre les conditions de commande et de paiement.'
      : 'By using this app, you agree to provide accurate information, follow platform rules, and comply with ordering and payment terms.';
  String get areYouSureToLogout =>
      isFrench ? 'Êtes-vous sûr de vouloir vous déconnecter ?' : 'Are you sure to log out?';

  String get notifications => isFrench ? 'Notifications' : 'Notifications';
  String get markAllRead =>
      isFrench ? 'Tout marquer comme lu' : 'Mark all read';
  String get failedToLoadNotifications =>
      isFrench ? 'Échec du chargement des notifications' : 'Failed to load notifications';
  String get noNotificationsYet =>
      isFrench ? 'Aucune notification pour le moment' : 'No notifications yet';
  String get newLabel => isFrench ? 'Nouvelles' : 'New';
  String get earlier => isFrench ? 'Plus tôt' : 'Earlier';
  String get now => isFrench ? 'maintenant' : 'now';
  String minutesAgoShort(int minutes) => isFrench ? '${minutes}min' : '${minutes}m';
  String hoursAgoShort(int hours) => isFrench ? '${hours}h' : '${hours}h';
  String daysAgoShort(int days) => isFrench ? '${days}j' : '${days}d';

  String get writeShortReview => isFrench
      ? 'Écrivez un court avis pour aider les autres lecteurs...'
      : 'Write a short review to help fellow books lovers...';
  String get rateThisOrder =>
      isFrench ? 'Évaluez cette commande' : 'Rate this order';
  String get selectRating =>
      isFrench ? 'Veuillez sélectionner une note.' : 'Please select a rating.';
  String get reviewSubmitted =>
      isFrench ? 'Merci pour votre avis !' : 'Thanks for your review!';

  String get requiredField => isFrench ? 'Ce champ' : 'This field';
  String requiredMessage(String label) =>
      isFrench ? '$label est requis.' : '$label is required.';
  String get emailLabel => isFrench ? 'E-mail' : 'Email';
  String get enterValidEmail =>
      isFrench ? 'Entrez une adresse e-mail valide.' : 'Enter a valid email address.';
  String minLengthMessage(String label, int length) => isFrench
      ? '$label doit contenir au moins $length caractères.'
      : '$label must be at least $length characters.';
  String get valueLabel => isFrench ? 'Valeur' : 'Value';
  String get fullNameLabel => isFrench ? 'Nom complet' : 'Full name';
  String get confirmPasswordLabel =>
      isFrench ? 'Confirmation du mot de passe' : 'Confirm password';
  String get passwordsDoNotMatch =>
      isFrench ? 'Les mots de passe ne correspondent pas.' : 'Passwords do not match.';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any(
        (supported) => supported.languageCode == locale.languageCode,
      );

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
