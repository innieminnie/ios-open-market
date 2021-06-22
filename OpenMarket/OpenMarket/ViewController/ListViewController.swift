
import UIKit

class ListViewController: UIViewController, ContainProducts {
    let tableView = UITableView()
    weak var detailProductDelegate: DetailProductDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProductListTableViewCell.self, forCellReuseIdentifier: ProductListTableViewCell.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let safeLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor)
        ])
    }
}
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = productList[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductListTableViewCell.identifier, for: indexPath) as? ProductListTableViewCell else {
            debugPrint("CellError")
            return UITableViewCell()
        }
        
        DispatchQueue.global().async {
            guard let imageURLText = product.thumbnails.first, let imageURL = URL(string: imageURLText), let imageData = try? Data(contentsOf: imageURL) else {
                DispatchQueue.main.async {
                    cell.updateUI(with: product, imageData: UIImage(systemName: "multiply.circle.fill"))
                }
                return
            }
            
            DispatchQueue.main.async {
                cell.updateUI(with: product, imageData: UIImage(data: imageData))
            }
        }
        
        return cell
    }
}
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailViewController = ProductDetailViewController()
        
        OpenMarketAPIManager.shared.requestProduct(of: productList[indexPath.row].id) { result in
            switch result {
            case .success(let product):
                self.detailProductDelegate = productDetailViewController
                self.detailProductDelegate?.showCurrentProduct(product)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        self.navigationController?.pushViewController(productDetailViewController, animated: true)
        
    }
}
