//
//  ResultViewController.swift
//  ShoppingAPI
//
//  Created by HDI on 7/27/25.
//

import UIKit
import SnapKit

class ResultViewController: UIViewController {
    
    var shoppingResult : [shopData] = []
    var recommandResult : [String] = []
    var display = 30
    var pageSize = 30
    var count = 1
    var isLoading = false
    var sorted: String
    var searchResult: String
    let indexPath = IndexPath(row: NSNotFound, section: 0)
    
    init(searchResult: String,sorted: String) {
        self.sorted = sorted
        self.searchResult = searchResult
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("스또리보드를 위해 존재하는 코드")
    }
    
    //MARK: Object 선언
    let totalLabel = {
        let totalLabel = UILabel()
        totalLabel.textColor = .green
        totalLabel.font = .systemFont(ofSize: 14)
        return totalLabel
    }()
    let shoppingCollection: UICollectionView = {
        let shoppingCollection = UICollectionViewFlowLayout()
        shoppingCollection.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - (10 * 2), height: 250)
        shoppingCollection.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        shoppingCollection.minimumLineSpacing = 10
        shoppingCollection.minimumInteritemSpacing = 10
        shoppingCollection.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: shoppingCollection)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    let recommandCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        let recommandCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        recommandCollectionView.backgroundColor = .black
        return recommandCollectionView
    }()
    let naviView: UIView = {
        let naviView = UIView()
        naviView.backgroundColor = .black
        return naviView
    }()
    
    let backButton: UIButton = {
        let backButton = UIButton(type: .system)
        backButton.setTitle("<", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        return backButton
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 16)
        return titleLabel
    }()
    
    let accuracyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("정확도", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let dateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("날짜순", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let highPriceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("가격높은순", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let lowPriceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("가격낮은순", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let sortButtonStack: UIStackView = {
        let sortButtonStack = UIStackView()
        sortButtonStack.axis = .horizontal
        sortButtonStack.distribution = .fillEqually
        sortButtonStack.spacing = 8
        return sortButtonStack
    }()
    
    var selectedButton: UIButton?
    
    
    //MARK: viewDidLoad  호출 -
    override func viewDidLoad() {
        super.viewDidLoad()
        addObject()
        configureObject()
        connectData()
        callRequest(query: searchResult,display: display,sort:sorted)
    }
    
    func updateButtonStyle(selectedButton: UIButton) {
        self.selectedButton?.backgroundColor = .clear
        self.selectedButton?.setTitleColor(.white, for: .normal)
        self.selectedButton?.layer.borderColor = UIColor.white.cgColor
        
        selectedButton.backgroundColor = .white
        selectedButton.layer.borderColor = UIColor.white.cgColor
        selectedButton.setTitleColor(.black, for: .normal)
        
        self.selectedButton = selectedButton
    }
    
    func convertInt (count requestIntValue: Int) -> String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let numPrice: String = numberFormatter.string(for: requestIntValue)!
        return numPrice
    }
    
    func callRequest(query: String,display: Int,sort:String) {
        guard !isLoading else { return }
        isLoading = true
        NetworkManager.shared.callRequest(query: query,display: display,sort: sort) { value in
            print("성공성공",value)
           
            if display == self.pageSize {
                self.shoppingResult = value.items
                self.recommandResult = value.items.map { $0.image } //맵으로 이미지를 반환하는 클로저
                self.shoppingCollection.setContentOffset(.zero, animated: false)
                //버튼눌렀을때 스크롤 맨위로 가게하는 구문
            } else {
                self.shoppingResult.append(contentsOf: value.items)
                self.recommandResult.append(contentsOf: value.items.map { $0.image })
            }
            self.count = value.total
            self.isLoading  = false
            self.totalLabel.text = "총 검색 결과 \(self.convertInt(count :value.total))개"
            DispatchQueue.main.async {
                self.shoppingCollection.reloadData()
                self.recommandCollectionView.reloadData()
            }
        } failed: { errorMessage in
            self.showAlert(title: "고장고장", message: errorMessage)
        }
    }
    func showAlert(title: String, message: String, okTitle: String = "확인") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: okTitle, style: .default)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true)
    }
    @objc
    func backButtonClicked() {
        dismiss(animated: true)
    }
    @objc
    func accuracyButtonClicked() {
        updateButtonStyle(selectedButton: accuracyButton)
        sorted = "sim"
        display = pageSize
        shoppingResult.removeAll()
        shoppingCollection.reloadData()
        callRequest(query: searchResult, display: display, sort: sorted)
    }
    
    @objc
    func dateButtonClicked() {
        updateButtonStyle(selectedButton: dateButton)
        sorted = "date"
        display = pageSize
        shoppingResult.removeAll()
        shoppingCollection.reloadData()
        callRequest(query: searchResult, display: display, sort: sorted)
    }
    
    @objc
    func highPriceButtonClicked() {
        updateButtonStyle(selectedButton: highPriceButton)
        sorted = "dsc"
        display = pageSize
        shoppingResult.removeAll()
        shoppingCollection.reloadData()
        callRequest(query: searchResult, display: display, sort: sorted)
    }
    
    @objc
    func lowPriceButtonClicked() {
        updateButtonStyle(selectedButton: lowPriceButton)
        sorted = "asc"
        display = pageSize
        shoppingResult.removeAll()
        shoppingCollection.reloadData()
        callRequest(query: searchResult, display: display, sort: sorted)
    }
    
}
extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == recommandCollectionView ? recommandResult.count : shoppingResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == shoppingResult.count - 2 && shoppingResult.count < count {
            callRequest(query: searchResult, display: shoppingResult.count + pageSize, sort: sorted)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recommandCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommandCollectionViewCell.identifier, for: indexPath) as! RecommandCollectionViewCell
            let shopData = shoppingResult[indexPath.item]
            cell.setupCell(shopData: shopData)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier , for: indexPath) as! ResultCollectionViewCell
        let row = shoppingResult[indexPath.item]
        cell.setupCell(shopData: row)
        return cell
    }
}
    
