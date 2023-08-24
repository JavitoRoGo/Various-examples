//
//  AnotherHealthManager.swift
//  HealthKitExample
//
//  Created by Javier Rodríguez Gómez on 24/8/23.
//

import Foundation
import HealthKit

// Another example of HK manager but a little more complicated, by azamsharp

class HealthStore {
	var healthStore: HKHealthStore?
	var query: HKStatisticsCollectionQuery?
	
	init() {
		requestAuthorization { success in
			if success {
				self.calculateSteps { statisticsCollection in
					if let statisticsCollection {
						// update the UI
						let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
						statisticsCollection.enumerateStatistics(from: startDate, to: Date()) { statistics, stop in
							let count = statistics.sumQuantity()?.doubleValue(for: .count())
							// count property is number of steps, and it's used to inject date into the view
						}
					}
				}
			}
		}
		if HKHealthStore.isHealthDataAvailable() {
			healthStore = HKHealthStore()
		}
	}
	
	func requestAuthorization(completion: @escaping (Bool) -> Void) {
		let stepType = HKQuantityType(.stepCount)
		let healthTypes: Set = [stepType]
		guard let healthStore else { return completion(false) }
		healthStore.requestAuthorization(toShare: [], read: healthTypes) { success, error in
			completion(success)
		}
	}
	
	func calculateSteps(completion: @escaping (HKStatisticsCollection?) -> Void) {
		let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
		let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
		let anchorDate = Date.mondayAt12AM()
		let daily = DateComponents(day: 1)
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
		
		query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
		query!.initialResultsHandler = { query, statisticsCollection, error in
			completion(statisticsCollection)
		}
		if let healthStore, let query {
			healthStore.execute(query)
		}
	}
}


extension Date {
	static func mondayAt12AM() -> Date {
		return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
	}
}
