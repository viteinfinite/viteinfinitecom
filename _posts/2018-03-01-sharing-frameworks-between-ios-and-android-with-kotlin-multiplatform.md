---
id: 174576753
title: Sharing frameworks between iOS and Android with Kotlin Multiplatform
date: 2018-03-01T02:36:12+00:00
layout: post
guid: http://viteinfinite.com/?p=174576753
permalink: /2018/03/sharing-frameworks-between-ios-and-android-with-kotlin-multiplatform/
categories:
  - iOS Development
  - Kotlin
---

Today we’ll see how to use Kotlin code to write a cross platform module that can be shared between an iOS and an Android app.

Since the support for building iOS frameworks, introduced with [Kotlin/Native 0.5](https://blog.jetbrains.com/kotlin/2017/12/kotlinnative-v0-5-released-calling-kotlin-from-swift-and-c-llvm-5-and-more/) in December 2017, it has been possible to use the same code for creating libraries for both Android (.aar) and iOS (.framework). A couple of months later, [Kotlin/Native 0.6](https://blog.jetbrains.com/kotlin/2018/02/kotlinnative-v0-6-is-here/) officially supports this use case, thanks to the support of [Multiplatform](https://kotlinlang.org/docs/reference/multiplatform.html), a new functionality focused on sharing code across platforms, introduced in the [version 1.2 of the Kotlin language](https://blog.jetbrains.com/kotlin/2017/11/kotlin-1-2-released/).

<!--more-->

* * *

> &#x1f1eb;&#x1f1f7; _Parlez-vous Français_ ? You can read a [French Version of this post](https://blog.xebia.fr/2018/03/13/creer-des-modules-partages-entre-android-et-ios-avec-kotlin-multiplatform/) on our blog at [Xebia France](http://blog.xebia.fr).

* * *

Today’s goal will be to create two modules, one for iOS and another one for Android, sharing a common interface but providing slightly different implementations, both written in Kotlin.

Multiplatform supports a DSL bringing two new kinds of modules:

  * “Common”: they contain code that is not specific to any platform, and unimplemented (“apxpect”) placeholder declarations that need to rely on a platform-specific implementation
  * “Platform”: they contain platform-specific code that implement the placeholder declarations in the common module. Platform modules can also contain other platform-dependent code.
  * “Regular”: they regroup those modules which are neither “Common” nor “Platform”.

A good example for this need is File I/O: as expected, any implementation of file access or networking is beyond the scope of Kotlin Standard Library. So, in case our commons module wants to use the file system, it’ll have to rely on two different underlying implementations which are platform dependent. For instance, to access files on Android, we would be using the `Java.io.File` while on iOS we would rather use `NSFileManager`.

So, let’s begin where we left in our previous post about [the creation of iOS frameworks with Kotlin/Native](http://viteinfinite.com/2018/02/creating-an-ios-framework-with-kotlin/).

Our module didn’t do anything except returning a string value. So, we’ll modify this behaviour by making our function return a different value depending on the system our module runs on. Our two implementations will be packaged under two different forms: an Android Archive (.aar) for Android and a Framework for iOS.

In order to do this we have to slightly change our project structure by adding two new folders corresponding to the _Platform_ modules (_myframework-ios_ and _myframework-android_), and create a directory tree containing “src/main/kotlin/fr/xebia/myframework” in both of them.

The resulting file tree should now be as follows:

<pre class="lang:default decode:true ">├── build.gradle
├── gradle
├── gradlew
├── gradlew.bat
├── myframework
│   ├── build.gradle
│   └── src
│       └── main
│           └── kotlin
│               └── fr
│                   └── xebia
│                       └── myframework
│                           └── foo.kt
├── myframework-android
│   └── src
│       └── main
│           └── kotlin
│               └── fr
│                   └── xebia
│                       └── myframework
├── myframework-ios
│   └── src
│       └── main
│           └── kotlin
│               └── fr
│                   └── xebia
│                       └── myframework
└── settings.gradle</pre>

&nbsp;

## The common project

### Settings.gradle

Now, we have to make sure Gradle recognises myrframework-android as part of our project. To do this, we need to edit our settings.gradle file and, in the second line, add `:myframework-android` and `:myframework-ios`.

The complete file contents are:

<pre class="lang:default decode:true ">rootProject.name = 'MyProject'
include ':myframework', ‘:myframework-android', ‘:myframework-ios'
</pre>

We can now run

<pre class="lang:default decode:true ">./gradlew tasks</pre>

to double check your new configuration does not output any error.

### build.gradle

Time to modify our build tasks: in our main build.gradle, we’ll have to change the kotlin version to _1.2.30_. This is needed in order to use the Multiplatform feature on Android.

The new, complete build.gradle is as follows:

<pre class="lang:default decode:true">allprojects {
    buildscript {
        ext.kotlin_version = '1.2.30'
        ext.konan_version = '0.6.1'

        repositories {
            jcenter()
        }
    }
}</pre>

### Back to the code

Let’s get back to our Foo class. We’d like to provide an extremely basic implementation, in which the `bar()` function will return a different string, depending on the OS. On Android, the returned string will be `"bar-android"`, while, on iOS, `"bar-ios"`.

Now, it’s the time to introduce a new keyword: expect. By the means of this we can tell the compiler that this declaration is nothing more than a placeholder – but that we’ll be **expect**ing a concrete, **actual**, implementation from one of our platform-dependent projects.

So, we’ll modify the Foo.kt file inside the _myframework_ subproject as follows:

<pre class="lang:default decode:true ">package fr.xebia.myframework

expect class Foo() {
    fun bar(): String
}</pre>

&nbsp;

Also, we need to declare that this project supports Multiplatform: in order to do this, we’ll have to modify the _build.gradle_ at _myframework/build.gradle_ as follows:

<pre class="lang:default decode:true">buildscript {
    dependencies {
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}

apply plugin: 'org.jetbrains.kotlin.platform.common'

dependencies {
    compile "org.jetbrains.kotlin:kotlin-stdlib-common:$kotlin_version"
}

repositories {
    jcenter()
}</pre>

## The _actual_ implementation

So, it’s now time to get to the platform-specific implementations, starting with Android.

We’ll now add a new build.gradle just inside the  myframework-android, holding the configuration for this subproject.

### build.gradle (Android)

In the new build gradle we’re going to declare that myframework-android provides an implementation that is expected by another project, namely _myframework_. We do this by using the `expectedBy` scope.

Also, and foremost, let’s not forget we’re building an Android library here, so we’ll have to add all the settings required by such context, under the ‘android’ property.

Here’s how the build.gradle file looks like for the _myframework-android_ subproject:

<pre class="lang:default decode:true">buildscript {
    repositories {
        google()
    }

    dependencies {
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.android.tools.build:gradle:3.0.1'
    }
}

apply plugin: 'com.android.library'
apply plugin: 'kotlin-platform-android'

android {
    compileSdkVersion 26

    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 26
        versionCode 1
        versionName '1.0'
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }
}

repositories {
    jcenter()
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib:$kotlin_version"
    expectedBy project(':myframework')
}
</pre>

### AndroidManifest

Since we’re building an .aar, we also need for an _AndroidManifest.xml_, which is required by the targets.

In this project, we’ll add, inside the _myframework-android/src/main_ folder, [a simple manifest file](https://github.com/xebia-france/kotlin-ios-framework/blob/feature/multiplatform/myframework-android/src/main/AndroidManifest.xml).

### Code

It is the time to provide the platform-specific implementation. In this extremely basic implementation, the `bar()` function will return a different string, depending on the OS. On Android, the returned string will be `"bar-android"`.

In order to do this, we have to make sure our “actual” implementation:

  * Belongs to the same package as the base (or “expect”) implementation
  * Uses the keywords “actual”, both before class (and optionally before its constructor) and before the actual function implementation.

The result is as follows:

&nbsp;

<pre class="lang:default decode:true ">package fr.xebia.myframework

actual class Foo {
    actual fun bar() = "bar-android"
}</pre>

## iOS

Creating the iOS counterpart doesn’t differ much from what we learned in [our previous article](http://viteinfinite.com/2018/02/creating-an-ios-framework-with-kotlin/).

First of all, we have to add a new build.gradle file containing the konan (i.e., the Kotlin/Native compiler) definitions. As mentioned, the build.gradle file should look quite familiar now, with the exception of the `enableMultiplatform true` directive, enabling the Multiplatform support in this subproject.

As we did in the Android counterpart, the `expectedBy` directive under `dependencies` tells gradle that our project contains the “actual” implementation of _myframework_.

<pre class="lang:default decode:true">apply plugin: 'konan'

buildscript {
    repositories {
        maven {
            url ‘https://dl.bintray.com/jetbrains/kotlin-native-dependencies'
        }
    }
    dependencies {
        classpath "org.jetbrains.kotlin:kotlin-native-gradle-plugin:$konan_version"
    }
}

konanArtifacts {
    framework('KotlinMyFramework', targets: ['iphone', 'iphone_sim']) {
        srcDir 'src/main/kotlin'

        enableMultiplatform true
    }
}

dependencies {
    expectedBy project(':myframework')
}</pre>

&nbsp;

### Code

The code is once again a matter of few lines. We’ll be adding a _Foo.kt_ class inside _myframework-ios/src/main/kotlin/fr/xebia/myframework_

In this case, the “actual” implementation of the `Foo` class will return the string `bar-ios`. Once again, in order for the class to match the “expected” one, we must remember to declare the `package` this file lives in.

And here is the full implementation:

&nbsp;

<pre class="lang:default decode:true ">package fr.xebia.myframework

actual class Foo {
    actual fun bar() = "bar-ios"
}</pre>

## Building

And that’s all. By running

<pre class="lang:default decode:true ">./gradlew tasks</pre>

we should now be able to get all the iOS (e.g. `konanCompile`) and Android tasks.

We can build both iOS and Android at the same time by running, from our project folder.

<pre class="lang:default decode:true ">./gradlew build</pre>

The artefacts will be created in the _myframework-ios/build_ and _myframework-android/build_ folders.

You can get a complete example of the code above from [the feature/multiplatform branch of this repo](https://github.com/xebia-france/kotlin-ios-framework/tree/feature/multiplatform).

## Wrapping Up

As we’ve seen, the workflow introduced by Kotlin multiplatform is pretty straightforward and has been quickly implemented in Kotlin/Native. I can say I am quite surprised to see so many features getting implemented into Kotlin and Kotlin/Native and I’m really looking forward to seeing the reception of mobile developers in respect to such tools.

## Credits

Once again, I particularly wish to thank my fellow colleagues at [Xebia](http://blog.xebia.fr), Bastien Bonnet, Sergio Dos Santos and Benjamin Lacroix, for thoroughly reviewing this article.