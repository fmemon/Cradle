//
//  GameOverScene.m
//  Cocos2DSimpleGame
//
//  Created by Ray Wenderlich on 2/10/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "GameOverScene.h"
#import "ComboSeeMe.h"

@implementation GameOverScene

+(id) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	GameOverScene *layer = [GameOverScene node];
    
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init] )) {
        CCSprite *sprite2 = [CCSprite spriteWithFile:@"bg.png"];
        sprite2.anchorPoint = CGPointZero;
        [self addChild:sprite2 z:-11];
        
        
        [self restoreData];
        //[[CCDirector sharedDirector] setDeviceOrientation:kCCDeviceOrientationPortrait];
        
        [self setLabels];
        
        tapLabel = [CCLabelTTF labelWithString:@"Tap to Restart" fontName:@"Marker Felt" fontSize:35];
		tapLabel.position = ccp(260, 131.67f);        
		[self addChild: tapLabel];
        
        
        newHSlabel = [CCLabelTTF labelWithString:@"New HighScore!!!" fontName:@"Marker Felt" fontSize:24];
        newHSlabel.position= ccp(100.0f, 280.0f);
		[self addChild: newHSlabel];
        
        /*UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Please enter your name:" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
         alert.tag = 9876;
         alert.alertViewStyle = UIAlertViewStylePlainTextInput;
         UITextField * alertTextField = [alert textFieldAtIndex:0];
         alertTextField.keyboardType = UIKeyboardTypeDefault;
         alertTextField.placeholder = @"Enter your name";
         [alert show];
         */
    
       /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New HighScore!!!" message:@"Please enter your name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
         [alert setTag:666];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeDefault;
        alertTextField.placeholder = @"Enter your name";
         [alert show];
         [alert release];
*/
         

        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Add Username" message:@"This gets covered." delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"Cancel", nil];
        myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
        [myTextField setPlaceholder:@"Insert Task.."];
        [myTextField setBackgroundColor:[UIColor whiteColor]];
        [myAlertView addSubview:myTextField];
        [myAlertView show];

        
        
        
        /*  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@" " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];		
         CGRect frame = CGRectMake(14, 45, 255, 83);		
         UITextField* textField = [[UITextField alloc] initWithFrame:frame];
         //UITextField * textField = [alertView textFieldAtIndex:0];
         
         textField.placeholder = @"Name";		
         // textField.backgroundColor = [UIColor whiteColor];		
         // textField.autocorrectionType = UITextAutocorrectionTypeDefault; 		
         textField.keyboardType = UIKeyboardTypeAlphabet; 		
         textField.returnKeyType = UIReturnKeyDone;		
         textField.clearButtonMode = UITextFieldViewModeWhileEditing; // has 'x' button to the right	
         [alertView addSubview:textField];	
         [alertView show];	
         [alertView release];
         */
        
        
        
        /*
         myText = [[UITextField alloc] initWithFrame:CGRectMake(80,10, 150,30)];
         [myText setTextColor:[UIColor blackColor]];
         [myText setClearsOnBeginEditing:YES];
         [myText setBorderStyle:UITextBorderStyleRoundedRect];
         
         [myText setDelegate:self];
         [myText setReturnKeyType:UIReturnKeyDone];
         [myText setAutocapitalizationType:UITextAutocapitalizationTypeWords];
         // [myText setTransform:CGAffineTransformMakeRotation((float)M_PI_2)];
         // myText.transform = CGAffineTransformMakeRotation(M_PI * (90.0 / 180.0));
         [myText setCenter:CGPointMake(80.0f, 100.0f)];
         
         [[[CCDirector sharedDirector] openGLView] addSubview: myText];
         */
        
        [newHSlabel setVisible:YES];
        [myText setHidden:NO];
        
        // Enable touches
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}	
	return self;
}


-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	/*if(buttonIndex == 0) {
		NSLog(@"You remain tight lipped on\nthe 'pie' question.");
	}else if(buttonIndex == 1){
		NSLog(@"Ah yes, another lover of pie.");
	}else if(buttonIndex == 2){
		NSLog(@"You don't like pie?\nWhat's wrong with you?");
	}
    */
    NSLog(@"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA:   %@", myTextField.text);
    
}


