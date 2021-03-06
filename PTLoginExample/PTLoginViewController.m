//
//  PTLoginViewController.m
//  PTLoginExample
//
//  Created by Phillip Harris on 10/10/14.
//  Copyright (c) 2014 Phillip Harris. All rights reserved.
//

#import "PTLoginViewController.h"

typedef NS_ENUM(NSInteger, PTLoginCellType) {
    PTLoginCellTypeUsername,
    PTLoginCellTypeEmail,
    PTLoginCellTypePassword,
    PTLoginCellTypeConfirmPassword,
    PTLoginCellTypeRememberMe,
    PTLoginCellTypeLoginButton,
    PTLoginCellTypeSignupButton
};

@interface PTLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *cellTypesGroupedBySection;

@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *confirmPasswordTextField;

@property (nonatomic, strong) UIView *tableHeaderView;

@property (nonatomic, strong) UISwitch *rememberMeSwitch;

@end

@implementation PTLoginViewController

//===============================================
#pragma mark -
#pragma mark Initialization
//===============================================

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    _cellTypesGroupedBySection = [NSMutableArray array];
}

//===============================================
#pragma mark -
#pragma mark View Methods
//===============================================

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Login";
    
    self.tableView.rowHeight = 44.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    [self configureCells];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
}

- (void)configureCells {
    
    NSMutableArray *firstSection = [NSMutableArray array];
    [firstSection addObject:@(PTLoginCellTypeUsername)];
    [firstSection addObject:@(PTLoginCellTypePassword)];
    
    NSMutableArray *secondSection = [NSMutableArray array];
    [secondSection addObject:@(PTLoginCellTypeLoginButton)];
    
    NSMutableArray *thirdSection = [NSMutableArray array];
    [thirdSection addObject:@(PTLoginCellTypeSignupButton)];
    
    [self.cellTypesGroupedBySection addObject:firstSection];
    [self.cellTypesGroupedBySection addObject:secondSection];
    [self.cellTypesGroupedBySection addObject:thirdSection];
}

/*
//===============================================
#pragma mark -
#pragma mark Add Table to UIViewController
//===============================================

- (void)addTable {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:tableView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:tableView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    self.tableView = tableView;
}
*/
//===============================================
#pragma mark -
#pragma mark Table Helpers
//===============================================

- (NSString *)cellReuseIdentifierForType:(PTLoginCellType)cellType {
    switch (cellType) {
        case PTLoginCellTypeEmail:
            return @"email";
        case PTLoginCellTypeUsername:
            return @"username";
        case PTLoginCellTypePassword:
            return @"password";
        case PTLoginCellTypeConfirmPassword:
            return @"confirmPassword";
        case PTLoginCellTypeLoginButton:
            return @"loginButton";
        case PTLoginCellTypeRememberMe:
            return @"remeberMe";
        case PTLoginCellTypeSignupButton:
            return @"signup";
        default:
            return @"default";
    }
}

- (UITextField *)textFieldForType:(PTLoginCellType)cellType {
    switch (cellType) {
        case PTLoginCellTypeEmail:
            return self.emailTextField;
        case PTLoginCellTypeUsername:
            return self.usernameTextField;
        case PTLoginCellTypePassword:
            return self.passwordTextField;
        case PTLoginCellTypeConfirmPassword:
            return self.confirmPasswordTextField;
        case PTLoginCellTypeSignupButton:
        case PTLoginCellTypeLoginButton:
            return nil;
        default:
            return nil;
    }
}

