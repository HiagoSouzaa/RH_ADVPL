/*{Protheus.doc} zDesMun 

@description POSICIONE que fornece os muncipios de determinado estado 
@author  	Hiago   
@return 	Undefinied

*/

#Include 'protheus.ch'

User Function zDesMun()
Return POSICIONE("CC2",1,FwxFilial("CC2")+ZCO->ZCO_ESTADO+ZCO->ZCO_MUN,"CC2_MUN")
