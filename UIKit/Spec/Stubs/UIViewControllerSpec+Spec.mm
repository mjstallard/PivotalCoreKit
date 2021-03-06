#import <UIKit/UIKit.h>
#import <Cedar-iOS.h>

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIViewControllerSpecExtensionsSpec)

describe(@"UIViewController (spec extensions)", ^{
    __block UIViewController *controller, *childController;
    __block UINavigationController *modalController;

    beforeEach(^{
        controller = [[UIViewController alloc] init];
        childController = [[UIViewController alloc] init];
        modalController = [[UINavigationController alloc] initWithRootViewController:childController];
    });

    describe(@"presenting modal view controllers", ^{
        __block BOOL completeBlockWasCalled;
        beforeEach(^{
            completeBlockWasCalled = NO;
            [controller presentViewController:modalController animated:YES completion:^{
                completeBlockWasCalled = YES;
            }];
        });

        it(@"should invoke the complete block", ^{
            completeBlockWasCalled should be_truthy;
        });

        it(@"should set the presentedViewController as the modal controller", ^{
            controller.presentedViewController should be_same_instance_as(modalController);
        });

        it(@"should set the presentingViewController on the modal controller", ^{
            modalController.presentingViewController should be_same_instance_as(controller);
        });

        describe(@"dismissing the modal using a child view controller", ^{
            beforeEach(^{
                completeBlockWasCalled = NO;
                [childController dismissViewControllerAnimated:YES completion:^{
                    completeBlockWasCalled = YES;
                }];
            });

            it(@"should invoke the complete block", ^{
                completeBlockWasCalled should be_truthy;
            });

            it(@"should remove the presented view controller", ^{
                controller.presentedViewController should be_nil;
            });

            it(@"should remove the presenting view controller", ^{
                modalController.presentingViewController should be_nil;
            });
        });

        describe(@"dismissing the modal using the parent view controller", ^{
            beforeEach(^{
                completeBlockWasCalled = NO;
                [controller dismissViewControllerAnimated:YES completion:^{
                    completeBlockWasCalled = YES;
                }];
            });

            it(@"should invoke the complete block", ^{
                completeBlockWasCalled should be_truthy;
            });

            it(@"should remove the presented view controller", ^{
                controller.presentedViewController should be_nil;
            });

            it(@"should remove the presenting view controller", ^{
                modalController.presentingViewController should be_nil;
            });
        });

        describe(@"dismissing the modal using the modal view controller", ^{
            beforeEach(^{
                completeBlockWasCalled = NO;
                [modalController dismissViewControllerAnimated:YES completion:^{
                    completeBlockWasCalled = YES;
                }];
            });

            it(@"should invoke the complete block", ^{
                completeBlockWasCalled should be_truthy;
            });

            it(@"should remove the presented view controller", ^{
                controller.presentedViewController should be_nil;
            });

            it(@"should remove the presenting view controller", ^{
                modalController.presentingViewController should be_nil;
            });
        });

        describe(@"presenting another modal controller", ^{
            it(@"should raise an exception", ^{
                ^{
                    UIViewController *viewController = [[UIViewController alloc] init];
                    [controller presentViewController:viewController animated:YES completion:nil];
                } should raise_exception;
            });
        });
    });

    describe(@"presenting modal view controllers (deprecated APIs)", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        beforeEach(^{
            [controller presentModalViewController:modalController animated:YES];
        });

        it(@"should set the presentedViewController as the modal controller", ^{
            controller.presentedViewController should be_same_instance_as(modalController);
        });

        describe(@"dismissing the modal using a child view controller", ^{
            beforeEach(^{
                [childController dismissModalViewControllerAnimated:YES];
            });

            it(@"should remove the presented view controller", ^{
                controller.presentedViewController should be_nil;
            });

            it(@"should remove the presenting view controller", ^{
                modalController.presentingViewController should be_nil;
            });
        });

        describe(@"dismissing the modal using the parent view controller", ^{
            beforeEach(^{
                [controller dismissModalViewControllerAnimated:YES];
            });

            it(@"should remove the presented view controller", ^{
                controller.presentedViewController should be_nil;
            });

            it(@"should remove the presenting view controller", ^{
                modalController.presentingViewController should be_nil;
            });
        });
#pragma clang diagnostic pop
    });
});

SPEC_END