extension ResultViewController: Configure {
    func settingView(){
        view.backgroundColor = .black
        titleLabel.text = searchResult
        
    }
    func configureObject() {
        naviView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
        }
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(naviView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(20)
        }
        sortButtonStack.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
        shoppingCollection.snp.remakeConstraints { make in
            make.top.equalTo(sortButtonStack.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(recommandCollectionView.snp.top).offset(-8)
        }

        recommandCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(150)
        }
        let sortButtons = [accuracyButton, dateButton, highPriceButton, lowPriceButton]
        sortButtons.forEach { button in
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
            button.clipsToBounds = true
        }
    }
    func addObject() {
        let objects = [naviView,totalLabel,sortButtonStack,shoppingCollection,recommandCollectionView]
        
        objects.forEach {
            self.view.addSubview($0)
        }
        naviView.addSubview(backButton)
        naviView.addSubview(titleLabel)
        let sortObjects = [accuracyButton,dateButton,highPriceButton,lowPriceButton]
        sortObjects.forEach {
            sortButtonStack.addArrangedSubview($0)
        }
    }
    func connectData() {
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        accuracyButton.addTarget(self, action: #selector(accuracyButtonClicked), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(dateButtonClicked), for: .touchUpInside)
        highPriceButton.addTarget(self, action: #selector(highPriceButtonClicked), for: .touchUpInside)
        lowPriceButton.addTarget(self, action: #selector(lowPriceButtonClicked), for: .touchUpInside)
        shoppingCollection.dataSource = self
        shoppingCollection.delegate = self
        shoppingCollection.register(ResultCollectionViewCell.self,forCellWithReuseIdentifier:ResultCollectionViewCell.identifier)
        recommandCollectionView.delegate = self
        recommandCollectionView.dataSource = self
        recommandCollectionView.register(RecommandCollectionViewCell.self, forCellWithReuseIdentifier: RecommandCollectionViewCell.identifier)
    }
}
