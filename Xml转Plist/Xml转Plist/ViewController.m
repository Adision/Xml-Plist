//
//  ViewController.m
//  Xml转Plist
//
//  Created by Apple on 2017/3/27.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ViewController.h"

#import "GDataXMLNode.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"xml"];
    NSData *plistXML = [[NSData alloc] initWithContentsOfFile:filePath];
    
    
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:plistXML error:&error];
    NSMutableArray*dataArr=[NSMutableArray array];
    NSArray *provinceArr= [doc nodesForXPath:@"/root/province" error:nil];
    //获取属性, 属性使用GDataXMLElement表示
    for (int i=0; i<provinceArr.count; i++) {
        NSMutableDictionary*pDic=[NSMutableDictionary dictionary];
        //省或直辖市名
        GDataXMLElement *item=(GDataXMLElement*)[provinceArr objectAtIndex:i];
        GDataXMLNode*pStr=[item attributeForName:@"name"];
        [pDic setObject:pStr.stringValue forKey:@"state"];
        //        NSLog(@"dis_stringValue1=%@",pStr.stringValue);
        
        //城市名
        NSMutableArray*tempCityArr=[NSMutableArray array];
        NSArray*cityArray=[provinceArr[i] children];
        for (int j=0; j<cityArray.count; j++) {
            NSMutableDictionary*cityDic=[NSMutableDictionary dictionary];
            GDataXMLElement *cityItem=cityArray[j];
            GDataXMLNode*cityStr=[cityItem attributeForName:@"name"];
            NSLog(@"dis_stringValue2=%@",cityStr.stringValue);
            [cityDic setObject:cityStr.stringValue forKey:@"city"];
            
            //区名
            NSMutableArray*disTempArr=[NSMutableArray array];
            NSArray*discritArr=[cityArray[j] children];
            for (int k=0; k<discritArr.count; k++) {
               GDataXMLElement *disItem=discritArr[k];
                NSString*XMLString=[disItem XMLString];
                if (XMLString.length>0) {
                    GDataXMLNode*disStr=[disItem attributeForName:@"name"];
                    NSLog(@">>>>>disItem.attributes=%@",disStr.stringValue);
                    [disTempArr addObject:disStr.stringValue];
                }
            }
            [cityDic setObject:disTempArr forKey:@"areas"];
            [tempCityArr addObject:cityDic];
        }
        
        [pDic setObject:tempCityArr forKey:@"cities"];
        [dataArr addObject:pDic];
    }
    
//    NSLog(@">>>>>>>>>>>dataArr=%@",dataArr);
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"area.plist"];
    NSLog(@">>>>>>>>>>>>>filename=%@",filename);
    [dataArr writeToFile:filename atomically:YES];
}


@end
