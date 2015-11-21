import CoreData

class PersistenceStack {
    private(set) var context: NSManagedObjectContext!

    private let modelName: String
    private var objectModel: NSManagedObjectModel!
    private var storeCoordinator: NSPersistentStoreCoordinator!


    init(modelName: String) {
        self.modelName = modelName
        
        self.setupObjectModel()
        self.setupStoreCoordinator()
        self.setupContext()
    }
    
    
    //MARK: - Private
    private func setupObjectModel() {
        guard let URL = NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd") else {
            fatalError("Failed to find managed object model file.")
        }
        
        self.objectModel = NSManagedObjectModel(contentsOfURL: URL)
    }
    
    private func setupStoreCoordinator() {
        self.storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.objectModel)
        
        do {
            try self.storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.storeURL(), options: nil)
        } catch {
            fatalError("Failed to add persistent store.")
        }
    }
    
    private func setupContext() {
        self.context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self.context.persistentStoreCoordinator = self.storeCoordinator
    }
    
    private func storeURL() -> NSURL {
        guard let docuementsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last else {
            fatalError("Failed to find documents directory.")
        }
        
        return docuementsURL.URLByAppendingPathComponent(self.modelName + ".sqlite")
    }
}
