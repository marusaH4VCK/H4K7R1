#import "MenuView.h"

@interface MenuView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGPoint lastLocation;
@end

@implementation MenuView

static MenuView *sharedInstance = nil;

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect screen = [UIScreen mainScreen].bounds;
        sharedInstance = [[MenuView alloc] initWithFrame:CGRectMake(20, 80, screen.size.width - 40, screen.size.height - 150)];
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
    self.backgroundColor = [UIColor colorWithWhite:0.08 alpha:0.95];
    self.layer.cornerRadius = 16;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRed:0.9 green:0.3 blue:0.2 alpha:0.6].CGColor;
    self.clipsToBounds = YES;
    
    // Title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 30)];
    self.titleLabel.text = @"DEKU MENU";
    self.titleLabel.textColor = [UIColor colorWithRed:0.9 green:0.3 blue:0.2 alpha:1.0];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:self.titleLabel];
    
    // Subtitle
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 200, 20)];
    self.subTitleLabel.text = @"by zexisy";
    self.subTitleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    self.subTitleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.subTitleLabel];
    
    // Close button
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(self.frame.size.width - 45, 15, 35, 35);
    [closeBtn setTitle:@"X" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.backgroundColor = [UIColor colorWithRed:0.9 green:0.3 blue:0.2 alpha:0.8];
    closeBtn.layer.cornerRadius = 17.5;
    [closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    // ScrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, self.frame.size.width, self.frame.size.height - 70)];
    self.scrollView.showsVerticalScrollIndicator = YES;
    [self addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200)];
    [self.scrollView addSubview:self.contentView];
    
    // Content
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.frame.size.width - 30, 30)];
    label.text = @"CHAMS";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:label];
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(15, 50, 50, 30)];
    sw.onTintColor = [UIColor colorWithRed:0.9 green:0.3 blue:0.2 alpha:1.0];
    [self.contentView addSubview:sw];
    
    self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, 100);
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, 100);
    
    // Drag
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.superview];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.lastLocation = self.center;
    }
    self.center = CGPointMake(self.lastLocation.x + translation.x, self.lastLocation.y + translation.y);
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
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
