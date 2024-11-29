
import SwiftUI
import Combine

class ChaseGameModel: ObservableObject {
       @Published var score: Int = 0
       @Published var buttonPosition: CGPoint = .zero
       @Published var missedClicks: Int = 0  // Track missed clicks
       
       private var speed: TimeInterval = 1.0  // Speed at which the button moves
       private let minSpeed: TimeInterval = 0.5  // Minimum speed cap
       private let speedIncrement: TimeInterval = 0.1  // Speed increase after each tap
       private let maxMissedClicks: Int = 3  // Limit
    
    // Called when the button is tapped
    func buttonTapped() {
        score += 1	
        increaseSpeed()
    }
    
    // Called when a click is missed (interaction with background)
       func missedClick() -> Bool {
           missedClicks += 1
           return missedClicks >= maxMissedClicks  // Return `true` if game is over
       }
       
    // Move the button to a random position within the screen bounds
    func moveButton(screenSize: CGSize) {
        let x = CGFloat.random(in: 50...(screenSize.width - 50))
        let y = CGFloat.random(in: 50...(screenSize.height - 50))
        buttonPosition = CGPoint(x: x, y: y)
    }
    
    // Get the current speed (time interval) for moving the button
    func getSpeed() -> TimeInterval {
        return speed
    }
    
    // Increase the game speed by reducing the time interval
    private func increaseSpeed() {
        speed = max(speed - speedIncrement, minSpeed) 
    }
}
