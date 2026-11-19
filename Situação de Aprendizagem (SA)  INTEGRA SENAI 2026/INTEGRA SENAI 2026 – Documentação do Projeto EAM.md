# Sistema de Gestão de Manutenção e Chamados Internos (EAM)

**Curso:** Aperfeiçoamento Profissional – Programação em Inteligência Artificial Generativa  
**Unidade Curricular:** Desenvolvimento de Soluções Web com Inteligência Artificial Generativa (Projeto Integrador)  
**Categoria:** INTEGRA Soluções Industriais — INTEGRA SENAI 2026  
**Situação de Aprendizagem:** SA 01 – Fábrica de Softwares (MVP Web Auditado)  
**Equipe:** Davi Martins, Carolline Maia, Alice Ortega, Ana Luiza Dore  
**Data de Entrega:** 19/11/2026  

---

## 1. Diagnóstico do Problema (Entrega 2 · Critério C1 – 20%)

### 1.1 Contexto Operacional
A empresa parceira do setor produtivo (acompanhada pelo Embaixador de Negócios do SENAI) possui aproximadamente **185 colaboradores** distribuídos em quatro áreas operacionais principais: **Produção/Oficina (Manutenção)**, **Refeitório/Cozinha (Zeladoria)**, **Portaria/Guarita (Vigilância)** e **Administração**. Atualmente, o registro e o encaminhamento de cerca de **65 ocorrências semanais** ocorrem de forma informal em grupos de WhatsApp, sem protocolo único, sem fila estruturada, sem definição de responsável e sem métricas de tempo de atendimento.

### 1.2 Declaração do Problema
Os setores operacionais da empresa parceira não conseguem registrar, direcionar e acompanhar chamados internos com rastreabilidade e governança, o que gera perda de histórico, duplicidade de atendimentos, atrasos críticos em situações de risco à segurança do trabalho e exposição indevida de dados pessoais dos colaboradores.

### 1.3 Matriz de Sintomas, Causas e Consequências

| Sintoma Observado | Causa Raiz | Consequência Operacional |
| :--- | :--- | :--- |
| Perda de histórico das ocorrências | Mensagens dispersas se misturam no fluxo contínuo do WhatsApp | Impossibilidade de comprovar o que foi solicitado, executado e quando |
| Chamados duplicados e retrabalho | Inexistência de consulta ou alerta de chamados abertos no mesmo local | Desperdício de horas técnicas e deslocamento desnecessário das equipes |
| Falta de clareza sobre quem atende | Ausência de roteamento por categoria e atribuição formal de dono | Ocorrências ficam paradas sem responsável definido |
| Ausência de indicadores (TMA/TMR) | Falta de registro estruturado de abertura, início e conclusão | Gestão toma decisões sem dados reais de gargalos por setor |
| Demora em incidentes de risco | Alertas críticos se perdem entre mensagens rotineiras | Aumento do risco de acidentes e paradas não planejadas |
| Exposição de dados pessoais | Nomes completos, telefones e fotos circulam em grupos abertos | Risco de não conformidade com a Lei Geral de Proteção de Dados (LGPD) |

### 1.4 Mapeamento de Partes Interessadas (Stakeholders)

| Perfil | Papel no Fluxo | Principal Dor |
| :--- | :--- | :--- |
| **Solicitante (Colaborador)** | Abre o chamado operacional | Não recebe protocolo nem sabe se/quando o problema será resolvido |
| **Zeladoria / Cozinha** | Atende demandas de limpeza, copa e conservação | Recebe pedidos informais sem ordem de chegada ou local exato |
| **Vigilância / Guarita** | Atende controle de acesso, perímetro e segurança | Dificuldade em destacar ocorrências de risco imediato |
| **Manutenção / Oficina** | Executa reparos prediais, elétricos e mecânicos | Atende pedidos duplicados e sem histórico de falhas anteriores |
| **Gestor / Administração** | Monitora SLAs, direciona equipes e analisa indicadores | Falta de visibilidade consolidada, trilha de auditoria e métricas TMA/TMR |
| **Embaixador de Negócios** | Valida escopo e aderência ao contexto real (consultivo) | Garantir solução simples, sem custo de hardware e aderente à LGPD |

