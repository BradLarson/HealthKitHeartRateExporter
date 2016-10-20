//  Created by Brad Larson on 5/6/2015.
//  Sunset Lake Software LLC.

import UIKit
import HealthKit

class ViewController: UIViewController {

    let healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let heartRateType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        
        if (HKHealthStore.isHealthDataAvailable()){
            var csvString = "Time,Date,Heartrate(BPM)\n"
            self.healthStore.requestAuthorization(toShare: nil, read:[heartRateType], completion:{(success, error) in
                let sortByTime = NSSortDescriptor(key:HKSampleSortIdentifierEndDate, ascending:false)
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "hh:mm:ss"

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/YYYY"

                let query = HKSampleQuery(sampleType:heartRateType, predicate:nil, limit:600, sortDescriptors:[sortByTime], resultsHandler:{(query, results, error) in
                    guard let results = results else { return }
                    for quantitySample in results {
                        let quantity = (quantitySample as! HKQuantitySample).quantity
                        let heartRateUnit = HKUnit(from: "count/min")
                        
//                        csvString.extend("\(quantity.doubleValueForUnit(heartRateUnit)),\(timeFormatter.stringFromDate(quantitySample.startDate)),\(dateFormatter.stringFromDate(quantitySample.startDate))\n")
//                        println("\(quantity.doubleValueForUnit(heartRateUnit)),\(timeFormatter.stringFromDate(quantitySample.startDate)),\(dateFormatter.stringFromDate(quantitySample.startDate))")
                        csvString += "\(timeFormatter.string(from: quantitySample.startDate)),\(dateFormatter.string(from: quantitySample.startDate)),\(quantity.doubleValue(for: heartRateUnit))\n"
                        print("\(timeFormatter.string(from: quantitySample.startDate)),\(dateFormatter.string(from: quantitySample.startDate)),\(quantity.doubleValue(for: heartRateUnit))")
                    }
                    
                    do {
                        let documentsDir = try FileManager.default.url(for: .documentDirectory, in:.userDomainMask, appropriateFor:nil, create:true)
                        try csvString.write(to: URL(string:"heartratedata.csv", relativeTo:documentsDir)!, atomically:true, encoding:String.Encoding.ascii)
                    }
                    catch {
                        print("Error occured")
                    }
                    
                })
                self.healthStore.execute(query)
            })
        }
    }
}

