//
//  TestScreenViewController.swift
//  HearXProject
//
//  Created by Mihlali Mazomba on 2023/03/05.
//

import UIKit

class TestScreenViewController: UIViewController {
    
    @IBOutlet private var answerTextField: UITextField!
    
    private lazy var viewModel = TestViewModel(interactor: EventsInteractor(), delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.viewModel.startTest()
        }
    }
    
    
    @IBAction private func submitButtonTapped(_ sender: Any) {
        viewModel.submitEntered(answer: answerTextField.text ?? "")
    }
    
    @IBAction private func ExitButtonTapped(_ sender: Any) {
        viewModel.stopTest()
        self.dismiss(animated: true)
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(
                UIAlertAction(
                    title: "Cancel",
                    style: UIAlertAction.Style.default, handler: { _ in
               }))
            self.present(alert, animated: true)
            
        }
    }
}

extension TestScreenViewController: TestResultDelegate {
    func showTotalScoreAlert(score: Int) {
        showAlert(title: "Test Results", message: "This is you test score \(score)")
    }
    
    func showFailureMessage(withError error: ServiceError) {
        showAlert(title: "Error", message: error.localizedDescription)
    }
}
