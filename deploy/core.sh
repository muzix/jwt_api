/usr/bin/ffmpeg -threads 3 -i rtmp://localhost/live/$1 -c:v libx264 -preset:v ultrafast -vf addroi=iw/4:ih/4:iw/2:ih/2:-1/10 -force_key_frames "expr:gte(t,n_forced*0.5)" -s 1280x720 -b:v 2000K -c:a copy -f flv rtmp://localhost/hls/$1_hi -c:v libx264 -preset:v ultrafast -vf addroi=iw/4:ih/4:iw/2:ih/2:-1/10 -force_key_frames "expr:gte(t,n_forced*0.5)" -s 854x480 -b:v 700K -c:a copy -f flv rtmp://localhost/hls/$1_low 1>>/root/run.log 2>>/root/error.log &
echo $2 > /root/debug.log
arr=(${2//[ ]/ })
if [ "${arr[0]}" = "aa" ]
then
  echo "twitch empty" >> /root/debug.log
else
  /usr/bin/ffmpeg -threads 3 -i rtmp://localhost/live/$1 -c:v copy -c:a copy -f flv "rtmp://live.twitch.tv/app/${arr[0]}" >> /root/debug.log &
fi
if [ "${arr[1]}" = "aa" ]
then
  echo "youtube empty" >> /root/debug.log
else
  /usr/bin/ffmpeg -threads 3 -i rtmp://localhost/live/$1 -c:v copy -c:a copy -f flv "rtmp://a.rtmp.youtube.com/live2/${arr[1]}" >> /root/debug.log &
fi
if [ "${arr[2]}" = "aa" ]
then
  echo "facebook empty" >> /root/debug.log
else
  /usr/bin/ffmpeg -threads 3 -i rtmp://localhost/live/$1 -c:v copy -c:a copy -f flv "rtmps://live-api-s.facebook.com:443/rtmp/${arr[2]}" >> /root/debug.log &
fi
wait
pkill -P $$
echo "All done" >> /root/debug.log
