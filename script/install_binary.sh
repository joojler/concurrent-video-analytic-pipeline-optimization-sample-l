#!/bin/bash
#This script is supposed to run under directory cva_e2e_sample_l which is generated by script pack_binary.sh
#Please use "sudo" to run this script for installing libva, media-driver and MediaSDK library binaries.

echo "If libva/media-driver/MediaSDK have been installed before, their libraies will be overwrote!"

if [ "$EUID" -ne 0 ]
then
    echo "Please use sudo to run this script"
    exit
fi

cur_home=~
echo "Current home dir $cur_home"
if [[ cur_home == *"root"* ]];
then
    echo "Please use sudo to run this script"
    exit
fi

echo "Install dependent packages"
apt-get -y install libssl-dev dh-autoreconf libgl1-mesa-dev libpciaccess-dev build-essential imagemagick ffmpeg libjpeg-dev libavcodec-dev libavutil-dev libavformat-dev libopencv-dev checkinstall pkg-config libgflags-dev

#install libva binaries
root_path=$PWD

cd $root_path/libva/
echo "Install libva header files and binaries"
set -x
mkdir -p /usr/include/va
/usr/bin/install -c -m 644 va_drm.h /usr/include/va
/usr/bin/install -c -m 644 va_dri2.h va_dricommon.h /usr/include/va
/usr/bin/install -c -m 644 va_backend_glx.h va_glx.h /usr/include/va
mkdir -p /usr/lib/x86_64-linux-gnu
/usr/bin/install -c libva.so.2.900.0 /usr/lib/x86_64-linux-gnu/libva.so.2.900.0
/usr/bin/install -c libva.lai /usr/lib/x86_64-linux-gnu/libva.la
/usr/bin/install -c libva-drm.so.2.900.0T /usr/lib/x86_64-linux-gnu/libva-drm.so.2.900.0
/usr/bin/install -c libva-drm.lai /usr/lib/x86_64-linux-gnu/libva-drm.la
/usr/bin/install -c libva-x11.lai /usr/lib/x86_64-linux-gnu/libva-x11.la
/usr/bin/install -c libva-glx.so.2.900.0T /usr/lib/x86_64-linux-gnu/libva-glx.so.2.900.0
/usr/bin/install -c libva-x11.so.2.900.0T /usr/lib/x86_64-linux-gnu/libva-x11.so.2.900.0
/usr/bin/install -c libva-glx.lai /usr/lib/x86_64-linux-gnu/libva-glx.la
cd /usr/lib/x86_64-linux-gnu && { ln -s -f libva.so.2.900.0 libva.so.2 || { rm -f libva.so.2 && ln -s libva.so.2.900.0 libva.so.2; }; }
cd /usr/lib/x86_64-linux-gnu && { ln -s -f libva.so.2.900.0 libva.so || { rm -f libva.so && ln -s libva.so.2.900.0 libva.so; }; }
cd /usr/lib/x86_64-linux-gnu && { ln -s -f libva-drm.so.2.900.0 libva-drm.so.2 || { rm -f libva-drm.so.2 && ln -s libva-drm.so.2.900.0 libva-drm.so.2; }; }
cd /usr/lib/x86_64-linux-gnu && { ln -s -f libva-drm.so.2.900.0 libva-drm.so || { rm -f libva-drm.so && ln -s libva-drm.so.2.900.0 libva-drm.so; }; }
cd /usr/lib/x86_64-linux-gnu && { ln -s -f libva-x11.so.2.900.0 libva-x11.so.2 || { rm -f libva-x11.so.2 && ln -s libva-x11.so.2.900.0 libva-x11.so.2; }; }
cd /usr/lib/x86_64-linux-gnu && { ln -s -f libva-x11.so.2.900.0 libva-x11.so || { rm -f libva-x11.so && ln -s libva-x11.so.2.900.0 libva-x11.so; }; }
cd /usr/lib/x86_64-linux-gnu && { ln -s -f libva-glx.so.2.900.0 libva-glx.so.2 || { rm -f libva-glx.so.2 && ln -s libva-glx.so.2.900.0 libva-glx.so.2; }; }
cd /usr/lib/x86_64-linux-gnu && { ln -s -f libva-glx.so.2.900.0 libva-glx.so || { rm -f libva-glx.so && ln -s libva-glx.so.2.900.0 libva-glx.so; }; }
mkdir -p /usr/include/va
cd $root_path/libva/
/usr/bin/install -c -m 644  va.h va_backend.h va_backend_vpp.h va_compat.h va_dec_av1.h va_dec_hevc.h va_dec_jpeg.h va_dec_vp8.h va_dec_vp9.h va_drmcommon.h va_egl.h va_enc_hevc.h va_enc_h264.h va_enc_jpeg.h va_enc_vp8.h va_fei.h va_fei_h264.h va_enc_mpeg2.h va_fei_hevc.h va_enc_vp9.h va_str.h va_tpi.h va_version.h va_vpp.h va_x11.h /usr/include/va
mkdir -p /usr/lib/x86_64-linux-gnu/pkgconfig
/usr/bin/install -c -m 644 libva.pc libva-drm.pc libva-x11.pc libva-glx.pc /usr/lib/x86_64-linux-gnu/pkgconfig
cp $root_path/libva-utils/vainfo /usr/bin/
set +x 

