# Diretrizes do projeto EAM

- Todo código, nomes de funções e variáveis, interface e comentários devem estar estritamente em português do Brasil (pt-BR).
- Aplicar Clean Code e SOLID: funções curtas, com no máximo 20 linhas, responsabilidade única e separação entre dados/regras de negócio e manipulação do DOM.
- Utilizar HTML5 semântico, CSS3 responsivo com Grid/Flexbox e JavaScript puro, sem frameworks externos.
- Nunca inserir dados do usuário com `innerHTML`. Criar nós com `document.createElement` e preencher conteúdo com `textContent`.
- Nos painéis operacionais públicos, nunca exibir nome completo, telefone ou documento do solicitante. Exibir somente as iniciais (por exemplo: “Carlos Silva” como “C. S.”).
- Nenhum chamado pode ficar sem status ou responsável. Toda mudança de status deve registrar autor, data/hora e justificativa no histórico de auditoria.
