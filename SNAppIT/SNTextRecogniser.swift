//
//  SNTextRecogniser.swift
//  SNAppIT
//
//  Created by Azat Almeev on 25.03.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

import UIKit

class SNTextRecogniser: NSObject {
    
    private var _operationQueue: NSOperationQueue!
    private var operationQueue: NSOperationQueue {
        get {
            if _operationQueue == nil {
                _operationQueue = NSOperationQueue()
            }
            return _operationQueue
        }
    }

    func recogniseTextFromImage(image: UIImage, completion: (text: String) -> (Void)) {
        
        // Create a new `G8RecognitionOperation` to perform the OCR asynchronously
        // It is assumed that there is a .traineddata file for the language pack
        // you want Tesseract to use in the "tessdata" folder in the root of the
        // project AND that the "tessdata" folder is a referenced folder and NOT
        // a symbolic group in your project
        let operation = G8RecognitionOperation(language: "eng")
        
        // Use the original Tesseract engine mode in performing the recognition
        // (see G8Constants.h) for other engine mode options
        operation?.tesseract?.engineMode = G8OCREngineMode.TesseractCubeCombined
        
        // Let Tesseract automatically segment the page into blocks of text
        // based on its analysis (see G8Constants.h) for other page segmentation
        // mode options
        operation?.tesseract?.pageSegmentationMode = G8PageSegmentationMode.AutoOnly
        
        // Set the image on which Tesseract should perform recognition
        operation?.tesseract?.image = image
        
        // Specify the function block that should be executed when Tesseract
        // finishes performing recognition on the image
        operation?.recognitionCompleteBlock = { tesseract in
            // Fetch the recognized text
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if tesseract == nil {
                    completion(text: "")
                }
                else {
                    completion(text: tesseract!.recognizedText ?? "")
                }
            })
        }
        
        // Finally, add the recognition operation to the queue
        self.operationQueue.addOperation(operation)

    }
    
}