### 1.5 Delimitação de Escopo da Versão 1 (v1)
* **Dentro do Escopo (v1):** Abertura rápida de chamados (< 60s) com protocolo automático (`#EAM-NNNN`); detecção preventiva de duplicidade por local e categoria; direcionamento automático para painéis setoriais (Cozinha, Guarita e Oficina); alerta visual crítico em vermelho piscante para `Situação de Risco` em todos os painéis; ocultação de dados pessoais nos painéis públicos (LGPD); painel gerencial com filtros, indicadores (TMA, TMR, setor mais demandado) e log de auditoria obrigatório em toda mudança de status.
* **Fora do Escopo (v1):** Dependência ou integração com WhatsApp; aplicativos móveis nativos (Android/iOS); aquisição de sensores IoT ou hardware dedicado; módulos financeiros, compras ou gestão patrimonial complexa; substituição dos canais oficiais de socorro e emergência (190, 192, 193).

### 1.6 Indicadores de Sucesso (KPIs)

| Indicador | Fórmula / Forma de Medição | Situação Atual (Linha de Base) | Meta Proposta (MVP v1) |
| :--- | :--- | :--- | :--- |
| **TMA (Tempo Médio de Atendimento)** | Média de `(data_inicio_atendimento - data_abertura)` | Não mensurado (estimado > 45 min) | Medição automática em 100% dos chamados |
| **TMR (Tempo Médio de Resolução)** | Média de `(data_conclusao - data_abertura)` | Não mensurado (estimado > 4 horas) | Medição automática em 100% dos chamados |
| **Taxa de Duplicidade** | `(Chamados duplicados evitados ÷ Total de tentativas)` | ~22% de retrabalho semanal | Redução mínima de 50% via alerta preventivo |
| **Rastreabilidade de Dono e Status** | `% de chamados com status válido e responsável atribuído` | 0% formalizado | 100% dos chamados rastreados |
| **Conformidade de Auditoria** | `% de mudanças de status com log (quem, quando, motivo)` | 0% | 100% auditado |
| **Tempo de Abertura de Chamado** | Cronometragem de usabilidade com usuário final | ~2 min (digitando e explicando no grupo) | Até 60 segundos |

### 1.7 Evidências Anexadas no Portfólio
- [x] Fluxograma comparativo: Cenário Atual (WhatsApp) × Cenário Futuro (Sistema Web EAM)
- [x] Termo de validação consultiva do Embaixador de Negócios
- [x] Planilha anonimizada de levantamento de volume semanal de ocorrências
- [x] Matriz de rastreabilidade de requisitos e regras de negócio

---

## 2. Pesquisa com Usuários e Stakeholders (Entrega 3 · Critério C2 – 15%)

### 2.1 Roteiro de Entrevista Semiestruturada (10 a 15 min)
1. Qual é a sua função e com que frequência você abre ou atende chamados internos?
2. Como você procede hoje quando precisa solicitar ou atender uma ocorrência? Relate o último caso.
3. Quais são os principais gargalos ou falhas nesse fluxo atual?
4. Já houve casos de chamados perdidos, duplicados ou sem retorno? Qual foi o impacto?
5. Como você acompanha se um pedido foi concluído e quanto tempo levou?
6. Como são comunicadas as situações de risco hoje e qual a velocidade de resposta?
7. Há preocupação com a exposição de nomes, contatos ou fotos nos grupos atuais?
8. O que é indispensável na nova tela para que a equipe adote o sistema no dia a dia?

### 2.2 Registro Consolidado das Entrevistas (Anonimizado – LGPD)

| Código | Perfil Entrevistado | Data | Formato | Síntese dos Achados e Falas-Chave |
| :--- | :--- | :--- | :--- | :--- |
| **E1** | Solicitante (Operador de Produção) | 10/11/2026 | Presencial (12 min) | *"A gente manda mensagem no grupo e não sabe se alguém viu. Às vezes três pessoas mandam a mesma foto de um vazamento no corredor."* |
| **E2** | Atendente (Técnico de Manutenção / Oficina) | 10/11/2026 | Presencial (15 min) | *"Quando chego no local, outro técnico já resolveu porque não tinha ninguém marcado como responsável. Preciso bater o olho na tela da oficina e ver o que é urgente."* |
| **E3** | Atendente (Líder de Zeladoria / Cozinha) | 11/11/2026 | Presencial (10 min) | *"Não precisamos de computador complexo na copa, só de um monitor ou tablet mostrando o local e o serviço sem poluição na tela."* |
| **E4** | Atendente (Vigilante / Guarita) | 11/11/2026 | Presencial (12 min) | *"Se houver portão travado, vazamento químico ou princípio de risco, tem que piscar na hora na guarita para acionarmos a brigada e a segurança."* |
| **E5** | Gestor (Coordenador Administrativo) | 12/11/2026 | Online (15 min) | *"Hoje não consigo apresentar um relatório mensal de TMA ou TMR. Também preciso saber quem cancelou ou alterou um chamado e o motivo."* |
| **E6** | Embaixador de Negócios (Empresa Parceira) | 12/11/2026 | Online (15 min) | *"A solução precisa rodar direto no navegador dos monitores e tablets que já temos, sem instalar app e sem expor dados pessoais nas telas públicas."* |

