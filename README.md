# ⏰ Alarmy
세계시계, 알람, 스톱워치, 타이머 기능의 앱입니다. MVC(Model - View - Controller)를 적용한 iOS앱으로 시계앱과 유사한 UI/UX를 제공합니다.

</br>

# 📱 프로젝트 소개

### 프로젝트 이름
#### *Alarmy*

 </br>

### 와이어 프레임 
<img width="5532" height="3198" alt="알라미" src="https://github.com/user-attachments/assets/7ef7f76b-4051-44dc-9dab-1538e81db576" />

</br>

# 🖥️ 프로젝트 정보
- 개발 기간: 2025년 11월 04일 - 11월 12일 </br>
- 개발 환경: Xcode 16, iOS 16+, Swift 5</br>
- 팀 구성: iOS 개발자 3명</br>
- 아키텍처: MVC + CoreData</br>
- 상태: 프로토타입 완성 ✅</br>

</br>

# 🛠 시스템 프레임워크
- **SnapKit**: 코드 기반 오토 레이아웃 프레임워크


</br>

# 👤 팀원 소개
| 장우석   | 박혜연       | 변지혜      |
|-------------|--------------|-------------|
| <div align="center">[@oww10](https://github.com/oww10)</div> | <div align="center">[@104hyeon](https://github.com/104hyeon)</div>|<div align="center">[@munuiee](https://github.com/munuiee)</div> |

</br>

# 화면
| 세계시간   | 알람       | 스톱워치      | 타이머
|-------------|--------------|-------------|-------------|
|![세계시간](https://github.com/user-attachments/assets/65633804-47ed-462c-b65c-8eeebbbd95bd) | ![알람](https://github.com/user-attachments/assets/cde67e71-71e0-471d-b39c-ca946a57a15b) | ![스톱워치](https://github.com/user-attachments/assets/74dfb334-e8be-4e76-808c-cdedfeb5af51) | ![타이머](https://github.com/user-attachments/assets/d7bd304a-76f0-46d8-97c5-dd32388876bc) |


</br>

#  주요 기능
### 🕓 세계시간
- 도시 검색 및 추가: 전 세계 도시를 검색하여 목록에 추가할 수 있습니다.</br>

- 목록 관리: 사용자가 원하는 순서대로 도시 목록을 편집하거나 삭제할 수 있습니다. </br>

### ⏰ 알람
- 알람 생성 및 설정: 원하는 시간을 설정하여 새로운 알람을 추가할 수 있습니다. </br>

- 반복 및 레이블: 특정 요일 반복, 알람 레이블 지정을 할 수 있습니다. </br>

- 알람 활성화/비활성화: 스위치 토글을 통해 알람을 켜고 끌 수 있으며 설정된 정보는 CoreData를 통해 저장됩니다. </br>

### ⏱️ 스톱워치
- 시간 측정: 시작, 재설정 기능을 통해 시간을 정밀하게 측정할 수 있습니다. </br>

### ⏲ 타이머
- 카운트다운 설정: 시, 분, 초 단위로 시간을 설정하여 카운트다운을 실행할 수 있습니다. </br>

- 타이머 제어: 타이머 작동 중 취소 기능을 제공합니다. </br>

- 종료 알림: 설정된 시간이 모두 지나면 지정된 사운드가 울려 사용자에게 종료를 알립니다. </br>

</br>

# 🏗 아키텍처 
> MVC + Core Data
- **MVC (Model-View-Controller)**: </br>
    데이터(Model), UI(View), 로직(Controller)의 역할을 분리하여 앱의 구조를 설계하고 관심사를 분리.</br>
- **Core Data Framework**: </br>
  알람 데이터의 영속성(Persistence) 관리. 객체 그래프와 로컬 데이터베이스를 통해 데이터의 생성, 읽기, 수정, 삭제(CRUD)를 담당.</br>
- **Controller 중심 데이터 흐름**: </br>
  Controller가 View와 Model 사이의 중재자 역할을 하며, 사용자의 입력을 받아 Model을 업데이트하고, Model의 변경 사항을 View에 반영하는 양방향 데이터 흐름을 가짐.</br>

</br>

# ⚙️ GitFlow 전략
- **main**: </br>
  최종 배포 가능한, 안정성이 검증된 프로덕션 코드만 관리하는 브랜치.
- **develop**: </br>
  다음 릴리즈 버전을 개발하고 모든 기능 브랜치를 통합(Merge)하는 중앙 브랜치.
- **feature**: </br>
  단일 기능 개발을 위한 브랜치. develop에서 분기하며, 개발 완료 후 다시 develop으로 병합.
- **브랜치 흐름**: </br>
  feature에서 개발된 기능들이 develop에 통합되고, 안정화된 develop의 코드가 master로 병합되어 배포되는 체계적인 워크플로우.

</br>

# 📁 프로젝트 구조
```
⏰ Alarmy
│
├─ 📂 App
│     ├─ AppDelegate
│     └─ SceneDelegate
│
├─ 📂 Controller
│     ├─ AlarmViewController
│     ├─ CitySearchViewController
│     ├─ EditViewController
│     ├─ MainViewController
│     ├─ StopWatchViewController
│     ├─ TimerViewController
│     └─ WorldClockViewController
│
├─ 📂 Model
│     └─ 📂 CoreData
│           ├─ Alarm+CoreDataClass
│           ├─ Alarm+CoreDataProperties
│           └─ CoreDataManager
│     ├─ AlarmNotification
│     ├─ Alarmy.plist
│     ├─ CitySearchDelegate
│     ├─ EditViewControllerDelegate
│     ├─ StopWatch
│     ├─ TimerModel
│     ├─ TimerNotification
│     └─ WorldClockModel
│
├─ 📂 Resources
│     ├─ Assets
│     ├─ Info.plist
│     └─ iPhoneAlarm
│
├─ 📂 Utils
│     └─ Color
│
│
└─ 📂 View
      ├─ AlarmTableView
      ├─ CitySearchCell
      ├─ TimerView
      └─ WorldClockCell
```


</br>

# 👥  팀 구성 및 담당 영역
### 🟡 장우석 - 타이머 

#### 담당 컴포넌트 </br>
- `TimerView.swift` </br>
  타이머의 전체 로직과 생명주기 관리 </br>
- `TimerModel.swift`</br>
  타이머 피커, 시간 표시 레이블 등 UI 레이아웃</br>
- `TimerViewController.swift`</br>
  타이머의 남은 시간, 상태 등 데이터 관리</br>
  
#### 주요 기능 구현 </br>
- `시간 설정 UI`</br>
  UIPickerView를 활용하여 사용자가 직관적으로 시,분,초를 설정하는 인터페이스 구현</br>
- `카운드다운 로직`</br>
  Timer 객체를 이용해 1초 단위로 시간을 차감하고, 남은 시간을 레이블에 실시간으로 업데이트</br>
- `타이머 종료 알림` </br>
  타이머가 0초에 도달하면 UNUserNotificationCenter를 통해 포그라운드, 백그라운드 상태에서 사용자에게 알림</br>

<br>

### 🟡 박혜연 - 스톱워치, 세계시계 

#### 담당 컴포넌트 </br>
- `StopWatch.swift` </br>
  스톱워치의 현재 시간(counter)과 타이머 객체(timer)를 포함하여, 시간 측정에 필요한 상태를 관리하는 데이터 모델</br>
- `StopWatchViewController.swift` </br>
  스톱워치 화면의 UI를 구성하고, 사용자의 입력(시작, 중단, 재설정)에 따라 StopWatch 모델을 제어하며 화면을 업데이트하는 메인 뷰 컨트롤러</br>
- `WorldClockModel.swift` </br>
  시스템(TimeZone)에 내장된 시간대 식별자를 기반으로 전 세계 도시 목록 데이터를 생성하고 가공하는 데이터 모델</br>
- `WorldClockViewController.swift` </br>
  사용자가 선택한 세계 시간 목록을 표시하고, 도시 추가/삭제 등 전체적인 기능을 관리하는 메인 뷰 컨트롤러</br>
- `CitySearchViewController.swift` </br>
  도시 검색 결과 목록에서 각 도시의 이름과 국가 정보를 표시하는 검색용 커스텀 셀</br>

#### 주요 기능 구현 </br>
- `실시간 타이머 로직` </br>
  0.01초 간격으로 실행하여 시간을 측정하고, 분:초:밀리초 형식으로 레이블에 실시간 업데이트</br>
- `동적 버튼 제어` </br>
  상태 값에 따라 하나의 버튼('시작'/'중단')으로 타이머의 시작과 중지를 제어</br>
- `재설정 기능` </br>
  '재설정' 버튼을 통해 실행 중인 Timer를 중지시키고, 측정된 시간을 0으로 초기화하는 로직 구현</br>
- `전 세계 도시 데이터 처리` </br>
  환경에 맞게 도시와 국가 이름을 가공하여 정렬된 전체 도시 목록을 생성</br>
- `실시간 세계 시간 표시` </br>
  UITableViewCell에 현재 시간을 실시간으로 계산하고 오전/오후 형식에 맞춰 표시</br>
- `도시 검색 기능 구현` </br>
  UISearchBar를 통해 사용자가 입력한 텍스트를 기반으로 도시 또는 국가 이름에 따라 실시간으로 목록을 필터링하는 검색 로직 구현</br>
- `Core Data 연동 및 관리` </br>
  사용자가 추가한 도시 목록을 Core Data를 통해 영구적으로 저장 및 삭제 기능을 구현</br>

<br>

### 🟡 변지혜 - 알람 

#### 담당 컴포넌트 </br>
- `AlarmTableViewCell.swift` </br>
  알람 목록을 표시하고, 사용자의 상호작용(추가, 삭제, 수정)을 처리하며, Core Data 모델과 뷰를 연결하는 핵심 컨트롤러</br>
- `AlarmViewController.swift` </br>
  UITableView 내에서 알람의 정보(시간, 레이블)와 상태(ON/OFF 스위치)를 시각적으로 표시하는 재사용 가능한 커스텀 셀</br>

#### 주요 기능 구현 </br>
- `알람 목록 UI 구현` </br>
  UITableView와 SnapKit을 사용하여 알람 목록 화면의 레이아웃을 구성하고, CoreData에 저장된 데이터를 연동하여 화면에 표시</br>
- `알람 CRUD 기능 구현` </br>
  알람의 추가, 수정(셀 선택), 개별 삭제(Swipe Action), 전체 삭제 기능 구현</br>
- `알람 활성화/비활성화 로직` </br>
  UISwitch 토글에 따라 CoreData의 알람 상태를 업데이트하고, UNUserNotificationCenter를 통해 해당 알람의 로컬 알림을 예약하거나 취소</br>
- `데이터 동기화` </br>
  Delegate 패턴을 활용하여 알람 추가/수정 화면(EditViewController)에서의 변경사항이 목록 화면에 즉시 반영되도록 구현</br>

<br>


# 💬 Code Convention
### final 규칙

- 더이상 상속이 일어나지 않는 class는 `final`을 붙여서 명시

### 접근자 규칙

- class 내부에서만 쓰이는 변수는 `private`으로 명시

</br>

# 💡 Commit 규칙

```
[chore]: 코드 수정, 내부 파일 수정.

[feat]: 새로운 기능 구현.

[style]: 스타일 관련 기능.(코드의 구조/형태 개선)

[add]: Feat 이외의 부수적인 코드 추가, 라이브러리 추가

[file]: 새로운 파일 생성, 삭제 시

[fix]: 버그, 오류 해결.

[del]: 쓸모없는 코드/파일 삭제.

[docs]: README나 WIKI 등의 문서 개정.

[move]: 프로젝트 내 파일이나 코드(리소스)의 이동.

[rename]: 파일 이름 변경이 있을 때 사용합니다.

[refactor]: 전면 수정이 있을 때 사용합니다.

[merge]: 다른브렌치를 merge 할 때 사용합니다.

[test]: 테스트 코드를 작성할 때 사용합니다.
```

</br>

# Branch & PR 규칙
```
커밋타입/#이슈번호 ex) feat/#1 </br>
PR 제목: [커밋타입] #이슈번호 - 작업 이름
```
