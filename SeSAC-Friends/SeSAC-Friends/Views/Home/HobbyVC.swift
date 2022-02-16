//
//  HobbyVC.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/10.
//

import CoreLocation
import UIKit

import SnapKit

final class HobbyVC: UIViewController {

    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private var selected: [String] = []
    private var titles: [String] = []
    
    var recommendHobby: [String]?
    var userHobby: [String]?
    private var myHobby: [String] = []
    lazy var findButton: CustomButton = CustomButton(text: "새싹 찾기")
    var originButtonPosition: CGFloat = 0
    var requestLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDefault()
        modelSetting()
        configureCollectionView()
        setUpLayout()
        configureKeyboardNoti()
    }
    
    private func configureDefault() {
        view.backgroundColor = .systemBackground
        view.addSubview(findButton)
        findButton.buttonStatus = .fill
        findButton.addTarget(self, action: #selector(findTapped), for: .touchUpInside)
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width - 28, height: 0))
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        searchBar.autocorrectionType = .no
        searchBar.searchTextField.delegate = self
        searchBar.searchTextField.autocorrectionType = .no
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)

        //let searchController = UISearchController(searchResultsController: nil)
        //searchController.searchBar.frame = CGRect(x: 0, y: 0, width: width - 28, height: 0)
        //searchController.searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        //searchController.obscuresBackgroundDuringPresentation = false
//        self.navigationItem.searchController = searchController
//
//        self.navigationItem.hidesSearchBarWhenScrolling = false // 스크롤 도중에도 검색바 보이기 옵션
//        self.navigationItem.searchController?.searchResultsUpdater = self // 검색업데이트 델리게이트설정
//        self.navigationItem.searchController?.searchBar.searchTextField.delegate = self
//
//        //self.navigationItem.searchController?.searchBar.searchTextField.autocorrectionType = .no
//        self.navigationItem.searchController?.searchBar.autocorrectionType = .no
    }
    
    private func configureKeyboardNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func textViewMoveUp(_ notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            UIView.animate(withDuration: 0.1, animations: {
                
                let findChangePosition = (self.view.frame.maxY - self.view.safeAreaLayoutGuide.layoutFrame.maxY) - keyboardSize.height
                self.findButton.snp.remakeConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(findChangePosition)
                    make.height.equalTo(44)
                    make.width.equalToSuperview()
                }
            })
        }
        
    }
    @objc func textViewMoveDown(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.1, animations: {
            self.findButton.snp.remakeConstraints { make in
                make.height.equalTo(48)
                make.width.equalToSuperview().multipliedBy(0.9)
                make.centerX.equalToSuperview()
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
        })
    }
    
    private func modelSetting() {
        guard let recommendHobby = recommendHobby,
                let userHobby = userHobby else {
            return
        }
        titles += recommendHobby
        titles += userHobby
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "TagCollectionViewCell")
        collectionView.register(TagCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TagCollectionReusableView")
        
        let layout = TagFlowLayout()
        layout.estimatedItemSize = CGSize(width: 140, height: 40)
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.isScrollEnabled = true
        collectionView.keyboardDismissMode = .onDrag // .interactive, .onDrag 차이점
    }
    
    private func setUpLayout() {
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(findButton.snp.top)
        }
        
        findButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func deleteTapped(_ sender: DeleteButton) {
        let indexPath = IndexPath(row: sender.row, section: sender.section)
        guard let cell = collectionView.cellForItem(at: indexPath) as? TagCollectionViewCell,
                let text = cell.recommendLabel.text else { return }
        selected = selected.filter { $0 != text }
        myHobby.remove(at: indexPath.row)
        collectionView.reloadData()
    }
    
    @objc func findTapped() {
        print(recommendHobby)
        print(userHobby)
        guard let requestLocation = requestLocation else {
            return
        }

        
        let queue = Queue(type: 2, region: calculateRegion(region: requestLocation), long: requestLocation.longitude, lat: requestLocation.latitude, hf: myHobby)
        
        HomeService.shared.postQueue(model: queue) { response in
            switch response.response?.statusCode {
            case 200:
                print("성공")
                switch response.result {
                case .success(let response):
                    print("네트워크 리스폰스\(response)")
                    self.navigationController?.pushViewController(FindVC(), animated: true)
                case .failure(let error):
                    print("error: \(error)")
                }
                break
            case 201:
                print("신고가 누적되어 이용하실 수 없습니다.")
                break
            case 203:
                print("약속 취소 패널티로, 1분동안 이용하실 수 없습니다")
                break
            case 204:
                print("약속 취소 패널티로, 2분동안 이용하실 수 없습니다")
                break
            case 205:
                print("약속 취소 패널티로, 3분동안 이용하실 수 없습니다")
                break
            case 206:
                print("새싹 찾기 기능을 이용하기 위해서는 성별이 필요해요!")
                self.tabBarController?.selectedIndex = 3
                break
            case 401:
                print("파이어베이스 토큰만료")
                break
            case 406:
                print("미가입 회원입니다.")
                break
            case 500:
                print("서버에러")
                break
            case 501:
                print("클라이언트에러")
                break
            default:
                print("에러")
                break
            }
        }
    }
    
    private func calculateRegion(region: CLLocationCoordinate2D) -> Int {
        let regionLatitude = region.latitude + 90
        let regionLongtitude = region.longitude + 180
        
        let removeDotLatitude = String(regionLatitude).replacingOccurrences(of: ".", with: "")
        let removeDotLongtitue = String(regionLongtitude).replacingOccurrences(of: ".", with: "")
        
        return Int((removeDotLatitude.prefix(5) + removeDotLongtitue.prefix(5)))!
    }
}

