---
id: 174576622
title: 'How to resolve “Unable to start status bar server. Failed to check into com.apple.UIKit.statusbarserver: unknown error code” exception'
date: 2013-05-20T14:48:43+00:00
layout: post
guid: http://www.viteinfinite.com/?p=174576622
permalink: /2013/05/how-to-resolve-unable-to-start-status-bar-server-failed-to-check-into-com-apple-uikit-statusbarserver-unknown-error-code-exception/
dsq_thread_id:
  - "1311130603"
categories:
  - iOS Development
  - Mobile Development
---
Ever wondered how to resolve the following error while executing GHUnitTest by Command Line?

`*** Assertion failure in -[UIStatusBarServerThread main], /SourceCache/UIKit_Sim/UIKit-2372/UIStatusBarServer.m:96<br />
*** Terminating app due to uncaught exception ‘NSInternalInconsistencyException’, reason: ‘Unable to start status bar server. Failed to check into com.apple.UIKit.statusbarserver: unknown error code’`

<!--more-->

In my situation, the exception was caused by having an iPhone Simulator session opened while executing the CLI tests. So, in order to resolve the issue, I simply had to add

`killall -s "iPhone Simulator" &> /dev/null<br />
if [ $? -eq 0 ]; then<br />
killall -m -KILL "iPhone Simulator"<br />
fi`

on top of the run script file (RunTests.sh) which is executed as last “build phase” of the build process.

**EDIT**: I wrote [another post](http://www.viteinfinite.com/2013/09/how-to-resolve-unable-to-start-status-bar-server-when-launching-ghunit-tests-from-command-line-after-upgrading-to-xcode-5/ "How to resolve “Unable to start status bar server” when launching GHUnit Tests from command line after upgrading to XCode 5") explaining how to solve the error after migrating to XCode 5.