### 2.3 Mapa de Empatia Consolidado

| Quadrante | Solicitante | Atendente Setorial | Gestor Administrativo |
| :--- | :--- | :--- | :--- |
| **Pensa e Sente** | Insegurança por não saber se o pedido foi recebido; frustração com demora | Sobrecarga com pedidos desordenados e medo de deixar passar um risco | Falta de controle gerencial e preocupação com passivos de segurança/LGPD |
| **Vê** | Mensagens subindo rápido no grupo sem resposta | Chamados repetidos para o mesmo local e falta de prioridade clara | Reclamações entre setores sem histórico documentado |
| **Ouve** | *"Manda no grupo de novo que ninguém viu"* | *"Achei que o outro turno já tinha ido lá"* | *"Precisamos reduzir o tempo de parada e ter indicadores"* |
| **Fala e Faz** | Cobra no privado ou abre pedidos duplicados | Pergunta no grupo quem vai atender antes de se deslocar | Cobra status manualmente por telefone ou mensagens |
| **Dores** | Ausência de protocolo e de retorno visual | Falta de fila única, dono e alerta visual de risco | Ausência de TMA, TMR e trilha de auditoria |
| **Ganhos Esperados** | Registrar em menos de 1 minuto e receber protocolo | Tela limpa estilo painel/telão com prioridade automática | Painel consolidado com filtros, métricas e histórico auditado |

### 2.4 Matriz de Síntese: Dos Achados aos Requisitos

| Achado da Pesquisa | Insight de Produto | Requisito Resultante |
| :--- | :--- | :--- |
| Pedidos repetidos no mesmo local geram deslocamento duplo | Alertar no momento da abertura se já existe chamado ativo no mesmo local/categoria | **RF06** (Detecção preventiva de duplicidade) |
| Falta de dono faz chamados ficarem sem atendimento | Exigir atribuição de responsável e status rastreável em todo ciclo de vida | **RF02** e **RF04** (Roteamento e gestão de responsável) |
| Incidentes de risco se perdem no meio de pedidos comuns | Destacar `Situação de Risco` em vermelho piscante em todos os painéis setoriais | **RF06** (Triagem prioritária de risco) |
| Gestor não possui métricas de tempo nem histórico de alterações | Calcular TMA/TMR automaticamente e exigir justificativa em mudanças de status | **RF04** e **RF05** (Indicadores e log auditado) |
| Exposição de nomes completos e telefones nos grupos | Exibir apenas iniciais do solicitante nos painéis operacionais públicos | **RNF01** (Privacidade e conformidade LGPD) |
| Formulários longos desencorajam o uso no chão de fábrica | Criar formulário enxuto com 6 campos essenciais e protocolo instantâneo | **RF01** (Abertura simplificada < 60s) |

---

## 3. Pesquisa de Anterioridade e Benchmarking (Entrega 4 · Critério C3)

| Solução Analisada | Categoria | Pontos Fortes | Lacunas para o Contexto Industrial v1 |
| :--- | :--- | :--- | :--- |
| **WhatsApp (Cenário Atual)** | Mensageria instantânea | Alta familiaridade dos usuários; custo zero | Sem protocolo, sem fila, sem dono, sem métricas TMA/TMR e vulnerável à LGPD |
| **GLPI** | Service Desk Open Source | Gestão completa de tickets, inventário e categorias | Exige servidor dedicado, configuração complexa e interface densa para telões de parede |
| **Jira Service Management** | ITSM Comercial | Fluxos avançados, SLAs e automações robustas | Custo de licenciamento por agente e curva de aprendizado alta para operação fabril |
| **Fracttal / UpKeep** | EAM / CMMS Comercial | Controle de ativos, planos preventivos e ordens de serviço | Complexidade excessiva (financeiro/ativos) vedada na v1; custo elevado |
| **Tractian** | Manutenção Preditiva IoT | Monitoramento de máquinas com sensores em tempo real | Exige aquisição de hardware/sensores; não cobre zeladoria, copa e guarita |
| **EAM Web MVP (Nossa Solução)** | Sistema Web Operacional Leve | Abertura em < 60s, telões setoriais sem dados pessoais, alerta global de risco, auditoria obrigatória e zero custo de hardware | Focado especificamente na operação v1 (sem módulos financeiros ou ativos complexos) |

