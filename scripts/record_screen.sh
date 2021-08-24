#!/bin/sh

# http://patorjk.com/software/taag/#p=display&h=2&f=Ivrit&t=Vasu's%0AScreen%20Recorder
cat << "EOF"
__     __              _
 \ \   / /_ _ ___ _   _( )___
  \ \ / / _` / __| | | |// __|
   \ V / (_| \__ \ |_| | \__ \
    \_/ \__,_|___/\__,_| |___/
  ____                             ____                        _
 / ___|  ___ _ __ ___  ___ _ __   |  _ \ ___  ___ ___  _ __ __| | ___ _ __
 \___ \ / __| '__/ _ \/ _ \ '_ \  | |_) / _ \/ __/ _ \| '__/ _` |/ _ \ '__|
  ___) | (__| | |  __/  __/ | | | |  _ <  __/ (_| (_) | | | (_| |  __/ |
 |____/ \___|_|  \___|\___|_| |_| |_| \_\___|\___\___/|_|  \__,_|\___|_|

EOF

current_time=$(date +"%Y-%m-%d-%H-%M-%S")
output_dir="$HOME/Videos/screen_recordings/$current_time"
mkdir -p $output_dir
cd $output_dir

output_filename="recording_${current_time}"
filenames_filename="filenames.ffconcat"

handler() {
    wait
}

trap "handler" INT

printf "\
Your screen recordings will be available in this folder:

    $output_dir

$(tput setaf 2)$(tput bold)Use Ctrl-C to stop recording and exit.$(tput sgr0)

"

# Resources used:
# https://unix.stackexchange.com/questions/14979/how-to-record-my-full-screen-with-audio
# https://trac.ffmpeg.org/wiki/Capture/Desktop
# https://superuser.com/questions/820747/slicing-video-file-into-several-segments
# https://www.ffmpeg.org/ffmpeg-formats.html#segment_002c-stream_005fsegment_002c-ssegment
# https://superuser.com/questions/326629/how-can-i-make-ffmpeg-be-quieter-less-verbose
# https://stackoverflow.com/questions/7333232/how-to-concatenate-two-mp4-files-using-ffmpeg
screen_size=$(xdpyinfo | awk '/dimensions:/{printf $2}')
# ffmpeg \
#     -hide_banner \
#     -f x11grab \
#     -video_size $screen_size \
#     -framerate 30 \
#     -i :0.0 \
#     -f alsa \
#     -i default \
#     -vcodec libx264 \
#     -qp 0 \
#     -preset ultrafast \
#     -f segment \
#     -segment_time 00:10:00.000 \
#     -segment_list $filenames_filename \
#     -reset_timestamps 1 \
#     "${output_filename}_%04d.mp4" &

# https://askubuntu.com/questions/892482/how-to-record-desktop-with-audio-on-ffmpeg
# ffmpeg \
#     -f x11grab \
#     -framerate 30 \
#     -video_size $screen_size \
#     -i :0.0 \
#     -f alsa \
#     -i default \
#     -async 1 \
#     -c:v libx264 \
#     -crf 28 \
#     -preset ultrafast \
#     -f segment \
#     -segment_time 00:10:00.000 \
#     -segment_list $filenames_filename \
#     -reset_timestamps 1 \
#     "${output_filename}_%04d.mp4" &

# https://www.linuxquestions.org/questions/linux-software-2/ffmpeg-video-is-out-of-sync-4175474651/
ffmpeg \
    -hide_banner \
    -v quiet -stats \
    -f alsa \
    -i default \
    -f x11grab \
    -r 15 \
    -video_size $screen_size \
    -i :0.0 \
    -c:a libmp3lame \
    -b:a 192k \
    -c:v libx264 \
    -crf 23 \
    -f segment \
    -segment_time 00:10:00.000 \
    -segment_list $filenames_filename \
    -reset_timestamps 1 \
    "${output_filename}_%04d.mp4" &

wait

printf "$(tput setaf 3)$(tput bold)Combining files - please don't exit! $(tput sgr0)"

ffmpeg \
    -hide_banner \
    -loglevel warning \
    -f concat \
    -i $filenames_filename \
    -c copy \
    $output_filename.mp4

echo "Your screen recording is at:\n\n\t`pwd`/$output_filename.mp4\n"
