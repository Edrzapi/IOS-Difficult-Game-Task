import Foundation
import SQLite3

class DatabaseHelper {
    static var shared: DatabaseHelper = DatabaseHelper()
    private var db: OpaquePointer?

    init() {
        self.openDatabase()
        self.createTable()
    }


    private func openDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("scoresDB.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database.")
        }
    }

    // Create the scores table
    private func createTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Scores (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            score INTEGER
        );
        """
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Scores table created.")
            } else {
                print("Scores table could not be created.")
            }
        } else {
            print("Create table statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }

    // Insert a new score
    func insertScore(score: Int) {
        let insertQuery = "INSERT INTO Scores (score) VALUES (?);"
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(score))
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted score.")
            } else {
                print("Could not insert score.")
            }
        } else {
            print("Insert statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }

    // Fetch all scores
    func fetchScores(completion: ([Int]) -> Void) {
        let fetchQuery = "SELECT score FROM Scores;"
        var fetchStatement: OpaquePointer?
        var scores: [Int] = []

        if sqlite3_prepare_v2(db, fetchQuery, -1, &fetchStatement, nil) == SQLITE_OK {
            while sqlite3_step(fetchStatement) == SQLITE_ROW {
                let score = sqlite3_column_int(fetchStatement, 0)
                scores.append(Int(score))
            }
        } else {
            print("Fetch statement could not be prepared.")
        }
        sqlite3_finalize(fetchStatement)
        completion(scores)
    }

    // Fetch the highest score
    func fetchHighScore(completion: (Int) -> Void) {
        let highScoreQuery = "SELECT MAX(score) FROM Scores;"
        var highScoreStatement: OpaquePointer?
        var highScore = 0

        if sqlite3_prepare_v2(db, highScoreQuery, -1, &highScoreStatement, nil) == SQLITE_OK {
            if sqlite3_step(highScoreStatement) == SQLITE_ROW {
                highScore = Int(sqlite3_column_int(highScoreStatement, 0))
            }
        } else {
            print("High score statement could not be prepared.")
        }
        sqlite3_finalize(highScoreStatement)
        completion(highScore)
    }
}
