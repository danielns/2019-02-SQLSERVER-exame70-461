require(XML); require(data.table)

# caminho = caminho no PC onde está o arquivo sei.xml.
# Ex.: C:\Users\m1312932\SEPLAG\SEI\data-raw\sei.xml

txt = readLines("data-raw/documentos.xml", encoding = "UTF-8")
xml = xmlTreeParse(txt, useInternalNodes=TRUE)

documentos = xpathApply(xml, "//ns1:consultarDocumentoResponse")

lista_documentos = list()
lista_formularios = list()
lista_assinaturas = list()

extrairValorTag = function(tag, xml=documento){
  return(xpathApply(xml, paste0(".//",tag), xmlValue)[[1]])
}

j=1; i=1

for(documento in documentos){
  doc_em_lista = list()
  
  doc_em_lista$IdProcedimento = xpathApply(documento, ".//IdProcedimento", xmlValue)[[1]]
  doc_em_lista$ProcedimentoFormatado = xpathApply(documento, ".//ProcedimentoFormatado", xmlValue)[[1]]
  
  doc_em_lista$IdDocumento = xpathApply(documento, ".//IdDocumento", xmlValue)[[1]]
  doc_em_lista$DocumentoFormatado = xpathApply(documento, ".//DocumentoFormatado", xmlValue)[[1]]
  
  
  doc_em_lista$LinkAcesso = extrairValorTag("LinkAcesso")
  
  doc_em_lista$id_serie = extrairValorTag("Serie//IdSerie")
  doc_em_lista$nome_serie = extrairValorTag("Serie//Nome")

  
  doc_em_lista$data = extrairValorTag("Data")
  
  doc_em_lista$UnidadeElaboradora_COD = extrairValorTag("UnidadeElaboradora//IdUnidade")
  doc_em_lista$UnidadeElaboradora_SIGLA = extrairValorTag("UnidadeElaboradora//Sigla")
  doc_em_lista$UnidadeElaboradora_DESC = extrairValorTag("UnidadeElaboradora//Descricao")
  
  doc_em_lista$GERACAO_DESC = extrairValorTag("AndamentoGeracao//Descricao")
  doc_em_lista$GERACAO_DATA_HORA = extrairValorTag("AndamentoGeracao//DataHora")
  doc_em_lista$GERACAO_UNIDADE_COD = extrairValorTag("AndamentoGeracao//Unidade//IdUnidade")
  doc_em_lista$GERACAO_UNIDADE_SIGLA = extrairValorTag("AndamentoGeracao//Unidade//Sigla")
  doc_em_lista$GERACAO_UNIDADE_DESC = extrairValorTag("AndamentoGeracao//Unidade//Descricao")
  
  doc_em_lista$USUARIO_COD = extrairValorTag("AndamentoGeracao//Usuario//IdUsuario")
  doc_em_lista$USUARIO_SIGLA = extrairValorTag("AndamentoGeracao//Usuario//Sigla")
  doc_em_lista$USUARIO_NOME = extrairValorTag("AndamentoGeracao//Usuario//Nome")
  
  lista_documentos[[j]] = as.data.table(doc_em_lista)
  
  assinaturas = xpathApply(documento, ".//Assinaturas//item")
  
  
  for(assinatura in assinaturas){
    
    assinatura_lista = list()
    assinatura_lista$IdDocumento = xpathApply(documento, ".//IdDocumento", xmlValue)[[1]]
    assinatura_lista$Nome = extrairValorTag("Nome", assinatura)
    assinatura_lista$CargoFuncao = extrairValorTag("CargoFuncao", assinatura)
    assinatura_lista$DataHora = extrairValorTag("DataHora", assinatura)
    assinatura_lista$IdUsuario = extrairValorTag("IdUsuario", assinatura)
    assinatura_lista$IdOrigem = extrairValorTag("IdOrigem", assinatura)
    assinatura_lista$IdOrgao = extrairValorTag("IdOrgao", assinatura)
    assinatura_lista$Sigla = extrairValorTag("Sigla", assinatura)
    
    lista_assinaturas[[i]] = as.data.table(assinatura_lista)
    i = i + 1
  }
  
  items = xpathApply(documento, ".//Campos//item")
  
  formulario_list  = list()
  formulario_list$IdDocumento = xpathApply(documento, ".//IdDocumento", xmlValue)[[1]]
  
  for(item in items){
    formulario_list[gsub(" ", "_", extrairValorTag("Nome", item))] = extrairValorTag("Valor", item)
  }
  
  lista_formularios[[j]] = as.data.table(formulario_list)
  
  j= j+1
}


assinaturas = rbindlist(lista_assinaturas)
formularios = rbindlist(lista_formularios, fill=T)
documentos = rbindlist(lista_documentos)

