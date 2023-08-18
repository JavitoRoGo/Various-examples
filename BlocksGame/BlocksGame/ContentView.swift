//
//  ContentView.swift
//  BlocksGame
//
//  Created by Javier Rodríguez Gómez on 23/7/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    let boxSize: CGFloat = 20.0
    let spacing: CGFloat = 2.0
	var boxNextSize: CGFloat = 10.0
	
	var titleTextSize: FontSize = .s24
	var infoTextSize: FontSize = .s20
	var spacerHeight: CGFloat = 0
	var titlePaddingBottom: CGFloat = 4
	
	var scoreFormatted: String {
		String(format: "%06i", viewModel.score)
		// este formato rellena con 0 hasta el número indicado
	}
	var linesFormatted: String {
		String(format: "%04i", viewModel.lines)
	}
	var levelFormatted: String {
		String(format: "%02i", viewModel.level)
	}
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    board
                }
                .padding(.top, 80)
                .padding(.horizontal, 20)
                Spacer()
				
				scoreboard
            }
            Spacer()
            controls
                .padding(.horizontal)
                .padding(.bottom, 20)
        }
        .ignoresSafeArea()
        .background(.black)
    }
    
    var board: some View {
        VStack(spacing: spacing) {
            ForEach(0..<viewModel.height, id: \.self) { y in
                HStack(spacing: spacing) {
                    ForEach(0..<viewModel.width, id: \.self) { x in
                        let squareGame = viewModel.getSquareGame(x: x, y: y)
                        let color = squareGame?.color ?? Color.gray.opacity(0.2)
                        
                        Rectangle()
                            .aspectRatio(1.0, contentMode: .fit)
                            .foregroundColor(color)
                            .frame(width: boxSize, height: boxSize)
                            .padding(0)
                    }
                }
            }
        }
    }
	
	var nextShape: some View {
		VStack {
			Text("NEXT")
				.foregroundColor(.white)
				.font(size: titleTextSize, type: .bold)
			
			VStack(spacing: spacing) {
				ForEach(-1...2, id: \.self) { y in
					HStack(spacing: spacing) {
						ForEach(3...6, id: \.self) { x in
							let color = colorNextShape(x: x, y: y) ?? Color.gray.opacity(0.2)
							Rectangle()
								.aspectRatio(1.0, contentMode: .fit)
								.foregroundColor(color)
								.frame(width: boxNextSize, height: boxNextSize)
								.padding(0)
						}
					}
				}
			}
			.padding(.top, 4)
		}
		.padding(.bottom, 8)
	}
	
	var scoreboard: some View {
		VStack {
			
			nextShape
			
			Text("LEVEL")
				.font(size: titleTextSize, type: .bold)
				.padding(.bottom, titlePaddingBottom)
			Text(levelFormatted)
				.font(size: infoTextSize, type: .digital)
			
			Spacer()
				.frame(height: spacerHeight)
			
			Text("LINES")
				.font(size: titleTextSize, type: .bold)
				.padding(.bottom, titlePaddingBottom)
			Text(linesFormatted)
				.font(size: infoTextSize, type: .digital)
			
			Spacer()
				.frame(height: spacerHeight)
			
			Text("SCORE")
				.font(size: titleTextSize, type: .bold)
				.padding(.bottom, titlePaddingBottom)
			Text(scoreFormatted)
				.font(size: infoTextSize, type: .digital)
		}
		.padding(.horizontal, 20)
		.padding(.vertical, 10)
		.padding(.bottom, 10)
		.background(
			RoundedRectangle(cornerRadius: 4)
				.stroke(.white, lineWidth: 2)
				.background(Color.black.opacity(0.75).cornerRadius(4))
		)
		.foregroundColor(.white)
	}
    
    var controls: some View {
        HStack(spacing: 20) {
            ButtonView(iconSystemName: IconButtons.icons.arrowback) {
                viewModel.moveLeft()
            }
            ButtonView(iconSystemName: IconButtons.icons.arrowforward) {
                viewModel.moveRight()
            }
            Spacer()
            ButtonView(iconSystemName: IconButtons.icons.rotateright) {
                viewModel.rotateShape()
            }
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 30)
    }
	
	private func colorNextShape(x: Int, y: Int) -> Color? {
		if let shape = viewModel.nextActiveShape,
		   let _ = shape.occupiedPositions.first(where: { $0.y == y && $0.x == x }) {
			return shape.color
		}
		return nil
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
