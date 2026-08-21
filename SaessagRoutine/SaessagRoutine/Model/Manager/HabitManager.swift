//
//  HabitManager.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/20/26.
//

import UIKit

class HabitManager {
    static let shared = HabitManager()//전역에 공유하겠다는 뜻
    private init() {}//다른 파일에서 인스턴스를 생성 할 수 없게 만드는 거
    
    var totalHabits: Int = 0
    var didHabits: Int = 0
}
