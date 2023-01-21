//
//  ViewController.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/11.
//

import UIKit
import MapKit
import SCLAlertView
import SVProgressHUD

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailSearchButton: UIButton!
    
    let locationManager = CLLocationManager()
    var latitude = Double()
    var longitude = Double()
    var apikey = "834159f2a4601857"
    var shopDataArray = [Shop]()
    var totalHitCount = Int()
    var urlArray = [String]()
    var nameStringArray = [String]()
    
    var indexNumber = Int()
    var annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startUpdatingLocation()
        configureSubViews()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyborad))
        gesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gesture)
        textField.delegate = self
        textField.returnKeyType = .search
        textField.attributedPlaceholder = NSAttributedString(string: "キーワードを入力（例：居酒屋）", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        self.detailSearchButton.layer.cornerRadius = 20
        self.detailSearchButton.addTarget(self, action: #selector(detailSearch), for: .touchUpInside)
        self.detailSearchButton.layer.shadowOffset = CGSize(width: 5, height: 5)//影の方向　右下
        self.detailSearchButton.layer.shadowRadius = 2// 影のぼかし量
        self.detailSearchButton.layer.shadowOpacity =  0.2 // 影の濃さ
    }
    
    @objc private func dismissKeyborad() {
        //キーボードを閉じる
        self.view.endEditing(true)
    }
    
    //位置情報を取得してよいか判定
    private func startUpdatingLocation() {
        locationManager .requestAlwaysAuthorization()
        let status = CLAccuracyAuthorization.fullAccuracy
        if status == .fullAccuracy{
            locationManager.startUpdatingLocation()
        }
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //検索処理
        textSearch()
        return true
    }
    
    private func configureSubViews() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        //更新する範囲 10m
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.userTrackingMode = .follow
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first //最初に取得した場所
        //緯度
        let latitudeValue = location?.coordinate.latitude
        //経度
        let longitudeValue = location?.coordinate.longitude
        latitude = latitudeValue ?? 0
        longitude = longitudeValue ?? 0
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways,.authorizedWhenInUse:
            break
        case .notDetermined,.denied,.restricted:
            break
        default:
            print("default case")
        }
        switch manager.accuracyAuthorization {
        case .reducedAccuracy:
            break
        case .fullAccuracy:
            break
        default:
            print("This should not happen")
        }
    }

    @IBAction func search(_ sender: Any) {
        if !validateCheck() {
            SCLAlertView().showInfo("検索条件が設定されていません。", subTitle: "キーワードを入力してください。", closeButtonTitle: "OK", colorStyle: 0xC1272D)
            return
        }
        //検索処理
        textSearch()
    }

    @objc private func detailSearch() {
        performSegue(withIdentifier: "detailSearchVC", sender: nil)
    }
    
    private func validateCheck() -> Bool {
        if self.textField.text == "" {
            return false
        } else {
            return true
        }
    }
    
    private func textSearch() {
        //textFieldを閉じる
        textField.resignFirstResponder()
        //ローディングを行う
        SVProgressHUD.show()

        let params = [
            "lat":latitude,
            "lng":longitude,
            "keyword":textField.text ?? ""
        ] as [String:Any]
        API.shared.request(path: .gourmet, params: params, type: ShopItems.self) { (items) in
            self.shopDataArray = items.results.shop
            self.totalHitCount = items.results.results_available
            self.addAnnotation(shopData:self.shopDataArray)
            SVProgressHUD.dismiss()
        }
    }
    
    private func addAnnotation(shopData: [Shop]) {
        removeArray()

        if totalHitCount == 0 {
            SCLAlertView().showInfo("検索結果は0件です", subTitle: "条件を変更してください", closeButtonTitle: "OK",colorStyle: 0xC1272D)
        } else {
            if totalHitCount > 100 {
                totalHitCount = 100
            }
            
            for i in 0...totalHitCount - 1 {
                annotation = MKPointAnnotation()
                //緯度、経度を設定
                annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(shopData[i].lat), CLLocationDegrees(shopData[i].lng))
                //タイトル
                annotation.title = shopData[i].name
                urlArray.append(shopData[i].urls.pc)
                nameStringArray.append(shopData[i].name)
                mapView.addAnnotation(annotation)
            }
        }
        textField.resignFirstResponder()
    }
    
    private func removeArray() {
        //mapViewの前回のアノテーション(ピン)を消去する
        let mapAnotaionts = mapView.annotations
        mapView.removeAnnotations(mapAnotaionts)
        urlArray = []
        nameStringArray = []
    }
    
    //アノテーション（ピン）がタップされたときに呼ばれる
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //詳細ページへ遷移
        indexNumber = 0
        guard let annotationTitle = (view.annotation?.title) else { return }
        guard let anntationTitleString = annotationTitle else { return }
        if nameStringArray.firstIndex(of: anntationTitleString) != nil {
            indexNumber = nameStringArray.firstIndex(of: anntationTitleString) ?? 0
            print("indexNumber",indexNumber)
        }
        performSegue(withIdentifier: "detailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailViewController else { return }
        detailVC.name = nameStringArray[indexNumber]
        detailVC.url  = urlArray[indexNumber]
    }
}
