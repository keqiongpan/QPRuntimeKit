# QPRuntimeKit

[![GitHub License](https://img.shields.io/github/license/keqiongpan/QPRuntimeKit.svg)](https://github.com/keqiongpan/QPRuntimeKit/blob/master/LICENSE)
[![CocoaPods Version](https://img.shields.io/cocoapods/v/QPRuntimeKit.svg)](https://cocoapods.org/pods/QPRuntimeKit)
[![Carthage Compatible](https://img.shields.io/badge/carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Platforms](https://img.shields.io/cocoapods/p/QPRuntimeKit.svg)](https://cocoapods.org/pods/QPRuntimeKit)

对Objective-C Runtime进行封装以符合其类型体系的方式对运行时对象进行解析或修改。


## 使用CocoaPods集成

QPRuntimeKit 支持使用第三方库管理工具 [CocoaPods](http://cocoapods.org) 集成到你的 Xcode 工程。详情可查看 [这里](https://cocoapods.org/pods/QPRuntimeKit) 。

可以在 Podfile 文件中添加如下项：

```
pod 'QPRuntimeKit', '~> 0.1.2'
```


## 使用Carthage集成

QPRuntimeKit 同时兼容使用去中心化的库管理工具 [Carthage](https://github.com/Carthage/Carthage)  集成到你的 Xcode 工程。

可以在 Cartfile 文件中添加如下项：

```
github "keqiongpan/QPRuntimeKit" ~> 0.1.1
```


## 使用说明

QPRuntimeKit 支持通过 Objective-C Runtime 的各种原型类型初始化运行时类型对象，并且与运行时所以暗示的结构体系相一致。这样使得 QPRuntimeKit 可以非常灵活有弹性地与 Objective-C Runtime API 一起工作，并且相机互兼容。

下面是 Objective-C Runtime 类型与 QPRuntimeKit 中的类型对象的对应表格：

| Objective-C Runtime Types   | QPRuntimeKit Classes | Initialize Methods                                           |
| --------------------------- | -------------------- | ------------------------------------------------------------ |
| -                           | RKRuntime            | +[RKRuntime sharedInstance]                                  |
| -                           | RKImage              | +[RKImage imageWithName:(NSString *)name]                    |
| id                          | RKObject             | +[RKObject objectWithPrototype:(id)anObject]                 |
| Class                       | RKClass              | +[RKClass classWithPrototype:(__unsafe_unretained Class)aClass] |
| Protocol *                  | RKProtocol           | +[RKProtocol protocolWithPrototype:(__unsafe_unretained Protocol *)prototype] |
| Method                      | RKMethod             | +[RKMethod methodWithPrototype:(Method)prototype]            |
| objc_method_description *   | RKMethodDescription  | +[RKMethodDescription methodDescriptionWithPrototype:(const struct objc_method_description *)prototype] |
| IMP                         | RKImplementation     | +[RKImplementation implementationWithPrototype:(IMP)prototype] |
| objc_property_t             | RKProperty           | +[RKProperty propertyWithPrototype:(objc_property_t)prototype] |
| objc_property_attribute_t * | RKPropertyAttribute  | +[RKPropertyAttribute propertyAttributeWithPrototype:(const objc_property_attribute_t *)prototype] |
| Ivar                        | RKIvar               | +[RKIvar ivarWithPrototype:(Ivar)prototype]                  |
| uint8_t *                   | RKIvarLayout         | +[RKIvarLayout ivarLayoutWithPrototype:(const uint8_t *)prototype] |
| SEL                         | RKSelector           | +[RKSelector selectorWithPrototype:(SEL)selector]            |
| char *                      | RKTypeEncoding       | +[RKTypeEncoding typeEncodingWithPrototype:(const char *)prototype] |
| char *                      | RKMethodTypeEncoding | +[RKMethodTypeEncoding typeEncodingWithPrototype:(const char *)prototype] |


## 使用示例

以 NSObject 类为例，使用 RKClass 初始化 NSObject 的运行时类型对象，并打印 NSObject 的所有明细信息。

```Objective-C
RKClass *objectClass = [RKClass classWithPrototype:[NSObject class]];
NSLog(@"NSObject's runtime description:\n%@", objectClass);
```

下面是输出结果：

```Objective-C
NSObject's runtime description:
//
// NSObject (Version 0, 8 Bytes)
//
// The class `NSObject' was exported from libobjc.A.dylib, that the image path is:
// /usr/lib/libobjc.A.dylib
//
@interface NSObject <CARenderValue, CAAnimatableValue, NSObject>
+ [Property] accessInstanceVariablesDirectly<Type=c, ReadOnly>
+ [Method] initialize(@, :) -> v
+ [Method] alloc(@, :) -> @
+ [Method] self(@, :) -> @
+ [Method] allocWithZone:(@, :, ^{_NSZone=}) -> @
+ [Method] new(@, :) -> @
+ [Method] class(@, :) -> #
+ [Method] retain(@, :) -> @
+ [Method] resolveInstanceMethod:(@, :, :) -> c
+ [Method] resolveClassMethod:(@, :, :) -> c
+ [Method] respondsToSelector:(@, :, :) -> c
+ [Method] release(@, :) -> Vv [Oneway]
+ [Method] instanceMethodForSelector:(@, :, :) -> ^?
+ [Method] isSubclassOfClass:(@, :, #) -> c
+ [Method] hash(@, :) -> Q
+ [Method] isEqual:(@, :, @) -> c
+ [Method] isKindOfClass:(@, :, #) -> c
+ [Method] conformsToProtocol:(@, :, @) -> c
+ [Method] superclass(@, :) -> #
+ [Method] autorelease(@, :) -> @
+ [Method] performSelector:(@, :, :) -> @
+ [Method] methodForSelector:(@, :, :) -> ^?
+ [Method] zone(@, :) -> ^{_NSZone=}
+ [Method] copyWithZone:(@, :, ^{_NSZone=}) -> @
+ [Method] instancesRespondToSelector:(@, :, :) -> c
+ [Method] isAncestorOfObject:(@, :, @) -> c
+ [Method] allowsWeakReference(@, :) -> c
+ [Method] retainWeakReference(@, :) -> c
+ [Method] performSelector:withObject:(@, :, :, @) -> @
+ [Method] isMemberOfClass:(@, :, #) -> c
+ [Method] isFault(@, :) -> c
+ [Method] isProxy(@, :) -> c
+ [Method] doesNotRecognizeSelector:(@, :, :) -> v
+ [Method] performSelector:withObject:withObject:(@, :, :, @, @) -> @
+ [Method] instanceMethodSignatureForSelector:(@, :, :) -> @
+ [Method] methodSignatureForSelector:(@, :, :) -> @
+ [Method] forwardInvocation:(@, :, @) -> v
+ [Method] forwardingTargetForSelector:(@, :, :) -> @
+ [Method] description(@, :) -> @
+ [Method] debugDescription(@, :) -> @
+ [Method] _tryRetain(@, :) -> c
+ [Method] _isDeallocating(@, :) -> c
+ [Method] retainCount(@, :) -> Q
+ [Method] init(@, :) -> @
+ [Method] dealloc(@, :) -> v
+ [Method] copy(@, :) -> @
+ [Method] mutableCopy(@, :) -> @
+ [Method] mutableCopyWithZone:(@, :, ^{_NSZone=}) -> @
- [Ivar] <0x0> isa:#
- [Property] hash<Type=Q, ReadOnly>
- [Property] superclass<Type=#, ReadOnly>
- [Property] debugDescription<Type=@"NSString", ReadOnly, Bycopy>
- [Property] hash<Type=Q, ReadOnly>
- [Property] superclass<Type=#, ReadOnly>
- [Property] debugDescription<Type=@"NSString", ReadOnly, Bycopy>
- [Property] hash<Type=Q, ReadOnly>
- [Property] superclass<Type=#, ReadOnly>
- [Property] debugDescription<Type=@"NSString", ReadOnly, Bycopy>
- [Method] retain(@, :) -> @
- [Method] dealloc(@, :) -> v
- [Method] init(@, :) -> @
- [Method] release(@, :) -> Vv [Oneway]
- [Method] autorelease(@, :) -> @
- [Method] copy(@, :) -> @
- [Method] isEqual:(@, :, @) -> c
- [Method] mutableCopy(@, :) -> @
- [Method] class(@, :) -> #
- [Method] isKindOfClass:(@, :, #) -> c
- [Method] hash(@, :) -> Q
- [Method] self(@, :) -> @
- [Method] respondsToSelector:(@, :, :) -> c
- [Method] isMemberOfClass:(@, :, #) -> c
- [Method] zone(@, :) -> ^{_NSZone=}
- [Method] conformsToProtocol:(@, :, @) -> c
- [Method] methodForSelector:(@, :, :) -> ^?
- [Method] forwardingTargetForSelector:(@, :, :) -> @
- [Method] performSelector:(@, :, :) -> @
- [Method] performSelector:withObject:(@, :, :, @) -> @
- [Method] allowsWeakReference(@, :) -> c
- [Method] _isDeallocating(@, :) -> c
- [Method] performSelector:withObject:withObject:(@, :, :, @, @) -> @
- [Method] retainWeakReference(@, :) -> c
- [Method] retainCount(@, :) -> Q
- [Method] _tryRetain(@, :) -> c
- [Method] superclass(@, :) -> #
- [Method] isProxy(@, :) -> c
- [Method] isFault(@, :) -> c
- [Method] doesNotRecognizeSelector:(@, :, :) -> v
- [Method] methodSignatureForSelector:(@, :, :) -> @
- [Method] forwardInvocation:(@, :, @) -> v
- [Method] description(@, :) -> @
- [Method] debugDescription(@, :) -> @
- [Method] finalize(@, :) -> v
@end

// /Applications/Xcode.app/Contents/SharedFrameworks/DVTInstrumentsUtilities.framework/Versions/A/DVTInstrumentsUtilities
@interface NSObject (DVTInstrumentsUtilities)
+ [Method] xr_object:isEqual:(@, :, @, @) -> c
- [Method] xr_isCLIPSSymbol(@, :) -> c
- [Method] xr_clipsStringRepresentation(@, :) -> @
@end

// /Applications/Xcode.app/Contents/SharedFrameworks/DVTInstrumentsUtilities.framework/Versions/A/DVTInstrumentsUtilities
@interface NSObject (XREngineeringValueHelpers)
- [Method] uuidFromEngineeringValue(@, :) -> @
@end

// /Applications/Xcode.app/Contents/SharedFrameworks/DVTInstrumentsUtilities.framework/Versions/A/DVTInstrumentsUtilities
@interface NSObject (XRMobileAgentStopDefaults)
- [Method] agentStopDiagnosticsTypeCode(@, :) -> i
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (_NSBinderKeyValueCodingAdditions)
- [Method] _invokeSelector:withArguments:onKeyPath:(@, :, :, @, @) -> v
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (_NSBindingAdaptorAccess)
- [Method] _releaseBindingAdaptor(@, :) -> v
- [Method] _bindingAdaptor(@, :) -> @
- [Method] _setBindingAdaptor:(@, :, @) -> v
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (_NSBindingCreationDelegateRegistration)
+ [Method] _setBindingCreationDelegate:(@, :, @) -> v
+ [Method] _bindingCreationDelegate(@, :) -> @
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (_NSBindingCreationSupport)
- [Method] _cleanupBindingsWithExistingNibConnectors:exception:(@, :, @, @) -> v
- [Method] _addOptionValue:toArray:withKey:type:(@, :, @, @, @, Q) -> v
- [Method] _addPlaceholderOptionValue:isDefault:toArray:withKey:binder:binding:(@, :, @, c, @, @, @, @) -> v
- [Method] _suggestedControllerKeyForController:binding:(@, :, @, @) -> @
- [Method] _placeSuggestionsInDictionary:acceptableControllers:boundBinders:binder:binding:(@, :, @, @, @, @, @) -> v
- [Method] _bindingInformationWithExistingNibConnectors:availableControllerChoices:(@, :, @, @) -> @
- [Method] _bind:toController:withKeyPath:valueTransformerName:options:existingNibConnectors:connectorsToRemove:connectorsToAdd:(@, :, @, @, @, @, @, @, @, @) -> v
- [Method] _unbind:existingNibConnectors:connectorsToRemove:connectorsToAdd:(@, :, @, @, @, @) -> v
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (_NSTiledLayer)
- [Method] NS_addTiledLayerDescendent:(@, :, @) -> v
- [Method] NS_removeTiledLayerDescendent:(@, :, @) -> v
- [Method] NS_tiledLayerVisibleRect(@, :) -> @
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (NSAccessibilityInternal)
- [Method] _accessibilityAttributeNamesClientError:(@, :, ^i) -> @
- [Method] _accessibilityValueForAttribute:clientError:(@, :, @, ^i) -> @
- [Method] _accessibilityCanSetValueForAttribute:clientError:(@, :, @, ^i) -> c
- [Method] _accessibilityIndexOfChild:clientError:(@, :, @, ^i) -> Q
- [Method] _accessibilityArrayAttributeCount:clientError:(@, :, @, ^i) -> Q
- [Method] _accessibilityArrayAttributeValues:index:maxCount:clientError:(@, :, @, Q, Q, ^i) -> @
- [Method] _accessibilityActionDelegate(@, :) -> @
- [Method] accessibilityPerformShowMenuOfChild:(@, :, @) -> c
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (NSAccessibilityNotifications)
- [Method] accessibilitySupportsNotifications(@, :) -> c
- [Method] accessibilityShouldSendNotification:(@, :, @) -> c
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (NSAccessibilityOverriddenAttributes)
- [Method] accessibilityOverriddenAttributes(@, :) -> @
- [Method] accessibilitySupportsOverriddenAttributes(@, :) -> c
- [Method] accessibilityAllowsOverriddenAttributesWhenIgnored(@, :) -> c
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (NSAccessibilityOverriddenAttributesArchiving)
- [Method] accessibilityDecodeOverriddenAttributes:(@, :, @) -> v
- [Method] accessibilityEncodeOverriddenAttributes:(@, :, @) -> v
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (NSAccessibilityOverridingAttributes)
- [Method] accessibilitySetOverrideValue:forAttribute:(@, :, @, @) -> c
- [Method] _accessibilitySetOverrideValue:forAttribute:(@, :, @, @) -> c
- [Method] _accessibilitySetOverrideIsAccessibilityElement:(@, :, c) -> c
- [Method] _accessibilitySetOverrideCustomActions:(@, :, @) -> c
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (NSAccessibilitySectionHelper)
- [Method] _isAccessibilityContentSectionCandidate(@, :) -> c
- [Method] _isAccessibilityContentNavigatorSectionCandidate(@, :) -> c
- [Method] _isAccessibilityTopLevelNavigatorSectionCandidate(@, :) -> c
- [Method] _isAccessibilityContainerSectionCandidate(@, :) -> c
- [Method] _isAccessibilityCandidateForSection:(@, :, @) -> c
- [Method] _shouldSearchChildrenForSection(@, :) -> c
- [Method] accessibilityVisibleArea(@, :) -> d
- [Method] accessibilityReplaceRange:withText:(@, :, {_NSRange=QQ}, @) -> c
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (NSAccessibilityTemporaryChildren)
- [Method] accessibilityAddTemporaryChild:(@, :, @) -> v
- [Method] accessibilityRemoveTemporaryChild:(@, :, @) -> v
- [Method] accessibilityTemporaryChildren(@, :) -> @
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (NSAccessibilityUIElementSpecifier)
- [Method] accessibilitySupportsCustomElementData(@, :) -> c
- [Method] _accessibilityUIElementSpecifier(@, :) -> @
- [Method] _accessibilityUIElementSpecifierRegisterIfNeeded:(@, :, c) -> @
- [Method] _accessibilityIsTableViewDescendant(@, :) -> c
- [Method] _accessibilityUIElementSpecifierForChild:registerIfNeeded:(@, :, @, c) -> @
- [Method] _accessibilitySpecifierComponentForChildUIElement:registerIfNeeded:(@, :, @, c) -> q
- [Method] accessibilityShouldUseUniqueId(@, :) -> c
- [Method] _accessibilityChildUIElementForSpecifierComponent:(@, :, q) -> @
- [Method] _accessibilityCustomDataBlob(@, :) -> @
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (NSAccessibilityUseConvenienceAPI)
- [Method] _accessibilitySetUseConvenienceAPI:(@, :, c) -> v
- [Method] _accessibilityUseConvenienceAPI(@, :) -> c
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (NSIBObjectDataAXExtras)
- [Method] _isAXConnector(@, :) -> c
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (NSKeyValueBindingCreation)
+ [Method] _exposedBindings(@, :) -> @
+ [Method] _exposeBinding:valueClass:(@, :, @, #) -> v
+ [Method] _guaranteeStorageInDictionary:addBinding:(@, :, @, @) -> @
+ [Method] _concealBinding:(@, :, @) -> v
+ [Method] exposeBinding:(@, :, @) -> v
- [Property] exposedBindings<Type=@"NSArray", ReadOnly, Bycopy>
- [Method] bind:toObject:withKeyPath:options:(@, :, @, @, @, @) -> v
- [Method] _binderForBinding:withBinders:createAutoreleasedInstanceIfNotFound:(@, :, @, @, c) -> @
- [Method] unbind:(@, :, @) -> v
- [Method] infoForBinding:(@, :, @) -> @
- [Method] exposedBindings(@, :) -> @
- [Method] _binderClassForBinding:withBinders:(@, :, @, @) -> #
- [Method] _binderWithClass:withBinders:createAutoreleasedInstanceIfNotFound:(@, :, #, @, c) -> @
- [Method] valueClassForBinding:(@, :, @) -> #
- [Method] optionDescriptionsForBinding:(@, :, @) -> @
- [Method] _optionDescriptionsForBinding:(@, :, @) -> @
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (NSLifeguard)
- [Method] NSLifeguard_autorelease(@, :) -> @
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (NSNibAwaking)
- [Method] awakeFromNib(@, :) -> v
- [Method] prepareForInterfaceBuilder(@, :) -> v
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (NSObjectAccessibilityAttributeAccessAdditions)
- [Method] accessibilityIndexOfChild:(@, :, @) -> Q
- [Method] accessibilityArrayAttributeCount:(@, :, @) -> Q
- [Method] accessibilityArrayAttributeValues:index:maxCount:(@, :, @, Q, Q) -> @
- [Method] accessibilityParameterizedAttributeNames(@, :) -> @
- [Method] accessibilityAttributeValue:forParameter:(@, :, @, @) -> @
- [Method] accessibilityIndexForChildUIElementAttributeForParameter:(@, :, @) -> @
- [Method] accessibilityAttributedValueForStringAttributeAttributeForParameter:(@, :, @) -> @
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (NSPlaceholders)
+ [Method] defaultPlaceholderForMarker:withBinding:(@, :, @, @) -> @
+ [Method] _registerDefaultPlaceholders(@, :) -> v
+ [Method] setDefaultPlaceholder:forMarker:withBinding:(@, :, @, @, @) -> v
+ [Method] _stateMarkerForValue:(@, :, @) -> @
+ [Method] _registerObjectClass:placeholder:binding:(@, :, #, @, @) -> v
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (NSRemoteUIElementAccessibility)
- [Method] accessibilitySetPresenterProcessIdentifier:(@, :, i) -> v
- [Method] accessibilityPresenterProcessIdentifier(@, :) -> i
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (NSSetVersionHacks)
+ [Method] _kitNewObjectSetVersion:(@, :, q) -> v
@end

// /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
@interface NSObject (NSUserInterfaceItemIdentification)
- [Method] userInterfaceItemIdentifier(@, :) -> @
- [Method] setUserInterfaceItemIdentifier:(@, :, @) -> v
@end

// /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
@interface NSObject (__NSCFType)
- [Method] _cfTypeID(@, :) -> Q
@end

// /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
@interface NSObject (NSKindOfAdditions)
- [Method] isNSString__(@, :) -> c
- [Method] isNSNumber__(@, :) -> c
- [Method] isNSDate__(@, :) -> c
- [Method] isNSObject__(@, :) -> c
- [Method] isNSCFConstantString__(@, :) -> c
- [Method] isNSDictionary__(@, :) -> c
- [Method] isNSArray__(@, :) -> c
- [Method] isNSData__(@, :) -> c
- [Method] isNSSet__(@, :) -> c
- [Method] isNSOrderedSet__(@, :) -> c
- [Method] isNSValue__(@, :) -> c
- [Method] isNSTimeZone__(@, :) -> c
@end

// /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
@interface NSObject (NSObject) <CARenderValue>
+ [Method] load(@, :) -> v
+ [Method] instanceMethodSignatureForSelector:(@, :, :) -> @
+ [Method] methodSignatureForSelector:(@, :, :) -> @
+ [Method] description(@, :) -> @
+ [Method] _copyDescription(@, :) -> @
+ [Method] doesNotRecognizeSelector:(@, :, :) -> v
+ [Method] __allocWithZone_OA:(@, :, ^{_NSZone=}) -> @
+ [Method] init(@, :) -> @
+ [Method] dealloc(@, :) -> v
- [Property] description<Type=@"NSString", ReadOnly, Bycopy>
- [Property] description<Type=@"NSString", ReadOnly, Bycopy>
- [Property] description<Type=@"NSString", ReadOnly, Bycopy>
- [Method] _copyDescription(@, :) -> @
- [Method] description(@, :) -> @
- [Method] methodSignatureForSelector:(@, :, :) -> @
- [Method] doesNotRecognizeSelector:(@, :, :) -> v
- [Method] __retain_OA(@, :) -> @
- [Method] ___tryRetain_OA(@, :) -> c
- [Method] __release_OA(@, :) -> Vv [Oneway]
- [Method] __autorelease_OA(@, :) -> @
- [Method] __dealloc_zombie(@, :) -> v
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (DefaultObservationImplementations)
- [Method] addObserverBlock:(@, :, @?) -> @
- [Method] receiveObservedValue:(@, :, @) -> v
- [Method] _destroyObserverList(@, :) -> v
- [Method] _overrideUseFastBlockObservers(@, :) -> c
- [Method] finishObserving(@, :) -> v
- [Method] addChainedObservers:(@, :, @) -> @
- [Method] addObservationTransformer:(@, :, @?) -> @
- [Method] _observerStorage(@, :) -> ^@
- [Method] _observerStorageOfSize:(@, :, Q) -> ^v
- [Method] _isToManyChangeInformation(@, :) -> c
- [Method] receiveObservedError:(@, :, @) -> v
- [Method] addObserver:(@, :, @) -> @
- [Method] removeObservation:(@, :, @) -> v
- [Method] _receiveBox:(@, :, @) -> v
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (KVOKeyPathSupport)
- [Method] addObserver:forObservableKeyPath:(@, :, @, @) -> @
- [Method] removeObservation:forObservableKeyPath:(@, :, @, @) -> v
- [Method] setObservation:forObservingKeyPath:(@, :, @, @) -> v
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSArchiverCallBack)
- [Method] classForArchiver(@, :) -> #
- [Method] replacementObjectForArchiver:(@, :, @) -> @
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSClassDescriptionPrimitives)
- [Property] classDescription<Type=@"NSClassDescription", ReadOnly, Bycopy>
- [Property] attributeKeys<Type=@"NSArray", ReadOnly, Bycopy>
- [Property] toOneRelationshipKeys<Type=@"NSArray", ReadOnly, Bycopy>
- [Property] toManyRelationshipKeys<Type=@"NSArray", ReadOnly, Bycopy>
- [Method] classDescription(@, :) -> @
- [Method] attributeKeys(@, :) -> @
- [Method] toOneRelationshipKeys(@, :) -> @
- [Method] toManyRelationshipKeys(@, :) -> @
- [Method] inverseForRelationshipKey:(@, :, @) -> @
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSComparisonMethods)
- [Method] isEqualTo:(@, :, @) -> c
- [Method] isNotEqualTo:(@, :, @) -> c
- [Method] isLessThanOrEqualTo:(@, :, @) -> c
- [Method] isLessThan:(@, :, @) -> c
- [Method] isGreaterThanOrEqualTo:(@, :, @) -> c
- [Method] isGreaterThan:(@, :, @) -> c
- [Method] doesContain:(@, :, @) -> c
- [Method] isLike:(@, :, @) -> c
- [Method] isCaseInsensitiveLike:(@, :, @) -> c
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSDelayedPerforming)
+ [Method] cancelPreviousPerformRequestsWithTarget:selector:object:(@, :, @, :, @) -> v
+ [Method] cancelPreviousPerformRequestsWithTarget:(@, :, @) -> v
- [Method] performSelector:withObject:afterDelay:(@, :, :, @, d) -> v
- [Method] performSelector:withObject:afterDelay:inModes:(@, :, :, @, d, @) -> v
- [Method] performSelector:object:afterDelay:(@, :, :, @, d) -> v
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSDeprecatedKeyValueCoding)
+ [Method] useStoredAccessor(@, :) -> c
- [Method] _oldValueForKeyPath:(@, :, @) -> @
- [Method] takeValue:forKeyPath:(@, :, @, @) -> v
- [Method] valuesForKeys:(@, :, @) -> @
- [Method] takeValuesFromDictionary:(@, :, @) -> v
- [Method] handleQueryWithUnboundKey:(@, :, @) -> @
- [Method] handleTakeValue:forUnboundKey:(@, :, @, @) -> v
- [Method] unableToSetNilForKey:(@, :, @) -> v
- [Method] _oldValueForKey:(@, :, @) -> @
- [Method] storedValueForKey:(@, :, @) -> @
- [Method] takeValue:forKey:(@, :, @, @) -> v
- [Method] takeStoredValue:forKey:(@, :, @, @) -> v
- [Method] keyValueBindingForKey:typeMask:(@, :, @, Q) -> @
- [Method] _createKeyValueBindingForKey:name:bindingType:(@, :, @, r*, Q) -> @
- [Method] createKeyValueBindingForKey:typeMask:(@, :, @, Q) -> @
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSDeprecatedKeyValueObservingCustomization)
+ [Method] setKeys:triggerChangeNotificationsForDependentKey:(@, :, @, @) -> v
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSDiscardableContentProxy)
- [Property] autoContentAccessingProxy<Type=@, ReadOnly, Byref>
- [Method] autoContentAccessingProxy(@, :) -> @
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSDistantObjectAdditions)
+ [Method] _localClassNameForClass(@, :) -> r*
- [Method] _localClassNameForClass(@, :) -> r*
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSDOAdditions)
+ [Method] instanceMethodDescriptionForSelector:(@, :, :) -> ^{objc_method_description=:*}
+ [Method] methodDescriptionForSelector:(@, :, :) -> ^{objc_method_description=:*}
- [Method] methodDescriptionForSelector:(@, :, :) -> ^{objc_method_description=:*}
- [Method] _conformsToProtocolNamed:(@, :, r*) -> c
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSKeyedArchiverObjectSubstitution)
+ [Method] classFallbacksForKeyedArchiver(@, :) -> @
- [Property] classForKeyedArchiver<Type=#, ReadOnly>
- [Method] replacementObjectForKeyedArchiver:(@, :, @) -> @
- [Method] classForKeyedArchiver(@, :) -> #
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSKeyedUnarchiverObjectSubstitution)
+ [Method] classForKeyedUnarchiver(@, :) -> #
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSKeyValueCoding)
+ [Method] accessInstanceVariablesDirectly(@, :) -> c
+ [Method] _createMutableArrayValueGetterWithContainerClassID:key:(@, :, @, @) -> @
- [Method] valueForKeyPath:(@, :, @) -> @
- [Method] valueForKey:(@, :, @) -> @
- [Method] setValue:forKey:(@, :, @, @) -> v
- [Method] setValue:forKeyPath:(@, :, @, @) -> v
- [Method] setValuesForKeysWithDictionary:(@, :, @) -> v
- [Method] mutableArrayValueForKey:(@, :, @) -> @
- [Method] dictionaryWithValuesForKeys:(@, :, @) -> @
- [Method] mutableSetValueForKey:(@, :, @) -> @
- [Method] mutableArrayValueForKeyPath:(@, :, @) -> @
- [Method] validateValue:forKey:error:(@, :, N^@, @, o^@) -> c
- [Method] mutableOrderedSetValueForKey:(@, :, @) -> @
- [Method] validateValue:forKeyPath:error:(@, :, N^@, @, o^@) -> c
- [Method] mutableOrderedSetValueForKeyPath:(@, :, @) -> @
- [Method] mutableSetValueForKeyPath:(@, :, @) -> @
- [Method] valueForUndefinedKey:(@, :, @) -> @
- [Method] setValue:forUndefinedKey:(@, :, @, @) -> v
- [Method] setNilValueForKey:(@, :, @) -> v
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSKeyValueCodingPrivate)
+ [Method] _createValueSetterWithContainerClassID:key:(@, :, @, @) -> @
+ [Method] _createValuePrimitiveSetterWithContainerClassID:key:(@, :, @, @) -> @
+ [Method] _createOtherValueSetterWithContainerClassID:key:(@, :, @, @) -> @
+ [Method] _createValueGetterWithContainerClassID:key:(@, :, @, @) -> @
+ [Method] _createMutableOrderedSetValueGetterWithContainerClassID:key:(@, :, @, @) -> @
+ [Method] _createMutableSetValueGetterWithContainerClassID:key:(@, :, @, @) -> @
+ [Method] _createValuePrimitiveGetterWithContainerClassID:key:(@, :, @, @) -> @
+ [Method] _createOtherValueGetterWithContainerClassID:key:(@, :, @, @) -> @
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSKeyValueObserverNotification)
- [Method] willChangeValueForKey:(@, :, @) -> v
- [Method] didChangeValueForKey:(@, :, @) -> v
- [Method] willChange:valuesAtIndexes:forKey:(@, :, Q, @, @) -> v
- [Method] didChange:valuesAtIndexes:forKey:(@, :, Q, @, @) -> v
- [Method] willChangeValueForKey:withSetMutation:usingObjects:(@, :, @, Q, @) -> v
- [Method] didChangeValueForKey:withSetMutation:usingObjects:(@, :, @, Q, @) -> v
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSKeyValueObserverNotifying)
- [Method] _isKVOA(@, :) -> c
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSKeyValueObserverRegistration)
- [Method] addObserver:forKeyPath:options:context:(@, :, @, @, Q, ^v) -> v
- [Method] _addObserver:forProperty:options:context:(@, :, @, @, Q, ^v) -> v
- [Method] removeObserver:forKeyPath:context:(@, :, @, @, ^v) -> v
- [Method] removeObserver:forKeyPath:(@, :, @, @) -> v
- [Method] _removeObserver:forProperty:(@, :, @, @) -> v
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSKeyValueObserving)
- [Method] observeValueForKeyPath:ofObject:change:context:(@, :, @, @, @, ^v) -> v
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSKeyValueObservingCustomization)
+ [Method] keyPathsForValuesAffectingValueForKey:(@, :, @) -> @
+ [Method] _keysForValuesAffectingValueForKey:(@, :, @) -> @
+ [Method] automaticallyNotifiesObserversForKey:(@, :, @) -> c
- [Property] observationInfo<Type=^v>
- [Method] observationInfo(@, :) -> ^v
- [Method] setObservationInfo:(@, :, ^v) -> v
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSKeyValueObservingPrivate)
+ [Method] _shouldAddObservationForwardersForKey:(@, :, @) -> c
- [Method] _willBeginKeyValueObserving(@, :) -> v
- [Method] _changeValueForKeys:count:maybeOldValuesDict:maybeNewValuesDict:usingBlock:(@, :, ^@, Q, @, @, @?) -> v
- [Method] _implicitObservationInfo(@, :) -> @
- [Method] _notifyObserversForKeyPath:change:(@, :, @, @) -> v
- [Method] _pendingChangeNotificationsArrayForKey:create:(@, :, @, c) -> @
- [Method] _notifyObserversOfChangeFromValuesForKeys:toValuesForKeys:(@, :, @, @) -> v
- [Method] _changeValueForKey:key:key:usingBlock:(@, :, @, @, @, @?) -> v
- [Method] _didEndKeyValueObserving(@, :) -> v
- [Method] _willChangeValuesForKeys:(@, :, @) -> v
- [Method] _didChangeValuesForKeys:(@, :, @) -> v
- [Method] _changeValueForKey:usingBlock:(@, :, @, @?) -> v
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSObject)
+ [Method] load(@, :) -> v
+ [Method] setVersion:(@, :, q) -> v
+ [Method] version(@, :) -> q
+ [Method] instancesImplementSelector:(@, :, :) -> c
+ [Method] implementsSelector:(@, :, :) -> c
+ [Method] poseAsClass:(@, :, #) -> v
- [Method] awakeAfterUsingCoder:(@, :, @) -> @
- [Method] replacementObjectForCoder:(@, :, @) -> @
- [Method] _allowsDirectEncoding(@, :) -> c
- [Method] classForCoder(@, :) -> #
- [Method] implementsSelector:(@, :, :) -> c
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSObjectPortCoding)
+ [Method] replacementObjectForPortCoder:(@, :, @) -> @
- [Method] classForPortCoder(@, :) -> #
- [Method] replacementObjectForPortCoder:(@, :, @) -> @
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSScriptAppleEventConversion)
+ [Method] _scriptingEnumeratorOfType:withDescriptor:(@, :, @, @) -> @
+ [Method] _scriptingValueOfOneOfAlternativeTypes:withDescriptor:(@, :, @, @) -> @
+ [Method] _scriptingValueOfComplexType:withDescriptor:(@, :, @, @) -> @
+ [Method] _scriptingValueOfObjectType:withDescriptor:(@, :, @, @) -> @
+ [Method] _scriptingValueOfValueType:withDescriptor:(@, :, @, @) -> @
- [Method] _scriptingAlternativeValueRankWithDescriptor:(@, :, @) -> i
- [Method] _scriptingDebugDescription(@, :) -> @
- [Method] _scriptingDescriptorOfComplexType:orReasonWhyNot:(@, :, @, ^@) -> @
- [Method] _scriptingDescriptorOfEnumeratorType:orReasonWhyNot:(@, :, @, ^@) -> @
- [Method] _scriptingDescriptorOfObjectType:orReasonWhyNot:(@, :, @, ^@) -> @
- [Method] _scriptingDescriptorOfValueType:orReasonWhyNot:(@, :, @, ^@) -> @
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSScriptClassDescription)
- [Property] classCode<Type=I, ReadOnly>
- [Property] className<Type=@"NSString", ReadOnly, Bycopy>
- [Method] className(@, :) -> @
- [Method] classCode(@, :) -> I
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSScripting)
- [Property] scriptingProperties<Type=@"NSDictionary", Bycopy>
- [Method] scriptingValueForSpecifier:(@, :, @) -> @
- [Method] scriptingProperties(@, :) -> @
- [Method] coerceValueForScriptingProperties:(@, :, @) -> @
- [Method] setScriptingProperties:(@, :, @) -> v
- [Method] _scriptingCopyWithProperties:forValueForKey:ofContainer:(@, :, @, @, @) -> @
- [Method] copyScriptingValue:forKey:withProperties:(@, :, @, @, @) -> @
- [Method] newScriptingObjectOfClass:forValueForKey:withContentsValue:properties:(@, :, #, @, @, @) -> @
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSScriptingInternal)
- [Method] _scriptingIndicesOfObjectsAfterValidatingSpecifier:(@, :, @) -> @
- [Method] _scriptingValueForSpecifier:(@, :, @) -> @
- [Method] _scriptingIndexOfObjectForSpecifier:(@, :, @) -> Q
- [Method] _scriptingIndexesOfObjectsForSpecifier:(@, :, @) -> @
- [Method] _scriptingIndicesOfObjectsForSpecifier:count:(@, :, @, ^q) -> ^q
- [Method] _scriptingValueForKey:(@, :, @) -> @
- [Method] _scriptingObjectCountInValueForKey:(@, :, @) -> Q
- [Method] _scriptingShouldCheckObjectIndexes(@, :) -> c
- [Method] _scriptingObjectAtIndex:inValueForKey:(@, :, Q, @) -> @
- [Method] _scriptingObjectsAtIndexes:inValueForKey:(@, :, @, @) -> @
- [Method] _scriptingObjectWithName:inValueForKey:(@, :, @, @) -> @
- [Method] _scriptingObjectWithUniqueID:inValueForKey:(@, :, @, @) -> @
- [Method] _scriptingIndexOfObjectWithName:inValueForKey:(@, :, @, @) -> Q
- [Method] _scriptingIndexOfObjectWithUniqueID:inValueForKey:(@, :, @, @) -> Q
- [Method] _scriptingObjectForSpecifier:(@, :, @) -> @
- [Method] _scriptingArrayOfObjectsForSpecifier:(@, :, @) -> @
- [Method] _scriptingSetOfObjectsForSpecifier:(@, :, @) -> @
- [Method] _scriptingCoerceValue:forKey:(@, :, @, @) -> @
- [Method] _scriptingCanSetValue:forSpecifier:(@, :, @, @) -> c
- [Method] _scriptingSetValue:forKey:(@, :, @, @) -> @
- [Method] _scriptingCanAddObjectsToValueForKey:(@, :, @) -> c
- [Method] _scriptingCanInsertBeforeOrReplaceObjectsAtIndexes:inValueForKey:(@, :, @, @) -> c
- [Method] _scriptingAddObjectsFromArray:toValueForKey:(@, :, @, @) -> @
- [Method] _scriptingAddObjectsFromSet:toValueForKey:(@, :, @, @) -> @
- [Method] _scriptingInsertObjects:atIndexes:inValueForKey:(@, :, @, @, @) -> @
- [Method] _scriptingReplaceObjectAtIndex:withObjects:inValueForKey:(@, :, Q, @, @) -> @
- [Method] _scriptingInsertObject:inValueForKey:(@, :, @, @) -> @
- [Method] _scriptingRemoveObjectsAtIndexes:fromValueForKey:(@, :, @, @) -> v
- [Method] _scriptingRemoveAllObjectsFromValueForKey:(@, :, @) -> v
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSScriptingInternalCommandHandling)
- [Method] _scriptingMightHandleCommand:(@, :, @) -> c
- [Method] _scriptingCanHandleCommand:(@, :, @) -> c
- [Method] _scriptingAddToReceiversArray:(@, :, @) -> v
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSScriptingInternalCounting)
- [Method] _scriptingCount(@, :) -> Q
- [Method] _scriptingCountOfValueForKey:(@, :, @) -> Q
- [Method] _scriptingCountNonrecursively(@, :) -> Q
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSScriptingInternalDeleting)
- [Method] _scriptingRemoveValueForSpecifier:(@, :, @) -> v
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSScriptingInternalExisting)
- [Method] _scriptingExists(@, :) -> c
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSScriptingInternalSetting)
- [Method] _scriptingSetValue:forSpecifier:(@, :, @, @) -> @
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSScriptKeyValueCoding)
- [Method] valueAtIndex:inPropertyWithKey:(@, :, Q, @) -> @
- [Method] valueWithName:inPropertyWithKey:(@, :, @, @) -> @
- [Method] valueWithUniqueID:inPropertyWithKey:(@, :, @, @) -> @
- [Method] replaceValueAtIndex:inPropertyWithKey:withValue:(@, :, Q, @, @) -> v
- [Method] insertValue:atIndex:inPropertyWithKey:(@, :, @, Q, @) -> v
- [Method] removeValueAtIndex:fromPropertyWithKey:(@, :, Q, @) -> v
- [Method] insertValue:inPropertyWithKey:(@, :, @, @) -> v
- [Method] coerceValue:forKey:(@, :, @, @) -> @
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSScriptKeyValueCodingInternal)
+ [Method] _selectorToGetValueWithNameForKey:(@, :, @) -> :
+ [Method] _selectorToGetValueWithUniqueIDForKey:(@, :, @) -> :
- [Method] _compatibility_takeValue:forKey:(@, :, @, @) -> v
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSScriptKeyValueCodingPrivate)
- [Method] _supportsGetValueWithNameForKey:perhapsByOverridingClass:(@, :, @, #) -> q
- [Method] _supportsGetValueWithUniqueIDForKey:perhapsByOverridingClass:(@, :, @, #) -> q
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSScriptLegacyPropertyListParsing)
- [Method] _asScriptTerminologyNameArray(@, :) -> @
- [Method] _asScriptTerminologyNameString(@, :) -> @
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSScriptObjectSpecifierBackstop)
- [Method] objectSpecifier(@, :) -> @
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSThreadPerformAdditions)
- [Method] performSelectorOnMainThread:withObject:waitUntilDone:(@, :, :, @, c) -> v
- [Method] performSelector:onThread:withObject:waitUntilDone:modes:(@, :, :, @, @, c, @) -> v
- [Method] performSelector:onThread:withObject:waitUntilDone:(@, :, :, @, @, c) -> v
- [Method] performSelectorOnMainThread:withObject:waitUntilDone:modes:(@, :, :, @, c, @) -> v
- [Method] performSelectorInBackground:withObject:(@, :, :, @) -> v
@end

