<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

//initialController
Route::post('registrarUsuario', 'initialController@registrarUsuario');
Route::get('getLogin'         , 'initialController@getLogin');

// getLogin -> user, password
// registrarUsuario -> user, password, nom_user,ape_user
// getListarProductoIdCategoria -> id_categoria
// getProductoSelect -> id_producto
