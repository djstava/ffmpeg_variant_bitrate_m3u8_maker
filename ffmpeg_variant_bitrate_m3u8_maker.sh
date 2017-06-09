#!/bin/sh

if [ $# != 2 ];then
echo "Usage: $0 videofilename"
exit 1;
fi

BITRATE_HIGH = 3M
BITRATE_MEDIUM = 1M
BITRATE_LOW = 500K

mkdir -p $1/$1-3M
mkdir -p $1/$1-1M
mkdir -p $1/$1-500k

ffmpeg -i $1 -acodec aac -strict -2 -map 0  -f segment -vbsf h264_mp4toannexb -flags -global_header  -segment_format mpegts -segment_list_type m3u8 -vcodec libx264 -crf 20 -b:v 2600k -maxrate 2600k -bufsize 2600k -g 30 -segment_list $1-3M/$1-3M.m3u8  $1-3M/$1-%04d.3M.ts ;

ffmpeg -i $1 -acodec aac -strict -2 -ab 128k  -map 0  -f segment -vbsf h264_mp4toannexb -flags -global_header  -segment_format mpegts -segment_list_type m3u8 -vcodec libx264 -vf "yadif=0, scale=1280:720" -crf 20 -b:v 900k -maxrate 900k -bufsize 900k -g 30 -segment_list $1-1M/$1-1M.m3u8  $1-1M/$1-%04d.1M.ts ;

ffmpeg -i $1 -acodec aac -strict -2 -ab 64k  -map 0  -f segment -vbsf h264_mp4toannexb -flags -global_header  -segment_format mpegts -segment_list_type m3u8 -vcodec libx264 -vf "yadif=0, scale=640:360" -crf 20 -b:v 450k -maxrate 450k -bufsize 450k -g 30 -segment_list $1-500k/$1-500k.m3u8  $1-500k/$1-%04d.500k.ts ;

echo "#EXTM3U" > $1.m3u8
echo "#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=500000" >> $1.m3u8
echo "$1-500k/$1-500k.m3u8" >> $1.m3u8
echo "#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=1000000" >> $1.m3u8
echo "$1-1M/$1-1M.m3u8" >> $1.m3u8
echo "#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=3000000" >>  $1.m3u8
echo "$1-3M/$1-3M.m3u8"  >> $1.m3u8

done
