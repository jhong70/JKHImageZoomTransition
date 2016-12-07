# JKHImageZoomTransition
[![Platform](https://img.shields.io/cocoapods/p/JKHImageZoomTransition.svg?style=flat)](https://img.shields.io/cocoapods/p/JKHImageZoomTransition.svg)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/JKHImageZoomTransition.svg?style=flat)](https://img.shields.io/cocoapods/v/JKHImageZoomTransition.svg)
[![License](https://img.shields.io/cocoapods/l/JKHImageZoomTransition.svg?style=flat)](https://img.shields.io/cocoapods/l/JKHImageZoomTransition.svg)

## Overview

JKHImageZoomTransition is a simple Swift 3 framework that allows you to add Apple-esque view controller transitions whether its presented within a UINavigationController stack or presented modally.

See the example below:


![Screen shot](Images/zoom.gif)


## Installation

### CocoaPods

You can quickly start using JKHImageZoomTransition by adding the line below to your project's Podfile  

```pod "JKHImageZoomTransition"```

### Manual

The source is contained inside the ```Pod/Classes``` folder. Simply drag these classes into your project's directory.


## Usage

### JKHImageZoomTransitionProtocol

Your source and destination view controllers need to implement this protocol to facilitate the transition. The protocol is as follows:

	optional func transitionFromImageView() -> UIImageView
    optional func transitionToImageView() -> UIImageView
    optional func transitionDidFinish(completed: Bool, finalImage: UIImage)


```transitionFromImageView``` is called to fetch the UIImageView from the source view controller

```transitionToImageView``` is called to fetch the UIImageView from the destination view controller

```transitionDidFinish``` is called when the view controller transition ends on the destination view controller

### UINavigationController

To use custom view controller transitions inside a UINavigationController as opposed to the standard push and pull transitions, you must first set the navigation controller delegate in your UINavigationController. ```JKHNavigationControllerDelegate``` is conveniently provided to override the standard transitions.

### Modal Presentation

To use custom view controller transitions modally you must:

1. Set the ```transitioningDelegate``` property in your "from" view controller to ```self```.
2. Implement the ```UIViewControllerTransitioningDelegate``` protocol in your "from" view controller to specify which animation controller to use. (Please see ```JKHCorgiCollectionViewController.swift``` as an example)
3. You'll want to implement the following methods:
			- animationControllerForPresentedController
			- animationControllerForPresentedController
4. Return a new instance of the ```JKHImageZoomAnimationController``` with your desired parameters:

	Note: ```JKHImageZoomType``` is an enum that specifies whether you want to use a zoom in or zoom out transition.


## Requirements

- iOS 8.0 or higher

## Change Log

### 0.2.0
- Swift 3 support

### 0.1.0
- First pre-release.

## Author

Joon Ki Hong jhong70@icloud.com

## License

JKHImageZoomTransition is available under the MIT license.
