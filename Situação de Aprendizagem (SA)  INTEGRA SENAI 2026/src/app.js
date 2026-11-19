"use strict";

const CHAVE_ARMAZENAMENTO = "eam_estado_2026";
const STATUS_VALIDOS = ["Aberto", "Em Atendimento", "Concluído", "Cancelado"];
const SETORES = [{ id: 1, nome: "Cozinha", painel_destino: "Zeladoria" }, { id: 2, nome: "Guarita", painel_destino: "Vigilância" }, { id: 3, nome: "Oficina", painel_destino: "Manutenção" }];
let banco = null;
let chamadoPendente = null;

function dataMinutos(quantidade) {
  return new Date(Date.now() - quantidade * 60000).toISOString();
}

function criarChamadosIniciais() {
  return [
    { protocolo: "#EAM-1001", solicitante: "Mariana Oliveira Costa", categoria: "Manutenção", setor_id: 3, localizacao: "Oficina — Linha 2", descricao: "Esteira com ruído acima do normal.", prioridade: "Alta", status: "Em Atendimento", responsavel: "Equipe da Oficina", data_abertura: dataMinutos(42), data_inicio: dataMinutos(18), data_conclusao: null, foto_url: null },
    { protocolo: "#EAM-1002", solicitante: "Carlos Silva", categoria: "Zeladoria", setor_id: 1, localizacao: "Cozinha — Área de preparo", descricao: "Piso molhado próximo à pia.", prioridade: "Média", status: "Aberto", responsavel: "Aguardando Triagem", data_abertura: dataMinutos(15), data_inicio: null, data_conclusao: null, foto_url: null },
    { protocolo: "#EAM-1003", solicitante: "Ana Luiza Dore", categoria: "Risco", setor_id: 2, localizacao: "Guarita — Portão principal", descricao: "Portão de acesso não está travando.", prioridade: "Urgente/Risco", status: "Em Atendimento", responsavel: "Equipe da Guarita", data_abertura: dataMinutos(9), data_inicio: dataMinutos(6), data_conclusao: null, foto_url: null },
    { protocolo: "#EAM-1004", solicitante: "Davi Martins", categoria: "Vigilância", setor_id: 2, localizacao: "Guarita — Acesso lateral", descricao: "Luminária do acesso lateral apagada.", prioridade: "Baixa", status: "Concluído", responsavel: "Equipe da Guarita", data_abertura: dataMinutos(120), data_inicio: dataMinutos(100), data_conclusao: dataMinutos(55), foto_url: null }
  ];
}

function criarUsuariosIniciais() {
  return [
    { id: 1, nome: "Gestor de Demonstração", perfil: "Gestor", setor_id: null },
    { id: 2, nome: "Equipe da Cozinha", perfil: "Operador", setor_id: 1 },
    { id: 3, nome: "Equipe da Guarita", perfil: "Operador", setor_id: 2 },
    { id: 4, nome: "Equipe da Oficina", perfil: "Operador", setor_id: 3 },
    { id: 5, nome: "Solicitante de Demonstração", perfil: "Solicitante", setor_id: null }
  ];
}

function criarHistoricoInicial() {
  return [
    { id: 1, protocolo_chamado: "#EAM-1001", status_anterior: "Aberto", novo_status: "Em Atendimento", usuario_responsavel: "Gestor de Demonstração", data_hora: dataMinutos(18), observacao: "Atendimento iniciado para demonstração." },
    { id: 2, protocolo_chamado: "#EAM-1003", status_anterior: "Aberto", novo_status: "Em Atendimento", usuario_responsavel: "Gestor de Demonstração", data_hora: dataMinutos(6), observacao: "Prioridade de risco; equipe acionada para demonstração." },
    { id: 3, protocolo_chamado: "#EAM-1004", status_anterior: "Aberto", novo_status: "Em Atendimento", usuario_responsavel: "Gestor de Demonstração", data_hora: dataMinutos(100), observacao: "Equipe iniciou a verificação." },
    { id: 4, protocolo_chamado: "#EAM-1004", status_anterior: "Em Atendimento", novo_status: "Concluído", usuario_responsavel: "Gestor de Demonstração", data_hora: dataMinutos(55), observacao: "Luminária substituída e funcionamento verificado." }
  ];
}

