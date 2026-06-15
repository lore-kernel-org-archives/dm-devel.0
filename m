Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421B827FD51
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 23:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781565389; cv=pass; b=Eqdz8R4koCvg0DJqh6urnp7InMQ2s98b9GDnfxRZsPDCEzpwv5DSzS4YSr5QSLqZkXONN32Z3X38rqLtQVeKcKcrt2TPa4anLE0wwv6I5hO0Ej5SEhzDI/3caU3ITfT/NlCyf1ed4V/Asd+PpeXZE9kOSmdKJq8f+liKr9fxQIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781565389; c=relaxed/simple;
	bh=wvQ6Who5f5/PwoZcQSQoi1VfOrOT4U5B3Hmg/+ZNTlQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u5C9F37T19xejvl7pySTnxvAC7l3Nv1NvTJeGAI+t3gqnFerfALlLMWbUm7Plm8VborB45CrRlU3X7htConK8QOaxS7YlJcIran9WXcLyXD6EasKKGsHvVwuxWdErXPSU85RX3/opG49WnmxoQC1nSWSYY/3FiYOyRXj9Zt0ne8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EkP7jml9; arc=pass smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EkP7jml9"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5aa68daa847so207659e87.2
        for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 16:16:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781565385; cv=none;
        d=google.com; s=arc-20240605;
        b=NgMVGMzy09mZFmXfnEHx59xifttTSWtgYpK4ZDt0bu88uhUjqLxVVDOg+8dDdr41zv
         aqunxMQql6+WvAfIp474bPqmhEUh8rZdCARSxIjwOH7QWuy0YbBRmRuG3riWSABdUzKk
         1exXJn1l1qa7TegE1Zxcmr1AFxDYKm/7hyqGCYx260GyacN9vYwPom3YbE0kWjfsQRj+
         0L0HWhS1D8kDctUV3LNOrXv/I8Q9YHBrs939PZYnj6Y0XWACJ2XLVycSO2YVsmRWmy2L
         aVEcrY8EY0uskR90GcKCofwzCX5E/ywbD29wyRL8QW1ZDCFdph8y8K61hv43pAKBIEvy
         Ju9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BEHqr5lJOBe8zsjJYuzGFelY0YDO4v08iAMpMi8m0uo=;
        fh=pzqKeMWPS5hk8H5quzDy70/jdu35+fHIc/io4HXWTu8=;
        b=PV0MgS+z/th5Z4n+HGCC/fhUyV3pVknGPOMbB3xaUpSZGxj/kaxtlO+SHTv7e6k7Yv
         trajxefFS4DEPNZQyKpBhIRTs5xj9YPNNUmnH7TGPeTVMk4D3Zg85kwtkooQlbP2Bisx
         yPg8d9WCbwasOybAXZ4IVxWIl0T977TGqWP+nP/ftcKb5JFwlyP5Uo1LiCCBNB7roop9
         ffm6fSyZrY8iDpefuuRuSoJryknJvJVhWTDtGGfokPCpXzAqxm6DLP14t/W/YWp39gmw
         c7ynfm08Aa63PTIL6mqZFIlxj2MtRJB5UJOWioWQX79Y2AUDd036PMhtUiCJs0sFVg2F
         Ahsw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781565385; x=1782170185; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BEHqr5lJOBe8zsjJYuzGFelY0YDO4v08iAMpMi8m0uo=;
        b=EkP7jml96P5cx2fLkzfkIbzY4TzsxAmt1ixsAJgy/Gukx97t4Sl4ecQd4JVIAfCSG1
         dOxQ3WW8EFTzPLs37WLvsF8upE6M8VGezFjLuX5EkAVP04kEhcFfv50WCI7CtMgLsPAO
         LmoyHIas3F4V13wOmNjUc7eC36rs/Mfl4nTzwPexDo/HqDCl9yYmwekbaaIY34JnEXqM
         LOzMFPqNEts2VhCwbIi3X0tR4N3V/BhqRgBdsTPGkOWMk+iXZMDMe8BVP8D7kxyo83Ky
         mN+giuP+UR8tnm2w4QY0UWNBgt3H3/U1akwhfiBRbxYjmFL28BIbfxIaxWk8xGNcJeE1
         fO0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781565385; x=1782170185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BEHqr5lJOBe8zsjJYuzGFelY0YDO4v08iAMpMi8m0uo=;
        b=TTX9FD6m6yU5hF0jNgQ0VqOEGaeAFzLG9wmHBjVeB3UjyNtNDf/FockvGFqAs+6S65
         SX7bOdicI5IZd0kdoNanmBnou7hwa1YZF5Hl5selJ/XemMXeffdbmeFx19GRRBjjl9GL
         NzkeVoKb7lwqpUzx0PZ5/1kNNzeTui/CiJV18BbMYI3M+JWoJ96irK7qK6E+/+1Z3QW3
         yhGz6/bs7nGhhCikCVv0wW6MtAqz44g09NWS9X+tg2owdA9zjt8KDUhteso7vlgJzcLf
         Xq+0y3XaWzShMOTDLnZ1nqLxCoNy2/ikf1RJEaPISU4A5IhksKWdMCGhBz2lzXsKLYfD
         yZhA==
