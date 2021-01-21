//
//  ViewController.swift
//  Instagrid
//
//  Created by Johann on 29/12/2020.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - @IBOutlet
    
    // Variables Buttons for Layout
    
    @IBOutlet weak var layout1: UIButton!
    @IBOutlet weak var layout2: UIButton!
    @IBOutlet weak var layout3: UIButton!
    
    // Variables for Grid Views
    
    @IBOutlet weak var gridView: UIStackView!
    @IBOutlet weak var gridPicture: UIView!
    @IBOutlet weak var topView: UIStackView!
    @IBOutlet weak var bottomView: UIStackView!
    @IBOutlet weak var topLeftView: UIButton!
    @IBOutlet weak var topRightView: UIButton!
    @IBOutlet weak var bottomLeftView: UIButton!
    @IBOutlet weak var bottomRightView: UIButton!
    
    // Variables for Share Displat
    
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    
    // MARK: - Private Var for Gesture
    
    private var swipeGesture: UISwipeGestureRecognizer!
    
    // MARK: - FirstView
    
    // Do any additional setup after loading the view.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewRadius()
        activeDisplay = .layoutReverseT
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(doSwipe(_:)))
        gridPicture.addGestureRecognizer(swipeGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(disposition), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    
    // MARK: - Layout Views
    
    // Enumeration Layout Buttons
    
    enum Display {
        case layoutT, layoutReverseT, fourSquare
    }
    
    // Display Default Layout
    
    var activeDisplay: Display = .layoutReverseT {
        didSet {
            currentLayout(activeDisplay)
        }
    }
    
    // Display Layout Selection and Apply to Grid
    
    private func currentLayout(_ layoutDisplay: Display) {
        switch layoutDisplay {
        case .layoutT:
            layout1.setImage(UIImage(named: "Selected"), for: .normal)
            layout2.imageView?.isHidden = true
            layout3.imageView?.isHidden = true
            topRightView.isHidden = true
            topLeftView.isHidden = false
            bottomRightView.isHidden = false
            bottomLeftView.isHidden = false
            
        case .layoutReverseT:
            layout2.setImage(UIImage(named: "Selected"), for: .normal)
            layout1.imageView?.isHidden = true
            layout3.imageView?.isHidden = true
            bottomRightView.isHidden = true
            topRightView.isHidden = false
            topLeftView.isHidden = false
            bottomLeftView.isHidden = false
            
        case .fourSquare:
            layout3.setImage(UIImage(named: "Selected"), for: .normal)
            layout1.imageView?.isHidden = true
            layout2.imageView?.isHidden = true
            topRightView.isHidden = false
            topLeftView.isHidden = false
            bottomRightView.isHidden = false
            bottomLeftView.isHidden = false
        }
    }
    
    
    // Radius correction to all views
    
    func viewRadius() {
        topLeftView.layer.cornerRadius = 2
        topRightView.layer.cornerRadius = 2
        bottomLeftView.layer.cornerRadius = 2
        bottomRightView.layer.cornerRadius = 2
    }
    
    // MARK: - @IBAction
    
    // @IBAction Button for selected Layout
    
    @IBAction func SelectedLayout1(_ sender: Any) {
        activeDisplay = .layoutT
    }
    
    @IBAction func SelectedLayout2(_ sender: Any) {
        activeDisplay = .layoutReverseT
    }
    
    @IBAction func SelectedLayout3(_ sender: Any) {
        activeDisplay = .fourSquare
    }
    
    
    // @IBAction to Add pictures to each place
    
    @IBAction func newPictureTopLeft() {
        loadPicture()
        isView = .topLeftView
    }
    
    @IBAction func newPictureTopRight() {
        loadPicture()
        isView = .topRightView
    }
    
    @IBAction func newPictureBottomLeft() {
        loadPicture()
        isView = .bottomLeftView
    }
    
    @IBAction func newPictureBottomRight() {
        loadPicture()
        isView = .bottomRightView
    }
    
    // MARK: - Sharing
    
    // Define Orientation of device
    @objc func disposition() {
        if UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
            swipeLabel.text = "Swipe left to share"
            arrow.image = UIImage(named: "Arrow Left")
            swipeGesture.direction = .left
        } else {
            swipeLabel.text = "Swipe up to share"
            arrow.image = UIImage(named: "Arrow Up")
            swipeGesture.direction = .up
        }
    }
    
    // swipe when action recognized
    
    @objc func doSwipe(_ sender: UISwipeGestureRecognizer) {
        gridAnimation()
        if sender.state == .recognized {
            share()
        }
    }
    
    // Func Pickup image in Library
    
    func loadPicture() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self;
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    //enum view
    
    enum CurrentView {
        case topLeftView, topRightView, bottomLeftView, bottomRightView
    }
    var isView : CurrentView = .bottomLeftView
    
    // func add image to active view
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let newPicture = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        switch isView {
        case .topLeftView:
            topLeftView.setImage(newPicture, for: .normal)
            topLeftView.imageView?.layer.cornerRadius = 2
            
        case .topRightView:
            topRightView.setImage(newPicture, for: .normal)
            topRightView.imageView?.layer.cornerRadius = 2
            
        case .bottomLeftView :
            bottomLeftView.setImage(newPicture, for: .normal)
            bottomLeftView.imageView?.layer.cornerRadius = 2
            
        case .bottomRightView :
            bottomRightView.setImage(newPicture, for: .normal)
            bottomRightView.imageView?.layer.cornerRadius = 2
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // Conversion UIView to UIImage
    
    func gridImage(with view: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        return image
    }
    
    // Func to Share picture after Conversion
    
    private func share() {
        let imageToShare = gridImage(with: gridPicture)
        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {(activityViewController, completed, returnedItem, error) in
            self.reverseGridAnimation()
        }
        
    }
    
    // MARK: - Animation
    
    // func animation when Share
    func gridAnimation() {
        let minusGrid = CGAffineTransform(scaleX: 0.4, y: 0.4)
        
        if UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
            let swipeLeftAnimation = CGAffineTransform(translationX: -self.view.frame.width , y: 0)
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.gridPicture.transform = minusGrid.concatenating(swipeLeftAnimation)
            })
            arrow.isHidden = true
            swipeLabel.isHidden = true
        } else {
            let swipeUpAnimation = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.gridPicture.transform = minusGrid.concatenating(swipeUpAnimation)
            })
            arrow.isHidden = true
            swipeLabel.isHidden = true
        }
    }
    
    // func animation when End Share
    
    func reverseGridAnimation() {
        arrow.isHidden = false
        swipeLabel.isHidden = false
        UIView.animate(withDuration: 0.4, delay: 0, animations: {
            self.gridPicture.transform = .identity
        })
        
    }
    
    // MARK: - Bonus
    
    // func alertmessage
    func showAlertPopup() {
        // create the alert
        let alert = UIAlertController(title: "Empty Image", message: "You need to complete the Grid", preferredStyle: .alert)
        
        // add an action
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // si pas d'image
    func checkPicture() {
    }
}

