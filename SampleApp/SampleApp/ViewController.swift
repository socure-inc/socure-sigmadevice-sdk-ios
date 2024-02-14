//
//  ViewController.swift
//  Demo App
//
//  Created by Nicolas Dedual on 9/29/20.
//

import UIKit
import DeviceRisk
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel:UILabel?
    @IBOutlet weak var uploadButton:UIButton?
    @IBOutlet weak var deviceAssessmentButton:UIButton?
    @IBOutlet weak var resultsTextView:UITextView?
    let webcall = Webcalls(idPlusKey: "Socure-API-Key")
    var sessionToken: String?

    let exampleUserData:[String:String] = ["firstName":"John",
                                    "surName":"Smith",
                                    "email":"j.smith@example.com",
                                    "country":"us",
                                    "physicalAddress":"123 Example Street",
                                    "city":"New York City",
                                    "state":"NY",
                                    "zip":"10011",
                                    "mobileNumber":"+00000000000"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resultsTextView?.text = "Results will be shown here."
    
        deviceAssessmentButton?.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        deviceAssessmentButton?.setBackgroundColor(UIColor.systemRed, for: .disabled)
        deviceAssessmentButton?.setBackgroundColor(UIColor.systemGreen.withAlphaComponent(0.2), for: .selected)
        deviceAssessmentButton?.setBackgroundColor(UIColor.systemGreen, for: .normal)
    }

    @IBAction func uploadData(sender:UIButton) {
        SigmaDevice.processDevice() { result, error in
            guard let error = error else {
                self.resultsTextView?.text = "sessionToken is \(result ?? "not generated")"
                self.sessionToken = result
                self.deviceAssessmentButton?.isEnabled = true
                return
            }

            switch error {
            case .unknownError, .dataFetchError:
                self.resultsTextView?.text = "unknown error"
            case .dataUploadError(let code, let message):
                self.resultsTextView?.text = "\(code ?? ""): \(message ?? "")"
            case .networkConnectionError(let nsUrlError):
                self.resultsTextView?.text = "\(nsUrlError)"
            default:
                self.resultsTextView?.text = "unknown error"
            }
        }
    }
    
    @IBAction func getDeviceAssessment(sender:UIButton) {
        deviceAssessmentButton?.isEnabled = false

        guard let sessionToken = sessionToken else {
            return
        }
        
        webcall.deviceRiskValidationAPICall(sessionToken: sessionToken, clientInfo: exampleUserData) { [weak self] response in
            
            guard let weakSelf = self else { return }
            
            guard let response = response as? [String: Any] else {
                weakSelf.deviceAssessmentButton?.isEnabled = true
                return
            }
            
            guard let deviceRiskInfo = response["deviceRisk"] as? [String: Any] else {
                weakSelf.deviceAssessmentButton?.isEnabled = true
                return
            }
            
            DispatchQueue.main.async {
                weakSelf.resultsTextView?.text = String(describing: deviceRiskInfo)
                weakSelf.deviceAssessmentButton?.isEnabled = true
            }
                        
        } onError: { [weak self] error in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.resultsTextView?.text = error?.localizedDescription
                weakSelf.deviceAssessmentButton?.isEnabled = true
            }
        }
    }
}
