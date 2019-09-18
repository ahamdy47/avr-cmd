// uart lib

#include "uart.h"

char str[] = "apple"; 
char* msg = (char*)"lite";
char camb[32];
char c;
double fl;

int main(){
	//_delay_ms(3000);
	serial_init();
	
	//strcpy(msg, "lite") ;

	while(1){
		/*serial_write('A');
		serial_write('P');
		serial_write('P');
		serial_write('L');
		serial_write('E');
		serial_write('\n');
		serial_write('\r');*/

		serial_write("sing");
		serial_write("\n\r");
		serial_writeln(32000);
		/*serial_write('C');
		serial_write('\n');
		serial_write('\r');
		serial_writeln(7053.14);
		serial_writeln(70053.14);
		serial_writeln(700053.14);
		serial_write(7000053.14);
		serial_write("\n\r");
		serial_write(70000053.14);
		serial_writeln();*/
		_delay_ms(500);
		//hile(strcmp(serial_read(), "") == 0) {
			//msg = serial_read();
			
		//}
		//serial_writeln(c);
		serial_read(camb);
		//serial_writeln(UDR0);
		//c = serial_read();
		fl = atof(camb);
		serial_writeln(camb);
		serial_writeln(fl);
		msg = (char *) "fire";
	}
	return 0;
}