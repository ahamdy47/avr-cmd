#ifndef _UART_H_
#define _UART_H_

#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef F_CPU
#define F_CPU 16000000
#endif

#ifndef BAUD
#define BAUD 9600
#endif 

#define BAUD_RATE (F_CPU / 8 / BAUD) - 1

void serial_init();
void serial_read(char return_str[]);
void serial_write(const char str[]);
void serial_write(char c);
void serial_write(int num);
void serial_write(long int num);
void serial_write(double d);
void serial_writeln();
void serial_writeln(const char str[]);
void serial_writeln(char c);
void serial_writeln(int num);
void serial_writeln(long int num);
void serial_writeln(double d);

#endif