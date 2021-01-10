# A case study in modern iOS development

This project started as a quick exercise / research into ODR (On Demand Delivery) for HTML5 Content using the VIPER Architecture.

Next came the addition of a second module: The Playbook.

Here a Web Service (and later on) a Generic web service is used to fetch a number of Matches from a server, as soon as the data is downloaded they are shown in a table view and at the same time the module's Interactor starts listening on a
Web Socket for match updates (a simple echo service, as we did not have access to a live web socket server).

A Socket Emulator was added that sends messages to the echo service, emulating a server sending data.

As soon as any update arrives, the View's table updates only the row/rows that contain updated data.

The updated data are animated (color + label text flips) so the user knows that data have changed.

Data at the moment are not stored into disk or memory resulting in the playbook reseting after living its screen and returning. Later on a storage service and data manager will be added in order to demonstrate this functionality.

At this point, testing was added to the project, specifically we test in full the PlayBook Module with 100% test coverage :)

Following this, a number of monitoring session using xCode instruments were done, resulting in a cyclic reference bug fix, and a constrains related cpu usage improvement.

As soon as we were done, a new module was added in order to investigate SpriteKit for native games development and SpriteKit Slots was born.

The game is fully responsive, the Slot Machine can be initialised with any number of rows and columns and dependin on the given frame and initialization parameters can even rescale its children in order to fit the available space

At the moment when elements do not fit in specified area, slots have their scalled to a smaller value (and thus breaking the slot's image ratio).

In a next version, more scaling options will be added such as the hole frame of the slot, and repositioning the resulting smaller than provided Slot Machine frame.

At this point an investigation was started into allowing the app to rotate to any orientation, but keep 2 specific views locked:

The SportsBook should only allow for portrait mode, while the Slots Game should be allowed to run in Portrait or Landscape, but disallow rotations after the view has started, as we have not yet implemented the re - scaling/positioning method required, and responsive/positional calculations are done only on initialisation.

At this point and in order to investigate modern usage of CoreData a generic CoreData backed Storage service was introduced. To test its usage, the Sporkbook module now fetches its initial data from the internet only if local/cached data do not exist. If data is here, they are returned and the web call is bypassed.

For testing purposes, we empty the DataStore every time the app starts, as we had some issues with the emulator not deleting data from the app finished handler.

At this point a refactoring is needed to the module's presenter and interactor in order to update its local/stored content with updates received from the socket server. Presenter now calls updateStoredGames() every time it is notified with a new Match update.

Now when users leave the SportsBook view and return they see the same data as the last time they opened the screen. This is not the normal flow for such an app, as in a real case we should fetch new data here, as matches would probably have been updated by now.

Next a Generic data manager will be added, removing Storage and Network dependncies from the Interactors as they now only depend on a signle DataManager for their data.

1.  VIPER Architecture
2.  Project Structure
3.  On Demand Delivery (ODR)
4.  Local HTML5 Content
5.  A Generic Web Service
6.  A Web Socket Service + Local Emulator
7.  Fast TableView updates
8.  Animating TableView row elements
9.  Testing a VIPER based app
10.  Monitoring an iOS app
11.  SpriteKit Slots Game
12.  Orientation support and specific screen locking
13.  A Generic CoreData backed Storage Service
14.  A Generic Data Manager


![Screens of the app](images/VIPER-Hybrid-App-preview.png)

Quickly became a Case Study into using Swift, SwiftLint, Testing, SpriteKit, ++

The app now contains three sections:

![Screens of the app](images/intro-screen.png)

Including a Sportbook with live game updates:

![Screens of the app](images/sports-book.png)

Fully tested:

![Screens of the app](images/sports-book-tests.png)

And Monitored:

![Screens of the app](images/instruments.png)

As well as a full native Slot Machine game made with SpriteKit:

![Screens of the app](images/slots.png)

[More info coming really soon as an update to this file]
