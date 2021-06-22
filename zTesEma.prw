#Include "Protheus.ch"

User Function zTesEma()

Local cPara      := "TI@portaodecambui.com.br ; hiagosouza9@hotmail.com" // Destinatario
local cAssunto   := " Teste"
Local cCorpo     := " Email chumbado "
Local aAnexos    := {}


//Local lMostraLog := .F.
//Local lUsaTLS    := .F.

//aAdd (aAnexos, "protheus_data\Imagens\imagem1.jpeg")


 u_zEnvMail(cPara, cAssunto, cCorpo, aAnexos)
Return 
