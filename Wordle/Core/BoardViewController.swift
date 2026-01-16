import UIKit
protocol BoardViewControllerDatasource: AnyObject {
    var currentGuesses: [[Character?]] { get }
    func boxColor(at indexPath: IndexPath)->UIColor?
}
class BoardViewController: UIViewController, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
   
    weak var datasource: BoardViewControllerDatasource?

  private  let collectionVIew: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(KeyCell.self, forCellWithReuseIdentifier: KeyCell.identifier)
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionVIew.delegate = self
        collectionVIew.dataSource = self
        view.addSubview(collectionVIew)
        NSLayoutConstraint.activate([
            collectionVIew.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:35),
            collectionVIew.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            collectionVIew.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            collectionVIew.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        
        
        ])
    
        
    }
    public func reloadData(){
        collectionVIew.reloadData()
    }
    
}
extension BoardViewController{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource?.currentGuesses.count ?? 0//broji koliko imamo redova
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let guesses = datasource?.currentGuesses ?? []
        return guesses[section].count //broji koliko slova ima u sekciji
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCell.identifier, for: indexPath) as? KeyCell else {
            fatalError()
        }
        
        cell.backgroundColor = datasource?.boxColor(at: indexPath)
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.systemGray3.cgColor
        
        let guesses  = datasource?.currentGuesses ?? []
        if let letter = guesses[indexPath.section][indexPath.row]{
            cell.configure(with: letter)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let margin: CGFloat = 20
        let size: CGFloat = (collectionView.frame.size.width - margin)/5 //sirina ekrana podjeljena s 10 jer najduzi red ima 10 tipki
        
        return CGSize(width: size, height: size)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int)->UIEdgeInsets{
        

        
        
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
}
