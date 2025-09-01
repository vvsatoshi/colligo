
//
//  CustomTextEditor.swift
//  freewrite
//
//  Created by Gemini on 8/23/25.
//

import SwiftUI

struct CustomTextEditor: NSViewRepresentable {
    @Binding var text: String
    @Binding var font: NSFont

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()
        scrollView.hasVerticalScroller = false
        let textView = scrollView.documentView as! NSTextView
        textView.drawsBackground = false
        textView.delegate = context.coordinator
        textView.font = font
        textView.textColor = NSColor.textColor
        textView.insertionPointColor = NSColor.systemBlue
        textView.isRichText = false
        textView.string = text
        textView.textContainer?.lineFragmentPadding = 1  // Minimal padding preserves cursor
        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        let textView = nsView.documentView as! NSTextView
        if textView.string != text {
            textView.string = text
        }
        if textView.font != font {
            textView.font = font
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: CustomTextEditor

        init(_ parent: CustomTextEditor) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.text = textView.string
        }
    }
}
