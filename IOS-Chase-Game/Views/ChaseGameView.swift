import SwiftUI
struct ChaseGameView: View {
    @StateObject private var game = ChaseGameModel()
    @State private var screenSize = CGSize.zero
    @State private var timer: Timer?
    var dbHelper = DatabaseHelper.shared
    @State private var isGameOver = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // White background that handles missed clicks
                Color.white
                    .ignoresSafeArea()
                    .onTapGesture {
                        handleMissClick(size: geometry.size)
                    }

                // Score Display
                VStack {
                    Text("Score: \(game.score)")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .padding()
                    
                    Spacer()
                }
                
                // Moving Button
                if !isGameOver {
                    Button(action: {
                        game.buttonTapped()
                        moveButtonAfterTap(size: geometry.size)
                    }) {
                        Text("Tap Me!")
                            .font(.headline)
                            .padding()
                            .frame(width: 100, height: 80)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .position(game.buttonPosition)
                } else {
                    VStack {
                        Text("Game Over!")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                            .padding()

                        Text("Final Score: \(game.score)")
                            .font(.title)
                            .foregroundColor(.black)
                        
                        Button(action: {
                            saveScore()   // Save the score to the database
                        }) {
                            Text("Save Score")
                                .font(.headline)
                                .padding()
                                .frame(width: 200)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding()

                        NavigationLink(destination: ScoreBoardView()) {
                            Text("View Scores")
                                .font(.headline)
                                .padding()
                                .frame(width: 200)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                screenSize = geometry.size
                game.buttonPosition = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
                if screenSize != .zero { startGame() }
            }
        }
        .onDisappear {
            timer?.invalidate()  // Stop the timer when leaving the view
        }
    }

    // Handle missed clicks
    private func handleMissClick(size: CGSize) {
        if game.missedClick() {  // Increment missed clicks and check for game over
            isGameOver = true
            timer?.invalidate()
        }
    }

    private func moveButtonAfterTap(size: CGSize) {
        game.moveButton(screenSize: size)
        restartTimer(size: size)
    }
    
    private func startGame() {
        guard timer == nil else { return }
        restartTimer(size: screenSize)
    }

    private func restartTimer(size: CGSize) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: game.getSpeed(), repeats: true) { _ in
            game.moveButton(screenSize: size)
            
            if game.score >= 10 {
                isGameOver = true
                timer?.invalidate()
            }
        }
    }

    private func saveScore() {
        dbHelper.insertScore(score: game.score)
    }
}

#Preview {
    NavigationStack {
        ChaseGameView()
    }
}