function criarEstadoInicial() {
  return { setores: SETORES, usuarios: criarUsuariosIniciais(), chamados: criarChamadosIniciais(), historico: criarHistoricoInicial() };
}

function validarBanco(estado) {
  const valido = estado && Array.isArray(estado.setores) && Array.isArray(estado.usuarios) && Array.isArray(estado.chamados) && Array.isArray(estado.historico);
  if (!valido) throw new Error("Os dados locais estão em formato inválido. Exporte ou limpe o armazenamento para continuar.");
  const inconsistente = estado.chamados.some((chamado) => !chamado.status || !chamado.responsavel || !STATUS_VALIDOS.includes(chamado.status));
  if (inconsistente) throw new Error("Há chamado sem status ou responsável válido no armazenamento local.");
  return estado;
}

function salvarBanco(estado) {
  try {
    localStorage.setItem(CHAVE_ARMAZENAMENTO, JSON.stringify(estado));
  } catch (erro) {
    const detalhe = erro instanceof Error ? erro.message : "falha desconhecida";
    throw new Error(`Não foi possível salvar os dados neste navegador: ${detalhe}`);
  }
}

function carregarBanco() {
  try {
    const salvo = localStorage.getItem(CHAVE_ARMAZENAMENTO);
    if (!salvo) {
      const inicial = criarEstadoInicial();
      salvarBanco(inicial);
      return inicial;
    }
    return validarBanco(JSON.parse(salvo));
  } catch (erro) {
    const detalhe = erro instanceof Error ? erro.message : "falha desconhecida";
    throw new Error(`Não foi possível carregar os dados locais: ${detalhe}`);
  }
}

function criarElemento(tag, texto, classe) {
  const elemento = document.createElement(tag);
  elemento.textContent = texto;
  if (classe) elemento.className = classe;
  return elemento;
}

function obterSetor(id) {
  return SETORES.find((setor) => setor.id === Number(id)) || SETORES[0];
}

function obterSetorCategoria(categoria) {
  const setor = SETORES.find((item) => item.painel_destino === categoria);
  return setor ? setor.id : 3;
}

function formatarIniciais(nome) {
  return nome.trim().split(/\s+/).map((parte) => parte.match(/[\p{L}\p{N}]/u)).filter(Boolean).map((parte) => `${parte[0].toLocaleUpperCase("pt-BR")}.`).join(" ");
}

function normalizar(texto) {
  return texto.trim().toLocaleLowerCase("pt-BR");
}

function formatarTempo(abertura) {
  const minutos = Math.max(0, Math.floor((Date.now() - new Date(abertura).getTime()) / 60000));
  return `${minutos} min`;
}

function chamadoAtivo(chamado) {
  return chamado.status !== "Concluído" && chamado.status !== "Cancelado";
}

function criarCartaoPainel(chamado) {
  const cartao = criarElemento("article", "", "cartao-chamado");
  if (chamado.categoria === "Risco" || chamado.prioridade === "Urgente/Risco") cartao.classList.add("risco");
  const topo = criarElemento("div", "", "cabecalho-cartao");
  topo.append(criarElemento("span", chamado.protocolo, "protocolo"), criarElemento("span", formatarTempo(chamado.data_abertura), "tempo-decorrido"));
  cartao.append(topo, criarElemento("p", chamado.categoria, "categoria-cartao"), criarElemento("p", chamado.localizacao, "local-cartao"), criarElemento("p", chamado.descricao.slice(0, 130), "descricao-cartao"));
  const rodape = criarElemento("div", "", "rodape-cartao");
  rodape.append(criarElemento("span", `Solicitante: ${formatarIniciais(chamado.solicitante)}`), criarElemento("span", chamado.status));
  cartao.append(rodape);
  return cartao;
}

function chamadosDoPainel(setorId) {
  return banco.chamados.filter((chamado) => chamadoAtivo(chamado) && (chamado.setor_id === setorId || chamado.categoria === "Risco" || chamado.prioridade === "Urgente/Risco"));
}

