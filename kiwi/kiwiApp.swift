//
//  kiwiApp.swift
//  kiwi
//
//  Created by hugo on 1/31/22.
//

import SwiftUI
//
//public func print(_ object: Any...) {
////    #if DEBUGGING
////    for item in object {
////        Swift.print(item)
////    }
////    #endif
//}

@main
struct kiwiApp: App {
    @StateObject var pixelData = PixelCollection()
    @StateObject var haptics = Haptics()
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environmentObject(pixelData)
                .environmentObject(haptics)
                .onAppear(perform: {
                    haptics.prepare()
                })
                
        }
    }
}

