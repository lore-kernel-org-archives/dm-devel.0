Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E50633
	for <dm-devel@lists.linux.dev>; Fri,  1 Dec 2023 00:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=lists.ewheeler.net
Received: from localhost (localhost [127.0.0.1])
	by mx.ewheeler.net (Postfix) with ESMTP id 3091985;
	Thu, 30 Nov 2023 16:40:05 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
	by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id l6pBSt9N_CLz; Thu, 30 Nov 2023 16:40:00 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.ewheeler.net (Postfix) with ESMTPSA id 2BCC340;
	Thu, 30 Nov 2023 16:40:00 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 2BCC340
Date: Thu, 30 Nov 2023 16:40:00 -0800 (PST)
From: Eric Wheeler <dm-devel@lists.ewheeler.net>
To: Joe Thornber <thornber@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: Re: Stuck IOs with dm-integrity + md raid1 + dm-thin
In-Reply-To: <bb6deb36-dd80-1649-11b6-bdcf24cb4e4@ewheeler.net>
Message-ID: <7bcbab39-9ad0-4e9-d49e-5c229689915f@ewheeler.net>
References: <fb4ae62-522-e262-df25-c82e8acf8baf@ewheeler.net> <CAJ0trDaipa_80xqVpDkJdm-SSCaN7g_O-m9-StG10P_DUxmtEA@mail.gmail.com> <CAJ0trDbP4BFjb0KQ+t4Lh1JdVjP9sbMiwJEOXPkGEV_R95rFoQ@mail.gmail.com> <12d141ed-84d2-411f-3e61-7a8d5bc7f0dc@ewheeler.net>
 <CAJ0trDaRQaDicO9ho8Hokj68vEopaJwM8YKwPEjzYkWBXE0dWg@mail.gmail.com> <cb3f4665-fcfc-c08-2dce-99c071c2a569@ewheeler.net> <bb6deb36-dd80-1649-11b6-bdcf24cb4e4@ewheeler.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-93319984-1701391200=:29635"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-93319984-1701391200=:29635
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 30 Nov 2023, Eric Wheeler wrote:
> On Thu, 30 Nov 2023, Eric Wheeler wrote:
> > On Thu, 30 Nov 2023, Joe Thornber wrote:
> > > On Wed, Nov 29, 2023 at 7:51 PM Eric Wheeler <dm-devel@lists.ewheeler.net> wrote:
> > > 
> > > Have you performed any long running tests with just dm-integrity and not dm-thin?
> > 
> > It ran fine for about 12 hours and then IOs hung shortly after we did a 
> > reserve_metadata_snap.
> 
> More info:
> 
> Not only did it run for 12 hours just fine before IOs hung at 3:30am when 
> we do metadata dumps, but this happened twice, on consecutive days at the 
> same time of day (~3:30am), when cron does a reserve_metadata_snap for
> metadata thin_dumps of inactive snapshots.
 
Here is a reproducer using ram disks, it hangs quickly on my test VM
with all the kernels I tested.  Here are a few example versions:

 - 6.5.7 vanilla
 - 5.14.0-362.8.1.el9_3
 - 5.14.0-162.12.1.el9_1

Watch dmesg and you'll eventually see errors like this:

	device-mapper: integrity: dm-6: Checksum failed at sector 0x17d8
	md/raid1:md9: dm-6: rescheduling sector 3912
	md/raid1:md9: redirecting sector 3912 to other mirror: dm-6
	raid1_read_request: 18950 callbacks suppressed

---------------------------------------------------------------
#!/bin/bash

# Notice: /dev/ram0 and /dev/ram1 will be wiped unconditionally.

# Configure these if you need to:
MD_DEV=/dev/md9
VGNAME=testvg
LVNAME=thin
LVSIZE=$((10 * 1024*1024*1024/512))

