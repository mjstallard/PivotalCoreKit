#import "SpecHelper.h"
#import "UIWindow+Spec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(UIWindow_SpecSpec)

describe(@"UIWindow_Spec", ^{
    describe(@"finding the first responder", ^{
        __block UIWindow *window;
        __block UITextField *firstResponderGrandchild;
        __block BOOL grandchildIsFirstResponder;

        beforeEach(^{
            window = [[[UIWindow alloc] init] retain];
            UITextField *child1 = [[[UITextField alloc] init] autorelease];
            UITextField *child2 = [[[UITextField alloc] init] autorelease];
            UITextField *grandchild1 = [[[UITextField alloc] init] autorelease];
            UITextField *grandchild2 = [[[UITextField alloc] init] autorelease];
            firstResponderGrandchild = [[[UITextField alloc] init] autorelease];

            [window addSubview:child1];
            [window addSubview:child2];
            [child1 addSubview:grandchild1];
            [child2 addSubview:grandchild2];
            [child2 addSubview:firstResponderGrandchild];
            grandchildIsFirstResponder = [firstResponderGrandchild becomeFirstResponder];
        });

        it(@"should properly assign first responder", ^{
            grandchildIsFirstResponder should equal(YES);
        });
        
        it(@"returns the first responder", ^{
            window.firstResponder should be_same_instance_as(firstResponderGrandchild);
        });

        afterEach(^{
            [window release];
        });
    });
});

SPEC_END
