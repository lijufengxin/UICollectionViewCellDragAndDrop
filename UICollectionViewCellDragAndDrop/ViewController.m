//
//  ViewController.m
//  UICollectionViewCellDragAndDrop
//
//  Created by fengxin on 2018/8/3.
//  Copyright © 2018年 fengxin. All rights reserved.
//

#import "ViewController.h"
#import "FXCollectionViewCell.h"
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDragDelegate,UICollectionViewDropDelegate>
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.array =  [NSMutableArray arrayWithObjects:@"tag1", @"tag2", @"tag3", @"tag4",
                   @"tag5", @"tag6", @"tag7", @"tag8",
                   @"tag9", @"tag10", @"tag11", @"tag12",@"tag13", @"tag14", @"tag15", @"tag16",
                   @"tag17", @"tag18", @"tag19", @"tag20",  nil];
    [self.view addSubview:self.collectionView];
}

#pragma UICollectionViewDragDelegate
- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath{
    NSString *tagName = [self.array objectAtIndex:indexPath.item];
    NSItemProvider *itemProvider = [[NSItemProvider alloc]initWithObject:tagName];
    UIDragItem *dragItem = [[UIDragItem alloc]initWithItemProvider:itemProvider];
    dragItem.localObject = tagName;
    return @[dragItem];
}

#pragma UICollectionViewDropDelegate


// 是否接收拖动的item。
- (BOOL)collectionView:(UICollectionView *)collectionView canHandleDropSession:(id<UIDropSession>)session {
    return [session canLoadObjectsOfClass:[NSString class]];
}

// 拖动过程中不断反馈item位置。
- (UICollectionViewDropProposal *)collectionView:(UICollectionView *)collectionView dropSessionDidUpdate:(id<UIDropSession>)session withDestinationIndexPath:(NSIndexPath *)destinationIndexPath {
    UICollectionViewDropProposal *dropProposal;
    if (session.localDragSession) {
        // 拖动手势源自同一app。
        dropProposal = [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationMove intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
    } else {
        // 拖动手势源自其它app。
        dropProposal = [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationCopy intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
    }
    return dropProposal;
}


- (void)collectionView:(UICollectionView *)collectionView performDropWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator{
    
    //如果coordinator.destinationIndexPath 存在，直接返回。如果不存在则返回(0,0)
    NSIndexPath *destinationIndexPath = coordinator.destinationIndexPath?coordinator.destinationIndexPath:[NSIndexPath indexPathForItem:0 inSection:0];
    if (coordinator.items.count == 1 && coordinator.items.firstObject.sourceIndexPath) {
        NSIndexPath *sourceIndexPath = coordinator.items.firstObject.sourceIndexPath;
        [collectionView performBatchUpdates:^{
            NSString *tagName = coordinator.items.firstObject.dragItem.localObject;
            [self.array removeObjectAtIndex:sourceIndexPath.item];
            [self.array insertObject:tagName atIndex:destinationIndexPath.item];
            [collectionView deleteItemsAtIndexPaths:@[sourceIndexPath]];
            [collectionView insertItemsAtIndexPaths:@[destinationIndexPath]];
            
        } completion:^(BOOL finished) {
            
        }];
    }
}




#pragma mark---UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FXCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentiifer" forIndexPath:indexPath];
    cell.markLabel.text = self.array[indexPath.item];
    cell.deleteButton.hidden = YES;
    
    return cell;
}


#pragma mark---UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",self.array[indexPath.item]);
}




//懒加载
- (NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.view.frame.size.width/4 - 30, 55);
        layout.footerReferenceSize = CGSizeMake(0, 0);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 64, self.view.frame.size.width - 20, self.view.frame.size.height - 64) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        
        _collectionView.backgroundColor = [UIColor redColor];
        _collectionView.delegate = self;
        
        self.collectionView.dragInteractionEnabled = YES;
        self.collectionView.dragDelegate = self;
        self.collectionView.dropDelegate = self;
        
        [_collectionView registerClass:[FXCollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentiifer"];
    }
    return _collectionView;
}


- (void)btnDelete:(UIButton *)btn{
    //cell的隐藏删除设置
    NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[_longPress locationInView:self.collectionView]];
    // 找到当前的cell
    FXCollectionViewCell *cell = (FXCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:selectIndexPath];
    cell.deleteButton.hidden = NO;
    //取出源item数据
    id objc = [self.array objectAtIndex:btn.tag];
    //从资源数组中移除该数据
    [self.array removeObject:objc];
    [self.collectionView reloadData];
    
}

@end
