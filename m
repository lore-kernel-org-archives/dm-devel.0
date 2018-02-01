From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 0/4] dm unstriped: support non power of 2 chunk
	size...
Date: Thu,  1 Feb 2018 19:06:08 +0100
Message-ID: <cover.1517504857.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

Patch series adds support for non power of 2 chunk size to
the "unstriped" target to better suit the striped target
in patch 1.

Patches 2-4 remove the module init error path message,
rename symbols to conform to the target name and avoid
unnecessary headers.


Test script:
------------
#!/bin/sh
#
# Test "unstriped" target non power of 2 chunk size support.
#
# Requires precreated "striped" logical volume as backing device.
# Device will be overwritten!
#
po2=0 # adjust to 1 = power of2, 0 = non-po2
dev=/dev/$vg/$lv # "striped" backing device; adjust to exisiting "striped" LV

table=`dmsetup table $dev`
size=`echo "$table"|awk '{print $2}'`
stripes=`echo "$table"|awk '{print $4}'`
stripesize=`echo "$table"|awk '{print $5}'`
bdstripesize=$stripesize

[ $po2 -eq 0 ] && stripesize=$(($stripesize - 9))
len=$(($size / $stripes / $stripesize * $stripesize))

if [ $po2 -eq 0 ]
then
	dmsetup table $dev | sed "s/$size/$(($len * $stripes))/;s/$bdstripesize/$stripesize/" | dmsetup load $dev
	dmsetup suspend $dev ; dmsetup resume $dev
fi

echo y | mkfs -t ext4 $dev
fsck -fn $dev

devs=""
for i in `seq 0 $(($stripes - 1))`
do
	echo "0 $len unstriped $stripes $stripesize $i $dev 0" | dmsetup create s-$i
	devs="$devs /dev/mapper/s-$i 0"
done

dmsetup create `basename $dev` --table "0 $(($len * $stripes)) striped $stripes $stripesize $devs"
fsck -fn /dev/mapper/`basename $dev`


Example mapping tables resulting from script:
---------------------------------------------
# dmsetup table|egrep "^(nvm-s|s)"
s: 0 270249 striped 3 119 254:7 0 254:8 0 254:9 0
s-2: 0 90083 unstriped 3 119 2 254:6 0
s-1: 0 90083 unstriped 3 119 1 254:6 0
s-0: 0 90083 unstriped 3 119 0 254:6 0
nvm-s: 0 270249 striped 3 119 66:96 13854720 66:64 2048 66:48 2048



Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>

Heinz Mauelshagen (4):
  dm unstriped: support non power of 2 chunk size
  dm unstriped: remove superfluous module init error path message
  dm unstriped: rename symbols to conform to target name
  dm unstriped: remove unnecessary header includes

 Documentation/device-mapper/unstriped.txt |   5 ++
 drivers/md/dm-unstripe.c                  | 109 +++++++++++++-----------------
 2 files changed, 53 insertions(+), 61 deletions(-)

-- 
2.14.3
