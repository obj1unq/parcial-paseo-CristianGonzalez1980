//NOTA: 9 (nueve)
// 1) B+: Un pequeño bug por tener/usar la variable desgaste en Prenda
// 2) M: No lanza el error y se enrieda con las listas
// 3) B+: Dos bugs por la manera de inicializar variables en combinación con properties/objetos bien conocidos
// 4) MB
// 5) MB
// 6) MB-
// 7) MB
// 8) MB

class Prenda {

	var property talle
	//TODO: Esta variable no la usan todas las prendas
	var property desgaste = 0

	method puntosPorComodidad(ninio) {
		return if (talle == ninio.talle()) {
			8
		} else {
			0
		}
	}

	method nivelDeDesgaste() = desgaste

	//TODO: Acá deberías usar el método nivelDeDesgaste, ya que la prenda a pares no usa esa variable
	method puntosPorDesgaste() = desgaste.min(3)

	method nivelDeComodidad(ninio) = self.puntosPorComodidad(ninio) - self.puntosPorDesgaste()

	method nivelDeCalidad(ninio) = self.nivelDeAbrigo() + self.nivelDeComodidad(ninio)

	method nivelDeAbrigo()

	method desgastar() {
		desgaste = +1
	}

}

class PrendaDeAPares inherits Prenda {
	//TODO: En este caso queda más cómodo tener una referencia para izquierda y otra para derecha
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
			//Esto tiene muchos problemas sintácticos: el + solo anda para concatenar listas. 
			//ni take ni drop devuvelven listas
			//La decisión de usar listas en  lugar de dos referencias distintas para izq/der
			//te complica
			elementos = par1.take(1) + par2.drop(1)
			otroPar.elemntos(par2.take(1) + par1.drop(1))
		}
		//TODO Y si no cumple hay que romper!!!!! self.error("...")
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
	//TODO Este código tiene problemas. Es equivalente a:
	// var nivelDeDesgaste = desgaste
	// method nivelDeDesgaste() = nivelDeDesgaste
	// method nivelDeDesgaste(_valor) { nivelDeDesgaste = _valor}
	//Entoces fijate que las subclases modifican la variable "desgaste", pero 
	//el metodo que consulta por el nivel no lo tiene en cuenta

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

	//TODO: Haciendolo de este modo, cuando se modifica el nivel default, las ropas ya creadas
	//Siguen usando el nivel viejo. El requerimiento era poder cambiar el valor para todas
	//las ropas a la vez. Entonces en el metodo nivelDeAbrigo deberías haber devuelvo el 
	//valor configurado en abrigoLiviana
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

	//TODO Lo que menos duplica código es sobreescribiendo un método que devuelva el 
	//mínimo de prendas 4/5
	override method tieneAlMenosXPrendas() = self.cantidadDePrendas() == 4

	override method listoParaSalirDePaseo() = super() && self.tieneEdadAcordeAJuguete()

	//TODO: Más facil usar un between
	method tieneEdadAcordeAJuguete() = edad > juguete.min() && edad < juguete.max()

}

class Juguete {

	var property min
	var property max

}

class Familia {

	var ninios = #{}

	method puedeSalirDePaseo() = ninios.all({ ninio => ninio.listoParaSalirDePaseo() })

	//TODO: Lo mejor es hacer un asSet para devolver un conjunto
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
