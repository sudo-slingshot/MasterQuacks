//
//  TestAudioPlayer.swift
//  MasterQuacks
//
//  Created by Yohann Le Clech on 18/02/2023.
//

import SwiftUI
import AVFAudio

struct TestAudioPlayer: View {
    
    //Variables
    @State var audioPlayer: AVAudioPlayer!
       @State var progress: CGFloat = 0.0
       @State private var playing: Bool = true
       @State var duration: Double = 0.0
       @State var formattedDuration: String = ""
       @State var formattedProgress: String = "00:00"
       let grellow =  Color(0xD7E900)
    
    //Funcs
    
    func initialiseAudioPlayer() {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [ .pad ]
        
        let path = Bundle.main.path(forResource: "QuackSFX",
                                    ofType: "mp3")!
        self.audioPlayer = try! AVAudioPlayer(contentsOf:
                                                URL(fileURLWithPath: path))
        self.audioPlayer.prepareToPlay()
        
        //The formattedDuration is the string to display
        formattedDuration = formatter.string(from:
                                                TimeInterval(self.audioPlayer.duration))!
        duration = self.audioPlayer.duration
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true)
        { _ in
            if !audioPlayer.isPlaying {
                playing = false
            }
            progress = CGFloat(audioPlayer.currentTime /
                               audioPlayer.duration)
            formattedProgress = formatter
                .string(from:
                            TimeInterval(self.audioPlayer.currentTime))!
        }
    }

    
    
    var body: some View {
        VStack{
                    HStack{
                    Text(formattedProgress)
                        .font(.caption.monospacedDigit())
                    
                    // this is a dynamic length progress bar
                    
                        GeometryReader { gr in
                            Capsule()
                                .stroke(grellow, lineWidth: 2)
                                .background(
                                    Capsule()
                                        .foregroundColor(grellow)
                                        .frame(width: gr.size.width * progress,
                                               height: 8), alignment: .leading)
                        }
                        .frame(width: 250, height: 8 ).offset(x:10)
                        
                        Text(formattedDuration)
                            .font(.caption.monospacedDigit()).padding()
                            .frame(height: 50, alignment: .center)
                    }
                    
                    // the control buttons
                    HStack(alignment: .center, spacing: 20) {
                        
                        Spacer()
                        
                        Button(action: {
                            let decrease = self.audioPlayer.currentTime - 15
                            if decrease < 0.0 {
                                self.audioPlayer.currentTime = 0.0
                            } else {
                                self.audioPlayer.currentTime -= 15
                            }
                        }) {
                            Image(systemName: "gobackward.15")
                                .font(.title)
                                .imageScale(.medium)
                        }
                        
                        Button(action: {
                            if audioPlayer.isPlaying {
                                playing = false
                                self.audioPlayer.pause()
                            } else if !audioPlayer.isPlaying {
                                playing = true
                                self.audioPlayer.play()
                            }
                        }) {
                            Image(systemName: playing ?
                                  "pause.circle.fill" : "play.circle.fill")
                            .font(.title)
                            .imageScale(.large)
                        }
                        
                        Button(action: {
                            let increase = self.audioPlayer.currentTime + 15
                            if increase < self.audioPlayer.duration {
                                self.audioPlayer.currentTime = increase
                            } else {
                                self.audioPlayer.currentTime = duration
                            }
                        }) {
                            Image(systemName: "goforward.15")
                                .font(.title)
                                .imageScale(.medium)
                        }
                        
                        Spacer()
                        
                    }.foregroundColor(grellow).onAppear {
                        initialiseAudioPlayer()
                        self.audioPlayer.play()
                    }.onDisappear{ self.audioPlayer.stop()}
                    
                    
                    
                    
                }
            }

    }


struct TestAudioPlayer_Previews: PreviewProvider {
    static var previews: some View {
        TestAudioPlayer()
    }
}
