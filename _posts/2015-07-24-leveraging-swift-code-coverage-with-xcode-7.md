---
id: 174576697
title: Leveraging Swift Code Coverage with Xcode 7
date: 2015-07-24T13:25:59+00:00
layout: post
guid: http://viteinfinite.com/?p=174576697
permalink: /2015/07/leveraging-swift-code-coverage-with-xcode-7/
dsq_thread_id:
  - "3966420505"
categories:
  - iOS Development
  - Mobile Development
---

One of the WWDC 2015 announcements that <del>surprised</del> interested us the most has definitely been the support for **code coverage for the Swift language**.
  
In this article we will understand the advantages of the new code coverage functionality introduced in Xcode 7 and how to integrate such KPI in our daily work.

<!--more-->

* * *

> French speakers: the original version of this article is actually French, and you can [read it on Xebia’s excellent blog](http://blog.xebia.fr/2015/07/20/exploitons-la-couverture-de-code-en-swift/).

> Also, this article is the text version of the talk “Leveraging Xcode Code Coverage”, presented at the [Mobile Optimized conference in Minsk](https://mo.dev.by), whose [slides are available here](https://speakerdeck.com/viteinfinite/leveraging-xcode-code-coverage).

* * *

Code coverage is a metric that measures the value of our tests by identifying what code is executed when running them and, above all, what portions of our project are untested.

## How it works?

The production of code coverage information is done in two passes:

  1. At compile time, the compiler prepares the files for analysis
  2. At runtime, the lines of code affected by the tests are annotated in a specific file

# Xcode code coverage before June 2015

<span style="line-height: 1.714285714; font-size: 1rem;">Before WWDC 2015, only the Objective-C code coverage was supported by Apple’s tools, while Swift had been left behind. Also, the Objective-C support was sometimes inconsistent and required a few tricks to get the information.</span>

## How did it work?

The procedure necessary to retrieve the information was a variant of the one used by gcov, included in the gcc tools. Two settings had to be added to the Build Settings:

  1. _Generate test coverage files_, which corresponds to the <span class="lang:default decode:true  crayon-inline">-ftest-coverage</span> gcc flag
  2. _Instrument program flow_, corresponding to <span class="lang:default decode:true  crayon-inline ">-fprofile-arcs</span>

The former allows the creation of the _.gcno_ files, which contain the information needed to build the execution graph and reconstruct the line numbers.

The latter, _Instrument program flow_, deals with the creation oft the _.gcda_ files, which contain the number of transitions on different arcs of the graph and other summary information.

In order to force the generation of these command line data, it was possible to use the following command:

<pre class="lang:sh decode:true">GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES
    GCC_GENERATE_TEST_COVERAGE_FILES= YES
    xcodebuild [...]
    test
</pre>

## Exploiting the data

A number of tools for reading and exporting reports exist, but in particular, we used the following:

  * **Coverstory**, a GUI tool to read files “.gcda” and “.gcno”
  * **gcovr** translates these files Cobertura XML format
  * **lcov** generates a visual report in a navigable HTML
  * and, especially, **Slather**.

### Slather

Slather, developed by the SF-based company Venmo, exports the code coverage data in a number of different formats, including Gutter JSON, Cobertura XML, HTML and plain text. In addition, it integrates easily with other platforms, such as Jenkins, Travis CI, Circle CI and coveralls.

As said, one of the major assets of Slather is its ease of configuration and integration within a continuous integration system. Slather is open source, and available here at [Venmo’s GitHub repo](http://github.com/venmo/Slather).

### Swiftcov

A recent tool for collecting Swift coverage information is [Swiftcov](https://github.com/realm/SwiftCov), developed by the guys at Realm. Swiftcov makes heavy use of LLDB breakpoints to detect which lines are affected by the execution of our tests.

# Code coverage after June 2015

During the WWDC 2015 keynote, Apple announced that Xcode 7 would introduce support of code coverage for our beloved Swift.

## How does it work?

A completely new format has been introduced, named profdata, thus making
  
gcov legacy – at least for what concerns projects developed with Apple’s development tools.

In other words, starting from the very first beta of Xcode 7, profdata is intended to replace completely gcov for both Swift and Objective-C.

In order to enable the setting, from Xcode 7, you will need to access the “scheme” setting and, in the “Test” tab, to tick the “Gather coverage data” checkbox.

![](http://viteinfinite.com/wp-content/uploads/2015/07/collect_coverage_annotated.png)

As for the command line, xcodebuild now ships with a new parameter, <span class="lang:default decode:true  crayon-inline">-enableCodeCoverage</span>, which can be used as follows:

<pre class="lang:sh decode:true">xcodebuild
    -scheme MoDevByProject
    -destination "name=iPhone 6,OS=latest"
    -enableCodeCoverage YES
    test
</pre>

Once the tests run, coverage information is immediately available in Xcode, on the right side of the code editor (see image below) and, in particular, in the “Report Navigator”.

![](http://viteinfinite.com/wp-content/uploads/2015/07/Screen-Shot-2015-07-24-at-15.03.52.png)
_Inline code coverage information_

![](http://viteinfinite.com/wp-content/uploads/2015/07/Screen-Shot-2015-07-14-at-11.41.36.png)
_The new Report Navigator_

The Report Navigator shows in detail which classes are covered by our tests and, by expanding the selection, which methods are actually used.

## Exploiting the data

Apple’s work hasn’t only consisted in enhancing Xcode but, also, in extending the features of the  <span class="lang:default decode:true  crayon-inline">llvm-cov</span> command line tool, which allows working with .profdata format.

The <span class="lang:default decode:true  crayon-inline ">llvm-cov show</span> command, for instance, allows exporting plain text coverage information and outputs annotated source code files, which can be easily read and processed.

### Slather (returns)

[A recent Pull Request](https://github.com/venmo/slather/pull/92) allows Slather to work with profdata files and convert them to other formats, thus enabling the integration with the other platforms supported by the tool.

### Xcode Server

If you are thinking about setting up an automated integration system, aside from the excellent Jenkins, Travis or Circle CI, it is perhaps time to start taking into consideration Xcode Server, which is part of the OS X Server bundle, distributed free of charge by Apple.

With the new version of Xcode bots and Xcode Server, it is now possible to support code coverage values ​​and to display the results in a Web browser. The reports are also available in the “Big Screen” presentation, useful for presenting your content in a simplified yet effective overview.

In order to enable this workflow, you could follow the steps below:

  1. Install OS X server
  2. Enable “Xcode” and “Websites” services
  3. Create a new project and assign a Source Control Manager to it (such as git)
  4. In Xcode, create an Xcode bot under “Product > Create Bot”
  5. Select the frequency of integration and enable code coverage (see image below) next to the caption “Code Coverage”.
  6. Launch an integration
  7. Open the web browser at the host indicated by your instance of Mac OS.

![](http://viteinfinite.com/wp-content/uploads/2015/07/bot_coverage.png)
_Xcode Bot creation panel_ 

# Conclusion

Code coverage is very useful to keep under control your code base health status. Although it can not replace your developer confidence in well designed, well structured apps, this metric can help write better code by encouraging you to give yourself concrete goals day by day.

Also, and finally, the new tools offered by Apple can now allow you to keep under control these values ​​in minutes, with a simple and immediate configuration.