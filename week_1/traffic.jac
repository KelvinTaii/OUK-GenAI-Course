import random;

class RockPaperScissors {
    def init(self: RockPaperScissors) {
        self.choices = ["rock", "paper", "scissors"];
    }

    def play(self: RockPaperScissors) {
        print("Welcome to Rock, Paper, Scissors!");
        player_choice = input("Enter rock, paper, or scissors: ").lower();

        if player_choice not in self.choices {
            print("Invalid choice! Try again.");
            return;
        }

        computer_choice = random.choice(self.choices);
        print(f"Computer chose: {computer_choice}");

        if player_choice == computer_choice {
            print("It's a tie!");
        } elif (player_choice == "rock" and computer_choice == "scissors")
            or (player_choice == "paper" and computer_choice == "rock")
            or (player_choice == "scissors" and computer_choice == "paper") {
            print("You win! 🎉");
        } else {
            print("You lose! 😢");
        }
    }
}

with entry {
    game = RockPaperScissors();
    game.play();
}