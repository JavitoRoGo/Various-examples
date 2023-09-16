//
//  ContentView.swift
//  ImportingExporting
//
//  Created by Javier Rodríguez Gómez on 16/9/23.
//

import SwiftUI

struct ContentView: View {
	@State var myText = ""
	@State var error: Error?
	@State var isImporting = false
	@State var isExporting = false
	
    var body: some View {
		NavigationStack {
			VStack {
				TextEditor(text: $myText)
					.padding()
					.background {
						RoundedRectangle(cornerRadius: 10)
					}
					.frame(height: 450)
				
				if let error {
					Text(error.localizedDescription)
				}
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						isImporting = true
					} label: {
						Label("Import file", systemImage: "square.and.arrow.down")
					}
				}
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						isExporting = true
					} label: {
						Label("Import file", systemImage: "square.and.arrow.up")
					}
				}
			}
			.fileImporter(isPresented: $isImporting, allowedContentTypes: [.text]) { result in
				// result contains a Result type with the URL of the selected file or an Error
				let resultUrl = result.flatMap { url in
					// resultUrl contains a Result type with a String or an Error
					read(from: url)
				}
				switch resultUrl {
					case .success(let text):
						self.myText = text
					case .failure(let error):
						self.error = error
				}
			}
			.fileExporter(isPresented: $isExporting, document: TextDocument(myText), contentType: .text, defaultFilename: "document.txt") { result in
				// result contains a Result type with the URL of the selected file or an Error
				if case .failure(let error) = result {
					self.error = error
				}
			}
		}
    }
	
	private func read(from url: URL) -> Result<String, Error> {
		let accessing = url.startAccessingSecurityScopedResource()
		defer {
			if accessing {
				url.stopAccessingSecurityScopedResource()
			}
		}
		return Result { try String(contentsOf: url) }
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
