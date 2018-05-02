//
//  ViewController.swift
//  Test20
//
//  Created by paresh on 11/02/1940 Saka.
//  Copyright © 1940 Saka paresh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblTimer: UITableView!
    var queue = DispatchQueue(label: "Timer", qos: .background, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.never, target: nil)
    var arrTimer:[CountDown] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1..<15
        {
            let time = CountDown()
            time.counter = 0
            time.isTimeron = false
            time.totaltime = 10 * i
            if i == 4
            {
                time.totaltime = 10
            }
            self.arrTimer.append(time)
            
        }
        tblTimer.reloadData()
        tblTimer.register(UINib(nibName: "cellTImer", bundle: nil), forCellReuseIdentifier: "cellTImer")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return arrTimer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTImer", for: indexPath) as! cellTImer
        let shared = self.arrTimer[indexPath.row]
//        if !shared.isTimeron{
//            cell.queue.async(execute: {
//                let currentRuploop = RunLoop.current
//               cell.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.timer), userInfo:nil, repeats: true)
//                currentRuploop.add(cell.timer!, forMode: .commonModes)
//                currentRuploop.run()
//            })
//
//        }
        if shared.isFinishaed{
            shared.timer?.invalidate()
        }
        
        
        if !shared.isTimeron{
            shared.isTimeron = true
            self.queue.async(execute: {
            let currentRuploop = RunLoop.current
            shared.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in

                if shared.counter >= shared.totaltime
                {
                    shared.timer?.invalidate()
                    shared.timer = nil
                    DispatchQueue.main.async {
//                        self.tblTimer.beginUpdates()
//                        self.arrTimer.remove(at: indexPath.row)
//                        self.tblTimer.deleteRows(at: [indexPath], with: .fade)
//                        self.tblTimer.endUpdates()
                    }
                    shared.isFinishaed = true
                    
                }
                else{
                    shared.counter += 1
                    DispatchQueue.main.async {
                        cell.lblCounter.text = "\(shared.counter)"
                    }
                }
            })
            currentRuploop.add(shared.timer!, forMode: .commonModes)
            currentRuploop.run()
            })
        }
        
        return cell
    }
    
    @objc func timer(timer: Timer)
    {
        
        DispatchQueue.main.async {
        let indexPatharray = self.tblTimer.indexPathsForVisibleRows
        
        
        
        for index in indexPatharray!
        {
            if let cell = self.tblTimer.cellForRow(at: index) as? cellTImer
            {
                if (self.arrTimer[index.row].totaltime * self.arrTimer.count) <= self.arrTimer[index.row].counter{
                    self.arrTimer[index.row].isFinishaed = true
                    self.tblTimer.beginUpdates()
                    self.arrTimer.remove(at: index.row)
                    self.tblTimer.deleteRows(at: [index], with: .fade)
                    self.tblTimer.endUpdates()
                }
                else{
                    var count = self.arrTimer[index.row].counter
                    count += 1
                    self.arrTimer[index.row].counter = count
                    if !self.arrTimer[index.row].isFinishaed{
                        cell.lblCounter.text = "\(count / self.arrTimer.count)"
                    }
                }
            }
            
        }
        }
    }

}

class CountDown : NSObject{
    var timer: Timer?
    
    var counter: Int = 0
    
    var isTimeron:Bool = false
    var totaltime : Int = 0
    var isFinishaed : Bool = false
}