**Diferencial Competitivo do MVP:** Combina a simplicidade de abertura de um formulário web leve com painéis operacionais em modo *Kiosk/Telão* (atualização automática a cada 5s), conformidade nativa com a LGPD (anonimização por iniciais nos painéis públicos) e governança auditável em cada transição de status.

---

## 4. Proposta de Valor e Lean Canvas (Entrega 5 · Critério C3 – 15%)

### 4.1 Declaração de Proposta de Valor
> Para colaboradores, equipes operacionais (Manutenção, Zeladoria e Vigilância) e gestores da empresa parceira que sofrem com chamados perdidos e retrabalho no WhatsApp, o **Sistema Web EAM** é uma plataforma leve e responsiva que centraliza a abertura com protocolo automático, direciona demandas para painéis setoriais protegidos pela LGPD e garante rastreabilidade completa com indicadores TMA/TMR em tempo real, sem exigir aplicativos nativos ou novo hardware.

### 4.2 Lean Canvas

| Bloco | Definição Estratégica |
| :--- | :--- |
| **1. Problema** | • Perda de histórico e falta de protocolo no WhatsApp<br>• Chamados duplicados e sem responsável definido<br>• Demora crítica em situações de risco e exposição de dados pessoais (LGPD) |
| **2. Segmento de Clientes** | • Indústrias, plantas operacionais e centros logísticos com equipes internas de manutenção, zeladoria e vigilância (Early Adopter: Empresa Parceira SENAI) |
| **3. Proposta de Valor Única** | Chamados internos rastreáveis, direcionados automaticamente e auditados, abertos em menos de 60 segundos direto no navegador |
| **4. Solução** | • Tela de abertura rápida com protocolo `#EAM-NNNN` e alerta de duplicidade<br>• Painéis setoriais em modo telão (Cozinha, Guarita, Oficina) com alerta global de risco<br>• Painel administrativo com filtros, métricas TMA/TMR e log de auditoria |
| **5. Canais** | • Validação com Embaixador de Negócios<br>• Acesso via navegador web em monitores de parede, tablets setoriais e desktops |
| **6. Fontes de Receita** | • v1: Projeto acadêmico/piloto sem custo para empresa parceira<br>• Evolução futura (SaaS B2B): assinatura mensal por planta operacional |
| **7. Estrutura de Custos** | • Horas de engenharia de software da equipe<br>• Hospedagem web leve / banco SQLite (custo próximo a zero em infraestrutura local) |
| **8. Métricas-Chave** | • TMA (Tempo Médio de Atendimento) e TMR (Tempo Médio de Resolução)<br>• Redução de chamados duplicados (≥ 50%) e 100% de chamados com dono/auditoria |
| **9. Vantagem Competitiva** | • Zero dependência de hardware novo, privacidade por padrão (LGPD) nos painéis públicos e aderência exata ao fluxo operacional validado em campo |

---

## 5. Planejamento Técnico e Arquitetura (Entrega 6 – Parte A · C4/C5)

### 5.1 Requisitos Funcionais (RF)

| Código | Nome | Especificação Funcional |
| :--- | :--- | :--- |
| **RF01** | Abertura Simplificada com Protocolo | Permitir abertura rápida com Solicitante, Categoria (`Manutenção`, `Zeladoria`, `Vigilância`, `Risco`), Local/Ambiente, Descrição, Prioridade (`Baixa`, `Média`, `Alta`, `Urgente/Risco`) e anexo simulado de foto, gerando protocolo único (`#EAM-1001`). |
| **RF02** | Roteamento Inteligente por Categoria | Direcionar automaticamente chamados de `Manutenção` para a Oficina, `Zeladoria` para a Cozinha, `Vigilância` para a Guarita e `Risco` para todos os painéis simultaneamente. |
| **RF03** | Painéis Setoriais (Modo Telão/Kiosk) | Exibir cartões operacionais contendo Protocolo, Categoria, Local, Descrição resumida, Iniciais do solicitante, Tempo decorrido em minutos e Status atual. |
| **RF04** | Painel Administrativo Consolidado | Disponibilizar tabela gerencial com filtros por setor, status (`Aberto`, `Em Atendimento`, `Concluído`, `Cancelado`) e prioridade, permitindo atribuir responsável, redirecionar setor, alterar status e visualizar TMA, TMR e setor mais demandado. |
| **RF05** | Histórico Auditado Obrigatório | Registrar log imutável a cada mudança de status ou setor contendo: usuário responsável pela ação, data/hora, status anterior, novo status e justificativa obrigatória. |
| **RF06** | Alertas Críticos e Prevenção | Exibir destaque em vermelho piscante para `Situação de Risco`, emitir aviso preventivo caso já exista chamado aberto no mesmo local/categoria e manter aviso permanente de que o sistema não substitui canais oficiais de emergência (190/192/193). |

