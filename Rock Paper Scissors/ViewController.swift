//
//  ViewController.swift
//  Rock Paper Scissors
//
//  Created by Abdinasir on 10/5/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var cpuImageView: UIImageView!
    
    
    @IBOutlet weak var userRoundLabel: UILabel!
    @IBOutlet weak var cpuRoundLabel: UILabel!
    @IBOutlet weak var userSetLabel: UILabel!
    @IBOutlet weak var cpuSetLabel: UILabel!
    
    //Int values to keep track of user and cpu wins
    var userRoundInt: Int = 0
    var cpuRoundInt: Int = 0
    var userSetInt: Int = 0
    var cpuSetInt: Int = 0
    
    //Streak values to see if anyone reached 4 round wins in a row
    var userStreak: Int = 0
    var cpuStreak: Int = 0
    
    //Round and Game Win Booleans
    var didUserWinRound: Bool = false
    var didCPUWinRound: Bool = false
    
    var didUserWin = false
    var didCPUWin = false
    var didGameStart = false
    
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = "Pick a Button to Start"
        userImageView.image = UIImage(named: "rpsStart")
        cpuImageView.image = UIImage(named: "rpsStart")
        textLabel.text = ""
        userRoundLabel.text = String(userRoundInt)
        userSetLabel.text = String(userSetInt)
        cpuRoundLabel.text = String(cpuRoundInt)
        cpuSetLabel.text = String(cpuSetInt)
        winLabel.isHidden = true
        retryButton.isHidden = true
        userRoundInt = 0
        cpuRoundInt = 0
        userSetInt = 0
        cpuSetInt = 0
        userStreak = 0
        cpuStreak = 0
        didUserWinRound = false
        didCPUWinRound = false
        didUserWin = false
        didCPUWin = false
        didGameStart = false
    }

    @IBAction func rockButton(_ sender: Any) {
        if didGameStart == false{
            didGameStart = true
            headerLabel.isHidden = true
        }
        let cpuChoice = Choice.randomComputerChoice()
        textLabel.text = playGame(yourChoice: .rock, cpuChoice: cpuChoice)
        userImageView.image = UIImage(named: Choice.rock.rawValue)
        cpuImageView.image = UIImage(named: cpuChoice.rawValue)
        
        userRoundLabel.text = String(userRoundInt)
        userSetLabel.text = String(userSetInt)
        cpuRoundLabel.text = String(cpuRoundInt)
        cpuSetLabel.text = String(cpuSetInt)
    }
    @IBAction func paperButton(_ sender: Any) {
        if didGameStart == false{
            didGameStart = true
            headerLabel.isHidden = true
        }
        let cpuChoice = Choice.randomComputerChoice()
        textLabel.text = playGame(yourChoice: .paper, cpuChoice: cpuChoice)
        userImageView.image = UIImage(named: Choice.paper.rawValue)
        cpuImageView.image = UIImage(named: cpuChoice.rawValue)
        
        userRoundLabel.text = String(userRoundInt)
        userSetLabel.text = String(userSetInt)
        cpuRoundLabel.text = String(cpuRoundInt)
        cpuSetLabel.text = String(cpuSetInt)
    }
    @IBAction func scissorsButton(_ sender: Any) {
        if didGameStart == false{
            didGameStart = true
            headerLabel.isHidden = true
        }
        let cpuChoice = Choice.randomComputerChoice()
        textLabel.text = playGame(yourChoice: .scissors, cpuChoice: cpuChoice)
        userImageView.image = UIImage(named: Choice.scissors.rawValue)
        cpuImageView.image = UIImage(named: cpuChoice.rawValue)
        
        userRoundLabel.text = String(userRoundInt)
        userSetLabel.text = String(userSetInt)
        cpuRoundLabel.text = String(cpuRoundInt)
        cpuSetLabel.text = String(cpuSetInt)
    }
    
    //MARK: CHOICE ENUM
    enum Choice: String{
        case rock = "rock"
        case paper = "paper"
        case scissors = "scissors"
        
        static func randomComputerChoice() -> Choice{
            let choices: [Choice] = [.rock, .paper, .scissors]
            let index = Int(arc4random_uniform(UInt32(choices.count)))
            let choice = choices[index]
            return choice
        }
    }
    //MARK: Game Logic
    func playGame(yourChoice:Choice, cpuChoice:Choice) -> String {
        //Establish Tie Condition
        if yourChoice == cpuChoice {
            return "You chose \(yourChoice), CPU chose \(cpuChoice), -> TIE"
        }
        
        //Establish Win Conditions for the User
        else if (yourChoice == .rock && cpuChoice == .scissors) ||
                    (yourChoice == .paper && cpuChoice == .rock) ||
                    (yourChoice == .scissors && cpuChoice == .paper){
            //Update winner values
            didUserWinRound = true
            didCPUWinRound = false
            updateValue()
            //Check to see if there's a winner
            return "You chose \(yourChoice), CPU chose \(cpuChoice), -> WIN"
            
        }
        //Establish Lose Condition
        else{
            //Update Winner Values
            didUserWinRound = false
            didCPUWinRound = true
            updateValue()
            return "You chose \(yourChoice), CPU chose \(cpuChoice), -> LOSE"
        }
    }
    
    //MARK: UPDATE MATCH VALUES
    func updateValue() {
        //if the User Won, and the cpu lost, increment the userRoundInt. Check to see if the Set win Conditionhas been met.
        if didUserWinRound == true && didCPUWinRound == false && userRoundInt != 1{
            userRoundInt += 1
            
            //Maintain User Streak
            userStreak += 1
            cpuStreak = 0
        }
        //If User wins the Set
        else if didUserWinRound == true && didCPUWinRound == false && userRoundInt == 1{
            //Update Scores
            userRoundInt = 0
            cpuRoundInt = 0
            userSetInt += 1
            userStreak += 1
            cpuStreak = 0
            
            if userSetInt == 2{
                didUserWin = true
                didCPUWin = false
                winLabel.isHidden = false
                winLabel.text = winnerText()
                
                //make the rock, paper, and scissors buttons not work
                
                
                //Make the retry button appear, and make it restart the match
                retryButton.isHidden = false
            }
        }
        
        //If CPU wins the round
        else if didUserWinRound == false && didCPUWinRound == true && cpuRoundInt != 1{
            cpuRoundInt += 1
            
            //Maintain CPU Streak
            userStreak = 0
            cpuStreak += 1
        }
        //If CPU Wins the Set
        else if didUserWinRound == false && didCPUWinRound == true && cpuRoundInt == 1{
            //Update Scores
            userRoundInt = 0
            cpuRoundInt = 0
            cpuSetInt += 1
            userStreak = 0
            cpuStreak += 1
            
            if cpuSetInt == 2{
                didCPUWin = true
                didUserWin = false
                winLabel.isHidden = false
                winLabel.text = winnerText()
                //make the rock, paper, and scissors buttons not work
                
                
                //Make the retry button appear, and make it restart the match
                retryButton.isHidden = false
            }
        }
        
    }
    //TODO: Check to See if There's a winner
    func winnerText() -> String{
        if didUserWin == true && didCPUWin != true{
            return "USER WON!!!"
        }
        else if didCPUWin == true && didUserWin != true{
            return "CPU WON!!!"
        }
        else if didUserWin == true && didCPUWin != true && userStreak == 4{
            return "CPU GOT SKUNKED"
        }
        else if didCPUWin == true && didUserWin != true && cpuStreak == 4{
            return "USER GOT SKUNKED"
        }
        else{
            return "They are playing, or a bug."
        }
    }
    
    
    @IBAction func retryGame(_ sender: Any) {
        viewDidLoad()
        headerLabel.isHidden = false
    }
    
    
}