function criarGrupoPainel(setor) {
  const grupo = criarElemento("section", "", "grupo-painel");
  grupo.append(criarElemento("h3", `${setor.nome} · ${setor.painel_destino}`));
  const chamados = chamadosDoPainel(setor.id).sort((a, b) => a.prioridade === "Urgente/Risco" ? -1 : b.prioridade === "Urgente/Risco" ? 1 : 0);
  if (!chamados.length) grupo.append(criarElemento("p", "Nenhum chamado ativo neste painel.", "estado-vazio"));
  chamados.forEach((chamado) => grupo.append(criarCartaoPainel(chamado)));
  return grupo;
}

function renderizarPaineis() {
  const lista = document.querySelector("#lista-paineis");
  const selecionado = document.querySelector("#filtro-painel").value;
  lista.replaceChildren();
  SETORES.filter((setor) => selecionado === "todos" || setor.id === Number(selecionado)).forEach((setor) => lista.append(criarGrupoPainel(setor)));
}

function minutosEntre(inicio, fim) {
  return (new Date(fim).getTime() - new Date(inicio).getTime()) / 60000;
}

function mediaTempos(chamados, inicio, fim) {
  const tempos = chamados.filter((chamado) => chamado[inicio] && chamado[fim]).map((chamado) => minutosEntre(chamado[inicio], chamado[fim]));
  return tempos.length ? Math.round(tempos.reduce((soma, tempo) => soma + tempo, 0) / tempos.length) : null;
}

function setorMaisDemandado() {
  const contagens = SETORES.map((setor) => ({ setor, total: banco.chamados.filter((chamado) => chamado.setor_id === setor.id).length }));
  return contagens.sort((a, b) => b.total - a.total)[0];
}

function renderizarIndicadores() {
  const tma = mediaTempos(banco.chamados, "data_abertura", "data_inicio");
  const tmr = mediaTempos(banco.chamados.filter((chamado) => chamado.status === "Concluído"), "data_abertura", "data_conclusao");
  document.querySelector("#indicador-tma").textContent = tma === null ? "—" : `${tma} min`;
  document.querySelector("#indicador-tmr").textContent = tmr === null ? "—" : `${tmr} min`;
  document.querySelector("#indicador-ativos").textContent = String(banco.chamados.filter(chamadoAtivo).length);
  const maisDemandado = setorMaisDemandado();
  document.querySelector("#indicador-setor").textContent = maisDemandado.total ? maisDemandado.setor.nome : "—";
}

function criarCampoTabela(rotulo, tipo, valor) {
  const contorno = criarElemento("div", "", "campo-tabela");
  const campo = document.createElement(tipo === "textarea" ? "textarea" : "input");
  if (tipo !== "textarea") campo.type = tipo;
  campo.value = valor;
  campo.setAttribute("aria-label", rotulo);
  contorno.append(criarElemento("label", rotulo), campo);
  return contorno;
}

function criarSelecaoTabela(rotulo, opcoes, valor) {
  const contorno = criarElemento("div", "", "campo-tabela");
  const selecao = document.createElement("select");
  selecao.setAttribute("aria-label", rotulo);
  opcoes.forEach((opcao) => {
    const elemento = criarElemento("option", opcao.rotulo, "");
    elemento.value = opcao.valor;
    selecao.append(elemento);
  });
  selecao.value = String(valor);
  contorno.append(criarElemento("label", rotulo), selecao);
  return contorno;
}

function adicionarCelula(linha, conteudo) {
  const celula = document.createElement("td");
  if (typeof conteudo === "string") celula.textContent = conteudo;
  else celula.append(conteudo);
  linha.append(celula);
  return celula;
}

function criarLinhaHistorico(chamado) {
  const linha = document.createElement("tr");
  linha.className = "linha-historico";
  const celula = document.createElement("td");
  celula.colSpan = 9;
  const eventos = banco.historico.filter((item) => item.protocolo_chamado === chamado.protocolo).sort((a, b) => new Date(a.data_hora) - new Date(b.data_hora));
  const lista = document.createElement("ol");
  lista.className = "lista-historico";
  eventos.forEach((evento) => {
    const texto = `${new Date(evento.data_hora).toLocaleString("pt-BR")} · ${evento.status_anterior} → ${evento.novo_status} · ${evento.usuario_responsavel}: ${evento.observacao}`;
    lista.append(criarElemento("li", texto));
  });
  if (!eventos.length) lista.append(criarElemento("li", "Sem alterações registradas."));
  celula.append(lista);
  linha.append(celula);
  return linha;
}

