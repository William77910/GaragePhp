<?php

namespace App\Controllers;
use App\Models\Car;

/**
 * Gère la logique de la page d'accueil
 */
class HomeController extends BaseController{

  public function index():void{

    $carModel = new Car();

    // On rend la vue 'home/index' et on lui passe le titre et la liste des voitures
    $this->render('home/index',[
      'title'=>'Accueil - Garage php',
      'cars'=> $carModel->all()
    ]);

  }
}