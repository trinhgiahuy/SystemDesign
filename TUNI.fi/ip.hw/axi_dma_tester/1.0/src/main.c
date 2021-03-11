#include "ac_fixed.h"
#include "ac_channel.h"

typedef ac_int<8,false>  uint_8;
typedef ac_int<16,false> uint_16;
typedef ac_int<32,false> uint_32;
typedef ac_int<64,false> uint_64;
typedef ac_int<8,true>   int_8;
typedef ac_int<16,true>  int_16;
typedef ac_int<32,true>  int_32;
typedef ac_int<64,true>  int_64;
typedef ac_int<1,false>  one_bit;

void axi_dma_write_testeri(ac_channel<uint_32> &config,ac_channel<uint_64> &data_out,ac_channel<uint_64> &data_in,uint_64 onchip_in[512],uint_64 onchip_out[512],one_bit *irq_read,one_bit *irq_write)
{
    uint_8 leveys = config.read();
    *irq_read = 0;
    *irq_write = 0;
    uint_16 index = 0;
    if(leveys != 0)
    {
        uint_16 loops = ((leveys*leveys)>>3)-1;
        for(index = 0; index < 512;index++)
        {
            data_out.write(onchip_in[index]);
            if(index == loops)
            {
                *irq_write = 1;
                break;
            }
        }
        for(index = 0; index < 512;index++)
        {
            onchip_out[index] = data_in.read();
            if(index == loops)
            {
                *irq_read = 1;
                break;
            }
        }
    }
}