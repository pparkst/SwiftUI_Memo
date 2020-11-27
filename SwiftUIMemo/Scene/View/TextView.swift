//
//  TextView.swift
//  SwiftUIMemo
//
//  Created by pparkst on 2020/11/28.
//  Copyright © 2020 pparkst. All rights reserved.
//

import UIKit
import SwiftUI
//UI TextView
struct TextView: UIViewRepresentable {
    @Binding var text: String
    
    func makeCoordinator() -> TextView.Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let myTextView = UITextView()
        myTextView.delegate = context.coordinator
        
        return myTextView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView
        
        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }
}
