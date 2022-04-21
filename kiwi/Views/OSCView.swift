//
//  OSCView.swift
//  kiwi
//
//  Created by hugo on 2/23/22.
//

import SwiftUI
//import SwiftUIOSC

import Network

                              
class OSCManager : ObservableObject {
    var client = OSCClientUDP()
//    var server = OSCServerUDP()
//    var multicast = OSCMulticast()
    
    func start () {
        client.delegate = self
        client.connect(serviceName: "kiwi-reaper-pc", timeout: 5.0)
        
//        server.delegate = self
//        do {
//            try server.register(method: MyMethod(addressPattern: "/hello", requiredArguments: [.anyBoolean]))
//            try server.listen(serviceName: "_airplay._udp")
//        } catch {
//            print("OSC manager error: \(error)")
//        }
    }
    
}

extension OSCManager : OSCClientDelegate {
    func connectionStateChange(_ state: NWConnection.State) {
        print("connection state change : \(state)")
        
        switch state {
        case .ready:
            let msg = OSCMessage(addressPattern: "/init", arguments: [.boolean(true)])
            do {
                try client.send(msg, completion: { err in
                    if (err != nil) {
                        print("error sending message to client: \(err?.debugDescription)")
                    }
                })
            } catch {
                print("message send error: \(error)")
            }
            
        default:
            print("")
        }
    }
}

extension OSCManager : OSCServerDelegate {
    func listenerStateChange(state: NWListener.State){
        print("listener state change : \(state)")
    }
}

extension OSCManager : OSCMulticastDelegate {
    func groupStateChange(state: NWConnectionGroup.State) {
        print("group state change : \(state)")
    }
}


class MyMethod: OSCMethod {
    var addressPattern: OSCAddressPattern
    var requiredArguments: OSCArgumentTypeTagArray? = nil

    init(addressPattern: OSCAddressPattern, requiredArguments: OSCArgumentTypeTagArray? = nil) {
        self.addressPattern = addressPattern
        self.requiredArguments = requiredArguments
    }
    
    func handleMessage(_ message: OSCMessage, for match: OSCPatternMatchType, at timeTag: OSCTimeTag?) {
        print("Received message: \(message.addressPattern ?? "")",
              "with match: \(match)",
              "arguments: \(String(describing: message.arguments))",
              "time tag: \(String(describing: timeTag?.date))")
    }
}



struct OSCStatus: View {
    
    var body: some View {
        // Connection
        HStack {
//            if osc.connection.isConnected {
//                Text("Connected on")
//            } else {
//                Text("Connection is")
//            }
//            switch osc.connection {
//            case .unknown:
//                Label("Unknown", systemImage: "wifi.exclamationmark")
//            case .offline:
//                Label("Offline", systemImage: "wifi.slash")
//            case .wifi:
//                Label("Wi-Fi", systemImage: "wifi")
//            case .cellular:
//                Label("Cellular", systemImage: "antenna.radiowaves.left.and.right")
//            }
        }
        .onAppear {
            
        }
    }
}
//
//struct OSCTestView: View {
//    @ObservedObject var osc: OSC = .shared
//
//    @OSCState(name: "test/float") var testFloat: CGFloat = 0.0
//    @OSCState(name: "test/int") var testInt: Int = 0
//    @OSCState(name: "test/string") var testString: String = ""
//
//    var body: some View {
//        // Test Float
//        HStack {
//
//            Text("Float")
//                .fontWeight(.bold)
//                .frame(width: 75, alignment: .trailing)
//
//            Button {
//                testFloat = 0.0
//            } label: {
//                Text("Zero")
//            }
//            .disabled(testFloat == 0.0)
//
//            Slider(value: $testFloat)
//
//            Text("\(testFloat, specifier: "%.2f")")
//
//        }
//
//        // Test Int
//        HStack {
//
//            Text("Int")
//                .fontWeight(.bold)
//                .frame(width: 75, alignment: .trailing)
//
//            Picker("", selection: $testInt) {
//                Text("First").tag(0)
//                Text("Second").tag(1)
//                Text("Third").tag(2)
//            }
//            .pickerStyle(SegmentedPickerStyle())
//
//        }
//
//        // Test String
//        HStack {
//
//            Text("String")
//                .fontWeight(.bold)
//                .frame(width: 75, alignment: .trailing)
//
//            TextField("Text", text: $testString)
//
//        }
//
//    }
//}

struct OSCSettingsView: View {
//    @ObservedObject var osc: OSC = .shared
//    var resolver = HostResolver()
    @ObservedObject var osc = OSCManager()

    var body: some View {
        VStack {
            // status
            Group {
                Divider()
                Text("Connection Status")
                    .background(Color.blue)
                OSCStatus()

            }

            // port and address controls
            Group {
                Divider()



            }


            // test
            Group {
                Divider()
                Text("Message Tester")
                    .background(Color.blue)
            }
            Divider()
        }
        .font(.system(.body, design: .monospaced))
        .frame(minWidth: 300, maxWidth: 400)
        .padding()
        .onAppear {
            osc.start()
        }
    }
}

//import Foundation
//
//
//class HostResolver : PeerBrowserDelegate {
//
//    var host: String = ""
//    var port: String = ""
//
//    func refreshResults(results: Set<NWBrowser.Result>) {
//        print("results: \(results)")
//        for result in results {
//            print(result.endpoint)
//            print(result.interfaces)
//            print(result.metadata)
//
//
//            let connection = NWConnection(to: result.endpoint,
//                                          using: .tcp)
//
//            connection.stateUpdateHandler = { state in
//                switch state {
//                case .ready:
//                    print(connection.endpoint)
//                    if let innerEndpoint = connection.currentPath?.remoteEndpoint,
//                       case .hostPort(let host, let port) = innerEndpoint {
//                            print("Connected to", "\(host):\(port)") // Here, I have the host
//                        }
//                default:
//                    break
//                }
//            }
//            connection.start(queue: .main)
//        }
//
//    }
//    func displayBrowseError(_ error: NWError) {
//        print("browse error: \(error)")
//    }
//}
//
