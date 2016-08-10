#include "WProgram.h"

int main(void)
{
	pinMode(LED_BUILTIN, OUTPUT);
	for (;;)
	{
		digitalWrite(LED_BUILTIN, HIGH);
		delay(125);
		digitalWrite(LED_BUILTIN, LOW);
		delay(125);
	}
}

