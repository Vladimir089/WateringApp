//
//  ViewController.swift
//  weatherApp
//
//  Created by Владимир on 22.09.2023.
//

import UIKit

class ViewController: UIViewController {

    //MARK: -Const
    
    @IBOutlet weak var personPickerView: UIPickerView!
    var numberPickerView: Int = 0
    var arrayNames: Array<String> = []
    @IBOutlet weak var clickButtonOutlet: UIButton!
    var name = ""
    
    var numberRow: Int? = 0
    var uni: Uni?
    var result: Result?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
        personPickerView.delegate = self
        personPickerView.dataSource = self
        clickButtonOutlet.layer.cornerRadius = 20
        clickButtonOutlet.tintColor = .white
        clickButtonOutlet.backgroundColor = .systemGreen
        
        
    }
    //MARK: -Methods
    
    public func request()  {
        let url = URL(string: "https://rickandmortyapi.com/api/character")
        if let url = url {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { [self] data , response , error  in
                if let data = data, let uni = try? JSONDecoder().decode(Uni.self, from: data) {
                    self.uni = uni
                    numberPickerView = uni.results.count
                    for results in uni.results {
                        arrayNames.append(results.name)
                    }
                    DispatchQueue.main.async {
                        personPickerView.reloadAllComponents()
                    }
                }
            }
            task.resume()
        }
    }

    
    @IBAction func nextPageButton(_ sender: UIButton) {
        result = uni?.results[numberRow ?? 0]
        if result != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Second") as! SecondViewController
            vc.name = name
            
            vc.results = result
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            showAlert()
        }
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "No internet connection", preferredStyle: .alert)
        let action = UIAlertAction(title: "Refresh", style: .default) { action in
            self.nextPageButton(self.clickButtonOutlet)
        }
        let actionNO = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.addAction(actionNO)
        self.present(alert, animated: true, completion: nil)
    }
}

    //MARK: -Extensions

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberPickerView
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        name = "\(arrayNames[row])"
        
        return "\(arrayNames[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numberRow = row
        
    }
}
