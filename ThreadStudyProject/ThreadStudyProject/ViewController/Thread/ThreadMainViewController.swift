//
//  ThreadMainViewController.swift
//  ThreadStudyProject
//
//  Created by JH on 22/11/2019.
//  Copyright © 2019 JH. All rights reserved.
//

import UIKit

/**
 라면 끓이는 세션에 버너가 네개가 있다면
 스레드도 네개를 만들어서 라면이 최대 네개가 끓여지도록 프로그래밍 해보자!
 https://www.youtube.com/watch?v=iks_Xb9DtTM&t=73s
 */
class ThreadMainViewController: UIViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ramenPrograme()
    }
    
    func ramenPrograme() {
        let rameCook: RamenCook = RamenCook(count: 10)
        let a = Thread(target: rameCook, selector: #selector(rameCook.run(name:)), object: "A")
        let b = Thread(target: rameCook, selector: #selector(rameCook.run(name:)), object: "B")
        let c = Thread(target: rameCook, selector: #selector(rameCook.run(name:)), object: "C")
        let d = Thread(target: rameCook, selector: #selector(rameCook.run(name:)), object: "D")
        a.start()
        b.start()
        c.start()
        d.start()
    }
}


class RamenCook: NSObject {
    
    private var ramenCount: Int // 라면의 갯수
    private var burners: [String] = ["_", "_", "_", "_"] // 버너의 상태
    
    init(count: Int) { // 끓일 라면의 수
        ramenCount = count
    }
 
    @objc
    func run(name: String) {
        while ramenCount > 0 {
            synced(self) {
                // 라면을 하나 집어가며 ramenCount를 하나 줄임
                self.ramenCount -= 1
                print("\(name) : \(self.ramenCount)개 남음")
                
                // 열거형 함수 활용 enumerate
                guard let activeBurners = burners.enumerated().filter({ (index, burner) -> Bool in
                    burner == "_"
                }).first else { return }
                
                // 빈 버너를 찾고 불을 켜요!
                burners[activeBurners.offset] = name
                print("\(name) : [ \(activeBurners.offset+1) ] 버너 on")
                self.showBurners()
            }
            
            // 해당 스레드를 일정시간 정지
            // 라면 끓일 시간 필요
            Thread.sleep(forTimeInterval: 2)
            
            synced(self) {
                guard let activeBurners = burners.enumerated().filter({$0.element == name}).first else { return }
                
                // 라면을 다 끓인 버너는 비워야합니다
                burners[activeBurners.offset] = "_"
                print("\(name) : [ \(activeBurners.offset + 1) ] 번 버너 off")
                showBurners()
            }
            
            Thread.sleep(forTimeInterval: drand48())
        }
        
    }
    
    private func showBurners() {
        var stringToPring: String = ""
        for str in burners {
           stringToPring += " " + str
        }
        print(stringToPring)
    }
    
    private func synced(_ lock: RamenCook, closure: () -> ()) {
        defer {
            objc_sync_exit(lock)
        }
        objc_sync_enter(lock)
        closure()
    }
}
