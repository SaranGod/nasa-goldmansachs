//
//  APODImageView.swift
//  NasaAPOD
//
//  Created by Saran on 4/15/22.
//

import SwiftUI
import AVKit
import WebKit

struct APODImageView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var apodImage: APODResponse? = nil
    @State var isLoading = true
    @State var dateString = ""
    @State var dateToSearch = ""
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var items: FetchedResults<NasaApodImage>
    
    @State var isFavourite = false
    
    var body: some View {
        VStack{
            if self.isLoading {
                VStack{
                    ActivityIndicator(isAnimating: .constant(true), style: .medium)
                    Text("Fetching Data")
                }
            }
            else {
                if apodImage != nil{
                    ScrollView(showsIndicators: false){
                        HStack{
                            VStack(alignment: .leading){
                                Text("\(dateString)").font(.body)
                            }
                            Spacer()
                            Button(action: self.favouriteItem){
                                if self.isFavourite{
                                    Image(systemName: "heart.fill")
                                }
                                else {
                                    Image(systemName: "heart")
                                }
                            }
                        }
                        if self.apodImage?.media_type == "image"{
                            if !((self.apodImage?.url ?? "").isEmpty){
                                Image(uiImage: UIImage(data: Data(base64Encoded: self.apodImage?.url ?? "") ?? Data(base64Encoded: "")!)!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 300)
                            }
                            else {
                                Image(systemName: "exclamationmark.icloud.fill")
                                    .frame(width: 300, height: 300)
                            }

                        }
                        else{
                            if URL(string: self.apodImage?.url ?? "") != nil {
                                WebView(request: URLRequest(url: URL(string: self.apodImage?.url ?? "")!))
                                    .frame(width: 300, height: 300)
                            }
                        }
                        Text("\(self.apodImage?.explanation ?? "")").font(.body).multilineTextAlignment(.leading)
                        
                    }
                }
                else {
                    Text("Cannot fetch data. Please try again later.")
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            let fetchedItems = items.filter({ $0.date == self.dateToSearch })
            if fetchedItems.count > 0 {
                self.isFavourite = fetchedItems[0].isFavourite
                if fetchedItems[0].date != nil{
                    getImageDTOFromResponse(APODResponse(date: fetchedItems[0].date ?? "", title: fetchedItems[0].title ?? "", url: fetchedItems[0].image ?? "", media_type: fetchedItems[0].mediaType ?? "", explanation: fetchedItems[0].explanation ?? ""))
                }
            }
            else {
                NetworkCalls().getImageByDate(date: self.dateToSearch) { response in
                    self.getImageDTOFromResponse(response)
                    self.addItem()
                }
            }
        }
        .navigationTitle(self.apodImage?.title ?? "")
        .navigationBarTitleDisplayMode(.large)
    }
    
    func getImageDTOFromResponse(_ dto: APODResponse?){
        if dto != nil {
            self.apodImage = dto
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateFormatterConvert = DateFormatter()
            dateFormatterConvert.dateFormat = "dd MMM yyyy"
            let dateAsDate = dateFormatter.date(from: self.apodImage?.date ?? "")
            self.dateString = dateFormatterConvert.string(from: dateAsDate ?? Date())
        }
        self.isLoading = false
    }
    
    private func favouriteItem() {
        withAnimation {
            items.filter({$0.date == self.dateToSearch}).forEach({$0.isFavourite = !self.isFavourite})
            self.isFavourite = !isFavourite
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func addItem() {
        let newItem = NasaApodImage(context: viewContext)
        newItem.mediaType = self.apodImage?.media_type ?? ""
        newItem.image = self.apodImage?.url ?? ""
        newItem.explanation = self.apodImage?.explanation ?? ""
        newItem.date = self.apodImage?.date ?? ""
        newItem.title = self.apodImage?.title ?? ""
        newItem.isFavourite = false
        self.isFavourite = false
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

struct WebView : UIViewRepresentable {
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
}

