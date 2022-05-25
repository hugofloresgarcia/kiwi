//
//  OSCView.swift
//  kiwi
//
//  Created by hugo on 2/23/22.
//

import SwiftUI
import SwiftUIOSC
import dnssd

struct OSCTestView: View {
    @ObservedObject var osc: OSC = .shared
    
    @OSCState(name: "test/float") var testFloat: CGFloat = 0.0
    @OSCState(name: "test/int") var testInt: Int = 0
    @OSCState(name: "test/string") var testString: String = ""
    
    var body: some View {
        // Test Float
        HStack {
            
            Text("Float")
                .fontWeight(.bold)
                .frame(width: 75, alignment: .trailing)
            
            Button {
                testFloat = 0.0
            } label: {
                Text("Zero")
            }
            .disabled(testFloat == 0.0)
            
            Slider(value: $testFloat)
            
            Text("\(testFloat, specifier: "%.2f")")
            
        }
        
        // Test Int
        HStack {
        
            Text("Int")
                .fontWeight(.bold)
                .frame(width: 75, alignment: .trailing)
            
            Picker("", selection: $testInt) {
                Text("First").tag(0)
                Text("Second").tag(1)
                Text("Third").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())

        }
        
        // Test String
        HStack {
        
            Text("String")
                .fontWeight(.bold)
                .frame(width: 75, alignment: .trailing)
            
            TextField("Text", text: $testString)
            
        }
        
    }
}

struct OSCSettingsView: View {
    @ObservedObject var osc: OSC = .shared
    
    var body: some View {
        VStack {
            // status
            Group {
                Divider()
                Text("Connection Status")
                HStack {
                    Text("Local IP Address:")
                        .frame(width: 200, alignment: .trailing)
                    Text(UIDevice.current.getIP() ?? "No Wi-fi")
                }.accessibilityElement(children: .combine)
                
            }
            
            // port and address controls
            Group {
                Divider()
                Text("Port and Address Settings")
                    .background(Color.blue)
                HStack {
                    Text("IP Address:")
                        .frame(width: 200, alignment: .trailing)
                    TextField("IP Address", text: $osc.clientAddress, onCommit: {
                        UserDefaults.standard.set(osc.clientAddress, forKey: "clientAddress")
                    })
                        .accessibilityHint("Double tap to edit IP address")
                        .border(Color.blue, width: 1.5)
                        .onAppear {
                            osc.clientAddress = UserDefaults.standard.string(forKey: "clientAddress") ?? "0.0.0.0"
                            osc.clientPort = 8001;
                            osc.serverPort = 8000;
                        }
                }
                
//                HStack {
//                    Text("Send Port:")
//                        .frame(width: 200, alignment: .trailing)
//
//                    TextField("Send Port", text: Binding<String>(get: {
//                        "\(osc.clientPort)"
//                    }, set: { text in
//                        guard let port = Int(text) else { return }
//                        osc.clientPort = port
//                    }))
//                        .border(Color.blue, width: 1.5)
//                }
//
//                HStack {
//                    Text("Receive Port:")
//                        .frame(width: 200, alignment: .trailing)
//
//                    TextField("Receive Port", text: Binding<String>(get: {
//                        "\(osc.serverPort)"
//                    }, set: { text in
//                        guard let port = Int(text) else { return }
//                        osc.serverPort = port
//                    }))
//                        .border(Color.blue, width: 1.5)
//                }
            }
        }
        .font(.system(.body, design: .monospaced))
        .frame(minWidth: 300, maxWidth: 400)
        .padding()
    }
}
