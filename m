Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0063A5810C
	for <dm-devel@lists.linux.dev>; Thu, 11 Jan 2024 20:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=lists.ewheeler.net
Received: from localhost (localhost [127.0.0.1])
	by mx.ewheeler.net (Postfix) with ESMTP id E472D4B;
	Thu, 11 Jan 2024 12:44:44 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
	by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id SLuhntzPRzcB; Thu, 11 Jan 2024 12:44:40 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.ewheeler.net (Postfix) with ESMTPSA id 414AE45;
	Thu, 11 Jan 2024 12:44:40 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 414AE45
Date: Thu, 11 Jan 2024 12:44:40 -0800 (PST)
From: Eric Wheeler <dm-devel@lists.ewheeler.net>
To: Xiao Ni <xni@redhat.com>
cc: Joe Thornber <thornber@redhat.com>, dm-devel@lists.linux.dev, 
    Heinz Mauelshagen <heinzm@redhat.com>, 
    Mikulas Patocka <mpatocka@redhat.com>, 
    "Snitzer, Mike" <snitzer@redhat.com>, 
    Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: Stuck IOs with dm-integrity + md raid1 + dm-thin
In-Reply-To: <CALTww2-kBfJw2uNTp8JgMz5=MZKFKGP=ATAC42=Wf7hWJfPT1A@mail.gmail.com>
Message-ID: <675735af-bee2-e448-bb77-40b91c83e29f@ewheeler.net>
References: <fb4ae62-522-e262-df25-c82e8acf8baf@ewheeler.net> <CALTww2-kBfJw2uNTp8JgMz5=MZKFKGP=ATAC42=Wf7hWJfPT1A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-436906490-1705005880=:26033"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-436906490-1705005880=:26033
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 11 Jan 2024, Xiao Ni wrote:
> On Wed, Nov 29, 2023 at 10:10 AM Eric Wheeler
> <dm-devel@lists.ewheeler.net> wrote:
> >
> > Hi Joe,
> >
> > I'm not sure who else to CC on this issue, feel free to add others.
> >
> > Recently we tried putting dm-integrity on NVMe's under MD RAID1 with
> > dm-thin metadata (tmeta) on that raid1 mirror (Linux v6.5.7).  It worked
> > fine for ~12 hours and then, at ~3:30 am in the morning when we do a
> > reserve_metadata_snap and thin_dump's, IO's began to hang.
> >
> > For reference, we have been using the same block device stack for years,
> > and it is quite stable.  We've been running Linux v6.5.7 for about 6 weeks
> > without issue until we tried dm-integrity under dm-thin.  The stack
> > _without_ dm-integrity looks like this:
> >
> >     nvme{0,1} =>
> >         raid mirror /dev/md0 =>
> >             LVM PV for VG "data" =>
> >                 tmeta for dm-thin
> >
> >     /dev/sda (LSI-based Hardware RAID)
> >         bcache =>
> >             LVM PV for VG "data" =>
> >                 tdata for dm-thin "pool0" =>
> >                     single thin volume from the pool =>
> >                         drbd to another host over the network
> >
> > After adding dm-integrity, the stack is the same as above except that
> > the RAID mirror is above dm-integrity:
> >
> >     nvme{0,1} =>
> >         dm-integrity =>
> >             raid mirror /dev/md0 =>
> >                 LVM PV for VG "data" =>
> >                     tmeta for dm-thin
> >
> > The first time we had the thindump+IO hang problem we thought that an
> > underlying NVMe drive was bad, so we replaced both: We rebooted and did
> > a `pvmove` of the tmeta volume to different NVMe+md-raid1+dm-integrity
> > on disks that were brand new, but had the same issue that night during
> > reserve_metadata_snap+thin_dump.
> >
> > Since we had the same problem on a different set of new NVMe disks, we
> > rebooted, did a `pvmove` back to the original MD RAID1 mirror stack
> > _without_ dm-integrity, and everything was back to normal.  Thus, I do not
> > think it is a disk or tmeta corruption issue, but an obscure race or
> > deadlock bug.
> >
> > We tried to reproduce this in a virtual environment, but so far it has not
> > triggered. In about a week when we get downtime for this system, I will
> > take a copy of its thin metadata to inspect further. For now, I have not
> > yet been enable to reproduce problem outside our semi-production testing
> > environment.
> >
> > So, this is what we see so far:
> >
> > We get _thousands_ of these lines in the kernel logs when IO hangs. The
> > `dm-175` device is one of the the dm-integrity targets being mirrored.
> > Note the "12924 callbacks suppressed" message:
> >
> >         [  +0.584816] raid1_end_read_request: 12924 callbacks suppressed
> >         [  +0.000006] md/raid1:md0: dm-175: rescheduling sector 1979682216
> >         [  +0.020011] md/raid1:md0: dm-175: rescheduling sector 1979682216
> >         [  +0.019462] md/raid1:md0: dm-175: rescheduling sector 1979682216
> >         [  +0.018672] md/raid1:md0: dm-175: rescheduling sector 1979682216
> >         [  +0.006242] md/raid1:md0: dm-175: rescheduling sector 1979682216
> >         [  +0.002399] md/raid1:md0: dm-175: rescheduling sector 1979682216
> >         [  +0.000934] md/raid1:md0: dm-175: rescheduling sector 1979682216
> >         [  +0.000688] md/raid1:md0: dm-175: rescheduling sector 1979682216
> >         [  +0.001161] md/raid1:md0: dm-175: rescheduling sector 1979682216
> >         [  +0.006404] md/raid1:md0: dm-175: rescheduling sector 1979682216
> >         [  +3.594380] integrity_metadata: 13095 callbacks suppressed
> >         [  +0.000006] device-mapper: integrity: dm-175: Checksum failed at sector 0x760395b0
> >         [  +0.001410] device-mapper: integrity: dm-175: Checksum failed at sector 0x760395b0
> >         [  +0.000824] device-mapper: integrity: dm-175: Checksum failed at sector 0x760395b0
> >         [  +0.003587] device-mapper: integrity: dm-175: Checksum failed at sector 0x760395b0
> >         [  +0.011065] device-mapper: integrity: dm-175: Checksum failed at sector 0x760395b0
> >         [  +0.004176] device-mapper: integrity: dm-175: Checksum failed at sector 0x760395b0
> >         [  +0.000604] device-mapper: integrity: dm-175: Checksum failed at sector 0x760395b0
> >         [  +0.006153] device-mapper: integrity: dm-175: Checksum failed at sector 0x760395b0
> >         [  +0.008797] device-mapper: integrity: dm-175: Checksum failed at sector 0x760395b0
> >         [  +0.002350] device-mapper: integrity: dm-175: Checksum failed at sector 0x760395b0
> >         [  +0.668866] raid1_read_request: 12747 callbacks suppressed
> >         [  +0.000005] md/raid1:md0: redirecting sector 1979682216 to other mirror: dm-175
> >         [  +0.024708] md/raid1:md0: redirecting sector 1979682216 to other mirror: dm-175
> >         [  +0.024441] md/raid1:md0: redirecting sector 1979682216 to other mirror: dm-175
> >         [  +0.018321] md/raid1:md0: redirecting sector 1979682216 to other mirror: dm-175
> >         [  +0.000850] md/raid1:md0: redirecting sector 1979682216 to other mirror: dm-175
> >         [  +0.004479] md/raid1:md0: redirecting sector 1979682216 to other mirror: dm-175
> >         [  +0.001225] md/raid1:md0: redirecting sector 1979682216 to other mirror: dm-175
> >         [  +0.001024] md/raid1:md0: redirecting sector 1979682216 to other mirror: dm-175
> >         [  +0.000741] md/raid1:md0: redirecting sector 1979682216 to other mirror: dm-175
> >         [  +0.001094] md/raid1:md0: redirecting sector 1979682216 to other mirror: dm-175
> 
> Hi all
> 
> The process is as follows and I add some logs
> 1. raid1_read_request submits bio to read data
> 2. raid1_end_read finds the read request fails and try to fix the read error
> 3. handle_read_error>fix_read_error tries to read data in 4K unit in
> another disk, write to the failed disk in 4K unit and read from the
> failed disk in 4K unit. fix_read_error finishes successfully.
> 4. handle_read_error re-read data from the failed disk. And the read
> request fails again.
> [ 1067.149829] device-mapper: integrity: dm-3: Checksum failed at sector 0x17d8
> [ 1067.149842] md/raid1:md9: dm-3: rescheduling sector 3912, sectors 248
> [ 1067.150437] md/raid1:md9: dm-3: fix read error 3912, sectors 248
> [ 1067.150439] md/raid1:md9: dm-3: re read 3912, sectors 248
> 
> It looks like the bio size is suspicious. Because it reads
> successfully when bio size is 4K.