X-Forwarded-Encrypted: i=1; AFNElJ+4AoIQXOYs7Q4WqAQYDkzLRqhvKPhNnBCTGGc3A5oU7TTJMSuag+R3s4y+Nnwg0yWSqvEXzNzRbg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxw9tKoRSQMcC2IBz1Ie4DcxHWlImsNbRftK9/Aq98j8Y4+5ZU1
	ym0b5BYPFGdAw7mWYzFv38mNZCpWRmAhJoyfwkduWljnxrEhWnJkFdLLizzBf19LSYusJRkdWku
	7ueT9LMcepw2uun+ELHD7MejpQ8mTtEE=
X-Gm-Gg: Acq92OH0MkwpTZXu5pOFt/Q81wDgaqdlAfJBg916Xrg2VEo1T1RdEFf65jZNpbWVMlx
	fkUDUyo85fRsN1p6Ay3W2dUy1JVvUXFhqcjxXVeK8fKTa5d3sbUTVgGNIDoQ1GXisIzhBA4lYZs
	W9InY7NmMsxUP1WjilsCSEDy7MDNgeMx0j9giKJ3RBVrZX/Q498L9O9ZQyiJxu1h4ZXngw/mhg3
	1NBBl3Xf606svMAa7drFGy8cSv4KjH8fXYsVKM0AHcjN27J6yQyIFZ1lCYwwrhtQkwI0b9D634p
	el7jOWZYpoy75g2jaIqqCGWwxXGULKEfMLQbvsIJ
X-Received: by 2002:a05:6512:3e2a:b0:5ad:2e00:c596 with SMTP id
 2adb3069b0e04-5ad2e00c659mr2386705e87.0.1781565385064; Mon, 15 Jun 2026
 16:16:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ai7rnH20IYeSmY8s@gallifrey> <165d3195-c81d-4760-870b-23a9a3b3b72c@leemhuis.info>
 <ai_1LYtofh1fwD-N@gallifrey>
In-Reply-To: <ai_1LYtofh1fwD-N@gallifrey>
From: Vjaceslavs Klimovs <vklimovs@gmail.com>
Date: Mon, 15 Jun 2026 16:16:12 -0700
X-Gm-Features: AVVi8CfOdTH2vROH_Juv4k7g3x3u4qhSt8PkqDE04glOQSK6GtfS63sTG69O_x0
Message-ID: <CAC_j7i0eDccVWzPeRafM50mZEOFHPz2cwd=RZqqx6TK2EVRFvw@mail.gmail.com>
Subject: Re: Repeatable, raid1+O_DIRECT, hang/warn
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>, kbusch@kernel.org, trnka@scm.com, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
	Linux kernel regressions list <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dave, all,

I'm one of the original reporters and very much a user, not a block/dm
developer, so please sanity-check all of this.

Your trace looks like what the two earlier reports hit: a read reaching
a leaf device with sectors > 0 but phys_seg 0 (an empty bio). One aside
that may help read the trace: blk_io_trace.error is a __u16, so the
bracketed values on your C lines are errnos as u16 (65514 =3D -EINVAL,
65531 =3D -EIO).

