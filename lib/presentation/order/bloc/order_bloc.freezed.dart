// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderEvent()';
}


}

/// @nodoc
class $OrderEventCopyWith<$Res>  {
$OrderEventCopyWith(OrderEvent _, $Res Function(OrderEvent) __);
}


/// Adds pattern-matching-related methods to [OrderEvent].
extension OrderEventPatterns on OrderEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _GetOrders value)?  getOrders,TResult Function( _GetOrderDetail value)?  getOrderDetail,TResult Function( _CancelOrder value)?  cancelOrder,TResult Function( _RepayOrder value)?  repayOrder,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetOrders() when getOrders != null:
return getOrders(_that);case _GetOrderDetail() when getOrderDetail != null:
return getOrderDetail(_that);case _CancelOrder() when cancelOrder != null:
return cancelOrder(_that);case _RepayOrder() when repayOrder != null:
return repayOrder(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _GetOrders value)  getOrders,required TResult Function( _GetOrderDetail value)  getOrderDetail,required TResult Function( _CancelOrder value)  cancelOrder,required TResult Function( _RepayOrder value)  repayOrder,}){
final _that = this;
switch (_that) {
case _GetOrders():
return getOrders(_that);case _GetOrderDetail():
return getOrderDetail(_that);case _CancelOrder():
return cancelOrder(_that);case _RepayOrder():
return repayOrder(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _GetOrders value)?  getOrders,TResult? Function( _GetOrderDetail value)?  getOrderDetail,TResult? Function( _CancelOrder value)?  cancelOrder,TResult? Function( _RepayOrder value)?  repayOrder,}){
final _that = this;
switch (_that) {
case _GetOrders() when getOrders != null:
return getOrders(_that);case _GetOrderDetail() when getOrderDetail != null:
return getOrderDetail(_that);case _CancelOrder() when cancelOrder != null:
return cancelOrder(_that);case _RepayOrder() when repayOrder != null:
return repayOrder(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? status)?  getOrders,TResult Function( int id)?  getOrderDetail,TResult Function( int id,  String? reason)?  cancelOrder,TResult Function( int id)?  repayOrder,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetOrders() when getOrders != null:
return getOrders(_that.status);case _GetOrderDetail() when getOrderDetail != null:
return getOrderDetail(_that.id);case _CancelOrder() when cancelOrder != null:
return cancelOrder(_that.id,_that.reason);case _RepayOrder() when repayOrder != null:
return repayOrder(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? status)  getOrders,required TResult Function( int id)  getOrderDetail,required TResult Function( int id,  String? reason)  cancelOrder,required TResult Function( int id)  repayOrder,}) {final _that = this;
switch (_that) {
case _GetOrders():
return getOrders(_that.status);case _GetOrderDetail():
return getOrderDetail(_that.id);case _CancelOrder():
return cancelOrder(_that.id,_that.reason);case _RepayOrder():
return repayOrder(_that.id);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? status)?  getOrders,TResult? Function( int id)?  getOrderDetail,TResult? Function( int id,  String? reason)?  cancelOrder,TResult? Function( int id)?  repayOrder,}) {final _that = this;
switch (_that) {
case _GetOrders() when getOrders != null:
return getOrders(_that.status);case _GetOrderDetail() when getOrderDetail != null:
return getOrderDetail(_that.id);case _CancelOrder() when cancelOrder != null:
return cancelOrder(_that.id,_that.reason);case _RepayOrder() when repayOrder != null:
return repayOrder(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _GetOrders implements OrderEvent {
  const _GetOrders({this.status});
  

 final  String? status;

/// Create a copy of OrderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetOrdersCopyWith<_GetOrders> get copyWith => __$GetOrdersCopyWithImpl<_GetOrders>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetOrders&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'OrderEvent.getOrders(status: $status)';
}


}

/// @nodoc
abstract mixin class _$GetOrdersCopyWith<$Res> implements $OrderEventCopyWith<$Res> {
  factory _$GetOrdersCopyWith(_GetOrders value, $Res Function(_GetOrders) _then) = __$GetOrdersCopyWithImpl;
@useResult
$Res call({
 String? status
});




}
/// @nodoc
class __$GetOrdersCopyWithImpl<$Res>
    implements _$GetOrdersCopyWith<$Res> {
  __$GetOrdersCopyWithImpl(this._self, this._then);

  final _GetOrders _self;
  final $Res Function(_GetOrders) _then;

/// Create a copy of OrderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? status = freezed,}) {
  return _then(_GetOrders(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _GetOrderDetail implements OrderEvent {
  const _GetOrderDetail(this.id);
  

 final  int id;

/// Create a copy of OrderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetOrderDetailCopyWith<_GetOrderDetail> get copyWith => __$GetOrderDetailCopyWithImpl<_GetOrderDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetOrderDetail&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'OrderEvent.getOrderDetail(id: $id)';
}


}

/// @nodoc
abstract mixin class _$GetOrderDetailCopyWith<$Res> implements $OrderEventCopyWith<$Res> {
  factory _$GetOrderDetailCopyWith(_GetOrderDetail value, $Res Function(_GetOrderDetail) _then) = __$GetOrderDetailCopyWithImpl;
@useResult
$Res call({
 int id
});




}
/// @nodoc
class __$GetOrderDetailCopyWithImpl<$Res>
    implements _$GetOrderDetailCopyWith<$Res> {
  __$GetOrderDetailCopyWithImpl(this._self, this._then);

  final _GetOrderDetail _self;
  final $Res Function(_GetOrderDetail) _then;

/// Create a copy of OrderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_GetOrderDetail(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _CancelOrder implements OrderEvent {
  const _CancelOrder(this.id, {this.reason});
  

 final  int id;
 final  String? reason;

/// Create a copy of OrderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CancelOrderCopyWith<_CancelOrder> get copyWith => __$CancelOrderCopyWithImpl<_CancelOrder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CancelOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,id,reason);

@override
String toString() {
  return 'OrderEvent.cancelOrder(id: $id, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$CancelOrderCopyWith<$Res> implements $OrderEventCopyWith<$Res> {
  factory _$CancelOrderCopyWith(_CancelOrder value, $Res Function(_CancelOrder) _then) = __$CancelOrderCopyWithImpl;
@useResult
$Res call({
 int id, String? reason
});




}
/// @nodoc
class __$CancelOrderCopyWithImpl<$Res>
    implements _$CancelOrderCopyWith<$Res> {
  __$CancelOrderCopyWithImpl(this._self, this._then);

  final _CancelOrder _self;
  final $Res Function(_CancelOrder) _then;

/// Create a copy of OrderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? reason = freezed,}) {
  return _then(_CancelOrder(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _RepayOrder implements OrderEvent {
  const _RepayOrder(this.id);
  

 final  int id;

/// Create a copy of OrderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RepayOrderCopyWith<_RepayOrder> get copyWith => __$RepayOrderCopyWithImpl<_RepayOrder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RepayOrder&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'OrderEvent.repayOrder(id: $id)';
}


}

/// @nodoc
abstract mixin class _$RepayOrderCopyWith<$Res> implements $OrderEventCopyWith<$Res> {
  factory _$RepayOrderCopyWith(_RepayOrder value, $Res Function(_RepayOrder) _then) = __$RepayOrderCopyWithImpl;
@useResult
$Res call({
 int id
});




}
/// @nodoc
class __$RepayOrderCopyWithImpl<$Res>
    implements _$RepayOrderCopyWith<$Res> {
  __$RepayOrderCopyWithImpl(this._self, this._then);

  final _RepayOrder _self;
  final $Res Function(_RepayOrder) _then;

/// Create a copy of OrderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_RepayOrder(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$OrderState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderState()';
}


}

/// @nodoc
class $OrderStateCopyWith<$Res>  {
$OrderStateCopyWith(OrderState _, $Res Function(OrderState) __);
}


/// Adds pattern-matching-related methods to [OrderState].
extension OrderStatePatterns on OrderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _ListLoaded value)?  listLoaded,TResult Function( _DetailLoaded value)?  detailLoaded,TResult Function( _ActionSuccess value)?  actionSuccess,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _ListLoaded() when listLoaded != null:
return listLoaded(_that);case _DetailLoaded() when detailLoaded != null:
return detailLoaded(_that);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _ListLoaded value)  listLoaded,required TResult Function( _DetailLoaded value)  detailLoaded,required TResult Function( _ActionSuccess value)  actionSuccess,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _ListLoaded():
return listLoaded(_that);case _DetailLoaded():
return detailLoaded(_that);case _ActionSuccess():
return actionSuccess(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _ListLoaded value)?  listLoaded,TResult? Function( _DetailLoaded value)?  detailLoaded,TResult? Function( _ActionSuccess value)?  actionSuccess,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _ListLoaded() when listLoaded != null:
return listLoaded(_that);case _DetailLoaded() when detailLoaded != null:
return detailLoaded(_that);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Order> orders)?  listLoaded,TResult Function( Order order)?  detailLoaded,TResult Function( String message,  String? paymentUrl)?  actionSuccess,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _ListLoaded() when listLoaded != null:
return listLoaded(_that.orders);case _DetailLoaded() when detailLoaded != null:
return detailLoaded(_that.order);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that.message,_that.paymentUrl);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Order> orders)  listLoaded,required TResult Function( Order order)  detailLoaded,required TResult Function( String message,  String? paymentUrl)  actionSuccess,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _ListLoaded():
return listLoaded(_that.orders);case _DetailLoaded():
return detailLoaded(_that.order);case _ActionSuccess():
return actionSuccess(_that.message,_that.paymentUrl);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Order> orders)?  listLoaded,TResult? Function( Order order)?  detailLoaded,TResult? Function( String message,  String? paymentUrl)?  actionSuccess,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _ListLoaded() when listLoaded != null:
return listLoaded(_that.orders);case _DetailLoaded() when detailLoaded != null:
return detailLoaded(_that.order);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that.message,_that.paymentUrl);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements OrderState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderState.initial()';
}


}




