//
//  ViewController.swift
//  PhotoMaster
//
//  Created by Yoshito Usui on 2024/05/09.
//

import UIKit

class ViewController: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    @IBOutlet var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func presentPickerController(sourceTyoe:UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(sourceTyoe){
            let picker = UIImagePickerController()
            picker.sourceType = sourceTyoe
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
        self.dismiss(animated: true, completion: nil)
        
        let image = info[.originalImage] as! UIImage
        let size = CGSize(width: image.size.width/8, height: image.size.height/8)
        let resizedImage = UIGraphicsImageRenderer(size: size).image{ _ in
            image.draw(in: CGRect(origin: .zero, size: size))
            photoImageView.image = image
        }
    }
    
    @IBAction func onTappedCameraButton (){
        presentPickerController(sourceTyoe: .camera)
    }
    
    @IBAction func onTappedAlbumButtonn(){
        presentPickerController(sourceTyoe: .photoLibrary)
    }
    
    @IBAction func onTappedTextButton(){
        if photoImageView.image != nil{
            photoImageView.image = drawText(image: photoImageView.image!)
        }else{
            print("画像がありません")
        }
    }
    
    @IBAction func onTappedIllustButton(){
        if photoImageView.image != nil{
            photoImageView.image = drawMaskImage(image: photoImageView.image!)
        }else{
            print("画像がありません")
        }
    }
    
    @IBAction func onTappedUploadButton(){
        if photoImageView.image != nil{
            let activityVC = UIActivityViewController(activityItems:[photoImageView.image!,"#PhotoMaster"],
                                                      applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }else{
              print("画像がありません")
            }
        }
    }
    
    func drawText(image: UIImage) -> UIImage{
        let text = "LifeisTech!"
        
        let textFontAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 120)!,
            NSAttributedString.Key.foregroundColor: UIColor.red
        ]
        
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        let margin: CGFloat = 5.0
        let textRect = CGRect(x: margin, y: margin, width: image.size.width - margin, height: image.size.height - margin)
        
        text.draw(in: textRect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
func drawMaskImage(image: UIImage) -> UIImage{
    let maskImage = UIImage(named: "furo_ducky")!
    UIGraphicsBeginImageContext(image.size)
    
    image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
    
    let margin: CGFloat = 50.0
    let maskRect = CGRect(x: image.size.width - maskImage.size.width - margin, y: image.size.height - maskImage.size.height, width: maskImage.size.width, height: maskImage.size.height)
    
    maskImage.draw(in: maskRect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return newImage!
}

