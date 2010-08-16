From: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [lvm-devel] [dm-devel] linux-2.6.35+ causes LVM to fail with "
 device-mapper: version ioctl failed: Inappropriate ioctl for device"
Date: Mon, 16 Aug 2010 23:32:15 +0800
Message-ID: <AANLkTik0naaXsicwLgLeBUA0u2+BQQbww-44Fs_cHXHH@mail.gmail.com>
References: <AANLkTime9NS3Bk-8ZpovRNy9iEGJxwYw=-aZ38JoRa_3@mail.gmail.com>
	<20100814155401.GJ26032@agk-dp.fab.redhat.com>
	<AANLkTi=aJ7f5X9sMeA85KJxi+rzWhiZCZ2ZwriNEVFCT@mail.gmail.com>
	<20100815130336.GA24055@agk-dp.fab.redhat.com>
	<AANLkTinUuphqozgrSMNnrKxJrPWFp77y2TzdEwtuMD42@mail.gmail.com>
	<4C6943A0.9030708@redhat.com>
	<20100816142246.GA11907@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100816142246.GA11907@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zdenek Kabelac <zkabelac@redhat.com>, device-mapper development <dm-devel@redhat.com>, lkml <linux-kernel@vger.kernel.org>, Jeff Chua <jeff.chua.linux@gmail.com>, lvm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Aug 16, 2010 at 10:22 PM, Alasdair G Kergon <agk@redhat.com> wr=
ote:
> On Mon, Aug 16, 2010 at 03:56:48PM +0200, Zdenek Kabelac wrote:
>> Dne 15.8.2010 16:13, Jeff Chua napsal(a):
>> > With 2.6.35++, /dev/mapper/control has moved from 60 to 236!
>
> The latest LVM package made an assumption that it would be set up
> correctly by udev (or manually in your case). =A0We are updating
> the userspace libdevmapper code to handle your circumstances
> automatically.

It'll be nice if lvm returns a more meanful message like "ioctl
failed. Check /proc/misc to ensure the device is mapped correctly."

To take care of it automatically with udev, I'm doing this in rc.S

if [ -f /sys/devices/virtual/misc/device-mapper/dev ]
then
        NODE=3D$(</sys/devices/virtual/misc/device-mapper/dev)
        rm -f /dev/mapper/control
        mknod /dev/mapper/control c ${NODE/:/ }
fi


>> > # vgchange -a n vg01
>> > =A0 Internal error: Maps lock 14217216 < unlock 14221312
>> > =A0 Internal error: Maps lock 14221312 < unlock 14225408
>> > =A0 Internal error: Maps lock 14225408 < unlock 14229504
>> > =A0 Internal error: Maps lock 14229504 < unlock 14233600
>> > =A0 Internal error: Maps lock 14233600 < unlock 14237696
>> > =A0 Internal error: Maps lock 14237696 < unlock 14241792
>> > =A0 0 logical volume(s) in volume group "vg01" now active
>
>> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=
=3Dcommitdiff;h=3Dd7824370e26325c881b665350ce64fb0a4fde24a
>
> For those interested, originally we used mlockall() but in non-C loca=
les
> on some distributions glibc is configured to map 80MB+ of locale data
> into memory without offering any way to unmap it. =A0We don't need
> that data locked and it increased the minimum memory required to inst=
all
> a distribution as well as slowing down the LVM tools! =A0So we had to
> write a customised version that tries to skip locking unnecessary pag=
es
> like those.

I see that now it's fixed with that commit.

Thanks,
Jeff