/// @nodoc


class _Loading implements OrderState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderState.loading()';
}


}




/// @nodoc


class _ListLoaded implements OrderState {
  const _ListLoaded(final  List<Order> orders): _orders = orders;
  

 final  List<Order> _orders;
 List<Order> get orders {
  if (_orders is EqualUnmodifiableListView) return _orders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orders);
}


/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListLoadedCopyWith<_ListLoaded> get copyWith => __$ListLoadedCopyWithImpl<_ListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListLoaded&&const DeepCollectionEquality().equals(other._orders, _orders));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_orders));

@override
String toString() {
  return 'OrderState.listLoaded(orders: $orders)';
}


}

/// @nodoc
abstract mixin class _$ListLoadedCopyWith<$Res> implements $OrderStateCopyWith<$Res> {
  factory _$ListLoadedCopyWith(_ListLoaded value, $Res Function(_ListLoaded) _then) = __$ListLoadedCopyWithImpl;
@useResult
$Res call({
 List<Order> orders
});




}
/// @nodoc
class __$ListLoadedCopyWithImpl<$Res>
    implements _$ListLoadedCopyWith<$Res> {
  __$ListLoadedCopyWithImpl(this._self, this._then);

  final _ListLoaded _self;
  final $Res Function(_ListLoaded) _then;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? orders = null,}) {
  return _then(_ListLoaded(
null == orders ? _self._orders : orders // ignore: cast_nullable_to_non_nullable
as List<Order>,
  ));
}


}

