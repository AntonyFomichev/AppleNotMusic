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
  @State var tracks = UserDefaults.standard.getSavedTracks()
  @State private var showingAlert = false
  
  var tabBarDelegate: MainTabBarControllerDelegate?
  
  var body: some View {
    NavigationView {
      VStack {
        GeometryReader { geometry in
          HStack(spacing: 20) {
            Button(action: {
              self.playFirstTrack()
            },
                   label: {
                    Image(systemName: "play.fill").frame(width: geometry.size.width / 2 - 10, height: 50.0).background(Color(.tertiarySystemGroupedBackground)).cornerRadius(10.0)
                    
            })
            Button(action: {
              self.tracks = UserDefaults.standard.getSavedTracks()
            },
                   label: {
                    Image(systemName: "arrow.2.circlepath").frame(width: geometry.size.width / 2 - 10, height: 50.0).background(Color(.tertiarySystemGroupedBackground)).cornerRadius(10.0)
            })
          }
        }.padding().frame(height: 50.0)
        Divider().padding(.leading).padding(.trailing)
        List {
          ForEach(tracks) { track in
            LibraryCell(cell: track).gesture(LongPressGesture().onEnded({ _ in
              self.showingAlert = true
            }).simultaneously(with: TapGesture().onEnded({ (_) in
              self.tabBarDelegate?.maximizeTrackDetailController(viewModel: track)
            }))).actionSheet(isPresented: self.$showingAlert, content: {
              ActionSheet(title: Text("Are you sure you want to delete track?"), buttons: [.destructive(Text("Delete"), action: {
                self.delete(track: track)
              }), .cancel()])
            })
            
          }
          .onDelete(perform: delete)
        }
      }
      .navigationBarTitle("Library")
      
    }
  }
  
  func playFirstTrack() {
    guard tracks.count != 0 else { return }
    let track = tracks[0]
    self.tabBarDelegate?.maximizeTrackDetailController(viewModel: track)
  }
  
  func delete(at offSets: IndexSet) {
    tracks.remove(atOffsets: offSets)
    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
    }
  }
  
  func delete(track: SearchViewModel.Cell) {
    guard let index = tracks.firstIndex(of: track) else { return }
    tracks.remove(at: index)
    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
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
