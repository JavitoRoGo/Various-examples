//
//  MessageRow.swift
//  WatchConnectivityExampleUI
//
//  Created by Javier Rodríguez Gómez on 4/2/23.
//

import SwiftUI

struct MessageRow: View {
//    let animal: String
    let animalModel: AnimalModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(animalModel.emoji + animalModel.name)
                .padding(.vertical, 4)
            Text(Date(), format: .dateTime)
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
}

struct MessageRow_Previews: PreviewProvider {
    static var previews: some View {
        MessageRow(animalModel: AnimalModel(name: "animal", emoji: "xxx"))
    }
}
