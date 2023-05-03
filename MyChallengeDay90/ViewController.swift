//
//  ViewController.swift
//  MyChallengeDay90
//
//  Created by Георгий Евсеев on 11.12.22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    var arrayImage = [UIImage]()
    var selectedImage: String?
    var topText: String?
    var bottomText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }

    @IBAction func importPicture(_ sender: Any) {
        addNewPerson()
    }

    @IBAction func addTopText(_ sender: Any) {
        addTopText()
    }

    @IBAction func addBottomText(_ sender: Any) {
        addBottomText()
        
    }

    func addTopText() {
        
        let ac = UIAlertController(title: "Text:", message: nil, preferredStyle: .alert)
        ac.addTextField()

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            self!.topText = newName
        })
        present(ac, animated: true)
    }

    func addBottomText() {
        let ac = UIAlertController(title: "Text:", message: nil, preferredStyle: .alert)
        ac.addTextField()

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            self!.bottomText = newName
        })
        present(ac, animated: true)
    }

    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        selectedImage = imageName
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
            imageView.image = image
            arrayImage.append(image)
        }

        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    @objc func drawImagesAndText() {
        let width = (imageView.image?.size.width)!
        let height = (imageView.image?.size.height)!
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))

        let image = renderer.image { _ in
            let picture = imageView.image

            picture!.draw(at: CGPoint(x: 0, y: 0))

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 46), .paragraphStyle: paragraphStyle,
            ]

            let topString = topText

            let topAttributedString = NSAttributedString(string: topString!, attributes: attrs)
            topAttributedString.draw(with: CGRect(x: 12, y: 12, width: 414, height: 148), options: .usesLineFragmentOrigin, context: nil)

            let bottomString = bottomText

            let bottomAttributedString = NSAttributedString(string: bottomString!, attributes: attrs)
            bottomAttributedString.draw(with: CGRect(x: 12, y: height - 58, width: 414, height: 148), options: .usesLineFragmentOrigin, context: nil)
        }

        imageView.image = image
    }
    
    @objc func shareTapped() {
        drawImagesAndText()
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }

        let vc = UIActivityViewController(activityItems: [image, "\(selectedImage!) is the best photo!"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
