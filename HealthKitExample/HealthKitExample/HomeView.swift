//
//  HomeView.swift
//  HealthKitExample
//
//  Created by Javier Rodríguez Gómez on 23/8/23.
//

import SwiftUI

struct HomeView: View {
	@EnvironmentObject var manager: HealthManger
	
    var body: some View {
		VStack {
			LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
				ForEach(manager.activities.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
					ActivityCard(activity: item.value)
				}
			}
			.padding(.horizontal)
		}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