echo "Install media-driver binaries to  /usr/lib/x86_64-linux-gnu/"
cd $root_path
set -x 
mkdir -p /usr/lib/x86_64-linux-gnu/dri/
cp media-driver/iHD_drv_video.so /usr/lib/x86_64-linux-gnu/dri/iHD_drv_video.so
cp media-driver/libigfxcmrt.so /usr/lib/x86_64-linux-gnu/
set +x

echo "Install MediaSDK binaries to /opt/intel/mediasdk/"
cd $root_path
set -x 
cd $root_path/MediaSDK
mkdir -p /opt/intel/mediasdk/share/mfx
mkdir -p /opt/intel/mediasdk/include
mkdir -p /opt/intel/mediasdk/lib/mfx
cp -rf include/* /opt/intel/mediasdk/include/
cp -rf lib/* /opt/intel/mediasdk/lib/
cp -rf share/* /opt/intel/mediasdk/share
ln -n /opt/intel/mediasdk/lib/libmfxhw64.so.1.34 /opt/intel/mediasdk/lib/libmfxhw64.so || { rm -f /opt/intel/mediasdk/lib/libmfxhw64.so && ln -n /opt/intel/mediasdk/lib/libmfxhw64.so.1.34 /opt/intel/mediasdk/lib/libmfxhw64.so; }
set +x

echo "Add enviroment setting command line to ~/.bashrc"

va_env_set=`grep "LIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri" ~/.bashrc -c`

if (( va_env_set == 0 )) 
then
set -x
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu:/usr/lib
    export LIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri
    export LIBVA_DRIVER_NAME=iHD
    export MFX_HOME=/opt/intel/mediasdk
set +x
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu:/usr/lib' >> ~/.bashrc
    echo "export LIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri" >> ~/.bashrc
    echo "export LIBVA_DRIVER_NAME=iHD" >> ~/.bashrc
    echo "export MFX_HOME=/opt/intel/mediasdk" >> ~/.bashrc

fi

if [[ $LD_LIBRARY_PATH != *"/opt/intel/mediasdk/lib/"* ]]
then
    export LD_LIBRARY_PATH="/opt/intel/mediasdk/lib/:$LD_LIBRARY_PATH"
    echo 'export LD_LIBRARY_PATH="/opt/intel/mediasdk/lib/:$LD_LIBRARY_PATH"' >> ~/.bashrc
fi

openvino_env_set=`grep "intel/openvino_2021/bin/setupvars.sh" ~/.bashrc -c`
if (( openvino_env_set == 0 )) 
then
    if [ -f ~/intel/openvino/bin/setupvars.sh ]
    then
        echo "source ~/intel/openvino_2021/bin/setupvars.sh" >> ~/.bashrc
    elif [ -f /opt/intel/openvino/bin/setupvars.sh ]
    then
        echo "source /opt/intel/openvino_2021/bin/setupvars.sh" >> ~/.bashrc
    fi
fi    

if [[ -d $cl_cache_dir ]];
then
    echo "cl_cache is enabled. \$cl_cache_dir : $cl_cache_dir"
else
    echo "Add enabling cl_cache commands to ~\.bashrc"
    set -x
    mkdir -p ~/cl_cache
    export cl_cache_dir=~/cl_cache
    echo "mkdir -p ~/cl_cache" >> ~/.bashrc
    echo "export cl_cache_dir=~/cl_cache" >> ~/.bashrc
fi

cd $root_path
source ./download_and_copy_models.sh
echo "Please run vainfo firstly to check if media driver has been installed successfully"
echo "After all models are downloaded successfully, you can run ./run_face_detection_test.sh for testing 16-channel 1080p face detection"
echo "Please switch to text mode(No X server) and use root user (su -p) to run the test" 
