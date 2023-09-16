//
//  TextDocument.swift
//  ImportingExporting
//
//  Created by Javier Rodríguez Gómez on 17/9/23.
//

import SwiftUI
import UniformTypeIdentifiers

// When exporting a file it's needed to define a file document
// In this example we are working with text, so the document is a wrapper around String

struct TextDocument: FileDocument {
	var textDoc: String = ""
	init(_ text: String = "") {
		self.textDoc = text
	}
	
	// There are 3 requirements for FileDocument
	
	// 1. List the content types the document supports
	static var readableContentTypes: [UTType] = [.text, .json, .xml]
	
	// 2. The initializer that loads documents from a file
	// The configuration parameter gives us access to the file wrapper whose contents we convert to text
	init(configuration: ReadConfiguration) throws {
		if let data = configuration.file.regularFileContents {
			textDoc = String(decoding: data, as: UTF8.self)
		}
	}
	
	// 3. The method that goes the other way creating a FileWrapper representing the file on disk
	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		let data = Data(textDoc.utf8)
		return FileWrapper(regularFileWithContents: data)
	}
	
	
}
