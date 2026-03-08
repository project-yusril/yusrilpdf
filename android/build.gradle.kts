allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    afterEvaluate {
        val android = project.extensions.findByName("android") as? com.android.build.gradle.BaseExtension
        android?.apply {
            // Fix Namespace for AGP 8+
            if (namespace == null) {
                namespace = if (project.name == "edge_detection") "com.sample.edgedetection" else "com.${project.name.replace("-", ".")}"
            }

            compileOptions {
                sourceCompatibility = JavaVersion.VERSION_17
                targetCompatibility = JavaVersion.VERSION_17
            }
        }
        
        project.tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            compilerOptions {
                jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
            }
        }

        project.tasks.withType<JavaCompile>().configureEach {
            targetCompatibility = "17"
            sourceCompatibility = "17"
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
