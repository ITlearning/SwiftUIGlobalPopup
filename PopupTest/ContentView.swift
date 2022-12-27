//
//  ContentView.swift
//  PopupTest
//
//  Created by Tabber on 2022/12/26.
//

import SwiftUI
import PopupView

struct ContentView: View {
    @State var popupOpen: Bool = false
    
    
    
    var popupAlignment: PopupAlignemt = .top
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .onTapGesture {
                    withAnimation(.interpolatingSpring(stiffness: 200, damping: 50)) {
                        
                        GlobalPopupView.shared.show(image: UIImage(systemName: "globe")!, title: "Test", message: "mesage")
                        //popupOpen.toggle()
                    }
                }
            Text("Hello, world!")
            
            Button(action: {
                //GlobalPopupView.shared.show(image: UIImage(named: "IMG_4459")!, title: "쑥쑥이의 아빠, Tabber님!", message: "쑥쑥이의 생일 선물 준비 하셨나요?", alignment: .top)
                GlobalImagePopupView.shared.show(image: UIImage(named: "IMG_4459")!, title: nil, message: nil)
            }, label: {
                Text("Top")
            })
            
            Button(action: {
                GlobalPopupView.shared.show(image: UIImage(named: "IMG_4459")!, title: "쑥쑥이의 아빠, Tabber님!", message: "쑥쑥이의 생일 선물 준비 하셨나요?", alignment: .mid)
            }, label: {
                Text("Mid")
            })
            
            Button(action: {
                GlobalPopupView.shared.show(image: UIImage(named: "IMG_4459")!, title: "쑥쑥이의 아빠, Tabber님!", message: "쑥쑥이의 생일 선물 준비 하셨나요?", alignment: .bottom)
            }, label: {
                Text("Bottom")
            })
            
            PopupView {
                
                VStack {
                    HStack {
                        Text("쑥톡")
                            .foregroundColor(.black)
                            .font(.system(size: 15, weight: .bold, design: .default))
                            .padding(.bottom, 20)
                            
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 10)
                        
                    Text("Hello World")
                        .padding(.bottom, 20)
                }
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                .frame(height: 50)
                
            }
            .offset(x: 0, y: popupOpen ? (UIScreen.main.bounds.height/2) - 150 : (UIScreen.main.bounds.height/2) + 50)
            
        }
        .padding()
        .onChange(of: popupOpen, perform: { value in
            print(value)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
