//
//  UploadImageViewController.swift
//  Final
//
//  Created by lime on 2023/4/22.
//

import UIKit
import CoreLocation


class UploadImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var lblLocation: UILabel!
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    var UploadProtocol: UploadImageProtocol?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    @IBAction func uploadAction(_ sender: Any) {
        guard let img = imgView.image else {return}
        
        guard let title = txtTitle.text else {return}
        guard let location = lblLocation.text else {return}
        
        UploadProtocol?.uploadedImageDelegate(img: img, locationImg: location, titleImg: title)
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func takeAPictureAction(_ sender: Any) {
        locationManager.requestLocation()
        
        // set alert
        let actionSheet = UIAlertController(title: "Take a picture", message: "Something", preferredStyle: .alert)

        // if select camera
        let cameraAction = UIAlertAction(title: "Camera", style: .default){action in

                        // start the image picker
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true)
            }

            print("User selected camera")
        }

        // if select photo library
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default){action in

            // check the photo libray available
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){

                                // start the image picker
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                imagePicker.allowsEditing = false
                                // show
                self.present(imagePicker, animated: true)
            }


            print("User Photo Library")
        }

        // select cancel
        let cancel = UIAlertAction(title: "Cancel", style: .default){action in
            print("Cancel")
        }

        // add these actions
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoLibraryAction)
        actionSheet.addAction(cancel)

        // show
        self.present(actionSheet, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        // want an original image from info, and change it to UIImage
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imgView.image = image
        }
        
        picker.dismiss(animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    // update the location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("start get location")
        
        guard let location = locations.last else{return}
        
        // get the location name
        getAddressFromLocation(locaiton: location)
    }
    
    // get location name
    func getAddressFromLocation(locaiton: CLLocation){
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(locaiton){ placemarks, error in
            if error != nil{
                print(error)
            }
            
            var address = ""
            guard let place = placemarks?.first else{return}
            
            if place.name != nil{
                address += place.name! + ", "
            }
            
            if place.locality != nil{
                address += place.locality! + ", "
            }
            
            if place.subLocality != nil{
                address += place.subLocality! + ", "
            }
            
            if place.country != nil{
                address += place.country! + ", "
            }
            
            if place.postalCode != nil{
                address += place.postalCode! + ", "
            }
            
            print(address)
            self.lblLocation.text = address
            
        }
    }
    
    
    
}
