<div align="center">

# Parcel Shift

**Entregue encomendas que mudam de tamanho, peso e física no meio do caminho.**

![Roblox](https://img.shields.io/badge/Roblox-jogo-00A2FF?logo=roblox&logoColor=white)
![Luau](https://img.shields.io/badge/Luau-linguagem-00A2FF?logo=lua&logoColor=white)
![Rojo](https://img.shields.io/badge/Rojo-sincroniza%C3%A7%C3%A3o-FF6B6B)
[![Licença: MIT](https://img.shields.io/badge/licen%C3%A7a-MIT-blue.svg)](./LICENSE)

</div>

---

## 📖 Sobre

**Parcel Shift** é um jogo co-op de entrega para o Roblox. O servidor constrói uma rota, um quiosque de retirada, três portões de mutação e um depósito. O jogador pega uma encomenda, atravessa os portões e adapta sua movimentação conforme o pacote muda — gigante, minúsculo, quicante ou flutuante — até entregá-lo e receber uma nota de percurso.

O diferencial é que a encomenda muda suas regras físicas **durante o trajeto**, e não por rolagem aleatória ou compra. Cada portão transforma o pacote de forma visível, e a rota pede que o jogador reaja à nova condição. Um amigo pode tornar a corrida melhor abrindo atalhos, acionando interruptores de rota ou **estabilizando** a encomenda de um companheiro.

O jogo foi pensado para quem gosta de desafios curtos de obstáculo, de colecionar variantes cosméticas e de jogar com amigos, com a meta de funcionar também solo e em telas de toque. O público-alvo são jogadores do Roblox que buscam uma sessão inicial satisfatória e repetível.

O posicionamento é o de um **desafio cooperativo de físico de entrega com coleção e domínio de rota**, e não de um simulador de armazém ou de uma economia de roubo. O espaço ocupado por esse formato no Roblox é o de entregas/armazém, e o Parcel Shift propõe uma abordagem diferente: a encomenda que muda de comportamento a cada portão.

## ✨ Funcionalidades

- Rota gerada inteiramente pelo servidor: praça inicial, pista, duas barreiras de faixa alternadas, quiosque de retirada e depósito.
- Três portões de mutação — `SIZE SHIFT`, `MOTION SHIFT` e `WILD SHIFT` — com volume de toque próprio no servidor.
- Quatro mutações de encomenda: `GIANT`, `TINY`, `BOUNCY` e `FLOATY`, alterando dimensões e movimentação do jogador.
- Turnos de 120 s (`ShiftDuration`) com pausa de 12 s (`BreakDuration`) controlados por um relógio no servidor.
- Retirada e entrega por `ProximityPrompt` (funciona em toque, teclado e gamepad, sem depender de hover).
- Pontuação com nota por entrega (`A`/`B`/`C`), bônus de combo, bônus por rota completa e bônus por estabilização de colegas.
- `leaderstats` por sessão com `Deliveries`, `RouteScore` e `BestCombo`.
- Ação opcional de **estabilizar a encomenda de um colega**, com cooldown e bônus limitado.
- Livro de selos de mutação (journal) que conta os tipos únicos encontrados na sessão.
- HUD responsivo com cronômetro, progresso dos três portões, livro de selos e toasts animados.
- Autoridade total no servidor: posse da encomenda, estado do turno, distância, contagem de portões, recompensa e cooldown de entrega são validados antes de pontuar.

## 🛠️ Tecnologias

![Roblox Studio](https://img.shields.io/badge/Roblox%20Studio-experi%C3%AAncia-00A2FF?logo=roblox&logoColor=white)
![Luau](https://img.shields.io/badge/Luau-scripts-00A2FF?logo=lua&logoColor=white)
![Rojo](https://img.shields.io/badge/Rojo-default.project.json-FF6B6B)

## 📁 Estrutura do projeto

```
ParcelShift/
├── default.project.json          # mapeamento Rojo da árvore do DataModel
├── GAME_DESIGN_BRIEF.md          # pesquisa de mercado e design do jogo
├── TECHNICAL_DESIGN.md           # arquitetura, validação e critérios de aceite
└── src/
    ├── shared/ReplicatedStorage/
    │   └── GameConfig.luau               # ModuleScript de tuning e mutações
    ├── server/ServerScriptService/
    │   └── GameServer.server.luau        # mundo, relógio, prompts, score autoritativo
    └── client/StarterPlayerScripts/
        └── GameClient.client.luau        # HUD (não decide recompensa)
```

## 🚀 Como rodar

O projeto usa **Rojo** para sincronizar `src/` com uma instância do Roblox Studio.

```bash
# 1. Instale o Rojo (por exemplo com Aftman/Rokit) e o plugin Rojo no Roblox Studio.

# 2. Na raiz do projeto, suba o servidor de sincronização:
rojo serve default.project.json

# 3. No Roblox Studio, abra o plugin Rojo e clique em Connect.

# (opcional) gerar um arquivo de build:
rojo build default.project.json -o ParcelShift.rbxlx
```

> Observação dos docs técnicos: este workspace não tem Roblox Studio nem Rojo instalados, então os critérios de aceite exigem um playtest real de servidor/cliente no Studio antes da publicação.

## ⚙️ Configuração

`src/shared/ReplicatedStorage/GameConfig.luau` (chaves de tuning — apenas os nomes):

- Mecânica de turno: `ShiftDuration`, `BreakDuration`.
- Rota: `GateCount`, `RouteSpacing`, `DepotPosition`, `PickupPosition`, `PromptDistance`.
- Pontuação: `BaseDeliveryScore`, `AssistScore`, `AssistCooldown`, `ComboWindow`, `MaxComboBonus`, `GradeRewards`.
- Dados: `Gates` (nome, dica e cor de cada portão) e `Mutations` (id, rótulo, descrição, cor, tamanho, multiplicadores de velocidade e pulo).

`default.project.json` mapeia:

- `ReplicatedStorage` → `src/shared/ReplicatedStorage`
- `ServerScriptService` → `src/server/ServerScriptService`
- `StarterPlayer.StarterPlayerScripts` → `src/client/StarterPlayerScripts`

Comunicação servidor→cliente: `RemoteEvent` `ParcelShiftEvent` (criado pelo servidor em `ReplicatedStorage`).

## 📄 Licença

Distribuído sob a **Licença MIT**. Veja [`LICENSE`](./LICENSE).
