//
//  XMLParser.m
//  XML
//
//  Created by Marian PAUL on 30/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser
@synthesize countries = _countries;
@synthesize delegate = _delegate;

- (void)parseXMLFileAtPath:(NSString *)path 
{
    self.countries = [[NSMutableArray alloc] init]; // [1]
    
    NSURL *xmlURL = [NSURL fileURLWithPath:path]; 
    
    _textParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
    [_textParser setDelegate:self]; // [2]
    
    [_textParser parse]; // [3]
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{

    _currentElement = [elementName copy]; // [1]
    NSLog(@"start %@", elementName);
    if ([elementName isEqualToString:kPays]) { // [2]
        //On efface notre cache qui est item
        _item = [[NSMutableDictionary alloc] init];
        _currentPopulation = [[NSMutableString alloc] init];
        _currentCapital = [[NSMutableString alloc] init];
        _currentCountry = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // todo : essayer de voir pourquoi ça marche plus cette histoire d'espace ...
    //NSLog(@"found '%@'", string);
    // on sauve les éléments du pays pour l'item en cours
    if ([_currentElement isEqualToString:kCapitale])
        [_currentCapital appendString:string];
    else if ([_currentElement isEqualToString:kNom])
        [_currentCountry appendString:string];
    else if ([_currentElement isEqualToString:kPopulation])
        [_currentPopulation appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:kPays]) {
        // on sauve les valeurs dans item, qui est ensuite ajouté dans le tableau countries
        [_item setObject:_currentCountry forKey:kNom];
        [_item setObject:_currentCapital forKey:kCapitale];
        [_item setObject:_currentPopulation forKey:kPopulation];
        
        [self.countries addObject:_item];
    }    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
    NSLog(@"C'est fini !");
    NSLog(@"countries a %d pays", [self.countries count]);
    
    // on retourne sur le processus principal en utilisant Grand Central Dispatch
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self.delegate xmlParser:self didFinishParsing:[NSArray arrayWithArray:self.countries]];
                   });
}

- (void) informDelegateOfError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self.delegate xmlParser:self didFailWithError:error];
                   });
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [self informDelegateOfError:parseError];
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    [self informDelegateOfError:validationError];
}

@end
