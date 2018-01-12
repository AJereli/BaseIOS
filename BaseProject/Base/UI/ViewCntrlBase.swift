//
//  ViewCntrlBase.swift
//  SpectorViewParody
//
//  Created by Valeev Anatoliy on 20/12/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import UIKit


class ViewCntrlBase : UIViewController {
    
    
    private var _spinner:UIActivityIndicatorView = UIActivityIndicatorView()
    private var _loadOverlay:LoadingOverlay!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSpinner()
        setLoadOverlay()
        
        if let nav = navigationController {
            nav.interactivePopGestureRecognizer?.isEnabled = false
            nav.navigationBar.isExclusiveTouch = true
        }
        
       
    }
    
    func setLoadOverlay(){
        _loadOverlay = LoadingOverlay()
    }
    
    func showLoadOverlay(_ animated:Bool = true){
        _loadOverlay.showOverlay(animated)
    }
    
    func hideLoadOverlay(_ animated:Bool = true){
        _loadOverlay.hideOverlay(animated)
    }
    
    fileprivate func setSpinner() {
        _spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        _spinner.stopAnimating()
        _spinner.hidesWhenStopped = true
        _spinner.isHidden = true
        view.addSubview(_spinner)
    }
    
    func showSpinner() {
      
        _spinner.isHidden = false
        _spinner.startAnimating()
    }
    
    func hideSpinner() {
        _spinner.isHidden = true
        _spinner.stopAnimating()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeKeyboardUpdates()
      
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        unsubscribeKeyboardUpdates()
        
      
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         _spinner.center = CGPoint(x: view.frame.size.width * 0.5, y: view.frame.size.height * 0.5)
      
    }
    
    func subscribeKeyboardUpdates() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    func unsubscribeKeyboardUpdates() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    @objc private func keyboardWillShow(_ n: Notification) {
        let duration: TimeInterval = TimeInterval((n.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue ?? 0.33)
        let kbdFrame: CGRect = (n.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        let curveInt: UInt = (n.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? 0
        let curve = UIViewAnimationOptions(rawValue: curveInt << 16)
        
        keyboardWillShow(kbdFrame.size, duration: duration, curve: curve)
    }
    
    func keyboardWillShow(_ size: CGSize, duration: TimeInterval, curve: UIViewAnimationOptions) {}
    
    @objc private func keyboardWillHide(_ n: Notification) {
        let duration: TimeInterval = TimeInterval((n.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue ?? 0.33)
        let curveInt: UInt = (n.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? 0
        let curve = UIViewAnimationOptions(rawValue: curveInt << 16)
        
        keyboardWillHide(duration, curve: curve)
    }
    
    func keyboardWillHide(_ duration: TimeInterval, curve: UIViewAnimationOptions) {}
    
    @objc private func keyboardDidShow(_ n: Notification) {
        let duration: TimeInterval = TimeInterval((n.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue ?? 0.33)
        let kbdFrame: CGRect = (n.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        let curveInt: UInt = (n.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? 0
        let curve = UIViewAnimationOptions(rawValue: curveInt << 16)
        
        keyboardDidShow(kbdFrame.size, duration: duration, curve: curve)
    }
    
    func keyboardDidShow(_ size: CGSize, duration: TimeInterval, curve: UIViewAnimationOptions) {}
}
