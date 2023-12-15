Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B244F48CF9
	for <dm-devel@lists.linux.dev>; Fri, 15 Dec 2023 23:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=lists.ewheeler.net
Received: from localhost (localhost [127.0.0.1])
	by mx.ewheeler.net (Postfix) with ESMTP id 0EA4885;
	Fri, 15 Dec 2023 15:27:25 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
	by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id W61pOfmrs3XT; Fri, 15 Dec 2023 15:27:23 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.ewheeler.net (Postfix) with ESMTPSA id 8290E46;
	Fri, 15 Dec 2023 15:27:23 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 8290E46
Date: Fri, 15 Dec 2023 15:26:55 -0800 (PST)
From: Eric Wheeler <dm-devel@lists.ewheeler.net>
To: Heinz Mauelshagen <heinzm@redhat.com>
cc: David Teigland <teigland@redhat.com>, 
    Mikulas Patocka <mpatocka@redhat.com>, Joe Thornber <thornber@redhat.com>, 
    dm-devel@lists.linux.dev
Subject: Re: Stuck IOs with dm-integrity + md raid1 + dm-thin
In-Reply-To: <4f19eefe-4c1e-3e42-2bc1-aa13dec61c@ewheeler.net>
Message-ID: <1eabb725-9556-4038-9148-e6a12ac164d7@ewheeler.net>
References: <fb4ae62-522-e262-df25-c82e8acf8baf@ewheeler.net> <CAJ0trDaipa_80xqVpDkJdm-SSCaN7g_O-m9-StG10P_DUxmtEA@mail.gmail.com> <CAJ0trDbP4BFjb0KQ+t4Lh1JdVjP9sbMiwJEOXPkGEV_R95rFoQ@mail.gmail.com> <12d141ed-84d2-411f-3e61-7a8d5bc7f0dc@ewheeler.net>
 <CAJ0trDaRQaDicO9ho8Hokj68vEopaJwM8YKwPEjzYkWBXE0dWg@mail.gmail.com> <cb3f4665-fcfc-c08-2dce-99c071c2a569@ewheeler.net> <bb6deb36-dd80-1649-11b6-bdcf24cb4e4@ewheeler.net> <7bcbab39-9ad0-4e9-d49e-5c229689915f@ewheeler.net> <ZWolcKU3EIS55zO7@redhat.com>
 <4f19eefe-4c1e-3e42-2bc1-aa13dec61c@ewheeler.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

[ +cc Heinz, Mikulas ]

> > On Tue, 5 Dec 2023, Joe Thornber wrote:
> > > Hi Eric,
> > > 
> > > I just released v1.0.8 of the thinp tools:
> > > 
> > > https://github.com/jthornber/thin-provisioning-tools
> >
> > Interesting, so do these tools play a role in the kernel somehow (ie,
> > kernel rust), or is this just userspace testing?
> 
> The tools issue IO.  LVM runs thin_check during one of the lvcreate 
> calls in your reproducer script.  The way the tools were issuing io was 
> triggering the dm-integrity error. The fact that it then hung we 
> currently believe is an md kernel bug. Mikulas and Heinz are looking 
> into it.

Hi Mikulas and Heinz, 

Joe mentioned that you were looking into this.  Have you been able to 
figure out what might be causing the strange md<=>dm-integrity interaction 
in the kernel?

-Eric

