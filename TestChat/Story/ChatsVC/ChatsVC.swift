//
//  ChatsVC.swift
//  TestChat
//
//  Created by Матвей Чернышев on 30.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MessageKit
import InputBarAccessoryView

final class ChatsVC: MessagesViewController {
	
	init(user: MUser, chat: MChat) {
		self.user = user
		self.chat = chat
		super.init(nibName: nil, bundle: nil)
		
		title = chat.friendUserName
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		messagesListener?.remove()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		
		if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
			layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
			layout.textMessageSizeCalculator.incomingAvatarSize = .zero
			layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
			layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
		}
		
		messagesListener = ListenerService.shared.messagesObserve(chat: chat, comletion: { result in
			
			switch result {
			case .success(var message):
				if let url = message.downloadURL {
					StorageService.shared.downloadImage(url: url) { [weak self] result in
						guard let self = self else { return }
						
						switch result {
						case .success(let image):
							message.image = image
							self.insertNewMessage(message: message)
							
						case .failure(let error):
							self.showAlert(message: error.localizedDescription)
						}
					}
				} else {
					self.insertNewMessage(message: message)
				}
				
			case .failure(let error):
				self.showAlert(message: error.localizedDescription)
			}
		})
	}
	
	private let user: MUser
	private let chat: MChat
	private var messages: [Message] = []
	private var messagesListener: ListenerRegistration?
}

extension ChatsVC: MessagesDataSource {
	
	func currentSender() -> SenderType {
		return Sender(senderId: user.id, displayName: user.avatarStringURL)
	}
	
	func messageForItem(
		at indexPath: IndexPath,
		in messagesCollectionView: MessagesCollectionView
	) -> MessageType {
		return messages[indexPath.item]
	}
	
	func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
		return 1
	}
	
	func numberOfItems(
		inSection section: Int,
		in messagesCollectionView: MessagesCollectionView
	) -> Int {
		return messages.count
	}
	
	func cellTopLabelAttributedText(
		for message: MessageType,
		at indexPath: IndexPath
	) -> NSAttributedString? {
		
		if indexPath.item % 4 == 0 {
			return NSAttributedString(
				string: MessageKitDateFormatter.shared.string(from: message.sentDate),
				attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
							 NSAttributedString.Key.foregroundColor: UIColor.darkGray])
		}
		return nil
	}
}

extension ChatsVC: MessagesLayoutDelegate {
	func footerViewSize(
		for section: Int,
		in messagesCollectionView: MessagesCollectionView
	) -> CGSize {
		return CGSize(width: 0, height: 0)
	}
	
	func cellTopLabelHeight(
		for message: MessageType,
		at indexPath: IndexPath,
		in messagesCollectionView: MessagesCollectionView
	) -> CGFloat {
		if indexPath.item % 4 == 0 {
			return 30
		}
		return 0
	}
}

extension ChatsVC: MessagesDisplayDelegate {
	
	func backgroundColor(
		for message: MessageType,
		at indexPath: IndexPath,
		in messagesCollectionView: MessagesCollectionView
	) -> UIColor {
		return isFromCurrentSender(message: message) ? .white : #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1)
	}
	
	func textColor(
		for message: MessageType,
		at indexPath: IndexPath,
		in messagesCollectionView: MessagesCollectionView
	) -> UIColor {
		return isFromCurrentSender(message: message) ? #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2392156863, alpha: 1) : .white
	}
	
	func configureAvatarView(
		_ avatarView: AvatarView,
		for message: MessageType,
		at indexPath: IndexPath,
		in messagesCollectionView: MessagesCollectionView
	) {
		avatarView.isHidden = true
	}
	
	func avatarSize(
		for message: MessageType,
		at indexPath: IndexPath,
		in messagesCollectionView: MessagesCollectionView
	) -> CGSize {
		return .zero
	}
	
	func messageStyle(
		for message: MessageType,
		at indexPath: IndexPath,
		in messagesCollectionView: MessagesCollectionView
	) -> MessageStyle {
		return .bubble
	}
}