// MARK: - CollectionView
extension HobbyVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? titles.count : myHobby.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell",
                                                            for: indexPath) as? TagCollectionViewCell else {
            return TagCollectionViewCell()
        }
        
        
        if indexPath.section == 1 {
            cell.deleteButton.isHidden = false
            cell.deleteButton.row = indexPath.row
            cell.deleteButton.section = indexPath.section
            cell.deleteButton.addTarget(self, action:#selector(deleteTapped(_:)), for: .touchUpInside)
            
            cell.recommendLabel.text = myHobby[indexPath.row]
            cell.recommendLabel.preferredMaxLayoutWidth = collectionView.frame.width - 16
        } else {
            cell.recommendLabel.text = titles[indexPath.row]
            cell.recommendLabel.preferredMaxLayoutWidth = collectionView.frame.width - 16
        }
        
        if selected.contains(titles[indexPath.row]) {
            cell.backgroundColor = UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)
        } else {
            cell.backgroundColor = .lightGray
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TagCollectionViewCell,
              let text = cell.recommendLabel.text else { return }
        
        if selected.contains(text) {
            selected = selected.filter{ $0 != text }
        } else {
            selected.append(text)
            myHobby.append(text)
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {

            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TagCollectionReusableView", for: indexPath) as? TagCollectionReusableView {
                if indexPath.section == 0 {
                    sectionHeader.tagHeaderLabel.text = "추천"
                } else {
                    sectionHeader.tagHeaderLabel.text = "내가하고싶은"
                }
                return sectionHeader
            }
        }

        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

// MARK: - Helper
extension HobbyVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textField.text else {
            return true
        }
        let texts = text.split(separator: " ").map{ String($0) } //띄어쓰기 자르기
        
        //공백일 경우
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            print("최소 한 자 이상, 최대 8글자까지 작성 가능합니다")
            return true
        }
        // 8개 넘을 경우
        else if myHobby.count + texts.count > 8{
            print("취미를 더 이상 추가할 수 없습니다 (8개)")
            return true
        }
        
        for text in texts {
            //띄어쓰기 글자중 8글자 넘는게 있는지 판단
            if text.count > 8 {
                print("각 취미 최소 한 자 이상, 최대 8글자까지 작성 가능합니다")
                return true
            }
            //띄어쓰기 글자중 이미 있는게 있는지 판단
            else if myHobby.contains(text) {
                print("이미 등록된 취미가 있습니다")
                return true
            }
        }
        
        myHobby += texts
        textField.text = ""
        
        collectionView.reloadData()
        
        return true
    }
}

// MARK: - FlowLayout

class Row {
    var attributes = [UICollectionViewLayoutAttributes]()
    var spacing: CGFloat = 0

    init(spacing: CGFloat) {
        self.spacing = spacing
    }

    func add(attribute: UICollectionViewLayoutAttributes) {
        attributes.append(attribute)
    }

    func tagLayout(collectionViewWidth: CGFloat) {
        let padding = 10
        var offset = padding
        for attribute in attributes {
            attribute.frame.origin.x = CGFloat(offset)
            offset += Int(attribute.frame.width + spacing)
        }
    }
}

class TagFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        var rows = [Row]()
        var currentRowY: CGFloat = -1

        for attribute in attributes {
            if currentRowY != attribute.frame.origin.y {
                currentRowY = attribute.frame.origin.y
                rows.append(Row(spacing: 10))
            }
            rows.last?.add(attribute: attribute)
        }

        rows.forEach {
            $0.tagLayout(collectionViewWidth: collectionView?.frame.width ?? 0)
        }
        return rows.flatMap { $0.attributes }
    }
}

// MARK: - Custom View

class DeleteButton: UIButton {
    var section: Int = 0
    var row : Int = 0
}

class TagCollectionReusableView: UICollectionReusableView {
    lazy var tagHeaderLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .CustomFont.title6R12
        lbl.textColor = .CustomColor.black
        lbl.textAlignment = .left
        
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tagHeaderLabel)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpLayout() {
        tagHeaderLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
