#import "MenuView.h"

@interface MenuView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *tabButtons;
@property (nonatomic, assign) NSInteger selectedTab;
@property (nonatomic, strong) NSMutableArray *tabsContent;
@property (nonatomic, assign) CGPoint lastLocation;
@end

@implementation MenuView

static MenuView *sharedInstance = nil;

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect screen = [UIScreen mainScreen].bounds;
        sharedInstance = [[MenuView alloc] initWithFrame:CGRectMake(20, 80, 340, 480)];
    });
    return sharedInstance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor colorWithWhite:0.06 alpha:0.95];
    self.layer.cornerRadius = 16;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:0.5].CGColor;
    self.clipsToBounds = YES;
    
    // Header
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    header.backgroundColor = [UIColor colorWithRed:0.9 green:0.3 blue:0.2 alpha:0.9];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 30)];
    title.text = @"DEKU MENU";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:18];
    [header addSubview:title];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(self.frame.size.width - 45, 8, 35, 35);
    [closeBtn setTitle:@"X" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    closeBtn.layer.cornerRadius = 17.5;
    [closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:closeBtn];
    
    [self addSubview:header];
    
    // Tab Bar
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, 45)];
    tabBar.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    [self addSubview:tabBar];
    
    NSArray *tabs = @[@"CHAMS", @"AIMBOT", @"SETTINGS", @"BRUTAL"];
    CGFloat tabWidth = self.frame.size.width / tabs.count;
    self.tabButtons = [NSMutableArray array];
    
    for (int i = 0; i < tabs.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(i * tabWidth, 0, tabWidth, 45);
        [btn setTitle:tabs[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        btn.backgroundColor = (i == 0) ? [UIColor colorWithRed:0.9 green:0.3 blue:0.2 alpha:0.5] : [UIColor clearColor];
        btn.tag = i;
        [btn addTarget:self action:@selector(tabTapped:) forControlEvents:UIControlEventTouchUpInside];
        [tabBar addSubview:btn];
        [self.tabButtons addObject:btn];
    }
    
    // ScrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 95, self.frame.size.width, self.frame.size.height - 95)];
    self.scrollView.showsVerticalScrollIndicator = YES;
    [self addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
    [self.scrollView addSubview:self.contentView];
    
    self.tabsContent = [NSMutableArray array];
    for (int i = 0; i < tabs.count; i++) {
        [self.tabsContent addObject:[NSMutableArray array]];
    }
    
    [self buildChams];
    [self buildAimbot];
    [self buildSettings];
    [self buildBrutal];
    
    [self showTab:0];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
}

- (void)buildChams {
    NSMutableArray *items = self.tabsContent[0];
    [items addObject:@{@"type": @"label", @"title": @"Menu Deku"}];
    [items addObject:@{@"type": @"switch", @"title": @"Menu LC"}];
    [items addObject:@{@"type": @"switch", @"title": @"Box 3D"}];
    [items addObject:@{@"type": @"switch", @"title": @"Dynamic RGB Box 3D"}];
    [items addObject:@{@"type": @"switch", @"title": @"Chams 3D"}];
    [items addObject:@{@"type": @"switch", @"title": @"Chams Red"}];
    [items addObject:@{@"type": @"switch", @"title": @"Chams Blue"}];
}

- (void)buildAimbot {
    NSMutableArray *items = self.tabsContent[1];
    [items addObject:@{@"type": @"label", @"title": @"AiMbot Page"}];
    [items addObject:@{@"type": @"switch", @"title": @"All Enable inGame"}];
    [items addObject:@{@"type": @"switch", @"title": @"All Enable inGame 2"}];
}

- (void)buildSettings {
    NSMutableArray *items = self.tabsContent[2];
    
    [items addObject:@{@"type": @"label", @"title": @"Under Player"}];
    [items addObject:@{@"type": @"info", @"title": @"Game", @"value": @"N/A"}];
    [items addObject:@{@"type": @"info", @"title": @"CPU", @"value": @"N/A"}];
    [items addObject:@{@"type": @"info", @"title": @"RAM", @"value": @"N/A"}];
    [items addObject:@{@"type": @"button", @"title": @"Key"}];
    
    [items addObject:@{@"type": @"label", @"title": @"Inject Under"}];
    [items addObject:@{@"type": @"switch", @"title": @"Speedo x50"}];
    [items addObject:@{@"type": @"switch", @"title": @"Anywhere"}];
    [items addObject:@{@"type": @"button", @"title": @"Key"}];
    
    [items addObject:@{@"type": @"label", @"title": @"Inject Speed V2"}];
    [items addObject:@{@"type": @"switch", @"title": @"Camera Left"}];
    [items addObject:@{@"type": @"switch", @"title": @"Anywhere"}];
    [items addObject:@{@"type": @"button", @"title": @"Key"}];
    
    [items addObject:@{@"type": @"label", @"title": @"Inject Left Camera"}];
    [items addObject:@{@"type": @"switch", @"title": @"Camera Far"}];
    [items addObject:@{@"type": @"switch", @"title": @"Anywhere"}];
    [items addObject:@{@"type": @"button", @"title": @"Key"}];
    
    [items addObject:@{@"type": @"label", @"title": @"Inject Far Camera"}];
    [items addObject:@{@"type": @"switch", @"title": @"Ghost Hack"}];
    [items addObject:@{@"type": @"switch", @"title": @"Game"}];
    [items addObject:@{@"type": @"button", @"title": @"Key"}];
    
    [items addObject:@{@"type": @"label", @"title": @"Inject Ghost"}];
    [items addObject:@{@"type": @"button", @"title": @"Reset Guest (Login)"}];
}

- (void)buildBrutal {
    NSMutableArray *items = self.tabsContent[3];
    
    [items addObject:@{@"type": @"label", @"title": @"ANTI-CHEAT (OFF)"}];
    [items addObject:@{@"type": @"switch", @"title": @"Camera High"}];
    [items addObject:@{@"type": @"switch", @"title": @"Login"}];
    [items addObject:@{@"type": @"button", @"title": @"Key"}];
    
    [items addObject:@{@"type": @"label", @"title": @"Sniper Switch"}];
    [items addObject:@{@"type": @"switch", @"title": @"Login"}];
    [items addObject:@{@"type": @"button", @"title": @"Key"}];
    
    [items addObject:@{@"type": @"label", @"title": @"Ultimate Switch"}];
    [items addObject:@{@"type": @"switch", @"title": @"Fast Fire (Alt)"}];
    [items addObject:@{@"type": @"switch", @"title": @"Login"}];
    [items addObject:@{@"type": @"button", @"title": @"Key"}];
    
    [items addObject:@{@"type": @"label", @"title": @"AntiCheat"}];
    [items addObject:@{@"type": @"switch", @"title": @"Remove Crouch"}];
    [items addObject:@{@"type": @"switch", @"title": @"Login"}];
    [items addObject:@{@"type": @"segments", @"title": @"Status", @"options": @[@"ON", @"VI", @"V2"]}];
    
    [items addObject:@{@"type": @"label", @"title": @"Ultra Reload v2"}];
    [items addObject:@{@"type": @"switch", @"title": @"Remove Animation"}];
    [items addObject:@{@"type": @"switch", @"title": @"Login"}];
}

- (void)showTab:(NSInteger)index {
    self.selectedTab = index;
    
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    NSArray *items = self.tabsContent[index];
    CGFloat y = 15;
    CGFloat w = self.frame.size.width - 30;
    CGFloat padding = 15;
    
    for (NSDictionary *item in items) {
        NSString *type = item[@"type"];
        NSString *title = item[@"title"];
        
        if ([type isEqualToString:@"label"]) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding, y, w, 30)];
            label.text = title;
            label.textColor = [UIColor colorWithRed:0.9 green:0.3 blue:0.2 alpha:1.0];
            label.font = [UIFont boldSystemFontOfSize:14];
            [self.contentView addSubview:label];
            y += 35;
        }
        else if ([type isEqualToString:@"info"]) {
            NSString *value = item[@"value"];
            UIView *row = [[UIView alloc] initWithFrame:CGRectMake(padding, y, w, 40)];
            row.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.8];
            row.layer.cornerRadius = 10;
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 40)];
            titleLabel.text = title;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [row addSubview:titleLabel];
            
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, w - 115, 40)];
            valueLabel.text = value;
            valueLabel.textColor = [UIColor colorWithRed:0.9 green:0.3 blue:0.2 alpha:1.0];
            valueLabel.font = [UIFont systemFontOfSize:14];
            [row addSubview:valueLabel];
            
            [self.contentView addSubview:row];
            y += 48;
        }
        else if ([type isEqualToString:@"switch"]) {
            UIView *row = [[UIView alloc] initWithFrame:CGRectMake(padding, y, w, 44)];
            row.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.8];
            row.layer.cornerRadius = 10;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, w - 70, 44)];
            label.text = title;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:14];
            [row addSubview:label];
            
            UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(w - 55, 7, 50, 30)];
            sw.onTintColor = [UIColor colorWithRed:0.9 green:0.3 blue:0.2 alpha:1.0];
            [row addSubview:sw];
            
            [self.contentView addSubview:row];
            y += 52;
        }
        else if ([type isEqualToString:@"button"]) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(padding, y, w, 40);
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor colorWithRed:0.9 green:0.3 blue:0.2 alpha:0.8];
            btn.layer.cornerRadius = 10;
            [self.contentView addSubview:btn];
            y += 48;
        }
        else if ([type isEqualToString:@"segments"]) {
            UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:item[@"options"]];
            seg.frame = CGRectMake(padding, y, w, 40);
            seg.selectedSegmentIndex = 0;
            seg.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.8];
            seg.selectedSegmentTintColor = [UIColor colorWithRed:0.9 green:0.3 blue:0.2 alpha:1.0];
            [seg setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
            [self.contentView addSubview:seg];
            y += 48;
        }
    }
    
    self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, y + 20);
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, y + 20);
}

- (void)tabTapped:(UIButton *)sender {
    for (int i = 0; i < self.tabButtons.count; i++) {
        UIButton *btn = self.tabButtons[i];
        btn.backgroundColor = (i == sender.tag) ? [UIColor colorWithRed:0.9 green:0.3 blue:0.2 alpha:0.5] : [UIColor clearColor];
    }
    [self showTab:sender.tag];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.superview];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.lastLocation = self.center;
    }
    self.center = CGPointMake(self.lastLocation.x + translation.x, self.lastLocation.y + translation.y);
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window) {
        self.center = window.center;
        [window addSubview:self];
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
