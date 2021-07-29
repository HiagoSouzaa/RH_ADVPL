/*{Protheus.doc} zEnvEma

@description Funcão a ser chamada para o envio de emails
@author  	Hiago   
@return 	Undefinied
*/

#Include "Protheus.ch"
#Include "Ap5Mail.ch"

user function zEnvEma(cDe,cPara,cCC,cCO,cAssunto,cMsg)
    Local lResulConn := .T.
    Local lResulSend := .T.
    Local lResult    := .T.
    Local cError     := ""   
    Local cRet       := ""                                         
    Local _cUsuario  := GetMV("MV_RELACNT")
    Local _cSenha    := Embaralha(GetMV("MV_RELPSW"), 1) 
    Local _lJob      
    
    lResulConn := MailSmtpOn( "smtp.dominio.com", _cUsuario, _cSenha)
    If !lResulConn//GET MAIL ERROR 
        cErrorcError := MailGetErr()
        If _lJob
            cRet := Padc("Falha na conexao "+cErrorcError)
        Else
            cRet := "Falha na conexao "+cError
        Endif
        
        Return(.F.)
    Endif
    SEND MAIL FROM cDe TO cPara CC cCC BCC cCO SUBJECT cAssunto BODY cMsg FORMAT TEXT RESULT lResulSend
    
    if !lResulSend
        cRet:= "Falha no Envio!"
    else
        cRet:= "E-mail enviado com sucesso!"
    endif
    alert(cRet)
return(cRet)
