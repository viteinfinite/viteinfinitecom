---
id: 174576733
title: Kotlin/Native 0.5 and iOS
date: 2018-01-01T23:11:54+00:00
layout: post
guid: http://viteinfinite.com/?p=174576733
permalink: /2018/01/kotlinnative-0-5-and-ios/
dsq_thread_id:
  - "6385379962"
categories:
  - iOS Development
  - Kotlin
---

Kotlin Native interoperability is rapidly evolving and the [latest iteration, version 0.5](https://github.com/JetBrains/kotlin-native/releases/tag/v0.5), brings support for calling Kotlin code from Swift and Objective-C.

<!--more-->

Also, iPhone Simulator is now supported out of the box. Just run

<pre class="lang:sh decode:true">./gradlew iphone_simPlatformLibs
./gradlew iphone_simCrossDistRuntime</pre>

to compile the Kotlin bridge for the iOS Simulator platform libs and runtime. The command will take about 1 hour to complete on a recent MacBook Pro.

Also, [the samples](https://github.com/JetBrains/kotlin-native/tree/master/samples) have been adapted and you will now be able to try out the features straight on your simulator.

And that’s pretty neat.