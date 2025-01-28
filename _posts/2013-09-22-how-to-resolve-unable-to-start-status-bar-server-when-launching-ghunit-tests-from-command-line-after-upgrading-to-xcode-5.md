---
id: 174576674
title: How to resolve “Unable to start status bar server” when launching GHUnit Tests from command line after upgrading to XCode 5
date: 2013-09-22T01:38:30+00:00
layout: post
guid: http://www.viteinfinite.com/?p=174576674
permalink: /2013/09/how-to-resolve-unable-to-start-status-bar-server-when-launching-ghunit-tests-from-command-line-after-upgrading-to-xcode-5/
dsq_thread_id:
  - "1785219175"
categories:
  - iOS Development
  - Mobile Development
---

After upgrading to XCode 5 my Jenkins Continuous Integration machine over at Xebia stopped executing command-line GHUnit tests under some apparently random conditions. The console output was as follows:

<!--more-->

<pre class="lang:sh decode:true">*** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Unable to start status bar server. Failed to check into com.apple.UIKit.statusbarserver: unknown error code'</pre>

The reason of the exception looks pretty much the same I had to deal with some months ago (and solved in [a previous post](http://www.viteinfinite.com/2013/05/how-to-resolve-unable-to-start-status-bar-server-failed-to-check-into-com-apple-uikit-statusbarserver-unknown-error-code-exception/ "How to resolve “Unable to start status bar server. Failed to check into com.apple.UIKit.statusbarserver: unknown error code” exception")).

Well, it turns out that after the XCode upgrade, after quitting an iOS 5.x or iOS 6.x simulator instance, the SpringBoard daemon (along with many others) does not get removed, thus preventing our test target to instantiate a status bar. Interestingly enough, this behaviour does not occur when quitting an iOS 7.0 simulator.

That said, in order to fix the issue, I added the following line to the RunTests.sh script:

<pre class="lang:sh decode:true"># Remove Springboard daemon which may be pending
launchctl remove 'com.apple.iPhoneSimulator:com.apple.SpringBoard' &&gt; /dev/null</pre>

The complete RunTests.sh script is available at [this public gist](https://gist.github.com/viteinfinite/6655857).