---
id: 174576681
title: Some opinions about Calabash-iOS
date: 2014-01-31T14:36:33+00:00
layout: post
guid: http://www.viteinfinite.com/?p=174576681
permalink: /2014/01/some-opinions-about-calabash-ios/
dsq_thread_id:
  - "2200352410"
categories:
  - iOS Development
  - Mobile Development
---

For what concerns iOS my colleagues and I have been using Calabash-iOS for a year now, with mixed feelings.
  
Here is a totally subjective opinion about Pros and Cons of Calabash-iOS

<!--more-->

## Pros:

  * Conciseness of the Gherkin language
  * Capability of querying webviews with CSS selectors
  * Access to all the object property values via Ruby
  * built-in Jenkins-Ready output (xml and HTML test reports, mainly)
  * Performance (on <= iOS 6)
  * It does not uniquely rely on accessibilityIdentifiers (as KIF does)
  * Actively mantained

## Cons:

  * It’s not an Apple-backed project : functionalities change significantly from OS to OS
  * Test fail randomly under certain circumstances and, in particular, when dealing with repeated scrolling on a UIScrollView (due to a poor implementation of the scroll/swipe functions)
  * On iOS 7, it relies on UIAutomation, thus…
  * …terrible performance on iOS 7 (see above)
  * Once again, quite a Pain-in-the-ass to make it work on iOS 7
  * Finding the good query for your element usually requires much trial-and-error via the calabash-ios console (Frank provides a nice UI tool for that task, but it’s not merged into Calabash-iOS yet)

Truth to be told, at this stage, the performance impact of relying on UIAutomation is deal breaker for me, so, on the next project we’ll be using [KIF](https://github.com/kif-framework/KIF), which appears to be also used in [some Google projects](http://googletesting.blogspot.fr/2013/08/how-google-team-tests-mobile-apps.html).