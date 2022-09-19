//
//  PageController.swift
//  EateriesApp
//
//  Created by admin on 24.08.2022.
//

import UIKit

class PageController: UIPageViewController {
    
    var headersArray = ["Записывайте", "Находите"]
    var subheaderArray = ["Создайте свой список любимых ресторанов","Найдите и отметьте на карте ваши любимые рестораны"]
    var imagesArray = ["food", "iphoneMap"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //объявляем, что dataSource будем выполнять сами (в extension)
        dataSource = self
        
        //говорим, какой contentViewController загружать первым
        if let firstVC = displayViewController(atIndex: 0){
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func displayViewController(atIndex index: Int) -> ContentController? {
        //ContentController возвращаем в переделах от 0 до headersArray.count не включая его
        guard index >= 0 else { return nil }
        guard index < headersArray.count else { return nil }
        //создаем contentViewController с помощью кода
        guard let contentVC = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentController else { return nil }
        
        //передаем в переменные данные из массива
        contentVC.header = headersArray[index]
        contentVC.subheader = subheaderArray[index]
        contentVC.imageFile = imagesArray[index]
        contentVC.index = index
        
        return contentVC
    }
    
    func nextVC(atIndex index: Int) {
        if let contentVC = displayViewController(atIndex: index + 1) {
            setViewControllers([contentVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

//говорит ViewController откуда брать информацию
extension PageController: UIPageViewControllerDataSource {
    //как должен меняться индекс, когда листаем Page вперед
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentController).index
        index -= 1
        return displayViewController(atIndex: index)
    }
    
    //как должен меняться индекс, когда листаем Page назад
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentController).index
        index += 1
        return displayViewController(atIndex: index)
    }
}
