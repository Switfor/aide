//
//  ViewController.swift
//  azertyuio
//
//  Created by Richard Bergoin on 28/05/2018.
//  Copyright © 2018 Richard Bergoin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    var imageView : UIImageView? = nil
    var oldPoint : CGPoint?
    var oldImageView : UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gest = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePanGesture(_:)))
        collectionView.addGestureRecognizer(gest)

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width / 10, height: collectionView.frame.height / 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath) as! CaseCollectionViewCell
        
        //let pion = gameBoard.pionAt(x,y)
        let pion: PionColor = .noir
        if indexPath.row % 2 == 0 {
            cell.configure(withPion: pion, andBackground: .light)
        } else {
            cell.configure(withPion: .blanc, andBackground: .dark)
        }
        if indexPath.row % 3 == 0 {
            cell.configure(withPion: .vide, andBackground: .dark)
        }

        return cell
    }
}


extension ViewController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Manage an invalid drag (no pion on this case / not current pion to be played)
        return true
    }
    
    @objc func handlePanGesture(_ panGestureRecognizer: UIPanGestureRecognizer) {
        
        
        let locationPoint = panGestureRecognizer.location(in: collectionView)
        
        if panGestureRecognizer.state == .began {
            
            // Create a current viewCell "screenshot" / TODO: only pionView should be duplicated
            
            //if (imageView?.backgroundColor == UIColor.black || imageView?.backgroundColor == UIColor.white){
            
            let indexPathOfMovingCell = collectionView.indexPathForItem(at: locationPoint)!
            let cell = collectionView.cellForItem(at: indexPathOfMovingCell) as! CaseCollectionViewCell
            UIGraphicsBeginImageContext(cell.bounds.size)

            let ctx = UIGraphicsGetCurrentContext()!
            
            //cell.layer.render(in: ctx)
            //cell.pionView...
            cell.pionView.layer.render(in: ctx)
            let cellImage = UIGraphicsGetImageFromCurrentImageContext()

            //cell.center
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.pionView.bounds.width, height: cell.pionView.bounds.height))
            
            
            
            if let imageView = imageView {
                imageView.image = cellImage
                collectionView.addSubview(imageView)
                imageView.center = locationPoint
            }
            // TODO: make moving view bigger (as it is upper from other "pion")
            // use UIView transform property and CGAffineTransform(scaleX:y:) to achieve this
            imageView?.transform = CGAffineTransform(scaleX : 2 , y : 2)
            // TODO: reconfigure current cell to be in state "moving away" (pion can have a alpha of 0.5 to indicate this)
            cell.pionView.alpha = 0
            //}
            
            oldPoint=cell.center
            oldImageView=imageView
        }
        
        if panGestureRecognizer.state == .changed {
            print("pan at \(locationPoint)")
            imageView?.center = locationPoint
        }
        
        if panGestureRecognizer.state == .ended {
            // TODO: manage if movement is valid (update model accordingly)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.imageView?.center = self.oldPoint!
                self.imageView?.alpha = 1.0
                self.imageView?.transform = CGAffineTransform(scaleX : 1 , y : 1)
                
            },completion:{
              _ in
                self.oldImageView?.removeFromSuperview()
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.oldImageView?.transform = CGAffineTransform(scaleX : 1 , y : 1)
                })
            })
            

            
        }
    } }

