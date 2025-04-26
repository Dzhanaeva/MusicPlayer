//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Гидаят Джанаева on 18.11.2024.
//

import SwiftUI
import RealmSwift
import UIKit

struct PlayerView: View {
    
    @ObservedResults(SongModel.self) var songs
    @StateObject var vm = ViewModel()
    @State private var showFiles = false
    @State private var showFullPlayer = false
    @State private var isDragging = false
    @Namespace private var playerAnimation

    
    var frameImage: CGFloat {
        showFullPlayer ? 300 : 60
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                
                    BackgroundColor()
                
                if showFullPlayer {
                    Color.white
                        .ignoresSafeArea()
                        .transition(.opacity) // Анимация появления
                        .zIndex(1) // Выше списка, но ниже самого плеера
                }

//                VStack {
                    List{
                        ForEach(songs) { song in
                            SongCell(song: song, durationFormatted: vm.durationFormatted)
                                .onTapGesture {
                                    vm.playAudio(song: song)
                                }
                        }
                        .onDelete(perform: $songs.remove)
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .listStyle(.plain)


                    
                    if vm.currentSong != nil {
                        
                        Player()
                            .frame(height: showFullPlayer ? SizeConstant.fullPlayer : SizeConstant.miniPlayer )
                            .onTapGesture {
                                withAnimation(.spring) {
                                    self.showFullPlayer.toggle()
                                    
                                    
                                }
                            }
                            .background(Color.clear)
                            .zIndex(2)
                        
                    }

                }
                

                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showFiles.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .font(.title3)
                                .foregroundStyle(.black)
                        }
                    }
                }
                .sheet(isPresented: $showFiles) {
                    ImportFileManager()
                }
            }
    }
    
    @ViewBuilder
    
    private func Player() -> some View {
        ZStack {
            
            if !showFullPlayer {
                // Тень под плеером
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.lightGrayCustom)
                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    .frame(height: SizeConstant.miniPlayer) // Размер тени для мини-плеера
                    .padding(.horizontal, 20)

                // Содержимое мини-плеера
                HStack {
                    
                    SongImageView(imageData: vm.currentSong?.coverImage, size: frameImage)
                        .clipShape(RoundedRectangle(cornerRadius: showFullPlayer ? 28 : 10))
                        .shadow(color: vm.dominantColor.swiftUIColor, radius: 6, x: 2, y: 4)
                        .frame(width: frameImage + 30, height: frameImage + 35)
                
                    VStack(alignment: .leading) {
                        SongDescriptionMini()
                    }
//                    .matchedGeometryEffect(id: "Song Title", in: playerAnimation)
                    .background(Color.clear)
                    
                    Spacer()
                    
                    CustomButton(image: vm.isPlaying ? "PauseMini" : "PlayMini", size: 22) {
                        vm.playPause()
                    }
                    .padding(.trailing, 16)
                }
                .padding(20) // Внутренний отступ внутри плеера
                .frame(height: SizeConstant.miniPlayer) // Задаём фиксированный размер
                .background(Color.clear) // Убираем лишние фоны
            }


            
            VStack {
     
                if showFullPlayer {
                    HStack {
                        // Обложка песни (увеличенная)
                        ZStack {
                            // Внешняя более размазанная тень
                            RoundedRectangle(cornerRadius: showFullPlayer ? 28 : 10)
                                .fill(vm.dominantColor.swiftUIColor.opacity(0.7))
                                .frame(width: frameImage + 35, height: frameImage + 35)
                                .blur(radius: 23)

                            // Внутренняя яркая тень
                            RoundedRectangle(cornerRadius: showFullPlayer ? 28 : 10)
                                .fill(vm.dominantColor.swiftUIColor.opacity(0.4))
                                .frame(width: frameImage + 10, height: frameImage + 10)
                                .blur(radius: 7)
                               
                            // Обложка
                            SongImageView(imageData: vm.currentSong?.coverImage, size: frameImage)
                                .clipShape(RoundedRectangle(cornerRadius: showFullPlayer ? 28 : 10))
//                                .matchedGeometryEffect(id: "Song Title", in: playerAnimation)
                        }
                        .transition(.opacity)
                    }
                    .padding(.horizontal, 10)
                    
                    VStack {
                        SongDescriptionMax()
                        
                    }
                    .matchedGeometryEffect(id: "Song Title", in: playerAnimation)
                    .padding(.top)
                    
                    VStack {
                        HStack {
                            Text("\(vm.durationFormatted(duration: vm.currentTime))")
                            Spacer()
                            Text("\(vm.durationFormatted(duration: vm.totalTime))")
                        }
                        .durationFont()
                        .padding(.horizontal, 40)
                        .offset(y: 40)
                        
//                        Slider(value: $vm.currentTime, in: 0...vm.totalTime) { editing in
//                            isDragging = editing
//                            
//                            if !editing {
//                                vm.seekAudio(time: vm.currentTime)
//                            }
//                        }

//                        .accentColor(.black)
//                        .padding(.horizontal, 40)
                        CustomProgressBar(value: $vm.currentTime, range: 0...vm.totalTime, onEditingEnded: { newTime in
                            vm.seekAudio(time: vm.currentTime) // Метод синхронизации с плеером
                        })
                            .padding(.horizontal, 40)
                            .offset(y: 40)
                            .onAppear {
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                vm.updateProgress()
                            }
                        }

                        

                        
                        HStack(spacing: 55) {
                            
                            CustomButton(image: "BackTwo", size: 30) {
                                vm.backward()
                            }
                            
                            CustomButton(image: vm.isPlaying ? "PauseMaxTwo" : "PlayMaxTree", size: 60) {
                                vm.playPause()
                            }
                            
                            CustomButton(image: "NextTwo", size: 30) {
                                vm.forward()
                            }

                        }
                        .offset(y: 30)
                        .padding(40)
                    }
                }
            }
        }
        
    }
    
    private func CustomButton(image: String, size: CGFloat, action: @escaping () -> ()) -> some View {
        Button {
            action()
        } label: {
            Image(image)
                .resizable() // Делаем изображение масштабируемым
                .aspectRatio(contentMode: .fit) // Сохраняем пропорции
                .frame(width: size, height: size) // Устанавливаем размер
                .foregroundColor(.black)
        }
    }
    
    @ViewBuilder
    private func SongDescriptionMini() -> some View {
        if let currentSong = vm.currentSong {
            Text(currentSong.name)
                .nameFont()
            Text(currentSong.artist ?? "Unknown")
                .artistFont()
        }
    }
    
    @ViewBuilder
    private func SongDescriptionMax() -> some View {
        if let currentSong = vm.currentSong {
            Text(currentSong.name)
                .nameFontMax()
            Text(currentSong.artist ?? "Unknown")
                .artistFontTwo()
        }
    }
}


#Preview {
    PlayerView()
}


