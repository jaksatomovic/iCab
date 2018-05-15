//
//  PreviousController.swift
//  iCab
//
//  Created by Jaksa Tomovic on 10/05/2018.
//  Copyright © 2018 Jakša Tomović. All rights reserved.
//

import UIKit
import CoreData

class PreviousController: UIViewController {
    
    var tableView: UITableView = {
        var tv = UITableView()
        tv.backgroundColor = .white
        return tv
    }()
    
    var bookings = [Booking]()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.fillSuperview()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        fetchAllBookings()
    }
    
    private func fetchAllBookings() {
        
        let context = CoreDataManager.context

        let fetchRequest = NSFetchRequest<Booking>(entityName: "Booking")
        
        do {
            let bookings = try context.fetch(fetchRequest)
            for book in bookings {
                if book.status == "started" {
                    self.bookings.append(book)
                }
            }
            self.tableView.reloadData()
            
        } catch let fetchErr {
            print("Failed to fetch companies:", fetchErr)
        }
    }
    
}

extension PreviousController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = "\(bookings[indexPath.row].start ?? "") - \(bookings[indexPath.row].finish ?? "") "
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailController()
        vc.booking = self.bookings[indexPath.row]
        self.show(vc, sender: self)
    }
}
