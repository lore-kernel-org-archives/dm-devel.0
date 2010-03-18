From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm resume
	ioctl.
Date: Thu, 18 Mar 2010 17:13:22 +0100
Message-ID: <ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Mar 18, 2010 at 14:58, Milan Broz <mbroz@redhat.com> wrote:
> Block layer sends ADD uevent when new device is initialised.
>
> But the device-mapper block devices are more complex,
> initialisation consists of allocating underlying device and
> loading mapping table.
>
> Because from the userspace all block devices should behave
> the same, patch defines new flag indicating that ADD event
> should be suppressed in block layer.
>
> If the flag is set, caller then take full responsibility
> for enabling and sending events later when device is ready
> to use.

This will disconnect /sys, /dev and /proc from the flow of events. We
rather like to keep them in sync. Device enumeration will find devices
which have never been announced before. It will also find devices
where "remove" was sent, but the device is still there. I don't think
this disconnect is really acceptable from a driver core perspective
and its consumers. On systems without devtmpfs, there will be no
device node for the dm device while there is already the full sysfs
entry and udev would be idle (settle returns), but the state in /sys
not fully reflected in /dev, which is what we should avoid.

How about doing a two-stage instantiation instead of mangling events
to work around this setup model? Instead of creating the mentioned
event/sys inconsistencies, did you think about not registering the
"dead" blockdev until it is ready to be used as a blockdev? Like you
would allocate the dm instance in the kernel, but only register the
blockdev with the block subsystem when the device is resumed/the table
loaded. That way, only after the device is usable, it would get
registered and appear in /dev, /sys and proc.

Thanks,
Kay
