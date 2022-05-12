//
//  RandomImageViewController.swift
//  RandomImage
//
//  Created by Павел Галкин on 05.05.2022.
//

import UIKit
import CoreData

let colorButton = UIColor(red: 0.92, green: 0.07, blue: 0.56, alpha: 1.00)

class RandomImageViewController: UIViewController {
    
//Инициализация параметров
    let randomImage: UIImageView = {
        let imageView = UIImageView(image: .none)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
     
    var presenter: RandomImagePresenterProtocol!
    
    var timer: Timer?
    
    var secondsRemaining = 5
    
    let randomImageCreatedAtLabel: UILabel = {
        let randomImageCreatedAtLabel = UILabel()
        return randomImageCreatedAtLabel
    }()
    let randomImageWidthLabel: UILabel = {
        let randomImageWidthLabel = UILabel()
        return randomImageWidthLabel
    }()
    let randomImageHeightLabel: UILabel = {
        let randomImageHeightLabel = UILabel()
        return randomImageHeightLabel
    }()
    let randomImageColorLabel: UILabel = {
        let randomImageColorLabel = UILabel()
        return randomImageColorLabel
    }()
    let randomImageUserOwnerLabel: UILabel = {
        let randomImageUserOwnerLabel = UILabel()
        return randomImageUserOwnerLabel
    }()
    
    let addToFavoriteimagesButton: UIButton = {
        let loginButton = UIButton(type: .roundedRect)
        loginButton.setTitle("Добавить в избранное", for: .normal)
        loginButton.backgroundColor = colorButton
        loginButton.tintColor = .black
        loginButton.layer.cornerRadius = 15.0
        return loginButton
    }()
    
    let timerLabel: UILabel = {
        let timerLabel = UILabel()
        timerLabel.textAlignment = .center
        return timerLabel
    }()
    
    var imageInfoId: String? = .none
    
    let color = UIColor(red: 0.01, green: 0.69, blue: 0.93, alpha: 1.00)
    
//Основной вид
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = color
        
        configureSecondsRemainingText(secondsRemaining: secondsRemaining)
        
        self.view.addSubview(randomImage)
        self.view.addSubview(timerLabel)
        self.view.addSubview(randomImageCreatedAtLabel)
        self.view.addSubview(randomImageWidthLabel)
        self.view.addSubview(randomImageHeightLabel)
        self.view.addSubview(randomImageColorLabel)
        self.view.addSubview(randomImageUserOwnerLabel)
        self.view.addSubview(addToFavoriteimagesButton)
        
        self.navigationController?.navigationBar.backgroundColor = color
        self.navigationController?.navigationBar.tintColor = colorButton
        let favoriteButton = UIBarButtonItem(title: "Избранное", style: .plain, target: self, action: #selector(willOpenFavoriteImages))
        favoriteButton.tintColor = colorButton
        self.navigationItem.rightBarButtonItem = favoriteButton
        self.navigationItem.backButtonTitle = "Главный экран"
        self.navigationItem.titleView = timerLabel
        self.navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        
        self.addToFavoriteimagesButton.addTarget(self, action: #selector(didTapAddToFavoritesButton), for: .touchUpInside)
        
        getRandomImage()

    }

//Добавление в избранное
    @objc func willOpenFavoriteImages() {
        navigationController?.pushViewController(FavoriteImagesViewController(), animated: true)
    }
    
    @objc func didTapAddToFavoritesButton(sender: UIButton!){
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDelegate.context
        let newFavoriteImage = FavoriteImage(context: context)
        
        if let infoId = imageInfoId {
            
            let fetch = NSFetchRequest<FavoriteImage>(entityName: "FavoriteImage")
            let predicate = NSPredicate(format: "id = %@", argumentArray: [infoId])
            //указываем состояние
            fetch.predicate = predicate
            do {
              let result = try context.fetch(fetch)
                if result.isEmpty {
                    newFavoriteImage.id = infoId
                    appDelegate.saveContext()
                    print(infoId)
                    let alert = UIAlertController(title: "", message: "Добавлено в избранное", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "", message: "Изображение уже в избранном", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            } catch {
                print("ОШИБКА")
            }
        }
        
        

    }
    
//расположение Subview
    override func viewWillLayoutSubviews() {
        anchorsConfiguration()
    }
    
    
//Привязка описания Image
    func anchorsConfiguration() {
        randomImage.translatesAutoresizingMaskIntoConstraints = false
        randomImage.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        randomImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        randomImage.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true
        randomImage.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -200).isActive = true
        
        addToFavoriteimagesButton.translatesAutoresizingMaskIntoConstraints = false
        addToFavoriteimagesButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        addToFavoriteimagesButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        addToFavoriteimagesButton.topAnchor.constraint(equalTo: self.randomImage.bottomAnchor, constant: 16).isActive = true
        
        randomImageCreatedAtLabel.translatesAutoresizingMaskIntoConstraints = false
        randomImageCreatedAtLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        randomImageCreatedAtLabel.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        randomImageCreatedAtLabel.topAnchor.constraint(equalTo: self.addToFavoriteimagesButton.bottomAnchor, constant: 8).isActive = true
        
        randomImageWidthLabel.translatesAutoresizingMaskIntoConstraints = false
        randomImageWidthLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        randomImageWidthLabel.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        randomImageWidthLabel.topAnchor.constraint(equalTo: self.randomImageCreatedAtLabel.bottomAnchor, constant: 8).isActive = true
        
        randomImageHeightLabel.translatesAutoresizingMaskIntoConstraints = false
        randomImageHeightLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        randomImageHeightLabel.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        randomImageHeightLabel.topAnchor.constraint(equalTo: self.randomImageWidthLabel.bottomAnchor, constant: 8).isActive = true
        
        randomImageColorLabel.translatesAutoresizingMaskIntoConstraints = false
        randomImageColorLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        randomImageColorLabel.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        randomImageColorLabel.topAnchor.constraint(equalTo: self.randomImageHeightLabel.bottomAnchor, constant: 8).isActive = true
        
        randomImageUserOwnerLabel.translatesAutoresizingMaskIntoConstraints = false
        randomImageUserOwnerLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        randomImageUserOwnerLabel.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        randomImageUserOwnerLabel.topAnchor.constraint(equalTo: self.randomImageColorLabel.bottomAnchor, constant: 8).isActive = true
    }
    
//Таймер
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
        secondsRemaining = 6
    }
    
    func createTimer() {
        if timer == nil {
            let timer = Timer.scheduledTimer(
                timeInterval: 1.0,
                target: self,
                selector: #selector(updateTimer),
                userInfo: nil,
                repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.1
            self.timer = timer
        }
    }
    
    @objc func updateTimer() {
        if secondsRemaining > 0 {
            secondsRemaining -= 1
            configureSecondsRemainingText(secondsRemaining: secondsRemaining)
        } else {
            cancelTimer()
            getRandomImage()
        }
    }
    
    func configureSecondsRemainingText(secondsRemaining: Int){
        let minutes = Int(secondsRemaining) / 60 % 60
        let seconds = Int(secondsRemaining) % 60
        
        var times: [String] = []
        if minutes > 0 {
          times.append("\(minutes)m")
        }
        times.append("\(seconds)s")
        
        timerLabel.text = times.joined(separator: " ")

        print(times.joined(separator: " "))
    }

}

//Протоколы
extension RandomImageViewController: RandomImageViewProtocol {
    
    func successGetingRandomImage(image: ImageInfo) {
        let url = URL(string: image.urls.regular)!
        if let data = try? Data(contentsOf: url) {
            DispatchQueue.main.async {
                self.randomImage.image = UIImage(data: data)
            }
        }
        self.randomImageUserOwnerLabel.text = "Создатель: \(image.user.name)"
        self.randomImageColorLabel.text = "Цвет: \(image.color)"
        self.randomImageHeightLabel.text = "Высота: \(image.height)"
        self.randomImageWidthLabel.text = "Ширина: \(image.width)"
        self.imageInfoId = image.id
        
        //Получил строку преобразовал ее в дату
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        let date = dateFormatter.date(from: image.created_at)

        //Получил преобразованную дату и хочу ее в строку
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "EEEE, MMM d, yyyy"
        let dateString = dateFormatter2.string(from: date!)
        self.randomImageCreatedAtLabel.text = "Дата создания: \(dateString)"
 
    }
    
    func failureGettingrandomImage(error: Error) {
        print(error.localizedDescription)
        
    }
    
    func getRandomImage() {
        presenter.getRandomImage()
        createTimer()
    }
    
}
