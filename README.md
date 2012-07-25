RetroPod - The original iPod, on your iPhone
========================================

![RetroPod](http://retropod.de/img/screens/02.png)

**RetroPod is simulation of the original iPod for iPhone and iPod touch originated by Johannes Lechner.**  
It was crafted with much love and care for details and is now available under the GPL.

Official Website: [http://RetroPod.de](http://RetroPod.de) 
Backstory:  
Contact: Hello __at__ RetroPod.de 

Installation
------------
Open with Xcode, change the provisioning info (if necessary) and run it on your iPhone.

Features
--------

* Navigate your songs by album, artist, genre and more
* Fast forward/rewind and skimming
* Working battery indicator
* Backside with custom engraving and real-time mirror

Hacking Ideas
=============

* Recreate the Breakout Game
* Add an about screen
* Integrate with MPNowPlayingInfoCenter, i.e. have the RetroPod app icon showing in the multitasking UI.
* Allow browsing of your contacts
* Recreate the calendar

Code Structure
==============

This quick overview should be enough to get you started on writing your own extensions.

PodViewController
-----------------
This class integrates all the pieces (which are explained later on).

First, a stack of `Content` is maintained, similar to the `UIViewController` stack managed by a `UINavigationController`:   
     - (void)pushContent:(Content *)content animate:(BOOL)a;  
     - (void)popContentAnimate:(BOOL)a toRoot:(BOOL)r;   
`PodViewController` is responsible for presenting the right `Controller` based on `Content` subclass passed.

Second, it dispatches `ScollWheelView` events (e.g. Prev, Next, etc.) to the currently active controller.

Third, it creates a `Menu` instance for the main menu with `MenuItems`, which in turn can also contain `Menus`.
It then pushes a `PodController` responsible for displaying this main menu on the stack.

Model
-----
`Content` subclasses model the different screen types available in RetroPod.  
Current subclasses are `Player` (displaying the currently played song), `MainMenu` (root menu) and `MediaMenu` (list of songs).

`Menu` subclasses display a list of `MenuItems`.

Controller
----------
`PodController` subclasses contain the logic of RetroPod.  
`PodViewController` forwards `ScollWheelView` events to them and calls their `activate`/`deactivate` methods before display/after disposal accordingly.

Current subclasses are `PlayerController` (responsible for controlling music playback and playlist management via `MPMusicPlayerController`) and `MenuController` (responsible for coordinating the rendering of `Menus` and executing the `Actions` assigned to the `MenuItems`).

Each `PodController` can have a `parentController` to which it can forward events it can't process.
This for example allows the Play/Pause button to function (which is implemented in `PlayerController`), even when a `MenuController` is currently displayed:
The `MenuController` receives the event, decices that it can't do anything useful with it and then forwards it to its parent.

Display
-------
This group contains subclasses of `ContentView` analogous to the `Content` subclasses of the Model group.
So for example `Player`, `PlayerView` and `PlayerController` all fit together.

Further it contains `DisplayView`, which is responsible for animating in the `ContentViews` in & out.

Action
------
There can be an `Action` attached to an `MenuItem`.    
For example a `SettingsAction` is responsible for changing preferences accordingly.

Back Side
---------
This group contains the implementation of the back side of RetroPod.