//
//  APODImageView.swift
//  NasaAPOD
//
//  Created by Quin Design on 4/15/22.
//

import SwiftUI
import AVKit

struct APODImageView: View {
    
    @State var apodImage: APODResponse? = nil
    @State var isLoading = true
    
    var body: some View {
        VStack{
            if self.isLoading {
                ActivityIndicator(isAnimating: .constant(true), style: .medium)
            }
            else {
                if apodImage != nil{
                    HStack{
                        Text("\(self.apodImage?.title ?? "")").font(.title2)
                        Spacer()
                    }
                    if self.apodImage?.media_type == "image"{
                        AsyncImage(url: URL(string: self.apodImage?.url ?? "")){phase in
                            switch phase {
                            case .empty:
                                ActivityIndicator(isAnimating: .constant(true), style: .medium)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                            case .failure(_):
                                Text("Unable to fetch the image. Please try again later!")
                            @unknown default:
                                Text("Unable to fetch the image. Please try again later!")
                            }
                        }
                            .frame(width: 300, height: 300)
//                        .padding(.horizontal)

                    }
                    else{
                        if URL(string: self.apodImage?.url ?? "") != nil {
                            VideoPlayer(player: AVPlayer(url: URL(string: self.apodImage?.url ?? "")!))
                        }
                    }
                }
                else {
                    Text("Cannot fetch data. Please try again later.")
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            NetworkCalls().getLatestImage { response in
                self.apodImage = response
                self.isLoading = false
            }
        }
    }
}

struct APODImageView_Previews: PreviewProvider {
    static var previews: some View {
        APODImageView()
    }
}

struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        
        let act =  UIActivityIndicatorView(style: style)
        return act
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
