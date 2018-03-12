From: Jitendra <jkhasdev@gmail.com>
Subject: Re: device mapper mapping across reboot
Date: Mon, 12 Mar 2018 16:39:12 +0530
Message-ID: <20180312110912.GA1015@gmail.com>
References: <CAN-6CVmztjkV6JL0k3N8Vh47Tr4oY_8Jj6-JL16b2YY5yNEHOA@mail.gmail.com>
	<f0e41723-159a-fe39-42f2-4a2ef1466bfa@redhat.com>
	<20180310104747.GA1027@gmail.com>
	<c257ef68-a6f2-a458-fbbf-752b729fa169@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <c257ef68-a6f2-a458-fbbf-752b729fa169@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 12, 2018 at 10:49:02AM +0100, Zdenek Kabelac wrote:
>Dne 10.3.2018 v 11:47 Jitendra napsal(a):
>>
>>
>>>lvm2 is exactly solving this problem as it maintains consistent
>>>'metadata' on every device - so upon reboot devices are discovered and
>>>from their metadata dm tables are actived/restored.
>>
>>Got it.
>>
>>>So=A0 are you looking for recreation of all the lvm2 infrastructure for
>>>this relatively quite complex task ?
>>Not exactly, but I want to create mapper device created before the root a=
nd
>>other fs get mounted so that I can track I/Os in target.
>>
>>>Or you just want to 'create' DM after kernel is booted ?
>>dmsetup create with my target.
>>
>>>Or you even want to pass 'DM' table line on kernel boot option line -
>>>so even your boot device is a 'DM' device ?
>>
>>It is something exactly, I wanna to do.
>>
>>eg. I wrote a basic target as explained here
>>http://techgmm.blogspot.in/p/writing-your-own-device-mapper-target.html
>>
>>Now, to use this target (kernel module), I need to create mapper device as
>>echo 0 <size_of_device> basic_target /Path/to/your/device 0 |
>>dmsetup create my_basic_dm_device
>>
>>After creation of device as /dev/mapper/my_basic_dm_device for
>>/dev/sda, if I do I/O from
>>/dev/mapper/my_basic_dm_device, then all I/O goes through basic_target be=
fore it
>>hits to /dev/sda.
>>
>>Now, if system is booted and disk is offline then it is very easy to crea=
te
>>mapper device. But now let suppose I want to boot on
>>/dev/mapper/my_basic_dm_device instead of /dev/sda1 etc. then I have to c=
reate
>>mapper device even before it get switch root.
>>
>>This is same case for other disks as well. So there should be a way so th=
at I
>>can use device mapper framework after reboot.
>
>Hi
>
>Well in general - that's why every distribution is using init ramdisk.
>
>This ramdisk is loaded from a small /boot partition together with kernel.
>As you can see - you simply always need something to boot from - you
>cannot load your kernel from "DM" device.

Got it.

>Once kernel is booted and 'ramdisk' is processed - you have plenty of
>time and lots of binaries there (typically with lvm2 built-in)  - so
>here you can safely activate your root volume being on dm device (even
>without lvm2 just by issuing couple 'dmsetup' commands)

This is something which I have tried in following steps.

1. First load my target driver(eg. my_custom_target) in initramfs (RHEL 7) =
using dracuf.
2. Now  my_custom_target will be available when initramfs get loaded.
3. Before the switch_root, I tried to run following command as,

	[root@localhost ~]# ls -l /usr/lib/systemd/system/initrd-switch-root.servi=
ce
	-rw-r--r--. 1 root root 737 Mar 12 07:00 /usr/lib/systemd/system/initrd-sw=
itch-root.service

	In above file, I have added  dmsetup command to create
	/dev/mapper/my_device as,

	# we have to use "--force" here, otherwise systemd would umount /run
	ExecStart=3D/usr/bin/echo 0 24035328 my_custom_target /dev/sda 0|/usr/sbin=
/dmsetup create my_device
	ExecStart=3D/usr/bin/systemctl --no-block --force switch-root /sysroot
	KillMode=3Dnone

But it does not have any effect, after booting I could not see
/dev/mapper/my_device.


>I'm aware there is some  Android person who proposed some booting into
>DM without initramfs - i.e.
>
>https://www.redhat.com/archives/linux-lvm/2017-May/msg00055.html
>
>I'm not sure in which stage this patch is - likely still not upstream
>thought, but there was some progress around this.
I have looked into it. Since I am workig with older kernel version (3.10) so
these patches wont help although it has some really good pointers.

>Still it's worth to say -  not using ramdisk is pretty much bogus idea
>- you should always use ramdisk - otherwise you are missing lots of
>important tools i.e. for validation of filesystem  before it gets
>mounted - so whoever wants to use 'DM'  to mount  rootfs  without
>initramfs is doing something wrong.

This is exactly same understanding of mine as well, but I tried to create m=
apper
device using dmsetup but no luck.
>
>Anyway - since it's still unclear what is your actually work - it's
>really hard to give you proper advice here.

In my target driver, I am tracking each and every I/O and looking for offse=
t and
length in each bio and doing some logging stuff.

---
Jitendra
