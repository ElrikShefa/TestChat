//
//  ImageItem.swift
//  TestChat
//
//  Created by Матвей Чернышев on 02.07.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import MessageKit

struct  ImageItem: MediaItem {
	
	var url: URL?
	var image: UIImage?
	var placeholderImage: UIImage
	var size: CGSize
}
