import Foundation

protocol NetworkServiceProtocol {
    func fetchMemes(from urlString: String, completion: @escaping (Result<[Meme], Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    func fetchMemes(from urlString: String, completion: @escaping (Result<[Meme], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -2)))
                return
            }

            do {
                let response = try JSONDecoder().decode(MemeResponse.self, from: data)
                completion(.success(response.data.memes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
