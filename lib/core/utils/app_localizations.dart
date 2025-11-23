import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  bool get isArabic => locale.languageCode == 'ar';

  // Common translations
  String get appName => isArabic ? 'رفيق' : 'RAFEEQ';
  
  // Auth
  String get welcomeBack => isArabic ? 'مرحباً بعودتك!' : 'Welcome back!';
  String get signIn => isArabic ? 'تسجيل الدخول' : 'Sign In';
  String get signUp => isArabic ? 'إنشاء حساب' : 'Sign Up';
  String get email => isArabic ? 'البريد الإلكتروني' : 'Email';
  String get password => isArabic ? 'كلمة المرور' : 'Password';
  String get forgotPassword => isArabic ? 'نسيت كلمة المرور؟' : 'Forgot Password?';
  String get dontHaveAccount => isArabic ? 'ليس لديك حساب؟' : "Don't have an account?";
  String get createAccount => isArabic ? 'إنشاء حساب' : 'Create account';
  
  // Navigation
  String get home => isArabic ? 'الرئيسية' : 'Home';
  String get housing => isArabic ? 'السكن' : 'Housing';
  String get services => isArabic ? 'الخدمات' : 'Services';
  String get market => isArabic ? 'السوق' : 'Market';
  String get wallet => isArabic ? 'المحفظة' : 'Wallet';
  String get orders => isArabic ? 'الطلبات' : 'Orders';
  String get profile => isArabic ? 'الملف الشخصي' : 'Profile';
  String get settings => isArabic ? 'الإعدادات' : 'Settings';
  String get chat => isArabic ? 'المحادثات' : 'Chat';
  
  // Common actions
  String get save => isArabic ? 'حفظ' : 'Save';
  String get cancel => isArabic ? 'إلغاء' : 'Cancel';
  String get delete => isArabic ? 'حذف' : 'Delete';
  String get edit => isArabic ? 'تعديل' : 'Edit';
  String get create => isArabic ? 'إنشاء' : 'Create';
  String get search => isArabic ? 'بحث' : 'Search';
  String get filter => isArabic ? 'تصفية' : 'Filter';
  String get add => isArabic ? 'إضافة' : 'Add';
  
  // Settings
  String get language => isArabic ? 'اللغة' : 'Language';
  String get switchAppLanguage => isArabic ? 'تغيير لغة التطبيق' : 'Switch app language';
  String get darkMode => isArabic ? 'الوضع الداكن' : 'Dark mode';
  String get general => isArabic ? 'عام' : 'General';
  
  // Housing
  String get housingList => isArabic ? 'قائمة السكن' : 'Housing List';
  String get addHousing => isArabic ? 'إضافة سكن' : 'Add Housing';
  String get price => isArabic ? 'السعر' : 'Price';
  String get rating => isArabic ? 'التقييم' : 'Rating';
  
  // Services
  String get addService => isArabic ? 'إضافة خدمة' : 'Add Service';
  String get serviceName => isArabic ? 'اسم الخدمة' : 'Service name';
  String get serviceCreated => isArabic ? 'تم إنشاء الخدمة (تجريبي)' : 'Service created (mock)';
  
  // Market
  String get studentMarket => isArabic ? 'سوق الطلاب' : 'Student Market';
  String get addProduct => isArabic ? 'إضافة منتج' : 'Add Product';
  String get productName => isArabic ? 'اسم المنتج' : 'Product name';
  
  // Messages
  String get chooseLanguage => isArabic ? 'اختر اللغة' : 'Choose language';
  String get youCanChangeLater => isArabic ? 'يمكنك التغيير لاحقاً من الإعدادات' : 'You can change later from Settings';
  
  // Sign Up
  String get chooseRole => isArabic ? 'اختر الدور' : 'Choose role';
  String get student => isArabic ? 'طالب' : 'Student';
  String get provider => isArabic ? 'مقدم خدمة' : 'Provider';
  String get fullName => isArabic ? 'الاسم الكامل' : 'Full name';
  String get phoneNumber => isArabic ? 'رقم الهاتف' : 'Phone number';
  String get passwordStrong => isArabic ? 'كلمة المرور (8+ أحرف قوية)' : 'Password (8+ strong)';
  
  // Home
  String get welcome => isArabic ? 'مرحباً' : 'Welcome';
  String get whatWouldYouLikeToDo => isArabic ? 'ماذا تريد أن تفعل اليوم؟' : 'What would you like to do today?';
  String get laundryCleaning => isArabic ? 'غسيل وتنظيف' : 'Laundry & Cleaning';
  String get inbox => isArabic ? 'الرسائل' : 'Inbox';
  
  // Settings
  String get payments => isArabic ? 'المدفوعات' : 'Payments';
  String get addCard => isArabic ? 'إضافة بطاقة' : 'Add card';
  String get cardHolder => isArabic ? 'صاحب البطاقة' : 'Card holder';
  String get last4Digits => isArabic ? 'آخر 4 أرقام' : 'Last 4 digits';
  String get savedCards => isArabic ? 'البطاقات المحفوظة' : 'Saved cards';
  String get notifications => isArabic ? 'الإشعارات' : 'Notifications';
  String get orderUpdates => isArabic ? 'تحديثات الطلبات' : 'Order updates';
  String get messages => isArabic ? 'الرسائل' : 'Messages';
  String get legal => isArabic ? 'قانوني' : 'Legal';
  String get privacyPolicy => isArabic ? 'سياسة الخصوصية' : 'Privacy Policy';
  String get termsOfService => isArabic ? 'شروط الخدمة' : 'Terms of Service';
  String get about => isArabic ? 'حول' : 'About';
  
  // Housing
  String get housingWithin2km => isArabic ? 'السكن (≤ 2 كم)' : 'Housing (≤ 2 km)';
  String get housingInfo => isArabic ? 'تعرض هذه القائمة الوحدات ضمن 2 كم من الجامعة.' : 'This list shows units within 2 km from the university.';
  String get title => isArabic ? 'العنوان' : 'Title';
  String get latitude => isArabic ? 'خط العرض' : 'Latitude';
  String get longitude => isArabic ? 'خط الطول' : 'Longitude';
  String get addPhoto => isArabic ? 'إضافة صورة' : 'Add photo';
  
  // Services
  String get laundryCleaningServices => isArabic ? 'غسيل وتنظيف' : 'Laundry & Cleaning';
  String get perItem => isArabic ? 'لكل قطعة' : 'per item';
  String get perVisit => isArabic ? 'لكل زيارة' : 'per visit';
  String get perPiece => isArabic ? 'لكل قطعة' : 'per piece';
  
  // Common
  String get welcomeText => isArabic ? 'مرحباً' : 'Welcome';
  String get visitHomepage => isArabic ? 'زيارة الموقع الإلكتروني' : 'Visit Homepage';
  
  // Housing List
  String get addHousingProvider => isArabic ? 'إضافة سكن (مقدم خدمة)' : 'Add Housing (Provider)';
  String get pricePerMonth => isArabic ? 'السعر / الشهر (دينار أردني)' : 'Price / month (JOD)';
  String get computeDistance => isArabic ? 'حساب المسافة' : 'Compute Distance';
  String get allowedWithin2km => isArabic ? 'مسموح: ضمن 2 كم من الجامعة' : 'Allowed: within 2 km of ASU';
  String get blockedExceeds2km => isArabic ? 'مرفوض: يجب أن تكون القوائم ≤ 2 كم من الجامعة' : 'Blocked: Listings must be ≤ 2 km from ASU';
  String get rejectedExceeds2km => isArabic ? 'مرفوض: يتجاوز 2 كم' : 'Rejected: exceeds 2 km';
  String get housingSaved => isArabic ? 'تم حفظ السكن (تجريبي)' : 'Housing saved (mock)';
  String get addPhotos => isArabic ? 'إضافة صور' : 'Add photos';
  String get lat => isArabic ? 'خط العرض' : 'Lat';
  String get lng => isArabic ? 'خط الطول' : 'Lng';
  
  // Additional translations
  String get signOut => isArabic ? 'تسجيل الخروج' : 'Sign Out';
  String get details => isArabic ? 'التفاصيل' : 'Details';
  String get orderNow => isArabic ? 'اطلب الآن' : 'Order Now';
  String get quantity => isArabic ? 'الكمية' : 'Quantity';
  String get totalAmount => isArabic ? 'المبلغ الإجمالي' : 'Total Amount';
  String get unitPrice => isArabic ? 'سعر الوحدة' : 'Unit Price';
  String get description => isArabic ? 'الوصف' : 'Description';
  String get items => isArabic ? 'قطع' : 'items';
  String get addNewService => isArabic ? 'إضافة خدمة جديدة' : 'Add New Service';
  String get noServicesYet => isArabic ? 'لم تقم بإضافة أي خدمات بعد' : 'No services added yet';
  String get noServicesAvailable => isArabic ? 'لا توجد خدمات متاحة حالياً' : 'No services available currently';
  String get serviceCategory => isArabic ? 'فئة الخدمة' : 'Service Category';
  String get serviceDescription => isArabic ? 'وصف الخدمة' : 'Service Description';
  String get priceJOD => isArabic ? 'السعر (دينار أردني)' : 'Price (JOD)';
  String get unit => isArabic ? 'الوحدة' : 'Unit';
  String get laundryCategory => isArabic ? 'غسيل ملابس' : 'Laundry';
  String get cleaningCategory => isArabic ? 'تنظيف' : 'Cleaning';
  String get piece => isArabic ? 'قطعة' : 'Piece';
  String get visit => isArabic ? 'زيارة' : 'Visit';
  String get hour => isArabic ? 'ساعة' : 'Hour';
  String get item => isArabic ? 'قطعة' : 'Item';
  String get activate => isArabic ? 'تفعيل' : 'Activate';
  String get deactivate => isArabic ? 'إيقاف' : 'Deactivate';
  String get confirmDelete => isArabic ? 'تأكيد الحذف' : 'Confirm Delete';
  String get deleteServiceConfirm => isArabic ? 'هل أنت متأكد من حذف هذه الخدمة؟' : 'Are you sure you want to delete this service?';
  String get serviceDeletedSuccess => isArabic ? 'تم حذف الخدمة بنجاح' : 'Service deleted successfully';
  String get serviceAddedSuccess => isArabic ? 'تم إضافة الخدمة بنجاح!' : 'Service added successfully!';
  String get fillAllFields => isArabic ? 'يرجى ملء جميع الحقول المطلوبة' : 'Please fill all required fields';
  String get enterValidPrice => isArabic ? 'يرجى إدخال سعر صحيح' : 'Please enter a valid price';
  String get errorAddingService => isArabic ? 'حدث خطأ أثناء إضافة الخدمة' : 'Error adding service';
  String get by => isArabic ? 'بواسطة:' : 'By:';
  String get jod => isArabic ? 'د.أ' : 'JOD';
  
  // Complete translations for all UI elements
  String get english => isArabic ? 'English' : 'English';
  String get arabic => isArabic ? 'العربية' : 'العربية';
  String get male => isArabic ? 'ذكور فقط' : 'Male Only';
  String get female => isArabic ? 'إناث فقط' : 'Female Only';
  String get both => isArabic ? 'الجنسين (بدون تفضيل)' : 'Both (No Preference)';
  String get genderPreference => isArabic ? 'تفضيل الجنس' : 'Gender Preference';
  String get location => isArabic ? 'الموقع' : 'Location';
  String get distance => isArabic ? 'المسافة' : 'Distance';
  String get kmFromUniversity => isArabic ? 'كم من الجامعة' : 'km from university';
  String get month => isArabic ? 'شهر' : 'month';
  String get photos => isArabic ? 'الصور' : 'Photos';
  String get housingPhotos => isArabic ? 'صور السكن' : 'Housing Photos';
  String get mustBeWithin2km => isArabic ? 'يجب أن يكون السكن ضمن 2 كم من الجامعة' : 'Housing must be within 2 km of the university';
  String get coordinates => isArabic ? 'الإحداثيات' : 'Coordinates';
  String get enterValidCoordinates => isArabic ? 'يرجى إدخال إحداثيات صحيحة' : 'Please enter valid coordinates';
  String get housingAddedSuccess => isArabic ? 'تم إضافة السكن بنجاح!' : 'Housing added successfully!';
  String get housingTooFar => isArabic ? 'السكن بعيد جداً عن الجامعة (أكثر من 2 كم)' : 'Housing is too far from university (more than 2 km)';
  String get noHousingsYet => isArabic ? 'لم تقم بإضافة أي سكن بعد' : 'No housing added yet';
  String get noHousingsAvailable => isArabic ? 'لا توجد وحدات سكنية متاحة حالياً' : 'No housing units available currently';
  String get addNewHousing => isArabic ? 'إضافة سكن جديد' : 'Add New Housing';
  String get viewDetails => isArabic ? 'عرض تفاصيل' : 'View details';
  String get deleteHousingConfirm => isArabic ? 'هل أنت متأكد من حذف هذا السكن؟' : 'Are you sure you want to delete this housing?';
  String get housingDeletedSuccess => isArabic ? 'تم حذف السكن بنجاح' : 'Housing deleted successfully';
  String get errorPickingImages => isArabic ? 'خطأ في اختيار الصور' : 'Error picking images';
  String get housingDescription => isArabic ? 'وصف السكن' : 'Housing Description';
  String get housingDescriptionHint => isArabic ? 'اكتب وصف مفصل للسكن، المرافق المتاحة، القرب من الخدمات...' : 'Write detailed description of housing, available facilities, proximity to services...';
  String get titleExample => isArabic ? 'مثال: شقة مفروشة قريبة من الجامعة' : 'Example: Furnished apartment near university';
  String get serviceDescriptionHint => isArabic ? 'اكتب وصف مفصل للخدمة المقدمة' : 'Write detailed description of the service provided';
  String get laundryExample => isArabic ? 'مثال: غسيل ملابس، تنظيف غرف' : 'Example: laundry, room cleaning';
  String get priceHint => isArabic ? '0.50' : '0.50';
  String get basket => isArabic ? 'سلة' : 'Basket';
  String get halfHour => isArabic ? 'نصف ساعة' : 'Half Hour';
  String get hours => isArabic ? 'ساعات' : 'Hours';
  String get orderSent => isArabic ? 'تم إرسال الطلب بنجاح' : 'Order sent successfully';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

