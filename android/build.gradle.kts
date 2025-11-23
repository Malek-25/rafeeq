import org.gradle.api.tasks.Delete

// ريبو لكل المشاريع
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// نخلي مجلد build الرئيسي خارج android/
rootProject.buildDir = file("../build")

subprojects {
    // نخلي build لكل سب-بروجكت داخل ../build/<اسم المشروع>
    project.buildDir = file("${rootProject.buildDir}/${project.name}")
}

// تاسك clean يحذف مجلد build الرئيسي
tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
