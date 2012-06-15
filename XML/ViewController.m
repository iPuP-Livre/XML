//
//  ViewController.m
//  XML
//
//  Created by Marian PAUL on 30/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *xmlFilePath =[[NSBundle mainBundle] pathForResource:@"capitales" ofType:@"xml"];
    
    [self performSelectorInBackground:@selector(parseXMLFile:) withObject:xmlFilePath]; //[1]
}

- (void)parseXMLFile:(NSString*)thePath 
{
    @autoreleasepool { // [2]
        _parser = [[XMLParser alloc] init];
        _parser.delegate = self; // [3]
        if ([_parser.countries count] == 0)
        {
            [_parser parseXMLFileAtPath:thePath];
        }
        
    } 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Retourne le nombre de sections
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Retourne le nombre de lignes dans la section
    return [_parser.countries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *pays = [_parser.countries objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ — %@ — %@", [pays objectForKey:kNom], [pays objectForKey:kCapitale], [pays objectForKey:kPopulation]];
    return cell;
}


#pragma mark - XMLParserDelegate

- (void) xmlParser:(XMLParser*)parser didFinishParsing:(NSArray*)array
{
    [self.tableView reloadData];
}
- (void) xmlParser:(XMLParser*)parser didFailWithError:(NSError*)error
{
    NSLog(@"Oooups il y a eu une erreur ... %@", [error localizedDescription]);
}


@end
