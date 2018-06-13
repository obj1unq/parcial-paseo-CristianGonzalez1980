class Prenda {

	var property talle
	var property desgaste = 0

	method puntosPorComodidad(ninio) {
		return if (talle == ninio.talle()) {
			8
		} else {
			0
		}
	}

	method nivelDeDesgaste() = desgaste

	method puntosPorDesgaste() = desgaste.min(3)

	method nivelDeComodidad(ninio) = self.puntosPorComodidad(ninio) - self.puntosPorDesgaste()

	method nivelDeCalidad(ninio) = self.nivelDeAbrigo() + self.nivelDeComodidad(ninio)

	method nivelDeAbrigo()

	method desgastar() {
		desgaste = +1
	}

}

class PrendaDeAPares inherits Prenda {

	var elementos = []

	override method nivelDeDesgaste() = (elementos.get(0).nivelDeDesgaste() + elementos.get(1).nivelDeDesgaste()) / 2

	method puntosPorEdad(ninio) {
		return if (ninio.esMenorA4Anios()) {
			1
		} else {
			0
		}
	}

	override method puntosPorComodidad(ninio) = super(ninio) - self.puntosPorEdad(ninio)

	method verificarTalle(par, otropar) = par.talle() == otropar.talle()

	method intercambiarPar(otroPar) {
		var par1 = elementos
		var par2 = otroPar.elementos()
		if (self.verificarTalle(par1, par2)) {
			elementos = par1.take(1) + par2.drop(1)
			otroPar.elemntos(par2.take(1) + par1.drop(1))
		}
	}

	override method nivelDeAbrigo() = elementos.get(0).nivelDeAbrigo() + elementos.get(1).nivelDeAbrigo()

	override method desgastar() {
		elementos.forEach({ elemento => elemento.desgastar()})
	}

}

class Elemento {

	var desgaste = 0
	var property nivelDeAbrigo = 1
	var property nivelDeDesgaste = desgaste

}

class ElementoDerecho inherits Elemento {
	
	method desgastar() {
		
		desgaste =+ 1.20
	}
	
	
}class ElementoIzquierdo inherits Elemento {
	
	method desgastar() {
		
		desgaste =+ 0.8
	}
	
	
}class RopaLiviana inherits Prenda {

	var nivelDeAbrigo = abrigoLiviana.nivelDefault()

	override method puntosPorComodidad(ninio) = super(ninio) + 2

	override method nivelDeAbrigo() = nivelDeAbrigo

}

object abrigoLiviana {

	var property nivelDefault = 1

}

class RopaPesada inherits Prenda {

	var nivelDeAbrigo = 3

	override method nivelDeAbrigo() = nivelDeAbrigo

}

class Ninio {

	var property talle
	var property edad
	var prendas = #{}

	method listoParaSalirDePaseo() = self.tieneAlMenosXPrendas() && self.tieneBuenAbrigo() && self.calidadSuperior()

	method tieneAlMenosXPrendas() = self.cantidadDePrendas() == 5

	method tieneBuenAbrigo() = prendas.any({ prenda => prenda.nivelDeAbrigo() >= 3 })

	method calidadSuperior() = prendas.sum({ prenda => prenda.nivelDeCalidad(self) }) / self.cantidadDePrendas() > 8

	method cantidadDePrendas() = prendas.size()

	method prendaInfaltable() = prendas.max({ prenda => prenda.nivelDeCalidad(self) })

	method esMenorA4Anios() = edad < 4

	method usarPrendas() = prendas.forEach({ prenda => prenda.desgastar() })

}

class NinioProblematico inherits Ninio {

	var juguete

	override method tieneAlMenosXPrendas() = self.cantidadDePrendas() == 4

	override method listoParaSalirDePaseo() = super() && self.tieneEdadAcordeAJuguete()

	method tieneEdadAcordeAJuguete() = edad > juguete.min() && edad < juguete.max()

}

class Juguete {

	var property min
	var property max

}

class Familia {

	var ninios = #{}

	method puedeSalirDePaseo() = ninios.all({ ninio => ninio.listoParaSalirDePaseo() })

	method prendasInfaltables() = ninios.map({ ninio => ninio.prendaInfaltable() })

	method niniosChiquitos() = ninios.filter({ ninio => ninio.esMenosA4anios() })

	method salirDePaseo() {
		if (self.puedeSalirDePaseo()) {
			
			ninios.forEach({ninio => ninio.usarPrendas()})
			
		} else {
			self.error("no se encuentran listos la totalidad de los ninios para el paseo")
		}
	}

}

//Objetos usados para los talles
object xs {

}

object s {

}

object m {

}

object l {

}

object xl {

}
