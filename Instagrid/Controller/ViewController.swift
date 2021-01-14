//
//  ViewController.swift
//  Instagrid
//
//  Created by Johann on 29/12/2020.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var grid: ActiveGrid!
    
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        grid.viewRadius()
        grid.activeDisplay = .layoutReverseT
    }
    
    var selectedView = 1
    // ajouts images
    @IBAction func newPictureTopLeft() {
        loadPicture()
        selectedView = 1
    }
    
    @IBAction func newPictureTopRight() {
        loadPicture()
        selectedView = 2
        
    }
    
    @IBAction func newPictureBottomLeft() {
        loadPicture()
        selectedView = 3
        
    }
    
    @IBAction func newPictureBottomRight() {
        loadPicture()
        selectedView = 4
    }
    
    // func pickup gallery
    func loadPicture() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self;
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    // func add image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let newPicture = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        //       grid.topRightView.setImage(newPicture, for: .normal)
        switch selectedView {
        case 1 :
            grid.topLeftView.setImage(newPicture, for: .normal)
        case 2 :
            grid.topRightView.setImage(newPicture, for: .normal)
        case 3 :
            grid.bottomLeftView.setImage(newPicture, for: .normal)
        case 4 :
            grid.bottomRightView.setImage(newPicture, for: .normal)
        default:
            print("error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // selection button
    @IBAction func SelectedLayout1(_ sender: Any) {
        grid.activeDisplay = .layoutT
    }
    
    @IBAction func SelectedLayout2(_ sender: Any) {
        grid.activeDisplay = .layoutReverseT
    }
    
    @IBAction func SelectedLayout3(_ sender: Any) {
        grid.activeDisplay = .fourSquare
    }
    
    // Conversion traitement image

    // func share + alerte manque elements
    @IBAction func share(_ sender: UISwipeGestureRecognizer) {
    }
    
    // retour normal
}
