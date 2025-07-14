import Foundation

final class MainViewModel {

    private let networkService: NetworkServiceProtocol
    private let url = "https://api.imgflip.com/get_memes"

    private(set) var allMemes: [Meme] = []
    private(set) var filteredMemes: [Meme] = []
    
    var onUpdate: (() -> Void)?

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    var numberOfItems: Int {
        return filteredMemes.count
    }

    func fetchData() {
        networkService.fetchMemes(from: url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let memes):
                    self?.allMemes = memes
                    self?.filteredMemes = memes
                    self?.onUpdate?()
                case .failure(let error):
                    print("Ошибка: \(error)")
                }
            }
        }
    }

    func filter(with text: String) {
        if text.isEmpty {
            filteredMemes = allMemes
        } else {
            filteredMemes = allMemes.filter {
                $0.name.lowercased().contains(text.lowercased())
            }
        }
        onUpdate?()
    }

    func meme(at index: Int) -> Meme {
        return filteredMemes[index]
    }
    
    func randomMeme() -> Meme? {
         return filteredMemes.randomElement()
     }
}
