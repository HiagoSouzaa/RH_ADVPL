/*{Protheus.doc} zJobExa 

@description Funcao automatica que manda email avisando sobre o vencimento de exames de colaboradores
@author  	Hiago   
@return 	Undefinied
*/
#include 'Protheus.ch'
#Include 'TopConn.ch'
#include 'parmtype.ch'
#include 'totvs.ch'

User Function zJobExa(aSchedule, cEmp_, cFil_)


    Local aArea            := {}
    Local cQUERY           :=  ' '
    Local cNameZHE         :=  ' '
    Local cNameZCO         :=  ' ' 
    Local cAliasTmp        := 'zJobExa_' + FWTimeStamp()
    Local cTextoHTML       :=  ' '
    Local cPara            := " " 
    local cAssunto         := ' ' 
    local dDiAviso         := cTod("//")
    local cExameAnterior   := ' '

    Default	aSchedule := {"01","0101"}		
	Default cEmp_	  := aSchedule[1]
	Default cFil_	  := aSchedule[2]


       //Se não tiver preparado o ambiente (Schedule)
        If( IsBlind() )
        		
    		RPCSetType(3)              //Não consome licença
		    RPCSetEnv(cEmp_, cFil_)    //Prepara ambiente 

	    EndIf

        aArea 	 := GetArea()

        cNameZHE  :=  retSqlname("ZHE")
        cNameZCO  :=  retSqlname("ZCO")
        dDiAviso  :=  DAYSUM(DATE(),SuperGetMv("MV_X_VENEX"))
        cPara     :=  SuperGetMv("MV_X_JOBEX")

    cQUERY := " SELECT  ZHE_CPF, ZHE_DTREA, ZHE_FREQU, ZHE_DTPREA, ZCO_NOME, ZHE_TPEXAM "
    cQUERY += " FROM " + cNameZHE + " AS ZHE "
    cQUERY += " INNER JOIN " + cNameZCO + " "
    cQuery += " ON ZCO_FILIAL = ZHE_FILIAL AND ZCO_CPF = ZHE_CPF "
    cQUERY += " WHERE ZHE_FILIAL = '" + FWxFilial( "ZHE" ) +" '"
    cQUERY += " AND ZHE_DTPREA = '" + DTOS(dDiAviso) +"' "
    cQUERY += " AND ZHE.D_E_L_E_T_ = ' ' "
    cQUERY += " ORDER BY ZHE_TPEXAM "
    cQUERY := changeQuery(cQUERY)
    VarInfo( cQUERY )

    TcQUERY cQUERY New Alias (cAliasTmp)

    dbSelectArea(cAliasTmp)

