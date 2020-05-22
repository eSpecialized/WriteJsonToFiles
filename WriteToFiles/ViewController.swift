//
//  ViewController.swift
//  WriteToFiles
//
//  Created by William Thompson on 5/21/20.
//  Copyright © 2020 William Thompson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var textView: UITextView!

    private let fileName = "readWrite.dat"

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = "Start of log here"
    }

    // MARK: - Internal Support Methods

    // I encourage you to break point, 'po' each object and do discovery along the way.
    @IBAction func saveToFiles(_ sender: Any) {
        // Data to be written.
        let usersName = nameField.text ?? "John Doe"

        // Where we will write our data to. This early exits if it fails to get the directory.
        guard let docDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return }

        // Build final output URL.
        let outputURL = docDirectoryURL.appendingPathComponent(fileName)

        do {
            // Encoder, to encode our data.
            let jsonEncoder = JSONEncoder()

            // Convert our Object into a Data object.
            let jsonCodedData = try jsonEncoder.encode(usersName)

            // Write the data to output.
            try jsonCodedData.write(to: outputURL)
        } catch {
            // Error Handling.
            logToTextView("Failed to write to file \(error.localizedDescription)")
            return
        }

        // Some simple status to the user.
        textView.text = "Start of log here"
        logToTextView("Wrote to \(fileName)")
        nameField.text = nil
    }

    @IBAction func showFilesAndDisplayClicked(_ sender: Any) {
        let fileManager = FileManager.default

        guard let docDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return }

        let inputFileURL = docDirectoryURL.appendingPathComponent(fileName)

        guard fileManager.fileExists(atPath: inputFileURL.path)
        else {
            logToTextView("File Doesn't exist. Try typing a name and hitting 'Save' First.")
            return
        }

        do {
            logToTextView("Attempting to read from \(fileName)")
            logToTextView("Reading from file at path \(inputFileURL.deletingLastPathComponent().path)")
            let inputData = try Data(contentsOf: inputFileURL)
            let decoder = JSONDecoder()
            let decodedString = try decoder.decode(String.self, from: inputData)
            logToTextView("previous name contents = [\(decodedString)]")
        } catch {
            logToTextView("Failed to open file contents for display!")
            return
        }
    }

    // MARK: - Private methods

    private func logToTextView(_ whatToLog: String) {
        print(whatToLog)

        guard let firstText = textView.text else { return }

        textView.text = firstText + "\n" + whatToLog
    }
}
