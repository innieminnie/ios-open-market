
import UIKit

class ListViewController: UIViewController, ContainProducts {
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
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
            guard let imageURLText = product.thumbnails?.first, let imageURL = URL(string: imageURLText), let imageData = try? Data(contentsOf: imageURL) else {
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
extension String {
    func checkRange(of value : String) -> NSRange {
        let string : NSString = NSString(string: self)
        return string.range(of: value)
    }
}
