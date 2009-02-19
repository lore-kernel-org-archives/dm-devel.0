From: malahal@us.ibm.com
Subject: Re: Device-mapper for write monitoring
Date: Thu, 19 Feb 2009 06:28:07 -0800
Message-ID: <20090219142807.GA26662@us.ibm.com>
References: <OF2FA15171.EBB61656-ONC2257562.00256C52-C2257562.002C88F5@il.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <OF2FA15171.EBB61656-ONC2257562.00256C52-C2257562.002C88F5@il.ibm.com>
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
> For our block-based incremental backup software we need to monitor all
> writes to a device, and report them to our user mode application for
> further processing. Our plan is to add a virtual block device of our own
> "on top" of every block device to be monitored. Our driver then intercepts
> all writes to this virtual device, executes the appropriate logic, and
> eventually passes it on to the underlying device.
> 
> Should we consider writing this as a dm target?
> 
> Some points that came up in discussions with other folks:
> 1. The "mapping" part itself is really trivial - it's an identity mapping.
> Does this mean, we are really abusing the dm infrastructure?

Don't think so. There are targets that have near 'identity mapping'
(dm-delay) and multipath target will have 'identity mapping' too, apart
from managing multiple paths!

In general, dm targets process the I/O without the help of any user land
code for performance.

> 2. What are the actual gains from writing a dm target over writing a
> dedicated driver? The following comes to mind: writing less setup code, a
> user space library, tools (dmsetup).

Yes. But then you will also get all the limitations/unimplemented
features of device-mapper framework too. E.g. barrier support comes to
mind! This is just an example, the simple barrier support might go to
upstream before you actually begin using your target though.

> 3. Are the interfaces of the device mapper relatively stable? (Assume that
> our target is not general enough to be included into mainline, and we'll
> have to do the API chasing ourselves.)

I don't think API changes, if any, give you a big trouble.

> I was also hoping that the device-mapper can somehow help us with
> monitoring the device hosting the root filesystem. Device-mapper apparently
> comes with some special support, which allows it to, e.g., mount root on a
> logical volume. Does this work for any device-mapper targets, or just for
> inbuilt ones? Where do you store the configuration information (dm tables)
> anyway, so that it's accessible before root is mounted?

As far as I know, "dm tables" are not stored persistently by the device
mapper tools. LVM is the one that stores and uses it from
initramfs/initrd. You will have to write your own tools to store the
configuration and use it. These tools will have to be included in the
initramfs/initrd for your thing to work on root device. You may need to
reserve some space on the device to store your configuration!
