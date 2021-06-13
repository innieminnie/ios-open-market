
import UIKit

class GridViewController: UIViewController {
    let openMarketAPIManager = OpenMarketAPIManager()
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    var productList = [Product]()
    private var currentPage = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        requestProductList()
    }
    private func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView.register(ProductGridViewCell.self, forCellWithReuseIdentifier: ProductGridViewCell.identifier)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        
        let safeLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor)
        ])
    }
}
extension GridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = productList[indexPath.row]
       
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductGridViewCell.identifier, for: indexPath) as? ProductGridViewCell else {
            debugPrint("CellError")
            return UICollectionViewCell()
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
extension GridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width - 30) / 2
        let height: CGFloat = width * 1.5
        return CGSize(width: width, height: height)
    }
}
extension GridViewController {
    private func requestProductList() {
        openMarketAPIManager.requestProductList(of: currentPage) { (result) in
            switch result {
            case .success (let product):
                guard product.items.count > 0 else {
                    return
                }

                self.productList.append(contentsOf: product.items)

                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
                self.currentPage += 1
                self.requestProductList()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
