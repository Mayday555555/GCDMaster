//
//  ViewController.swift
//  AboutGCD
//
//  Created by 陈铉泽 on 2019/3/12.
//  Copyright © 2019 陈铉泽. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var count = 0
    var timer: DispatchSourceTimer?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func synConcurrentAction(_ sender: Any) {
        self.syncConcurrent()
    }
    
    @IBAction func asyncConcurrentAction(_ sender: Any) {
        self.asyncConcurrent()
    }
    @IBAction func syncSerialAction(_ sender: Any) {
        self.syncSerial()
    }
    
    @IBAction func asyncSerialAction(_ sender: Any) {
        self.asyncSerial()
    }
    
    @IBAction func syncMainAction(_ sender: Any) {
//        self.syncMain()
                Thread.detachNewThread {[weak self] in
                    self?.syncMain()
                }
    }
    @IBAction func asyncMainAction(_ sender: Any) {
        self.asyncMain()
    }
    @IBAction func barrierAction(_ sender: Any) {
        self.barrier()
    }
    @IBAction func afterAction(_ sender: Any) {
        self.after()
    }
    @IBAction func timerResumeAction(_ sender: Any) {
        self.timerResume()
    }
    @IBAction func applyAction(_ sender: Any) {
        self.apply()
    }
    @IBAction func groupNofityAction(_ sender: Any) {
        self.groupNotify()
    }
    @IBAction func groupWaitAction(_ sender: Any) {
        self.groupWait()
    }
    
    @IBAction func semaphoreAction(_ sender: Any) {
        self.semaphore()
    }
    func method() {
        let mainQueue = DispatchQueue.main
        let globalQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        let customQueue = DispatchQueue(label: "哈哈", qos: .default, attributes: .concurrent)
        globalQueue.async {
            
        }
        
        globalQueue.sync {
            
        }
    }
    
    //MARK:同步执行 + 并发队列
    func syncConcurrent() {
        print("currentThread:\(Thread.current)")
        print("syncConcurrent--begin")
        
        let customQueue = DispatchQueue(label: "haha", qos: .default, attributes: .concurrent)
        customQueue.sync {
            //追加任务1
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("1--\(Thread.current)")
            }
        }
        
        customQueue.sync {
            //追加任务1
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("2--\(Thread.current)")
            }
        }
        
        customQueue.sync {
            //追加任务1
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("3--\(Thread.current)")
            }
        }
        
        print("syncConcurrent--end")
    }

    
    //MARK:异步执行 + 并发队列
    func asyncConcurrent() {
        print("currentThread:\(Thread.current)")
        print("asyncConcurrent--begin")
        
        let customQueue = DispatchQueue(label: "haha", qos: .default, attributes: .concurrent)

        customQueue.async {
            //追加任务1
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("1--\(Thread.current)")
            }
        }
        
        customQueue.async {
            //追加任务1
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("2--\(Thread.current)")
            }
        }
        
        customQueue.async {
            //追加任务1
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("3--\(Thread.current)")
            }
        }
        
        print("asyncConcurrent--end")
    }
    
    //MARK:同步执行 + 串行队列
    func syncSerial() {
        print("currentThread:\(Thread.current)")
        print("syncSerial--begin")
        
        let customQueue = DispatchQueue(label: "haha", qos: .default)
        customQueue.sync {
            //追加任务1
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("1--\(Thread.current)")
            }
        }
        
        customQueue.sync {
            //追加任务1
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("2--\(Thread.current)")
            }
        }
        
        customQueue.sync {
            //追加任务1
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("3--\(Thread.current)")
            }
        }
        
        print("syncSerial--end")
    }
    
    //MARK:异步执行 + 串行队列
    func asyncSerial() {
        print("currentThread:\(Thread.current)")
        print("asyncSerial--begin")
        
        let customQueue = DispatchQueue(label: "haha", qos: .default)
        
        customQueue.async {
            //追加任务1
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("1--\(Thread.current)")
            }
        }
        
        customQueue.async {
            //追加任务1
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("2--\(Thread.current)")
            }
        }
        
        customQueue.async {
            //追加任务1
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("3--\(Thread.current)")
            }
        }
        
        print("asyncSerial--end")
    }
    
    //MARK:同步执行 + 主队列（当前队列）
    func syncMain() {
        print("currentThread:\(Thread.current)")
        print("syncMain--begin")
        
        let mainQueue = DispatchQueue.main
        
        mainQueue.sync {
            //追加任务1
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("1--\(Thread.current)")
            }
        }
        
        mainQueue.sync {
            //追加任务1
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("2--\(Thread.current)")
            }
        }
        
        mainQueue.sync {
            //追加任务1
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("3--\(Thread.current)")
            }
        }
        
        print("syncMain--end")
        
        
        //当我们把任务1追加到主队列中，任务1就在等待主线程处理完syncMain任务。而syncMain任务需要等待任务1执行完毕，才能接着执行。
        
