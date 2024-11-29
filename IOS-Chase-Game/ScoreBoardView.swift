import SwiftUI
struct ScoreBoardView: View {
    @State private var scores: [Int] = []          // List of scores fetched from the database
    @State private var highScore: Int = 0          // High score fetched from the database
    @State private var isLoading: Bool = true      // Tracks loading state

    var dbHelper = DatabaseHelper.shared
    
    
    var body: some View {
        VStack {

            Text("High Score: \(highScore)")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.blue)

            Divider()

            if isLoading {
                ProgressView("Loading scores...")
            } else {
                List(scores, id: \.self) { score in
                    Text("Score: \(score)")
                        .font(.headline)
                }
            }

            Spacer()

            // Button to Refresh Scores
            Button(action: fetchScores) {
                Text("Refresh Scores")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Scoreboard")
        .onAppear {
            fetchScores()
        }
    }

    // Fetch scores from the database
    private func fetchScores() {
        isLoading = true
        dbHelper.fetchScores { fetchedScores in
            self.scores = fetchedScores
            self.highScore = fetchedScores.max() ?? 0
            self.isLoading = false
        }
    }
}

#Preview {
    ScoreBoardView()
}