### 5.2 Requisitos Não Funcionais (RNF)

| Código | Categoria | Especificação Não Funcional |
| :--- | :--- | :--- |
| **RNF01** | Privacidade e LGPD | Ocultar nome completo, telefone, matrícula ou qualquer dado pessoal sensível nos painéis públicos setoriais (Cozinha, Guarita e Oficina), exibindo apenas iniciais (ex.: `M. S.`). |
| **RNF02** | Compatibilidade e Responsividade | Operar 100% via navegador web moderno (desktop, tablet e monitor de parede) sem instalação de apps nativos, utilizando HTML5 semântico, CSS3 responsivo (Grid/Flexbox) e Vanilla JavaScript. |
| **RNF03** | Atualização em Tempo Real e Clean Code | Atualizar painéis e contadores de tempo automaticamente a cada 5 segundos sem recarregar a página, mantendo código modular em `pt-BR` com funções de no máximo 20 linhas e sanitização contra XSS. |

### 5.3 Modelagem Relacional de Dados (SQLite)

```sql
CREATE TABLE SETOR (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL UNIQUE,
    painel_destino TEXT NOT NULL
);

CREATE TABLE USUARIO (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    perfil TEXT NOT NULL CHECK (perfil IN ('Solicitante', 'Operador', 'Gestor')),
    setor_id INTEGER,
    FOREIGN KEY (setor_id) REFERENCES SETOR(id)
);

CREATE TABLE CHAMADO (
    protocolo TEXT PRIMARY KEY,
    solicitante TEXT NOT NULL,
    categoria TEXT NOT NULL CHECK (categoria IN ('Manutenção', 'Zeladoria', 'Vigilância', 'Risco')),
    setor_id INTEGER NOT NULL,
    localizacao TEXT NOT NULL,
    descricao TEXT NOT NULL,
    prioridade TEXT NOT NULL CHECK (prioridade IN ('Baixa', 'Média', 'Alta', 'Urgente/Risco')),
    status TEXT NOT NULL DEFAULT 'Aberto' CHECK (status IN ('Aberto', 'Em Atendimento', 'Concluído', 'Cancelado')),
    responsavel TEXT NOT NULL DEFAULT 'Aguardando Triagem',
    data_abertura DATETIME NOT NULL,
    data_inicio DATETIME,
    data_conclusao DATETIME,
    foto_url TEXT,
    FOREIGN KEY (setor_id) REFERENCES SETOR(id)
);

CREATE TABLE HISTORICO (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    protocolo_chamado TEXT NOT NULL,
    status_anterior TEXT NOT NULL,
    novo_status TEXT NOT NULL,
    usuario_responsavel TEXT NOT NULL,
    data_hora DATETIME NOT NULL,
    observacao TEXT NOT NULL,
    FOREIGN KEY (protocolo_chamado) REFERENCES CHAMADO(protocolo)
);
```

### 5.4 Governança e Ambiente Assistido por IA (VS Code + GitHub Copilot)
Para manter a blindagem arquitetural e a rastreabilidade exigidas na Fase 2, o ambiente foi configurado no **VS Code com GitHub Copilot (modo Agent)** espelhando integralmente as regras de governança da Situação de Aprendizagem:

| Arquivo de Governança | Finalidade Técnica | Equivalência na SA |
| :--- | :--- | :--- |
| `.github/copilot-instructions.md` | Define regras permanentes: idioma 100% `pt-BR`, Clean Code/SOLID, limite de 20 linhas por função, separação entre regras de negócio e DOM, stack HTML5/CSS3/JS puro, sanitização XSS e privacidade LGPD. | `.antigravityrules` |
| `.vscode/mcp.json` | Configura os servidores MCP `database` (`@modelcontextprotocol/server-sqlite` em `./src/database/eam.sqlite`) e `filesystem` (`@modelcontextprotocol/server-filesystem` em `./src`). | `.antigravity/config.json` |
| `.github/prompts/auditar.prompt.md` | Prompt reutilizável de auditoria técnica (`/auditar`) para inspeção de vulnerabilidades XSS, vazamento LGPD, teto de 20 linhas e confiabilidade operacional. | Skill `/auditar` |
| `.env.example` e `.gitignore` | Protegem variáveis de ambiente, chaves e arquivos de banco de dados locais (`.sqlite`, `.db`) contra versionamento acidental. | `.env.example` e `.gitignore` |

---

