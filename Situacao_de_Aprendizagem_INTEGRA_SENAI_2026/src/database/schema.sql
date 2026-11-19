PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS SETOR (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL UNIQUE,
    painel_destino TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS USUARIO (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    perfil TEXT NOT NULL CHECK (perfil IN ('Solicitante', 'Operador', 'Gestor')),
    setor_id INTEGER,
    FOREIGN KEY (setor_id) REFERENCES SETOR(id)
);

CREATE TABLE IF NOT EXISTS CHAMADO (
    protocolo TEXT PRIMARY KEY,
    solicitante TEXT NOT NULL,
    categoria TEXT NOT NULL CHECK (categoria IN ('Manutenção', 'Zeladoria', 'Vigilância', 'Risco')),
    setor_id INTEGER NOT NULL,
    localizacao TEXT NOT NULL,
    descricao TEXT NOT NULL,
    prioridade TEXT NOT NULL CHECK (prioridade IN ('Baixa', 'Média', 'Alta', 'Urgente/Risco')),
    status TEXT NOT NULL DEFAULT 'Aberto' CHECK (status IN ('Aberto', 'Em Atendimento', 'Concluído', 'Cancelado')),
    responsavel TEXT NOT NULL DEFAULT 'Aguardando Triagem' CHECK (length(trim(responsavel)) > 0),
    data_abertura DATETIME NOT NULL,
    data_inicio DATETIME,
    data_conclusao DATETIME,
    foto_url TEXT,
    FOREIGN KEY (setor_id) REFERENCES SETOR(id)
);

CREATE TABLE IF NOT EXISTS HISTORICO (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    protocolo_chamado TEXT NOT NULL,
    status_anterior TEXT NOT NULL,
    novo_status TEXT NOT NULL,
    usuario_responsavel TEXT NOT NULL,
    data_hora DATETIME NOT NULL,
    observacao TEXT NOT NULL,
    FOREIGN KEY (protocolo_chamado) REFERENCES CHAMADO(protocolo)
);

INSERT OR IGNORE INTO SETOR (id, nome, painel_destino) VALUES
    (1, 'Cozinha', 'Zeladoria'),
    (2, 'Guarita', 'Vigilância'),
    (3, 'Oficina', 'Manutenção');

INSERT OR IGNORE INTO USUARIO (id, nome, perfil, setor_id) VALUES
    (1, 'Gestor de Demonstração', 'Gestor', NULL),
    (2, 'Equipe da Cozinha', 'Operador', 1),
    (3, 'Equipe da Guarita', 'Operador', 2),
    (4, 'Equipe da Oficina', 'Operador', 3),
    (5, 'Solicitante de Demonstração', 'Solicitante', NULL);

INSERT OR IGNORE INTO CHAMADO
    (protocolo, solicitante, categoria, setor_id, localizacao, descricao, prioridade, status, responsavel, data_abertura, data_inicio, data_conclusao, foto_url)
VALUES
    ('#EAM-1001', 'Mariana Oliveira Costa', 'Manutenção', 3, 'Oficina — Linha 2', 'Esteira com ruído acima do normal.', 'Alta', 'Em Atendimento', 'Equipe da Oficina', datetime('now', '-42 minutes'), datetime('now', '-18 minutes'), NULL, NULL),
    ('#EAM-1002', 'Carlos Silva', 'Zeladoria', 1, 'Cozinha — Área de preparo', 'Piso molhado próximo à pia.', 'Média', 'Aberto', 'Aguardando Triagem', datetime('now', '-15 minutes'), NULL, NULL, NULL),
    ('#EAM-1003', 'Ana Luiza Dore', 'Risco', 2, 'Guarita — Portão principal', 'Portão de acesso não está travando.', 'Urgente/Risco', 'Em Atendimento', 'Equipe da Guarita', datetime('now', '-9 minutes'), datetime('now', '-6 minutes'), NULL, NULL),
    ('#EAM-1004', 'Davi Martins', 'Vigilância', 2, 'Guarita — Acesso lateral', 'Luminária do acesso lateral apagada.', 'Baixa', 'Concluído', 'Equipe da Guarita', datetime('now', '-120 minutes'), datetime('now', '-100 minutes'), datetime('now', '-55 minutes'), NULL);

INSERT OR IGNORE INTO HISTORICO
    (protocolo_chamado, status_anterior, novo_status, usuario_responsavel, data_hora, observacao)
VALUES
    ('#EAM-1001', 'Aberto', 'Em Atendimento', 'Gestor de Demonstração', datetime('now', '-18 minutes'), 'Atendimento iniciado para demonstração.'),
    ('#EAM-1003', 'Aberto', 'Em Atendimento', 'Gestor de Demonstração', datetime('now', '-6 minutes'), 'Prioridade de risco; equipe acionada para demonstração.'),
    ('#EAM-1004', 'Aberto', 'Em Atendimento', 'Gestor de Demonstração', datetime('now', '-100 minutes'), 'Equipe iniciou a verificação.'),
    ('#EAM-1004', 'Em Atendimento', 'Concluído', 'Gestor de Demonstração', datetime('now', '-55 minutes'), 'Luminária substituída e funcionamento verificado.');
