//
//  ViewController.swift
//  4Kick_CompactController
//
//  Created by Нечаев Михаил on 13.02.2024.
//

import UIKit

class ContentViewController: UIViewController {
            
    lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.insertSegment(withTitle: "280pt", at: 0, animated: false)
        segmentControl.insertSegment(withTitle: "150pt", at: 1, animated: false)
        segmentControl.addTarget(self, action: #selector(changeSegment), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    let closeButton: UIButton = {
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        closeButton.tintColor = .systemGray2
        return closeButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchDown)
        view.addSubview(segmentControl)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        segmentControl.sizeToFit()
        segmentControl.frame = CGRect(
            x: view.frame.width / 2 - segmentControl.frame.width / 2,
            y: 32,
            width: segmentControl.frame.width,
            height: segmentControl.frame.height
        )
        closeButton.frame = CGRect(x: view.frame.width - 16 - 32, y: 32, width: 32, height: 32)
    }
    
    @objc
    func changeSegment() {
        preferredContentSize = CGSize(width: 300, height: segmentControl.selectedSegmentIndex == 0 ? 280 : 150)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func closeAction() {
        dismiss(animated: true)
    }
    
}

class MainView: UIView {
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        button.setTitleColor(tintAdjustmentMode == .dimmed ? .systemGray5 : .systemBlue, for: .normal)
    }
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Present", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {
    
    let contentView = MainView()
    
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.button.addTarget(self, action: #selector(presentAction), for: .touchDown)
    }
    
    private var popover: ContentViewController?

    @objc
    func presentAction() {
        let popover = ContentViewController()
        self.popover = popover
        popover.preferredContentSize = CGSize(width: 300, height: 280)
        popover.modalPresentationStyle = .popover
        popover.popoverPresentationController?.delegate = self
        popover.popoverPresentationController?.permittedArrowDirections = .up
        popover.popoverPresentationController?.sourceView = contentView.button
        self.present(popover, animated: false, completion: {
            popover.view.superview?.layer.cornerRadius = 8.0
        })
    }

}

extension ViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
    
}
