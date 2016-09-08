# JKHImageZoomTransition


## Overview

JKHImageZoomTransition is a simple Swift 2.2 framework that allows you to add Apple-esque view controller transitions whether its presented within a UINavigationController stack or presented modally. 

See the example below:


![Screen shot](Images/zoom.gif)


## Installation

### CocoaPods

You can quickly start using JKHImageZoomTransition by adding the line below to your project's Podfile  

```pod "JKHImageZoomTransition"```

### Manual

The source is contained inside the ```Pod/Classes``` folder. Simply drag these classes into your project's directory.


## Usage

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

### 0.1.0
- First pre-release.

## Contribution

If you have feature requests or bug reports, feel free to help out by sending pull requests or by creating new issues.

## Author

Joon Ki Hong jhong70@icloud.com

## License

JKHImageZoomTransition is available under the MIT license.