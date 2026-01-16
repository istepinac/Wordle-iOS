import UIKit

protocol KeyboardViewControllerDelegate: AnyObject {
    func keyboardViewController(_ vc: KeyboardViewController, didTapKey letter: Character)
}

class KeyboardViewController: UIViewController, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    
    weak var delegate: KeyboardViewControllerDelegate?
    let letters = ["qwertyuiop", "asdfghjkl", "»xcvbnm<"]
    private var keys: [[Character]] = []
    

    let collectionVIew: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
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
            collectionVIew.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionVIew.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionVIew.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            collectionVIew.bottomAnchor.constraint(equalTo: view.bottomAnchor ),

        
        
        ])
        
        for row in letters{ //brojimo znakove
            let chars = Array(row)
            keys.append(chars)
        }
        
    }
    
}
extension KeyboardViewController{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return keys.count //broji koliko imamo redova
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys[section].count //broji koliko slova ima u sekciji
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCell.identifier, for: indexPath) as? KeyCell else {
            fatalError()
        }
        let letter = keys[indexPath.section][indexPath.row] //Uzima konkretno slovo iz matrice i šalje ga u KeyCell (ćeliju) na prikaz.
        cell.configure(with: letter)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let margin: CGFloat = 20
        let size: CGFloat = (collectionView.frame.size.width - margin)/10 //sirina ekrana podjeljena s 10 jer najduzi red ima 10 tipki
        
        return CGSize(width: size, height: size*1.5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int)->UIEdgeInsets{
        
        var left: CGFloat = 1
        var right: CGFloat = 1
        
        let margin: CGFloat = 20
        let size: CGFloat = (collectionView.frame.size.width - margin)/10
        
        
        let count: CGFloat = CGFloat(collectionView.numberOfItems(inSection: section))
        
        let inset: CGFloat = (collectionView.frame.size.width-(size*count) - (2*count))/2
        
        left = inset
        right = inset
        //racuna se koliko prostora tipke + razmaci zauzimaju oduzme se to od ukupone sirine ekrana i podjeli sa 2 i tako dobijemo margine 
        return UIEdgeInsets(top: 6, left: left, bottom: 6, right: right)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let letter = keys[indexPath.section][indexPath.row]
        delegate?.keyboardViewController(self, didTapKey: letter)
    }
}
