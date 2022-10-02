//
//  JapaneseNationalHoliday.swift
//  UCalendarView
//
//  Created by Tomohiro Uchida on 2022/10/02.
//

import Foundation
import SwiftUI


public class JapaneseNationalHoliday {
    
    let bundle = Bundle(identifier: "com.jimdo.uchida001tmhr.UCalendarView")

    public class Holiday {
        var isHoliday: Bool = false
        var holidayName: String = ""
    }

    private func getGanjitsu(date: Date) -> Holiday {
        let holiday = Holiday()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date.resetTime())
        let month = calendar.component(.month, from: date.resetTime())
        let day = calendar.component(.day, from: date.resetTime())

        if (year >= 2014) && (month == 1) && (day == 1) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("ganjitsu", bundle: bundle!, comment: "")
            return holiday;
        } else {
            holiday.isHoliday = false
            holiday.holidayName = ""
            return holiday
        }
    }

    private func getSeijin_no_hi(date: Date) -> Holiday {
        let holiday = Holiday()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date.resetTime())
        let month = calendar.component(.month, from: date.resetTime())
        let weekOfMonth = calendar.component(.weekdayOrdinal, from: date.resetTime())
        let weekday = calendar.component(.weekday, from: date.resetTime())

        if (year >= 2014) && (month == 1) && (weekOfMonth == 2) && (weekday == 2) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("seijin_no_hi", bundle: bundle!, comment: "")
            return holiday;
        } else {
            holiday.isHoliday = false
            holiday.holidayName = ""
            return holiday
        }
    }

    private func getKenkokukinen_no_hi(date: Date) -> Holiday {
        let holiday = Holiday()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date.resetTime())
        let month = calendar.component(.month, from: date.resetTime())
        let day = calendar.component(.day, from: date.resetTime())

        if (year >= 2014) && (month == 2) && (day == 11) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("kenkokukinen_no_hi", bundle: bundle!, comment: "")
            return holiday;
        } else {
            holiday.isHoliday = false
            holiday.holidayName = ""
            return holiday
        }
    }

    private func getSyunbun_no_hi(date: Date) -> Holiday {
        let holiday = Holiday()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date.resetTime())
        let month = calendar.component(.month, from: date.resetTime())
        let day = calendar.component(.day, from: date.resetTime())

        if (year >= 2014) && (month == 3) && (day == getSyunbunbi(date: date)) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("syunbun_no_hi", bundle: bundle!, comment: "")
            return holiday;
        } else {
            holiday.isHoliday = false
            holiday.holidayName = ""
            return holiday
        }
    }

    private func getSyunbunbi(date: Date) -> Int {
        // 2000年以降の春分日を計算
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date.resetTime())
        let syunbun: Int = Int(Double(20.69115) + (Double(year - 2000)*0.242194) - Double(Int((Double(year - 2000)/Double(4)))))
        return syunbun
    }

    private func getShowa_no_hi(date: Date) -> Holiday {
        let holiday = Holiday()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date.resetTime())
        let month = calendar.component(.month, from: date.resetTime())
        let day = calendar.component(.day, from: date.resetTime())

        if (year >= 2014) && (month == 4) && (day == 29) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("showa_no_hi", bundle: bundle!, comment: "")
            return holiday;
        } else {
            holiday.isHoliday = false
            holiday.holidayName = ""
            return holiday
        }
    }

    private func getSokui_no_hi(date: Date) -> Holiday {
        let holiday = Holiday()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date.resetTime())
        let month = calendar.component(.month, from: date.resetTime())
        let day = calendar.component(.day, from: date.resetTime())

        if (year == 2019) && (month == 5) && (day == 1) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("sokui_no_hi", bundle: bundle!, comment: "")
            return holiday;
        } else {
            holiday.isHoliday = false
            holiday.holidayName = ""
            return holiday
        }
    }

    private func getKenpokinenbi(date: Date) -> Holiday {
        let holiday = Holiday()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date.resetTime())
        let month = calendar.component(.month, from: date.resetTime())
        let day = calendar.component(.day, from: date.resetTime())

        if (year >= 2014) && (month == 5) && (day == 3) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("kenpokinenbi", bundle: bundle!, comment: "")
            return holiday;
        } else {
            holiday.isHoliday = false
            holiday.holidayName = ""
            return holiday
        }
    }

    private func getMidori_no_hi(date: Date) -> Holiday {
        let holiday = Holiday()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date.resetTime())
        let month = calendar.component(.month, from: date.resetTime())
        let day = calendar.component(.day, from: date.resetTime())

        if (year >= 2014) && (month == 5) && (day == 4) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("kenpokinenbi", bundle: bundle!, comment: "")
            return holiday;
        } else {
            holiday.isHoliday = false
            holiday.holidayName = ""
            return holiday
        }
    }

    private func getKodomo_no_hi(date: Date) -> Holiday {
        let holiday = Holiday()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date.resetTime())
        let month = calendar.component(.month, from: date.resetTime())
        let day = calendar.component(.day, from: date.resetTime())

        if (year >= 2014) && (month == 5) && (day == 5) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("kenpokinenbi", bundle: bundle!, comment: "")
            return holiday;
        } else {
            holiday.isHoliday = false
            holiday.holidayName = ""
            return holiday
        }
    }

    private func getUmi_no_hi(date: Date) -> Holiday {
        let holiday = Holiday()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date.resetTime())
        let month = calendar.component(.month, from: date.resetTime())
        let day = calendar.component(.day, from: date.resetTime())
        let weekOfMonth = calendar.component(.weekdayOrdinal, from: date.resetTime())
        let weekday = calendar.component(.weekday, from: date.resetTime())

        if (year == 2021) && (month == 6) && (day == 22) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("umi_no_hi", bundle: bundle!, comment: "")
            return holiday;
        } else if (year == 2020) && (month == 6) && (day == 23) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("umi_no_hi", bundle: bundle!, comment: "")
            return holiday;
        } else if (year >= 2014) && (year != 2021) && (year != 2020) && (month == 6) && (weekOfMonth == 3) && (weekday == 2) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("umi_no_hi", bundle: bundle!, comment: "")
            return holiday;
        } else {
            holiday.isHoliday = false
            holiday.holidayName = ""
            return holiday
        }
    }

    private func getYama_no_hi(date: Date) -> Holiday {
        let holiday = Holiday()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date.resetTime())
        let month = calendar.component(.month, from: date.resetTime())
        let day = calendar.component(.day, from: date.resetTime())

        if (year == 2021) && (month == 8) && (day == 8) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("yama_no_hi", bundle: bundle!, comment: "")
            return holiday;
        } else if (year == 2020) && (month == 8) && (day == 10) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("yama_no_hi", bundle: bundle!, comment: "")
            return holiday;
        } else if (year >= 2014) && (year != 2021) && (year != 2020) && (month == 6) && (month == 8) && (day == 11) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("yama_no_hi", bundle: bundle!, comment: "")
            return holiday;
        } else {
            holiday.isHoliday = false
            holiday.holidayName = ""
            return holiday
        }
    }

    private func getKeiro_no_hi(date: Date) -> Holiday {
        let holiday = Holiday()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date.resetTime())
        let month = calendar.component(.month, from: date.resetTime())
        let weekOfMonth = calendar.component(.weekdayOrdinal, from: date.resetTime())
        let weekday = calendar.component(.weekday, from: date.resetTime())

        if (year >= 2014) && (month == 9) && (weekOfMonth == 3) && (weekday == 2) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("keiro_no_hi", bundle: bundle!, comment: "")
            return holiday;
        } else {
            holiday.isHoliday = false
            holiday.holidayName = ""
            return holiday
        }
    }

    private func getSyubun_no_hi(date: Date) -> Holiday {
        let holiday = Holiday()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date.resetTime())
        let month = calendar.component(.month, from: date.resetTime())
        let day = calendar.component(.day, from: date.resetTime())

        if (year >= 2014) && (month == 9) && (day == getSyubunbi(date: date)) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("syubun_no_hi", bundle: bundle!, comment: "")
            return holiday;
        } else {
            holiday.isHoliday = false
            holiday.holidayName = ""
            return holiday
        }
    }

    private func getSyubunbi(date: Date) -> Int {
        // 2000年以降の春分日を計算
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date.resetTime())
        let syubun: Int = Int(Double(23.09) + (Double(year - 2000)*Double(0.242194)) - Double(Int((Double(year - 2000)/Double(4)))))
        return syubun
    }
    
    
    private func getSport_no_hi(date: Date) -> Holiday {
        let holiday = Holiday()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date.resetTime())
        let month = calendar.component(.month, from: date.resetTime())
        let day = calendar.component(.day, from: date.resetTime())
        let weekOfMonth = calendar.component(.weekdayOrdinal, from: date.resetTime())
        let weekday = calendar.component(.weekday, from: date.resetTime())

        if (year >= 2022) && (month == 10) && (weekOfMonth == 2) && (weekday == 2) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("sport_no_hi", bundle: bundle!, comment: "")
            return holiday;
        } else if (year == 2021) && (month == 7) && (day == 23) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("sport_no_hi", bundle: bundle!, comment: "")
            return holiday;
        } else if (year == 2020) && (month == 7) && (day == 24) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("sport_no_hi", bundle: bundle!, comment: "")
            return holiday;
        } else if (2014 <= year) && (year <= 2019) && (year != 2021) && (year != 2020) && (month == 10) && (weekOfMonth == 2) && (weekday == 2) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("taiiku_no_hi", bundle: bundle!, comment: "")
            return holiday;
        } else {
            holiday.isHoliday = false
            holiday.holidayName = ""
            return holiday
        }
    }

    private func getSokui_reiseiden_no_hi(date: Date) -> Holiday {
        let holiday = Holiday()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date.resetTime())
        let month = calendar.component(.month, from: date.resetTime())
        let day = calendar.component(.day, from: date.resetTime())

        if (year == 2019) && (month == 10) && (day == 22) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("sokui_reiseiden_no_hi", bundle: bundle!, comment: "")
            return holiday;
        } else {
            holiday.isHoliday = false
            holiday.holidayName = ""
            return holiday
        }
    }
    
    private func getBunka_no_hi(date: Date) -> Holiday {
        let holiday = Holiday()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date.resetTime())
        let month = calendar.component(.month, from: date.resetTime())
        let day = calendar.component(.day, from: date.resetTime())

        if (year >= 2014) && (month == 11) && (day == 3) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("bunka_no_hi", bundle: bundle!, comment: "")
            return holiday;
        } else {
            holiday.isHoliday = false
            holiday.holidayName = ""
            return holiday
        }
    }

    private func getKinrokansya_no_hi(date: Date) -> Holiday {
        let holiday = Holiday()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date.resetTime())
        let month = calendar.component(.month, from: date.resetTime())
        let day = calendar.component(.day, from: date.resetTime())

        if (year >= 2014) && (month == 11) && (day == 23) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("kinrokansya_no_hi", bundle: bundle!, comment: "")
            return holiday;
        } else {
            holiday.isHoliday = false
            holiday.holidayName = ""
            return holiday
        }
    }

    private func getTennotanjobi(date: Date) -> Holiday {
        let holiday = Holiday()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date.resetTime())
        let month = calendar.component(.month, from: date.resetTime())
        let day = calendar.component(.day, from: date.resetTime())

        let date20190501 = calendar.date(from: DateComponents(year: 2019, month: 5, day: 1))!.resetTime()
        if (date20190501 <= date) {
            if (month == 2) && (day == 23) {
                holiday.isHoliday = true
                holiday.holidayName = NSLocalizedString("tennotanjobi", bundle: bundle!, comment: "")
                return holiday;
            } else {
                holiday.isHoliday = false
                holiday.holidayName = ""
                return holiday
            }
        } else if (year >= 2014) && (month == 12) && (day == 23) {
            holiday.isHoliday = true
            holiday.holidayName = NSLocalizedString("tennotanjobi", bundle: bundle!, comment: "")
            return holiday;
        } else {
            holiday.isHoliday = false
            holiday.holidayName = ""
            return holiday
        }
    }

    private func getRestrictHoliday(date: Date) -> Holiday {
        var holiday = Holiday()

        holiday = getGanjitsu(date: date)
        if (holiday.isHoliday) {
            return holiday
        }
        holiday = getSeijin_no_hi(date: date)
        if (holiday.isHoliday) {
            return holiday
        }
        holiday = getKenkokukinen_no_hi(date: date)
        if (holiday.isHoliday) {
            return holiday
        }
        holiday = getSyunbun_no_hi(date: date)
        if (holiday.isHoliday) {
            return holiday
        }
        holiday = getShowa_no_hi(date: date)
        if (holiday.isHoliday) {
            return holiday
        }
        holiday = getSokui_no_hi(date: date)
        if (holiday.isHoliday) {
            return holiday
        }
        holiday = getKenpokinenbi(date: date)
        if (holiday.isHoliday) {
            return holiday
        }
        holiday = getMidori_no_hi(date: date)
        if (holiday.isHoliday) {
            return holiday
        }
        holiday = getKodomo_no_hi(date: date)
        if (holiday.isHoliday) {
            return holiday
        }
        holiday = getUmi_no_hi(date: date)
        if (holiday.isHoliday) {
            return holiday
        }
        holiday = getYama_no_hi(date: date)
        if (holiday.isHoliday) {
            return holiday
        }
        holiday = getKeiro_no_hi(date: date)
        if (holiday.isHoliday) {
            return holiday
        }
        holiday = getSyubun_no_hi(date: date)
        if (holiday.isHoliday) {
            return holiday
        }
        holiday = getSport_no_hi(date: date)
        if (holiday.isHoliday) {
            return holiday
        }
        holiday = getSokui_reiseiden_no_hi(date: date)
        if (holiday.isHoliday) {
            return holiday
        }
        holiday = getBunka_no_hi(date: date)
        if (holiday.isHoliday) {
            return holiday
        }
        holiday = getKinrokansya_no_hi(date: date)
        if (holiday.isHoliday) {
            return holiday
        }
        holiday = getTennotanjobi(date: date)
        if (holiday.isHoliday) {
            return holiday
        }

        holiday.isHoliday = false
        holiday.holidayName = ""

        return holiday;

    }

    private func getFurikae_kyujitsu(date: Date) -> Holiday {
        var holiday = Holiday()
        let calendar = Calendar(identifier: .gregorian)
        
        var date1 = date.resetTime()

        repeat {
            date1 = calendar.date(byAdding: .day, value: -1, to: date1)!
            holiday = getRestrictHoliday(date: date1)
            if holiday.isHoliday && calendar.component(.weekday, from: date1) == 1 {
                holiday.holidayName = NSLocalizedString("furikae_kyujitsu", bundle: bundle!, comment: "")
                return holiday
            }
        } while (holiday.isHoliday)

        holiday.isHoliday = false
        holiday.holidayName = ""

        return holiday;

    }

    private func getKokumin_no_kyujitsu(date: Date) -> Holiday {
        let holiday = Holiday()
        let calendar = Calendar(identifier: .gregorian)

        let dateYesterday = calendar.date(byAdding: .day, value: -1, to: date.resetTime())
        let dateTomorrow = calendar.date(byAdding: .day, value: 1, to: date.resetTime())

        let holidayYesterday = getRestrictHoliday(date: dateYesterday!)
        let holidayTomorrow = getRestrictHoliday(date: dateTomorrow!)
        
        if (holidayYesterday.isHoliday && holidayTomorrow.isHoliday) {
            holiday.isHoliday = true;
            holiday.holidayName = NSLocalizedString("kokumin_no_kyujitsu", bundle: bundle!, comment: "")
            return holiday;
        }

        holiday.isHoliday = false
        holiday.holidayName = ""

        return holiday;

    }

    public func getHoliday(date: Date) -> Holiday {
        var holiday = Holiday()

        /*
        @Environment(\.locale) var locale
        if (locale != Locale(identifier: "ja-JP")) {
            holiday.isHoliday = false
            holiday.holidayName = ""
            return holiday
        }
         */

        holiday = getRestrictHoliday(date: date);
        if (holiday.isHoliday) {
            return holiday
        }
        holiday = getFurikae_kyujitsu(date: date);
        if (holiday.isHoliday) {
            return holiday
        }
        holiday = getKokumin_no_kyujitsu(date: date);
        if (holiday.isHoliday) {
            return holiday
        }

        holiday.isHoliday = false;
        holiday.holidayName = "";

        return holiday;

    }

}
