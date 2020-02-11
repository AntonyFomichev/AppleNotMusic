//
//  Library.swift
//  AppleNotMusic
//
//  Created by Антон on 11.02.2020.
//  Copyright © 2020 Tony Blaire. All rights reserved.
//

import SwiftUI

struct Library: View {
  var body: some View {
    NavigationView {
      VStack {
        GeometryReader { geometry in
          HStack(spacing: 20) {
            Button(action: {
              print("54321")
            },
                   label: {
                    Image(systemName: "play.fill").frame(width: geometry.size.width / 2 - 10, height: 50).background(Color(.tertiarySystemGroupedBackground)).cornerRadius(10)          })
            Button(action: {
              print("54321")
            },
                   label: {
                    Image(systemName: "arrow.2.circlepath").frame(width: geometry.size.width / 2 - 10, height: 50).background(Color(.tertiarySystemGroupedBackground)).cornerRadius(10)
            })
          }
        }.padding().frame(height: 50)
        Divider().padding(.leading).padding(.trailing)
        List {
          LibraryCell()
        }
      }
      .navigationBarTitle("Library")
      
    }
  }
}

struct LibraryCell: View {
  var body: some View {
    HStack {
      Image("1").resizable().frame(width: 60, height: 60).cornerRadius(4)
      VStack {
        Text("Fangirl")
        Text("Lil Peep")
      }
    }
  }
}


struct Library_Previews: PreviewProvider {
  static var previews: some View {
    Library()
  }
}
