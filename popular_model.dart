import 'package:flutter/material.dart';
import '../presenter/popular_presenter.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class PopularPageModel {
  PopularPagePresenterState _presenter;

  PopularPageModel() {}

  set presenter(PopularPagePresenterState value) { 
    this._presenter = value;
  }

  Stream<QuerySnapshot> getCollectionCategories() {
    return Firestore.instance.collection('Frutas&Vegetales').snapshots();
    // return Firestore.instance.collection('Categorias').snapshots();
  }

  // List<DocumentSnapshot> getPopular(List<DocumentSnapshot> lista) {
  //   int max = 0;
  //   int max2 = 0;
  //   int max3 = 0;
  //   // List<List<DocumentSnapshot>> res = new List<List<DocumentSnapshot>>();
  //   List<DocumentSnapshot> res = new List<DocumentSnapshot>();
  //   // List<DocumentSnapshot> items = new List<DocumentSnapshot>();
  //   // List<DocumentSnapshot> items2 = new List<DocumentSnapshot>();
  //   // List<DocumentSnapshot> items3 = new List<DocumentSnapshot>();
  //   DocumentSnapshot items;
  //   DocumentSnapshot items2;
  //   DocumentSnapshot items3;

  //   for (int i = 0; i < lista.length; i++) {
  //     if(lista[i]['count'] > max){
  //       max = lista[i]['count'];
  //       // items.add(lista[i]);
  //       items = lista[i];
  //     }
  //     if(lista[i]['count2'] > max2){
  //       max2 = lista[i]['count2'];
  //       // items2.add(lista[i]);
  //       items2 = lista[i];
  //     }
  //     if(lista[i]['count3'] > max3){
  //       max3 = lista[i]['count3'];
  //       // items3.add(lista[i]);
  //       items3 = lista[i];
  //     }
  //   }
  //   // if(items.length > 1){
  //   //   items.removeAt(items.length - 1);
  //   // }
  //   // if(items2.length > 1){
  //   //   items2.removeAt(items2.length - 1);
  //   // }
  //   // if(items3.length > 1){
  //   //   items3.removeAt(items3.length - 1);
  //   // }
  //   res.add(items);
  //   res.add(items2);
  //   res.add(items3);

  //   return res;
  // }

  Future<List<List<DocumentSnapshot>>> getPopularList(List<DocumentSnapshot> list_snapshot) async {
    List<List<DocumentSnapshot>> res = new List<List<DocumentSnapshot>>();
    // List<String> array;
    var array = ['Frutas&Vegetales', 'Pan&Pasteles'];
    
    // for (int i = 0; i < list_snapshot.length; i++) {
    //     array.add(list_snapshot[i]['nombre']);
    // }
 
    for (int i = 0; i < array.length; i++) {
      QuerySnapshot querySnapshot = await Firestore.instance.collection(array[i]).getDocuments();
      var lista = querySnapshot.documents;
      int max = 0;
      int max2 = 0;
      int max3 = 0;
      DocumentSnapshot items;
      DocumentSnapshot items2;
      DocumentSnapshot items3;
      List<DocumentSnapshot> listdocs = new List<DocumentSnapshot>();
      for (int i = 0; i < lista.length; i++) {
        if(lista[i]['count'] > max){
          max = lista[i]['count'];
          items = lista[i];
        }
        if(lista[i]['count2'] > max2){
          max2 = lista[i]['count2'];
          items2 = lista[i];
        }
        if(lista[i]['count3'] > max3){
          max3 = lista[i]['count3'];
          items3 = lista[i];
        }
      }
      listdocs.add(items);
      listdocs.add(items2);
      listdocs.add(items3);
      res.add(listdocs);
    }
    return res;
  }
}
