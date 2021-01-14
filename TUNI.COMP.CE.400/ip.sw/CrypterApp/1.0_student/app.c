#include <iostream>
#include <iomanip>
#include <stdint.h>

//The key used to encrypt the value
#define KEY 0xDEADBEEF

int main()
{
	//A single value read from the input.
	uint32_t feed;
	//Enrypted value
	uint32_t encrypted_value;
	//Decrypted value
	uint32_t decrypted_value;
		
	//As many loops as there are values.
	while(std::cin >> std::hex >> feed)
	{
		encrypted_value = feed;
		
		//Permutate by switching last two and first two bytes.
		encrypted_value = ( encrypted_value << 16 ) + (uint16_t)( encrypted_value >> 16 );

		//"Crypt" with the key.
		encrypted_value = encrypted_value ^ KEY;
		
		//Decrypt with the key.
		decrypted_value = encrypted_value ^ KEY;
		
		//Undo the permutation.
		decrypted_value = ( decrypted_value << 16 ) + (uint16_t)( decrypted_value >> 16 );

		//Print the result.
		std::cout << std::setfill( '0' ) << std::hex << std::setw( 9 ) << decrypted_value << std::endl;
	}
}