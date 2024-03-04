abstract class InternetConnectionState {}

class InternetConnectionInitial extends InternetConnectionState {
  @override
  List<Object?> get props => [];
}

class InternetConnectionSuccess extends InternetConnectionState {
  final String result;

  InternetConnectionSuccess(this.result);
}

class InternetConnectionFailure extends InternetConnectionState {
  final String error;

  InternetConnectionFailure(this.error);
}

class InternetConnectionLoading extends InternetConnectionState {}
