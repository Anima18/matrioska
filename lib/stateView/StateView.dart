import 'package:flutter/material.dart';
import 'package:matrioska/viewModel/view_state.dart';

typedef OnRetry = void Function();

class StateView extends StatelessWidget {
  Widget _loadingView;
  Widget _errorView;
  Widget _emptyView;
  final Widget child;
  final OnRetry onRetry;
  final DataState viewState;
  final String errorMessage;
  final double iconSize = 200;

  StateView(
      {@required this.child,
        this.onRetry,
        this.viewState : DataState.loading,
        @required this.errorMessage,
        Widget loadingView,
        Widget errorView,
        Widget emptyView}) {
    _loadingView  = loadingView == null ? _getLoadingView() : loadingView;
    _errorView  = errorView == null ? _getErrorView() : errorView;
    _emptyView  = emptyView == null ? _getEmptyView() : emptyView;
  }


  @override
  Widget build(BuildContext context) {
    if (viewState == DataState.loading) {
      return _loadingView;
    } else if (viewState == DataState.error) {
      return _errorView;
    } else if (viewState == DataState.empty) {
      return _emptyView;
    } else {
      return child;
    }
  }

  Widget _getLoadingView() {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }

  Widget _getErrorView() {
    return Container(
      alignment: Alignment.center,
      child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/error.png", package: "matrioska"),
                width: iconSize,
                height: iconSize,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                errorMessage != null ? errorMessage : "",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              FlatButton(
                child: Text("点击重试"),
                textColor: Colors.blue,
                onPressed: () {
                  _retry();
                },
              ),
            ],
          )),
    );
  }

  Widget _getEmptyView() {
    return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage("assets/not_data.png", package: "matrioska"),
              width: iconSize,
              height: iconSize,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "没有数据",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            FlatButton(
              child: Text("点击重试"),
              textColor: Colors.blue,
              onPressed: () {
                _retry();
              },
            ),
          ],
        ));
  }

  void _retry() {
    if (onRetry != null) {
      onRetry();
    }
  }
}
