//
//  XYJKVOObserver.m
//  XYJiOSTool
//
//  Created by 肖迎军 on 2019/2/19.
//  Copyright © 2019 肖迎军. All rights reserved.
//

#import "XYJKVOObserver.h"

@interface XYJKVOObserver ()

@property (nonatomic, nullable) NSObject * object;
@property (nonatomic, nullable, copy) NSString * keyPath;
@property (nonatomic, assign) NSKeyValueObservingOptions options;
@property (nonatomic, assign, nullable) void * context;

@end

@implementation XYJKVOObserver

- (instancetype)initWithObject:(NSObject*)object keyPath:(NSString*)keyPath {
    return [self initWithObject:object keyPath:keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}

- (instancetype)initWithObject:(NSObject*)object keyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options context:(void*)context {
    if (self = [super init]) {
        self.object = object;
        self.keyPath = keyPath;
        self.options = options;
        self.context = context;
        [_object addObserver:self forKeyPath:_keyPath options:_options context:_context];
    }
    return self;
}

- (void)dealloc {
    [_object removeObserver:self forKeyPath:_keyPath context:_context];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == _context) {
        if (object == _object) {
            if ([keyPath isEqualToString:_keyPath]) {
                id changeKind = change[NSKeyValueChangeKindKey];
                id changeOld = change[NSKeyValueChangeOldKey];
                id changeNew = change[NSKeyValueChangeNewKey];
                id changeIndexes = change[NSKeyValueChangeIndexesKey];
                id isPrior = change[NSKeyValueChangeNotificationIsPriorKey];
                
                if (_changeHandler) {
                    _changeHandler (self, object, keyPath, changeKind, changeIndexes, changeOld, changeNew, isPrior);
                }
                else {
                    NSKeyValueChange changeKindEnum = ((NSNumber*)changeKind).integerValue;
                    BOOL bIsPrior = isPrior && ((NSNumber*)isPrior).boolValue;
                    
                    switch (changeKindEnum) {
                        case NSKeyValueChangeSetting: {
                            id changeOldObj = (changeOld == [NSNull null]) ? nil : changeOld;
                            id changeNewObj = (changeNew == [NSNull null]) ? nil : changeNew;
                            if (_settingHandler) {
                                _settingHandler (self, object, keyPath, changeOldObj, changeNewObj, bIsPrior);
                            }
                        }
                            break;
                        case NSKeyValueChangeInsertion: {
                            if (_insertionHandler) {
                                NSIndexSet * changeIndexesSet = changeIndexes;
                                NSArray * changeNewArray = changeNew;
                                NSAssert([changeIndexesSet isKindOfClass:[NSIndexSet class]], @"");
                                NSAssert([changeNewArray isKindOfClass:[NSArray class]], @"");
                                _insertionHandler (self, object, keyPath, changeIndexesSet, changeNewArray, bIsPrior);
                            }
                        }
                            break;
                        case NSKeyValueChangeRemoval: {
                            if (_removalHandler) {
                                NSIndexSet * changeIndexesSet = changeIndexes;
                                NSArray * changeOldArray = changeOld;
                                NSAssert([changeIndexesSet isKindOfClass:[NSIndexSet class]], @"");
                                NSAssert([changeOldArray isKindOfClass:[NSArray class]], @"");
                                _removalHandler (self, object, keyPath, changeIndexesSet, changeOldArray, bIsPrior);
                            }
                        }
                            break;
                        case NSKeyValueChangeReplacement: {
                            if (_replacementHandler) {
                                NSIndexSet * changeIndexesSet = changeIndexes;
                                NSArray * changeOldArray = changeOld;
                                NSArray * changeNewArray = changeNew;
                                NSAssert([changeIndexesSet isKindOfClass:[NSIndexSet class]], @"");
                                NSAssert([changeOldArray isKindOfClass:[NSArray class]], @"");
                                NSAssert([changeNewArray isKindOfClass:[NSArray class]], @"");
                                _replacementHandler (self, object, keyPath, changeIndexesSet, changeOldArray, changeNewArray, bIsPrior);
                            }
                        }
                            break;
                    }
                }
            }
        }
    }
}

@end
