import UIKit
import SnapKit

class MainViewController: UIViewController {
    private enum Layout {
        static let inset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        static let searchBarTop: CGFloat = 20
 
        
        enum SearchButton {
            static let top: CGFloat = 20
            static let inset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        }

        enum ImageMeme {
            static let top: CGFloat = 20
            
            static let height: CGFloat = 500
            static let widht: CGFloat = 300
          
        }

        enum OkButton {
            static let top: CGFloat = 20
            static let left: CGFloat = 80
            
            static let height: CGFloat = 100
            static let wight: CGFloat = 100
           
        }
        
        enum NOButton {
            static let top: CGFloat = 20
            static let right: CGFloat = 80
            
            static let height: CGFloat = 100
            static let wight: CGFloat = 100
           
        }
        
    }
    
    private let viewModel = MainViewModel()
 
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Введите ваш запрос"
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ПОЛУЧИТЬ ПРЕДСКАЗАНИЕ", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.purple.withAlphaComponent(0.5)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.addTarget(
            self,
            action: #selector(didTapButton),
            for: .touchUpInside
        )
   
        return button
    }()
    
    private let imageMeme: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "1")
        image.clipsToBounds = true
        image.layer.cornerRadius = 7
        image.contentMode = .scaleAspectFit
 
        return image
    }()
    
    
    private let okButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("👍", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        button.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.addTarget(
            self,
            action: #selector(didTapOKButton),
            for: .touchUpInside
        )

        return button
    }()
    
    
    private let noButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("👎", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        button.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.addTarget(
            self,
            action: #selector(didTapNOButton),
            for: .touchUpInside
        )

        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        addSubviews()
        setupConstraints()
        viewModel.fetchData() 

    }
    
  

       private func bindViewModel() {
           viewModel.onUpdate = { [weak self] in
               self?.showRandomMeme()
           }
       }

    
       @objc
       private func didTapButton() {
           showRandomMeme()
       }
        @objc
     private func didTapOKButton() {
         searchBar.text = ""
         imageMeme.image = UIImage(named: "1")
        }
    
       @objc
        private func didTapNOButton() {
        showRandomMeme()
        }

       private func showRandomMeme() {
           guard let meme = viewModel.randomMeme() else { return }
           
           loadImage(from: meme.url, height: meme.height, width: meme.width)
       }

    private func loadImage(from urlString: String, height: Int, width: Int) {
           guard let url = URL(string: urlString) else { return }

       
           DispatchQueue.global().async {
               if let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) {
                   DispatchQueue.main.async {
                       self.imageMeme.image = image
                      
                   }
               }
           }
       }

   
}

// MARK: - Setup Constraints

private extension MainViewController {
    func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(searchButton)
        view.addSubview(imageMeme)
        view.addSubview(okButton)
        view.addSubview(noButton)
    }

    func setupConstraints() {
   
        searchBar.snp.makeConstraints { make in
                    make
                        .top
                        .equalTo(view.safeAreaLayoutGuide)
                        .offset(Layout.searchBarTop)
                    make
                        .leading
                        .trailing
                        .equalToSuperview()
                        .inset(Layout.inset)
                }
        
        searchButton.snp.makeConstraints { make in
            make
                .top
                .equalTo(searchBar.snp.bottom)
                .offset(Layout.SearchButton.top)
            make
                .leading
                .trailing
                .equalToSuperview()
                .inset(Layout.SearchButton.inset)
        }
       
        imageMeme.snp.makeConstraints { make in
            make
                .top
                .equalTo(searchButton.snp.bottom)
                .offset(Layout.ImageMeme.top)
            make
                .leading
                .trailing
                .equalToSuperview()
                .inset(Layout.inset)
            make
                .height
                .equalTo(Layout.ImageMeme.height)
            make
                .width
                .equalTo(Layout.ImageMeme.widht)
            
        }
        
        okButton.snp.makeConstraints { make in
            make
                .top
                .equalTo(imageMeme.snp.bottom)
                .offset(Layout.OkButton.top)
            make
                .leading
                .equalToSuperview()
                .inset(Layout.OkButton.left)
            make
                .height
                .equalTo(Layout.OkButton.height)
            make
                .width
                .equalTo(Layout.OkButton.wight)
        }
        
        noButton.snp.makeConstraints { make in
            make
                .top
                .equalTo(imageMeme.snp.bottom)
                .offset(Layout.NOButton.top)
            make
                .trailing
                .equalToSuperview()
                .inset(Layout.NOButton.right)
            make
                .height
                .equalTo(Layout.NOButton.height)
            make
                .width
                .equalTo(Layout.NOButton.wight)
        }
    }
}