function preencherDadosGestao(linha, chamado) {
  adicionarCelula(linha, chamado.protocolo);
  adicionarCelula(linha, chamado.solicitante);
  adicionarCelula(linha, `${chamado.localizacao} — ${chamado.descricao}`);
  adicionarCelula(linha, chamado.prioridade);
  adicionarCelula(linha, criarCampoTabela("Responsável", "text", chamado.responsavel));
  const opcoesSetor = SETORES.map((setor) => ({ valor: String(setor.id), rotulo: setor.nome }));
  adicionarCelula(linha, criarSelecaoTabela("Setor", opcoesSetor, chamado.setor_id));
  adicionarCelula(linha, criarSelecaoTabela("Status", STATUS_VALIDOS.map((status) => ({ valor: status, rotulo: status })), chamado.status));
  const gestor = criarElemento("div", "", "campo-tabela");
  gestor.append(criarCampoTabela("Nome do gestor", "text", ""), criarCampoTabela("Justificativa", "textarea", ""));
  adicionarCelula(linha, gestor);
}

function criarCelulaAcoes(chamado, linha) {
  const acoes = document.createElement("td");
  const salvar = criarElemento("button", "Salvar", "botao botao-principal botao-tabela");
  salvar.type = "button";
  salvar.addEventListener("click", () => executarComErro(() => salvarEdicao(chamado.protocolo, linha)));
  const historico = criarElemento("button", "Histórico", "botao botao-secundario botao-tabela");
  historico.type = "button";
  historico.addEventListener("click", () => alternarHistorico(chamado, linha));
  acoes.append(salvar, document.createTextNode(" "), historico);
  return acoes;
}

function criarLinhaGestao(chamado) {
  const linha = document.createElement("tr");
  linha.dataset.protocolo = chamado.protocolo;
  preencherDadosGestao(linha, chamado);
  const acoes = criarCelulaAcoes(chamado, linha);
  linha.append(acoes);
  return linha;
}

function alternarHistorico(chamado, linha) {
  const proxima = linha.nextElementSibling;
  if (proxima && proxima.classList.contains("linha-historico")) {
    proxima.remove();
    return;
  }
  linha.after(criarLinhaHistorico(chamado));
}

function chamadosFiltrados() {
  const setor = document.querySelector("#filtro-setor").value;
  const status = document.querySelector("#filtro-status").value;
  const prioridade = document.querySelector("#filtro-prioridade").value;
  return banco.chamados.filter((chamado) => (setor === "todos" || chamado.setor_id === Number(setor)) && (status === "todos" || chamado.status === status) && (prioridade === "todos" || chamado.prioridade === prioridade));
}

function renderizarTabela() {
  const tabela = document.querySelector("#tabela-chamados");
  const chamados = chamadosFiltrados().sort((a, b) => new Date(b.data_abertura) - new Date(a.data_abertura));
  tabela.replaceChildren();
  chamados.forEach((chamado) => tabela.append(criarLinhaGestao(chamado)));
  document.querySelector("#estado-tabela").hidden = chamados.length > 0;
}

function renderizarTudo() {
  renderizarPaineis();
  renderizarIndicadores();
  renderizarTabela();
}

function executarComErro(operacao) {
  try {
    operacao();
  } catch (erro) {
    notificar(erro instanceof Error ? erro.message : "Ocorreu uma falha inesperada.");
  }
}

function notificar(mensagem) {
  const aviso = criarElemento("p", mensagem, "notificacao");
  document.querySelector("#notificacoes").append(aviso);
  window.setTimeout(() => aviso.remove(), 7000);
}

