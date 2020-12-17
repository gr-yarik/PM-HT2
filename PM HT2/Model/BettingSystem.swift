//
//  BettingSystem.swift
//  PM HT2
//
//  Created by Yaroslav Hrytsun on 16.12.2020.
//

import Foundation

enum UserStatus {
    case regular
    case admin
}

enum LogStatus {
    case loggedIn
    case loggedOut
}

enum BanStatus {
    case banned
    case notBanned
}

class BettingSystem {
    
    public static let shared = BettingSystem()
    
    private init() { }
    
    private var users: [User] = [
//        User(status: .admin, username: "a", password: "d"), User(status: .regular, username: "p", password: "p")
//        для теста юзаю
    ]
    
    private var currentUser: User? {
        didSet {
            if currentUser == nil {
                logStatus = .loggedOut
            } else {
                logStatus = .loggedIn
            }
        }
    }
    
    private var logStatus: LogStatus = .loggedOut
    
    func registerNewUser(status: UserStatus, username: String, password: String) throws {
        guard users.first( where: { $0.username == username }) == nil else {
            throw PMError.busyUsername
        }
        let newUser = User(status: status, username: username, password: password)
        users.append(newUser)
    }
    
    
    func logIn(username: String, password: String) throws {
        switch logStatus {
        case .loggedIn:
            throw PMError.successiveLogin
        case .loggedOut:
            guard let user = users.first(where: { $0.username == username && $0.password == password }) else {
                throw PMError.wrongLoginData
            }
            if user.banStatus == .banned {
                throw PMError.loginWhenBanned
            }
            currentUser = user
            print("You have successfuly logged in")
        }
    }
    
    
    func logOut() throws {
        switch logStatus {
        case .loggedIn:
            logStatus = .loggedOut
            let currentUserIndex = users.firstIndex(where: { $0.username == currentUser?.username })
            users[currentUserIndex!] = currentUser!
            currentUser = nil
            print("You have successfuly logged out")
        case .loggedOut:
            throw PMError.successiveLogout
        }
    }
    
    
    func placeBet(outcome: String) throws {
        switch logStatus {
        case .loggedIn:
            switch currentUser!.status {
            case .admin:
                throw PMError.adminBets
            case .regular:
                currentUser?.placedBets.append(outcome)
                print("New bet \(outcome) has been successfuly placed.")
            }
        case .loggedOut:
            throw PMError.actionWhenLoggedOut
        }
    }
    
    
    func printPlacedBets() throws -> String {
        switch logStatus {
        case .loggedIn:
            print(currentUser!.placedBets)
            return currentUser!.placedBets.joined(separator: "\n")
        case .loggedOut:
            throw PMError.seeBetsWhenLoggedOut
        }
    }
    
    
    func printUsers() throws -> String {
        switch logStatus {
        case .loggedIn:
            switch currentUser!.status {
            case .admin:
                let usersData = (users.filter({ $0.status == .regular }).map({$0.username}))
                return usersData.joined(separator: "\n")
            default:
                throw PMError.accessDenied
            }
        case .loggedOut:
            throw PMError.actionWhenLoggedOut
        }
    }
    
    
    func banUser(username: String) throws {
        switch logStatus {
        case .loggedIn:
            switch currentUser!.status {
            case .admin:
                guard let indexOfUserToBan = users.firstIndex(where: {$0.username == username && $0.status == .regular}) else {
                    throw PMError.cannotBan
                }
                users[indexOfUserToBan].banStatus = .banned
                print("User \(username) is successfuly banned.")
            default:
                throw PMError.accessDenied
            }
        case .loggedOut:
            throw PMError.actionWhenLoggedOut
        }
    }
}

struct User {
    fileprivate var status: UserStatus
    fileprivate let username: String
    fileprivate let password: String
    fileprivate var placedBets: [String] = []
    fileprivate var banStatus: BanStatus = .notBanned
}
