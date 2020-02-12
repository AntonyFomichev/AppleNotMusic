//
//  Library.swift
//  AppleNotMusic
//
//  Created by Антон on 11.02.2020.
//  Copyright © 2020 Tony Blaire. All rights reserved.
//

import SwiftUI
import URLImage

struct Library: View {
  var tracks = UserDefaults.standard.getSavedTracks()
  
  var body: some View {
    NavigationView {
      VStack {
        GeometryReader { geometry in
          HStack(spacing: 20) {
            Button(action: {
              print("54321")
            },
                   label: {
                    Image(systemName: "play.fill").frame(width: geometry.size.width / 2 - 10, height: 50.0).background(Color(.tertiarySystemGroupedBackground)).cornerRadius(10.0)
                    
            })
            Button(action: {
              print("543321")
            },
                   label: {
                    Image(systemName: "arrow.2.circlepath").frame(width: geometry.size.width / 2 - 10, height: 50.0).background(Color(.tertiarySystemGroupedBackground)).cornerRadius(10.0)
            })
          }
        }.padding().frame(height: 50.0)
        Divider().padding(.leading).padding(.trailing)
        List(tracks) { track in
          LibraryCell(cell: track)
        }
      }
      .navigationBarTitle("Library")
      
    }
  }
}

struct LibraryCell: View {
  var cell: SearchViewModel.Cell
  var body: some View {
    HStack {
      URLImage(URL(string: cell.iconUrlString ?? "")!, content: {
        $0.image
          .resizable().frame(width: 60.0, height: 60.0).cornerRadius(2)
      })
      VStack(alignment: .leading) {
        Text("\(cell.trackName ?? "")")
        Text("\(cell.artistName)")
      }
    }
  }
}


struct Library_Previews: PreviewProvider {
  static var previews: some View {
    Library()
  }
}
