import SwiftUI
import CryptoKit

// Network Error Enum
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
}

class APIService {
    static let shared = APIService()
    
    private let secret = "1cHACoP9eDTHurLkCZJcD7NyxfBkve0S"

    func hmacSHA256(data: String) -> String {
        let key = SymmetricKey(data: Data(secret.utf8))
        let data = Data(data.utf8)
        let hmac = HMAC<SHA256>.authenticationCode(for: data, using: key)
        return hmac.map { String(format: "%02hhx", $0) }.joined()
    }

    // Function for the GET request (Service Status)
    func fetchServiceStatus(completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = "https://backend-ai.backd-api.workers.dev/"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data, let status = String(data: data, encoding: .utf8) {
                completion(.success(status))
            } else {
                completion(.failure(NetworkError.invalidResponse))
            }
        }
        task.resume()
    }

    // Function for the POST request (Search)
    func search(query: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = "https://backend-ai.backd-api.workers.dev/search"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // POST body
        let body: [String: Any] = [
            "query": query,
            "model": "gemini"
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            completion(.failure(NetworkError.invalidResponse))
            return
        }
        
        // Generate HMAC-SHA256 for the body
        let hashedBody = hmacSHA256(data: jsonString)
        
        // Set the hashed body in the Authorization header
        request.setValue("Bearer \(hashedBody)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NetworkError.invalidResponse))
            }
        }
        task.resume()
    }
    
    func fetchSpecials(completion: @escaping (Result<[Special], Error>) -> Void) {
            let urlString = "https://backend-ai.backd-api.workers.dev/specials"
            guard let url = URL(string: urlString) else {
                completion(.failure(NetworkError.invalidURL))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Empty JSON body
            let jsonData = "{}".data(using: .utf8)!
            
            // Generate HMAC-SHA256 for the empty body
            let hashedBody = hmacSHA256(data: "{}")
            
            // Set the hashed body in the Authorization header
            request.setValue("Bearer \(hashedBody)", forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(SpecialsResponse.self, from: data)
                    completion(.success(decodedResponse.result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }


}
