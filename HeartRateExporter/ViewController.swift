//  Created by Brad Larson on 5/6/2015.
//  Sunset Lake Software LLC.

import UIKit
import HealthKit

class ViewController: UIViewController {

    let healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let heartRateType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
        
        if (HKHealthStore.isHealthDataAvailable()){
            var csvString = "Time,Date,Heartrate(BPM)\n"
            self.healthStore.requestAuthorizationToShareTypes(nil, readTypes:[heartRateType], completion:{(success, error) in
                let sortByTime = NSSortDescriptor(key:HKSampleSortIdentifierEndDate, ascending:false)
                let timeFormatter = NSDateFormatter()
                timeFormatter.dateFormat = "hh:mm:ss"

                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM/dd/YYYY"

                let query = HKSampleQuery(sampleType:heartRateType, predicate:nil, limit:600, sortDescriptors:[sortByTime], resultsHandler:{(query, results, error) in
                    guard let results = results else { return }
                    for quantitySample in results {
                        let quantity = (quantitySample as! HKQuantitySample).quantity
                        let heartRateUnit = HKUnit(fromString: "count/min")
                        
//                        csvString.extend("\(quantity.doubleValueForUnit(heartRateUnit)),\(timeFormatter.stringFromDate(quantitySample.startDate)),\(dateFormatter.stringFromDate(quantitySample.startDate))\n")
//                        println("\(quantity.doubleValueForUnit(heartRateUnit)),\(timeFormatter.stringFromDate(quantitySample.startDate)),\(dateFormatter.stringFromDate(quantitySample.startDate))")
                        csvString += "\(timeFormatter.stringFromDate(quantitySample.startDate)),\(dateFormatter.stringFromDate(quantitySample.startDate)),\(quantity.doubleValueForUnit(heartRateUnit))\n"
                        print("\(timeFormatter.stringFromDate(quantitySample.startDate)),\(dateFormatter.stringFromDate(quantitySample.startDate)),\(quantity.doubleValueForUnit(heartRateUnit))")
                    }
                    
                    do {
                        let documentsDir = try NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain:.UserDomainMask, appropriateForURL:nil, create:true)
                        try csvString.writeToURL(NSURL(string:"heartratedata.csv", relativeToURL:documentsDir)!, atomically:true, encoding:NSASCIIStringEncoding)
                    }
                    catch {
                        print("Error occured")
                    }
                    
                })
                self.healthStore.executeQuery(query)
            })
        }
    }
}

