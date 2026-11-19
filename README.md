
# AlertaBairro
### Inteligência territorial para prevenção de alagamentos

## Sobre o projeto

O AlertaBairro é um aplicativo desenvolvido como parte do projeto acadêmico Global Solution 2026.2 da FIAP.

A proposta é utilizar inteligência territorial para auxiliar no monitoramento de bairros e na identificação de situações que podem contribuir para alagamentos urbanos.

A plataforma reúne indicadores de precipitação, registros de ocorrências, análise demonstrativa de riscos e informações sobre possíveis impactos sociais.

O objetivo é apoiar a identificação de áreas que merecem atenção, contribuindo para o planejamento e a tomada de decisões por pessoas responsáveis.

## Problema

Alagamentos urbanos podem comprometer a mobilidade, danificar residências, interromper serviços e colocar vidas em risco.

A ausência de informações organizadas sobre as condições dos bairros pode dificultar a identificação de regiões que necessitam de maior atenção.

O AlertaBairro propõe uma plataforma de monitoramento territorial que organiza informações e apresenta indicadores para apoiar ações preventivas.

## Público-alvo

- Gestores públicos e equipes de planejamento urbano.
- Defesa Civil e equipes de monitoramento.
- Profissionais envolvidos na gestão territorial.
- Comunidades interessadas nas condições de seus bairros.

## Funcionalidades

- **Visão geral:** apresenta indicadores da cidade, situação dos bairros e registros recentes.
- **Monitoramento de chuvas:** apresenta volume acumulado, histórico de precipitação e estimativas para as próximas horas.
- **Ocorrências:** organiza os registros por bairro e apresenta sua distribuição territorial.
- **Impacto social:** apresenta indicadores demonstrativos relacionados às ocorrências e aos possíveis benefícios de ações preventivas.
- **Central de alertas:** identifica bairros que merecem atenção com base nos registros disponíveis, apresentando evidências, nível de confiança e limitações.
- **Registro de ocorrências:** permite informar bairro, tipo de ocorrência, descrição e ponto de referência.

## Dados e metodologia

O protótipo utiliza dados sintéticos para demonstrar o funcionamento da plataforma.

As informações de precipitação, histórico e previsão são fornecidas por um serviço simulado. Os registros de ocorrências podem ser inseridos pelo usuário e ficam armazenados localmente no dispositivo.

### Geração de alertas

A classificação demonstrativa considera a quantidade de ocorrências registradas em cada bairro:

| Registros | Classificação |
|---|---|
| Nenhum | Sem registros |
| 1 ocorrência | Atenção moderada |
| 2 ou mais | Atenção elevada |

A confiança da análise é considerada baixa, pois a quantidade de registros, isoladamente, não permite determinar a probabilidade real de alagamento.

Uma avaliação mais precisa exigiria dados meteorológicos reais, histórico de alagamentos, condições de drenagem, relevo e características de ocupação urbana.

Os alertas são instrumentos de apoio à análise. A decisão final deve permanecer sob responsabilidade humana.

## Indicadores de impacto social

A plataforma apresenta informações demonstrativas relacionadas à distribuição das ocorrências, aos bairros monitorados e ao potencial de benefício de ações preventivas.

Esses indicadores têm finalidade ilustrativa e não representam resultados comprovados de intervenções públicas.

## Privacidade e inclusão

O formulário de ocorrências orienta os usuários a não informar dados pessoais desnecessários.

Os registros são armazenados localmente no dispositivo por meio do SharedPreferences.

O protótipo utiliza informações sintéticas e não depende de dados pessoais reais para demonstrar suas funcionalidades.

A interface utiliza componentes visuais, textos explicativos e indicadores para facilitar a compreensão das informações.

## Tecnologias utilizadas

- **Flutter:** desenvolvimento da aplicação multiplataforma.
- **Dart:** linguagem de programação.
- **Material UI:** componentes e identidade visual.
- **Provider:** gerenciamento de estado compartilhado.
- **SharedPreferences:** persistência local de ocorrências.

## Estrutura do projeto

```text
lib/
├── main.dart
├── models/
│   └── occurrence.dart
├── screens/
│   ├── home_screen.dart
│   ├── rain_screen.dart
│   ├── occurrences_screen.dart
│   ├── impact_screen.dart
│   ├── alerts_screen.dart
│   ├── register_occurrence_screen.dart
│   └── main_screen.dart
├── services/
│   ├── occurrence_service.dart
│   └── rain_data_service.dart
└── theme/
    └── app_theme.dart
```

## Como executar

### Pré-requisitos

- Flutter SDK instalado.
- Dart SDK.
- Android Studio ou Visual Studio Code.
- Emulador Android ou dispositivo físico configurado.

### Instalação

Clone o repositório:

```bash
git clone 
```

Entre na pasta do projeto:

```bash
cd alerta_bairro
```

Instale as dependências:

```bash
flutter pub get
```

Execute o aplicativo:

```bash
flutter run
```

## Demonstração

Vídeo de apresentação do aplicativo:

[Inserir link do vídeo]

## Equipe

- Pedro Miranda: 562117
- Israel Karacsony: 563435
