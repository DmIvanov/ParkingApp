# ParkingApp

There are several users in the app and it's possible to create new ones. Users have their profile with some personal data and set of cars. When some user logged in they can pick one of the available parking zones on a map view and park their car. When the parking is over the user stops it. There is a history of parkings of the user available as well.

The app communicate to the remote API (backed by Firebase) to create, retrieve and change the app data: users, cars, parkings.

## Main concepts of the project are:
	- modularity 
	- clear object's responsibilities 
	- clear APIs 
	- testability

## Screens/features implemented:
	- Login Screen. At this screen the user is able to select the app user (login) or create a new user.
	- Menu. To switch between different scenes (Login, Start Parking, User Profile...). Implemented as a simple UIAlertController.
	- Start Parking Screen.  
		  * Map with all parking zones on it. User is able to select one.  
		  * When zone is selected the UI updates accordingly.
		  * When "start parking" pressed, the parking is started (with selected vehicle for selected zone).
	- Parking Screen.  Displays details of the current parking action (startDate, vehicle number, zone id)
		  * When “stop parking” pressed (if this is running parking action) the current perking action is considered as finished and being added to History.
	- History Screen. List of parking actions which are finished.
	- User Profile Screen. Editable user details
	- Vehicles Screen. A screen to select default vehicle or add a new one to the user’s account.
