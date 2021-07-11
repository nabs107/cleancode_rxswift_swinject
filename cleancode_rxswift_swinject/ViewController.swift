//
//  ViewController.swift
//  cleancode_rxswift_swinject
//
//  Created by Nabin Shrestha on 7/10/21.
//

import UIKit
import LBTATools
import RxSwift

final class ViewController: UIViewController {
    
    private final let disposeBag: DisposeBag = DisposeBag()
    
    private var nationalityViewModel: NationalityViewModel!
    private var profileViewModel: ProfileViewModel!
    
    lazy var containerView: UIView = UIView()
    
    lazy var nationalityNameLabel: UILabel = UILabel(text: "N/A", font: .systemFont(ofSize: 24), textColor: .systemBlue, textAlignment: .center, numberOfLines: 1)
    
    lazy var fetchProfileButton: UIButton = {
        let button = UIButton(title: "Fetch Profile", titleColor: .white, font: .boldSystemFont(ofSize: 16), backgroundColor: .blue, target: self, action: #selector(fetchProfileButtonTapped))
        button.layer.cornerRadius = 12
        button.constrainHeight(45)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        nationalityViewModel = container.resolve(NationalityViewModel.self)!
//        nationalityViewModel.getNationalities()
        
        profileViewModel = container.resolve(ProfileViewModel.self)!
        
        view.addSubview(containerView)
        containerView.fillSuperviewSafeAreaLayoutGuide()
        
        containerView.stack(
            UIView(),
            fetchProfileButton
        ).padLeft(20).padRight(20).padBottom(20)
        
        containerView.addSubview(nationalityNameLabel)
        nationalityNameLabel.centerInSuperview()
        
        profileViewModel.profile
            .asDriverOnErrorJustComplete()
            .drive(onNext: {
                self.nationalityNameLabel.text = $0.nationalityName ?? ""
            }).disposed(by: disposeBag)
    }
    
    @objc
    func fetchProfileButtonTapped() {
        profileViewModel.getProfile()
    }
}
