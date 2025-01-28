---
id: 174576632
title: About the Builder Pattern in Objective&#8209;C
date: 2013-05-25T23:54:06+00:00
layout: post
guid: http://www.viteinfinite.com/?p=174576632
permalink: /2013/05/about-the-builder-pattern-in-objective-c/
dsq_thread_id:
  - "1319323687"
categories:
  - iOS Development
  - Mobile Development
---

When dealing with complex object creation in an iOS application you may feel the need for a cleaner and more fluent approach.

During my latest development my colleague @alexiskinsella set up a pattern based on providers in order to mimic the factory behaviour we often find in languages such as Java.

Recently, in the occasion of a side project, I am studying a slightly different approach, based on [this article](http://matthiaswessendorf.wordpress.com/2012/11/12/objective-c-builder-pattern-vs-configuration-objects/) by Matthias Wessendorf.

<!--more-->

What I am willing to do is an image builder which creates UIImages on which a GPUImageFilter is applied.

The result I came to is as follows:

# The Builder itself (implementation)

<pre class="toolbar-overlay:false plain:false lang:objc decode:true" title="The Builder itself">+ (SMFilteredImageBuilder *)builderWithConfigurationBlock:(FilteredImageConfigurationBlock)configBlock
{
    return [[self alloc] initWithConfigurationBlock:configBlock];
}

- (id)initWithConfigurationBlock:(FilteredImageConfigurationBlock)configBlock
{
    if (self = [super init]) {
        self.configuration = [SMFilteredImageConfiguration configuration];
        if (configBlock) {
            configBlock(self.configuration);
        }
    }

    return self;
}

- (UIImage *)build
{
    [self.configuration.imagePicture processImage];
    return [self.configuration.filter imageFromCurrentlyProcessedOutput];
}</pre>

# The Configuration object (header)

<pre class="toolbar-overlay:false plain:false lang:objc decode:true" title="The Configuration object (header)">@interface SMFilteredImageConfiguration : NSObject

@property GPUImageFilter *filter;
@property GPUImagePicture *imagePicture;

+ (instancetype)configuration;

@end</pre>

#  Using a Builder with an inline Configuration

<pre class="toolbar-overlay:false plain:false lang:objc decode:true" title="Using a builder with configuration">- (void)saveFilteredImage:(UIImage *)image
{
    SMFilteredImageBuilder *imageBuilder = [SMFilteredImageBuilder builderWithConfigurationBlock:^(SMFilteredImageConfiguration *configuration){
        GPUImagePicture *sourceImagePicture = [[GPUImagePicture alloc] initWithImage:image];
        configuration.filter = [GPUImageFilter filterForSquaredImageFromImagePicture:sourceImagePicture withSide:100.0];
        configuration.imagePicture = sourceImagePicture;
    }];

    UIImage *filteredImage = [imageBuilder build];
    [filteredImage saveToDocumentsFolderWithName:@"Filtered.png"];
}</pre>

This should make for a quite readable code with a reduced number of lines of code in the method that invokes the builder.