//
//  SankeyTips.swift
//  Track
//
//  Created by Ethan Maxey on 12/8/24.
//

import TipKit

struct SankeyLandscapeTip: Tip {
    var title: Text {
        Text("Not Looking Quite Right?")
    }


    var message: Text? {
        Text("Rotate your device to landscape mode for the best visual experience.")
    }


    var image: Image? {
        Image(systemName: "rectangle.portrait.rotate")
    }
}
