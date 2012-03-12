//
//  ViewController.m
//  CloudStoreThree
//
//  Created by Firoze Lafeer on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController()

-(void)updateLastMessageReadLabel;

@end

@implementation ViewController 
@synthesize labelLastMessageRead;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)observeValueForKeyPath:(NSString *)keyPath 
                     ofObject:(id)object 
                       change:(NSDictionary *)change 
                      context:(void *)context {
    
    if ([keyPath isEqualToString:@"lastMessageRead"]) {
        
        //Write the new value out to the user defaults
        [self updateLastMessageReadLabel];
    }
    
    else { [super observeValueForKeyPath:keyPath ofObject:object change:change context:context]; }
}


-(void)updateLastMessageReadLabel {
    
    self.labelLastMessageRead.text = [NSString stringWithFormat:@"%d",[[AppDelegate instance] lastMessageRead]];

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setLabelLastMessageRead:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateLastMessageReadLabel];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[AppDelegate instance] addObserver:self
                             forKeyPath:@"lastMessageRead" 
                                options:NSKeyValueObservingOptionNew 
                                context:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    // Clean up so we don't get KVO updates while we're not on screen
    [[AppDelegate instance] removeObserver:self forKeyPath:@"lastMessageRead"];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)readMoreStories:(id)sender {
    
    // For now, just pretend we read another 25...
    
    NSUInteger current = [[AppDelegate instance] lastMessageRead];
    
    [[AppDelegate instance] updateLastMessageRead:(current + 25)];
}
@end
