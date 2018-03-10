From: Jitendra <jkhasdev@gmail.com>
Subject: Re: device mapper mapping across reboot
Date: Sat, 10 Mar 2018 16:17:47 +0530
Message-ID: <20180310104747.GA1027@gmail.com>
References: <CAN-6CVmztjkV6JL0k3N8Vh47Tr4oY_8Jj6-JL16b2YY5yNEHOA@mail.gmail.com>
	<f0e41723-159a-fe39-42f2-4a2ef1466bfa@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <f0e41723-159a-fe39-42f2-4a2ef1466bfa@redhat.com>
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



>lvm2 is exactly solving this problem as it maintains consistent
>'metadata' on every device - so upon reboot devices are discovered and
>from their metadata dm tables are actived/restored.

Got it.

>So  are you looking for recreation of all the lvm2 infrastructure for
>this relatively quite complex task ?
Not exactly, but I want to create mapper device created before the root and
other fs get mounted so that I can track I/Os in target.

>Or you just want to 'create' DM after kernel is booted ?
dmsetup create with my target.

>Or you even want to pass 'DM' table line on kernel boot option line -
>so even your boot device is a 'DM' device ?

It is something exactly, I wanna to do.

eg. I wrote a basic target as explained here
http://techgmm.blogspot.in/p/writing-your-own-device-mapper-target.html

Now, to use this target (kernel module), I need to create mapper device as
echo 0 <size_of_device> basic_target /Path/to/your/device 0 | dmsetup create my_basic_dm_device

After creation of device as /dev/mapper/my_basic_dm_device for /dev/sda, if I do I/O from
/dev/mapper/my_basic_dm_device, then all I/O goes through basic_target before it
hits to /dev/sda.

Now, if system is booted and disk is offline then it is very easy to create
mapper device. But now let suppose I want to boot on
/dev/mapper/my_basic_dm_device instead of /dev/sda1 etc. then I have to create
mapper device even before it get switch root.

This is same case for other disks as well. So there should be a way so that I
can use device mapper framework after reboot.

---
Jitendra
