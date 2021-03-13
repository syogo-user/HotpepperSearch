//
//  ViewController.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/11.
//

import UIKit
import MapKit
import Lottie
class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, DoneCatchDataProtcol {

    

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var animationView = AnimationView()
    let locationManager = CLLocationManager()
    var latitude = Double()
    var longitude = Double()
    var apikey = "834159f2a4601857"
    var shopDataArray = [ShopData]()
    var totalHitCount = Int()
    var urlArray = [String]()
    var imageStringArray = [String]()
    var nameStringArray = [String]()
//    var telArray = [String()]
    
    var indexNumber = Int()
    var annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startUpdatingLocation()
        configureSubViews()
    }
    //Lottieを表示する
    func startLoad(){
        animationView = AnimationView()
        let animation = Animation.named("1")
        animationView.frame = view.bounds
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        view.addSubview(animationView)
        animationView.play()
    }
    //位置情報を取得してよいか判定
    func startUpdatingLocation(){
        locationManager .requestAlwaysAuthorization()
        let status = CLAccuracyAuthorization.fullAccuracy
        if status == .fullAccuracy{
            locationManager.startUpdatingLocation()
        }
    }
//http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=834159f2a4601857&lat=35.6629220&lng=139.761457&range=5&count=100&format=json
    
    private func configureSubViews(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        //更新する範囲 10m
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        mapView.mapType = .standard //
        mapView.userTrackingMode = .follow//
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first //最初に取得した場所
        //緯度
        let latitudeValue = location?.coordinate.latitude
        //経度
        let longitudeValue = location?.coordinate.longitude
        print("★\(latitude),\(longitude)")
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
        //textFieldを閉じる
        textField.resignFirstResponder()
        //ローディングを行う
        startLoad()
        //textFieldの文字、didUpdateLocationsで取得した緯度、経度とAPIキーを用いてURLを作成
        let urlString = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=\(apikey)&lat=\(latitude)&lng=\(longitude)&range=3&count=50&format=json&keyword=\(textField.text!)"
        
        //通信を行う
        let analyticsModel = AnalyticsModel(latitude: latitude, longitude: longitude, url: urlString)
        analyticsModel.doneCatchDataProtcol = self //自分に処理を委任する
        analyticsModel.setData() 
        
    }
    func addAnnotation(shopData :[ShopData]){
        removeArray()
        for i in 0...totalHitCount - 1{
            annotation = MKPointAnnotation()
            //緯度、経度を設定
            annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(shopData[i].latitude ?? 0.0), CLLocationDegrees(shopData[i].longitude ?? 0.0))
            //タイトル
            annotation.title = shopData[i].name
//            annotation.subtitle = shopData[i].
            urlArray.append(shopData[i].url!)
            imageStringArray.append(shopData[i].shopImage!)
            nameStringArray.append(shopData[i].name!)
            mapView.addAnnotation(annotation)
        }
        textField.resignFirstResponder()
    }
    func removeArray(){
        //mapViewの前回のアノテーション(ピン)を消去する
        guard let mapAnotaionts = mapView.annotations as? MKAnnotation else{return}
        mapView.removeAnnotation(mapAnotaionts)
        urlArray   = []
        imageStringArray = []
        nameStringArray = []
    }
    
    func catchData(arrayData: Array<ShopData>, resultCount: Int) {
        //arrayData,resultCount
        animationView.removeFromSuperview()//アニメーションを閉じる
        shopDataArray = arrayData
        totalHitCount = resultCount

        //shopDataArrayの中身を取り出して、annotationとして設置
         addAnnotation(shopData:  shopDataArray)
    }
    //アノテーションがタップされたときに呼ばれる
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //詳細ページへ遷移
        indexNumber = 0
        
        if nameStringArray.firstIndex(of: (view.annotation?.title)!!) != nil{
            
            indexNumber = nameStringArray .firstIndex(of: (view.annotation?.title)!!)!
            print("indexNumber",indexNumber)
        }
        performSegue(withIdentifier: "detailVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! DetailViewController
        detailVC.name = nameStringArray[indexNumber]
        detailVC.imageURLString = imageStringArray[indexNumber]
        detailVC.url  = urlArray[indexNumber]
    }
    
}
