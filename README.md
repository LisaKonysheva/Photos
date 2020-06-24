# Photos

App that displays list of photos retrieved from the network.

What was achieved:
- App uses light version of image cache and downloads images asynchronously
- I've used DI extensively so all app components could be easily tested 

What can be improved:
- I didn't manage to write lots of unit tests, but existing ones give an idea how unit testing could be implemented for the whole app.
- Proper error handling (with retry button), loading indicators could make UX better
- Fetching 5000 items is not a nice idea, would be nice to have paging implemented on backend side.

* I've noticed weird behaviour on iPhone 11 Simulator (iOS 13.5), photos in the list sometimes become unresponsive. On other simulators there is no such issue. I haven't time to investigate the issue deeper, could be connected with new iOS 13 tableViewController api.
