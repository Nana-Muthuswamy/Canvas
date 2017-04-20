//
//  ViewController.swift
//  Canvas
//
//  Created by Nana on 4/19/17.
//  Copyright © 2017 Nana. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var panTrayViewGesture: UIPanGestureRecognizer!

    var trayOriginalCenter: CGPoint!
    var trayCenterWhenOpen: CGPoint!
    var trayCenterWhenClosed: CGPoint!

    var newlyCreatedFace: UIImageView!
    var newFaceOriginalCenter: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()

        trayCenterWhenOpen = CGPoint(x: trayView.frame.size.width / 2, y: view.frame.size.height - (trayView.frame.height / 2))
        trayCenterWhenClosed = CGPoint(x: trayCenterWhenOpen.x, y: trayCenterWhenOpen.y + 184)

        trayView.center = trayCenterWhenClosed
        trayOriginalCenter = trayView.center

        panTrayViewGesture.delegate = self
    }

    @IBAction func trayPanGestureRecognizer(_ sender: UIPanGestureRecognizer) {

        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)

        if sender.state == .began {
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            if velocity.y > 0 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                    self.trayView.center = self.trayCenterWhenClosed
                }, completion: nil)
            } else {

                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                    self.trayView.center = self.trayCenterWhenOpen
                }, completion: nil)
            }
        }
    }

    @IBAction func trayTapGestureRecognizer(_ sender: UITapGestureRecognizer) {

        if sender.state == .ended {

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { 
                self.trayView.center = self.trayView.center == self.trayCenterWhenOpen ? self.trayCenterWhenClosed : self.trayCenterWhenOpen

            }, completion: nil)
        }
    }

    @IBAction func facePanGestureRecognizer(_ sender: UIPanGestureRecognizer) {

        if sender.state == .began {

            // Gesture recognizers know the view they are attached to
            let imageView = sender.view as! UIImageView

            // Create a new image view that has the same image as the one currently panning
            newlyCreatedFace = UIImageView(image: imageView.image)

            // Add the new face to the tray's parent view.
            view.addSubview(newlyCreatedFace)

            // Initialize the position of the new face.
            newlyCreatedFace.center = imageView.center

            // Since the original face is in the tray, but the new face is in the
            // main view, you have to offset the coordinates
            newlyCreatedFace.center.y += trayView.frame.origin.y

            newFaceOriginalCenter = newlyCreatedFace.center

        } else if sender.state == .changed {

            let translation = sender.translation(in: trayView)

            newlyCreatedFace.center = CGPoint(x: newFaceOriginalCenter.x, y: newFaceOriginalCenter.y + translation.y)

        } else if sender.state == .ended {
        }
    }


    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }



}

