
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
Os botões são conectados à placa do Arduino utilizando os digital pins 13, 12, 11 e 10. Já o RTC DS1307 e o display [I2C](http://www.univasf.edu.br/~romulo.camara/novo/wp-content/uploads/2013/11/Barramento-e-Protocolo-I2C.pdf) estão conectados aos analog pins A4 e A5 e a porta de 5V. Como ambos utilizam o protocolo I2C é necessário descobrir o endereço I2C do display que pode mudar conforme o display e o microcontrolador, neste caso o endereço do meu display é 0X3F. No futuro, a definição do endereço será dinâmica. Neste ponto do projeto, ainda não há relé para o controle do motor que será responsável por liberar a ração do dispenser.

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
- [ ] Adicionar checagem de alarme mais próximo
- [ ] Comprar relé e implementar sua lógica
- [ ] Comprar motor e fazer conexão com o relé
- [ ] Criar uma estrutura para o Cat Feeder


## Tecnologias
<div style="display: flex; ">
    <div style="display: inline-block; margin-right: 10px;">
        <img src="https://img.shields.io/badge/Arduino-00878F.svg?style=for-the-badge&logo=Arduino&logoColor=white" alt="Arduino" />
    </div>
    <div class="card h-100" data-clipboard-text="https://img.shields.io/badge/C++-00599C.svg?style=for-the-badge&amp;logo=C++&amp;logoColor=white" style="background-color: rgb(0, 89, 156); width: 70px; height:28px; display: inline-flex; justify-content: center; align-items: center;">
        <div class="img-badge" style="color: white; fill: white; text-align: center;">
            <div style="font: bold 10px Verdana; display: flex; align-items:center;">
                <svg role="img" viewBox="0 0 28 24" xmlns="http://www.w3.org/2000/svg" width="20" height="20"> 
                    <title>C++</title>
                    <path d="M22.394 6c-.167-.29-.398-.543-.652-.69L12.926.22c-.509-.294-1.34-.294-1.848 0L2.26 5.31c-.508.293-.923 1.013-.923 1.6v10.18c0 .294.104.62.271.91.167.29.398.543.652.69l8.816 5.09c.508.293 1.34.293 1.848 0l8.816-5.09c.254-.147.485-.4.652-.69.167-.29.27-.616.27-.91V6.91c.003-.294-.1-.62-.268-.91zM12 19.11c-3.92 0-7.109-3.19-7.109-7.11 0-3.92 3.19-7.11 7.11-7.11a7.133 7.133 0 016.156 3.553l-3.076 1.78a3.567 3.567 0 00-3.08-1.78A3.56 3.56 0 008.444 12 3.56 3.56 0 0012 15.555a3.57 3.57 0 003.08-1.778l3.078 1.78A7.135 7.135 0 0112 19.11zm7.11-6.715h-.79v.79h-.79v-.79h-.79v-.79h.79v-.79h.79v.79h.79zm2.962 0h-.79v.79h-.79v-.79h-.79v-.79h.79v-.79h.79v.79h.79z"></path>
                </svg>
                <span style="padding: 5px;">C++</span>
            </div>
        </div>
    </div>
</div>


## Bibliotecas
- [LiquidCrystal_I2C](https://gitlab.com/tandembyte/LCD_I2C)
- [RTClib](https://github.com/adafruit/RTClib)



## Licença


## Autor
| <img src="https://avatars.githubusercontent.com/mightbehappyy" width="100px;" alt="Mightbehappy"/><br /><sub></sub></a><br/> |
|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| [Mightbehappyy](https://github.com/mightbehappyy)                                                                                                     |