;Oznaczenie pamieci
;BIT, CODE, DATA, IDATA, XDATA, NUMBER

;Wejscie
;Arg Number               char, 1-byte ptr       int, 2-byte ptr                long, float                         generic ptr
;    1                          R7                   R6 & R7                       R4由7                              R1由3
;                                             (MSB in R6,LSB in R7)           (MSB in R4,LSB in R7)      (Mem type in R3, MSB in R2, LSB in R1)
;    2                          R5                   R4 & R5                       R4由7                              R1由3
;                                             (MSB in R4,LSB in R5)           (MSB in R4,LSB in R7)      (Mem type in R3, MSB in R2, LSB in R1)
;    3                          R3                   R2 & R3                     ----------                           R1由3
;                                             (MSB in R2,LSB in R3)                                      (Mem type in R3, MSB in R2, LSB in R1)

;Wyjscie
;bit                                 - Carry bit
;char, unsigned char, 1-byte pointer - R7 
;int, unsigned int, 2-byte ptr       - R6 & R7 MSB in R6, LSB in R7. 
;long,  unsigned long                - R4-R7 MSB in R4, LSB in R7. 
;float R4-R7                         - 32-Bit IEEE format. 
;generic pointer                     - R1-R3 Memory type in R3, MSB R2, LSB R1. 

;Upublicznie (udostepnienie na zewnatrz) symbolu zwiazanego z procedura/funkcja (jesli przyjmuje argumenty wejsciowe, to wymaga uzupelnienia symbolu dodatkowym znakiem "podlogi")
		PUBLIC  _WAIT_10US_ASM
		PUBLIC  INWERSJAP1_6_ASM
		
;Zdefiniowanie segmentu kodu wynikowego 				
PRGSEG  SEGMENT CODE
		RSEG    PRGSEG
;Definicja procedury realizujacej opoznienie czasowe bedace dopelnieniem do wartosci maksymalnej 16-bitowej
_WAIT_10US_ASM:
; Odebranie argumentu wejsciowego podanego przy wywolaniu procedury
		MOV DPL,R7   ;Umieszcza mlodszy bajty argumentu wejsciowego w mlodszym bajcie rejestru DPTR (DPL)
		MOV DPH,R6   ;Umieszcza starszy bajt argumentu wejsciowego w starszym bajcie rejestru DPTR (DPH)
;Petla opozniajaca wykorzystujaca wartosc rejestru DPTR jako zmienna iteracyjna			
WAIT_U:
; czterokrotne wykonanie instrukcji NOP, implementujce opoznienie 4us w celu zapewnienia opoznienia rownego 10us dla jednej iteracji petli
		NOP
		NOP
		NOP
		NOP
;Zwiekszenie DPTR o jeden
		INC DPTR
;Przeslanie do akumulatora starszego bajtu DPTR-a
		MOV A,DPH
;Wykonanie sumy logicznej miedzy akumulatorenm a mlodszym bajtem DPTR w celu przygotwania akumulatora do sprawdzenia czy rejestr DPTR ulegl wyzerowaniu
		ORL A,DPL
;Sprawdzenie niezerowego stanu rejestru DPTR poprzez weryfikacje stanu akumulatora ustalonego poprzednia instrukcja sumy logicznej
;Wykonanie skoku do kolejnej iteracji petli jesli akumulator jest rozny od zera (oparciu o powyzsze instrukcji rowniez jesli DPTR jest rozny od zera)
		JNZ WAIT_U
;Powrot z procedury		
		RET
;Etykieta rozpoczynajaca procedure INWERSJAP1_6_A
INWERSJAP1_6_ASM:
; Inwersja bitu 6 portu P1, ktory steruje dioda L8
	CPL P1.6 
;Powrot z procdury (podprogramu) - skok bezwarunkowy pod adres zapisany na stosie
	RET
	
;Dyrektywa asemblera konczaca kod zrodlowy
	END

