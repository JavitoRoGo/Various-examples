//
//  BeActiveTabView.swift
//  HealthKitExample
//
//  Created by Javier Rodríguez Gómez on 23/8/23.
//

import SwiftUI

struct BeActiveTabView: View {
	@EnvironmentObject var manager: HealthManger
	@State var selectedTab = "Home"
	
    var body: some View {
		TabView(selection: $selectedTab) {
			HomeView()
				.environmentObject(manager)
				.tag("Home")
				.tabItem {
					Image(systemName: "house")
				}
			
			ChartsView()
				.environmentObject(manager)
				.tag("Charts")
				.tabItem {
					Image(systemName: "chart.line.uptrend.xyaxis")
				}
			
			ContentView()
				.tag("Content")
				.tabItem {
					Image(systemName: "person")
				}
		}
    }
}

struct BeActiveTabView_Previews: PreviewProvider {
    static var previews: some View {
        BeActiveTabView()
			.environmentObject(HealthManger())
    }
}
