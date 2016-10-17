
#import "ViewController.h"
#import "GestureViewController.h"
#import "GestureVerifyViewController.h"
#import "PCCircleView.h"

@interface ViewController ()<UIAlertViewDelegate>

- (IBAction)BtnClick:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"手势解锁";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (IBAction)BtnClick:(UIButton *)sender {
    
    [PCCircleViewConst saveLockCodeKey:@"qiye"];
    
    switch (sender.tag) {
        case 1:
        {
            GestureViewController *gestureVc = [[GestureViewController alloc] init];
            gestureVc.type = GestureViewControllerTypeSetting;
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:gestureVc] animated:YES completion:nil];
        }
            break;
        case 2:
        {
            GestureViewController *gestureVc = [[GestureViewController alloc] init];
            gestureVc.type = GestureViewControllerTypeVerify;
            gestureVc.loginUseOtherAccountBlock = ^(){
                
            };
            gestureVc.getPwdBlock = ^(NSString *pwd,id vc){
                [vc dismissViewControllerAnimated:YES completion:nil];
                
                GestureViewController *gestureVc = [[GestureViewController alloc] init];
                gestureVc.type = GestureViewControllerTypeSetting;
                [self presentViewController:[[UINavigationController alloc] initWithRootViewController:gestureVc] animated:YES completion:nil];

            };
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:gestureVc] animated:YES completion:nil];
        }
            break;
        case 3:
        {
            GestureVerifyViewController *gestureVerifyVc = [[GestureVerifyViewController alloc] init];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:gestureVerifyVc] animated:YES completion:nil];
        }
            break;
            
        case 4:
        {
            GestureVerifyViewController *gestureVerifyVc = [[GestureVerifyViewController alloc] init];
            gestureVerifyVc.isToSetNewGesture = YES;
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:gestureVerifyVc] animated:YES completion:nil];
        }
            break;
        case 5:
        {
//            AYGestureViewController *controller = [[AYGestureViewController alloc] init];
//            controller.type = [AYGestureViewController hasGesture] ? AYGestureTypeModify : AYGestureTypeSetting;
//            [self presentViewController:controller animated:YES completion:NULL];
        }
            break;
            
        case 6:
        {
//            [AYGestureViewController removeGesture];
//            
//            [[[UIAlertView alloc] initWithTitle:@"手势密码已清除" message:nil delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil] show];
        }
            break;
        default:
            break;
    }
}

@end
