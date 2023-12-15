//
//  EpisodesViewController.swift
//  weatherApp
//
//  Created by Владимир on 30.09.2023.
//

import UIKit

class EpisodesViewController: UIViewController {
    
    var episodes: Array<String> = []
    let id = "one"
    var nameEps: Array<String> = []
    var detailEps: Array<String> = []
    @IBOutlet weak var tableView: UITableView!
    var epsUrl: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getEpisodes()
    }
    
    
    
    func getEpisodes() {
        for episode in episodes {
            let url = URL(string: episode)
            let request = URLRequest(url: url!)
            if request != nil {
                let task = URLSession.shared.dataTask(with: request) { [self] data , response , error  in
                    if let data = data, let eps = try? JSONDecoder().decode(Eps.self, from: data) {
                        nameEps.append(eps.name)
                        detailEps.append(eps.airDate)
                        epsUrl.append(eps.url)
                        
                    }
                }
                task.resume()
            }
            
        }
    }

   

}


extension EpisodesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameEps.count
    }
    
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: id)
     
        
        
        cell.detailTextLabel?.text = detailEps[indexPath.row]
        cell.textLabel?.text = nameEps[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Characters") as! CharactersViewController
        vc.episode = epsUrl[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
