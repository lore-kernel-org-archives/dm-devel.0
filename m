From: Michael Keller <MKELLER@il.ibm.com>
Subject: Re: Device-mapper for write monitoring
Date: Sun, 22 Feb 2009 15:18:29 +0200
Message-ID: <OFB375B90B.5958A499-ONC2257565.0042E713-C2257565.00491A7B@il.ibm.com>
References: <OF2FA15171.EBB61656-ONC2257562.00256C52-C2257562.002C88F5@il.ibm.com>
	<20090219142807.GA26662@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090219142807.GA26662@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


> Re: [dm-devel] Device-mapper for write monitoring
> malahal
> to:
> dm-devel
> 19/02/2009 16:33

[snip] (and thanks for your answers!)

> > I was also hoping that the device-mapper can somehow help us with
> > monitoring the device hosting the root filesystem. Device-mapper
apparently
> > comes with some special support, which allows it to, e.g., mount root
on a
> > logical volume. Does this work for any device-mapper targets, or just
for
> > inbuilt ones? Where do you store the configuration information (dm
tables)
> > anyway, so that it's accessible before root is mounted?
>
> As far as I know, "dm tables" are not stored persistently by the device
> mapper tools. LVM is the one that stores and uses it from
> initramfs/initrd. You will have to write your own tools to store the
> configuration and use it. These tools will have to be included in the
> initramfs/initrd for your thing to work on root device. You may need to
> reserve some space on the device to store your configuration!

This got me a bit scared. To confirm, I unpacked my initrd and looked at
init. There is indeed no indication of the device-mapper trying to
reconstruct the correct tree, rather it is (as you say) all LVM:

lvm vgscan --ignorelockingfailure
lvm vgchange -ay --ignorelockingfailure  VolGroup00
resume /dev/VolGroup00/LogVol01
mkrootdev -t ext3 -o defaults,ro /dev/VolGroup00/LogVol00

But now suppose, I added a simple dm-linear device in between LVM and the
physical device - so to speak, a glass sheet on top of the physical volume.
What would happen? I tried something similar outside the boot process: I
put a dm-delay device on top of /dev/sda1 (which is a PV). The
resulting /dev/mapper/delayed has no users, and obviously the logical
volumes are not suddenly magically going through this device. On the other
hand, when I did a pvscan, it would now report to me a physical volume
called /dev/mapper/delayed, rather than /dev/sda1! I suppose from LVM's
point of view, it just finds two identical devices (two devices with
identical LVM metadata), and chooses to display ... well, one of them.

This means that in the boot process, to support a similar setup, I'd need
to create my device first, and then somehow instruct 'lvm vgscan' to make
the correct choice. I think /etc/lvm/lvm.conf (included in initrd) allows
me to do so. At this point this is clearly becoming an LVM question, rather
than a device-mapper question.

Unless I missed something?

Thanks,
Michael
