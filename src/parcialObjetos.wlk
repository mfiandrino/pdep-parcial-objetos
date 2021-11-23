class Invader
{
	var property durabilidad
	
	method disparar(jugador)
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
	
}

class Crab inherits Invader
{
	override method disparar(jugador)
	{
		super(jugador)
		if(jugador.vida().between(1,50))
			jugador.impactar()
	}
}

class UFO inherits Invader
{
	override method disparar(jugador)
	{
		super(jugador)
		jugador.impactar()
	}
}

class Octopus inherits Invader
{
	override method disparar(jugador)
	{
		if(tablero.cantidadDeInvaders().even())
			super(jugador)
		else
			jugador.impactar()
			
	}
}

object player
{	
	var property vida
	var property categoria = novato
	
	method disparar(invader)
	{
		self.validarInvader(invader)
		self.incrementarVidaPorDisparo(invader)
		categoria.efectoDisparo(invader,self)
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
}

object novato
{
	method efectoDisparo(invader,player)
	{
		invader.modificarDurabilidad(player.vida() * (-0.1))
	}
	
	method serImpactado(invader,player)
	{
		player.modificarVida(-invader.durabilidad() / 2)
	}
	
	method cambiar(player)
	{
		if(tablero.invaders().any({inv => inv.durabilidad() < player.vida()}))
			player.categoria(experimentado)
	}
}

object experimentado
{
	var property vidaPerdidaPorImpacto = 5
	
	method efectoDisparo(invader,_)
	{
		invader.modificarDurabilidad(-tablero.cantidadDeInvaders())
	}
	
	method serImpactado(invader,player)
	{
		player.modificarVida(-vidaPerdidaPorImpacto)
	}
	
}

object gamer
{
	method efectoDisparo(invader,_)
	{
		invader.morir()
	}
	
	method serImpactado(invader,player)
	{
		player.modificarVida(-tablero.invaderMejorPosicionado().durabilidad())
	}
}

object tablero
{
	const property invaders = []
	
	method cantidadDeInvaders() = invaders.size()
	
	method invaderMejorPosicionado() = invaders.max({invader => invader.durabilidad()})
}