//===============================================
#pragma mark -
#pragma mark UITableView
//===============================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.cellTypesGroupedBySection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rows = [self.cellTypesGroupedBySection objectAtIndex:section];
    return [rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PTLoginCellType cellType = [[[self.cellTypesGroupedBySection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue];
    NSString *cellReuseIdentifier = [self cellReuseIdentifierForType:cellType];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
        
        UITextField *textField = [self textFieldForType:cellType];
        
        if (textField) {
            
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
//            [self addSubview:textField centeredVerticallyInContentView:cell.contentView withSideMargin:15.0];
            [self addSubview:textField toContentView:cell.contentView withEdgeInsets:UIEdgeInsetsMake(5.0, 15.0, 5.0, 15.0)];
        }
        
        if (cellType == PTLoginCellTypeLoginButton) {
            
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *fakeButton = [self fakeButton];
            fakeButton.text = @"Login";
            [self addSubview:fakeButton toContentView:cell.contentView withEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0)];
        }
        else if (cellType == PTLoginCellTypeSignupButton) {
            
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *fakeButton = [self fakeButton];
            fakeButton.text = @"Sign Up";
            [self addSubview:fakeButton toContentView:cell.contentView withEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0)];
        }
        else if (cellType == PTLoginCellTypeRememberMe) {
            
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.accessoryView = self.rememberMeSwitch;
            cell.textLabel.text = @"Remember Me";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PTLoginCellType cellType = [[[self.cellTypesGroupedBySection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue];
    
    switch (cellType) {
        case PTLoginCellTypeEmail:
            [self.emailTextField becomeFirstResponder];
            break;
        case PTLoginCellTypeUsername:
            [self.usernameTextField becomeFirstResponder];
            break;
        case PTLoginCellTypePassword:
            [self.passwordTextField becomeFirstResponder];
            break;
        case PTLoginCellTypeConfirmPassword:
            [self.confirmPasswordTextField becomeFirstResponder];
            break;
        case PTLoginCellTypeLoginButton:
            [self login];
            break;
        case PTLoginCellTypeSignupButton:
            [self signup];
            break;
        default:
            break;
    }
}

//===============================================
#pragma mark -
#pragma mark Text Fields
//===============================================

- (UITextField *)emailTextField {
    if (_emailTextField) {
        return _emailTextField;
    }
    UITextField *textField = [self defaultTextField];
    textField.keyboardType = UIKeyboardTypeEmailAddress;
    textField.returnKeyType = UIReturnKeyNext;
    textField.placeholder = @"Email";
    _emailTextField = textField;
    return _emailTextField;
}

- (UITextField *)usernameTextField {
    if (_usernameTextField) {
        return _usernameTextField;
    }
    UITextField *textField = [self defaultTextField];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyNext;
    textField.placeholder = @"Username";
    _usernameTextField = textField;
    return _usernameTextField;
}

- (UITextField *)passwordTextField {
    if (_passwordTextField) {
        return _passwordTextField;
    }
    UITextField *textField = [self defaultTextField];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyGo;
    textField.secureTextEntry = YES;
    textField.placeholder = @"Password";
    _passwordTextField = textField;
    return _passwordTextField;
}

- (UITextField *)confirmPasswordTextField {
    if (_confirmPasswordTextField) {
        return _confirmPasswordTextField;
    }
    UITextField *textField = [self defaultTextField];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyGo;
    textField.secureTextEntry = YES;
    textField.placeholder = @"Confirm Password";
    _confirmPasswordTextField = textField;
    return _confirmPasswordTextField;
}

- (UITextField *)defaultTextField {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
//    textField.backgroundColor = [UIColor purpleColor];
    [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [textField sizeToFit];
    return textField;
}

//===============================================
#pragma mark -
#pragma mark Remember Me Switch
//===============================================

- (UISwitch *)rememberMeSwitch {
    if (_rememberMeSwitch) {
        return _rememberMeSwitch;
    }
    UISwitch *theSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [theSwitch sizeToFit];
    [theSwitch addTarget:self action:@selector(rememberMeSwitchDidToggle:) forControlEvents:UIControlEventValueChanged];
    _rememberMeSwitch = theSwitch;
    return _rememberMeSwitch;
}

//===============================================
#pragma mark -
#pragma mark Fake Button
//===============================================

- (UILabel *)fakeButton {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 4.0;
    label.layer.masksToBounds = YES;
    return label;
}

//===============================================
#pragma mark -
#pragma mark Cell Subview Layout
//===============================================

- (void)addSubview:(UIView *)subview flushWithContentView:(UIView *)contentView {
    
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:subview];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:subview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:subview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
}

- (void)addSubview:(UIView *)subview centeredVerticallyInContentView:(UIView *)contentView withSideMargin:(CGFloat)sideMargin {
    
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:subview];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:sideMargin]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:subview attribute:NSLayoutAttributeRight multiplier:1.0 constant:sideMargin]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:subview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

- (void)addSubview:(UIView *)subview toContentView:(UIView *)contentView withEdgeInsets:(UIEdgeInsets)insets {
    
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:subview];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:insets.left]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:insets.top]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:subview attribute:NSLayoutAttributeRight multiplier:1.0 constant:insets.right]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:subview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:insets.bottom]];
}

//===============================================
#pragma mark -
#pragma mark UITextFieldDelegate
//===============================================

- (void)textFieldEditingChanged:(UITextField *)textField {
    //
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField) {
        [textField resignFirstResponder];
        [self login];
    }
    
    return YES;
}

//===============================================
#pragma mark -
#pragma mark Actions
//===============================================

- (void)login {
    NSLog(@"Login");
}

- (void)signup {
    NSLog(@"Signup");
}

- (void)rememberMeSwitchDidToggle:(UISwitch *)rememberMeSwitch {
    NSLog(@"Toggle");
}

//===============================================
#pragma mark -
#pragma mark Table Header View
//===============================================

- (UIView *)tableHeaderView {
    if (_tableHeaderView) {
        return _tableHeaderView;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sampleImage"]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:imageView];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    view.frame = CGRectMake(0.0, 0.0, 0.0, CGRectGetHeight(imageView.bounds) + 30.0);
    
    _tableHeaderView = view;
    return _tableHeaderView;
}

@end