echo "NOTICE: THIS MAY BE UNSAFE. ONLY RUN THIS IN A TEST ENVIRONMENT!"
echo "Press enter twice to continue or CTRL-C to abort."

read
read

set -x

# append disks into a linear target
linear_add()
{
	name=$1
	shift

	prevsize=0
	for vol in "$@"; do
		size=`blockdev --getsize $vol`
		echo "$prevsize $size linear $vol 0"
		prevsize=$size
	done \
		| dmsetup create $name

	echo /dev/mapper/$name
}

lvthin_add()
{
	id=$1
	lvcreate -An -V $LVSIZE -n $LVNAME$id --thinpool pool0 $VGNAME >&2
	echo /dev/$VGNAME/$LVNAME$id
}

lvthin_snapshot()
{
	origin=$1
	id=$2

	lvcreate -An -s $VGNAME/$LVNAME$origin -n $LVNAME$id >&2
	echo /dev/$VGNAME/$LVNAME$id
}

fio()
{
	dev=$1
	/bin/fio --name=$dev --rw=randrw --direct=1 --bs=512 --numjobs=1 --filename=$dev --time_based --runtime=$FIOTIME --ioengine=libaio --iodepth=1 &> /dev/null
}

do_reset()
{
	killall -9 fio
	lvchange -an $VGNAME
	rmdir /dev/$VGNAME
	dmsetup remove ssd
	dmsetup remove pv
	lvmdevices --deldev /dev/mapper/ssd
	lvmdevices --deldev /dev/mapper/pv
	losetup -d /dev/loop?
	mdadm --stop $MD_DEV
	integritysetup close /dev/mapper/dm-integrity0
	integritysetup close /dev/mapper/dm-integrity1
	rmmod brd
	rmmod null_blk
	echo ==== reset done
	sleep 1
}

do_init()
{
	modprobe null_blk gb=30000 bs=512

	ramsize_gb=1
	modprobe brd rd_size=$(($ramsize_gb * 1024*1024)) rd_nr=2

	idev0=/dev/ram0
	idev1=/dev/ram1

	integritysetup format $idev0 --integrity xxhash64 --batch-mode
	integritysetup format $idev1 --integrity xxhash64 --batch-mode

	integritysetup open --integrity xxhash64 --allow-discards $idev0 dm-integrity0
	integritysetup open --integrity xxhash64 --allow-discards $idev1 dm-integrity1

	mdadm --create $MD_DEV --metadata=1.2 --assume-clean --level=1 --raid-devices=2 /dev/mapper/dm-integrity[01]

	# 1. This should be enough to trigger it:
	SSD_DEV=$MD_DEV

	# 2. If not, then wrap /dev/md9 in a linear target:
	#linear_add ssd $MD_DEV
	#SSD_DEV=/dev/mapper/ssd

	# Create a writable header for the PV meta:
	dd if=/dev/zero bs=1M count=16 oflag=direct of=/tmp/pvheader
	loop=`losetup -f --show /tmp/pvheader`
	linear_add pv $loop /dev/nullb0

	# Create the VG
	lvmdevices --adddev $SSD_DEV
	lvmdevices --adddev /dev/mapper/pv
	vgcreate $VGNAME /dev/mapper/pv $SSD_DEV

	# Create the pool:
	lvcreate -n pool0 -L 1T $VGNAME /dev/mapper/pv
	lvcreate -n meta0 -L 512m $VGNAME $SSD_DEV

	# Make sure the meta volume is on the SSD (it should be already from above):
	pvmove -n meta0 /dev/mapper/pv
	lvconvert -y --force --force --chunksize 64k --type thin-pool --poolmetadata $VGNAME/meta0 $VGNAME/pool0
}


while true; do
	do_reset
	do_init

	thin1=`lvthin_add 1`
	fio $thin1 &

	thin2=`lvthin_snapshot 1 2`
	fio $thin2 &

	wait

done

--8323328-93319984-1701391200=:29635--
