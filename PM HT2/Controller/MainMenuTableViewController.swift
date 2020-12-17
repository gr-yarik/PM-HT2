//
//  MainMenuTableViewController.swift
//  PM HT2
//
//  Created by Yaroslav Hrytsun on 16.12.2020.
//

import UIKit

class MainMenuTableViewController: UITableViewController {

    var username: String!
    var users: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = username
    }

    
    @IBAction func placeBetButtonPressed(_ sender: UIButton) {
        presentInputAlertOnMainThread(title: "Enter your bet") { [weak self] bet in
            guard let self = self else { return }
            do {
                try BettingSystem.shared.placeBet(outcome: bet)
            } catch let error as PMError {
                self.presentAlertOnMainThread(message: error.rawValue)
            }
            
        }
    }
    
    
    @IBAction func banUserButtonPressed(_ sender: UIButton) {
        presentInputAlertOnMainThread(title: "Enter user`s username") { [weak self] username in
            guard let self = self else { return }
            do {
                try BettingSystem.shared.banUser(username: username)
            } catch let error as PMError {
                self.presentAlertOnMainThread(message: error.rawValue)
            }
            
        }
    }
    
    @IBAction func browseUsers(_ sender: Any) {
        users = ""
        do {
            users = try BettingSystem.shared.printUsers()
            performSegue(withIdentifier: "usersSegue", sender: nil)
        } catch let error as PMError {
            self.presentAlertOnMainThread(message: error.rawValue)
        } catch { }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFromMainMenu" {
            do {
                try BettingSystem.shared.logOut()
            } catch let error as PMError {
                presentAlertOnMainThread(message: error.rawValue)
            } catch {}
        }
        else if segue.identifier == "betsSegue" {
            var placedBets = ""
            do {
                placedBets = try BettingSystem.shared.printPlacedBets()
            } catch let error as PMError {
                self.presentAlertOnMainThread(message: error.rawValue)
            } catch { }
            let destinationVC = (segue.destination as! UINavigationController).topViewController as! DetailsViewController
            destinationVC.text = placedBets
        }
        else if segue.identifier == "usersSegue" {
            let destinationVC = (segue.destination as! UINavigationController).topViewController as! DetailsViewController
            destinationVC.text = users
        }
    }
    
}