Hi Xiao, thanks for looking into this.  

It looks like the problem can be reproduced using 4k blocks as well, but
I suppose its still possible that some 512-byte (4k-unaligned) IO is
happening somewhere in the device stack.

The script below changes the null_blk modprobe to set bs=4096 and uses
zram instead of brd because zram only supports 4k blocks:

# blockdev --getss /dev/mapper/pv /dev/zram[01]
4096
4096
4096

The script below has been added to the Jira ticket:
	https://issues.redhat.com/browse/RHEL-20912

--
Eric Wheeler

Script to trigger the bug with 4k blocks:

# cat dm-integrity-thin-lvraid-zram-4k
#!/bin/bash

# Notice: /dev/zram0 and /dev/zram1 will be wiped unconditionally.

# Configure these if you need to:
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
	dmsetup remove pv
	dmsetup remove zram0
	dmsetup remove zram1
	lvmdevices --deldev /dev/mapper/pv
	losetup -d /dev/loop?
	rmmod zram
	rmmod null_blk
	echo ==== reset done
	sleep 1
}

do_init()
{
	modprobe null_blk gb=30000 bs=4096

	modprobe zram num_devices=2
	echo 1g > /sys/block/zram0/disksize
	echo 1g > /sys/block/zram1/disksize

	# Create a writable header for the PV meta:
	dd if=/dev/zero bs=1M count=16 oflag=direct of=/tmp/pvheader
	loop=`losetup -f --show /tmp/pvheader`
	linear_add pv $loop /dev/nullb0

	# Create the VG
	sleep 1
	#linear_add zram0 /dev/zram0
	#linear_add zram1 /dev/zram1
	lvmdevices --adddev /dev/zram0
	lvmdevices --adddev /dev/zram1
	lvmdevices --adddev /dev/mapper/pv
	vgcreate $VGNAME /dev/mapper/pv /dev/zram[01]

	# Create the pool:
	lvcreate -n pool0 -L 1T $VGNAME /dev/mapper/pv
	lvcreate --type raid1 --raidintegrity y -m1 -L 512m -n meta0 $VGNAME /dev/zram[01]

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

--8323328-436906490-1705005880=:26033--
