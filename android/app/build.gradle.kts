plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.rafeeq"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"   // NDK الموحد لكل البلغنز

    defaultConfig {
        applicationId = "com.example.rafeeq"

        // أقل نسخة أندرويد مطلوبة للفيريبيس auth الجديدة
        minSdk = 23

        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        getByName("release") {
            // ما في تصغير كود ولا حذف موارد في وضع التطوير
            isMinifyEnabled = false
            isShrinkResources = false
        }
        getByName("debug") {
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ضيف أي dependencies إضافية لو احتجت
}
