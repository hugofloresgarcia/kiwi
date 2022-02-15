//
//  ContentView.swift
//  kiwi
//
//  Created by hugo on 1/31/22.
//

import SwiftUI
import SwiftUITrackableScrollView
import NetUtils


struct HapticPixelView : View {
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
    
        VStack(alignment: .center){
            Spacer()
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                                     startPoint: .top,
                                     endPoint: .bottom))
                .frame(width: width, height: height)
            Spacer()
        }
    }
}

class HapticPixel : Identifiable {
    let intensity: Float
    let sharpness: Float
    var globalPos: CGRect?
    var id: UUID?

    init(_intensity: Float, _sharpness: Float){
        id = UUID()
        intensity = _intensity
        sharpness = _sharpness
    }
    
    func getCoords(geo: SwiftUI.GeometryProxy) -> CGPoint {
        globalPos = geo.frame(in: .global)
        let width = geo.size.width
        let height = CGFloat(intensity * 500)
        
        return CGPoint(x: width, y: height)
    }
}

class HapticPixelContainer : ObservableObject {
    @Published var pixels = [HapticPixel]()


    func getHapticPixelOverScrubArea(point: CGPoint) -> HapticPixel? {
        var retPixel: HapticPixel?
        pixels.forEach{ pixel in
            if let pos = pixel.globalPos{
                if (pos.contains(point))
                {
                    retPixel = pixel
                }
            } else {
                print("pixel does not have global position")
            }
        }
        return retPixel
    }
}

struct HapticPixelScrubber : View {
    @State private var haptics = Haptics()
    private var pixelSpacing: CGFloat = 1
    @ObservedObject var pixels = HapticPixelContainer()
    private var numPixels = 4
    
    @State private var scrubbing: Bool = false
    @State private var scrubPlayer = ContinuousHapticPlayer()
    var scrub: some Gesture {
        DragGesture()
            .onChanged{ value in
                // if we just started scrubbing, start a continuous event
                if let pixel = pixels.getHapticPixelOverScrubArea(point: value.location){
                    if (scrubPlayer.player == nil) {
                        scrubPlayer.start(with: haptics, intensity: pixel.intensity,
                                          sharpness: pixel.sharpness)
                        print("started continuous player")
                    } else {
                        scrubPlayer.update(intensity: pixel.intensity, sharpness: pixel.sharpness)
                        print("updating continuous player")
                    }
                }
            }
            .onEnded { value in
                print("stopping continuous player")
                scrubPlayer.stop(atTime: 0)
                scrubPlayer.player = nil
            }
    }
    
    func constructHapticPixelView(for pixel: HapticPixel, with geo: GeometryProxy) -> some View {
        let coords = pixel.getCoords(geo: geo)
        return HapticPixelView(width: coords.x,
                              height: coords.y)
                              .gesture(scrub)
    }
    
    var body : some View {
        
        HStack(spacing: pixelSpacing) {
            ForEach(pixels.pixels) { _pixel in
                GeometryReader  { geo in
                    constructHapticPixelView(for: _pixel, with: geo)
                }
            }
        }.onAppear(perform: {
            haptics.prepare()
            (0...128).forEach({idx in
                pixels.pixels.append(HapticPixel(_intensity: Float.random(in: 0.5...1.0),
                                                 _sharpness: 1.0))
            })
        }).padding()
    }
}

struct ContentView: View {
    
    var body: some View {
        VStack {
            Text("welcome to kiwi :) yee haw")
                .padding()
            HapticPixelScrubber()
        }
    }
}