function gerarProtocolo() {
  const maior = banco.chamados.reduce((valor, chamado) => Math.max(valor, Number(chamado.protocolo.replace("#EAM-", "")) || 1000), 1000);
  return `#EAM-${maior + 1}`;
}

function lerFormulario(formulario) {
  const dados = new FormData(formulario);
  const foto = formulario.elements.foto.files[0];
  return {
    protocolo: gerarProtocolo(), solicitante: String(dados.get("solicitante")).trim(), categoria: String(dados.get("categoria")),
    setor_id: obterSetorCategoria(String(dados.get("categoria"))), localizacao: String(dados.get("localizacao")).trim(),
    descricao: String(dados.get("descricao")).trim(), prioridade: String(dados.get("prioridade")), status: "Aberto",
    responsavel: "Aguardando Triagem", data_abertura: new Date().toISOString(), data_inicio: null, data_conclusao: null,
    foto_url: foto ? foto.name : null
  };
}

function chamadosDuplicados(novo) {
  return banco.chamados.filter((chamado) => chamadoAtivo(chamado) && chamado.categoria === novo.categoria && normalizar(chamado.localizacao) === normalizar(novo.localizacao));
}

function mostrarDuplicidade(chamados) {
  const alerta = document.querySelector("#alerta-duplicidade");
  alerta.replaceChildren(criarElemento("p", `Já existe chamado ativo no mesmo local e categoria: ${chamados.map((item) => item.protocolo).join(", ")}. Deseja registrar mesmo assim?`));
  const confirmar = criarElemento("button", "Registrar mesmo assim", "botao botao-principal");
  confirmar.type = "button";
  confirmar.addEventListener("click", () => executarComErro(confirmarChamado));
  const revisar = criarElemento("button", "Revisar formulário", "botao botao-secundario");
  revisar.type = "button";
  revisar.addEventListener("click", cancelarDuplicidade);
  alerta.append(confirmar, revisar);
  alerta.hidden = false;
}

function cancelarDuplicidade() {
  chamadoPendente = null;
  document.querySelector("#alerta-duplicidade").hidden = true;
}

function confirmarChamado() {
  if (!chamadoPendente) throw new Error("Não há chamado aguardando confirmação.");
  criarChamado(chamadoPendente);
  cancelarDuplicidade();
}

function enviarFormulario(evento) {
  evento.preventDefault();
  chamadoPendente = lerFormulario(evento.currentTarget);
  const duplicados = chamadosDuplicados(chamadoPendente);
  if (duplicados.length) return mostrarDuplicidade(duplicados);
  criarChamado(chamadoPendente);
}

function criarChamado(chamado) {
  banco = carregarBanco();
  chamado.protocolo = gerarProtocolo();
  banco.chamados.push(chamado);
  const id = Math.max(0, ...banco.historico.map((evento) => evento.id || 0)) + 1;
  banco.historico.push({ id, protocolo_chamado: chamado.protocolo, status_anterior: "Novo", novo_status: "Aberto", usuario_responsavel: chamado.solicitante, data_hora: chamado.data_abertura, observacao: "Chamado criado." });
  salvarBanco(banco);
  const confirmacao = document.querySelector("#confirmacao-chamado");
  confirmacao.replaceChildren(criarElemento("p", "Chamado registrado com sucesso."), criarElemento("strong", chamado.protocolo));
  confirmacao.hidden = false;
  document.querySelector("#formulario-chamado").reset();
  chamadoPendente = null;
  renderizarTudo();
}

function obterCampo(linha, rotulo) {
  const campos = Array.from(linha.querySelectorAll("[aria-label]"));
  return campos.find((campo) => campo.getAttribute("aria-label") === rotulo);
}

function criarRegistroHistorico(chamado, gestor, motivo, statusNovo, setorNovo) {
  const setorAnterior = obterSetor(chamado.setor_id).nome;
  const setorDestino = obterSetor(setorNovo).nome;
  const mudouSetor = Number(setorNovo) !== chamado.setor_id;
  const observacaoSetor = mudouSetor ? ` Setor redirecionado de ${setorAnterior} para ${setorDestino}.` : "";
  const id = Math.max(0, ...banco.historico.map((evento) => evento.id || 0)) + 1;
  banco.historico.push({
    id, protocolo_chamado: chamado.protocolo, status_anterior: chamado.status, novo_status: statusNovo,
    usuario_responsavel: gestor, data_hora: new Date().toISOString(), observacao: `${motivo}${observacaoSetor}`
  });
}

