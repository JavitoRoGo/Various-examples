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
				.tag("Home")
				.tabItem {
					Image(systemName: "house")
				}
				.environmentObject(manager)
			
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
    }
}
