//
//  XYJKVOObserver.h
//  XYJiOSTool
//
//  Created by 肖迎军 on 2019/2/19.
//  Copyright © 2019 肖迎军. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class XYJKVOObserver;


typedef void(^XYJKVOObserverChangeHandler)(XYJKVOObserver * sender, id _Nullable object, NSString * _Nullable keyPath, id _Nullable change, id _Nullable changeIndexes, id _Nullable changeOld, id _Nullable changeNew, id _Nullable isPrior);

typedef void(^XYJKVOObserverSettingHandler)(XYJKVOObserver * sender, id _Nullable object, NSString * _Nullable keyPath, id _Nullable beforeChange, id _Nullable afterChange, BOOL isPrior);

typedef void(^XYJKVOObserverInsertionHandler)(XYJKVOObserver * sender, id _Nullable object, NSString * _Nullable keyPath, NSIndexSet * indexes, NSArray * objs, BOOL isPrior);

typedef void(^XYJKVOObserverRemovalHandler)(XYJKVOObserver * sender, id _Nullable object, NSString * _Nullable keyPath, NSIndexSet * indexes, NSArray * objs, BOOL isPrior);

typedef void(^XYJKVOObserverReplacementHandler)(XYJKVOObserver * sender, id _Nullable object, NSString * _Nullable keyPath, NSIndexSet * indexes, NSArray * beforeObjs, NSArray * afterObjs, BOOL isPrior);


@interface XYJKVOObserver : NSObject

@property (nonatomic, readonly, nullable) NSObject * object;
@property (nonatomic, readonly, nullable, copy) NSString * keyPath;
@property (nonatomic, readonly, assign) NSKeyValueObservingOptions options;
@property (nonatomic, readonly, assign) void * context;

@property (nonatomic, nullable) XYJKVOObserverChangeHandler changeHandler;
@property (nonatomic, nullable) XYJKVOObserverSettingHandler settingHandler;
@property (nonatomic, nullable) XYJKVOObserverInsertionHandler insertionHandler;
@property (nonatomic, nullable) XYJKVOObserverRemovalHandler removalHandler;
@property (nonatomic, nullable) XYJKVOObserverReplacementHandler replacementHandler;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithObject:(NSObject*)object keyPath:(NSString*)keyPath;
- (instancetype)initWithObject:(NSObject*)object keyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options context:(void* _Nullable)context;

@end

NS_ASSUME_NONNULL_END
