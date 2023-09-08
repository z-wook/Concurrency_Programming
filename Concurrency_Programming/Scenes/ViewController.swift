//
//  ViewController.swift
//  Concurrency_Programming
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import Alamofire
import SnapKit

class ViewController: UIViewController {
    
    private let imageSize: CGFloat = 300
    private let progressViewHeight: CGFloat = 10
    private let stackViewSpacing: CGFloat = 20
    private let defaultImage = UIImage(systemName: "photo")
    
    private lazy var imageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = defaultImage
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(imageSize)
        }
        return imageView
    }()
    
    private lazy var imageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = defaultImage
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(imageSize)
        }
        return imageView
    }()
    
    
    private lazy var imageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = defaultImage
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(imageSize)
        }
        return imageView
    }()
    
    private lazy var progressView1: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .lightGray
        view.progressTintColor = .systemBlue
        view.progress = 0
        view.snp.makeConstraints {
            $0.height.equalTo(progressViewHeight)
        }
        return view
    }()
    
    private lazy var progressView2: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .lightGray
        view.progressTintColor = .systemBlue
        view.progress = 0
        view.snp.makeConstraints {
            $0.height.equalTo(progressViewHeight)
        }
        return view
    }()
    
    private lazy var progressView3: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .lightGray
        view.progressTintColor = .systemBlue
        view.progress = 0
        view.snp.makeConstraints {
            $0.height.equalTo(progressViewHeight)
        }
        return view
    }()
    
    private lazy var subStackView1: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = stackViewSpacing
        [imageView1, progressView1].forEach {
            stack.addArrangedSubview($0)
        }
        return stack
    }()
    
    private lazy var subStackView2: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = stackViewSpacing
        [imageView2, progressView2].forEach {
            stack.addArrangedSubview($0)
        }
        return stack
    }()
    
    private lazy var subStackView3: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = stackViewSpacing
        [imageView3, progressView3].forEach {
            stack.addArrangedSubview($0)
        }
        return stack
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = stackViewSpacing
        [subStackView1, subStackView2, subStackView3].forEach {
            stack.addArrangedSubview($0)
        }
        return stack
    }()
    
    private lazy var rightBtn: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "이미지 다운",
                                     style: .plain,
                                     target: self,
                                     action: #selector(download))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = rightBtn
        view.backgroundColor = .systemBackground
        
        configureLayout()
    }
}

private extension ViewController {
    func configureLayout() {
        view.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    @objc func download() {
        /// 1번 방법
//        Task {
//            async let firstData = donwnLoadImage(imageUrl: ImageURL.first)
//            async let secondData = donwnLoadImage(imageUrl: ImageURL.second)
//            async let thirdData = donwnLoadImage(imageUrl: ImageURL.third)
//            imageView1.image = await UIImage(data: firstData)
//            imageView2.image = await UIImage(data: secondData)
//            imageView3.image = await UIImage(data: thirdData)
//        }
        
        
        /// 2번 방법
//        Task {
//            async let firstData = donwnLoadImage(imageUrl: ImageURL.first)
//            let threadID1 = pthread_self() // 현재 스레드의 ID 얻기
//            print("Task 1 is running on thread ID: \(threadID1)")
//            imageView1.image = await UIImage(data: firstData)
//        }
//
//        Task {
//            async let secondData = donwnLoadImage(imageUrl: ImageURL.second)
//            let threadID2 = pthread_self() // 현재 스레드의 ID 얻기
//            print("Task 2 is running on thread ID: \(threadID2)")
//            imageView2.image = await UIImage(data: secondData)
//        }
//
//        Task {
//            async let thirdData = donwnLoadImage(imageUrl: ImageURL.third)
//            let threadID3 = pthread_self() // 현재 스레드의 ID 얻기
//            print("Task 3 is running on thread ID: \(threadID3)")
//            imageView3.image = await UIImage(data: thirdData)
//        }
        
        
        /// 3번 방법
        Task {
            let dataList = await getData()
            imageView1.image = UIImage(data: dataList[0])
            imageView2.image = UIImage(data: dataList[1])
            imageView3.image = UIImage(data: dataList[2])
        }
    }
    
    func getData() async -> [Data] {
        let imageUrls: [ImageURL] = [.first, .second, .third]
        
        let datas = await withTaskGroup(of: (Data, Int).self) { group in
            for (index, imageUrl) in imageUrls.enumerated() {
                group.addTask {
                    let data = await self.donwnLoadImage(imageUrl: imageUrl)
                    return (data, index) // 데이터와 인덱스를 함께 반환
                }
            }
            var dataList: [Data?] = Array(repeating: nil, count: imageUrls.count)
            for await (data, index) in group {
                dataList[index] = data
            }
            return dataList.compactMap { $0 } // nil 값을 제거하여 순서대로 정렬된 배열 반환
        }
        return datas
    }
    
    func donwnLoadImage(imageUrl: ImageURL) async -> Data {
        let dataTask = AF.request(imageUrl.url, method: .get)
            .downloadProgress(closure: { progress in
                switch imageUrl {
                case .first:
                    self.progressView1.progress = Float(progress.fractionCompleted)
                case .second:
                    self.progressView2.progress = Float(progress.fractionCompleted)
                case .third:
                    self.progressView3.progress = Float(progress.fractionCompleted)
                }
            })
            .serializingData()
        switch await dataTask.result {
        case .success(let data):
            return data
            
        case .failure(let error):
            print(error.localizedDescription)
        }
        return Data()
    }
}
