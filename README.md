# Wordle iOS – OOP Project
Native iOS implementation of the popular Wordle game, developed as a final project for the Object-Oriented Programming (OOP) course. The app is built using Swift and follows the MVC (Model-View-Controller) design pattern.

🚀 Architecture & Design Patterns
The project focus is on clean code separation and communication between objects:

Model-View-Controller (MVC):

Model: ViewController handles the game state, word validation, and color logic.

View: BoardViewController and KeyboardViewController manage the UI components using UICollectionView.

Controller: The main ViewController acts as the coordinator between the user input and the game logic.

Protocol-Oriented Programming: * Delegation: Used KeyboardViewControllerDelegate to communicate key presses from the keyboard to the main controller.

Datasource Pattern: Used BoardViewControllerDatasource to decouple the game board from the underlying data, allowing the board to remain "stateless."

🛠 OOP Principles Applied
Encapsulation: All sensitive game data, such as the answer and guesses array, are marked as private to prevent unauthorized modification outside the main logic.

Abstraction: Protocols are used to define a blueprint for communication, hiding the complexity of the game engine from the UI layers.

Modular UI: The KeyCell class is a reusable component used by both the game board and the keyboard, demonstrating efficient code reuse.

🎮 Features
Custom Word Bank: Over 100 5-letter words.

Dynamic Feedback: Real-time color coding (Green for correct, Orange for misplaced, Gray for incorrect).

Interactive Keyboard: Custom-built UI keyboard with specific layout logic and margin calculations.

Game Loop: Full game cycle including win/loss alerts and game reset functionality.

💻 Setup
Open Wordle.xcodeproj in Xcode.

Select an iOS Simulator (iPhone 13 or newer recommended).

Press Cmd + R to build and run.
