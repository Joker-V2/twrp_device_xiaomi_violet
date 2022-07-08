echo 'Starting to clone stuffs needed for your device'

echo 'Cloning Kernel tree [1/2]'
# Kernel Tree
git clone --depth=1 https://github.com/SuperiorOS-Devices/kernel_xiaomi_violet.git -b erofs kernel/xiaomi/violet

echo 'Cloning Proton clang [2/2]'
# Proton Clang
git clone --depth=1 https://github.com/kdrag0n/proton-clang.git prebuilts/clang/host/linux-x86/clang-proton

echo 'Completed, Now proceeding to lunch'