//        那么，现在的情况就是syncMain任务和任务1都在等对方执行完毕。这样大家互相等待，所以就卡住了
    }
    
    
    //MARK:异常步执行 + 主队列（当前队列）
    func asyncMain() {
        print("currentThread:\(Thread.current)")
        print("asyncMain--begin")
        
        let mainQueue = DispatchQueue.main
        
        mainQueue.async {
            //追加任务1
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("1--\(Thread.current)")
            }
        }
        
        mainQueue.async {
            //追加任务1
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("2--\(Thread.current)")
            }
        }
        
        mainQueue.async {
            //追加任务1
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("3--\(Thread.current)")
            }
        }
        
        print("asyncMain--end")
    }
    
    //MARK: 栅栏
    func barrier() {
        
        let customQueue = DispatchQueue(label: "haha", qos: .default, attributes: .concurrent)
        
        customQueue.async {
            //追加任务1
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("1--\(Thread.current)")
            }
        }
        
        customQueue.async {
            //追加任务2
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("2--\(Thread.current)")
            }
        }
        
        customQueue.async(flags: .barrier) {
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("barrier--\(Thread.current)")
            }
        }
        
        customQueue.async {
            //追加任务3
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("3--\(Thread.current)")
            }
        }
        
        customQueue.async {
            //追加任务4
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("4--\(Thread.current)")
            }
        }
        
    }
    
    //MARK:延时
    func after() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            print("2秒后执行")
        }
    }
    
    //MARK:定时器
    func timerResume() {
        self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer?.schedule(deadline: .now(), repeating: 1)
        timer?.setEventHandler {
            DispatchQueue.main.async {[weak self] in
                self?.timerCount()
            }
        }
        timer?.resume()
    }
    
    func timerCount() {
        self.count += 1
        print(self.count)
        if self.count == 10 {
            self.timer?.cancel()
        }
    }
    
    func once() {
        
    }
    
    //MARK:快速迭代
    func apply() {
        print("apply--begin")
        DispatchQueue.concurrentPerform(iterations: 6) { (index) in
            print("\(index),\(Thread.current)")
        }
        print("apply--end")
    }
    
    //MARK:队列组
    func groupNotify() {
        let group = DispatchGroup()
        let globalQueue = DispatchQueue.global(qos: .default)
        globalQueue.async(group: group, qos: .default, flags: DispatchWorkItemFlags(rawValue: 0)) {
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("1..\(Thread.current)")
            }
        }
        globalQueue.async(group: group, qos: .default, flags: DispatchWorkItemFlags(rawValue: 0)) {
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("2..\(Thread.current)")
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("3..\(Thread.current)")
            }
        }
        
    }
    
    func groupWait() {
        let group = DispatchGroup()
        print("groupBegin")
        let globalQueue = DispatchQueue.global(qos: .default)
        globalQueue.async(group: group, qos: .default, flags: DispatchWorkItemFlags(rawValue: 0)) {
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("1..\(Thread.current)")
            }
        }
        globalQueue.async(group: group, qos: .default, flags: DispatchWorkItemFlags(rawValue: 0)) {
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("2..\(Thread.current)")
            }
        }
        
        group.wait()
        
        print("groupEnd")
    }
    @IBAction func pushToViewController2(_ sender: Any) {
        let vc2 = ViewController2()
        self.present(vc2, animated: true) {
            
        }
    }
    
    //MARK:信号量
    func semaphore() {
        let queue = DispatchQueue.global(qos: .default)
        let semaphore = DispatchSemaphore(value: 1)
        for i in 0..<100 {
            queue.async {
                _ = semaphore.wait(timeout: DispatchTime.distantFuture)
                print("i=\(i)")
                semaphore.signal()
            }
        }
    }
}

