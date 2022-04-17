//
//  APODImageByDate.swift
//  NasaAPOD
//
//  Created by Saran on 4/16/22.
//

import SwiftUI

struct APODImageByDate: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isPickingDate = true
    @State var selectedDate = Date()
    @State var pickedDateString = ""
    
    var body: some View {
        VStack{
            if self.isPickingDate {
                DatePicker("", selection: self.$selectedDate, in: ...Date(), displayedComponents: .date)
                    .datePickerStyle(.wheel)
                Button(action: {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    self.pickedDateString = dateFormatter.string(from: self.selectedDate)
                    self.isPickingDate = false
                }){
                    Text("Search")
                }
                Spacer()
            }
            else {
                APODImageView(dateToSearch: self.pickedDateString)
                    .environment(\.managedObjectContext, viewContext)
                Button(action: resetViewState){
                    Text("Search Another Date")
                }
            }
        }
    }
    
    func resetViewState(){
        self.isPickingDate = true
        self.selectedDate = Date()
        self.pickedDateString = ""
    }
    
}

struct APODImageByDate_Previews: PreviewProvider {
    static var previews: some View {
        APODImageByDate()
    }
}