## 6. MVP Funcional e Bateria de Testes (Entrega 6 – Parte B · C4 – 20%)

### 6.1 Estrutura do Projeto
```text
eam-manutencao/
├── .github/
│   ├── copilot-instructions.md
│   └── prompts/
│       └── auditar.prompt.md
├── .vscode/
│   └── mcp.json
├── src/
│   ├── database/
│   │   └── schema.sql
│   ├── index.html
│   ├── style.css
│   └── app.js
├── .env.example
├── .gitignore
├── index.html
└── README.md
```

### 6.2 Como Executar
1. Abra o arquivo `src/index.html` (ou `index.html` na raiz) em qualquer navegador web moderno (Chrome, Edge, Firefox) ou via extensão *Live Server* no VS Code.
2. Navegue entre as abas **Abrir Chamado**, **Painéis Setoriais (Cozinha, Guarita, Oficina)** e **Gestão Administrativa**.

### 6.3 Resultados dos Testes Funcionais, de Segurança e Responsividade

| Caso de Teste | Cenário Executado | Resultado Esperado | Resultado Obtido | Status |
| :--- | :--- | :--- | :--- | :--- |
| **T1 – Abertura e Protocolo** | Preenchimento do formulário com dados válidos e envio | Gera protocolo único `#EAM-1005`, salva no repositório e exibe confirmação | Protocolo `#EAM-1005` gerado em < 1s e listado imediatamente | **Aprovado** |
| **T2 – Prevenção de XSS** | Inserção de `<script>alert('XSS')</script>` na descrição do chamado | Texto renderizado literalmente na tela sem execução de script | Payload exibido como texto seguro via `textContent`; zero execução | **Aprovado** |
| **T3 – Triagem de Risco** | Abertura de chamado com categoria `Risco` / prioridade `Urgente/Risco` | Cartão com borda/badge vermelho piscante exibido nos 3 painéis setoriais | Alerta vermelho piscante ativado simultaneamente na Cozinha, Guarita e Oficina | **Aprovado** |
| **T4 – Privacidade LGPD** | Visualização do solicitante `"Mariana Oliveira Costa"` nos painéis públicos | Exibição apenas das iniciais (`M. O. C.`) sem dados pessoais sensíveis | Painéis públicos exibiram apenas `M. O. C.`; nome completo restrito à Gestão | **Aprovado** |
| **T5 – Log de Auditoria** | Tentativa de concluir chamado no Painel do Gestor sem preencher justificativa | Sistema bloqueia alteração e exige responsável + motivo | Bloqueio validado; após preenchimento, gravou log com data/hora, autor e motivo | **Aprovado** |
| **T6 – Aviso de Duplicidade** | Abertura de segundo chamado aberto para `Manutenção` no mesmo local (`Galpão B`) | Exibição de alerta informando chamado ativo semelhante e pedindo confirmação | Alerta preventivo exibido com protocolo existente antes da confirmação | **Aprovado** |
| **T7 – Atualização Automática** | Abertura de chamado em uma aba com o painel setorial aberto | Novo cartão aparece e contador de minutos atualiza em até 5s sem *reload* | Sincronização automática executada a cada 5s mantendo estado da interface | **Aprovado** |
| **T8 – Responsividade Tablet** | Redimensionamento da viewport para `768px` (tablet) no painel da Guarita | Cartões organizados em CSS Grid/Flexbox sem quebra ou sobreposição de texto | Alinhamento fluido em 1-2 colunas sem sobreposição entre protocolo e timer | **Aprovado** |

---

## 7. Auditoria de IA Responsável e Segurança (Entrega 7 · Critério C7 – 5%)

Relatório consolidado após execução do prompt de auditoria (`.github/prompts/auditar.prompt.md`) sobre `index.html`, `style.css` e `app.js`:

| Pilar Auditado | Verificação Realizada | Não Conformidade Identificada na v0 | Correção Aplicada e Validada na v1 | Status Final |
| :--- | :--- | :--- | :--- | :--- |
| **1. Segurança contra Injeção (XSS)** | Inspeção de todas as renderizações de entradas do usuário no DOM | Uso inicial de template string com `innerHTML` na renderização da tabela administrativa | Substituição integral por criação segura de nós DOM (`document.createElement` + `textContent`) | **Conforme** |
| **2. Privacidade e LGPD** | Verificação dos dados expostos nos painéis Cozinha, Guarita e Oficina | Nome completo do solicitante aparecia no rodapé do cartão setorial | Criação da função `formatarIniciaisLGPD(nome)` exibindo somente iniciais nos painéis públicos | **Conforme** |
| **3. Clean Code e Governança** | Contagem de linhas por função, modularidade e idioma dos comentários | Função `renderizarPainelGestor` possuía 34 linhas e 2 variáveis em inglês | Refatoração em 3 subfunções especialistas (`<= 18` linhas cada) e padronização 100% em `pt-BR` | **Conforme** |
| **4. Confiabilidade Operacional** | Simulação de falha no `localStorage`, chamados simultâneos e casos de emergência | Falta de `try/catch` na persistência e ausência de aviso de emergência oficial | Inclusão de tratamento de exceções no storage, geração de ID sem colisão e banner fixo para 190/192/193 | **Conforme** |
| **5. Prevenção de Alucinação** | Revisão manual de imports, APIs e dependências | Nenhuma biblioteca externa ou API inexistente utilizada | 100% HTML5, CSS3 e Vanilla JS nativos auditados linha a linha | **Conforme** |

