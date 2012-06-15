//
//  XMLParser.h
//  XML
//
//  Created by Marian PAUL on 30/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPays @"pays"
#define kCapitale @"capitale"
#define kNom @"nom"
#define kPopulation @"habitants"

@class XMLParser;

@protocol XMLParserDelegate <NSObject>

- (void) xmlParser:(XMLParser*)parser didFinishParsing:(NSArray*)array;
- (void) xmlParser:(XMLParser*)parser didFailWithError:(NSError*)error;

@end


@interface XMLParser : NSObject <NSXMLParserDelegate>
{
    NSXMLParser *_textParser;
    
    // un objet temporaire (ici un pays). 
    // il est ajouté au tableau "countries" puis effacé pour le nouveau pays
    NSMutableDictionary *_item;
    
    // On va parser le document de haut en bas.
    // On va donc collecter chaque sous-élements, les sauver dans item, puis ajouter dans le tableau
    
    NSString *_currentElement;
    NSMutableString *_currentCountry;
    NSMutableString *_currentPopulation;
    NSMutableString *_currentCapital;
    
}

- (void)parseXMLFileAtPath:(NSString *)path;

@property (nonatomic, retain) NSMutableArray *countries;
@property (nonatomic, assign) id <XMLParserDelegate> delegate;

@end
