//
//  FavoriteImagesViewController.swift
//  RandomImage
//
//  Created by Павел Галкин on 05.05.2022.
//

import UIKit
import CoreData

class FavoriteImagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    var objects = [String]()
    let networkService = NetworkService.shared
    let fetchRequest: NSFetchRequest<FavoriteImage> = FavoriteImage.fetchRequest()
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    var collectionView: UICollectionView?
    var lpgr:UILongPressGestureRecognizer?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        let context = appDelegate.context
        updateData(context: context)
        // регистрация классов ячеек
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: (view.frame.width/2)-3, height: (view.frame.height/3)-4)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else {return}
        collectionView.register(FavoriteImagesViewCell.self, forCellWithReuseIdentifier: FavoriteImagesViewCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
     
        setupLongGestureRecognizerOnCollection()
    }
    
    func updateData(context: NSManagedObjectContext) {
        objects = [String]()
        do {
            let fetchedObjects =  try context.fetch(fetchRequest)
            for image in fetchedObjects {
                if let id = image.id {
                    objects.append(id)
                }
            }
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteImagesViewCell.identifier, for: indexPath) as! FavoriteImagesViewCell
        let currentImageId = objects[indexPath.row]
        
        networkService.getImage(id: currentImageId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    let url = URL(string: image!.urls.regular)!
                    if let data = try? Data(contentsOf: url) {
                        cell.favoriteImageView.image = UIImage(data: data)
                        print("image was downloaded")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let presentedController = SelectedFavoriteImageViewController()
        presentedController.imageId = objects[indexPath.row]
        present(presentedController, animated: true)
    }
    
    private func setupLongGestureRecognizerOnCollection() {
        lpgr = UILongPressGestureRecognizer(target: self, action: #selector(triggerDeleteAction))
        if let lpgr = lpgr {
            lpgr.minimumPressDuration = 1
            lpgr.delaysTouchesBegan = true
            lpgr.delegate = self
            if let collectionView = collectionView {
                collectionView.addGestureRecognizer(lpgr)
            }
        }
    }
    
    @objc private func triggerDeleteAction() {
        if let lpgr = lpgr {
            let point = lpgr.location(in: self.collectionView)
            let alert = UIAlertController(title: "Удалить изображение?", message: "Нажмите \"Удалить\" чтобы удалить изображение", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
                if let lpgr = self.lpgr {
                    self.deleteImageFromDB(gestureReconizer: lpgr, point: point)
                }
            }))
            alert.addAction(UIAlertAction(title: "Возврат", style: .cancel, handler: { _ in
                print("return")
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func deleteImageFromDB(gestureReconizer: UILongPressGestureRecognizer, point: CGPoint) {
        guard gestureReconizer.state != .began else { return }

        if let collectionView = self.collectionView {
            let indexPath = collectionView.indexPathForItem(at: point)
            if let index = indexPath{
                print(objects[index.row])
                let context = appDelegate.context
                do {
                    let fetchedObjects =  try context.fetch(fetchRequest)
                    for image in fetchedObjects {
                        if String(objects[index.row]) == image.id {
                            context.delete(image)
                            do {
                                try context.save()
                            } catch {
                                let nserror = error as NSError
                                fatalError("Unresolved error \(nserror)")
                            }
                        }
                    }
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror)")
                }
                print("delete object")
                updateData(context: context)
                collectionView.reloadData()
            }
            else{
                print("Could not find index path")
            }
        }
    }
    
}