/// @nodoc


class _DetailLoaded implements OrderState {
  const _DetailLoaded(this.order);
  

 final  Order order;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetailLoadedCopyWith<_DetailLoaded> get copyWith => __$DetailLoadedCopyWithImpl<_DetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DetailLoaded&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,order);

@override
String toString() {
  return 'OrderState.detailLoaded(order: $order)';
}


}

/// @nodoc
abstract mixin class _$DetailLoadedCopyWith<$Res> implements $OrderStateCopyWith<$Res> {
  factory _$DetailLoadedCopyWith(_DetailLoaded value, $Res Function(_DetailLoaded) _then) = __$DetailLoadedCopyWithImpl;
@useResult
$Res call({
 Order order
});




}
/// @nodoc
class __$DetailLoadedCopyWithImpl<$Res>
    implements _$DetailLoadedCopyWith<$Res> {
  __$DetailLoadedCopyWithImpl(this._self, this._then);

  final _DetailLoaded _self;
  final $Res Function(_DetailLoaded) _then;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = null,}) {
  return _then(_DetailLoaded(
null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order,
  ));
}


}

/// @nodoc


class _ActionSuccess implements OrderState {
  const _ActionSuccess(this.message, {this.paymentUrl});
  

 final  String message;
 final  String? paymentUrl;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionSuccessCopyWith<_ActionSuccess> get copyWith => __$ActionSuccessCopyWithImpl<_ActionSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionSuccess&&(identical(other.message, message) || other.message == message)&&(identical(other.paymentUrl, paymentUrl) || other.paymentUrl == paymentUrl));
}


@override
int get hashCode => Object.hash(runtimeType,message,paymentUrl);

@override
String toString() {
  return 'OrderState.actionSuccess(message: $message, paymentUrl: $paymentUrl)';
}


}

/// @nodoc
abstract mixin class _$ActionSuccessCopyWith<$Res> implements $OrderStateCopyWith<$Res> {
  factory _$ActionSuccessCopyWith(_ActionSuccess value, $Res Function(_ActionSuccess) _then) = __$ActionSuccessCopyWithImpl;
@useResult
$Res call({
 String message, String? paymentUrl
});




}
/// @nodoc
class __$ActionSuccessCopyWithImpl<$Res>
    implements _$ActionSuccessCopyWith<$Res> {
  __$ActionSuccessCopyWithImpl(this._self, this._then);

  final _ActionSuccess _self;
  final $Res Function(_ActionSuccess) _then;

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? paymentUrl = freezed,}) {
  return _then(_ActionSuccess(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,paymentUrl: freezed == paymentUrl ? _self.paymentUrl : paymentUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Error implements OrderState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of OrderState
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
  return 'OrderState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $OrderStateCopyWith<$Res> {
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

/// Create a copy of OrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
