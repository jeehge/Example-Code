//
//  ViewController.swift
//  VisionStudyProject
//
//  Created by JH on 2021/02/17.
//

import UIKit
import Vision
import VisionKit

final class ViewController: UIViewController {
	// MARK: - Properties
	@IBOutlet private weak var imageView: UIImageView!
	@IBOutlet private weak var textView: UITextView!
	
	private var textRequest = VNRecognizeTextRequest(completionHandler: nil)
	private let scannerQueue = DispatchQueue(label: "MyVisionScannerQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		textView.isEditable = false
		setupVision()
	}
	
	private func setupVision() {
		// 이미지에서 텍스트를 찾고 인식하는 이미지 분석 요청
		textRequest = VNRecognizeTextRequest { (request, error) in
			guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

			var detectedText = ""
			for observation in observations {
				guard let topCandidate = observation.topCandidates(1).first else { return }
				// 카드 번호 정규식
				let creditCardPattern = #"\d{4} \d{4} \d{4} \d{4}"#
				// 카드 날짜 정규식
				let datePattern = #"\d{2}/\d{2}"#
				
				let text = topCandidate.string
				let creditCardNumber = text.getArrayAfterRegex(regex: creditCardPattern)
				let creditCardDate = text.getArrayAfterRegex(regex: datePattern)
				
				if let cardNumber = creditCardNumber.first,
				   let cardDate = creditCardDate.first {
					detectedText += cardNumber
					detectedText += "\n"
					detectedText += cardDate
				}
			}
			DispatchQueue.main.async { [weak self] in
				guard let self = self else { return }
				self.textView.text = detectedText
				self.textView.flashScrollIndicators()
			}
		}

		textRequest.recognitionLevel = .accurate
	}
	
	private func processImage(_ image: UIImage) {
		imageView.image = image
		recognizeTextInImage(image)
	}
	
	private func recognizeTextInImage(_ image: UIImage) {
		guard let cgImage = image.cgImage else { return }
		
		textView.text = ""
		scannerQueue.async {
			let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
			do {
				try requestHandler.perform([self.textRequest])
			} catch {
				print(error)
			}
		}
	}

	// MARK: - IBAction
	@IBAction private func tapped(scan button: UIButton) {
		let scannerViewController = VNDocumentCameraViewController()
		scannerViewController.delegate = self
		present(scannerViewController, animated: true)
	}
}

extension ViewController: VNDocumentCameraViewControllerDelegate {
	// 카메라에서 스캔 한 문서를 성공적으로 저장했음 알림
	func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
		guard scan.pageCount >= 1 else {
			controller.dismiss(animated: true)
			return
		}
		
		let originalImage = scan.imageOfPage(at: 0)
		let newImage = compressedImage(originalImage)
		controller.dismiss(animated: true)
		
		processImage(newImage)
	}
	
	// 카메라 뷰 컨트롤러가 활성화 된 동안 문서 스캔이 실패했음 알림
	func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
		print(error)
		controller.dismiss(animated: true)
	}
	
	// 카메라에서 취소했음 알림
	func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
		controller.dismiss(animated: true)
	}

	func compressedImage(_ originalImage: UIImage) -> UIImage {
		guard let imageData = originalImage.jpegData(compressionQuality: 1),
			  let reloadedImage = UIImage(data: imageData) else {
			return originalImage
		}
		return reloadedImage
	}
}
