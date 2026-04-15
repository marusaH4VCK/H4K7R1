#import <UIKit/UIKit.h>
#import "UI/MenuView.h"

static MenuView *menu = nil;

UIWindow *getKeyWindow(void) {
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive &&
            [scene isKindOfClass:[UIWindowScene class]]) {
            return [(UIWindowScene *)scene windows].firstObject;
        }
    }
    return nil;
}

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *window = getKeyWindow();
        if (window) {
            if (!menu) {
                menu = [MenuView shared];
                [window addSubview:menu];
                [menu show];
            }
        }
    });
}
