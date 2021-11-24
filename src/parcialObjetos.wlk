class Invader
{
	var property durabilidad
	
	method disparar(jugador)
	{
		if(not self.estaMuerto())
			self.realizarDisparo(jugador)
	}
	
	method realizarDisparo(jugador)
	{
		durabilidad += 1
	}
	
	method modificarDurabilidad(cant)
	{
		durabilidad = (durabilidad + cant).max(0)
	}
	
	method morir()
	{
		durabilidad = 0
	}
	
	method estaMuerto() = durabilidad == 0
}

class Squid inherits Invader
{
	//Hereda el metodo disparar de la clase Invader
}

class Crab inherits Invader
{
	override method realizarDisparo(jugador)
	{
		super(jugador)
		if(jugador.tienePocaVida())
			jugador.serImpactadoPor(self)
	}
}

class UFO inherits Invader
{
	override method realizarDisparo(jugador)
	{
		super(jugador)
		jugador.serImpactadoPor(self)
	}
}

class Octopus inherits Invader
{
	override method realizarDisparo(jugador)
	{
		super(jugador)
		if(not tablero.cantidadDeInvaders().even())
			jugador.serImpactadoPor(self)
	}
}

object player
{	
	var property vida = 100
	var property categoria = novato
	
	method disparar(invader)
	{
		self.validarInvader(invader)
		self.incrementarVidaPorDisparo(invader)
		categoria.ocasionarDanio(invader,self)
	}
	
	method incrementarVidaPorDisparo(invader)
	{
		vida += (vida - invader.durabilidad()).min(10)
	}
	
	method validarInvader(invader)
	{
		if(invader.estaMuerto())
			throw new DomainException(message = "El player no puede dispararle a un invader muerto")
	}
	
	method modificarVida(cant)
	{
		vida = (vida + cant).max(0)
	}
	
	method cambiarDeCategoria()
	{
		categoria.cambiar(self)
	}
	
	method serImpactadoPor(invader)
	{
		categoria.serImpactado(invader,self)
	}
	
	method tienePocaVida() = vida.between(1,50)
}

object novato
{
	method ocasionarDanio(invader,player)
	{
		invader.modificarDurabilidad(player.vida() * (-0.1))
	}
	
	method serImpactado(invader,player)
	{
		player.modificarVida(-invader.durabilidad() / 2)
	}
	
	method cambiar(player)
	{
		if(self.vidaSuperaAAlgunaDurabilidad(player))
			player.categoria(experimentado)
	}
	
	method vidaSuperaAAlgunaDurabilidad(player) = tablero.invaders().any({inv => player.vida() > inv.durabilidad()})
}

object experimentado
{
	var property vidaPerdidaPorImpacto = 5
	
	method ocasionarDanio(invader,_)
	{
		invader.modificarDurabilidad(-tablero.cantidadDeInvadersVivos())
	}
	
	method serImpactado(invader,player)
	{
		player.modificarVida(-vidaPerdidaPorImpacto)
	}

	method cambiar(player)
	{
		if(self.vidaSuperaAlMenosLaMitadDeLasDurabilidades(player))
			player.categoria(gamer)
	}	
	
	method vidaSuperaAlMenosLaMitadDeLasDurabilidades(player) = self.cantDeInvadersQueElPlayerSuperaSuDurabilidad(player) > (tablero.cantidadDeInvaders() / 2)
	
	method cantDeInvadersQueElPlayerSuperaSuDurabilidad(player) = tablero.invaders().count({inv => player.vida() > inv.durabilidad()})
	 
}

object gamer
{
	method ocasionarDanio(invader,_)
	{
		invader.morir()
	}
	
	method serImpactado(invader,player)
	{
		player.modificarVida(-tablero.invaderMejorPosicionado().durabilidad())
	}
	
	method cambiar(){}
}

object tablero
{
	const property invaders = []
	
	method cantidadDeInvaders() = invaders.size()
	
	method invaderMejorPosicionado() = invaders.max({invader => invader.durabilidad()})
	
	method cantidadDeInvadersVivos() = invaders.count({inv => not inv.estaMuerto()})
	
	method agregarInvader(invader)
	{
		invaders.add(invader)
	}
}


/*	Punto 6
 * 
 * En el sentido estricto de la definicion de clase abstracta, esta requiere por lo menos un metodo abstracto 
 * y no se puede instanciar objetos a partir de la misma
 * 
 * Pero en cuanto al modelo realizado, la clase Invader seria una clase abstracta a pesar de que no tiene un metodo abstracto,
 * ya que no creamos instancias a partir de ella.
 * 
*/












