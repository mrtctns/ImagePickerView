import Foundation
import UIKit

public final class ImagePickerView: UIImageView {
    // MARK: - Properties -
    private var placeholderImage: UIImage?
    private var color: UIColor?
    public var onImagePicked: ((UIImage) -> Void)?
    public init(placeholderImage: UIImage? = nil, color: UIColor? = .clear) {
        self.placeholderImage = placeholderImage
        self.color = color
        super.init(frame: .zero)
        setupTapGestureRecognizer()
        configuration()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        setupTapGestureRecognizer()
    }

    func configuration() {
        image = placeholderImage ?? nil
        backgroundColor = color
    }

    private func setupTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGestureRecognizer)
    }

    public func showImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary

        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
            DispatchQueue.main.async {
                topViewController.present(imagePickerController, animated: true, completion: nil)
            }
        }
    }

    @objc public func imageViewTapped() {
        showImagePicker()
    }
}

extension ImagePickerView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = selectedImage
            onImagePicked?(selectedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
