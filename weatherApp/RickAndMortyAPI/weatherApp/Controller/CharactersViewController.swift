//
//  CharactersViewController.swift
//  weatherApp
//
//  Created by Владимир on 06.10.2023.
//

import UIKit

class CharactersViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var episode: String = "Eps"
    var arrayImage: Dictionary<String,UIImage> = [:]
    var arrayID: Array<String> = []
    var eps: Eps?
    var result: Result?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        loadURL()
        
        
    }
    
    func loadURL() {
        guard let url = URL(string: episode) else { return }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { [self] data , response , error  in
            if let data = data, let eps = try? JSONDecoder().decode(Eps.self, from: data) {
                self.eps = eps
                    for i in eps.characters {
                        loadPerson(urlPerson: i)
                    }
            }
        }
        
        task.resume()
        
    }
    
    func loadPerson(urlPerson: String) {
  
        let url = URL(string: urlPerson)!
            let request = URLRequest(url: url)
            
        let task = URLSession.shared.dataTask(with: request) { [self] data, response , error  in
                if let data = data, let person = try? JSONDecoder().decode(Result.self, from: data) {
                    
                    
                    arrayID.append(String(person.id))
                    loadImage(urlString: String(person.id))
                }
                
            }
            task.resume()
    }
    
    
    func loadImage(urlString: String) {
        let url = URL(string: "https://rickandmortyapi.com/api/character/avatar/\(urlString).jpeg")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [self] data , response , error  in
            if let data = data, let image = UIImage(data: data) {
                arrayImage.updateValue(image, forKey: urlString)
                
                
                if arrayImage.count == arrayID.count {
                    
                    DispatchQueue.main.async {
                        collectionView.reloadData()
                        print(arrayImage.count)
                    }
                }
            }
        }
        task.resume()
    }

    func goSecondVc(id: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Second") as! SecondViewController

        
        
        let url = URL(string: "https://rickandmortyapi.com/api/character/\(id)")!
        let request = URLRequest(url: url)
    let task = URLSession.shared.dataTask(with: request) { [self] data , response , error  in
            if let data = data, let res = try? JSONDecoder().decode(Result.self, from: data) {
                result = res
                
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Second") as! SecondViewController
                    vc.results = result
                    vc.name = result?.name ?? "NO NAME"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        task.resume()
        
        
    }
    
    

}


extension CharactersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrayImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 190, height: 190)
    }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        let key = Array(arrayImage.keys)[indexPath.row]
        
        if let image = arrayImage[key] {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.frame = cell.bounds
                imageView.layer.cornerRadius = 30
                imageView.layer.borderColor = UIColor.red.cgColor
                
                cell.addSubview(imageView)
            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let key = Array(arrayImage.keys)[indexPath.row]
        goSecondVc(id: "\(key)")
    }
    
    
}
