#include "main.h"
#include <stdio.h> // Dodane dla funkcji sprintf()

// Prototyp funkcji disptext_led
void disptext_led(unsigned char *text);

unsigned char xdata LCDBUF[42];
unsigned char Licznik;
unsigned char ZM1 = 2;
unsigned char xdata POT0_ADC _at_ 0x8005; // POT0 jako wejście ADC
unsigned char xdata POT1_ADC _at_ 0x8006; // POT1 jako wejście ADC
unsigned char xdata POT2_ADC _at_ 0x8007; // POT2 jako wejście ADC
unsigned char xdata PTSEG _at_ 0X8018;
unsigned char xdata PTIO _at_ 0x8008;
unsigned char xdata PTAC _at_ 0x8000;
sbit P1_6 = P1^6;

void main(void) {
    unsigned int pot0_value = 0; // Zdefiniowanie zmiennej pot0_value
    unsigned int pot1_value = 0; // Zdefiniowanie zmiennej pot1_value
    unsigned int pot2_value = 0; // Zdefiniowanie zmiennej pot2_value
    unsigned char last_potentiometer = 1; // Zmienna przechowująca informację o ostatnio zmienionym potencjometrze
    
    Licznik = 0;
    prglcd();
    
    while(1) {
        WAIT_10US(25000U);
        INWERSJAP1_6();
        disptext(LCDBUF); // Tutaj wyświetlamy na W-LCD
        
        // Odczyt wartości z potencjometra POT0
        POT0_ADC = 0x00; // Ustawienie kanału ADC na POT0
        WAIT_10US(50); // Oczekiwanie na ustabilizowanie się sygnału
        pot0_value = POT0_ADC * 5UL / 255; // Odczyt wartości z ADC
        
        // Odczyt wartości z potencjometra POT1
        POT1_ADC = 0x00; // Ustawienie kanału ADC na POT1
        WAIT_10US(50); // Oczekiwanie na ustabilizowanie się sygnału
        pot1_value = POT1_ADC * 5UL / 255; // Odczyt wartości z ADC
        
        // Odczyt wartości z potencjometra POT2
        POT2_ADC = 0x00; // Ustawienie kanału ADC na POT2
        WAIT_10US(50); // Oczekiwanie na ustabilizowanie się sygnału
        pot2_value = POT2_ADC * 5UL / 255; // Odczyt wartości z ADC
        
        // Sprawdzenie, który potencjometr miał ostatnio zmienioną wartość
        if (pot0_value != pot1_value && pot0_value != pot2_value) {
            last_potentiometer = 0; // POT0 miał ostatnio zmienioną wartość
        } else if (pot1_value != pot0_value && pot1_value != pot2_value) {
            last_potentiometer = 1; // POT1 miał ostatnio zmienioną wartość
        } else {
            last_potentiometer = 2; // POT2 miał ostatnio zmienioną wartość
        }
        
        // Konwersja wartości potencjometra na tekst i umieszczenie w buforze LCDBUF
        if (last_potentiometer == 0) {
            sprintf(&LCDBUF[16], "POT0 value: %i     ", pot0_value);
        } else if (last_potentiometer == 1) {
            sprintf(&LCDBUF[16], "POT1 value: %i     ", pot1_value);
        } else {
            sprintf(&LCDBUF[16], "POT2 value: %i     ", pot2_value);
        }
    }
}

void INWERSJAP1_6() {
#ifdef ASM_EXAMPLE
    INWERSJAP1_6_ASM();
#else
    P1_6 = !P1_6;
#endif
}

void WAIT_10US(unsigned int wait) {
#ifdef ASM_EXAMPLE
    WAIT_10US_ASM(-wait);
#else
    wait = (wait * 10UL) / 11UL;
    while (--wait) _nop_();
#endif
}
