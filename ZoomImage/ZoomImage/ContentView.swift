//
//  ContentView.swift
//  ZoomImage
//
//  Created by Karanveer Singh Brar on 06/10/19.
//  Copyright © 2019 Karanveer Singh Brar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var scale: CGFloat = 1.0
    @State var isTapped: Bool = false
    @State var pointTapped: CGPoint = CGPoint.zero
    @State var draggedSize: CGSize = CGSize.zero
    @State var previousDragged: CGSize = CGSize.zero
    var body: some View {
        GeometryReader {reader in
            Image("pizza1delivery").resizable().scaledToFit().animation(.default).offset(x: self.draggedSize.width, y: 0).scaleEffect(self.scale).scaleEffect(self.isTapped ? 2 : 1, anchor: UnitPoint(x: self.pointTapped.x / reader.frame(in: .global).maxX, y: self.pointTapped.y / reader.frame(in: .global).maxY)).gesture(TapGesture(count: 2).onEnded({
            self.isTapped = !self.isTapped
        }).simultaneously(with: DragGesture(minimumDistance: 0, coordinateSpace: .global).onChanged({ (value) in
            self.pointTapped = value.startLocation
            self.draggedSize = CGSize(width: value.translation.width + self.previousDragged.width, height: value.translation.height + self.previousDragged.height)
//            print(value.startLocation)
        }).onEnded({ (value) in
//            print(value.location)
            let offsetWidth = (reader.frame(in: .global).maxX * self.scale - reader.frame(in: .global).maxX) / 2
            let newDraggedWidth = self.draggedSize.width * self.scale
            if (newDraggedWidth > offsetWidth) {
                self.draggedSize = CGSize(width: offsetWidth / self.scale, height: value.translation.height + self.previousDragged.height)
            } else if (newDraggedWidth < -offsetWidth) {
                self.draggedSize = CGSize(width: -offsetWidth / self.scale, height: value.translation.height + self.previousDragged.height)
            } else {
                self.draggedSize = CGSize(width: value.translation.width + self.previousDragged.width, height: value.translation.height + self.previousDragged.height)
            }
            self.previousDragged = self.draggedSize
            }))).gesture(MagnificationGesture().onChanged({ (scale) in
            self.scale = scale.magnitude
        }).onEnded({ (scaleFinal) in
            self.scale = scaleFinal.magnitude
        }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
