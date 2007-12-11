From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [dm-devel] [PATCH] improve atomicity of device creation
Date: Tue, 11 Dec 2007 19:25:32 +0100
Message-ID: <1197397532.2579.26.camel@lov.site>
References: <1197389316.25082.27.camel@quest>
	<20071211162538.GR22311@agk.fab.redhat.com>
	<1197391333.25082.31.camel@quest>
	<20071211170352.GS22311@agk.fab.redhat.com>
	<1197393526.25082.36.camel@quest>
	<3ae72650712110951h477d1fc0hd9abd39f069da105@mail.gmail.com>
	<20071211180829.GW22311@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20071211180829.GW22311@agk.fab.redhat.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-hotplug-devel@lists.sourceforge.net
List-Id: dm-devel.ids

On Tue, 2007-12-11 at 18:08 +0000, Alasdair G Kergon wrote:
> On Tue, Dec 11, 2007 at 06:51:31PM +0100, Kay Sievers wrote:
> > We can make the kernel's kobject_uevent() return the generated seqnum to
> > the caller.
> 
> Is 32 bits enough?

In the kernel it is 64 bit. Udev also uses 64bit number, but it does not
care about the value these days (netlink is never out of order,
unlike /sbin/hotplug). Only the udev queue export would break if the
number wraps around and duplicates are generated in a window of 180
seconds (the event process kills itself after that time). :)

So we would need to strip the upper 32 bit of the numbers we see from
udev, and handle the case where the 32 bit number wraps around.

> We added 'uint32_t padding;' recently which we I reckon we could now use for
> this.
> 
> dm_kobject_uevent() and alloc_dev() could keep a new field in
> struct mapped_device up-to-date, and a new function could return its
> value to dm-ioctl.c code to place into a renamed 'padding' field
> before returning to userspace?

Yes, we would return the kernel generated seqnum to the libdevmapper
ioctl.

Should we create an additional new iocl to request the device node
creation, or add that call to an existing one?

Could it be that we want to pass more properties to the event, which are
added as environment keys?

Kay


-------------------------------------------------------------------------
SF.Net email is sponsored by: 
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://sourceforge.net/services/buy/index.php
