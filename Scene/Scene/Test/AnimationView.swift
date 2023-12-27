//
//  AnimationView.swift
//  Scene
//
//  Created by 이조은 on 12/10/23.
//

import SwiftUI
import WebKit
import AVFoundation

struct AnimationView: View {
    var body: some View {
        GifImage("AnimatedGIF")
            //.edgesIgnoringSafeArea(.all)
    }
}

struct GifImage: UIViewRepresentable {
    private let name: String

    init(_ name: String) {
        self.name = name
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webView.load(
            data,
            mimeType: "image/gif",
            characterEncodingName: "UTF-8",
            baseURL: url.deletingLastPathComponent()
        )
        webView.scrollView.isScrollEnabled = false

        // 왼쪽으로 90도 회전
        webView.transform = CGAffineTransform(scaleX: 2, y: 2)

        webView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)

        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // 웹뷰의 크기와 위치 업데이트
        uiView.reload()
    }
}


struct GifImage_Previews: PreviewProvider {
    static var previews: some View {
        AnimationView()
    }
}
