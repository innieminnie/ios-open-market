
import Foundation

struct Product: Decodable {
    let id: Int
    let title: String
    let descriptions: String?
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
    let images: [String]?
    let registrationDate: Double
    
    init(_ id: Int, _ title: String, _ price: Int, _ currency: String, _ stock: Int, _ thumbnails: [String], _ registrationDate: Double) {
        self.id = id
        self.title = title
        self.descriptions = nil
        self.price = price
        self.currency = currency
        self.stock = stock
        self.discountedPrice = nil
        self.thumbnails = thumbnails
        self.images = nil
        self.registrationDate = registrationDate
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case descriptions
        case price
        case currency
        case stock
        case discountedPrice = "discounted_price"
        case thumbnails
        case images
        case registrationDate = "registration_date"
    }
}
