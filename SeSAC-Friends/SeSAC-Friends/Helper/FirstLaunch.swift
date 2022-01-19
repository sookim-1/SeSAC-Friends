//
//  FirstLaunch.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/20.
//

import Foundation

final class FirstLaunch {

    let wasLaunchedBefore: Bool
    var isFirstLaunch: Bool {
        return !wasLaunchedBefore
    }

    init(getLaunchedFlag: () -> Bool, setLaunchedFlag: (Bool) -> ())
    {
        self.wasLaunchedBefore = getLaunchedFlag()

        if !wasLaunchedBefore {
            setLaunchedFlag(true)
        }
    }

    convenience init(userDefaults: UserDefaults, key: String) {
        self.init(getLaunchedFlag: { userDefaults.bool(forKey: key) },
                  setLaunchedFlag: { userDefaults.set($0, forKey: key) })
    }

}
