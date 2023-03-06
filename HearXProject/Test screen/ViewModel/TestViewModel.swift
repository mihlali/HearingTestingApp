//
//  TestViewModel.swift
//  HearXProject
//
//  Created by Mihlali Mazomba on 2023/03/05.
//

import Foundation
import AVFoundation

struct PlayedItem {
    var name: String
    var itemExtension: String
}

struct Triplet {
    var noise: PlayedItem
    var playedList: [PlayedItem]
}

protocol TestResultDelegate: NSObject {
    func showTotalScoreAlert(score: Int)
    func showFailureMessage(withError error: ServiceError)
}

class TestViewModel {
    
    private let initialWaitTime = 3
    private let testRoundWaitTime = 2
    private var testTotalScore = 0
    private var playerList = [AVAudioPlayer]()
    private var roundNumber = 1
    private var numberArray = [1,2,3,4,5,6,7,8,9]
    private var playedTriplet = ""
    private var results = [String]()
    private weak var delegate: TestResultDelegate?
    
    private var interactor: ResultsProtocol
    
    init(interactor: ResultsProtocol, delegate: TestResultDelegate?) {
        self.interactor = interactor
        self.delegate = delegate
    }
    
    func updateTestTotalScore(for answer: String) {
        if playedTriplet == answer {
            testTotalScore += 1
        }
    }
    
    func submitEntered(answer: String) {
        if roundNumber < 10  {
            updateRoundNumber(for: answer)
            updateTestTotalScore(for: answer)
            results.append(compileResult(answer))
        } else {
           uploadResult()
        }
    }
    
    func stopTest() {
        playerList.forEach { player in
            if player.isPlaying {
                player.stop()
            }
        }
    }
    
    func startTest() {
        let noise = triplet.noise
        play(noise)
        
        triplet.playedList.forEach { playedItem in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.play(playedItem)
            }
        }
    }
    
    private func uploadResult() {
        interactor.upload(
            userResult: results.description) { [weak self] (result: Result<[UploadResult], ServiceError>) in
                switch result {
                case .success(_):
                    self?.delegate?.showTotalScoreAlert(score: self?.testTotalScore ?? 0)
                case .failure(let failure):
                    self?.delegate?.showFailureMessage(withError: failure)
                }
            }
    }
    
    private var triplet: Triplet {
        playedTriplet = ""
        let digitList = ( 1...3 ).map { _ in
            let randomNumber = generateRandomNumber()
            playedTriplet += "\(randomNumber)"
            return PlayedItem(name: "\(randomNumber)", itemExtension: "m4a")
        }
        return Triplet(noise: PlayedItem(name: "noise_\(roundNumber)", itemExtension: "m4a"), playedList:  digitList)
    }
    
    
    private func updateRoundNumber(for answer: String) {
        if playedTriplet == answer {
            roundNumber += 1
        } else {
            roundNumber -= 1
        }
    }
    
     private func play(_ playedItem: PlayedItem) {
        guard let bundle = Bundle.main.path(
            forResource: playedItem.name,
            ofType: playedItem.itemExtension) else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
             
           let player =  try AVAudioPlayer(contentsOf: URL(filePath: bundle))
            playerList.append(player)
            playerList.last?.prepareToPlay()
            playerList.last?.play()
        } catch {
            // add delegate for alert
        }
    }
    
    private func generateRandomNumber() -> Int {
        let arrayCount = numberArray.count - 1
        let randomIndex = Int.random(in: 0...arrayCount)
        let random = numberArray[randomIndex]
        numberArray.swapAt(randomIndex, numberArray.count-1)
        numberArray.removeLast()
        return random
    }
    
    private func compileResult(_ answer: String) -> String {
        return "triplet_played: \(playedTriplet) triplet_answered:\(answer) difficulty: 1, \(roundNumber)"
    }
}
