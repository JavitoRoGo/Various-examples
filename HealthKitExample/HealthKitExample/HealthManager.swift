//
//  HealthManager.swift
//  HealthKitExample
//
//  Created by Javier Rodríguez Gómez on 23/8/23.
//

import Foundation
import HealthKit

class HealthManger: ObservableObject {
	let healthStore = HKHealthStore()
	
	@Published var activities: [String : Activity] = [:]
	
	@Published var mockActivities: [String : Activity] = [
		"todaySteps" : Activity(id: 0, title: "Today steps", subtitle: "Goal 10,000", image: "figure.walk", tintColor: .green, amount: "12,345"),
		"todayCalories" : Activity(id: 1, title: "Today calories", subtitle: "Goal 300", image: "flame", tintColor: .red, amount: "789")
	]
	
	@Published var oneMonthChartData = [DailyStepView]()
	
	init() {
		let steps = HKQuantityType(.stepCount)
		let calories = HKQuantityType(.activeEnergyBurned)
		let workout = HKObjectType.workoutType()
		
		
		let healthTypes: Set = [steps, calories, workout]
		
		Task {
			do {
				try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
				fetchTodaySteps()
				fetchTodayCalories()
//				fetchWeekRunningStats()
//				fetchWeightLiftingStats()
				fetchCurrentWeekWorkoutStats()
				fetchPastMonthStepData()
			} catch {
				print("Error fetching health data")
			}
		}
	}
	
