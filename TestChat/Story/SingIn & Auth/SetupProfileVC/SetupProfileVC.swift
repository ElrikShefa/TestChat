//
//  SetupProfileVC.swift
//  TestChat
//
//  Created by Матвей Чернышев on 10.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage

final class SetupProfileVC: BaseVC {
	
	init(currentUser: User) {
		self.currentUser = currentUser
		super.init(nibName: nil, bundle: nil)
		
		if let username = currentUser.displayName {
			fullNameTextField.text = username
		}
		
		if let photoURL = currentUser.photoURL {
			fullImageView.circleImageView.sd_setImage(with: photoURL, completed: nil)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	private let currentUser: User
	
	private lazy var fullImageView = AddPhotoView()
	
	private lazy var welcomeLabel = UILabel(text: "Set up profile", font: .avenir20())
	private lazy var fullNameLabel = UILabel(text: "Full name")
	private lazy var aboutMeLabel = UILabel(text: "About me")
	private lazy var sexLabel = UILabel(text: "Sex")
	
	private lazy var fullNameTextField = OneLineTextField(font: .avenir20())
	private lazy var aboutMeTextField = OneLineTextField(font: .avenir20())
	
	private lazy var sexSegmentedControl = UISegmentedControl(first: "Male", second: "Femail")
	
	private lazy var goToChatsButton = UIButton(
		title: "Go to chats!", titleColor: .white, backgroundColor: .buttonDark(), isShadow: true
	)
}

private	extension SetupProfileVC {
	
	@objc func goToChatsButtonTapped() {
		FirestoreService.shared.saveProfileWith(
			id: currentUser.uid,
			email: currentUser.email!,
			username: fullNameTextField.text,
			avatarImage: fullImageView.circleImageView.image,
			description: aboutMeTextField.text,
			sex: sexSegmentedControl.titleForSegment(
				at: sexSegmentedControl.selectedSegmentIndex)
		) { (result) in switch result {
			
		case .success(let user):
			self.showAlert(message: "Save Data", title: "Succes") {
				self.present(MainTBC(currentUser: user), animated: true, completion: nil)
			}
			
		case .failure(let error):
			self.showAlert(message: error.localizedDescription, title: "Error!")
			}
		}
	}
	
	@objc func plusButtonTapped() {
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		imagePickerController.sourceType = .photoLibrary
		present(imagePickerController, animated: true, completion: nil)
	}
	
	func setupUI() {
		goToChatsButton.addTarget(self, action: #selector(goToChatsButtonTapped), for: .touchUpInside)
		fullImageView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
		
		
		let fullStackView = UIStackView(arranged: [fullNameLabel, fullNameTextField])
		let aboutMeStackView = UIStackView(arranged: [aboutMeLabel, aboutMeTextField])
		let sexStackView = UIStackView(arranged: [sexLabel, sexSegmentedControl], spacing: 12)
		
		let stackView = UIStackView(
			arranged: [ fullStackView,
						aboutMeStackView,
						sexStackView,
						goToChatsButton ],
			spacing: 40)
		
		view.backgroundColor = .white
		
		fullImageView.translatesAutoresizingMaskIntoConstraints = false
		welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(welcomeLabel)
		view.addSubview(fullImageView)
		view.addSubview(stackView)
		
		NSLayoutConstraint.activate([
			welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
			welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			fullImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
			fullImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			stackView.topAnchor.constraint(equalTo: fullImageView.bottomAnchor, constant: 40),
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
			
			goToChatsButton.heightAnchor.constraint(equalToConstant: 60)
		])
	}
}

extension SetupProfileVC: UINavigationControllerDelegate {}

extension SetupProfileVC: UIImagePickerControllerDelegate {
	
	func imagePickerController(
		_ picker: UIImagePickerController,
		didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
	) {
		
		picker.dismiss(animated: true, completion: nil)
		guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
			return
		}
		fullImageView.circleImageView.image = image
	}
}
