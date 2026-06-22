// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddressEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressEvent()';
}


}

/// @nodoc
class $AddressEventCopyWith<$Res>  {
$AddressEventCopyWith(AddressEvent _, $Res Function(AddressEvent) __);
}


/// Adds pattern-matching-related methods to [AddressEvent].
extension AddressEventPatterns on AddressEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _GetAddresses value)?  getAddresses,TResult Function( _CreateAddress value)?  createAddress,TResult Function( _UpdateAddress value)?  updateAddress,TResult Function( _DeleteAddress value)?  deleteAddress,TResult Function( _SetDefault value)?  setDefault,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetAddresses() when getAddresses != null:
return getAddresses(_that);case _CreateAddress() when createAddress != null:
return createAddress(_that);case _UpdateAddress() when updateAddress != null:
return updateAddress(_that);case _DeleteAddress() when deleteAddress != null:
return deleteAddress(_that);case _SetDefault() when setDefault != null:
return setDefault(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _GetAddresses value)  getAddresses,required TResult Function( _CreateAddress value)  createAddress,required TResult Function( _UpdateAddress value)  updateAddress,required TResult Function( _DeleteAddress value)  deleteAddress,required TResult Function( _SetDefault value)  setDefault,}){
final _that = this;
switch (_that) {
case _GetAddresses():
return getAddresses(_that);case _CreateAddress():
return createAddress(_that);case _UpdateAddress():
return updateAddress(_that);case _DeleteAddress():
return deleteAddress(_that);case _SetDefault():
return setDefault(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _GetAddresses value)?  getAddresses,TResult? Function( _CreateAddress value)?  createAddress,TResult? Function( _UpdateAddress value)?  updateAddress,TResult? Function( _DeleteAddress value)?  deleteAddress,TResult? Function( _SetDefault value)?  setDefault,}){
final _that = this;
switch (_that) {
case _GetAddresses() when getAddresses != null:
return getAddresses(_that);case _CreateAddress() when createAddress != null:
return createAddress(_that);case _UpdateAddress() when updateAddress != null:
return updateAddress(_that);case _DeleteAddress() when deleteAddress != null:
return deleteAddress(_that);case _SetDefault() when setDefault != null:
return setDefault(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  getAddresses,TResult Function( AddressRequestModel request)?  createAddress,TResult Function( int id,  AddressRequestModel request)?  updateAddress,TResult Function( int id)?  deleteAddress,TResult Function( int id)?  setDefault,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetAddresses() when getAddresses != null:
return getAddresses();case _CreateAddress() when createAddress != null:
return createAddress(_that.request);case _UpdateAddress() when updateAddress != null:
return updateAddress(_that.id,_that.request);case _DeleteAddress() when deleteAddress != null:
return deleteAddress(_that.id);case _SetDefault() when setDefault != null:
return setDefault(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  getAddresses,required TResult Function( AddressRequestModel request)  createAddress,required TResult Function( int id,  AddressRequestModel request)  updateAddress,required TResult Function( int id)  deleteAddress,required TResult Function( int id)  setDefault,}) {final _that = this;
switch (_that) {
case _GetAddresses():
return getAddresses();case _CreateAddress():
return createAddress(_that.request);case _UpdateAddress():
return updateAddress(_that.id,_that.request);case _DeleteAddress():
return deleteAddress(_that.id);case _SetDefault():
return setDefault(_that.id);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  getAddresses,TResult? Function( AddressRequestModel request)?  createAddress,TResult? Function( int id,  AddressRequestModel request)?  updateAddress,TResult? Function( int id)?  deleteAddress,TResult? Function( int id)?  setDefault,}) {final _that = this;
switch (_that) {
case _GetAddresses() when getAddresses != null:
return getAddresses();case _CreateAddress() when createAddress != null:
return createAddress(_that.request);case _UpdateAddress() when updateAddress != null:
return updateAddress(_that.id,_that.request);case _DeleteAddress() when deleteAddress != null:
return deleteAddress(_that.id);case _SetDefault() when setDefault != null:
return setDefault(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _GetAddresses implements AddressEvent {
  const _GetAddresses();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetAddresses);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressEvent.getAddresses()';
}


}




/// @nodoc


class _CreateAddress implements AddressEvent {
  const _CreateAddress(this.request);
  

 final  AddressRequestModel request;

/// Create a copy of AddressEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateAddressCopyWith<_CreateAddress> get copyWith => __$CreateAddressCopyWithImpl<_CreateAddress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateAddress&&(identical(other.request, request) || other.request == request));
}


@override
int get hashCode => Object.hash(runtimeType,request);

@override
String toString() {
  return 'AddressEvent.createAddress(request: $request)';
}


}

/// @nodoc
abstract mixin class _$CreateAddressCopyWith<$Res> implements $AddressEventCopyWith<$Res> {
  factory _$CreateAddressCopyWith(_CreateAddress value, $Res Function(_CreateAddress) _then) = __$CreateAddressCopyWithImpl;
@useResult
$Res call({
 AddressRequestModel request
});




}
/// @nodoc
class __$CreateAddressCopyWithImpl<$Res>
    implements _$CreateAddressCopyWith<$Res> {
  __$CreateAddressCopyWithImpl(this._self, this._then);

  final _CreateAddress _self;
  final $Res Function(_CreateAddress) _then;

/// Create a copy of AddressEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? request = null,}) {
  return _then(_CreateAddress(
null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as AddressRequestModel,
  ));
}


}

/// @nodoc


class _UpdateAddress implements AddressEvent {
  const _UpdateAddress(this.id, this.request);
  

 final  int id;
 final  AddressRequestModel request;

/// Create a copy of AddressEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateAddressCopyWith<_UpdateAddress> get copyWith => __$UpdateAddressCopyWithImpl<_UpdateAddress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateAddress&&(identical(other.id, id) || other.id == id)&&(identical(other.request, request) || other.request == request));
}


@override
int get hashCode => Object.hash(runtimeType,id,request);

@override
String toString() {
  return 'AddressEvent.updateAddress(id: $id, request: $request)';
}


}

