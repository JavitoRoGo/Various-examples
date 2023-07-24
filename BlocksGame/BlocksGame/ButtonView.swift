//
//  ButtonView.swift
//  BlocksGame
//
//  Created by Javier Rodríguez Gómez on 24/7/23.
//

import SwiftUI

struct ButtonView: View {
    let iconSystemName: String
    let action: () -> Void
    
    private var size: CGFloat {
        70.0
    }
    private var iconSize: CGFloat {
        70.0
    }
    var cornerRadius: CGFloat = 35
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: iconSystemName)
                .foregroundColor(.white)
                .frame(width: iconSize, height: iconSize)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(.white, lineWidth: 6)
                )
        }
        .frame(width: size, height: size, alignment: .center)
        .background(.black)
        .clipShape(Circle())
        .buttonStyle(IconButtonRoundDefault())
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(iconSystemName: IconButtons.icons.rotateright) { }
    }
}


struct IconButtonRoundDefault: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 1.5 : 1)
            .animation(.easeOut(duration: 0.6), value: configuration.isPressed)
    }
}

struct IconButtons {
    static let icons = IconNames()
    
    struct IconNames {
        let arrowback = "arrow.backward"
        let arrowforward = "arrow.forward"
        let rotateleft = "arrow.counterclockwise"
        let rotateright = "arrow.clockwise"
        let restart = "restart"
    }
}