// monta o cabecario de exames
While !(cAliasTmp)->(Eof())

    cExameAnterior := (cAliasTmp)->ZHE_TPEXAM

    cTextoHTML +=' <html lang="pt-BR">'
    cTextoHTML +=' <head> '
    cTextoHTML +=' <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> '
    cTextoHTML +=' <title> Alerta  </title> '
    cTextoHTML +=' </head> '
    cTextoHTML +=' <body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0" offset="0" style="padding: 0;"> '
    cTextoHTML +='      <div id="wrapper" dir="ltr" style="background-color: #f7f7f7; margin: 0; padding: 70px 0; width: 100%; -webkit-text-size-adjust: none;"> '
    cTextoHTML +='          <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%"> '
    cTextoHTML +='              <tr> '
    cTextoHTML +='                  <td align="center" valign="top"> '
    cTextoHTML +='                     <div id="template_header_image"> '
    cTextoHTML +='                          <p  style="margin-top: 0;"><img src="https://portaodecambui.com.br/loja/wp-content/themes/portaodecambui/custom/images/header/logo.png" '
    cTextoHTML +='                              alt="Portão de Cambuí "
    cTextoHTML +='                              style="border: none; display: inline-block; font-size: 14px; font-weight: bold; height: auto; outline: none; text-decoration: none; text-transform: capitalize; vertical-align: middle; max-width: 100%; margin-left: 0; margin-right: 0;"> '
    cTextoHTML +='                          </p> '
    cTextoHTML +='                     </div>  '
    cTextoHTML +='                     <table border="0" cellpadding="0" cellspacing="0" width="800" id="template_container" style="background-color: #ffffff; border: 1px solid #dedede; box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1); border-radius: 3px;"> '
    cTextoHTML +='                          <tr> '
    cTextoHTML +='                              <td align="center" valign="top"> '
    cTextoHTML +='                                  <!-- Header --> '
    cTextoHTML +='                                  <table border="0" cellpadding="0" cellspacing="0" width="100%" id="template_header" style="background-color: #ce171f; color: #ffffff; border-bottom: 0; font-weight: bold; line-height: 50pix; vertical-align: middle; font-family: "Helvetica Neue", Helvetica, Roboto, Arial, sans-serif; border-radius: 3px 3px 0 0;"> '
    cTextoHTML +='                                      <tr> '
    cTextoHTML +='                                          <td id="header_wrapper" style="padding: 38px 48px; display: block;"> '
    cTextoHTML +='                                              <h1 style="font-family: "Helvetica Neue", Helvetica, Roboto, Arial, sans-serif; font-size: 30px; font-weight: 300; line-height: 150%; margin: 0; text-align: left; text-shadow: 0 1px 0 #d8454c; color: #ffffff; background-color: inherit;"> '
    cTextoHTML +='                                                 Tipo do Exame : ' + POSICIONE("SX5",1,FWXFILIAL("SX5")+"ZE"+(cAliasTmp)->ZHE_TPEXAM,"X5_DESCRI")
	cTextoHTML +='      										</h1> '
    cTextoHTML +='                                          </td> '
    cTextoHTML +='                                      </tr> '
    cTextoHTML +='                                  </table> '
    cTextoHTML +='                                  <!-- End Header --> '
    cTextoHTML +='                              </td> '
    cTextoHTML +='                          </tr> '
    cTextoHTML +='                          <tr> '
    cTextoHTML +='                        <td align="center" valign="top"> '
    cTextoHTML +='                            <!-- Body --> '
    cTextoHTML +='                            <table border="0" cellpadding="0" cellspacing="0" width="800" id="template_body"> '
    cTextoHTML +='                                <tr> '
    cTextoHTML +='                                    <td valign="top" id="body_content" style="background-color: #ffffff;"> '
    cTextoHTML +='                                        <!-- Content --> '
    cTextoHTML +='                                        <table border="0" cellpadding="20" cellspacing="0" width="100%"> '
    cTextoHTML +='                                          <tr> '
    cTextoHTML +='                                                <td valign="top" style="padding: 48px 48px 32px;"> '
    cTextoHTML +='                                                    <div id="body_content_inner" style="color: #636363; font-family: "Helvetica Neue", Helvetica, Roboto, Arial, sans-serif; font-size: 14px; line-height: 150%; text-align: left;">'
    cTextoHTML +='                                                            <p style="margin: 0 0 16px;">Olá usuário</p> '
    cTextoHTML +='                                                            <p style="margin: 0 0 16px;"> '
    cTextoHTML +='                                                              Segue abaixo os colaboradores que teram seus exames vencidos. '
    cTextoHTML +='                                                            </p> '
    cTextoHTML +='                                                            <h2 style="color: #ce171f; display: block; font-family: "Helvetica Neue", Helvetica, Roboto, Arial, sans-serif; font-size: 18px; font-weight: bold; line-height: 130%; margin: 0 0 18px; text-align: left;"> '
    cTextoHTML +='                                                              Data: '+ DTOC(dDiAviso) 
	cTextoHTML +='       													  </h2> '
    cTextoHTML +='                                                            <div style="margin-bottom: 4px;"> '
    cTextoHTML +='                                                                 <table cellspacing="0" cellpadding="6" '
	cTextoHTML +='  																border="1" '
    cTextoHTML +='                                                                  style="color: #636363; border: 1px solid #e5e5e5; vertical-align: middle; width: 100%; font-family: "Helvetica Neue", Helvetica, Roboto, Arial, sans-serif;"> '
    cTextoHTML +='                                                                  <thead> '
    cTextoHTML +='                                                                        <tr> '
    cTextoHTML +='                                                                              <th class="td" scope="col" style="color: #636363; border: 1px solid #e5e5e5; vertical-align: middle; padding: 12px; text-align: left;"> '
    cTextoHTML +='                                                                                    Colaborador '
	cTextoHTML +='  		    		    													</th> '
    cTextoHTML +='                                                                              <th class="td" scope="col" style="color: #636363; border: 1px solid #e5e5e5; vertical-align: middle; padding: 12px; text-align: left;"> '
    cTextoHTML +='                                                                                    CPF '
	cTextoHTML +='  									    									</th> '
    cTextoHTML +='                                                                              
    cTextoHTML +='                                                                        </tr> '
    cTextoHTML +='                                                                </thead> '
    cTextoHTML +='                                                                <tbody> '
    
     cAssunto  := "Vencimetos de exames : " +; 
                  POSICIONE("SX5",1,FWXFILIAL("SX5")+"ZE"+(cAliasTmp)->ZHE_TPEXAM,"X5_DESCRI") +;
                  "data de vencimento : " + DTOC(dDiAviso)
        
        While ((cAliasTmp)->ZHE_TPEXAM = cExameAnterior)
           
            cTextoHTML +=' <tr> '
            cTextoHTML +='   <td style="color: #636363; border: 1px solid #e5e5e5; padding: 12px; text-align: left; vertical-align: middle; font-family: "Helvetica Neue", Helvetica, Roboto, Arial, sans-serif; word-wrap: break-word;"> '
            cTextoHTML +=      (cAliasTmp)->ZCO_NOME       
			cTextoHTML +='   </td> '
            cTextoHTML +='   <td style="color: #636363; border: 1px solid #e5e5e5; padding: 12px; text-align: left; vertical-align: middle; font-family: "Helvetica Neue", Helvetica, Roboto, Arial, sans-serif;"> '
            cTextoHTML +='       '+ TRANSFORM((cAliasTmp)->ZHE_CPF, "@R 999.999.999-99") 
			cTextoHTML +='   </td>

            dbSkip() 
       EndDo 
                                                                                                                                                    
   cTextoHTML +='                                                                </tbody> '
   cTextoHTML +='                                                             </table> '
   cTextoHTML +='                                                        </div> '                                                        
   cTextoHTML +='                                                     </div> '
   cTextoHTML +='                                                 </td> '
   cTextoHTML +='                                             </tr> '
   cTextoHTML +='                                         </table> '
   cTextoHTML +='                                         <!-- End Content --> '
   cTextoHTML +='                                     </td> '
   cTextoHTML +='                                 </tr> '
   cTextoHTML +='                             </table> '
   cTextoHTML +='                             <!-- End Body --> '
   cTextoHTML +='                         </td> '
   cTextoHTML +='                     </tr> '     
   cTextoHTML +='                 </table> '
   cTextoHTML +='             </td> '
   cTextoHTML +='         </tr> '
   cTextoHTML +='    </table> '   
   cTextoHTML +=' </div> '
   cTextoHTML +='</body> '
   cTextoHTML +='</html> '
    
        u_zEnvMail(cPara, cAssunto, cTextoHTML)
    
   cTextoHTML := ' '  
   cAssunto  := ' '
    
 EndDo

    (cAliasTmp)->(dbCloseArea())
    
    RestArea(aArea)

    //Sempre após abrir o sistema e fazer o que tem de fazer deve ser fechado.
	If( IsBlind() )

		RpcClearEnv() //Libera ambiente

	Endif

Return
