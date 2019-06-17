import 'package:flutter/material.dart';
 
import '../model/popular_model.dart';
import '../view/popular.dart';


import 'package:cloud_firestore/cloud_firestore.dart';

class PopularPagePresenter {
}

class PopularPagePresenterState implements PopularPagePresenter {
  PopularPageModel _viewModel;

  PopularPageState _viewAuth;

  PopularPagePresenterState(){   
    _viewModel = new PopularPageModel();
    _viewModel.presenter = this; 
  }

  set model(PopularPageModel value){
    this._viewModel = value; 
  }

  set view(PopularPageState value){ 
    this._viewAuth = value;
  }

  Stream<QuerySnapshot> getCollection() {
    return _viewModel.getCollectionCategories(); 
  }

  // List<DocumentSnapshot> getPopular(List<DocumentSnapshot> lista) {
  //   return _viewModel.getPopular(lista);
  // }

  Future<List<List<DocumentSnapshot>>> getPopularList(List<DocumentSnapshot> list_snapshot) {
    return _viewModel.getPopularList(list_snapshot);
  }
}
