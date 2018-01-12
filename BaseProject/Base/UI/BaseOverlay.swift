//
//  BaseOverlay.swift
//  BaseProject
//
//  Created by Valeev Anatoliy on 11/01/2018.
//  Copyright © 2018 Valeev A. All rights reserved.
//

import UIKit

class BaseOverlay: ViewCntrlBase, UIGestureRecognizerDelegate {

    private var _window:UIWindow?
    private var _isShown:Bool = false
    
    var hideByTap:Bool {return true}
    
    internal func actionByTap (){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.alpha = 0
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseOverlay.actByTap))
        tapRecognizer.delegate = self
        self.view.addGestureRecognizer(tapRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    internal func winLvl () -> UIWindowLevel{
        return UIWindowLevelStatusBar - 2
    }
    
     @objc func actByTap (){
        if hideByTap{
            hideOverlay()
        }else {
            actionByTap()
        }
    }
    
    func showOverlay (_ animated:Bool = true){
        
        _window = UIWindow(frame: UIScreen.main.bounds)
        _window?.rootViewController = self
        _window?.windowLevel = winLvl()
        _window?.makeKeyAndVisible()
        
        if animated {
            UIView.stdAnimated( animations: {
                self.view.alpha = 1
            }, completion: {cmpl in
            })
        } else {
            self.view.alpha = 1
        }
        
        _isShown = true
    }
    
    func hideOverlay(_ animated:Bool = true){
        if !_isShown{ return }
        
        guard let currWin = _window else {return}
        
        if animated {
            UIView.stdAnimated(animations: {self.view.alpha = 0}, completion: { cmpl in
                currWin.rootViewController = nil
                currWin.isHidden = true
                currWin.removeFromSuperview()
            })
        }else{
            currWin.rootViewController = nil
            currWin.isHidden = true
            currWin.removeFromSuperview()
            view.alpha = 0
        }
        
        _isShown = false
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view {
            if view.isKind(of: UIControl.self) {
                return false
            }
        }
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