/// @nodoc
abstract mixin class _$UpdateAddressCopyWith<$Res> implements $AddressEventCopyWith<$Res> {
  factory _$UpdateAddressCopyWith(_UpdateAddress value, $Res Function(_UpdateAddress) _then) = __$UpdateAddressCopyWithImpl;
@useResult
$Res call({
 int id, AddressRequestModel request
});




}
/// @nodoc
class __$UpdateAddressCopyWithImpl<$Res>
    implements _$UpdateAddressCopyWith<$Res> {
  __$UpdateAddressCopyWithImpl(this._self, this._then);

  final _UpdateAddress _self;
  final $Res Function(_UpdateAddress) _then;

/// Create a copy of AddressEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? request = null,}) {
  return _then(_UpdateAddress(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as AddressRequestModel,
  ));
}


}

/// @nodoc


class _DeleteAddress implements AddressEvent {
  const _DeleteAddress(this.id);
  

 final  int id;

/// Create a copy of AddressEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteAddressCopyWith<_DeleteAddress> get copyWith => __$DeleteAddressCopyWithImpl<_DeleteAddress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteAddress&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'AddressEvent.deleteAddress(id: $id)';
}


}

/// @nodoc
abstract mixin class _$DeleteAddressCopyWith<$Res> implements $AddressEventCopyWith<$Res> {
  factory _$DeleteAddressCopyWith(_DeleteAddress value, $Res Function(_DeleteAddress) _then) = __$DeleteAddressCopyWithImpl;
@useResult
$Res call({
 int id
});




}
/// @nodoc
class __$DeleteAddressCopyWithImpl<$Res>
    implements _$DeleteAddressCopyWith<$Res> {
  __$DeleteAddressCopyWithImpl(this._self, this._then);

  final _DeleteAddress _self;
  final $Res Function(_DeleteAddress) _then;

/// Create a copy of AddressEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_DeleteAddress(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _SetDefault implements AddressEvent {
  const _SetDefault(this.id);
  

 final  int id;

/// Create a copy of AddressEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetDefaultCopyWith<_SetDefault> get copyWith => __$SetDefaultCopyWithImpl<_SetDefault>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetDefault&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'AddressEvent.setDefault(id: $id)';
}


}

/// @nodoc
abstract mixin class _$SetDefaultCopyWith<$Res> implements $AddressEventCopyWith<$Res> {
  factory _$SetDefaultCopyWith(_SetDefault value, $Res Function(_SetDefault) _then) = __$SetDefaultCopyWithImpl;
@useResult
$Res call({
 int id
});




}
/// @nodoc
class __$SetDefaultCopyWithImpl<$Res>
    implements _$SetDefaultCopyWith<$Res> {
  __$SetDefaultCopyWithImpl(this._self, this._then);

  final _SetDefault _self;
  final $Res Function(_SetDefault) _then;

/// Create a copy of AddressEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_SetDefault(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$AddressState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressState()';
}


}

/// @nodoc
class $AddressStateCopyWith<$Res>  {
$AddressStateCopyWith(AddressState _, $Res Function(AddressState) __);
}


/// Adds pattern-matching-related methods to [AddressState].
extension AddressStatePatterns on AddressState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Address> addresses)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.addresses);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Address> addresses)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.addresses);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Address> addresses)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.addresses);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements AddressState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressState.initial()';
}


}




/// @nodoc


class _Loading implements AddressState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressState.loading()';
}


}




/// @nodoc


class _Loaded implements AddressState {
  const _Loaded(final  List<Address> addresses): _addresses = addresses;
  

 final  List<Address> _addresses;
 List<Address> get addresses {
  if (_addresses is EqualUnmodifiableListView) return _addresses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_addresses);
}


/// Create a copy of AddressState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._addresses, _addresses));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_addresses));

@override
String toString() {
  return 'AddressState.loaded(addresses: $addresses)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $AddressStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<Address> addresses
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of AddressState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? addresses = null,}) {
  return _then(_Loaded(
null == addresses ? _self._addresses : addresses // ignore: cast_nullable_to_non_nullable
as List<Address>,
  ));
}


}

/// @nodoc


class _Error implements AddressState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of AddressState
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
  return 'AddressState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $AddressStateCopyWith<$Res> {
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

/// Create a copy of AddressState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
