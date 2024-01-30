//
//  ContentView.swift
//  ExampleApp
//
//  Created by polestar on 05/09/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isPresentingModal = false
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Ellipse()
                    .fill(Color.blue)
                .frame(width: geometry.size.width * 1.4, height: geometry.size.height * 0.33)
                .position(x: geometry.size.width / 2.35, y: geometry.size.height * 0.1)
                .shadow(radius: 3)
                .edgesIgnoringSafeArea(.all)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Example")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        
                        Text("NAOSwiftProvider integration")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(Color.white)

                        Spacer()
                    }
                    .padding(.leading, 25)
                    .padding(.top, 30)
                    Spacer()
                }
                
                Button {
                    isPresentingModal.toggle()
                } label: {
                    Text("START")
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(30)
            }
        }
        .fullScreenCover(isPresented: $isPresentingModal, content: {
            LocationViewControllerWrapper()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
