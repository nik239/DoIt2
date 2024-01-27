DoIt is a simple but well-built to-do list that I've made from scratch in UIKit. 
Here're some of the things I was able to implement in it: 
1) Clean architecture with MVVM + Coordinator
2) Persistence through Core Data
   - Clean, efficient fetching with NSFetchedResultsController
   - Table views driven by NSManagedObjectContext, through a combination of NSFetchedResultsController and a custom diffable data source
3) Unit tests and snapshot tests
   - Efficient testing of CoreData-dependent objects, by using a TestCoreDataStack for in-memory storage
4) A fully programmatic UI with SnapKit (no Soryboards)
