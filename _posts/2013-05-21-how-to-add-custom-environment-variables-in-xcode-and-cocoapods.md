---
id: 174576625
title: How to add custom environment variables in Xcode and CocoaPods
date: 2013-05-21T10:39:56+00:00
layout: post
guid: http://www.viteinfinite.com/?p=174576625
permalink: /2013/05/how-to-add-custom-environment-variables-in-xcode-and-cocoapods/
dsq_thread_id:
  - "1310360062"
categories:
  - Uncategorized
tags:
  - iOS Development
  - Mobile Development
---

Let’s say we would like to share some Xcode environment variables across multiple targets in a project configured with CocoaPods. For instance, we would to use the same app version number across our development and distribution targets in order not to retype the same values for each version bump over and over again.

<!--more-->

The solution I opted for was to:

1. Add a custom xcconfig file (for instance “SharedSettings.xcconfig”) from the Xcode menu

<p style="text-align: center;">
  <a href="http://www.viteinfinite.com/wp-content/uploads/2013/05/Screen-Shot-2013-05-21-at-12.16.11-PM.png"><img class="alignnone size-medium wp-image-174576627" alt="Screen Shot 2013-05-21 at 12.16.11 PM" src="http://www.viteinfinite.com/wp-content/uploads/2013/05/Screen-Shot-2013-05-21-at-12.16.11-PM-300x204.png" width="300" height="204" srcset="http://viteinfinite.com/wp-content/uploads/2013/05/Screen-Shot-2013-05-21-at-12.16.11-PM-300x204.png 300w, http://viteinfinite.com/wp-content/uploads/2013/05/Screen-Shot-2013-05-21-at-12.16.11-PM-624x424.png 624w, http://viteinfinite.com/wp-content/uploads/2013/05/Screen-Shot-2013-05-21-at-12.16.11-PM.png 742w" sizes="(max-width: 300px) 100vw, 300px" /></a>
</p>

<p style="text-align: left;">
  2. In the project settings, change the configuration settings file to “SharedSettings”
</p>

<p style="text-align: left;">
  <a href="http://www.viteinfinite.com/wp-content/uploads/2013/05/Screen-Shot-2013-05-21-at-12.18.43-PM.png"><img class="size-medium wp-image-174576628 aligncenter" alt="Screen Shot 2013-05-21 at 12.18.43 PM" src="http://www.viteinfinite.com/wp-content/uploads/2013/05/Screen-Shot-2013-05-21-at-12.18.43-PM-300x163.png" width="300" height="163" srcset="http://viteinfinite.com/wp-content/uploads/2013/05/Screen-Shot-2013-05-21-at-12.18.43-PM-300x163.png 300w, http://viteinfinite.com/wp-content/uploads/2013/05/Screen-Shot-2013-05-21-at-12.18.43-PM-624x339.png 624w, http://viteinfinite.com/wp-content/uploads/2013/05/Screen-Shot-2013-05-21-at-12.18.43-PM.png 882w" sizes="(max-width: 300px) 100vw, 300px" /></a>
</p>

<p style="text-align: left;">
  3. In settings file, in order to preserve your pod configuration, add
</p>

```
#include "Pods/Pods.xcconfig"
VERSION_NUMBER = 3.0
```

And it’s done: now you can use the environment variable `$(VERSION_NUMBER)`, even in your plist file, without breaking the compatibility with CocoaPods. As a result, any future “pod install” will not break the configuration you have just created.