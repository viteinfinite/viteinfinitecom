---
id: 174576653
title: Introducing SMWheelControl
date: 2013-06-10T09:13:50+00:00
layout: post
guid: http://www.viteinfinite.com/?p=174576653
permalink: /2013/06/introducing-smwheelcontrol/
dsq_thread_id:
  - "1384373069"
categories:
  - iOS Development
tags:
  - cocoapods
  - pod
  - smwheelcontrol
---

Today I am proud to announce the availability of a new Pod for iOS which will be included in my forthcoming app.

# **SMWheelControl**

an iOS control allowing the selection of an item from a 360° spinning wheel with a smooth inertial rotation.

<!--more-->

The code, released under the BSD 3-clause license, is loosely based on the tutorial “How To Create a Rotating Wheel Control with UIKit” published on [this Ray Wenderlich’s post](http://www.raywenderlich.com/9864/how-to-create-a-rotating-wheel-control-with-uikit) by [Cesare Rocchi](http://twitter.com/@_funkyboy)

As usual, you can insert it into your podfile by adding

<pre class="font-size:16 show-lang:2 lang:ruby decode:true">pod "SMWheelControl", "0.1.1"</pre>

Some howto follows.

# Usage

## <a href="https://github.com/viteinfinite/SMWheelControl#initialization-and-data-source" name="initialization-and-data-source"></a>Initialization and data source

Instantiate the control with a classical `- (id)initWithFrame:(CGRect)rect` and add a target as you usually do with a control, e.g.:

<div>
  <pre class="crayon-selected">SMWheelControl *wheel = [[SMWheelControl alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
[wheel addTarget:self action:@selector(wheelDidChangeValue:) forControlEvents:UIControlEventValueChanged];</pre>
</div>

Then add a dataSource:

<div>
  <pre>wheel.dataSource = self;
[wheel reloadData];</pre>
</div>

and implement the following methods (the dataSource should conform to the `SMWheelControlDataSource`):

<div>
  <pre>- (UIView *)wheel:(SMWheelControl *)wheel viewForSliceAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfSlicesInWheel:(SMWheelControl *)wheel;</pre>
</div>

For instance:

<div>
  <pre>- (NSUInteger)numberOfSlicesInWheel:(SMWheelControl *)wheel
{
    return 10;
}

- (UIView *)wheel:(SMWheelControl *)wheel viewForSliceAtIndex:(NSUInteger)index
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@" %d", index];
    return label;
}</pre>
</div>

When the wheel ends snapping to the closest slice, if you added a target, then it will receive the event `UIControlEventValueChanged`, and the selector you specified will be executed.

<div>
  <pre>- (void)wheelDidChangeValue:(id)sender
{
    self.valueLabel.text = [NSString stringWithFormat:@"%d", self.wheel.selectedIndex];
}</pre>
</div>