---

## 8. Registro Oficial de Uso Responsável de IA (Entrega 7 · Cap. 7 Art. 68 e Cap. 8 Art. 73)

| Data | Fase / Etapa | Ferramenta / Agente | Objetivo do Uso | Prompt Relevante Utilizado | Síntese da Saída Gerada | Critério de Validação Humana e Ajustes Realizados | Decisão Final |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 19/11/2026 | Fase 1 – Planejamento | GitHub Copilot (VS Code) | Estruturar RF01–RF06, RNF01–RNF03 e schema SQLite | *"Elabore RF01 a RF06, 3 RNFs e schema SQLite para o sistema EAM..."* | Gerou 6 RFs, 3 RNFs e 4 tabelas relacionais (`SETOR`, `USUARIO`, `CHAMADO`, `HISTORICO`). | Adicionamos os campos `responsavel` em `CHAMADO` e `observacao` em `HISTORICO` para atender às restrições de dono e motivo obrigatório. | **Adaptado** |
| 19/11/2026 | Fase 2 – Setup | GitHub Copilot (Agent Mode) | Criar governança do projeto e configuração MCP no VS Code | *"Configure .github/copilot-instructions.md, .vscode/mcp.json e prompt /auditar..."* | Gerou arquivos de regras em `pt-BR`, MCP SQLite/Filesystem, `.gitignore` e `.env.example`. | Validamos os caminhos relativos (`./src` e `./src/database/eam.sqlite`) e o limite máximo de 20 linhas por função. | **Utilizado com ajuste** |
| 19/11/2026 | Fase 3 – Build | GitHub Copilot (Agent Mode) | Desenvolver MVP em `index.html`, `style.css` e `app.js` | *"Desenvolva o protótipo web completo do EAM com 3 visões, modo telão, filtros e log..."* | Gerou interface completa com abas, modo escuro operacional, timers e persistência modular. | Testamos o fluxo ponta a ponta e ajustamos o alerta de duplicidade para comparar `localizacao` + `categoria` normalizados. | **Utilizado com ajuste** |
| 19/11/2026 | Fase 4 – Debugging | GitHub Copilot (Chat) | Corrigir quebra de layout em tablets e erro de histórico indefinido | *"Ajuste style.css com CSS Grid/Flexbox para tablets e inicialize array historico em atualizarStatusChamado"* | Refatorou cards para CSS Grid responsivo e adicionou guarda `chamado.historico = chamado.historico \|\| []`. | Validamos no DevTools (F12) em resolução `768px` e executamos 10 transições de status sem erros no console. | **Utilizado com correção** |
| 19/11/2026 | Fase 5 – Auditoria | GitHub Copilot (`/auditar`) | Auditar vulnerabilidades XSS, conformidade LGPD e teto de 20 linhas | *"Execute auditoria de segurança XSS, LGPD, Clean Code e confiabilidade..."* | Apontou `innerHTML` na tabela do gestor, nome completo nos painéis e 1 função com 34 linhas. | Substituímos `innerHTML` por `textContent`, aplicamos iniciais nos painéis públicos e quebramos a função longa em 3 funções curtas. | **Utilizado com correção** |

---

## 9. Demo Day: Roteiro de Pitch e Vídeo do Protótipo (Entrega 8 · Critério C6 – 10%)

### 9.1 Pitch Elevator (Duração Alvo: 2m45s · Limite Eliminatório: 3m00s)

