import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Move build output to parent build folder
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Ensure :app is evaluated first
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    configurations.all {
        resolutionStrategy {
            eachDependency {
                if (requested.group == "androidx.core" && (requested.name == "core" || requested.name == "core-ktx")) {
                    useVersion("1.13.1")
                }
                if (requested.group == "androidx.activity" && (requested.name == "activity" || requested.name == "activity-ktx")) {
                    useVersion("1.9.3")
                }
                if (requested.group == "androidx.fragment" && (requested.name == "fragment" || requested.name == "fragment-ktx")) {
                    useVersion("1.8.5")
                }
                if (requested.group.startsWith("androidx.lifecycle")) {
                    useVersion("2.8.7")
                }
                if (requested.group == "androidx.browser" && requested.name == "browser") {
                    useVersion("1.8.0")
                }
                if (requested.group.startsWith("androidx.savedstate")) {
                    useVersion("1.2.1")
                }
                if (requested.group == "androidx.annotation" && requested.name == "annotation") {
                    useVersion("1.8.2")
                }
                if (requested.group == "androidx.navigationevent" && requested.name == "navigationevent-android") {
                    useVersion("1.0.0")
                }
                if (requested.group == "org.jetbrains.kotlin") {
                    useVersion("2.0.20")
                }
            }
        }
    }
}

// Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