-(void)setLabels {

    winner1 = [CCLabelTTF labelWithString:@"1. HighScorer" fontName:@"Arial" fontSize:24];
    winner1.position = ccp(260.0f, 280.0f);
    winner1.color = ccc3(26, 46, 149);
    [self addChild:winner1];
    
    HS1 = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:24];
    HS1.position = ccp(400.0f, 280.0f);
    HS1.color = ccc3(26, 46, 149);
    [self addChild:HS1];
   
    winner2 = [CCLabelTTF labelWithString:@"2. Highscorer" fontName:@"Arial" fontSize:24];
    winner2.position = ccp(260.0f, 240.0f);
    winner2.color = ccc3(26, 46, 149);
    [self addChild:winner2];
    
    HS2 = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:24];
    HS2.position = ccp(400.0f, 240.0f);
    HS2.color = ccc3(26, 46, 149);
    [self addChild:HS2];
    
    winner3 = [CCLabelTTF labelWithString:@"3. HighScorer" fontName:@"Arial" fontSize:24];
    winner3.position = ccp(260.0f, 200.0f);
    winner3.color = ccc3(26, 46, 149);
    [self addChild:winner3];
    
    HS3 = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:24];
    HS3.position = ccp(400.0f, 200.0f);
    HS3.color = ccc3(26, 46, 149);
    [self addChild:HS3];    
   
   
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
	//Terminate editing 
	[textField resignFirstResponder]; 
    [myText setHidden:YES];

	return YES; 
} 

- (void)textFieldDidEndEditing:(UITextField*)textField { 
	NSLog(@"textFieldDidEndEditing");
    if (textField==myText) {    
		
		[myText endEditing:YES]; 
        [myText removeFromSuperview];     
		// here is where you should do something with the data they entered   
		//NSLog(@"%@", myText.text);    
        [self saveData];
	}
} 


- (void)saveData {   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:myText.text forKey:@"Winner1"];
    [defaults synchronize];
}

- (void)restoreData {
    
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"Winner1"]) {
        [winner1 setString:[NSString stringWithFormat:@"%i",[defaults objectForKey:@"Winner1"]]];
    }
    if ([defaults objectForKey:@"Winner2"]) {
        [winner2 setString:[NSString stringWithFormat:@"%i",[defaults objectForKey:@"Winner2"]]];
    }
    if ([defaults objectForKey:@"Winner3"]) {
        [winner3 setString:[NSString stringWithFormat:@"%i",[defaults objectForKey:@"Winner3"]]];
    }
    
    if ([defaults integerForKey:@"newHS"]) {
        newHS = [defaults integerForKey:@"newHS"];
    }
    if ([defaults integerForKey:@"HS1"]) {
        H1 = [defaults integerForKey:@"HS1"];
    }
    if ([defaults integerForKey:@"HS2"]) {
        H2 = [defaults integerForKey:@"HS2"];
    }
    if ([defaults integerForKey:@"HS3"]) {
        H3 = [defaults integerForKey:@"HS3"];
    }
    
    [self testScore];
    
}

- (void)testScore {
    
    if (newHS > H1) {
        
        H3 = H2;
        H2 = H1;
        H1 = newHS;
        [newHSlabel setString:@"New Highscorer1!!!"];
        NSLog(@"New hihscorer1!");

    }
    else if (newHS > H2) {
        H3 = H2;
        H2 = newHS;
        [newHSlabel setString:@"New Highscorer2!!"];
        NSLog(@"New hihscorer3!");
    }
    else if (newHS > H3) {
        H3 = newHS;
        [newHSlabel setString:@"New Highscorer3!"];
        NSLog(@"New hihscorer3!");

    }
    else {
        //no switch over
        [newHSlabel setVisible:NO];
        [myText setHidden:YES];
        NSLog(@"No New hihscorer1!");

    }
    
    [self printScores];
    
}

- (void)printScores {
    [HS1 setString:[NSString stringWithFormat:@"%i",H1]];
    [HS2 setString:[NSString stringWithFormat:@"%i",H2]];
    [HS3 setString:[NSString stringWithFormat:@"%i",H3]];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [myText removeFromSuperview];

    [[CCDirector sharedDirector] replaceScene:[ComboSeeMe scene]];
    return YES;
}


- (void)dealloc {
	[super dealloc];
}

@end
