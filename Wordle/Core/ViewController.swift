import UIKit

class ViewController: UIViewController {
    
    let answers = [
        "apple", "beach", "brain", "bread", "brush", "chair", "chest", "chord", "click", "clock",
        "cloud", "dance", "diary", "drink", "drive", "earth", "feast", "field", "fruit", "glass",
        "grape", "green", "ghost", "heart", "house", "juice", "light", "lemon", "melon", "money",
        "music", "night", "ocean", "party", "piano", "pilot", "plane", "phone", "pizza", "plant",
        "radio", "river", "robot", "shirt", "shoes", "smile", "snake", "space", "spoon", "storm",
        "table", "tiger", "toast", "touch", "train", "truck", "voice", "water", "watch", "whale",
        "world", "write", "yacht", "zebra", "above", "adult", "alive", "alone", "angry", "apply",
        "areas", "asset", "audio", "awful", "basic", "below", "black", "blind", "block", "blood",
        "board", "boost", "bound", "brave", "brick", "brief", "bring", "broke", "build", "burnt",
        "cable", "candy", "catch", "cause", "chain", "chart", "check", "chief", "child", "china"
    ]
    
    var answer = ""
    private var guesses: [[Character?]] = Array(repeating: Array(repeating: nil, count: 5), count: 6)
    
    // Pratimo u kojem smo redu trenutno
    private var currentRowIndex = 0
    
    let keyboardVC = KeyboardViewController()
    let boardVC = BoardViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answer = answers.randomElement() ?? "apple"
        view.backgroundColor = .systemGray6
        addChildren()
    }
    
    private func addChildren() {
        addChild(keyboardVC)
        keyboardVC.didMove(toParent: self)
        keyboardVC.delegate = self
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardVC.view)
        
        addChild(boardVC)
        boardVC.didMove(toParent: self)
        boardVC.view.translatesAutoresizingMaskIntoConstraints = false
        boardVC.datasource = self
        view.addSubview(boardVC.view)
        
        addConstraints()
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            boardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            boardVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            boardVC.view.bottomAnchor.constraint(equalTo: keyboardVC.view.topAnchor),
            boardVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            keyboardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - Keyboard Logic
extension ViewController: KeyboardViewControllerDelegate {
    func keyboardViewController(_ vc: KeyboardViewController, didTapKey letter: Character) {
        
        
        if letter == "<" {
            deleteLastLetter()
            return
        }

        if letter == "»" {
            submitGuess()
            return
        }
        
        addLetter(letter)
    }
    
    private func addLetter(_ letter: Character) {
        // Dodajemo slovo samo u trenutni red ako ima mjesta
        for j in 0..<guesses[currentRowIndex].count {
            if guesses[currentRowIndex][j] == nil {
                guesses[currentRowIndex][j] = letter
                boardVC.reloadData()
                return
            }
        }
    }
    
    private func deleteLastLetter() {
        // Brišemo zadnje uneseno slovo samo u trenutnom redu
        for j in (0..<5).reversed() {
            if guesses[currentRowIndex][j] != nil {
                guesses[currentRowIndex][j] = nil
                boardVC.reloadData()
                return
            }
        }
    }
    
    private func submitGuess() {
        let currentGuess = guesses[currentRowIndex].compactMap { $0 }
        
        // Provjeri ima li riječ 5 slova
        guard currentGuess.count == 5 else {
            print("Riječ mora imati 5 slova!")
            return
        }
        
        let guessString = String(currentGuess).lowercased()
        
        // Provjera pobjede
        if guessString == answer.lowercased() {
            boardVC.reloadData() // Da se oboje polja u zeleno
            showResultAlert(title: "Pobjeda! 🎉", message: "Pogodili ste riječ: \(answer.uppercased())")
        }
        // Provjera poraza
        else if currentRowIndex == 5 {
            boardVC.reloadData()
            showResultAlert(title: "Kraj igre ❌", message: "Niste pogodili. Riječ je bila: \(answer.uppercased())")
        }
        // Sljedeći pokušaj
        else {
            currentRowIndex += 1
            boardVC.reloadData()
        }
    }
    
    func showResultAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Igraj ponovno", style: .default, handler: { _ in
            self.resetGame()
        }))
        present(alert, animated: true)
    }
    
    func resetGame() {
        guesses = Array(repeating: Array(repeating: nil, count: 5), count: 6)
        answer = answers.randomElement() ?? "apple"
        currentRowIndex = 0
        boardVC.reloadData()
    }
}

extension ViewController: BoardViewControllerDatasource {
    var currentGuesses: [[Character?]] {
        return guesses
    }
    
    func boxColor(at indexPath: IndexPath) -> UIColor? {
        let rowIndex = indexPath.section
        let colIndex = indexPath.row
        
        // Provjera prikazujemo li boju za ovaj red
        guard rowIndex < currentRowIndex || (self.presentedViewController != nil && rowIndex == currentRowIndex) else {
            return nil
        }
        
        // Uzimamo slovo iz guesses i pretvaramo ga u String (mala slova)
        guard let guessChar = guesses[rowIndex][colIndex] else { return nil }
        let guestLetter = String(guessChar).lowercased()
        
        // Uzimamo slovo iz odgovora i pretvaramo ga u String (mala slova)
        let indexedAnswer = Array(answer.lowercased())
        let targetLetter = String(indexedAnswer[colIndex])
        
        if guestLetter == targetLetter {
            return .systemGreen
        } else if answer.lowercased().contains(guestLetter) {
            return .systemOrange
        } else {
            return .systemGray4
        }
    }
}
