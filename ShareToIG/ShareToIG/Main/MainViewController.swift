//
//  MainViewController.swift
//  ShareToIG
//
//  Created by 바보세림이 on 2020/09/06.
//  Copyright (c) 2020 serim. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SnapKit

protocol MainDisplayLogic: class {
    func displaySomething(viewModel: Main.Something.ViewModel)
}

class MainViewController: UIViewController, MainDisplayLogic {
    var interactor: MainBusinessLogic?
    var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
        setViews()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    let imageView = UIImageView()
    let shareButton = UIButton()
    
    func doSomething() {
        let request = Main.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: Main.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
    
    private func setViews() {
        setImageView()
        setShareButton()
    }
    
    private func setImageView() {
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.gray
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(250)
            $0.height.equalTo(350)
        }
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker)))
    }
    
    private func setShareButton() {
        self.view.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.backgroundColor = UIColor.blue
        shareButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.width.equalTo(250)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func imagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
}
