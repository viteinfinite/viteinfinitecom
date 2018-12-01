---
id: 174576718
title: Swift on the Raspberry PI
date: 2017-02-08T20:05:54+00:00
layout: post
guid: http://viteinfinite.com/?p=174576718
permalink: /2017/02/swift-on-the-raspberry-pi-part-1/
dsq_thread_id:
  - "5534253417"
categories:
  - Uncategorized
---
In this article we will discover how to use the Swift programming language to write software running on our Raspberry PI. We’ll be reading and writing through the GPIO of our board, connecting a number of widely available components and, at the same time, interacting with a remote sever.

Here, I’ll be covering how to get started with Swift on a Raspberry PI board.

<!--more-->

Swift is a programming language released by Apple in 2014 which has received an ever increasing interest from the mobile community, thanks to its modern patterns, its static typing and its performances.

Since October 2015, Swift has been Open Sourced and it can now run on a plethora of Linux distributions, making it an interesting, even though experimental, for the development of Server-Side Software.

Even if, once released, Swift for Linux only was able to run on x86 Hardware only, after some efforts from the community, the language can be compiled, and compile, on ARM machines, such as the really popular Raspberry PI (and its clones), C.H.I.P., and many others.

The most straightforward way to have Swift running on a ARM Linux distribution is to start from the most widespread of them: Ubuntu. The popular operating system now ships a version specifically built for our favourite single-board computer, named Ubuntu Core. With the words of its own maker, Ubuntu Core is << a tiny, transactional version of Ubuntu for IoT devices and large container deployments. It runs […] secure, remotely upgradeable Linux app packages known as snaps. >>. In this series we won’t be using Snaps, but we will instead make use of the traditional layer of Ubuntu, called “classic”.

The introduction is now over, let’s get started!

## 0. Requirements

In order to complete this tutorial, we need:

  * A Micro-SD card of at least 8GB of size (16GB recommended for building Swift from sources)
  * A Raspberry PI 3
  * An Ubuntu SSO Account, used to complete the setup of Ubuntu Core.
  * An external screen for our Raspberry (actually needed only when booting Ubuntu Core for the first time)

In order to create an Ubuntu account, please refer to the [Ubuntu SSO account](https://login.ubuntu.com/) page. Do not forget to add your SSH public key, as it’s needed for logging in to Ubuntu Core.

## 1. Installing Ubuntu Core

Install Ubuntu Core by following the instructions on the Get Started page of Ubuntu Core: <https://developer.ubuntu.com/core/get-started/raspberry-pi-2-3>

Copy the image onto the micro-SD card, plug the card into the Raspberry PI and boot your Raspberry PI.

Follow the on-screen setup wizard, type your Ubuntu SSO account email and you’re done.

You can now simply ssh from your development machine to your Raspberry PI:

<pre class="lang:sh decode:true">ssh &lt;USERNAME&gt;@&lt;RASPBERRY-IP&gt;</pre>

## 2. “classic” mode

Despite Ubuntu focus on Snap apps, we won’t be using Ubuntu this feature at the moment, as we need to enable the traditional development mode of our Ubuntu installation, now dubbed classic.

To do so, run :

<pre class="lang:sh decode:true">$ sudo snap install classic --edge --devmode
$ sudo classic</pre>

## 3. Update apt-get

Since the Ubuntu Core installation hasn’t received any repository update yet, it’s now the moment to fetch the packages:

<pre class="lang:sh decode:true ">$ sudo apt-get -qq update</pre>

## 4. Installing Swift

There are two ways for get Swift running on your installation, the first one being compiling Swift from sources. This operation can take a long amount of time: that is, at least 10 hours on a Raspberry PI 3.

Luckily, the team over at [iachieved.it](http://iachieved.it) have been regularly compiling versions from source and distributing the artefacts via a Jenkins installation available at <http://swift-arm.ddns.net>.

This is a major simplification in our process, as we will be saving hours of compilation time and get straight to the installation part.

At the time of writing, the most recent compiled version dates December, 21st 2016, as the machine used for compiling seems to have been offline for the past 30 or so days. The compiled Swift version is the 3.0.1-dev rather than the current 3.0.2 but that doesn’t affect in any way our setup.

So, let’s install wget from apt-get, which will allows us to download the Swift artefact:

<pre class="lang:sh decode:true ">$ sudo apt-get install wget</pre>

Then, let’s proceed to Swift itself:

<pre class="lang:sh decode:true ">$ wget http://swift-arm.ddns.net/job/Swift-3.0-Pi3-ARM-Incremental/lastSuccessfulBuild/artifact/swift-3.0-2016-12-21-RPi23-ubuntu16.04.tar.gz</pre>

Now, time to unarchive the Swift package:

<pre class="lang:sh decode:true ">$ mkdir swift-3.0 && cd swift-3.0
$ tar -xvzf ../swift-3.0-2016-12-21-RPi23-ubuntu16.04.tar.gz</pre>

And, finally, add the folder we’ve extracted swift to to our PATH:

<pre class="lang:sh decode:true ">$ export PATH=$HOME/swift-3.0/usr/bin:$PATH</pre>

## 5. Dependencies

The installation is virtually over, but we need to install a number of dependencies needed by Swift at runtime.

Let’s launch the following command – and take the time to drink a long coffee. Or two.

<pre class="lang:sh decode:true ">$ sudo apt-get install -y libpython2.7 libxml2 libicu-dev clang-3.6 libcurl3
$ sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.6 100
$ sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.6 100</pre>

## 6. Verifying your installation

Still there? Let’s verify that our installation is correct. Upon running the following command

<pre class="lang:sh decode:true ">$ swift --version</pre>

we should be greeted with the following line:

<pre class="lang:sh decode:true">Swift version 3.0.1-dev (LLVM a922364e5b, Clang 968470f170, Swift 0cca6668a2)
</pre>

## 7. Our first project

We’re finally taking the time to create and run a first empty project.

<pre class="lang:sh decode:true">$ cd $HOME
$ mkdir proj && cd proj
$ swift package init --type executable
$ swift build
</pre>

And let’s finally run it:

<pre class="lang:sh decode:true ">$ .build/debug/proj</pre>

## Acknowledgements

This article would not have been possible without the work of many developers from the iOS and Swift community, some of them being:

  * Joe ([@iachievedit](https://twitter.com/iachievedit)) <http://dev.iachieved.it>
  * William Dillon ([@hpux735](https://twitter.com/hpux735)) [http://www.housedillon.com](http://www.housedillon.com/)
  * Ryan Lovelett ([@rlovelett) ](https://twitter.com/rlovelett)<http://stackoverflow.com/users/247730/ryan>
  * Brian Gesiak ([@modocache](https://twitter.com/modocache)) [http://modocache.io](http://modocache.io/)
  * [Karl Wagner](https://github.com/karwa) <http://www.springsup.com/>
  * [@tienex](https://twitter.com/tienex) [tienex](https://github.com/tienex)
  * PJ Gray ([@pj4533](https://twitter.com/pj4533)) [Say Goodnight Software](http://saygoodnight.com/)
  * Cameron Perry ([@mistercameron](https://twitter.com/mistercameron)) [http://mistercameron.com](http://mistercameron.com/)

## Conclusion

That’s all for today! We now have our foundation block for controlling the GPIO of our Raspberry PI. That said, this setup is already sufficient for running Swift code and, even, a local Web Server through Web Frameworks like Kitura or Vapor. But let’s stick to our goal: next up, SwiftyGPIO.