// /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
@interface NSObject (NSUnpublishedEOF)
+ [Method] flushAllKeyBindings(@, :) -> v
+ [Method] flushClassKeyBindings(@, :) -> v
- [Method] _setObject:forBothSidesOfRelationshipWithKey:(@, :, @, @) -> v
- [Method] addObject:toBothSidesOfRelationshipWithKey:(@, :, @, @) -> v
- [Method] addObject:toPropertyWithKey:(@, :, @, @) -> v
- [Method] allPropertyKeys(@, :) -> @
- [Method] classDescriptionForDestinationKey:(@, :, @) -> @
- [Method] clearProperties(@, :) -> v
- [Method] entityName(@, :) -> @
- [Method] flushKeyBindings(@, :) -> v
- [Method] isToManyKey:(@, :, @) -> c
- [Method] ownsDestinationObjectsForRelationshipKey:(@, :, @) -> c
- [Method] removeObject:fromBothSidesOfRelationshipWithKey:(@, :, @, @) -> v
- [Method] removeObject:fromPropertyWithKey:(@, :, @, @) -> v
- [Method] takeStoredValuesFromDictionary:(@, :, @) -> v
- [Method] validateValue:forKey:(@, :, ^@, @) -> @
- [Method] validateTakeValue:forKeyPath:(@, :, @, @) -> @
@end

