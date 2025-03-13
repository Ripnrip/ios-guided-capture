/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Top-level app structure of the view hierarchy.
*/

import SwiftUI

@main
struct GuidedCaptureSampleApp: App {
    static let subsystem: String = "org.sfomuseum.photogrammetry.guidedcapture"
    
    var body: some Scene {
        WindowGroup {
            if #available(iOS 17.0, *) {
                SplashViewControllerRepresentable()
            }
        }
    }
}


struct SplashViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SplashViewController {
        return SplashViewController()
    }
    
    func updateUIViewController(_ uiViewController: SplashViewController, context: Context) {
        // Nothing to update here.
    }
}
