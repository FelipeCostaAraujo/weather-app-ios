# Weather App
## Curso Desenvolvendo um Aplicativo do Tempo para iOS

- _Aulas ministradas por [Attekita Dev](https://github.com/Bullas)_
- _Desenvolvido por [Felipe C. Araujo](https://github.com/FelipeCostaAraujo)_

## Descrição
O Weather App é uma aplicação iOS que fornece previsões meteorológicas em tempo real. Com uma interface construída em Swift e uma arquitetura robusta MVVM, o aplicativo oferece uma experiência de usuário refinada e desempenho confiável. Ele se integra com a OpenWeatherMap API para fornecer dados meteorológicos precisos com base na localização do usuário, obtida através do CoreLocation.

## Funcionalidades
- Mostra condições meteorológicas atuais e previsões para as próximas horas e dias.
- Apresenta informações detalhadas como velocidade do vento e umidade.
- Utiliza a localização do usuário para fornecer dados personalizados e relevantes.
- Trata diversos cenários de erros de rede, garantindo uma boa experiência de usuário mesmo sob condições adversas.

## Tecnologias Utilizadas
- UIKit
- Combine para a programação reativa
- Padrão MVVM para a arquitetura de software
- API OpenWeatherMap para dados meteorológicos
- CoreLocation para serviços de geolocalização

## Configuração do Projeto
Para configurar este projeto em sua máquina local, siga os passos abaixo:

```bash
git clone https://github.com/FelipeCostaAraujo/weather-app-ios.git
cd weather-app
open WeatherApp.xcodeproj
```

## Uso do CLLocationManager
Este aplicativo utiliza o `CLLocationManager` para obter a localização atual do usuário. Isso é feito de forma responsiva e eficiente, parando as atualizações de localização assim que uma localização precisa é obtida. As permissões de localização são solicitadas ao usuário, e a aplicação reage adequadamente às respostas.

O `CLLocationManager` é encapsulado dentro de um `Publisher` personalizado, seguindo o paradigma Combine, para que as atualizações de localização sejam emitidas como eventos que o ViewModel pode assinar e reagir.

## Como Contribuir
Contribuições são bem-vindas! Se você tem uma ideia ou sugestão de melhoria, siga estes passos:

- Faça um fork do repositório.
- Crie uma nova branch com o nome da sua funcionalidade (`git checkout -b feature/minha-nova-funcionalidade`).
- Faça commit das suas alterações (`git commit -am 'Adiciona nova funcionalidade'`).
- Faça push para a branch (`git push origin feature/minha-nova-funcionalidade`).
- Abra um Pull Request.

## Licença
- Este projeto está licenciado sob a MIT License. Para mais informações, consulte o arquivo LICENSE no repositório.