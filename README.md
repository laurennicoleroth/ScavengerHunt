<img src="https://swift.org/assets/images/swift.svg" alt="Swift logo" height="70" >
# Scavenger Hunt

**Welcome to Scavenger Hunt!**

Scavenger Hunt is a playable game (almost) where the user offers their location and gets museums nearby to hunt down. It could be any type of location that you can query from Google Places, I just chose museums because I like them. The object of the game is to pick a location by clue, look at its detail view, then drop a pin to see if you have found the answer!

WelcomeViewController:
- Request user's current location.
- Issue a request to Google Places when the user hits "play" button
- (I initially built this out with NYC Open Data and Mapkit, but that was not the right way to go)
- Use Alamofire, SwiftyJSON, and a JSON parser to grab and render manageable responses to a request with these parameters:

`let params: [String:AnyObject] = ["key": Constants.Keys.GoogleKey,
                                          "radius": "2000",
                                          "location": "\(latitude)," + "\(longitude)",
                                          "rankBy": "distance",
                                          "types": "museum"]
                                        `
- Send the places to the PlacesTableViewController by setting the variable on that view controller called googlePlaces, which is an [Place]
- I might add a scene in between Welcome and the Places TableView to log in a user (I started adding Firebase to let users log in using Facebook, but that's been a yak-shave every time I've done it, so I didn't get to it (yet))

PlacesTableViewController
- Using the array of places, googlePlaces, populate a tableview with them
- Ability to grab the photo for each location is there. I need to figure out how to only populate it once the user has "solved" that location. Probably using a more MVVM approach.
- I have defaults showing up for each place until I can figure out good clues for each of them.
- I started writing a silly anagram extension on array to make the place name itself a kind of word clue, but that didn't seem like the best approach.
- What really needs to happen is I need to augment the Place struct to add a clue and have a user with an "admin" role add clues for each location
- For the didSelectRowAtIndexPath, simply pass along the specific place from the array to the PlaceDetailsViewController where the play will actually happen.

PlaceDetailsViewController
- Where the fun happens!
- global of type Place passed from the tableview, there to operate on and used to center the map, but initially none of its properties are shown.
- If you tap on the map, it'll show you how close you are (I just used the coordinates of the dropped pin and compared them using distanceFromLocation to get a distance in feet from the place's correct coordinates)
- Each time you drop a pin, the callout shows how close you are, as does the name of the place at the top of the scene.
- Once you are within 1000 ft (totally arbitrary), all the correct properties get displayed and you get a congratulations for finding the spot! Fun, right? Well, the next thing to do is to update the place in the tableview you came from with all the correct details, show a fun alert (or something), then remove the location from the tableview with animation.

## Documentation

To Install
Run this command:

`git clone https://github.com/laurennicoleroth/ScavengerHunt`

This repository uses pods for all its dependencies so also run:

`pod init`

then

`pod install`

The podfile looks like this, but adjust the version if you are running something else:

`platform :ios, '9.3'
use_frameworks!

target 'ScavengerHunt' do
  pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git', :branch => 'xcode7.1'
  pod 'Alamofire', '~> 3.4'
  pod 'GoogleMaps'
  pod 'Firebase'
end

target 'ScavengerHuntTests' do
  pod 'Quick'
  pod 'Nimble'
end`


(Fun fact, if you forget to uncommend Pods in your .gitignore you may end up trying to push *giant* pods, Google Maps is huge, to github. I ran into this limit, tried to retroactively remove these files from the history and clean the repo, but it ended up being better to just create a new project will all my code from a previous repo with a proper .gitignore)


This was fun!! I really want to keep working on this, especially if you have ideas for improvements.