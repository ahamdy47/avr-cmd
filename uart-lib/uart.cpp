#include "uart.h"

void serial_init(){
	UBRR0H = BAUD_RATE>>8;
	UBRR0L = BAUD_RATE;
	UCSR0A = (1<<U2X0);
	UCSR0B = (1<<RXEN0) | (1<<TXEN0);
	UCSR0C = (1<<UCSZ01) | (1<<UCSZ00);
	while ((UCSR0A & _BV(RXC0) == 0));
	_delay_ms(3000);
}

void serial_read(char return_str[]){
	int i = 0;
	while(1){
		while(!(UCSR0A & (1<<RXC0)));
		return_str[i] = UDR0;
		if(return_str[i] == 0x0D) break;
		i++;
	}
	return_str[i] = '\0';
}

void serial_write(const char str[]){
	int i;
	int length = strlen(str);	
	for(i=0; i<length; i++){
		while((UCSR0A & _BV(UDRE0)) == 0);
		UDR0 = str[i];
	}
}

void serial_write(char c){
	while((UCSR0A & _BV(UDRE0)) == 0);
	UDR0 = c;
}

void serial_write(int num){
	char num_str[32];
	itoa(num, num_str, 10); 

	int i;
	int length = strlen(num_str);	
	for(i=0; i<length; i++){
		while((UCSR0A & _BV(UDRE0)) == 0);
		UDR0 = num_str[i];
	}
}

void serial_write(long int num){
	char num_str[32];
	itoa(num, num_str, 10); 

	int i;
	int length = strlen(num_str);	
	for(i=0; i<length; i++){
		while((UCSR0A & _BV(UDRE0)) == 0);
		UDR0 = num_str[i];
	}
}

void serial_write(double d){
	char d_str[32];
	dtostrf(d, 1, 2, d_str); 

	int i;
	int length = strlen(d_str);	
	for(i=0; i<length; i++){
		while((UCSR0A & _BV(UDRE0)) == 0);
		UDR0 = d_str[i];
	}
}

void serial_writeln(){
	serial_write("\n\r");
}

void serial_writeln(const char str[]){
	serial_write(str);
	serial_writeln();
}

void serial_writeln(char c){
	serial_write(c);
	serial_writeln();
}

void serial_writeln(int num){
	serial_write(num);
	serial_writeln();
}

void serial_writeln(long int num){
	serial_write(num);
	serial_writeln();
}

void serial_writeln(double d){
	serial_write(d);
	serial_writeln();
}