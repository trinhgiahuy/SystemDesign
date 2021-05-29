# create a convenience variable to reference the soc-fpga linux include path
SOC_FPGA_LINUX_SRC_TREE_PATH="/opt/linux-socfpga"

CROSS_COMPILE=arm-linux-gnueabihf-
ARCH=arm

export SOC_FPGA_LINUX_SRC_TREE_PATH
export CROSS_COMPILE
export ARCH

echo ""
echo "Convenience variables:"
echo "SOC_FPGA_LINUX_SRC_TREE_PATH=${SOC_FPGA_LINUX_SRC_TREE_PATH}"
echo "CROSS_COMPILE=${CROSS_COMPILE}"
echo "ARCH=${ARCH}"
echo ""
