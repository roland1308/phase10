import 'package:flutter/material.dart';

class Instructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Instrucciones"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HISTORIA:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'El juego Phase 10 fue creado por Kenneth Johnson en el 1982. Era publicado por Fundex Games pero en el 2010 Mattel (en inglés) adquiere los derechos para su publicación a nivel mundial. El juego está basado en el juego de cartas Rummy que se juega utilizando una baraja estándar.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8.0),
              Text(
                'INFORMACIÓN GENERAL:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'El Phase 10 es un juego ideal para jugar en familia y además tiene un alto valor educativo.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16.0),
              Text(
                'Objetivo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Ser el primero en completar diez diferentes fases, de ahí su nombre, en diez rondas diferentes.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8.0),
              Text(
                'Contenido',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '- Dos cartas de referencia con las fases a completar\n- 108 cartas: 24 de cada color (rojo, azul, amarillo y verde) numeradas del 1 al 12; cuatro cartas Skip (Brinco) y ocho cartas Wild (Salvajes).',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16.0),
              Text(
                'Significado de las cartas de acción',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '- Wild: Esta carta puede ser utilizada para reemplazar cualquier carta, ya sea un número o color, para completar cualquier fase. El valor asignado se mantiene por toda la mano. Se puede utilizar más de una carta Wild con este propósito. Si es la primera carta lanzada en la pila de descarte esta puede ser tomada por el primer jugador.\n- Skip: Esta carta se utiliza para saltar a un jugador. El que lanza la carta escogerá el jugador que perderá su próximo turno que no necesariamente es el jugador a su izquierda.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16.0),
              Text(
                'Fases',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Las fases son la misión a completar en cada mano. Las fases se realizan en orden. Se puede completar una sola fase por mano. Sin embargo, si no logras completar una fase en la mano puedes intentar conseguir completarla en la próxima mano.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16.0),
              Text(
                'Las fases giran en torno a tres tipos de misión:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '- Sets: Completar conjuntos de un mismo número de cualquier color.\n- Run o Sequencia: Completar una secuencia numérica de cualquier color.\n- Un color: Completar un conjunto de cartas de un mismo color.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16.0),
              Text(
                'Las diez fases son:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                """ 1. dos conjuntos de tres
 2. un conjunto de tres + una corrida de cuatro
 3. un conjunto de cuatro + una secuencia de cuatro
 4. una secuencia de siete
 5. una secuencia de ocho
 6. una secuencia de nueve
 7. dos conjuntos de cuatro
 8. siete cartas de un color
 9. un conjunto de cinco y un conjunto de dos
10. un conjunto de cinco y un conjunto de tres""",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16.0),
              Text(
                'Ejemplos de jugadas:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                """- Fase 1: Tres cartas de 5 y tres cartas de 7
- Fase 4: Cartas 2, 3, 4, 5, 6, 7 y 8
- Fase 8: 1 rojo, 3 rojo, 5 rojo, 5 rojo, 7 rojo, 10 rojo, 11 rojo

Recuerda que una carta Wild puede sustituir cualquier carta de los ejemplos anteriores.""",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16.0),
              Text(
                'REGLAS:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Antes de comenzar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Escoge un jugador para que mezcle y reparta las cartas. Se reparten boca abajo diez cartas a cada jugador. El resto de las cartas se colocan boca abajo en el centro de la mesa. La primera carta se voltea y se coloca al lado pues esta será la primera carta de la pila de descarte. Luego todos los jugadores voltean sus cartas y las estudian para determinar que necesitan para completar su misión.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16.0),
              Text(
                'Desarrollo del juego',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                """El jugador a la izquierda del repartidor comienza el juego. Durante tu turno podrás realizar las siguientes acciones:

- Robar: Tomar una carta ya sea de la pila de robar o de la pila de descartar. Esta acción es obligatoria.

- Completar la fase: Colocar sobre la mesa y boca arriba las cartas que completan la fase. Esto solo puedes hacerlo cuando tienes la fase completa en su totalidad.

- Golpear (hitting): Esta acción podrás realizarla cuando hayas completado la fase. Esta es la manera en que irás deshaciéndote de tus cartas. Para hacerlo podrás añadir una carta a tus cartas de la fase o la de los demás jugadores. Por ejemplo: en la fase 1, puedes añadir otro cinco al conjunto de 5; en la fase 4 puedes añadir un 1 o un 9; y en la fase 8 puedes añadir un 1 rojo.

- Descartar: Al final de tu turno debes tirar una de tus cartas en la pila de descarte.

El juego continua a favor de las manecillas del reloj. La mano continúa hasta que uno de los jugadores se queda sin cartas. En una misma mano dos o más jugadores pueden completar la fase.

Al finalizar la mano se cuentan los puntos de los jugadores con cartas en mano y se lleva un registro.""",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16.0),
              Text(
                'Puntuaciones:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                """- Cartas del 1 al 9 valen cinco puntos
- Cartas del 10 al 12 valen diez puntos
- Cartas Skip valen 15 puntos
- Cartas Wild valen 25 puntos""",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16.0),
              Text(
                'Final del juego',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'El juego termina cuando un jugador ha logrado completar las diez fases al final de la mano. Si más de un jugador lo logra, gana el que tenga menos puntos. Si hay un empate se juega otra mano para completar la fase 10. El primero que se quede sin cartas gana.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