> On Fri, 1 Dec 2023, David Teigland wrote:
> > On Thu, Nov 30, 2023 at 04:40:00PM -0800, Eric Wheeler wrote:
> > > 	integritysetup format $idev0 --integrity xxhash64 --batch-mode
> > > 	integritysetup format $idev1 --integrity xxhash64 --batch-mode
> > > 
> > > 	integritysetup open --integrity xxhash64 --allow-discards $idev0 dm-integrity0
> > > 	integritysetup open --integrity xxhash64 --allow-discards $idev1 dm-integrity1
> > > 
> > > 	mdadm --create $MD_DEV --metadata=1.2 --assume-clean --level=1 --raid-devices=2 /dev/mapper/dm-integrity[01]
> > > 
> > > 	# 1. This should be enough to trigger it:
> > > 	SSD_DEV=$MD_DEV
> > > 
> > > 	# 2. If not, then wrap /dev/md9 in a linear target:
> > > 	#linear_add ssd $MD_DEV
> > > 	#SSD_DEV=/dev/mapper/ssd
> > 
> > Interesting that just adding a linear layer there would have some effect.
> 
> Its seemed (sometimes) to be the difference between triggering on the 
> first instead of the second iteration.  Without the linear wrap, it would 
> sometimes not crash until the second loop, typically on `lvchange -an 
> testvg`.  Maybe the extra linear hop delayed the IO just enough to help 
> with the race, but that is only speculation.
> 
> > > 	# Create a writable header for the PV meta:
> > > 	dd if=/dev/zero bs=1M count=16 oflag=direct of=/tmp/pvheader
> > > 	loop=`losetup -f --show /tmp/pvheader`
> > > 	linear_add pv $loop /dev/nullb0
> > > 
> > > 	# Create the VG
> > > 	lvmdevices --adddev $SSD_DEV
> > > 	lvmdevices --adddev /dev/mapper/pv
> > > 	vgcreate $VGNAME /dev/mapper/pv $SSD_DEV
> > > 
> > > 	# Create the pool:
> > > 	lvcreate -n pool0 -L 1T $VGNAME /dev/mapper/pv
> > > 	lvcreate -n meta0 -L 512m $VGNAME $SSD_DEV
> > > 
> > > 	# Make sure the meta volume is on the SSD (it should be already from above):
> > > 	pvmove -n meta0 /dev/mapper/pv
> > 
> > I'd omit that pvmove if possible just in case it makes some unexpected
> > change.  You have more than enough layers to complicate things as it is
> > without pvmove adding dm-mirror to the mix.
> 
> Good point. Since we specify the PV with `lvcreate ... $SSD_DEV`, the
> pvmove isn't necessary at all.  (Specifying the PV on lvcreate was added
> later, pvmove was leftover from earlier testing.)
> 
> > 
> > > 	lvconvert -y --force --force --chunksize 64k --type thin-pool --poolmetadata $VGNAME/meta0 $VGNAME/pool0
> > 
> > It's not a bad idea to use mdraid over dm-integrity, but it would be
> > interesting to know if doing raid+integrity in lvm would have the same
> > problems. e.g.
> >
> > 
> > lvcreate --type raid1 --raidintegrity y -m1 -L 512m -n meta0 $vg /dev/ram[01]
> > lvcreate -n pool0 -L 1T $vg /dev/nullb0
> > lvconvert --type thin-pool --poolmetadata meta0 $vg/pool0
> 
> Good idea!  As it turns out, that crashes just as easily.  Here is the
> script with LVM based RAID1, which is somewhat simpler:
> 
> --------------------------------------------------------------------
> #!/bin/bash
> 
> # Notice: /dev/ram0 and /dev/ram1 will be wiped unconditionally.
> 
> # Configure these if you need to:
> VGNAME=testvg
> LVNAME=thin
> LVSIZE=$((10 * 1024*1024*1024/512))
> 
> echo "NOTICE: THIS MAY BE UNSAFE. ONLY RUN THIS IN A TEST ENVIRONMENT!"
> echo "Press enter twice to continue or CTRL-C to abort."
> 
> read
> read
> 
> set -x
> 
> 
> # append disks into a linear target
> linear_add()
> {
> 	name=$1
> 	shift
> 
> 	prevsize=0
> 	for vol in "$@"; do
> 		size=`blockdev --getsize $vol`
> 		echo "$prevsize $size linear $vol 0"
> 		prevsize=$size
> 	done \
> 		| dmsetup create $name
> 
> 	echo /dev/mapper/$name
> }
> 
> lvthin_add()
> {
> 	id=$1
> 	lvcreate -An -V $LVSIZE -n $LVNAME$id --thinpool pool0 $VGNAME >&2
> 	echo /dev/$VGNAME/$LVNAME$id
> }
> 
> lvthin_snapshot()
> {
> 	origin=$1
> 	id=$2
> 
> 	lvcreate -An -s $VGNAME/$LVNAME$origin -n $LVNAME$id >&2
> 	echo /dev/$VGNAME/$LVNAME$id
> }
> 
> fio()
> {
> 	dev=$1
> 	/bin/fio --name=$dev --rw=randrw --direct=1 --bs=512 --numjobs=1 --filename=$dev --time_based --runtime=$FIOTIME --ioengine=libaio --iodepth=1 &> /dev/null
> }
> 
> do_reset()
> {
> 	killall -9 fio
> 	lvchange -an $VGNAME
> 	rmdir /dev/$VGNAME
> 	dmsetup remove pv
> 	lvmdevices --deldev /dev/mapper/pv
> 	losetup -d /dev/loop?
> 	rmmod brd
> 	rmmod null_blk
> 	echo ==== reset done
> 	sleep 1
> }
> 
> do_init()
> {
> 	modprobe null_blk gb=30000 bs=512
> 
> 	ramsize_gb=1
> 	modprobe brd rd_size=$(($ramsize_gb * 1024*1024)) rd_nr=2
> 
> 	# Create a writable header for the PV meta:
> 	dd if=/dev/zero bs=1M count=16 oflag=direct of=/tmp/pvheader
> 	loop=`losetup -f --show /tmp/pvheader`
> 	linear_add pv $loop /dev/nullb0
> 
> 	# Create the VG
> 	lvmdevices --adddev /dev/ram0
> 	lvmdevices --adddev /dev/ram1
> 	lvmdevices --adddev /dev/mapper/pv
> 	vgcreate $VGNAME /dev/mapper/pv /dev/ram[01]
> 
> 	# Create the pool:
> 	lvcreate -n pool0 -L 1T $VGNAME /dev/mapper/pv
> 	lvcreate --type raid1 --raidintegrity y -m1 -L 512m -n meta0 $VGNAME /dev/ram[01]
> 
> 	lvconvert -y --force --force --chunksize 64k --type thin-pool --poolmetadata $VGNAME/meta0 $VGNAME/pool0
> }
> 
> 
> while true; do
> 	do_reset
> 	do_init
> 
> 	thin1=`lvthin_add 1`
> 	fio $thin1 &
> 
> 	thin2=`lvthin_snapshot 1 2`
> 	fio $thin2 &
> 
> 	wait
> 
> done
> 
> 
> 
