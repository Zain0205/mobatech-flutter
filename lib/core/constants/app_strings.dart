class AppStrings {
  // Splash
  static const String splashTagline = 'Layanan Kesehatan Terpercaya';

  // Onboarding
  static const String welcomeTitle = 'Welcome to\nHermina Apps';
  static const String welcomeSubtitle =
      'Akses layanan kesehatan terbaik dan terpercaya '
      'dari Hermina Hospital langsung dari genggaman Anda.';
  static const String getStarted = 'Get Started';

  // Login
  static const String loginGreeting = 'Halo, Selamat Datang 👋';
  static const String loginSubtitle = 'Masuk ke Hermina Mobile Apps';
  static const String emailLabel = 'Email';
  static const String emailHint = 'contoh@email.com';
  static const String passwordLabel = 'Kata Sandi';
  static const String passwordHint = 'Masukkan kata sandi';
  static const String rememberMe = 'Ingat saya';
  static const String forgotPassword = 'Lupa kata sandi?';
  static const String loginButton = 'Masuk';
  static const String noAccount = 'Belum punya akun? ';
  static const String registerLink = 'Daftar';
  static const String orContinueWith = 'Atau lanjutkan dengan';
  static const String continueWithGoogle = 'Lanjutkan dengan Google';

  // Register
  static const String registerTitle = 'Daftar Akun';
  static const String fullNameLabel = 'Nama Lengkap';
  static const String fullNameHint = 'Masukkan nama lengkap';
  static const String phoneLabel = 'Nomor Telepon';
  static const String confirmPasswordLabel = 'Konfirmasi Kata Sandi';
  static const String confirmPasswordHint = 'Masukkan ulang kata sandi';
  static const String registerButton = 'Daftar';
  static const String phoneMinError = 'Nomor telepon minimal 8 digit';

  // Password validations
  static const String passMinChars = 'Minimal 8 karakter';
  static const String passUppercase = 'Huruf Besar';
  static const String passLowercase = 'Huruf Kecil';
  static const String passDigit = 'Angka';

  // History
  static const String historyTitle = 'Riwayat';
  static const String appointmentTab = 'Janji Temu';
  static const String pharmacyTab = 'Farmasi';
  static const String noAppointmentHistory = 'Belum ada riwayat janji temu.';
  static const String noPharmacyHistory = 'Belum ada riwayat farmasi.';
  static const String appointmentWith = 'Janji Temu bersama';
  static const String defaultDoctorName = 'Dokter';

  // General
  static const String phonePrefix = '+62';

  // Home
  static const String homeGreetingPrefix = 'Selamat Pagi, ';
  static const String homeGreetingSubtitle = 'Semoga harimu menyenangkan, salam sehat';
  static const String searchHint = 'Cari layanan atau spesialis...';
  
  static const String menuAppointment = 'Buat Janji\nTemu';
  static const String menuOffers = 'Penawaran\nKhusus';
  static const String menuAssistant = 'Hermina\nAssistant';
  static const String menuEmergency = 'Panggilan\nEmergensi';
  static const String menuOthers = 'Lainnya';
  static const String menuOthersTitle = 'Menu Lainnya';
  
  static const String sectionAgenda = 'Agenda Terdaftar';
  static const String emptyAgenda = 'Belum ada agenda terdaftar';
  static const String sectionAssistant = 'Hermina Asisten Kesehatan Digital';
  static const String sectionHospitals = 'RS Hermina terdekat dari rumah kamu';
  static const String defaultUser = 'Pengguna';

  static const String hospital1Name = 'Hermina Ciledug';
  static const String hospital1Address = 'Jl. Cipto Mangunkusumo No 12 Kab...';
  static const String hospital1Distance = '6 KM';

  static const String hospital2Name = 'Hermina Cibinong';
  static const String hospital2Address = 'Jl. Raya Jakarta-Bogor Km 46...';
  static const String hospital2Distance = '6 KM';

  // Emergency
  static const String emergencyTitle = 'Panggilan Darurat';
  static const String emergencyWarning = 'Gunakan layanan ini HANYA untuk kondisi gawat darurat yang mengancam nyawa.';
  static const String locationLabel = 'LOKASI ANDA';
  static const String patientDataLabel = 'DATA PASIEN';
  static const String patientNameHint = 'Nama Lengkap Pasien';
  static const String conditionHint = 'Kondisi (cth: Pendarahan, Sesak Nafas)';
  static const String phoneActiveHint = 'Nomor Telepon Aktif';
  static const String callAmbulance = 'PANGGIL AMBULANS SEKARANG';
  static const String locationNotDetected = 'Lokasi belum terdeteksi. Tunggu atau coba lagi.';
  static const String locationServiceDisabled = 'Layanan lokasi tidak aktif. Aktifkan GPS Anda.';
  static const String locationPermissionDenied = 'Izin lokasi ditolak.';
  static const String locationPermissionDeniedForever = 'Izin lokasi ditolak permanen. Buka pengaturan untuk mengaktifkan.';
  static const String locationDetectFailed = 'Gagal mendeteksi lokasi: ';
  static const String detectingLocation = 'Mendeteksi lokasi...';
  static const String detectFailed = 'Gagal mendeteksi';
  static const String locationDetected = 'Lokasi terdeteksi';
  static const String usingGps = 'Menggunakan GPS...';
  static const String locationUnavailable = 'Lokasi tidak tersedia';
  static const String requiredField = 'Wajib diisi';
  static const String contactingDriver = 'Menghubungi driver...';

  // Emergency Dispatching
  static const String searchingAmbulance = 'Mencari Ambulans Terdekat...';
  static const String contactingEmergencyUnit = 'Menghubungi unit darurat di sekitar Anda';

  // Emergency Tracking
  static const String you = 'Anda';
  static const String ambulance = 'Ambulans';
  static const String live = 'LIVE';
  static const String ambulanceTracking = 'Pelacakan Ambulans';
  static const String min = 'min';
  static const String ambulanceHeading = 'Ambulans sedang menuju lokasi Anda';
  static const String estimateArrival = 'Estimasi tiba dalam ';
  static const String minuteText = ' menit';
  static const String driverName = 'Pak Surya';
  static const String driverDetails = 'B 1234 AMB • Ambulans Tipe A';

  // Emergency Arrived
  static const String ambulanceArrived = 'Ambulans Telah Tiba!';
  static const String arrivedMessage = 'Tim medis sedang menuju lokasi Anda.\nTetap tenang dan tunggu di tempat.';
  static const String driverInfoArrived = 'Pak Surya • B 1234 AMB';
  static const String ambulanceType = 'Ambulans Tipe A';
  static const String backToHome = 'Kembali ke Beranda';
  // Pharmacy
  static const String pharmacyTitle = 'Farmasi';
  static const String catalogTab = 'Katalog';
  static const String ePrescriptionTab = 'E-Resep';
  static const String ordersTab = 'Pesanan';
  static const String allCategory = 'Semua';
  static const String errorLoadCategories = 'Gagal memuat kategori';
  static const String errorLoadMedicines = 'Gagal memuat obat';
  static const String prescriptionLabel = 'Resep';
  static const String addedToCartSuffix = ' ditambahkan ke keranjang';
  static const String noPrescription = 'Tidak ada e-resep aktif';
  static const String diagnosisPrefix = 'Diagnosis: ';
  static const String redeemMedicine = 'Tebus Obat';
  static const String errorLoadPrescriptions = 'Gagal memuat e-resep';
  static const String noOrders = 'Belum ada pesanan';
  static const String totalOrder = 'Total Pesanan';
  static const String errorLoadOrders = 'Gagal memuat pesanan';

  // Chatbot
  static const String chatGreeting = 'Halo! Saya asisten AI Hermina.\nApa yang bisa saya bantu hari ini?';
  static const String chatHospitalName = 'Hermina Hospital';
  static const String chatSubtitle = 'Tanyakan apa yang jadi keluhan kamu';
  static const String chatNewTooltip = 'New Chat';
  static const String chatHistoryTooltip = 'Chat History';
  static const String chatHistoryTitle = 'Riwayat Obrolan';
  static const String chatNoHistory = 'Belum ada riwayat.';
  static const String chatNewConversation = 'Percakapan Baru';
  static const String chatWelcomeMessage = 'Halo! Saya asisten AI Hermina.\nApa yang bisa saya bantu hari ini?';
  static const String chatHeaderTitle = 'Hermina Hospital';
  static const String chatHeaderSubtitle = 'Tanyakan apa yang jadi keluhan kamu';
  static const String chatNewChatTooltip = 'New Chat';
  static const String chatHistoryEmpty = 'Belum ada riwayat.';
  static const String chatNewSessionTitle = 'Percakapan Baru';
  static const String chatMediaAttachmentTitle = 'Berkas Media';
  static const String chatAccessDeniedMsg = 'Akses ditolak atau dibatalkan.';
  static const String chatFilePickerErrorMsg = 'Gagal memilih file.';
  static const String chatBypassImageMsg = 'Bypass Emulator: Gambar dummy dilampirkan.';
  static const String chatBypassFileMsg = 'Bypass Emulator: Dokumen dummy dilampirkan.';
  static const String chatSuggestionSymptoms = 'Cek Gejala';
  static const String chatSuggestionDoctorSchedule = 'Info Jadwal Dokter';
  static const String chatSuggestionFacilities = 'Fasilitas Hermina';
  static const String chatInputHint = 'Tulis Pertanyaan Kamu Disini ...';
  static const String chatAttachmentGallery = 'Galeri';
  static const String chatAttachmentCamera = 'Kamera';
  static const String chatAttachmentDocument = 'Dokumen';
  static const String botAvatarAsset = 'assets/doctor.png';
  static const String headerLogoAsset = 'assets/header_logo.png';
}
