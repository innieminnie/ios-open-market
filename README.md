# OpenMarket

서버에 있는 상품에 대한 데이터를 네트워크 통신을 통해 유저에게
  1. 앱 실행 시 전체 상품 목록을 제시합니다.
  2. 하나의 상품 목록을 탭할 경우, 상품에 대한 상세 내용을 제시합니다.
  3. 첫 화면의 상단 오른쪽의 '+' 버튼을 탭할 경우, 새로운 상품을 등록합니다.

첫화면(로딩 후, 목록형 및 격자형 ) / 새로운 상품 등록 화면 // 맨맨맨 마지막에 시뮬화면


---
## 주요 폴더 구조
// 최종적인 폴더구조 등록하기
📦OpenMarket
 ┣ 📂OpenMarket
 ┃ ┣ 📂Network
 ┃ ┃ ┣ 📜OpenMarketAPIManager.swift
 ┃ ┃ ┣ 📜HTTPMethods.swift
 ┃ ┃ ┗ 📜OpenMarketURLMaker.swift
 ┃ ┣ 📂Model
 ┃ ┃ ┣ 📜FeatureList.swift
 ┃ ┃ ┣ 📜Product.swift
 ┃ ┃ ┣ 📜ProductList.swift
 ┃ ┃ ┗ 📜ProductRegistration.swift
 ┃ ┣ 📂ViewController
 ┃ ┃ ┣ 📜ViewController.swift
 ┃ ┃ ┣ 📜ListViewController.swift
 ┃ ┃ ┗ 📜GridViewController.swift
 ┃ ┣ 📂Cell
 ┃ ┃ ┣ 📜ProductGridViewCell.swift
 ┃ ┃ ┣ 📜ProductListTableViewCell.swift
 ┃ ┗ ┗ 📜StringFormatter.swift
 ┗

---
## 주요 구현 사항

// 네트워크 요청 API 요약 (도표)

- <b>네트워크 통신을 위한 모델 타입과 네트워킹 담당 타입을 구현했습니다.</b>
  - <b>Model 폴더</b>에 네트워크 통신을 위한 Model 정의
    - 하나의 상품 정보를 담는 <b>Product</b>
    - 여러 Product를 담는 <b>ProductList</b>
    - 상품 등록 시, request body에 담아야하는 정보로 구성된 <b>ProductRegistration</b><br><br> 
  - <b>Network 폴더</b>에 네트워킹 담당 타입 OpenMarketAPIManager 설계<br> 
    - requestProductList, requestRegistration, requestProduct 메소드로 URLSessionDataTask를 활용한 데이터 요청 관련 기능을 구현<br><br>

    - Generic을 활용한 fetchData 메소드를 통해 request관련 메소드들이 네트워크 통신 시, 요구하는 데이터에 맞춰 받아오는 기능 구현 
     ``` swift
     fetchData<T: Decodable>(feature: FeatureList, url: URLRequest, completion: @escaping (Result<T,  OpenMarketNetworkError>) -> Void)
     ```
    <br>
- <b>서버에 GET 요청으로 상품목록 데이터를 받은 후, UISegmentControl을 통해 상품 목록 화면 (목록형, 격자형)을 선택형으로 구현했습니다.</b>
  - ViewController와 ListViewController & GridViewController 의 관계를 Parent <-> Child 관계로 설정하여 ViewController에서 데이터 fetch 작업을 수행하면 ListViewController & GridViewController 두 컨트롤러의 View 모두 같은 데이터 목록을 표현합니다.<br><br>
  - ListViewController(목록형): UITableView에 데이터 표현
  //학습필요<br><br>
  - GridViewController(격자형): UICollectionView에 데이터 표현
  //학습필요 <br><br>
- <b>첫 화면에서 "+" 버튼을 탭할 경우, Modal로 화면을 띄워 새로운 상품 정보에 대한 작성 및 등록 후, 서버에 POST 요청으로 서버에 데이터를 등록합니다.</b>
//모달구현 필요, 등록에 대한 tdd 필요  <br><br>

- <b>TDD를 적용하여 네트워킹 통신에 대해 UnitTest를 작성해보았습니다.</b>


---
## 트러블슈팅

1. 상품목록을 나타내기 위해 서버 API 문서에서 페이지별로 GET 호출을 필요로 하는데, 페이지를 연속적으로 호출을 하는 방식을 어떻게 할 것인가?

2. 상품 데이터의 로딩 시간이 길어서 사용자가 불편함을 느낄 수 있다.
   - 사용자에게 로딩을 나타내는 indicator 표시
   - prefetchDataSource
3. 화면의 스크롤을 위아래로 반복하면, 같은 위치의 Cell에서 보여주는 data가 변동된다.
   - Caching
   - 셀의 재사용
   - prepareForCell

4. 네트워크 통신을 통해 데이터를 가져오는 작업 플로우가 상품목록나타내기, 새로운 상품 등록하기, 상품 상세 내역 나타내기 각각의 기능 내에서 유사하다고 느껴졌는데 어떻게 공통적으로 묶을 수 있을까?
   - fetchData<T: Decodable>(feature: FeatureList, url: URLRequest, completion: **@escaping** (Result<T,OpenMarketNetworkError>) -> Void) 메소드로 리팩토링 작업
   - Generic



## 배운점

- 서버API 문서에 대한  이해
  - http 통신 방식
- 네트워크 통신에 대한 단위테스트(Unit Test) 작성, 단위테스트의 필요성
- ParentViewController와 ChildViewContoller 관계 형성에 대한 이해
- JSONDecoder 동작방식에 대한 이해
- prefetchDataSource
- Generic

