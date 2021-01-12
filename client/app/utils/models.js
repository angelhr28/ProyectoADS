class Item {
	constructor(data) {
		this.itemStatus        = false;
		this.itemPercent       = 0;
		this.itemNombre        = data.nomb_producto;
		this.itemDiscount      = false;
		this.itemBaseAmount    = data.precio_producto;
		this.itemDiscountAmoun = 0;
		this._id_marca         = data._id_marca;
		this.caract_producto   = data.caract_producto;
		this.desc_producto     = data.desc_producto;
		this.id_categoria      = data.id_categoria;
		this.id_producto       = data.id_producto;
		this.img_producto      = data.img_producto;
		this.precio_producto   = data.precio_producto;
		this.nomb_producto     = data.nomb_producto;
		this.id_categoria      = data.id_categoria;
	}
}

class Categoria {
	constructor(data) {
		this.id_categoria = data.id_categoria;
		this.nomb_categoria = data.nomb_categoria;
		this.foto_categoria = data.foto_categoria;
		this.is_active      = data.is_active || false;
	}
}