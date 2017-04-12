//
//  HandlePositionVC.swift
//  wp
//
//  Created by J-bb on 17/3/28.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit
import SVProgressHUD
class HandlePositionVC: UIViewController {

    var positionModel:PoHistoryModel?
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var infoBackImage: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var flightLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    var resultBlock: CompleteBlock?

    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "buyBg")
        infoBackImage.image = image?.resizableImage(withCapInsets: UIEdgeInsetsMake(17, 23  , 17, 23), resizingMode: .stretch)
        infoBackImage.layer.cornerRadius = 3
        infoBackImage.layer.masksToBounds = true
        contentView.bringSubview(toFront: infoLabel)
        let text = "当前舱位航班 : 5X3154"
        flightLabel.setAttributeText(text: text, firstFont: 16.0, secondFont: 16.0, firstColor: UIColor(hexString: "666666"), secondColor: UIColor(hexString: "333333"), range: NSMakeRange(9, text.length() - 9))
        
        let priceText = "此次成交额￥132.0"
        priceLabel.setAttributeText(text: priceText, firstFont: 16.0, secondFont: 20.0, firstColor: UIColor(hexString: "666666"), secondColor: UIColor(hexString: "157FB3"), range: NSMakeRange(5, priceText.length() - 5))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismissController()
    }
     // 货运
    @IBAction func freightAction(_ sender: Any) {
                let timeCount = Int64(NSDate().timeIntervalSince1970) - ((positionModel?.tradeTime)! / 1000)
                if timeCount < 5 * 24 * 3600 {
                    SVProgressHUD.showWainningMessage(WainningMessage: "货运-交易5日内不可操作", ForDuration: 2, completion: {
                        
                    })
                    return
                }
        handlePositionWithIndex(index: 5)
        

    }
    // 退仓
    @IBAction func feeRefundAction(_ sender: Any) {
        handlePositionWithIndex(index: 4)

    }
    // 转卖
    @IBAction func resellAction(_ sender: Any) {
        let timeCount = Int64(NSDate().timeIntervalSince1970) - ((positionModel?.tradeTime)! / 1000)
        if timeCount < 5 * 24 * 3600 {
            
            SVProgressHUD.showWainningMessage(WainningMessage: "转卖-5日内不可操作", ForDuration: 2, completion: {
                
            })
            return
        }
        
        handlePositionWithIndex(index: 6)
    }
    
    func handlePositionWithIndex(index:Int) {
        
        let model = HandlePositionModel()
        model.requestPath = "/api/trade/user/flightspace/handle.json"
        model.tradeId = positionModel!.tradeId
        model.handleType = index
        model.token = UserDefaults.standard.value(forKey: SocketConst.Key.token) as! String
        HttpRequestManage.shared().postRequestModelWithJson(requestModel: model, reseponse: { (response) in
            self.resultBlock!(index as AnyObject?)
            self.dismissController()
        }) { (error) in
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
