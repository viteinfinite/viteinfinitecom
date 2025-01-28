---
id: 174576765
title: 'Kotlin Multiplatform: testing a shared module supporting iOS and Android'
date: 2018-04-15T09:51:43+00:00
layout: post
guid: http://viteinfinite.com/?p=174576765
permalink: /2018/04/kotlin-multiplatform-testing-ios-android/
categories:
  - iOS Development
  - Kotlin
  - Mobile Development
---

Conceiving your app as modular can be greatly beneficial to your codebase’s health. In particular, designing a separation between your view and business logic can decrease the coupling between your layers and improve maintainability as well as testability. Tests are indeed your app’s best friends, as they can, at the same time, verify the code you wrote works as intended and act as a specification for the implemented functionality.

<!--more-->

* * *

> &#x1f1eb;&#x1f1f7; _Parlez-vous Français_ ? You can read a [French Version of this post](https://blog.xebia.fr/2018/04/11/tester-un-projet-kotlin-multiplatform/) on our blog at [Xebia France](http://blog.xebia.fr).

* * *

When it comes to Multiplatform, Kotlin provides an interesting solution for testing your logic: in this configuration, every written test is executed against each one of your targeted platform.

In other words, given you target are Android and iOS (via [Kotlin/Native](https://kotlinlang.org/docs/reference/native-overview.html)), your tests will be compiled and launched in both the JVM and the native runtime.

The setup of unit tests for Multiplatform can be tricky, though. Let’s see how to get a working configuration.

In order to do this, we’ll proceed from [where we left in our last post](http://viteinfinite.com/2018/03/sharing-frameworks-between-ios-and-android-with-kotlin-multiplatform/).

As you might recall, our module did nothing more than producing two strings, `bar-android` and `bar-ios` for Android and iOS respectively. Thanks to test in Kotlin Multiplatform we’ll be able to verify that, no matter the targeted platform, the produced value starts with `bar-`.

## Writing our Test

> The full code for this article is available in the [feature/multiplatform branch of our kotlin-ios-framework repository](https://github.com/xebia-france/kotlin-ios-framework/tree/feature/multiplatform).

So, time to create a new file. First of all, let’s create a folder holding our test: _myframework/src/test/kotlin/fr/xebia/myframework/_. As you would expect, the path mirrors the one containing our implementation under test. In this directory we’ll create a new test class, `TestFoo`, whose contents are as follows:

```kotlin
package fr.xebia.myframework
import kotlin.test.*

class TestFoo {

    // The “@Test” annotation allows Kotlin to recognise the following function as a test
    @Test
    fun testBar() {
        val foo = Foo()

        // The assert to be verified
        assertTrue {
            foo.bar().startsWith("bar-")
        }
    }
}
```

As you can see, Kotlin comes with a testing and assertion framework, so no need to declare another dependency to your project.

Of course, for tests to be run, we need to edit our `build.gradle` files. Let’s start with the common project’s: it should declare two additional _dependencies_: `kotlin-test-common` and `kotlin-test-annotations`.

Please note that, in Kotlin Multiplatform, since tests can be only run against a specific target platform (such as Android’s JVM), `kotlin-test-common` will not suffice to be running your verification logic, but acts as a placeholder for an actual testing framework such as JUnit.

As a proof, we can already try compiling the tests, which action will produce a build error, as the platform target won’t know how to interpret annotations and assertions.

## `build.gradle` for Android

Quite unsurprisingly, we’ll have to edit the build.gradle file for the Android project as well. Similarly to the build file included in the common project, the Android’s should declare additional dependencies, needed for testing: JUnit, `kotlin-test-junit` and `kotlin-test`. Those dependencies contain the actual frameworks that will be executing during the execution of your tests.

## `build.gradle` for Kotlin/Native

Last but not least, let’s configure the gradle file for the Kotlin/Native project used on iOS, which setup is definitely trickier.

In the current version of Kotlin/Native, in order for tests to be launched, we’ll have to create a “dummy” program that will hold both our “main” and “test” code and that will be executed when running the “test” task with gradle.

To do so, let’s then add a new program in the build.gradle file contained in our myframework-ios folder:

```groovy
program('shared-ios-test') {
    srcDir 'src/main/kotlin'
    srcDir 'src/test/kotlin'
    commonSourceSets 'main', 'test'
    extraOpts '-tr'

    enableMultiplatform true
}
```

Second, we need to ask gradle to run the program upon launch of the “test” task. To do so we’ll have to add a new task, at the bottom of the file:

```groovy
task test(dependsOn: run)
```

When running `gradle test`, our program will compile, get executed and produce the following output:

```bash
[==========] Running 1 tests from 1 test cases.
[----------] Global test environment set-up.
[----------] 1 tests from fr.xebia.myframework.TestFoo
[ RUN      ] fr.xebia.myframework.TestFoo.testBar
[       OK ] fr.xebia.myframework.TestFoo.testBar (0 ms)
[----------] 1 tests from fr.xebia.myframework.TestFoo (0 ms total)
[----------] Global test environment tear-down
[==========] 1 tests from 1 test cases ran. (0 ms total)
[  PASSED  ] 1 tests.
```

Once again, you can grab the full code for this article from [the feature/multiplatform branch of our kotlin-ios-framework repository](https://github.com/xebia-france/kotlin-ios-framework/tree/feature/multiplatform).

## Going Further

A nice feature of such configuration is that we can add specific tests for each platform. For instance, in case we want to add a more detailed test for our Kotlin/Native target, we’ll just need to create a new test folder in the myframework-ios subproject – without forgetting to add such folder as `srcDir` inside the `build.gradle` file.

## Wrapping Up

As seen in this post, configuring a test environment for Multiplatform tests is just a matter of adding a few lines of code. Once we get the right setup, tests will be run on all the targeted platforms with little effort.