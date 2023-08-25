//
//  Model.swift
//  HealthKitExample
//
//  Created by Javier Rodríguez Gómez on 23/8/23.
//

import Foundation
import SwiftUI

struct Activity: Identifiable {
	let id: Int
	let title: String
	let subtitle: String
	let image: String
	let tintColor: Color
	let amount: String
}

struct DailyStepView: Identifiable {
	let id = UUID()
	let date: Date
	let stepCount: Double
}

enum ChartOptions {
	case oneWeek
	case oneMonth
	case threeMonth
	case yearToDate
	case oneYear
}
