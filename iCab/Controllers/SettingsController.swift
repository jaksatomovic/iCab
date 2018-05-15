//
//  SettingsController.swift
//  iCab
//
//  Created by Jaksa Tomovic on 10/05/2018.
//  Copyright © 2018 Jakša Tomović. All rights reserved.
//

import UIKit
import AHKActionSheet

class SettingsController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let cellID = "cellID"
    
    let userDefaults = UserDefaults.groupUserDefaults()
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.allowsSelection = true
        return tv
    }()
    
    var nameText: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .right
        tf.textColor = .lightGray
        return tf
    }()
    
    var ageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .lightGray
        label.isUserInteractionEnabled = false
        return label
    }()
    
    var registrationText: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .right
        tf.textColor = .lightGray
        return tf
    }()
    
    var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25
        iv.backgroundColor = .gray
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        tableView.fillSuperview()
        
        for element in [nameText, registrationText] {
            element.inputAccessoryView = Globals.numericToolbar(element,
                                                                selector: #selector(UIResponder.resignFirstResponder),
                                                                barColor: .palette_main,
                                                                textColor: .white)
        }
        
        updateUI()
        
    }
    
    func updateUI() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let suffix = " "
        
        nameText.text = numberFormatter.string(for: userDefaults.double(forKey: Constants.General.name.key()))! + suffix
        ageLabel.text = numberFormatter.string(for: userDefaults.double(forKey: Constants.General.age.key()))! + suffix
        registrationText.text = numberFormatter.string(for: userDefaults.double(forKey: Constants.General.registration.key()))! + suffix

        let data = userDefaults.object(forKey: Constants.General.avatar.key()) as! NSData
        avatarImageView.image = UIImage(data: data as Data)

    }
    
    func handleSelectPhoto() {
        print("Trying to select photo...")
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            avatarImageView.image = editedImage
            let image = editedImage
            let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
            userDefaults.set(imageData, forKey: Constants.General.avatar.key())
            
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatarImageView.image = originalImage
            let image = originalImage
            let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
            userDefaults.set(imageData, forKey: Constants.General.avatar.key())
        }
        
        dismiss(animated: true, completion: nil)
        
    }

}

extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "User info"
        } else if section == 1 {
            return "User Photo"
        } else {
            return "App Developer"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 60
        } else {
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
                cell.addSubview(nameText)
                nameText.anchor(cell.topAnchor, left: nil, bottom: cell.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 100, heightConstant: 0)
//                cell.textLabel?.text = NSLocalizedString("gulp.small", comment: "")
                cell.textLabel?.text = "Name:"
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
                cell.addSubview(ageLabel)
                ageLabel.anchor(cell.topAnchor, left: nil, bottom: cell.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 100, heightConstant: 0)
                cell.textLabel?.text = "Age: "
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
                cell.addSubview(registrationText)
                registrationText.anchor(cell.topAnchor, left: nil, bottom: cell.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 100, heightConstant: 0)
                cell.textLabel?.text = "Registration plate:"
                return cell
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            cell.addSubview(avatarImageView)
            avatarImageView.anchor(cell.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 50, heightConstant: 50)
            cell.textLabel?.text = "Change avatar:"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            cell.textLabel?.text = "Jakša Tomović"
            return cell
        }
    }
    
}

extension SettingsController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var actionSheet: AHKActionSheet?
        if ((indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 1) {
            actionSheet = AHKActionSheet(title: "Age") //NSLocalizedString("from:", comment: "")
            for index in 18...60 {
                actionSheet?.addButton(withTitle: "\(index) years", type: .default) { _ in
                    self.updateSetting(Constants.General.age.key(), value: index)
                }
            }
        }
        if ((indexPath as NSIndexPath).section == 1) {
            handleSelectPhoto()
        }
        actionSheet?.show()
    }
    
    func updateSetting(_ key: String, value: Int) {
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
        updateUI()
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == nameText) {
            storeText(nameText, toKey: Constants.General.name.key())
        }
        if (textField == registrationText) {
            storeText(registrationText, toKey: Constants.General.registration.key())
        }
    }
    
    func storeText(_ textField: UITextField, toKey key: String) {
        guard let text = textField.text else {
            return
        }
        let number = numberFormatter.number(from: text) as? Double
        userDefaults.set(number ?? 0.0, forKey: key)
        userDefaults.synchronize()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return Globals.numericTextField(textField, shouldChangeCharactersInRange: range, replacementString: string)
    }
}