extension ChatsVC: InputBarAccessoryViewDelegate {
	func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
		let message = Message(user: user, content: text)
		FirestoreService.shared.sentMessages(chat: chat, message: message) { result in
			
			switch result {
			case .success():
				self.messagesCollectionView.scrollToBottom()
				
			case .failure(let error):
				self.showAlert(message: error.localizedDescription)
			}
		}
		inputBar.inputTextView.text = ""
	}
}

extension ChatsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(
		_ picker: UIImagePickerController,
		didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
	) {
		picker.dismiss(animated: true, completion: nil)
		guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
		sendImage(image: image)
	}
}

private extension ChatsVC {
	
	func sendImage(image: UIImage) {
		StorageService.shared.uploadImageMessage(photo: image, chat: chat) { result in
			
			switch result {
			case .success(let url):
				var message = Message(user: self.user, image: image)
				message.downloadURL = url
				FirestoreService.shared.sentMessages(chat: self.chat, message: message) { result in
					
					switch result {
					case .success():
						self.messagesCollectionView.scrollToBottom()
						
					case .failure(_):
						self.showAlert(message: "Image was not delivered")
					}
				}
				
			case .failure(let error):
				self.showAlert(message: error.localizedDescription)
			}
		}
	}
	
	func insertNewMessage(message: Message) {
		guard !messages.contains(message) else { return }
		messages.append(message)
		messages.sort()
		
		let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
		let shouldScrollBottom = messagesCollectionView.isAtBottom && isLatestMessage
		
		messagesCollectionView.reloadData()
		
		if shouldScrollBottom {
			DispatchQueue.main.async {  [weak self] in
				self?.messagesCollectionView.scrollToBottom(animated: true)
			}
		}
	}
	
	@objc func cameraButtonPressed() {
		let picker = UIImagePickerController()
		picker.delegate = self
		
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			picker.sourceType = .camera
		} else {
			picker.sourceType = .photoLibrary
		}
		
		present(picker, animated: true, completion: nil)
	}
	
	func setupUI() {
		let cameraItem = InputBarButtonItem(type: .system)
		let cameraImage = UIImage(systemIcon: .camera)
		
		cameraItem.tintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
		cameraItem.image = cameraImage
		cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
		cameraItem.addTarget(self, action: #selector(cameraButtonPressed), for: .primaryActionTriggered)
		
		messageInputBar.sendButton.setImage(UIImage(named: "Sent"), for: .normal)
		messageInputBar.sendButton.applyGradients(cornerRadius: 10)
		messageInputBar.setRightStackViewWidthConstant(to: 56, animated: false)
		messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 6, right: 30)
		messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: false)
		messageInputBar.middleContentViewPadding.right = -38
		
		messageInputBar.isTranslucent = true
		messageInputBar.separatorLine.isHidden = true
		messageInputBar.backgroundView.backgroundColor = .mainWhite()
		messageInputBar.inputTextView.backgroundColor = .white
		
		messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
		messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 30, bottom: 14, right: 36)
		messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 36, bottom: 14, right: 36)
		messageInputBar.inputTextView.layer.borderColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 0.4033635232)
		messageInputBar.inputTextView.layer.borderWidth = 0.2
		messageInputBar.inputTextView.layer.cornerRadius = 18.0
		messageInputBar.inputTextView.layer.masksToBounds = true
		messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
		
		messageInputBar.leftStackView.alignment = .center
		messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
		
		messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
		messageInputBar.delegate = self
		
		messageInputBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		messageInputBar.layer.shadowRadius = 5
		messageInputBar.layer.shadowOpacity = 0.3
		messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 4)
		
		messagesCollectionView.backgroundColor = .mainWhite()
		messagesCollectionView.messagesDataSource = self
		messagesCollectionView.messagesLayoutDelegate = self
		messagesCollectionView.messagesDisplayDelegate = self
	}
}
