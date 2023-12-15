//
//  ViewController.swift
//  WateringTrackerApp
//
//  Created by Владимир on 05.12.2023.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    //MARK: -Create UI
    var firstViewHeightConstraint: NSLayoutConstraint!
    var collapseIndicator: UIView!
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var secondViewHeightConstraint: NSLayoutConstraint!
    let arrayImage = ["1.jpeg", "2.jpeg", "3.jpeg", "4.jpeg", "5.jpeg"]
    let ID = "1"
    let backgroundView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemGreen
        let image = UIImage(named: "2.jpeg")
        view.image = image
        
        return view
    }()
    
    let labelTop: UILabel = {
        let label = UILabel()
        label.text = "Watering  tracker"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    let tableView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    
    let firstView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        return view
    }()
    
    let secondView: UIView = {
        let view = UIView()
        
        
        view.layer.cornerRadius = 30
        view.alpha = 0.7
        return view
    }()
    
    var timer: Timer?
    var timerAdd: Timer?
    
    var watering: Int {
        get {
            return UserDefaults.standard.integer(forKey: "WateringValue")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "WateringValue")
            UserDefaults.standard.synchronize()
        }
    }
    
    var labelDay: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        return label
    }()
    
    let watInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Watering Info"
        return label
    }()
    
    let watInfoTwoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.text = "Watering this kind of plants depends on the temperature of the place."
        return label
    }()
    
    let plantsInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.text = "Plants Info"
        return label
    }()
    
    let labelBaseFirstView: UILabel = {
        let label = UILabel()
        label.text = "Next Watering in"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.contentMode = .center
        return label
    }()
    
    let labelBaseSecondView: UILabel = {
        let label = UILabel()
        label.text = "Select background image"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.contentMode = .center
        label.textColor = .white
        
        return label
    }()
    
    let labellight: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = .lightGray
        label.text = "watering every 7 days"
        return label
    }()
    
    let Temp: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = .lightGray
        label.text = "Temperature"
        return label
    }()
    
    let Hum: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = .lightGray
        label.text = "Humidity"
        return label
    }()
    
    let Light: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = .lightGray
        label.text = "Light"
        return label
    }()
    
    let viewInFirstView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    let viewInView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    let buttonWatering: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.systemGreen.cgColor
        button.backgroundColor = .systemGreen
        button.layer.borderWidth = 4
        button.layer.cornerRadius = 30
        
        if let originalImage = UIImage(systemName: "drop") {
            // Увеличиваем размер системной картинки
            let configuration = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
            let scaledImage = originalImage.applyingSymbolConfiguration(configuration)
            
            button.setImage(scaledImage, for: .normal)
            button.tintColor = .white
            
        }
        button.isSpringLoaded = true
        
        return button
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.text = "18-28 ℃"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let humLabel: UILabel = {
        let label = UILabel()
        label.text = "70-75 %"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let lightLabel: UILabel = {
        let label = UILabel()
        label.text = "5k to 10k lux"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    
    func updateLabel() {
        watering += 1
        labelDay.text = "\(watering) days"
        sleep(UInt32(0.1))
    }
    
    @objc func tapButton() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.transition(with: self.buttonWatering, duration: 0.4, options: .transitionCrossDissolve, animations: { [self] in
                if let originalImage = UIImage(systemName: "checkmark") {
                    let configuration = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
                    let scaledImage = originalImage.applyingSymbolConfiguration(configuration)
                    self.buttonWatering.setImage(scaledImage, for: .normal)
                    self.buttonWatering.tintColor = .systemGreen
                    self.buttonWatering.backgroundColor = .white
                }
            }, completion: nil)
        }
        
        DispatchQueue.main.async { [self] in
            timerAdd = Timer.scheduledTimer(timeInterval: 0.09, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
        
        // Задержка в 1.5 секунды (вместо 15 для тестирования)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.transition(with: self.buttonWatering, duration: 0.4, options: .transitionCrossDissolve, animations: {
                if let originalImage = UIImage(systemName: "drop") {
                    let configuration = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
                    let scaledImage = originalImage.applyingSymbolConfiguration(configuration)
                    self.buttonWatering.setImage(scaledImage, for: .normal)
                    self.buttonWatering.tintColor = .white
                    self.buttonWatering.backgroundColor = .systemGreen
                }
            }, completion: nil)
        }
    }
    @objc func touchDown() {
        UIView.animate(withDuration: 0.3, animations: {
            self.buttonWatering.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })
    }
    
    @objc func touchUp() {
        UIView.animate(withDuration: 0.3, animations: {
            self.buttonWatering.transform = CGAffineTransform.identity
        })
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundView)
        
        
        
        view.addSubview(secondView)
        view.addSubview(firstView)
        
        firstView.addSubview(labellight)
        firstView.addSubview(labelDay)
        firstView.addSubview(labelBaseFirstView)
        firstView.addSubview(buttonWatering)
        firstView.addSubview(watInfoLabel)
        firstView.addSubview(watInfoTwoLabel)
        firstView.addSubview(plantsInfoLabel)
        viewInFirstView.addSubview(viewInView)
        firstView.addSubview(Temp)
        firstView.addSubview(Hum)
        firstView.addSubview(Light)
        viewInFirstView.addSubview(tempLabel)
        viewInFirstView.addSubview(lightLabel)
        firstView.addSubview(viewInFirstView)
        viewInFirstView.addSubview(humLabel)
        collapseIndicator = UIView()
        view.addSubview(labelTop)
        secondView.addSubview(labelBaseSecondView)
        secondView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
        buttonWatering.adjustsImageWhenHighlighted = false
        buttonWatering.addTarget(self, action: #selector(touchDown), for: .touchDown)
        buttonWatering.addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside])
        
        
        secondView.addSubview(tableView)
        tableView.isUserInteractionEnabled = true
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isUserInteractionEnabled = true
        secondView.isUserInteractionEnabled = true
        
        view.insertSubview(blurView, belowSubview: secondView)
        blurView.layer.cornerRadius = 30
        blurView.clipsToBounds = true
        tableView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ID)
        blurView.topAnchor.constraint(equalTo: secondView.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        blurView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
        collapseIndicator.layer.cornerRadius = 3
        collapseIndicator.backgroundColor = .lightGray
        collapseIndicator.translatesAutoresizingMaskIntoConstraints = false
        firstView.addSubview(collapseIndicator)
        let panGesture = UITapGestureRecognizer(target: self, action: #selector(panFirstView))
        collapseIndicator.isUserInteractionEnabled = true
        firstView.addGestureRecognizer(panGesture)
        buttonWatering.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        createConstains()
        tableView.delegate = self
        tableView.dataSource = self
        UNUserNotificationCenter.current().delegate = self
        if watering == 1 {
            labelDay.text = "\(watering) day"
        } else {
            labelDay.text = "\(watering) days"
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Уведомления разрешены")
            } else {
                print("Уведомления не разрешены")
            }
        }
        
        startBackgroundTimer()
    }
    
    
    
    func startBackgroundTimer() {
        backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "BackgroundTimer") {
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        }
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateWatering), userInfo: nil, repeats: true)
        
        
        RunLoop.current.add(timer!, forMode: .default)
    }
    
    
    @objc func updateWatering() {
        if watering > 1 {
            watering -= 1
            
            if watering == 1 {
                scheduleLocalNotification()
                labelDay.text = "\(watering) day"
            } else {
                labelDay.text = "\(watering) days"
            }
        }
        
    }
    
    func scheduleLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Next Watering"
        content.body = "It's time to water your plants!"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "WateringNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    
    
    @objc func updateTimer() {
        if watering != 7 {
            watering += 1
            labelDay.text = "\(watering) days"
        }
        if watering == 7 {
            
            timerAdd?.invalidate()
            
        }
    }
    
    func createConstains() {
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        firstView.translatesAutoresizingMaskIntoConstraints = false
        firstViewHeightConstraint = firstView.heightAnchor.constraint(equalToConstant: view.frame.height / 4.75)
        firstViewHeightConstraint.isActive = true
        firstView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        firstView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        firstView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
        collapseIndicator.topAnchor.constraint(equalTo: firstView.topAnchor, constant: 8).isActive = true
        collapseIndicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
        collapseIndicator.heightAnchor.constraint(equalToConstant: 6).isActive = true
        collapseIndicator.centerXAnchor.constraint(equalTo: firstView.centerXAnchor).isActive = true
        
        labelBaseFirstView.translatesAutoresizingMaskIntoConstraints = false
        labelBaseFirstView.topAnchor.constraint(equalTo: firstView.topAnchor, constant: 30).isActive = true
        labelBaseFirstView.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 20).isActive = true
        
        labelDay.translatesAutoresizingMaskIntoConstraints = false
        labelDay.topAnchor.constraint(equalTo: labelBaseFirstView.bottomAnchor, constant: 10).isActive = true
        labelDay.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 20).isActive = true
        
        labellight.translatesAutoresizingMaskIntoConstraints = false
        labellight.topAnchor.constraint(equalTo: labelDay.bottomAnchor, constant: 10).isActive = true
        labellight.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 20).isActive = true
        
        buttonWatering.translatesAutoresizingMaskIntoConstraints = false
        buttonWatering.topAnchor.constraint(equalTo: firstView.topAnchor, constant: 30).isActive = true
        buttonWatering.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -20).isActive = true
        buttonWatering.bottomAnchor.constraint(equalTo: labellight.bottomAnchor, constant: 0).isActive = true
        buttonWatering.leftAnchor.constraint(equalTo: labellight.rightAnchor, constant: 110).isActive = true
        
        watInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        watInfoLabel.topAnchor.constraint(equalTo: labellight.bottomAnchor, constant: 50).isActive = true
        watInfoLabel.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 20).isActive = true
        
        watInfoTwoLabel.translatesAutoresizingMaskIntoConstraints = false
        watInfoTwoLabel.topAnchor.constraint(equalTo: watInfoLabel.bottomAnchor, constant: 25).isActive = true
        watInfoTwoLabel.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 20).isActive = true
        watInfoTwoLabel.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -50).isActive = true
        
        plantsInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        plantsInfoLabel.topAnchor.constraint(equalTo: watInfoTwoLabel.bottomAnchor, constant: 50).isActive = true
        plantsInfoLabel.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 20).isActive = true
        
        Temp.translatesAutoresizingMaskIntoConstraints = false
        Temp.topAnchor.constraint(equalTo: plantsInfoLabel.bottomAnchor, constant: 20).isActive = true
        Temp.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 20).isActive = true
        
        Hum.translatesAutoresizingMaskIntoConstraints = false
        Hum.leftAnchor.constraint(equalTo: viewInView.leftAnchor, constant: 0).isActive = true
        Hum.topAnchor.constraint(equalTo: plantsInfoLabel.bottomAnchor, constant: 20).isActive = true
        
        Light.translatesAutoresizingMaskIntoConstraints = false
        Light.leftAnchor.constraint(equalTo: viewInView.rightAnchor, constant: 0).isActive = true
        Light.topAnchor.constraint(equalTo: plantsInfoLabel.bottomAnchor, constant: 20).isActive = true
        
        viewInFirstView.translatesAutoresizingMaskIntoConstraints = false
        viewInFirstView.topAnchor.constraint(equalTo: Temp.bottomAnchor, constant: 10).isActive = true
        viewInFirstView.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 20).isActive = true
        viewInFirstView.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -20).isActive = true
        viewInFirstView.bottomAnchor.constraint(equalTo: Temp.bottomAnchor, constant: 50).isActive = true
        
        viewInView.translatesAutoresizingMaskIntoConstraints = false
        viewInView.leftAnchor.constraint(equalTo: viewInFirstView.leftAnchor, constant: 125).isActive = true
        viewInView.rightAnchor.constraint(equalTo: viewInFirstView.rightAnchor, constant: -125).isActive = true
        viewInView.topAnchor.constraint(equalTo: viewInFirstView.topAnchor, constant: 0).isActive = true
        viewInView.bottomAnchor.constraint(equalTo: viewInFirstView.bottomAnchor, constant: 0).isActive = true
        
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.topAnchor.constraint(equalTo: viewInFirstView.topAnchor, constant: 11).isActive = true
        tempLabel.leftAnchor.constraint(equalTo: viewInFirstView.leftAnchor, constant: 30).isActive = true
        
        humLabel.translatesAutoresizingMaskIntoConstraints = false
        humLabel.topAnchor.constraint(equalTo: viewInView.topAnchor, constant: 11).isActive = true
        humLabel.leftAnchor.constraint(equalTo: viewInView.leftAnchor, constant: 30).isActive = true
        
        lightLabel.translatesAutoresizingMaskIntoConstraints = false
        lightLabel.topAnchor.constraint(equalTo: viewInFirstView.topAnchor, constant: 11).isActive = true
        lightLabel.rightAnchor.constraint(equalTo: viewInFirstView.rightAnchor, constant: -15).isActive = true
        
        secondView.translatesAutoresizingMaskIntoConstraints = false
        secondViewHeightConstraint = secondView.heightAnchor.constraint(equalToConstant: view.frame.height / 4.75)
        secondViewHeightConstraint.isActive = true
        secondView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        secondView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        secondView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height / (-6)).isActive = true
        
        labelTop.translatesAutoresizingMaskIntoConstraints = false
        labelTop.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        labelTop.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        labelTop.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -180).isActive = true
        
        
        labelBaseSecondView.translatesAutoresizingMaskIntoConstraints = false
        labelBaseSecondView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        labelBaseSecondView.topAnchor.constraint(equalTo: secondView.topAnchor, constant: 30).isActive = true
        labelBaseSecondView.alpha = 1.0
        
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 20
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: labelBaseSecondView.bottomAnchor, constant: 10).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
        
    }
    
    
    
    @objc func panFirstView() {
        let isCollapsed = firstViewHeightConstraint.constant != view.frame.height / 4.75
        
        if isCollapsed {
            // Развернуть
            firstViewHeightConstraint.constant = view.frame.height / 4.75
            UIView.animate(withDuration: 0.4) {
                self.backgroundView.transform = CGAffineTransform.identity
                self.view.layoutIfNeeded()
            }
        } else {
            // Свернуть
            firstViewHeightConstraint.constant = view.frame.height / 1.8
            let scale = CGAffineTransform(scaleX: 1.1, y: 1.1)
            UIView.animate(withDuration: 0.4) {
                self.backgroundView.transform = scale
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    
    func prints() {
        print(1)
    }
    
    
    
}




extension ViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath)
        collectionView.isUserInteractionEnabled = true
        
        
        let image = UIImage(named: arrayImage[indexPath.row])
        let imageView = UIImageView(image: image)
        imageView.frame = cell.contentView.bounds
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        cell.isUserInteractionEnabled = true
        cell.addSubview(imageView)
        
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell selected at indexPath: \(indexPath)")
        prints()
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 73, height: 73)
    }
    
}
