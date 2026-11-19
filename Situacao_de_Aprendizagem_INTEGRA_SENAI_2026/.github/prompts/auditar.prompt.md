---
mode: agent
description: Audita segurança, privacidade, qualidade e confiabilidade do MVP EAM
---

Audite os arquivos `src/index.html`, `src/style.css` e `src/app.js` sem alterar arquivos inicialmente. Verifique:

1. Prevenção de XSS: dados fornecidos pelo usuário não podem ser renderizados com `innerHTML`; devem ser usados nós criados com `document.createElement` e `textContent`.
2. Privacidade LGPD: os painéis operacionais públicos devem exibir somente iniciais do solicitante e nunca nome completo, telefone ou documento.
3. Clean Code: cada função deve ter no máximo 20 linhas; comentários existentes devem estar integralmente em português do Brasil.
4. Confiabilidade operacional: chamados devem ter status e responsável; mudanças de status devem exigir autor e justificativa e gerar registro com data/hora; falhas de persistência devem ser comunicadas.
5. Comportamento funcional: duplicidade, alerta global de risco, filtros, métricas e atualização automática devem preservar o estado dos formulários.

Apresente evidências com arquivo e linha. Corrija apenas problemas encontrados que contrariem esses requisitos e, ao final, repita a auditoria para confirmar as correções.
