//
//  ChartsView.swift
//  HealthKitExample
//
//  Created by Javier Rodríguez Gómez on 25/8/23.
//

import Charts
import SwiftUI

struct ChartsView: View {
	@EnvironmentObject var manager: HealthManger
	@State var selectedChart: ChartOptions = .oneMonth
	
    var body: some View {
		VStack(spacing: 12) {
			Chart {
				ForEach(manager.oneMonthChartData) { daily in
					BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("Steps", daily.stepCount))
				}
			}
			.foregroundColor(.green)
			.frame(height: 350)
			.padding(.horizontal)
			
			HStack {
				Button("1W") {
					withAnimation {
						selectedChart = .oneWeek
					}
				}
				.padding(.all)
				.foregroundColor(selectedChart == .oneWeek ? .white : .green)
				.background(selectedChart == .oneWeek ? .green : .clear)
				.cornerRadius(10)
				
				Button("1M") {
					withAnimation {
						selectedChart = .oneMonth
					}
				}
				.padding(.all)
				.foregroundColor(selectedChart == .oneMonth ? .white : .green)
				.background(selectedChart == .oneMonth ? .green : .clear)
				.cornerRadius(10)
				
				Button("3M") {
					withAnimation {
						selectedChart = .threeMonth
					}
				}
				.padding(.all)
				.foregroundColor(selectedChart == .threeMonth ? .white : .green)
				.background(selectedChart == .threeMonth ? .green : .clear)
				.cornerRadius(10)
				
				Button("YTD") {
					withAnimation {
						selectedChart = .yearToDate
					}
				}
				.padding(.all)
				.foregroundColor(selectedChart == .yearToDate ? .white : .green)
				.background(selectedChart == .yearToDate ? .green : .clear)
				.cornerRadius(10)
				
				Button("1Y") {
					withAnimation {
						selectedChart = .oneYear
					}
				}
				.padding(.all)
				.foregroundColor(selectedChart == .oneYear ? .white : .green)
				.background(selectedChart == .oneYear ? .green : .clear)
				.cornerRadius(10)
			}
		}
    }
}

struct ChartsView_Previews: PreviewProvider {
    static var previews: some View {
        ChartsView()
			.environmentObject(HealthManger())
    }
}
