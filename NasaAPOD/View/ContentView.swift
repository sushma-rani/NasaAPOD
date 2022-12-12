//
//  ContentView.swift
//  NasaAPOD
//
//  Created by Shivakumar, Sushma on 09/12/22.
//

import SwiftUI
import CoreData
import AVKit

struct ContentView: View {
    @StateObject private var viewModel = APODViewModel()
    @State private var currentDate = Date.now
    @Environment(\.colorScheme) var colorScheme
    @State private var player: AVPlayer? = nil
    @State var showsAlert = false
    @State private var error = ""
    @State private var calendarId: Int = 0
    @State private var imageOfTheDay: UIImage?
    @State private var showFavorite = false
    @State private var favourite = false
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ManagedAPOD.picDate, ascending: false)],
        animation: .default)
    private var items: FetchedResults<ManagedAPOD>
    var body: some View {
        NavigationView {
            VStack {
                TitleView()
                List {
                    HStack {
                        if showFavorite {
                            Button(action: {
                                favourite = !favourite
                                _ = NasaAPODDataManager.shared.favouritePic(day: Date.yyyyMMdd.string(from: currentDate), favourite: favourite)
                            }) {
                                self.favourite ? Image(systemName: "heart.fill")
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .imageScale(.large) :
                                Image(systemName: "heart")
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .imageScale(.large)
                            }
                        }
                        
                        DatePicker("", selection: $currentDate, displayedComponents: .date)
                            .id(calendarId)
                            .accessibility(identifier: AccessibilityIdentifiers.datePicker)
                            .onChange(of: currentDate, perform: { value in
                                showFavorite = false
                                loadData()
                            })
                            .onTapGesture {
                                calendarId += 1
                            }
                    }.buttonStyle(PlainButtonStyle())
                    
                    ImageContainerView(viewModel: viewModel, player: $player, imageOfTheDay: $imageOfTheDay, showFavorite: $showFavorite)
                        .onAppear {
                            loadData()
                        }
                        .alert(isPresented: $showsAlert) {
                            Alert(title: Text("Error in retrieving the data for \(Date.yyyyMMdd.string(from: currentDate))"), message: Text(error))
                        }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    func loadData() {
        var loadingLocally = false
        for imageDetails in items {
            if let date = imageDetails.picDate, date == Date.yyyyMMdd.string(from: currentDate) {
                loadingLocally = true
                loadDataFromCoreData(entity: imageDetails)
            }
        }
        if !loadingLocally {
            imageOfTheDay = nil
            loadDataFromNetwork()
        }
    }
    
    func loadDataFromCoreData(entity: ManagedAPOD) {
        viewModel.apod = APOD(date: entity.picDate ?? "" , explanation: entity.message ?? "", hdurl: nil, serviceVersion: nil, mediaType: entity.mediaType ?? "", title: entity.title ?? "", url: entity.url ?? "")
        if let storedImageData = entity.value(forKey: "imageData") as? Data {
            imageOfTheDay = UIImage(data: storedImageData)
        }
        player = AVPlayer(url: URL(string: viewModel.apod.url)!)
        showsAlert = false
        calendarId += 1
        showFavorite = true
        favourite = entity.isFav
    }
    
    func loadDataFromNetwork() {
        viewModel.loadData(date: Date.yyyyMMdd.string(from: currentDate)) { (success, errorString) in
            calendarId += 1
            if success {
                player = AVPlayer(url: URL(string: viewModel.apod.url)!)
                showsAlert = false
            } else {
                self.error = errorString ?? ""
                showsAlert = true
            }
            favourite = false
        }
    }
}

struct TitleView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var displayInboxPage = false
    var body: some View {
        HStack {
            Text("🌟✨ NASA Pic of the day ✨🌟")
                .font(Font.custom(Fellix.bold.rawValue, size: 22))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .padding([.top, .leading], 20)
                .accessibility(identifier: AccessibilityIdentifiers.picOfTheDay)
            
            Spacer()
            NavigationLink(destination: FavouritePicturesView(), isActive: $displayInboxPage) {
                    Image(systemName: "list.star")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding([.top, .trailing], 20)
                        .imageScale(.large)
                        .onTapGesture {
                            displayInboxPage = true
                        }
                }
        }
    }
}

struct ImageContainerView: View {
    @ObservedObject var viewModel: APODViewModel
    @Binding var player: AVPlayer?
    @Environment(\.colorScheme) var colorScheme
    @Binding var imageOfTheDay: UIImage?
    @Binding var showFavorite: Bool
    var body: some View {
        VStack {
            if viewModel.apod.mediaType == MediaType.image.rawValue {
                if let image = imageOfTheDay {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 300, height: 300)
                        .cornerRadius(15)
                        .accessibility(identifier: AccessibilityIdentifiers.image)
                } else {
                    AsyncImage(url: URL(string: viewModel.apod.url)) { image in
                        image.resizable()
                            .scaledToFill()
                            .accessibility(identifier: AccessibilityIdentifiers.image)
                            .onChange(of: image.asUIImage()) { newImage in
                                NasaAPODDataManager.shared.addAPODData(APODModel: viewModel.apod, image: image.asUIImage())
                                showFavorite = true
                            }
                            .onAppear {
                                showFavorite = true
                            }
                    }
                     placeholder: {
                         ProgressView()
                     }
                     .frame(width: 300, height: 300)
                    .cornerRadius(15)
                }
            } else if viewModel.apod.mediaType == MediaType.video.rawValue, let _player = player {
                VideoPlayer(player: _player)
                    .frame(width: 300, height: 300)
                    .padding(.top, 20)
            }
            Text(viewModel.apod.title)
                .font(Font.custom(Fellix.medium.rawValue, size: 20))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .accessibility(identifier: AccessibilityIdentifiers.title)
            Text(viewModel.apod.explanation)
                .padding(.top, 20)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .accessibility(identifier: AccessibilityIdentifiers.message)
        }
        .padding([.leading, .trailing], 20)
    }
}

