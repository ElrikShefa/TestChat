//
//  Point.swift
//  TestChat
//
//  Created by Матвей Чернышев on 14.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//
import UIKit

enum Point {
	
	case topLeading
	case leading
	case bottomLeading
	case top
	case center
	case bottom
	case topTrailing
	case trailing
	case bottomTrailing
}

extension Point {
	
	var point: CGPoint {
		switch self {
		case .topLeading:
			return CGPoint(x: 0, y: 0)
		case .leading:
			return CGPoint(x: 0, y: 0.5)
		case .bottomLeading:
			return CGPoint(x: 0, y: 1.0)
		case .top:
			return CGPoint(x: 0.5, y: 0)
		case .center:
			return CGPoint(x: 0.5, y: 0.5)
		case .bottom:
			return CGPoint(x: 0.5, y: 1.0)
		case .topTrailing:
			return CGPoint(x: 1.0, y: 0.0)
		case .trailing:
			return CGPoint(x: 1.0, y: 0.5)
		case .bottomTrailing:
			return CGPoint(x: 1.0, y: 1.0)
		}
	}
}
