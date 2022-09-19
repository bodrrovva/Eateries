//
//  NewRests.swift
//  Eateries
//
//  Created by admin on 22.04.2022.
//

import UIKit

class NewRests: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: @IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //MARK: SaveButton
    //сохраняем данные
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        //проверка на пустоту
        if nameTextField.text == "" || addressTextField.text == "" || typeTextField.text == "" {
        } else {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext  {
                let restaurant = Restaurant(context: context)
                restaurant.name = nameTextField.text
                restaurant.location = addressTextField.text
                restaurant.type = typeTextField.text
                if let image = imageView.image{
                    restaurant.image = image.pngData() as NSData? as Data?
                }
                restaurant.favorite = false
            }
            //переход на основной экран
            performSegue(withIdentifier: "unwindSegueNewRest", sender: self)
        }
    }

    //MARK: ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: AlertController
    //alert с выбором источника фото
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //нажатие на первую ячейку
        if indexPath.row == 0 {
            let alertController = UIAlertController(title: "Источник фото", message: nil, preferredStyle: .actionSheet)
            //камера
            let cameraAction = UIAlertAction(title: "Камера", style: .default, handler: { action in
                self.chooseImagePickerAction(source: .camera) })
            //галерея
            let photoLibAction = UIAlertAction(title: "Фото", style: .default, handler:{ action in
                self.chooseImagePickerAction(source: .photoLibrary) })
            //отмена
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)

            alertController.addAction(cameraAction)
            alertController.addAction(photoLibAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        //снимает выделение с ячейки
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: ImagePicker
    //заменяем заглушку на выбранное фото
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        imageView.contentMode = .scaleToFill
        //все, что выходит за рамки будет обрезано
        imageView.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }

    //MARK: ChooseImagePickerAction
    func chooseImagePickerAction(source: UIImagePickerController.SourceType) {
        //проверяем доступен ли источник фото
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            //разрешаем изменять фото(обрезать)
            imagePicker.allowsEditing = true
            //передаем тип источника(камера или галлерея)
            imagePicker.sourceType = source
            //отображаем
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}
