//
//  OnboardingVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/20.
//

import UIKit
import SnapKit

final class OnboardingVC: UIViewController {

    lazy var nextButton: CustomButton = {
       let button = CustomButton()
        button.buttonStatus = .fill
        button.setTitle("시작하기", for: .normal)
        
        return button
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
       
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.decelerationRate = .fast
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        
        return collectionView
    }()
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.CustomColor.gray5
        pageControl.currentPageIndicatorTintColor = UIColor.CustomColor.black
        pageControl.isEnabled = false
        
        return pageControl
    }()
    var slides: [OnboardingSlide] = []
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setUpOnboardSlide()
        setUpConstraints()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        [nextButton, collectionView, pageControl].forEach {
            view.addSubview($0)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        nextButton.addTarget(self, action: #selector(clickedNextBtn), for: .touchUpInside)
    }

    private func setUpOnboardSlide() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        paragraphStyle.alignment = .center
        
        let firstOnboardingAttributedString = NSMutableAttributedString(string: "위치 기반으로 빠르게\n주위 친구를 확인")
        firstOnboardingAttributedString.addAttributes([.foregroundColor: UIColor.CustomColor.green,
                                                       .kern: -0.5,
                                                       .paragraphStyle: paragraphStyle
                                                      ],
                                                      range: NSRange(location: 0, length: 5))
        
        let secondOnboardingAttributedString = NSMutableAttributedString(string: "관심사가 같은 친구를\n찾을 수 있어요")
        secondOnboardingAttributedString.addAttributes([.foregroundColor: UIColor.CustomColor.green,
                                                       .kern: -0.5,
                                                       .paragraphStyle: paragraphStyle
                                                      ],
                                                      range: NSRange(location: 0, length: 10))
        
        let thirdOnboardingAttributedString = NSMutableAttributedString(string: "SeSAC Friends")
        
        slides = [
            OnboardingSlide(titleText: firstOnboardingAttributedString, imageName: R.image.onboardingImg1.name),
            OnboardingSlide(titleText: secondOnboardingAttributedString, imageName: R.image.onboardingImg2.name),
            OnboardingSlide(titleText: thirdOnboardingAttributedString, imageName: R.image.onboardingImg3.name)
        ]
    }

   @objc func clickedNextBtn(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            DispatchQueue.main.async {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                windowScene.windows.first?.rootViewController = SMSAuthVC()
                windowScene.windows.first?.makeKeyAndVisible()
            }
        }
        else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }

    }
    
    private func setUpConstraints() {
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.bottom.equalTo(nextButton.snp.top).offset(-42)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top).offset(-56)
        }
    }

}

extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as? OnboardingCollectionViewCell else { return UICollectionViewCell() }

        cell.setup(slides[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
    
}
