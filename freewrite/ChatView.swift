
//
//  ChatView.swift
//  freewrite
//
//  Created by Gemini on 8/23/25.
//

import SwiftUI

struct ChatView: View {
    @State private var messageText: String = ""
    @Binding var showingChatSidebar: Bool
    @Binding var selectedFont: String
    @State private var isHoveringSendButton = false
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var isTextFieldFocused: Bool
    @State private var eventMonitor: Any?

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Chat")
                    .font(.headline)
                    .foregroundColor(colorScheme == .light ? .black : .white)
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showingChatSidebar = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(colorScheme == .light ? .black : .white)
                }
                .buttonStyle(.plain)
            }
            .padding()

            Divider()

            ScrollView {
                VStack(alignment: .leading) {
                    // TODO: Add chat messages here
                }
            }

            HStack(alignment: .center) {
                ZStack(alignment: .topLeading) {
                    CustomTextEditor(text: $messageText, font: .constant(NSFont(name: selectedFont, size: 16)!))
                        .focused($isTextFieldFocused)
                        .frame(minHeight: 50, maxHeight: 100)
                        .cornerRadius(5)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 0)
                        )
                    if messageText.isEmpty {
                        Text("Ask anything")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 12)
                    }
                }
                
                Button(action: {
                    // TODO: Add send message functionality
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 18))
                }
                .buttonStyle(.plain)
                .foregroundColor(isHoveringSendButton ? (colorScheme == .light ? .black : .white) : (colorScheme == .light ? .gray : .gray.opacity(0.8)))
                .onHover { hovering in
                    isHoveringSendButton = hovering
                }
            }
            .padding()
        }
        .background(colorScheme == .light ? Color.white : Color(NSColor.black))
        .onAppear {
            isTextFieldFocused = true
            eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                if event.keyCode == 53 { // 53 is the key code for the Escape key
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showingChatSidebar = false
                    }
                }
                return event
            }
        }
        .onDisappear {
            if let eventMonitor = eventMonitor {
                NSEvent.removeMonitor(eventMonitor)
            }
        }
    }
}
