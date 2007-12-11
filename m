From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: [dm-devel] [PATCH] improve atomicity of device creation
Date: Tue, 11 Dec 2007 18:51:31 +0100
Message-ID: <3ae72650712110951h477d1fc0hd9abd39f069da105@mail.gmail.com>
References: <1197389316.25082.27.camel@quest>
	<20071211162538.GR22311@agk.fab.redhat.com>
	<1197391333.25082.31.camel@quest>
	<20071211170352.GS22311@agk.fab.redhat.com>
	<1197393526.25082.36.camel@quest>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1197393526.25082.36.camel@quest>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-hotplug-devel@lists.sourceforge.net, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Dec 11, 2007 6:18 PM, Scott James Remnant <scott@ubuntu.com> wrote:
> On Tue, 2007-12-11 at 17:03 +0000, Alasdair G Kergon wrote:
>
> > On Tue, Dec 11, 2007 at 04:42:13PM +0000, Scott James Remnant wrote:
> > > What is that agreed design?
> >
> > In simple terms:
> >
> > - udev takes over full responsibility for creating nodes
> > [this will probably be a ./configure option]
> >
> Excellent, this is what we've wanted for a while.

Sounds fine.

> > - udev provides interface we use to wait until it has finished
> > processing all the outstanding requests we sent it.
> >
> What's this interface?
>
> I had a proposed patch that made udev write its sequence number to the
> kernel, and thus allowed any kobject add event to have a "bottom half"
> that could happen when udev had finished.  The idea was that the
> existing ioctls could then just block.

You want to block processes (doing ioctl) until udev has finished? Like a
kernel userspace transaction? Where could you see which requests you
will need to fulfill to continue the hanging processes?

It could work, but if something goes wrong, it seems pretty hard to recover
from such a failure. Just remember how firmware loading works. :)

> The other patch we tried a couple of releases ago was have devmapper
> spin until udev had caught up.

The currently running udev events are in: /dev/.udev/queue/<seqnum>. The last
seqnum that arrived in the udev daemon is: /dev/.udev/uevent_seqnum. So udev's
state is exported.

We can make the kernel's kobject_uevent() return the generated seqnum to
the caller. A devmapper ioctl, an existing one to extend, or a new one like
"create node" can return the seqnum to libdevmapper. Libdevmapper then
checks and spins until  /dev/.udev/uevent_seqnum has seen the seqnum,
and /dev/.udev/queue/<seqnum> does not exist.

Kay

-------------------------------------------------------------------------
SF.Net email is sponsored by: 
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://sourceforge.net/services/buy/index.php
