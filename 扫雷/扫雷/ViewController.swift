//
//  ViewController.swift
//  扫雷
//
//  Created by qianfeng on 16/6/26.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

import UIKit

struct Point {
    var value:Int  // 负数表示是雷  正数表过周围的雷数
    var isHiden:Bool //踩过的标记 true表示没踩过
}
class ViewController: UIViewController {
    
    var level = 1
    
    var rows:Int?
    var cols:Int?
    
    var selectedImage:UIImage?
    
    var array:[Point]?
    
    var arrayBtn = [UIButton]()
    
    
    var bombTotals:Int?
    
    subscript (row:Int, col:Int)->Point {
        get {
            return self.array![row*self.cols!+col]
        }
        set {
            self.array![row*self.cols!+col] = newValue
        }
    }
 override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rows = 6+level*3
        
        self.cols = rows
        
        // 设置雷数
        self.bombTotals = level*10
        
        self.array = [Point](count: rows! * cols!, repeatedValue: Point(value: 0, isHiden: true))
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        // 把埋雷代码封装成一个函数
        self.setBomb()
        
        
        for r in 0..<self.rows! {
            for c in 0..<self.cols! {
                let btn = UIButton(type: .Custom)
                
                btn.frame = CGRectMake(27+CGFloat(r*40), 100+CGFloat(c*40), 40, 40)
                
                btn.setImage(UIImage(named: "tile_2_mask@2x"), forState: .Normal)
                
                btn.setImage(UIImage(named: "tile_2_mask_down@2x"), forState: .Highlighted)
                
                if self[r,c].value<0 {
                    self.selectedImage = UIImage(named: "tile_0_b@2x")
                }else if self[r,c].value == 0{
                    
                    self.selectedImage = UIImage(named: "tile_2_base@2x")
                    
                }else{
                    
                    self.selectedImage = UIImage(named: "tile_5_\(self[r,c].value)@2x")
                }
                
                btn.setImage(self.selectedImage , forState: .Selected)
                
                //                btn.selected = true
                
                btn.addTarget(self, action: "btnClick:", forControlEvents: .TouchUpInside)
                
                
                
                
                btn.tag = r*self.cols!+c
                
                self.arrayBtn.append(btn)
                self.view.addSubview(btn)
                
            }
        }
        
        // 把埋雷代码封装成一个函数
        //        self.setBomb()
        
        
        
        
        
        
    }
    
    func setBomb(){
        // 循环埋雷
        for _ in 1...self.bombTotals!{
            var row = 0
            var col = 0
            // 随机定位埋雷点
            repeat{
                row = Int(arc4random())%self.rows!
                col = Int(arc4random())%self.cols!
            } while self[row,col].value < 0//  说明已经埋过雷
            // 给 row,col 位置布雷
            self[row,col].value = -1000  //  如果>0 那么把他赋值-1000
            
            //****************************
            //给 row,col的周围八个点加1
            //****************************
            
            // 左  如果左边没出界
            if col-1 >= 0 {
                for i in row-1...row+1 {
                    if i<0||i>=self.rows {
                        continue
                    }
                    self[i,col-1].value += 1
                }
            }
            // 上 如果上边没出界
            if row-1>=0 {
                self[row-1,col].value += 1
            }
            
            // 右 如果右边没出界
            if col+1<self.cols {
                for i in row-1...row+1 {
                    if i<0||i>=self.rows {
                        continue
                    }
                    self[i,col+1].value += 1
                }
            }
            
            // 下
            if row+1<self.rows {
                self[row+1,col].value += 1
            }
        }
    }
    
    func btnClick(btn:UIButton){
        
        btn.selected = true
        if self.array![btn.tag].value < 0 {
            
//            for button in self.view.subviews{
//                
//                (button as! UIButton).selected = true
//                
//            }
            for button in self.view.subviews{
                button.hidden = false
            }
            let alertView = UIAlertView(title: "警告", message: "你挂了", delegate: nil, cancelButtonTitle: "OK")
            //显示提示框
            alertView.show()
        } else if self.array![btn.tag].value == 0{
            
            let row = btn.tag/self.cols!
            
            let col = btn.tag%self.cols!
            
            self.openArea(row, col: col)
        }
        //        else{
        //
        //            self.array![btn.tag].isHiden = false
        //
        //        }
        
        self.win()
        
        
    }
    
    func openArea(row:Int,col:Int){
        // 左  如果左边没出界
        
        //        self[row,col].isHiden = false(可以被注释)
        
        //        self.arrayBtn[row+self.cols!+col].selected = true
        if col-1 >= 0 {
            for i in row-1...row+1 {
                if i<0||i>=self.rows {
                    continue
                }
                if self[i,col-1].value == 0 && self[i,col-1].isHiden {
                    
                    self[i,col-1].isHiden = false
                    
                    self.arrayBtn[i*self.cols!+(col-1)].selected = true
                    openArea(i, col: col-1)
                }else if self[i,col-1].value>0 {
                    self[i,col-1].isHiden = false
                    self.arrayBtn[i*self.cols!+(col-1)].selected = true
                    
                }
            }
        }
        
        // 上 如果上边没出界
        if row-1>=0 {
            if self[row-1,col].value == 0 && self[row-1,col].isHiden{
                self[row-1,col].isHiden = false
                
                self.arrayBtn[(row-1)*self.cols!+col].selected = true
                openArea(row-1, col: col)
            }else if self[row-1,col].value > 0 {
                self[row-1,col].isHiden = false
                
                self.arrayBtn[(row-1)*self.cols!+col].selected = true
            }
        }
        
        // 右 如果右边没出界
        if col+1<self.cols {
            for i in row-1...row+1 {
                if i<0||i>=self.rows {
                    continue
                }
                if self[i,col+1].value == 0 && self[i,col+1].isHiden{
                    self[i,col+1].isHiden = false
                    
                    self.arrayBtn[i*self.cols!+(col+1)].selected = true
                    openArea(i, col: col+1)
                }else if self[i,col+1].value > 0 {
                    self[i,col+1].isHiden = false
                    
                    self.arrayBtn[i*self.cols!+(col+1)].selected = true
                }
            }
        }
        
        // 下
        if row+1<self.rows {
            if self[row+1,col].value == 0 && self[row+1,col].isHiden {
                self[row+1,col].isHiden = false
                
                self.arrayBtn[(row+1)*self.cols!+col].selected = true
                openArea(row+1, col: col)
            }else if self[row+1,col].value > 0 {
                self[row+1,col].isHiden = false
                
                self.arrayBtn[(row+1)*self.cols!+col].selected = true
            }
        }
        
    }
    
    func win() {
        var count = 0
        for i in 0...self.rows!-1 {
            for j in 0...self.cols!-1 {
                
                
                if self.arrayBtn[i*self.cols!+j].selected == true  {
                    count += 1
                }
            }
        }
        if count == self.bombTotals {
            let alertView = UIAlertView(title: "恭喜", message: "你赢了", delegate: nil, cancelButtonTitle: "OK")
            //显示提示框
            alertView.show()
            
        }
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

