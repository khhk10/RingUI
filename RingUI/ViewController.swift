import UIKit

class ViewController: UIViewController {
    
    // タッチ座標
    var touchLocation: CGPoint?
    // リング画像
    var ringView: UIImageView?
    // 角度（0〜360）
    var angleForParameter: CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初期化
        touchLocation = CGPoint(x: view.center.x + 1, y: view.center.y + 1)
        angleForParameter = 0.0
    
        // リング
        let ringImage = drawRing()
        ringView = UIImageView(image: ringImage)
        self.view.addSubview(ringView!)
    }
    
    // ドラッグ
    @IBAction func dragEvent(_ sender: UIPanGestureRecognizer) {
        
        self.touchLocation = sender.location(in: self.view)
        
        ringView?.image = drawRing()
    }
    
    // 描画画像を生成
    func drawRing() -> UIImage? {
        let size = view.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        
        let centerX: CGFloat = view.center.x
        let centerY: CGFloat = view.center.y
        
        let radius: CGFloat = 100
        
        // リングのパス生成
        let ringPath = createRing(radius: radius)
        ringPath.lineWidth = 40
        ringPath.lineCapStyle = .round
        
        // 色の設定
        let para = fabs(angleForParameter! / 360)
        let color = UIColor(hue: 0.5, saturation: 1.0, brightness: para + 0.25, alpha: 1.0)
        color.setStroke()
        
        // アフィン変換
        let transform = CGAffineTransform(translationX: centerX, y: centerY)
        ringPath.apply(transform)
        
        // 描画
        ringPath.stroke()
        
        // 文字
        let percent = 100 * (Double(angleForParameter!)) / 360
        let font = UIFont.boldSystemFont(ofSize: 40)
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
        let percentString = String(format: "%.1f", percent) + "%"
        
        let strX = view.center.x - 60
        let strY = view.center.y - 20
        let rect = CGRect(x: strX, y: strY, width: 120, height: 40)
        percentString.draw(in: rect, withAttributes: attributes)
        
        // UIImage取得
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndPDFContext()
        
        return image
    }
    
    // リングのパス生成
    func createRing(radius r: CGFloat) -> UIBezierPath {
        // let angle1 = 2 * Double.pi * p/100 - Double.pi/2
        
        let center = view.center
        
        var endAngle = calcAngle(centerPoint: center, touchPoint: self.touchLocation!)
        if endAngle < 0 {
            endAngle = endAngle + CGFloat.pi*2
        }
        angleForParameter = 360 * endAngle / (CGFloat.pi*2)
        
        let path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: r, startAngle: CGFloat(0), endAngle: endAngle, clockwise: true)
        
        return path
    }
    
    // 座標から角度を計算
    func calcAngle(centerPoint center: CGPoint, touchPoint touch: CGPoint) -> CGFloat {
        // ラジアン
        var r = atan2(touch.y - center.y, touch.x - center.x)
        
        // 0〜2piの範囲
        if r < 0 {
            r = r + CGFloat.pi*2
        }
        
        print(r)
        
        return r
    }
}

