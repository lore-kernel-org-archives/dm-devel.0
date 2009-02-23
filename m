From: malahal@us.ibm.com
Subject: Re: Device-mapper for write monitoring
Date: Sun, 22 Feb 2009 21:48:53 -0800
Message-ID: <20090223054852.GA9395@us.ibm.com>
References: <OF2FA15171.EBB61656-ONC2257562.00256C52-C2257562.002C88F5@il.ibm.com>
	<20090219142807.GA26662@us.ibm.com>
	<OFB375B90B.5958A499-ONC2257565.0042E713-C2257565.00491A7B@il.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <OFB375B90B.5958A499-ONC2257565.0042E713-C2257565.00491A7B@il.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Michael Keller [MKELLER@il.ibm.com] wrote:
> 
> > As far as I know, "dm tables" are not stored persistently by the device
> > mapper tools. LVM is the one that stores and uses it from
> > initramfs/initrd. You will have to write your own tools to store the
> > configuration and use it. These tools will have to be included in the
> > initramfs/initrd for your thing to work on root device. You may need to
> > reserve some space on the device to store your configuration!
> 
> But now suppose, I added a simple dm-linear device in between LVM and the
> physical device - so to speak, a glass sheet on top of the physical volume.
> What would happen? I tried something similar outside the boot process: I
> put a dm-delay device on top of /dev/sda1 (which is a PV). The
> resulting /dev/mapper/delayed has no users, and obviously the logical
> volumes are not suddenly magically going through this device. On the other
> hand, when I did a pvscan, it would now report to me a physical volume
> called /dev/mapper/delayed, rather than /dev/sda1! I suppose from LVM's
> point of view, it just finds two identical devices (two devices with
> identical LVM metadata), and chooses to display ... well, one of them.

If your LVM used /dev/mapper/delayed device as a PV, that amounts to
inserting dm-delayed between LVM and the "physical volume". By default
LVM scans all block devices in /dev. You should add "filter" rules so
that LVM doesn't use /dev/sda1 but /dev/mapper/delayed. You will need
code to make it persistent though -- either LVM changes or new tools!

> This means that in the boot process, to support a similar setup, I'd need
> to create my device first, and then somehow instruct 'lvm vgscan' to make
> the correct choice. I think /etc/lvm/lvm.conf (included in initrd) allows
> me to do so. At this point this is clearly becoming an LVM question, rather
> than a device-mapper question.
> 
> Unless I missed something?

You are right! Look at multipath tools. Multipath tools also use device
mapper framework. People use LVM on top of multipath devices. Multipath
tools use device identification and don't need to store any metadata on
the devices themselves. You could probably use similar method depending
on what you want to do.

Thanks, Malahal.
