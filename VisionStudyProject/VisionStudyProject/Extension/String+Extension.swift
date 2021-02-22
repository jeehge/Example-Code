//
//  String+Extension.swift
//  VisionStudyProject
//
//  Created by JH on 2021/02/22.
//

import UIKit

extension String {
	func getArrayAfterRegex(regex: String) -> [String] {
		do {
			let regex = try NSRegularExpression(pattern: regex)
			let results = regex.matches(in: self,
										range: NSRange(self.startIndex..., in: self))
			return results.map {
				String(self[Range($0.range, in: self)!])
			}
		} catch let error {
			print("invalid regex: \(error.localizedDescription)")
			return []
		}
	}
}
