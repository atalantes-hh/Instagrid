//
//  ViewController.swift
//  Instagrid
//
//  Created by Johann on 29/12/2020.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Enumerations
    
    // Enumeration for the layout Display buttons
    enum Display {
        case layoutT, layoutReverseT, fourSquare
    }
    
    // Enumeration for CurrentView
    enum CurrentView {
        case topLeftView, topRightView, bottomLeftView, bottomRightView
    }
    var isView: CurrentView = .bottomLeftView
    
    // MARK: - @IBOutlet
    
    //  Buttons for layout
    @IBOutlet weak var layout1: UIButton!
    @IBOutlet weak var layout2: UIButton!
    @IBOutlet weak var layout3: UIButton!
    
    // All views & Buttons for Grid and Subviews
    @IBOutlet weak var gridPicture: UIView!
    @IBOutlet weak var topLeftView: UIButton!
    @IBOutlet weak var topRightView: UIButton!
    @IBOutlet weak var bottomLeftView: UIButton!
    @IBOutlet weak var bottomRightView: UIButton!
    
    // Main Title
    @IBOutlet weak var instagridLabel: UILabel!
    
    // Share Display : Label & Arrow
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    
    // MARK: - Private var
    
    private var swipeGesture: UISwipeGestureRecognizer!
    
    // Display Layout Default
    var activeDisplay: Display = .layoutReverseT {
        didSet {
            currentLayout(activeDisplay)
        }
    }
    
    // MARK: - FirstView when application lauch
    
    // viewDidLoad : Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        viewRadius()
        activeDisplay = .layoutReverseT
        
        //Active gesture options
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        gridPicture.addGestureRecognizer(swipeGesture)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(disposition),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }
    
    // MARK: - @IBAction
    
    // @IBAction Buttons for selected Layout
    @IBAction func selectedLayout1(_ sender: Any) {
        activeDisplay = .layoutT
    }
    
    @IBAction func selectedLayout2(_ sender: Any) {
        activeDisplay = .layoutReverseT
    }
    
    @IBAction func selectedLayout3(_ sender: Any) {
        activeDisplay = .fourSquare
    }
    
    // @IBAction to Add pictures to each view
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
    
    // MARK: Private Methods
    
    // Radius correction from all views
    private func viewRadius() {
        topLeftView.layer.cornerRadius = 2
        topRightView.layer.cornerRadius = 2
        bottomLeftView.layer.cornerRadius = 2
        bottomRightView.layer.cornerRadius = 2
    }
    
    // Display Layout Selection and apply configuration to Grid
    private func currentLayout(_ layoutDisplay: Display) {
        switch layoutDisplay {
        case .layoutT:
            layout1.setImage(UIImage(named: "Selected"), for: .normal)
            layout2.setImage(nil, for: .normal)
            layout3.setImage(nil, for: .normal)
            topRightView.isHidden = true
            topLeftView.isHidden = false
            bottomRightView.isHidden = false
            bottomLeftView.isHidden = false
        case .layoutReverseT:
            layout2.setImage(UIImage(named: "Selected"), for: .normal)
            layout1.setImage(nil, for: .normal)
            layout3.setImage(nil, for: .normal)
            bottomRightView.isHidden = true
            topRightView.isHidden = false
            topLeftView.isHidden = false
            bottomLeftView.isHidden = false
        case .fourSquare:
            layout3.setImage(UIImage(named: "Selected"), for: .normal)
            layout1.setImage(nil, for: .normal)
            layout2.setImage(nil, for: .normal)
            topRightView.isHidden = false
            topLeftView.isHidden = false
            bottomRightView.isHidden = false
            bottomLeftView.isHidden = false
        }
    }
    
    // Define Orientation of device
    @objc private func disposition() {
        if UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
            // Condition for small display iPhone SE Gen 1
            if (traitCollection.verticalSizeClass == .compact) && (traitCollection.horizontalSizeClass == .compact) {
                swipeLabel.font = swipeLabel.font.withSize(22)
                instagridLabel.font = instagridLabel.font.withSize(30)
            } else {
                swipeLabel.font = swipeLabel.font.withSize(28)     
            }
            swipeLabel.text = "Swipe left to share"
            arrow.image = UIImage(named: "Arrow Left")
            swipeGesture.direction = .left
        } else {
            swipeLabel.text = "Swipe up to share"
            arrow.image = UIImage(named: "Arrow Up")
            swipeGesture.direction = .up
        }
    }
    
    // Swipe when action recognized & Add Methods to checkEmptyPicture
    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        guard checkPicture() else { return}
        gridAnimation()
        if sender.state == .recognized {
            share()
        }
    }
    
    // Access and choose image in Photo Library
    private func loadPicture() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    // Conversion UIView to UIImage
    private func gridImage(with view: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        return image
    }
    
    // Share picture after Conversion with gridImage
    private func share() {
        let imageToShare = gridImage(with: gridPicture)
        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {(_, _, _, _) in
            self.reverseGridAnimation()
        }
    }
    
    // func alertmessage
    private func showAlertPopUp() {
        // create the alert
        let alert = UIAlertController(title: "Warning : Empty Image",
                                      message: "You need to complete the grid before sharing",
                                      preferredStyle: .alert)
        // add an action
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // Image Completion Checking if view is Hidden ignore PopUp Alert
    private func checkPicture() -> Bool {
        // checking image data if pngData is not equal to Plus image the function is ignore
        guard let plusImage = UIImage(named: "Plus")?.pngData() else { return false }
        
        if topLeftView.isHidden == false, topLeftView.image(for: .normal)?.pngData() == plusImage {
            showAlertPopUp()
            return false
        }
        if topRightView.isHidden == false, topRightView.image(for: .normal)?.pngData() == plusImage {
            showAlertPopUp()
            return false
        }
        if bottomLeftView.isHidden == false, bottomLeftView.image(for: .normal)?.pngData() == plusImage {
            showAlertPopUp()
            return false
        }
        if bottomRightView.isHidden == false, bottomRightView.image(for: .normal)?.pngData() == plusImage {
            showAlertPopUp()
            return false
        }
        return true
    }
    
    // Lauch animation when Share to each mode of orientation
    private func gridAnimation() {
        // Reduction of the grid
        let minusGrid = CGAffineTransform(scaleX: 0.4, y: 0.4)
        if UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
            // Combine minusGrid and swipe translation
            let swipeLeftAnimation = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
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
    
    //  Reverse Animation when end Share
    private func reverseGridAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            self.gridPicture.transform = .identity
        })
        arrow.isHidden = false
        swipeLabel.isHidden = false
    }
    
    // MARK: - Internal Methods
    
    // Picking image with loadPicture and apply to choosen view
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any] ) {
        let newPicture = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        switch isView {
        case .topLeftView:
            topLeftView.setImage(newPicture, for: .normal)
            topLeftView.imageView?.contentMode = .scaleAspectFill
            topLeftView.imageView?.layer.cornerRadius = 2
        case .topRightView:
            topRightView.setImage(newPicture, for: .normal)
            topRightView.imageView?.contentMode = .scaleAspectFill
            topRightView.imageView?.layer.cornerRadius = 2
        case .bottomLeftView :
            bottomLeftView.setImage(newPicture, for: .normal)
            bottomLeftView.imageView?.contentMode = .scaleAspectFill
            bottomLeftView.imageView?.layer.cornerRadius = 2
        case .bottomRightView :
            bottomRightView.setImage(newPicture, for: .normal)
            bottomRightView.imageView?.contentMode = .scaleAspectFill
            bottomRightView.imageView?.layer.cornerRadius = 2
        }
        self.dismiss(animated: true, completion: nil)
    }
}