// /System/Library/Frameworks/QuartzCore.framework/Versions/A/QuartzCore
@interface NSObject (_CAObjectInternal)
+ [Method] CA_encodesPropertyConditionally:type:(@, :, I, i) -> c
+ [Method] CA_setterForProperty:(@, :, r^{_CAPropertyInfo}) -> ^?
+ [Method] CA_getterForProperty:(@, :, r^{_CAPropertyInfo}) -> ^?
+ [Method] CA_automaticallyNotifiesObservers:(@, :, #) -> c
+ [Method] CA_CAMLPropertyForKey:(@, :, @) -> @
- [Method] CA_archivingValueForKey:(@, :, @) -> @
@end

// /System/Library/Frameworks/QuartzCore.framework/Versions/A/QuartzCore
@interface NSObject (CAAnimatableValue) <CAAnimatableValue>
- [Method] CA_addValue:multipliedBy:(@, :, @, i) -> @
- [Method] CA_interpolateValue:byFraction:(@, :, @, f) -> @
- [Method] CA_roundToIntegerFromValue:(@, :, @) -> @
- [Method] CA_interpolateValues:::interpolator:(@, :, @, @, @, r^{ValueInterpolator=dddddddddB}) -> @
- [Method] CA_distanceToValue:(@, :, @) -> d
@end

// /System/Library/Frameworks/QuartzCore.framework/Versions/A/QuartzCore
@interface NSObject (CAMLWriter)
- [Method] CAMLType(@, :) -> @
- [Method] encodeWithCAMLWriter:(@, :, @) -> v
- [Method] CAMLTypeForKey:(@, :, @) -> @
- [Method] CAMLTypeSupportedForKey:(@, :, @) -> c
@end

// /System/Library/Frameworks/QuartzCore.framework/Versions/A/QuartzCore
@interface NSObject (CARenderValue) <CARenderValue>
- [Method] CA_prepareRenderValue(@, :) -> v
- [Method] CA_copyRenderValue(@, :) -> ^{Object=^^?{Atomic={?=i}}}
- [Method] CA_copyNumericValue:(@, :, [20d]) -> Q
@end

// /System/Library/Frameworks/Security.framework/Versions/A/Security
@interface NSObject (SFSQLiteAdditions)
+ [Method] SFSQLiteClassName(@, :) -> @
@end

// /System/Library/Frameworks/UserNotifications.framework/Versions/A/UserNotifications
@interface NSObject (UserNotifications)
- [Method] un_safeBoolValue(@, :) -> c
@end

// /System/Library/PrivateFrameworks/AXRuntime.framework/Versions/A/AXRuntime
@interface NSObject (AXAttributedStringAdditions)
- [Method] isAXAttributedString(@, :) -> c
- [Method] _accessibilityAttributedLocalizedString(@, :) -> @
- [Method] _setAccessibilityAttributedLocalizedString:(@, :, @) -> v
@end

// /System/Library/PrivateFrameworks/AXRuntime.framework/Versions/A/AXRuntime
@interface NSObject (AXPropertyListCoersion)
- [Method] _axRecursivelyPropertyListCoercedRepresentationWithError:(@, :, ^@) -> @
- [Method] _axRecursivelyReconstitutedRepresentationFromPropertyListWithError:(@, :, ^@) -> @
- [Method] _axDictionaryKeyReplacementRepresentation(@, :) -> @
- [Method] _axReconstitutedRepresentationForDictionaryKeyReplacement(@, :) -> @
@end

// /System/Library/PrivateFrameworks/BaseBoard.framework/Versions/A/BaseBoard
@interface NSObject (BaseBoard)
+ [Method] bs_isPlistableType(@, :) -> c
+ [Method] bs_secureDecodedFromData:(@, :, @) -> @
+ [Method] bs_secureDecodedFromData:withAdditionalClasses:(@, :, @, @) -> @
+ [Method] bs_secureDataFromObject:(@, :, @) -> @
+ [Method] bs_secureObjectFromData:ofClass:(@, :, @, #) -> @
+ [Method] bs_secureObjectFromData:ofClasses:(@, :, @, @) -> @
- [Method] bs_isPlistableType(@, :) -> c
- [Method] bs_secureEncoded(@, :) -> @
@end

// /System/Library/PrivateFrameworks/BaseBoard.framework/Versions/A/BaseBoard
@interface NSObject (BaseBoardDeprecated)
+ [Method] bs_dataFromObject:(@, :, @) -> @
+ [Method] bs_objectFromData:(@, :, @) -> @
+ [Method] bs_decodedFromData:(@, :, @) -> @
- [Method] bs_encoded(@, :) -> @
@end

// /System/Library/PrivateFrameworks/BaseBoard.framework/Versions/A/BaseBoard
@interface NSObject (BSXPCObjectUtilities)
- [Method] bs_isXPCObject(@, :) -> c
@end

// /System/Library/PrivateFrameworks/BaseBoard.framework/Versions/A/BaseBoard
@interface NSObject (BSXPCSecureCoding)
+ [Method] supportsBSXPCSecureCoding(@, :) -> c
- [Method] supportsBSXPCSecureCoding(@, :) -> c
@end

// /System/Library/PrivateFrameworks/CoreUtils.framework/Versions/A/CoreUtils
@interface NSObject (BoxingUtils)
- [Method] boolValueSafe(@, :) -> c
- [Method] boolValueSafe:(@, :, ^i) -> c
- [Method] int64ValueSafe(@, :) -> q
- [Method] int64ValueSafe:(@, :, ^i) -> q
- [Method] doubleValueSafe(@, :) -> d
- [Method] doubleValueSafe:(@, :, ^i) -> d
- [Method] stringValueSafe(@, :) -> @
- [Method] stringValueSafe:(@, :, ^i) -> @
- [Method] utf8ValueSafe(@, :) -> r*
- [Method] utf8ValueSafe:(@, :, ^i) -> r*
@end
```


## 后续发展路线

1. 添加对 type encodings 字符串的解析/编码支持，用以替代 NSMethodSignature 类，使得可以在 lldb 上直接调用，并且支持直接解析为类型信息，而不是 @encode 编码；
2. 添加对现有 Objective-C Runtime Types 进行增删改的支持；
3. 探索非公开 Objective-C Runtime API 的使用，以支持更强大的功能。


## 交流反馈

邮箱： keqiongpan@163.com
微信/QQ： 469070147

目前该项目还在开发演进中，欢迎各为感兴趣的同学来信交流，谢谢。
