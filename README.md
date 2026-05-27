# Medita em Paz

## Sobre o projeto

Este repositório contém um projeto base em Flutter para uma atividade prática de desenvolvimento mobile com foco em animações de interface.

O aplicativo simula uma plataforma de meditação guiada, onde o objetivo principal não é apenas o funcionamento das telas, mas a melhoria da experiência do usuário por meio de animações e transições suaves.

## Objetivo da atividade

O objetivo desta atividade é praticar conceitos de:

- Animações em Flutter
- Transições entre telas
- Feedback visual de interação do usuário
- Organização de código com separação de responsabilidades (SoC)
- Melhoria de experiência de usuário (UX)

Ao final, o aluno deverá transformar uma interface funcional básica em uma experiência mais fluida e agradável.

## Estrutura do projeto

```text
lib/
├── screens/
│ ├── home_screen.dart
│ ├── meditation_screen.dart
│
├── widgets/
│ ├── start_button.dart
│ ├── fade_intro_text.dart
│ ├── animated_menu_icon.dart
│
├── animations/
│ ├── page_transitions.dart
├── main.dart
```

## Requisitos

Antes de executar o projeto, certifique-se de ter instalado:

- Flutter SDK
- Dart SDK
- Um navegador compatível (Chrome recomendado)

Para verificar a instalação do Flutter:

```bash
flutter doctor
```

## Como executar o projeto

1. Clonar o repositório

```bash
git clone <URL_DO_REPOSITORIO>
```

2. Acessar a pasta do projeto

```bash
cd medita-em-paz
```

3. Instalar dependências

```bash
flutter pub get
```

4. Executar no Chrome

```bash
flutter run -d chrome
```

## O que deve ser desenvolvido

Durante a atividade, você deverá implementar melhorias na interface do aplicativo, incluindo:

- Animação de transição entre telas
- Animação no botão de iniciar meditação
- Efeito de fade-in no texto introdutório
- Animação bounce nos ícones do menu

O foco está na experiência do usuário e na fluidez da interface.

## Regras gerais

- Não alterar a estrutura de pastas do projeto
- Manter o código organizado e legível
- Utilizar widgets separados sempre que possível
- Evitar centralizar toda a lógica em um único arquivo
- Priorizar fluidez e consistência visual

## Sugestões de estudo

Recomenda-se consultar a documentação oficial do Flutter sobre animações:

[Documentação do Flutter](https://docs.flutter.dev/ui/animations)

Tópicos importantes:

- AnimatedOpacity
- AnimatedScale
- AnimationController
- PageRouteBuilder
- Curves

## Entrega

Seguir as orientações do roteiro de atividade prática fornecido pelo professor.