| Tempo | Bloco Narrativo | Roteiro Falado (Síntese) |
| :--- | :--- | :--- |
| **0:00 – 0:20** | **Gancho de Impacto** | *"Imagine um vazamento elétrico ou portão travado na indústria sendo avisado num grupo de WhatsApp e desaparecendo em 2 minutos no meio de dezenas de mensagens. Na nossa empresa parceira, cerca de 65 ocorrências semanais corriam esse risco."* |
| **0:20 – 0:50** | **Problema e Evidências** | *"Entrevistamos solicitantes, equipes de manutenção, zeladoria, guarita e gestão. Identificamos 22% de retrabalho por chamados duplicados, ausência de responsáveis, falta de métricas TMA e TMR e exposição de dados pessoais nos grupos."* |
| **0:50 – 1:35** | **Demonstração da Solução** | *"Desenvolvemos o Sistema Web EAM. Em menos de 60 segundos, qualquer colaborador abre um chamado, recebe alerta caso já exista pedido igual no local e gera um protocolo único. O sistema roteia automaticamente para os telões da Cozinha, Guarita ou Oficina, e dispara alerta vermelho piscante em todos os painéis em situações de risco."* |
| **1:35 – 2:10** | **IA Responsável e Auditoria** | *"Construímos o MVP com IA Generativa sob regras rígidas de engenharia: código modular, auditoria contra ataques XSS, anonimização por iniciais nos painéis públicos conforme a LGPD e log obrigatório com autor e justificativa em toda mudança de status."* |
| **2:10 – 2:45** | **Impacto e Encerramento** | *"O sistema roda 100% no navegador, aproveitando os monitores e tablets que a empresa já possui, entregando TMA e TMR em tempo real e rastreabilidade total. Obrigado!"* |

### 9.2 Vídeo do Protótipo (Duração Alvo: 1m20s · Limite Eliminatório: 1m30s)

| Tempo | Cena Capturada em Tela | Narração / Legenda |
| :--- | :--- | :--- |
| **0:00 – 0:10** | Tela inicial do Sistema Web EAM (Identificação do projeto e equipe) | Apresentação do Sistema de Gestão de Manutenção e Chamados Internos (EAM). |
| **0:10 – 0:30** | Aba **Abrir Chamado**: preenchimento rápido, alerta de duplicidade e geração do protocolo `#EAM-1005` | Abertura em segundos com protocolo automático e prevenção de retrabalho. |
| **0:30 – 0:50** | Aba **Painéis Setoriais**: visão da Guarita e Oficina com iniciais (LGPD) e alerta vermelho piscante de `Risco` | Painéis em modo telão atualizados a cada 5 segundos com privacidade e prioridade crítica. |
| **0:50 – 1:10** | Aba **Gestão Administrativa**: filtros, indicadores TMA/TMR, alteração de status com motivo e timeline auditada | Controle gerencial completo com métricas em tempo real e histórico auditável. |
| **1:10 – 1:20** | Banner de segurança (canais oficiais 190/192/193) e encerramento | Solução 100% web, responsiva e auditada — INTEGRA SENAI 2026. |

---

## 10. Mapa de Entregas e Checklist Final (INTEGRA SENAI 2026)

| Entrega Obrigatória | Localização / Evidência | Critério Avaliado |
| :--- | :--- | :--- |
| **Entrega 1:** Plano de Ensino e Planos de Aula | Documentação Docente Validada | **C5** (15%) |
| **Entrega 2:** Diagnóstico do Problema | Seção 1 deste README | **C1** (20%) |
| **Entrega 3:** Pesquisa com Usuários e Stakeholders | Seção 2 deste README | **C2** (15%) |
| **Entrega 4:** Pesquisa de Anterioridade e Benchmarking | Seção 3 deste README | **C3** (15%) |
| **Entrega 5:** Proposta de Valor e Lean Canvas | Seção 4 deste README | **C3** (15%) |
| **Entrega 6:** Planejamento Técnico e MVP Funcional | Seções 5 e 6 + Código-fonte (`src/`) | **C4** (20%) e **C5** (15%) |
| **Entrega 7:** Auditoria Técnica e Registro de Uso de IA | Seções 7 e 8 deste README | **C7** (5%) |
| **Entrega 8:** Demo Day (Vídeos ≤ 1m30s / ≤ 3min e Portfólio) | Seção 9 + Arquivos de Mídia | **C6** (10%) |

### Checklist Final de Conformidade
- [x] Equipe formada por 3 a 5 estudantes com validação consultiva do Embaixador de Negócios.
- [x] Nenhum dado pessoal sensível real inserido nos prompts de IA; painéis públicos anonimizados (LGPD).
- [x] Código-fonte auditado contra XSS, funções limitadas a 20 linhas e 100% comentado em `pt-BR`.
- [x] Vídeo do Protótipo (`1m20s` ≤ `1m30s`) e Vídeo Pitch (`2m45s` ≤ `3m00s`) dentro do tempo regulamentar.