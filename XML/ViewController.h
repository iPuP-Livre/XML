//
//  ViewController.h
//  XML
//
//  Created by Marian PAUL on 30/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLParser.h"

@interface ViewController : UITableViewController <XMLParserDelegate>
{
    XMLParser *_parser;
}
@end
