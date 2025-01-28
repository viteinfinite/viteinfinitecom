---
id: 174576723
title: Running a Kotlin/Native iOS app in the Simulator
date: 2017-11-25T13:59:09+00:00
layout: post
guid: http://viteinfinite.com/?p=174576723
permalink: /2017/11/running-a-kotlinnative-ios-app-in-the-simulator/
dsq_thread_id:
  - "6309143394"
categories:
  - iOS Development
  - Kotlin
  - Mobile Development
---

Kotlin Native 0.4 is out since the beginning of November and, with it, some nice sample iOS demo apps to be run into your favourite iOS device. That sounds amazing, even for some hardcore Swift fans like me. Yet, there’s a catch: the sample apps can only run on a _real_ iOS device but not in the Simulator. Sure, that’s just an unsignificant drawback compared to what the Kotlin Native team achieved so far. Still, I’m a huge fan of the iOS Simulator, as it’s by far the fastest way to do some quick testing of an app while doing a pretty good job in mimicking the behaviour of an app on a real device.

<!--more-->

* * *

**Update:** since [Kotlin/Native 0.5](http://viteinfinite.com/2018/01/kotlinnative-0-5-and-ios/), the following article is now outdated. I’ll be keeping its content for reference.

* * *

So, as a way to understand the Kotlin Native project, I decided to try supporting the Simulator on a Kotln Native iOS app.

In order to do this, I started from the UIKit project sample found in the samples dir of the main repo and tried to make it run in the sim.

The first element to be considered when building for the simulator is obviously that this platform runs on the x86_64 architecture, compared to the armv7s of a real device.

To follow this tutorial, please clone the Kotlin/Native repo from <https://github.com/JetBrains/kotlin-native>. This repository contains all the sources to build **konan**, the kotlin compiler for native targets.

## 1. The Target

First thing I discovered when reading some of the KN source code, was that the iPhone Simulator support has been considered and partially implemented. Just, it was not active.

In the KonanTarget.kt file, which manages which targets are actually available in the platforms, the line the `KonanTarget.IPHONE_SIM.enabled = true` was simply commented out. So, let’s uncomment it in order for Kotlin to start acknowledging the presence of an iOS Simulator target.

A minor configuration issue had to be repaired as well. In particular, in the konan.proprerties file, the dependencies.osx-ios_sim at line 75 needs to be changed to:

<pre class="show-lang:2 nums:false lang:default highlight:0 decode:true ">dependencies.osx-ios_sim = target-sysroot-1-darwin-macos \
libffi-3.2.1-2-darwin-ios-sim \
clang-llvm-3.9.0-darwin-macos \
target-sysroot-1-darwin-ios-sim</pre>

It’s now time to build the compiler, by following the (few) steps described in the README.md of the Kotlin/Native project.

In particular, we’ll have to execute

<pre class="">./gradlew dist distPlatformLibs</pre>

## 2. Configuring the uikit project

Next step, is to build the uikit project for the simulator. To do that, we simply have to change the `konan.targets = ['iphone']` in _samples/uikit/build.gradle_ to read `konan.targets = ['iphone_sim']`.

When I started building, without success, I hoped for some intelligible error message. And, in fact, there it was. Turns out, prior to building, konan downloads a number of dependencies needed for compiling to a specific target. Archives bundling the dependencies are pulled directly from downloads.jetbrains.com, saved to the _~/.konan/cache_ directory and then extracted to the _~/.konan/dependencies_ folder.

In the case of the iOS Simulator, two of those are actually missing from the jetbrains repository: _libffi_ and _target-sysroot_.

## 3. libffi

Libffi is an open-source project providing a Foreign Function Interface. As the libffi repo README says, Libffi is

> a foreign function interface is the popular name for the interface that allows code written in one language to call code written in another language

Kotlin Native uses libffi to call Objective-C platform frameworks, such as UIKit or Foundation.

Unfortunately, while downloads.jetbrains.com provides a compiled libffi library supporting the iphoneos platform, there is no version available for iphonesimulator. So, time to build it from source. Luckily enough, the libffi repo already contains a pre-configured libffi.xcodeproj to build the library, so I just had to download it, generate Darwin headers files (using the generate-darwin-source-and-headers.py script) and producing a static library with Xcode.

Feel lazy? [Here is a pre-compiled version](http://viteinfinite.com/wp-content/uploads/2017/11/libffi-3.2.1-2-darwin-ios-sim.tar.gz), built with Xcode 9.0.

It’s now possible to build the library and archive it in a file _named libffi-3.2.1-2-darwin-ios-sim.tar.gz_. The archive has then to be inserted into the _~/.konan/cache _folder. This procedure is needed for konan to retrieve the libffi from the cache, instead of trying downloading the archive from the online repository.

## 4. target-sysroot

The target-sysroot is, in this case, the SDK we’re targeting, in other words the iphonesimulator. You can get a list of the sdks installed with Xcode by running

<pre class="">xcrun --sdk iphoneos11.1 --show-sdk-path</pre>

in the terminal.

Since we’re looking for the iOS simulator SDK, we’ll be typing again in the terminal

<pre class="">xcrun --sdk iphonesimulator11.1 --show-sdk-path</pre>

to retrieve the SDK path.

Normally, the SDK is ready to be used for our app to be built against. Instead, some minor modifications should be added for the compilation to succeed. In particular, I needed to tweak the NSUUID.h header in _<SDK>/System/Library/Frameworks/Foundation.framework/Headers_ to remove the nullability keywords (`_Nonnull` and `_Nullable`) in the interface methods `initWithUUIDBytes:` and `getUUIDBytes:`.

Of course, the whole folder had to be _tarred_ to a target-sysroot-1-darwin-ios-sim.tar.gz file and then moved into _~/.konan/cache_.
  
Once again, this procedure is needed for konan to avoid downloading the archive from the online repository.

## 5. Runtime

Once libffi is build, the target sysroot is retrieved and both are achieved and inserted in the cache folder, it was time to compile the kotlin runtime for the iphonesimulator.

The runtime will be linked to iOS app during the build process, and this will ultimately allow our kotlin code to access the functions provided by the iOS native frameworks.
  
In order to build the runtime for the Simulator, we simply have to cd to our kotlin-native source folder and run

<pre class="">./gradlew iphone_simCrossDistRuntime</pre>

Building the runtime may take up to 10/15 minutes, so get grab a coffee and please come back more excited than ever.

## 6. Project build configuration

Alright, all the prerequisites are in place!

Before running, back to Xcode, let’s change the “Replace Binary” phase to read
  
`cp "$SRCROOT/build/konan/bin/iphone_sim/app.kexe" "$TARGET_BUILD_DIR/$EXECUTABLE_PATH"`

And, that’s it. Just build the app as you would normally do and run it in an iOS simulator.

## Conclusion

To be honest, I’m pretty excited by the result and I can’t wait to do some more with kotlin for iOS.

As for the technicalities of the articles, even if my initial goal involved some degree of knowledge on subjects I barely know about, turns out that there was not much work to be done after all: in fact, the Kotlin Native team did all the heavy lifting, as the simulator support was almost finished apart from some missing bits.

Most of all, that was, to some extent, a rewarding task and a good opportunity to submit a PR to the team.