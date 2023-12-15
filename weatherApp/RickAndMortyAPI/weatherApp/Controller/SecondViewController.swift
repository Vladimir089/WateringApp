//
//  SecondViewController.swift
//  weatherApp
//
//  Created by Владимир on 28.09.2023.
//

import UIKit

class SecondViewController: UIViewController {
    var name = " "
   
    @IBOutlet weak var imagePerson: UIImageView!
    var results: Result?
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    
    @IBOutlet weak var epButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = name
        imagePerson.layer.cornerRadius = 70
        task()
  
    }
    
    @IBAction func goEpisodesButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Episodes") as! EpisodesViewController
        vc.episodes = results?.episode ?? ["Эпизодов нет"]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func task() {
        if let imageURl = results?.image {
            let url = URL(string: imageURl)!
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data , response , error  in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imagePerson.image = image
                        let orig = self.results?.location.name
                        let gender = self.results?.gender.rawValue
                        let status = self.results?.status.rawValue
                        let species = self.results?.species.rawValue
                        let numbEpisode = self.results?.episode.count
                        self.originLabel.text = "Origin — " + (orig ?? "Unknown")
                        self.genderLabel.text = "Gender — " + (gender ?? "Unknown")
                        self.statusLabel.text = "Status — " + (status ?? "Unknown")
                        self.speciesLabel.text = "Species — " + (species ?? "Unknown")
                        self.epButtonOutlet.setTitle("Episodes — " + "\(numbEpisode ?? 0)", for: .normal)
                        
                        
                    }
                }
            }
            task.resume()
        }
        
    }
}