	func fetchTodaySteps() {
		let steps = HKQuantityType(.stepCount)
		let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
		let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
			guard let quantity = result?.sumQuantity(), error == nil else {
				print("Error fetching todays step data")
				return
			}
			let stepCount = quantity.doubleValue(for: .count())
			let activity = Activity(id: 0, title: "Today steps", subtitle: "Goal 10,000", image: "figure.walk", tintColor: .green, amount: stepCount.formattedString())
			DispatchQueue.main.async {
				self.activities["todaySteps"] = activity
			}
		}
		healthStore.execute(query)
	}
	
	func fetchTodayCalories() {
		let calories = HKQuantityType(.activeEnergyBurned)
		let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
		let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, result, error in
			guard let quantity = result?.sumQuantity(), error == nil else {
				print("Error fetching todays calories data")
				return
			}
			let caloriesBurned = quantity.doubleValue(for: .kilocalorie())
			let activity = Activity(id: 1, title: "Today calories", subtitle: "Goal 300", image: "flame", tintColor: .red, amount: caloriesBurned.formattedString())
			DispatchQueue.main.async {
				self.activities["todayCalories"] = activity
			}
		}
		healthStore.execute(query)
	}
	
	func fetchWeekRunningStats() {
		let workout = HKSampleType.workoutType()
		let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeekMonday, end: Date())
		let workoutPredicate = HKQuery.predicateForWorkouts(with: .running)
		let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
		let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: 20, sortDescriptors: nil) { _, sample, error in
			guard let workouts = sample as? [HKWorkout], error == nil else {
				print("Error fetching week running data")
				return
			}
			
			var count = 0
			workouts.forEach { workout in
				let duration = Int(workout.duration) / 60
				count += duration
			}
			let activity = Activity(id: 2, title: "Running", subtitle: "Mins this week", image: "figure.run", tintColor: .green, amount: "\(count) mins")
			DispatchQueue.main.async {
				self.activities["weekRunning"] = activity
			}
		}
		healthStore.execute(query)
	}
	
	func fetchWeightLiftingStats() {
		let workout = HKSampleType.workoutType()
		let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeekMonday, end: Date())
		let workoutPredicate = HKQuery.predicateForWorkouts(with: .traditionalStrengthTraining)
		let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
		let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: 20, sortDescriptors: nil) { _, sample, error in
			guard let workouts = sample as? [HKWorkout], error == nil else {
				print("Error fetching week running data")
				return
			}
			
			var count = 0
			workouts.forEach { workout in
				let duration = Int(workout.duration) / 60
				count += duration
			}
			let activity = Activity(id: 3, title: "Weight Lifting", subtitle: "This week", image: "dumbbell", tintColor: .orange, amount: "\(count) mins")
			DispatchQueue.main.async {
				self.activities["weekStrength"] = activity
			}
		}
		healthStore.execute(query)
	}
	
	// To fetch different workouts we can make one function with different options
	func fetchCurrentWeekWorkoutStats() {
		let workout = HKSampleType.workoutType()
		let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeekMonday, end: Date())
		let query = HKSampleQuery(sampleType: workout, predicate: timePredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, sample, error in
			guard let workouts = sample as? [HKWorkout], error == nil else {
				print("Error fetching week running data")
				return
			}
			
			var runningCount = 0
			var strengthCount = 0
			var stairsCount = 0
			var swimmingCount = 0
			
			workouts.forEach { workout in
				if workout.workoutActivityType == .running {
					let duration = Int(workout.duration) / 60
					runningCount += duration
				} else if workout.workoutActivityType == .traditionalStrengthTraining {
					let duration = Int(workout.duration) / 60
					strengthCount += duration
				} else if workout.workoutActivityType == .stairs {
					let duration = Int(workout.duration) / 60
					stairsCount += duration
				} else if workout.workoutActivityType == .swimming {
					let duration = Int(workout.duration) / 60
					swimmingCount += duration
				}
			}
			let runningActivity = Activity(id: 3, title: "Running", subtitle: "This week", image: "figure.run", tintColor: .green, amount: "\(runningCount) mins")
			let strengthActivity = Activity(id: 3, title: "Strength Training", subtitle: "This week", image: "dumbbell", tintColor: .orange, amount: "\(strengthCount) mins")
			let stairsActivity = Activity(id: 3, title: "Stairs", subtitle: "This week", image: "figure.stairs", tintColor: .blue, amount: "\(stairsCount) mins")
			let swimmingActivity = Activity(id: 3, title: "Swimming", subtitle: "This week", image: "figure.pool.swim", tintColor: .cyan, amount: "\(swimmingCount) mins")
			DispatchQueue.main.async {
				self.activities["weekRunning"] = runningActivity
				self.activities["weekStrength"] = strengthActivity
				self.activities["weekStairs"] = stairsActivity
				self.activities["weekSwimming"] = swimmingActivity
			}
		}
		healthStore.execute(query)
	}
	
	func fetchDailySteps(startDate: Date, completion: @escaping ([DailyStepView]) -> Void) {
		let steps = HKQuantityType(.stepCount)
		let interval = DateComponents(day: 1)
		let query = HKStatisticsCollectionQuery(quantityType: steps, quantitySamplePredicate: nil, anchorDate: startDate, intervalComponents: interval)
		
		query.initialResultsHandler = { query, result, error in
			guard let result else {
				completion([])
				return
			}
			
			var dailySteps = [DailyStepView]()
			result.enumerateStatistics(from: startDate, to: Date()) { statistics, stop in
				dailySteps.append(DailyStepView(date: statistics.startDate, stepCount: statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0.0))
			}
			completion(dailySteps)
		}
		
		healthStore.execute(query)
	}
}


extension Date {
	static var startOfDay: Date {
		Calendar.current.startOfDay(for: Date())
	}
	
	static var startOfWeekMonday: Date {
		let calendar = Calendar.current
		var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
		components.weekday = 2
		return calendar.date(from: components)!
	}
	
	static var oneMonthAgo: Date {
		let calendar = Calendar.current
		let oneMonth = calendar.date(byAdding: .month, value: -1, to: Date())
		return calendar.startOfDay(for: oneMonth!)
	}
}

extension Double {
	func formattedString() -> String {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .decimal
		numberFormatter.maximumFractionDigits = 0
		return numberFormatter.string(from: NSNumber(value: self))!
	}
}

// MARK: Chart Data

extension HealthManger {
	func fetchPastMonthStepData() {
		fetchDailySteps(startDate: .oneMonthAgo) { dailySteps in
			DispatchQueue.main.async {
				self.oneMonthChartData = dailySteps
			}
		}
	}
}