function aplicarDatasStatus(chamado, statusNovo) {
  if (statusNovo === "Em Atendimento" && !chamado.data_inicio) chamado.data_inicio = new Date().toISOString();
  if (statusNovo === "Concluído") chamado.data_conclusao = new Date().toISOString();
  if (statusNovo !== "Concluído") chamado.data_conclusao = null;
}

function salvarEdicao(protocolo, linha) {
  const chamado = banco.chamados.find((item) => item.protocolo === protocolo);
  const responsavel = obterCampo(linha, "Responsável").value.trim();
  const setorNovo = Number(obterCampo(linha, "Setor").value);
  const statusNovo = obterCampo(linha, "Status").value;
  if (!responsavel) throw new Error("Informe um responsável para o chamado.");
  const mudou = statusNovo !== chamado.status || setorNovo !== chamado.setor_id;
  const gestor = obterCampo(linha, "Nome do gestor").value.trim();
  const motivo = obterCampo(linha, "Justificativa").value.trim();
  if (mudou && (!gestor || !motivo)) throw new Error("Informe o nome do gestor e a justificativa para alterar status ou setor.");
  if (mudou) criarRegistroHistorico(chamado, gestor, motivo, statusNovo, setorNovo);
  aplicarDatasStatus(chamado, statusNovo);
  Object.assign(chamado, { responsavel, setor_id: setorNovo, status: statusNovo });
  salvarBanco(banco);
  renderizarTudo();
  notificar(`Chamado ${protocolo} atualizado.`);
}

function alternarVisao(evento) {
  const alvo = evento.currentTarget.dataset.visao;
  document.querySelectorAll(".aba").forEach((aba) => {
    const selecionada = aba.dataset.visao === alvo;
    aba.classList.toggle("ativa", selecionada);
    aba.setAttribute("aria-selected", String(selecionada));
  });
  document.querySelectorAll(".visao").forEach((visao) => { visao.hidden = visao.id !== alvo; });
}

function alternarTema() {
  const claro = document.body.classList.toggle("tema-claro");
  const botao = document.querySelector("#alternar-tema");
  botao.textContent = claro ? "Tema escuro" : "Tema claro";
  botao.setAttribute("aria-pressed", String(claro));
}

function atualizarTempoReal() {
  try {
    banco = carregarBanco();
    renderizarPaineis();
    renderizarIndicadores();
  } catch (erro) {
    notificar(erro instanceof Error ? erro.message : "Falha ao atualizar os dados.");
  }
}

function atualizarDadosExternos(evento) {
  if (evento.key !== CHAVE_ARMAZENAMENTO || !evento.newValue) return;
  try {
    banco = validarBanco(JSON.parse(evento.newValue));
    renderizarPaineis();
    renderizarIndicadores();
    const tabela = document.querySelector("#tabela-chamados");
    if (!tabela.contains(document.activeElement)) renderizarTabela();
  } catch (erro) {
    notificar(erro instanceof Error ? erro.message : "Falha ao sincronizar os dados.");
  }
}

function inicializar() {
  try {
    banco = carregarBanco();
    document.querySelector("#formulario-chamado").addEventListener("submit", enviarFormulario);
    document.querySelectorAll(".aba").forEach((aba) => aba.addEventListener("click", alternarVisao));
    document.querySelectorAll(".filtros-gestao select").forEach((filtro) => filtro.addEventListener("change", renderizarTabela));
    document.querySelector("#filtro-painel").addEventListener("change", renderizarPaineis);
    document.querySelector("#alternar-tema").addEventListener("click", alternarTema);
    window.addEventListener("storage", atualizarDadosExternos);
    renderizarTudo();
    window.setInterval(atualizarTempoReal, 5000);
  } catch (erro) {
    notificar(erro instanceof Error ? erro.message : "Não foi possível iniciar o sistema.");
  }
}

inicializar();