The WARN itself is new, the bad bio isn't. bio_add_page() only started
rejecting len =3D=3D 0 in 643893647cac ("block: reject zero length in
bio_add_page()", v7.1-rc1); on 7.0.8 the same empty bio tripped
scsi_alloc_sgtables()'s !nr_segs instead, which matches what you saw.
That fits your "not a recent regression": the condition is older, v7.1
just made it loud.

For Tomas's and my reports (QEMU O_DIRECT to the LV block device) the
origin looks like 5ff3f74e145a ("block: simplify direct io validity
check", v6.18): blkdev_dio_invalid() now checks only aggregate
ki_pos | count alignment and dropped the per-segment
bdev_iter_is_aligned() walk, so a degenerate or misaligned O_DIRECT no
longer gets -EINVAL at the fops boundary. But your reproducer reads a
file, which goes through the filesystem O_DIRECT path and never calls
blkdev_dio_invalid(), and still makes the empty bio. So it isn't only
that one entry point.

dm-mirror then hangs because Keith's f7b24c7b41f2 only covers md
raid1/raid10; legacy dm-mirror (dm-raid1.c) has no equivalent and
rebuilds the empty read onto the other leg. Note the leg's status isn't
even consistent (your SATA path returns BLK_STS_IOERR, not
BLK_STS_INVAL), so copying that status check into dm-mirror probably
wouldn't catch every case.

For what it's worth, that points me toward rejecting the empty or
misaligned bio once, at submission, with -EINVAL, rather than teaching
each consumer to tolerate it. But you'll know the tradeoffs far better
than I do.

I have a small QEMU + LVM raid1/mirror setup that reproduces the
block-device variant and bisects to 5ff3f74e. Happy to run your file
reproducer with some instrumentation at the dm-mirror read entry
(bi_size vs bio_sectors vs bvec lengths) to see whether the bio is
already empty on arrival or built that way on the retry, and to test
any patch.

Thanks,
Vjaceslavs


On Mon, Jun 15, 2026 at 5:50=E2=80=AFAM Dr. David Alan Gilbert
<linux@treblig.org> wrote:
>
> * Thorsten Leemhuis (regressions@leemhuis.info) wrote:
> > On 6/14/26 19:57, Dr. David Alan Gilbert wrote:
> > >
> > >   I've got a repeatable raid hang/warn and would appreciate some poin=
ters
> > > as where to debug.
> > >   (I've been logging stuff on  https://bugzilla.kernel.org/show_bug.c=
gi?id=3D221535 )
> >
> > Note: not my area of expertise, so I might be sending you totally
> > off-track with this comment. Feel free to ignore it. But FWIW:
>
> Hi Thorsten,
>   Thanks for the reply - these do seem to be related!
> (So copying in Keith, Vjaceslavs, and Tom=C3=A1=C5=A1 )
> (Not my area either).
>
> > Have you seen these reports?
> > https://lore.kernel.org/all/2982107.4sosBPzcNG@electra/
> > https://lore.kernel.org/all/CAC_j7i1R7oy+nRhxEjCTba=3DDUgn02w9X+p94DCu0=
aHv5+5tKnQ@mail.gmail.com/
>
> I hadn't!  Those are both the problem I originally was trying to debug
> and stumbled into the WARN/BUG/hang with my test program.
>
> > The former lead to a fix in the mdraid code that should be in the kerne=
l
> > version you are using. But in a reply to the latter report the repoter
> > claimed that that fix is not enough (claiming "this was obvious" and
> > also using dm), but things then stalled there.
>
> Yeh I see my world has Keith's f7b24c7b41f23
>
> I think the problem I'm seeing is zero length requests coming from somewh=
ere.
>
> The WARN I'm seeing in 7.1.0-rc7+ is:
>
> [ 2681.597042] device-mapper: raid1: Mirror read failed from 252:25. Tryi=
ng alternative device.
> [ 2681.631933] ------------[ cut here ]------------
> [ 2681.631939] WARNING: block/bio.c:1044 at bio_add_page+0x18b/0x250, CPU=
#22: kworker/22:0/18929
>
> 1039 int bio_add_page(struct bio *bio, struct page *page,
> 1040                  unsigned int len, unsigned int offset)
> 1041 {
> 1042         if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
> 1043                 return 0;
> 1044         if (WARN_ON_ONCE(len =3D=3D 0))
> 1045                 return 0;
>
> So it's the ' if (WARN_ON_ONCE(len =3D=3D 0))'
>
> and the warn I got on the older 7.0.8 was:
> [Sun May 17 17:22:52 2026] WARNING: drivers/scsi/scsi_lib.c:1140 at scsi_=
alloc_sgtables+0x38a/0x400, CPU#28: kworker/28:1H/3943
>
> which I *think* corresponds to:
> 1164         if (WARN_ON_ONCE(!nr_segs))
> 1165                 return BLK_STS_IOERR;
>
> so it sounds like we need to find where zero length requests are coming f=
rom??
>
> Thanks again,
>
> Dave
>
> > Ciao, Thorsten
> >
> > >   This started off as debugging a case where I'd get my RAID1 (on the=
 host)
> > > getting a reliable 'rescheduling sector'/disk failure while running t=
he qemu block test suite
> > > during a qemu build, but then I tried to build a smaller discrete
> > > test, and now I've got a simply triggerable warn and test hang.
> > > There's no errors from the underlying SATA layer on the storage,
> > > everything resyncs just fine.
> > >
> > > I've got an existing LVM vg ('main') with two mirrors on sda2, and sd=
b2
> > > which are SATA disks.
> > >
> > > # lvcreate --type mirror --mirrors 1 -L 1G main /dev/sda2 /dev/sdb2
> > > # mkfs.ext4 /dev/mapper/main-lvol0
> > > # mount /dev/mapper/main-lvol0 /mnt/tmp/
> > > # chmod a+rwx /mnt/tmp
> > >
> > > $ dd if=3D/dev/zero of=3D/mnt/tmp/testfile bs=3D1024k count=3D1
> > >
> > > (I then wait for the IO to stop)
> > >
> > > then we've got this little test program:
> > >
> > > <--><--><--><--><--><--><--><--><--><--><--><--><--><--><--><--><--><=
-->
> > > #include <errno.h>
> > > #include <fcntl.h>
> > > #include <asm-generic/fcntl.h>
> > > #include <stdio.h>
> > > #include <unistd.h>
> > >
> > >
> > > const char* path=3D"/mnt/tmp/testfile";
> > > static char buf[8192];
> > >
> > > int main()
> > > {
> > >   int fd=3Dopen(path, O_RDWR|O_DIRECT|O_CLOEXEC);
> > >
> > >   errno=3D0;
> > >   int res3=3Dpread(fd, buf, 4096, 0);
> > >   printf("pread of 4096 said: %d (%m)\n", res3);
> > >
> > > }
> > > <--><--><--><--><--><--><--><--><--><--><--><--><--><--><--><--><--><=
-->
> > >
> > > running that, either hangs or gets a 'pread of 4096 said: -1 (Input/o=
utput error)'
> > > when it hangs it's unkillable.
> > >
> > > at the moment (on 7.1.0-rc7) this is giving:
> > > Jun 14 18:08:32 dalek kernel: device-mapper: raid1: Mirror read faile=
d from 252:24. Trying alternative device.
> > > Jun 14 18:08:32 dalek kernel: ------------[ cut here ]------------
> > > Jun 14 18:08:32 dalek dmeventd[1010]: Primary mirror device 252:24 re=
ad failed.
> > > Jun 14 18:08:32 dalek kernel: WARNING: block/bio.c:1044 at bio_add_pa=
ge+0x18b/0x250, CPU#15: kworker/15:1/369
> > >
> > > (full backtrace below)
> > > (Note there is a moan in there about sdb IO error - repeated a lot - =
but
> > > again, there's no SATA level errors, and the drive is fine on smart, =
and
> > > I can read the whole of the underlying lvm mirrors, so I don't think =
it's
> > > physically there).
> > >
> > > I did a blktrace, although that gives me a 23G blkparse output, hmm
> > > (I see each event repeated a lot - maybe per thread?)
> > >
> > > 252,26  15        1     0.000000000  3435  Q  RS 264192 + 8 [dbf]
> > >   252,26 is /dev/mapper/main-lvol0
> > > 252,24  15        1     0.000005501  3435  A  RS 264192 + 8 <- (252,2=
6) 264192
> > >   252,24 is main-lvol0_mimage_0
> > > 252,24  15        2     0.000005761  3435  Q  RS 264192 + 8 [dbf]
> > >   8,0   15        1     0.000008646  3435  A  RS 71634944 + 8 <- (252=
,24) 264192
> > >     so that's sda
> > >   8,0   15        2     0.000008787  3435  A  RS 73734144 + 8 <- (8,2=
) 71634944
> > >     I guess mapping down from sda2 to sda
> > >   8,0   15        3     0.000009037  3435  Q  RS 73734144 + 8 [dbf]
> > >   8,0   15        4     0.000009809  3435  C  RS 73734144 + 8 [65514]
> > >       ??? Hmm what's the 65514 there?
> > > 252,24  15        3     0.000010320  3435  C  RS 264192 + 8 [65514]
> > > 252,25  15        1     0.000290384   369  Q   R 264192 + 8 [kworker/=
15:1]
> > >    252,25 is main-lvol0_mimage_1
> > >
> > > and at this point I'm a bit lost as to what I'm looking for.
> > >
> > > Hints appreciated!
> > >
> > > (I don't believe this is a regression - or at least not recent)
> > >
> > > Dave
> > >
> > >
> > >
> > >
> > > Jun 14 18:08:32 dalek kernel: device-mapper: raid1: Mirror read faile=
d from 252:24. Trying alternative device.
> > > Jun 14 18:08:32 dalek kernel: ------------[ cut here ]------------
> > > Jun 14 18:08:32 dalek dmeventd[1010]: Primary mirror device 252:24 re=
ad failed.
> > > Jun 14 18:08:32 dalek kernel: WARNING: block/bio.c:1044 at bio_add_pa=
ge+0x18b/0x250, CPU#15: kworker/15:1/369
> > > Jun 14 18:08:32 dalek dmeventd[1010]: main-lvol0 is now in-sync.
> > > Jun 14 18:08:32 dalek kernel: Modules linked in: nft_masq nft_reject_=
ipv4 act_csum cls_u32 sch_htb nf_nat_tftp nf_conntrack_tftp bridge stp llc =
rfkill nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_re=
ject_ipv4 nf_reje>
> > > Jun 14 18:08:32 dalek kernel:  drm_panel_backlight_quirks gpu_sched d=
rm_suballoc_helper video nvme drm_display_helper nvme_core cec nvme_keyring=
 sp5100_tco nvme_auth wmi serio_raw fuse scsi_dh_alua i2c_dev scsi_dh_rdac =
scsi_dh_emc
> > > Jun 14 18:08:32 dalek kernel: CPU: 15 UID: 0 PID: 369 Comm: kworker/1=
5:1 Not tainted 7.1.0-rc7+ #786 PREEMPT(lazy)
> > > Jun 14 18:08:32 dalek kernel: Hardware name: To Be Filled By O.E.M. T=
o Be Filled By O.E.M./X570 Pro4, BIOS P3.10 07/13/2020
> > > Jun 14 18:08:32 dalek kernel: Workqueue: kmirrord do_mirror
> > > Jun 14 18:08:32 dalek kernel: RIP: 0010:bio_add_page+0x18b/0x250
> > > Jun 14 18:08:32 dalek kernel: Code: 24 10 4c 8b 04 24 84 c0 0f 85 c9 =
00 00 00 41 0f b7 40 78 48 8b 74 24 08 8b 4c 24 14 e9 b4 fe ff ff 0f 0b 31 =
c0 e9 55 d1 af 00 <0f> 0b eb f5 48 8b 7f 08 83 7f 60 05 0f 85 00 ff ff ff 4=
9 8b 3b 4c
> > > Jun 14 18:08:32 dalek kernel: RSP: 0018:ffffd1fb8176fc10 EFLAGS: 0001=
0246
> > > Jun 14 18:08:32 dalek kernel: RAX: 0000000000000000 RBX: ffffd1fb8176=
fd18 RCX: 0000000000000000
> > > Jun 14 18:08:32 dalek kernel: RDX: 0000000000000000 RSI: 000000000000=
0000 RDI: ffff8d1a8eb28b00
> > > Jun 14 18:08:32 dalek kernel: RBP: 0000000000000000 R08: ffffd1fb8176=
fc38 R09: ffffd1fb8176fc40
> > > Jun 14 18:08:32 dalek kernel: R10: ffffd1fb8176fc34 R11: 000000000000=
0000 R12: 0000000000000000
> > > Jun 14 18:08:32 dalek kernel: R13: ffffd1fb8176fd90 R14: 000000000000=
0001 R15: ffff8d1a8eb28b00
> > > Jun 14 18:08:32 dalek kernel: FS:  0000000000000000(0000) GS:ffff8d29=
d161f000(0000) knlGS:0000000000000000
> > > Jun 14 18:08:32 dalek kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000=
0080050033
> > > Jun 14 18:08:32 dalek kernel: CR2: 00007f0ddcd7b9d0 CR3: 000000023dcb=
f000 CR4: 0000000000350ef0
> > > Jun 14 18:08:32 dalek kernel: Call Trace:
> > > Jun 14 18:08:32 dalek kernel:  <TASK>
> > > Jun 14 18:08:32 dalek kernel:  do_region+0x227/0x2a0
> > > Jun 14 18:08:32 dalek kernel:  dispatch_io+0xf1/0x150
> > > Jun 14 18:08:32 dalek kernel:  ? __pfx_bio_get_page+0x10/0x10
> > > Jun 14 18:08:32 dalek kernel:  ? __pfx_bio_next_page+0x10/0x10
> > > Jun 14 18:08:32 dalek kernel:  ? __pfx_read_callback+0x10/0x10
> > > Jun 14 18:08:32 dalek kernel:  dm_io+0x169/0x2d0
> > > Jun 14 18:08:32 dalek kernel:  ? __pfx_bio_get_page+0x10/0x10
> > > Jun 14 18:08:32 dalek kernel:  ? __pfx_bio_next_page+0x10/0x10
> > > Jun 14 18:08:32 dalek kernel:  do_reads+0x149/0x230
> > > Jun 14 18:08:32 dalek kernel:  ? __pfx_read_callback+0x10/0x10
> > > Jun 14 18:08:32 dalek kernel:  do_mirror+0x11a/0x2b0
> > > Jun 14 18:08:32 dalek kernel:  process_one_work+0x19e/0x390
> > > Jun 14 18:08:32 dalek kernel:  worker_thread+0x1a6/0x310
> > > Jun 14 18:08:32 dalek kernel:  ? __pfx_worker_thread+0x10/0x10
> > > Jun 14 18:08:32 dalek kernel:  kthread+0xe4/0x120
> > > Jun 14 18:08:32 dalek kernel:  ? __pfx_kthread+0x10/0x10
> > > Jun 14 18:08:32 dalek kernel:  ret_from_fork+0x1a1/0x270
> > > Jun 14 18:08:32 dalek kernel:  ? __pfx_kthread+0x10/0x10
> > > Jun 14 18:08:32 dalek kernel:  ret_from_fork_asm+0x1a/0x30
> > > Jun 14 18:08:32 dalek kernel:  </TASK>
> > > Jun 14 18:08:32 dalek kernel: ---[ end trace 0000000000000000 ]---
> > > Jun 14 18:08:32 dalek kernel: ------------[ cut here ]------------
> > > Jun 14 18:08:32 dalek kernel: WARNING: drivers/scsi/scsi_lib.c:1164 a=
t scsi_alloc_sgtables+0x38a/0x400, CPU#15: kworker/15:1/369
> > > Jun 14 18:08:32 dalek kernel: Modules linked in: nft_masq nft_reject_=
ipv4 act_csum cls_u32 sch_htb nf_nat_tftp nf_conntrack_tftp bridge stp llc =
rfkill nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_re=
ject_ipv4 nf_reje>
> > > Jun 14 18:08:32 dalek kernel:  drm_panel_backlight_quirks gpu_sched d=
rm_suballoc_helper video nvme drm_display_helper nvme_core cec nvme_keyring=
 sp5100_tco nvme_auth wmi serio_raw fuse scsi_dh_alua i2c_dev scsi_dh_rdac =
scsi_dh_emc
> > > Jun 14 18:08:32 dalek kernel: CPU: 15 UID: 0 PID: 369 Comm: kworker/1=
5:1 Tainted: G        W           7.1.0-rc7+ #786 PREEMPT(lazy)
> > > Jun 14 18:08:32 dalek kernel: Tainted: [W]=3DWARN
> > > Jun 14 18:08:32 dalek kernel: Hardware name: To Be Filled By O.E.M. T=
o Be Filled By O.E.M./X570 Pro4, BIOS P3.10 07/13/2020
> > > Jun 14 18:08:32 dalek kernel: Workqueue: kmirrord do_mirror
> > > Jun 14 18:08:32 dalek kernel: RIP: 0010:scsi_alloc_sgtables+0x38a/0x4=
00
> > > Jun 14 18:08:32 dalek kernel: Code: 8b 3d ba 2d a9 01 e9 d1 fd ff ff =
48 8b 75 00 48 8d bb f0 fe ff ff e8 15 b7 b0 ff 48 89 ab e0 00 00 00 89 45 =
08 e9 30 ff ff ff <0f> 0b 4c 8b 6c 24 30 b8 0a 00 00 00 e9 21 ff ff ff b8 0=
9 00 00 00
> > > Jun 14 18:08:32 dalek kernel: RSP: 0018:ffffd1fb8176f7f0 EFLAGS: 0001=
0246
> > > Jun 14 18:08:32 dalek kernel: RAX: 0000000000000000 RBX: ffff8d1aedad=
0110 RCX: 0000000000000009
> > > Jun 14 18:08:32 dalek kernel: RDX: 0000000000000000 RSI: ffffffff99c1=
5960 RDI: ffff8d1aedad0110
> > > Jun 14 18:08:32 dalek kernel: RBP: ffff8d1a93d17000 R08: ffff8d1aedad=
0110 R09: ffff8d1a818fa800
> > > Jun 14 18:08:32 dalek kernel: R10: 7020676e69736961 R11: 000000000000=
0000 R12: 0000000000000000
> > > Jun 14 18:08:32 dalek kernel: R13: 0000000000000000 R14: ffff8d1a9339=
4000 R15: ffff8d1a93d17000
> > > Jun 14 18:08:32 dalek kernel: FS:  0000000000000000(0000) GS:ffff8d29=
d161f000(0000) knlGS:0000000000000000
> > > Jun 14 18:08:32 dalek kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000=
0080050033
> > > Jun 14 18:08:32 dalek kernel: CR2: 00007f0ddcd7b9d0 CR3: 000000023dcb=
f000 CR4: 0000000000350ef0
> > > Jun 14 18:08:32 dalek kernel: Call Trace:
> > > Jun 14 18:08:32 dalek kernel:  <TASK>
> > > Jun 14 18:08:32 dalek kernel:  ? srso_return_thunk+0x5/0x5f
> > > Jun 14 18:08:32 dalek kernel:  sd_setup_read_write_cmnd+0x9d/0x740
> > > Jun 14 18:08:32 dalek kernel:  ? srso_return_thunk+0x5/0x5f
> > > Jun 14 18:08:32 dalek kernel:  scsi_queue_rq+0x4d2/0x890
> > > Jun 14 18:08:32 dalek kernel:  blk_mq_dispatch_rq_list+0x241/0x530
> > > Jun 14 18:08:32 dalek kernel:  ? srso_return_thunk+0x5/0x5f
> > > Jun 14 18:08:32 dalek kernel:  ? sbitmap_get+0x61/0x100
> > > Jun 14 18:08:32 dalek kernel:  __blk_mq_do_dispatch_sched+0x330/0x340
> > > Jun 14 18:08:32 dalek kernel:  __blk_mq_sched_dispatch_requests+0x143=
/0x180
> > > Jun 14 18:08:32 dalek kernel:  blk_mq_sched_dispatch_requests+0x2d/0x=
70
> > > Jun 14 18:08:32 dalek kernel:  blk_mq_run_hw_queue+0x2bf/0x350
> > > Jun 14 18:08:32 dalek kernel:  ? srso_return_thunk+0x5/0x5f
> > > Jun 14 18:08:32 dalek kernel:  blk_mq_dispatch_list+0x172/0x350
> > > Jun 14 18:08:32 dalek kernel:  blk_mq_flush_plug_list+0x51/0x1a0
> > > Jun 14 18:08:32 dalek kernel:  ? blk_mq_submit_bio+0x71c/0x9f0
> > > Jun 14 18:08:32 dalek kernel:  __blk_flush_plug+0x112/0x180
> > > Jun 14 18:08:32 dalek kernel:  ? srso_return_thunk+0x5/0x5f
> > > Jun 14 18:08:32 dalek kernel:  __submit_bio+0x19c/0x260
> > > Jun 14 18:08:32 dalek kernel:  __submit_bio_noacct+0x8e/0x210
> > > Jun 14 18:08:32 dalek kernel:  do_region+0x14c/0x2a0
> > > Jun 14 18:08:32 dalek kernel:  dispatch_io+0xf1/0x150
> > > Jun 14 18:08:32 dalek kernel:  ? __pfx_bio_get_page+0x10/0x10
> > > Jun 14 18:08:32 dalek kernel:  ? __pfx_bio_next_page+0x10/0x10
> > > Jun 14 18:08:32 dalek kernel:  ? __pfx_read_callback+0x10/0x10
> > > Jun 14 18:08:32 dalek kernel:  dm_io+0x169/0x2d0
> > > Jun 14 18:08:32 dalek kernel:  ? __pfx_bio_get_page+0x10/0x10
> > > Jun 14 18:08:32 dalek kernel:  ? __pfx_bio_next_page+0x10/0x10
> > > Jun 14 18:08:32 dalek kernel:  do_reads+0x149/0x230
> > > Jun 14 18:08:32 dalek kernel:  ? __pfx_read_callback+0x10/0x10
> > > Jun 14 18:08:32 dalek kernel:  do_mirror+0x11a/0x2b0
> > > Jun 14 18:08:32 dalek kernel:  process_one_work+0x19e/0x390
> > > Jun 14 18:08:32 dalek kernel:  worker_thread+0x1a6/0x310
> > > Jun 14 18:08:32 dalek kernel:  ? __pfx_worker_thread+0x10/0x10
> > > Jun 14 18:08:32 dalek kernel:  kthread+0xe4/0x120
> > > Jun 14 18:08:32 dalek kernel:  ? __pfx_kthread+0x10/0x10
> > > Jun 14 18:08:32 dalek kernel:  ret_from_fork+0x1a1/0x270
> > > Jun 14 18:08:32 dalek kernel:  ? __pfx_kthread+0x10/0x10
> > > Jun 14 18:08:32 dalek kernel:  ret_from_fork_asm+0x1a/0x30
> > > Jun 14 18:08:32 dalek kernel:  </TASK>
> > > Jun 14 18:08:32 dalek kernel: ---[ end trace 0000000000000000 ]---
> > > Jun 14 18:08:32 dalek kernel: I/O error, dev sdb, sector 50606087 op =
0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > > Jun 14 18:08:32 dalek kernel: I/O error, dev sdb, sector 50606087 op =
0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > > Jun 14 18:08:32 dalek kernel: I/O error, dev sdb, sector 50606087 op =
0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > > Jun 14 18:08:32 dalek kernel: I/O error, dev sdb, sector 50606087 op =
0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > > Jun 14 18:08:32 dalek kernel: I/O error, dev sdb, sector 50606087 op =
0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > > Jun 14 18:08:32 dalek kernel: I/O error, dev sdb, sector 50606087 op =
0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > > Jun 14 18:08:32 dalek kernel: I/O error, dev sdb, sector 50606087 op =
0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > > Jun 14 18:08:32 dalek kernel: I/O error, dev sdb, sector 50606087 op =
0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > > Jun 14 18:08:32 dalek kernel: I/O error, dev sdb, sector 50606087 op =
0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > > Jun 14 18:08:32 dalek kernel: I/O error, dev sdb, sector 50606087 op =
0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > > Jun 14 18:08:37 dalek kernel: blk_print_req_error: 241000 callbacks s=
uppressed
> > > Jun 14 18:08:37 dalek kernel: I/O error, dev sdb, sector 50606087 op =
0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > >
> > >
> >
> --
>  -----Open up your eyes, open up your mind, open up your code -------
> / Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \
> \        dave @ treblig.org |                               | In Hex /
>  \ _________________________|_____ http://www.treblig.org   |_______/
