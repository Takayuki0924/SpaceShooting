//
//  StartViewController.swift
//  SpaceShooting
//
//  Created by 長野貴之 on 2019/08/30.
//  Copyright © 2019 takayuki Nagano. All rights reserved.
//

import UIKit
import AVFoundation

class StartViewController: UIViewController, AVAudioPlayerDelegate {
    
    var myImageview: UIImageView!
    var GameTitle: UILabel!
    var posX: CGFloat!
    var posY: CGFloat!
    var NewGameButton = UIButton()
    var audioplayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //画像をviewに表示
        let iWidth: CGFloat = self.view.frame.width
        let iHeight: CGFloat = self.view.frame.height
        
        myImageview = UIImageView(frame: CGRect(x: 0, y: 0, width: iWidth, height: iHeight))
        let myImage = UIImage(named: "space1")
        myImageview.image = myImage
        self.view.addSubview(myImageview)
        
        //ゲームタイトルを表示
        let lWidth: CGFloat = 320
        let lHeight: CGFloat = 50
        
        posX = self.view.bounds.width / 2 - lWidth / 2
        posY = self.view.bounds.height / 4 - lHeight / 2
        
        GameTitle = UILabel(frame: CGRect(x: posX, y: posY, width: lWidth, height: lHeight))
        GameTitle.textColor = UIColor.white
        GameTitle.font = UIFont.systemFont(ofSize: CGFloat(45))
        GameTitle.text = "Space Shooting"
        GameTitle.textAlignment = NSTextAlignment.center
        self.view.addSubview(GameTitle)
        
        //ボタンをviewに表示
        let bWidth: CGFloat = 200
        let bHeight: CGFloat = 50
        
        posX = self.view.frame.width / 2 - bWidth / 2
        posY = self.view.frame.height / 2 + 170 - bHeight / 2
        
        NewGameButton.frame = CGRect(x: posX, y: posY, width: bWidth, height: bHeight)
        NewGameButton.setTitle("START", for: .normal)
        NewGameButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        NewGameButton.titleLabel?.textColor = UIColor.white
        NewGameButton.addTarget(self, action: #selector(ChangeView(sender:)),for: .touchUpInside)
        self.view.addSubview(NewGameButton)
        
    }
    
    @objc func ChangeView(sender: Any) {
        
        //ゲーム画面に遷移する
        let gameview = self.storyboard?.instantiateViewController(withIdentifier: "GameView") as! GameViewController
        self.present(gameview, animated: true, completion: nil)
        
        //ボタンのタッチ音
        guard let path = Bundle.main.path(forResource: "TitleBtnSoundEffect", ofType: "mp3") else {
            print("音源ファイルが見つかりません")
            return
        }
        do {
            audioplayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            
            audioplayer.delegate = self
            
            audioplayer.play()
            audioplayer.numberOfLoops = 0
        } catch {
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
