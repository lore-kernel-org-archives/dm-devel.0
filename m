From: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [lvm-devel] linux-2.6.35+ causes LVM to fail with "
 device-mapper: version ioctl failed: Inappropriate ioctl for device"
Date: Tue, 17 Aug 2010 00:10:48 +0800
Message-ID: <AANLkTi=rm97rBs+Umvp7dNc_i5uzg6vhhVx=9BZH1AW4@mail.gmail.com>
References: <AANLkTime9NS3Bk-8ZpovRNy9iEGJxwYw=-aZ38JoRa_3@mail.gmail.com>
	<20100814155401.GJ26032@agk-dp.fab.redhat.com>
	<AANLkTi=aJ7f5X9sMeA85KJxi+rzWhiZCZ2ZwriNEVFCT@mail.gmail.com>
	<20100815130336.GA24055@agk-dp.fab.redhat.com>
	<AANLkTinUuphqozgrSMNnrKxJrPWFp77y2TzdEwtuMD42@mail.gmail.com>
	<4C6943A0.9030708@redhat.com>
	<20100816142246.GA11907@agk-dp.fab.redhat.com>
	<AANLkTik0naaXsicwLgLeBUA0u2+BQQbww-44Fs_cHXHH@mail.gmail.com>
	<20100816155516.GD11907@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100816155516.GD11907@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jeff Chua <jeff.chua.linux@gmail.com>, Zdenek Kabelac <zkabelac@redhat.com>, device-mapper development <dm-devel@redhat.com>, lkml <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Mon, Aug 16, 2010 at 11:55 PM, Alasdair G Kergon <agk@redhat.com> wrote:
> On Mon, Aug 16, 2010 at 11:32:15PM +0800, Jeff Chua wrote:
>> It'll be nice if lvm returns a more meanful message like "ioctl
>> failed. Check /proc/misc to ensure the device is mapped correctly."
>
> No need - LVM should be quite capable of detecting/dealing with the probl=
em.

Ok, cool.

>> To take care of it automatically with udev, I'm doing this in rc.S
>> if [ -f /sys/devices/virtual/misc/device-mapper/dev ]
>> then
>> =A0 =A0 =A0 =A0 NODE=3D$(</sys/devices/virtual/misc/device-mapper/dev)
>> =A0 =A0 =A0 =A0 rm -f /dev/mapper/control
>> =A0 =A0 =A0 =A0 mknod /dev/mapper/control c ${NODE/:/ }
>
> The whole point of this change was to trigger the loading of dm-mod
> automatically for people using it as a module, based on using a known
> major/minor number instead of a dynamic one only known after the module
> has been loaded. =A0That needs to happen regardless of whether someone is
> using udev or not.
>
> This can all be fixed easily enough in userspace.

I'm not using module. It's all built-in to the kernel. Hopefully this
would be taken care of as well. That's why I had it in rc.S just
before the lvm filesystems are mounted.

Thanks,
Jeff.
