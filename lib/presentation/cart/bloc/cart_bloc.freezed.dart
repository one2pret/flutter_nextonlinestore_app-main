// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CartEvent()';
}


}

/// @nodoc
class $CartEventCopyWith<$Res>  {
$CartEventCopyWith(CartEvent _, $Res Function(CartEvent) __);
}


/// Adds pattern-matching-related methods to [CartEvent].
extension CartEventPatterns on CartEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _GetCart value)?  getCart,TResult Function( _AddToCart value)?  addToCart,TResult Function( _UpdateCartItem value)?  updateCartItem,TResult Function( _RemoveCartItem value)?  removeCartItem,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetCart() when getCart != null:
return getCart(_that);case _AddToCart() when addToCart != null:
return addToCart(_that);case _UpdateCartItem() when updateCartItem != null:
return updateCartItem(_that);case _RemoveCartItem() when removeCartItem != null:
return removeCartItem(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _GetCart value)  getCart,required TResult Function( _AddToCart value)  addToCart,required TResult Function( _UpdateCartItem value)  updateCartItem,required TResult Function( _RemoveCartItem value)  removeCartItem,}){
final _that = this;
switch (_that) {
case _GetCart():
return getCart(_that);case _AddToCart():
return addToCart(_that);case _UpdateCartItem():
return updateCartItem(_that);case _RemoveCartItem():
return removeCartItem(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _GetCart value)?  getCart,TResult? Function( _AddToCart value)?  addToCart,TResult? Function( _UpdateCartItem value)?  updateCartItem,TResult? Function( _RemoveCartItem value)?  removeCartItem,}){
final _that = this;
switch (_that) {
case _GetCart() when getCart != null:
return getCart(_that);case _AddToCart() when addToCart != null:
return addToCart(_that);case _UpdateCartItem() when updateCartItem != null:
return updateCartItem(_that);case _RemoveCartItem() when removeCartItem != null:
return removeCartItem(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  getCart,TResult Function( int productId,  int quantity)?  addToCart,TResult Function( int id,  int quantity)?  updateCartItem,TResult Function( int id)?  removeCartItem,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetCart() when getCart != null:
return getCart();case _AddToCart() when addToCart != null:
return addToCart(_that.productId,_that.quantity);case _UpdateCartItem() when updateCartItem != null:
return updateCartItem(_that.id,_that.quantity);case _RemoveCartItem() when removeCartItem != null:
return removeCartItem(_that.id);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  getCart,required TResult Function( int productId,  int quantity)  addToCart,required TResult Function( int id,  int quantity)  updateCartItem,required TResult Function( int id)  removeCartItem,}) {final _that = this;
switch (_that) {
case _GetCart():
return getCart();case _AddToCart():
return addToCart(_that.productId,_that.quantity);case _UpdateCartItem():
return updateCartItem(_that.id,_that.quantity);case _RemoveCartItem():
return removeCartItem(_that.id);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  getCart,TResult? Function( int productId,  int quantity)?  addToCart,TResult? Function( int id,  int quantity)?  updateCartItem,TResult? Function( int id)?  removeCartItem,}) {final _that = this;
switch (_that) {
case _GetCart() when getCart != null:
return getCart();case _AddToCart() when addToCart != null:
return addToCart(_that.productId,_that.quantity);case _UpdateCartItem() when updateCartItem != null:
return updateCartItem(_that.id,_that.quantity);case _RemoveCartItem() when removeCartItem != null:
return removeCartItem(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _GetCart implements CartEvent {
  const _GetCart();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetCart);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CartEvent.getCart()';
}


}




/// @nodoc


class _AddToCart implements CartEvent {
  const _AddToCart({required this.productId, this.quantity = 1});
  

 final  int productId;
@JsonKey() final  int quantity;

/// Create a copy of CartEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddToCartCopyWith<_AddToCart> get copyWith => __$AddToCartCopyWithImpl<_AddToCart>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddToCart&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,productId,quantity);

@override
String toString() {
  return 'CartEvent.addToCart(productId: $productId, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$AddToCartCopyWith<$Res> implements $CartEventCopyWith<$Res> {
  factory _$AddToCartCopyWith(_AddToCart value, $Res Function(_AddToCart) _then) = __$AddToCartCopyWithImpl;
@useResult
$Res call({
 int productId, int quantity
});




}
/// @nodoc
class __$AddToCartCopyWithImpl<$Res>
    implements _$AddToCartCopyWith<$Res> {
  __$AddToCartCopyWithImpl(this._self, this._then);

  final _AddToCart _self;
  final $Res Function(_AddToCart) _then;

/// Create a copy of CartEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? quantity = null,}) {
  return _then(_AddToCart(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _UpdateCartItem implements CartEvent {
  const _UpdateCartItem({required this.id, required this.quantity});
  

 final  int id;
 final  int quantity;

/// Create a copy of CartEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateCartItemCopyWith<_UpdateCartItem> get copyWith => __$UpdateCartItemCopyWithImpl<_UpdateCartItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateCartItem&&(identical(other.id, id) || other.id == id)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,id,quantity);

@override
String toString() {
  return 'CartEvent.updateCartItem(id: $id, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$UpdateCartItemCopyWith<$Res> implements $CartEventCopyWith<$Res> {
  factory _$UpdateCartItemCopyWith(_UpdateCartItem value, $Res Function(_UpdateCartItem) _then) = __$UpdateCartItemCopyWithImpl;
@useResult
$Res call({
 int id, int quantity
});




}
/// @nodoc
class __$UpdateCartItemCopyWithImpl<$Res>
    implements _$UpdateCartItemCopyWith<$Res> {
  __$UpdateCartItemCopyWithImpl(this._self, this._then);

  final _UpdateCartItem _self;
  final $Res Function(_UpdateCartItem) _then;

/// Create a copy of CartEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? quantity = null,}) {
  return _then(_UpdateCartItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _RemoveCartItem implements CartEvent {
  const _RemoveCartItem(this.id);
  

 final  int id;

/// Create a copy of CartEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoveCartItemCopyWith<_RemoveCartItem> get copyWith => __$RemoveCartItemCopyWithImpl<_RemoveCartItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoveCartItem&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'CartEvent.removeCartItem(id: $id)';
}


}

/// @nodoc
abstract mixin class _$RemoveCartItemCopyWith<$Res> implements $CartEventCopyWith<$Res> {
  factory _$RemoveCartItemCopyWith(_RemoveCartItem value, $Res Function(_RemoveCartItem) _then) = __$RemoveCartItemCopyWithImpl;
@useResult
$Res call({
 int id
});




}
/// @nodoc
class __$RemoveCartItemCopyWithImpl<$Res>
    implements _$RemoveCartItemCopyWith<$Res> {
  __$RemoveCartItemCopyWithImpl(this._self, this._then);

  final _RemoveCartItem _self;
  final $Res Function(_RemoveCartItem) _then;

/// Create a copy of CartEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_RemoveCartItem(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$CartState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CartState()';
}


}

/// @nodoc
class $CartStateCopyWith<$Res>  {
$CartStateCopyWith(CartState _, $Res Function(CartState) __);
}


/// Adds pattern-matching-related methods to [CartState].
extension CartStatePatterns on CartState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Error():
return error(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<CartItem> items)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.items);case _Error() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<CartItem> items)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.items);case _Error():
return error(_that.message);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<CartItem> items)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.items);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements CartState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CartState.initial()';
}


}




/// @nodoc


class _Loading implements CartState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CartState.loading()';
}


}




/// @nodoc


class _Loaded implements CartState {
  const _Loaded(final  List<CartItem> items): _items = items;
  

 final  List<CartItem> _items;
 List<CartItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'CartState.loaded(items: $items)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $CartStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<CartItem> items
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_Loaded(
null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CartItem>,
  ));
}


}

/// @nodoc


class _Error implements CartState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'CartState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $CartStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of CartState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
