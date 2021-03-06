//
//  SNLaunchPageViewController.m
//  SporNetApp
//
//  Created by ZhengYang on 16/7/1.
//  Copyright © 2016年 Peng Wang. All rights reserved.
//

#import "SNLaunchPageViewController.h"
#import "SNPageContentViewController.h"

@interface SNLaunchPageViewController ()

@end

@implementation SNLaunchPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageTitles = @[@"Page 1",@"Page 2",@"Page 3",@"Page 4"];
    _pageImages = @[@"page1.png",@"page2.png",@"page3.png",@"page4.png"];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    SNPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//previous page
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = ((SNPageContentViewController*) viewController).pageIndex;
    if ((index == 0)||(index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

//next page
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = ((SNPageContentViewController*) viewController).pageIndex;
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == self.pageTitles.count) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
    
}

//current page
-(SNPageContentViewController *)viewControllerAtIndex:(NSInteger)index{
    if ((self.pageTitles.count == 0)||(index == self.pageTitles.count)) {
        return nil;
    }
    SNPageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.pageTitles.count;

}

//which index for the first page
-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
