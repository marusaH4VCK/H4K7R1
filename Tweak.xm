#import <UIKit/UIKit.h>
#import "UI/MenuView.h"

static MenuView *menu = nil;

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (window) {
            if (!menu) {
                menu = [MenuView shared];
                [window addSubview:menu];
                [menu show];
            }
        }
    });
}
