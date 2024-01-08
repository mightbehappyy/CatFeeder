
<h1 align="center">
  <br>
  <a href=""><img src="https://i.imgur.com/xXllAvt.png" alt="ROSA" width="600"></a>
  <br>
  <br>
</h1>

<h1 align="center">Cat Feeder</h1>

<p align="center">Alimente seu gato automaticamente com Arduino!</p>

<div align="center">
  <a href="https://makeapullrequest.com">
    <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square" alt="PRs Welcome">
  </a>
  <a href="https://wakatime.com/badge/user/018bb0d6-56a3-43d5-85d1-e7b7401fdda3/project/018cda84-2da9-46fe-8377-672cc817dd55"><img src="https://wakatime.com/badge/user/018bb0d6-56a3-43d5-85d1-e7b7401fdda3/project/018cda84-2da9-46fe-8377-672cc817dd55.svg" alt="wakatime"></a>
  </a>
</div>



## Descrição
O Cat Feeder é um projeto que utiliza a plataforma Arduino visando atuar como um "dispenser" para ração de gato. A ideia começou quando percebi que minha namorada precisava sair da faculdade para colocar ração para Navii 😾 (a gata dela) ou esquecia se havia colocado ração ou não. Além disso, muitas vezes essa gata demasiadamente astuta implorava por comida mesmo já sendo alimentada e, como resultado, mais ração que o recomendado estava sendo colocada. Já fazia algum tempo que queria produzir algo para Arduino, mas os projetos em que pensava eram grandes ou pequenos demais. Ao observar essa situação, vi que era um problema de tamanho perfeito e que poderia ser solucionado utilizando Arduino. 

## Como usar?
A utilização é bastante simples, você pode definir até 5 alarmes para que o Cat Feeder entregue a ração, também é possível definir o tamanho das porções. Existem 3 "telas" que são exibidas no display, a primeira tela mostra a hora atual e o horário da próxima refeição, na segunda tela é possível ativar ou desativar os alarmes das refeições e definir seu horário no modo de configuração e na terceira tela você pode decidir qual será o tamanho das porções de ração, atualmente não é possível personalizar a porção para cada horário o valor definido vale para todas as refeições. 

Existem 4 botões que você utiliza para realizar estas operações, segue abaixo o esquema dos botões:

![figmaBotoes](https://github.com/mightbehappyy/CatFeeder/assets/97134972/6c973c27-ef78-4915-9156-e146e971617a)


>Para transitar entre as telas, sendo estas "Tela inicial", "Alarmes" e a "Porção" basta pressionar "C"

![figmaMudançatela](https://github.com/mightbehappyy/CatFeeder/assets/97134972/090bcbad-398c-436c-b9e3-45b87ab7898f)

> Na tela dos alarmes é possível ativá-los.

![ativarAlarme](https://github.com/mightbehappyy/CatFeeder/assets/97134972/4532a30a-36d6-4cb4-8044-54ec8b211709)

> Pressionando "A" é possível transitar entre os 5 alarmes disponíveis.

![alarmes](https://github.com/mightbehappyy/CatFeeder/assets/97134972/d354c691-76ce-441f-b603-f4d91b485a75)

> Para aumentar a porção, basta pressionar "A"

![porção2](https://github.com/mightbehappyy/CatFeeder/assets/97134972/81041801-3c58-43fe-89da-7e73a79766da)

> Na tela dos alarmes, o usuário pode ativar o modo de configuração pressionando "D"

![configAlarmes2](https://github.com/mightbehappyy/CatFeeder/assets/97134972/b3ce625a-d958-49ed-82c2-a802300b27e4)
## Montagem
Os botões são conectados à placa do Arduino utilizando as portas digitais 13, 12, 11 e 10. Já o RTC DS1307 e o display [I2C](http://www.univasf.edu.br/~romulo.camara/novo/wp-content/uploads/2013/11/Barramento-e-Protocolo-I2C.pdf) estão conectados às portas analógicas A4 e A5 e à porta de 5V. Como ambos utilizam o protocolo I2C, é necessário descobrir o endereço I2C do display que pode mudar conforme o display e o microcontrolador, neste caso o endereço do meu display é 0X3F. No futuro, a definição do endereço será dinâmica. Neste ponto do projeto, ainda não há relé para o controle do motor que será responsável por liberar a ração do dispenser.

### Modulos utilizados
>Arduino UNO

>RTC DS1307

>Display 16x2 I2C

>Protoboard 760 furos

>Protoboard 170 furos

>20 jumpers
### Esquemático
![protoboard](https://github.com/mightbehappyy/CatFeeder/assets/97134972/533f7db4-31a3-4943-992e-b1adb887728d)
*A organização dos jumpers foi alterada em relação a que eu utilizo para uma melhor visualização.* 

## To do
- [x] Criar lógica dos alarmes
- [x] Fazer conexão do display e implementar biblioteca
- [x] Implementação das telas
- [x] Comprar RTC DS1307 
- [X] Adicionar checagem de horário
- [X] Adicionar checagem de alarme mais próximo
- [ ] Comprar relé e implementar sua lógica
- [ ] Comprar motor e fazer conexão com o relé
- [ ] Criar uma estrutura para o Cat Feeder
- [ ] Refatoração do código


## Tecnologias
![Arduino](https://img.shields.io/badge/Arduino-00878F.svg?style=for-the-badge&logo=Arduino&logoColor=white)
![C++](https://img.shields.io/badge/c++-%2300599C.svg?style=for-the-badge&logo=c%2B%2B&logoColor=white)


## Bibliotecas
- [LiquidCrystal_I2C](https://gitlab.com/tandembyte/LCD_I2C)
- [RTClib](https://github.com/adafruit/RTClib)



## Licença


## Autor
| <img src="https://avatars.githubusercontent.com/mightbehappyy" width="100px;" alt="Mightbehappy"/><br /><sub></sub></a><br/> |
|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| [Mightbehappyy](https://github.com/mightbehappyy)                                                                                                     |
