
import SwiftUI
import Combine

class ChaseGameModel: ObservableObject {
    // Published properties to notify the view when they change
    @Published var score: Int = 0
    @Published var buttonPosition: CGPoint = .zero
    
    private var speed: TimeInterval = 1.0  // Speed at which the button moves
    private let minSpeed: TimeInterval = 0.5  // Minimum speed cap
    private let speedIncrement: TimeInterval = 0.1  // Speed increase after each tap
    
    // Called when the button is tapped
    func buttonTapped() {
        score += 1
        increaseSpeed()
    }
    
    // Move the button to a random position within the screen bounds
    func moveButton(screenSize: CGSize) {
        let x = CGFloat.random(in: 50...(screenSize.width - 50))  // Ensure button stays within screen bounds
        let y = CGFloat.random(in: 50...(screenSize.height - 50))
        buttonPosition = CGPoint(x: x, y: y)
    }
    
    // Get the current speed (time interval) for moving the button
    func getSpeed() -> TimeInterval {
        return speed
    }
    
    // Increase the game speed by reducing the time interval
    private func increaseSpeed() {
        speed = max(speed - speedIncrement, minSpeed)  // set minimum speed
    }
}
