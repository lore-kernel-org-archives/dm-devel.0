From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: Re: ANNOUNCE: mdadm 3.0 - A tool for managing Soft
	RAID under Linux
Date: Tue, 09 Jun 2009 18:29:53 +0200
Message-ID: <1244564993.2407.27.camel@o>
References: <18980.48553.328662.80987@notabene.brown>
	<4A25876A.1010901@garzik.org>
	<18981.62579.171350.910761@notabene.brown>
	<1244040123.6938.19.camel@o> <18989.40871.865610.422540@notabene.brown>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <18989.40871.865610.422540@notabene.brown>
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
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Arjan van de Ven <arjan@infradead.org>
List-Id: dm-devel.ids

On Tue, 2009-06-09 at 09:32 +1000, Neil Brown wrote:
> On Wednesday June 3, heinzm@redhat.com wrote:
> > > 
> > > I haven't spoken to them, no (except for a couple of barely-related
> > > chats with Alasdair).
> > > By and large, they live in their little walled garden, and I/we live
> > > in ours.
> > 
> > Maybe we are about to change that? ;-)
> 
> Maybe ... what should we talk about?
> 
> Two areas where I think we might be able to have productive
> discussion:
> 
>  1/ Making md personalities available as dm targets.
>     In one sense this is trivial as an block device can be a DM
>     target, and any md personality can be a block device.

Of course one could stack a linear target on any MD personality and live
with the minor overhead in the io path. The overhead to handle such
stacking on the tool side of things is not negligible though, hence it's
a better option to have native dm targets for these mappings.

>     However it might be more attractive if the md personality
>     responded to dm ioctls.

Indeed, we need the full interface to be covered in order to stay
homogeneous.

>     Considering specifically raid5, some aspects of plugging
>     md/raid5 underneath dm would be trivial - e.g. assembling the
>     array at the start.
>     However others are not so straight forward.
>     In particular, when a drive fails in a raid5, you need to update
>     the metadata before allowing any writes which depend on that drive
>     to complete.  Given that metadata is managed in user-space, this
>     means signalling user-space and waiting for a response.
>     md does this via a file in sysfs.  I cannot see any similar
>     mechanism in dm, but I haven't looked very hard.

We use events passed to a uspace daemon via an ioctl interface and our
suspend/resume mechanism to ensure such metadata updates.

> 
>     Would it be useful to pursue this do you think?

I looked at the MD personality back in time when I was searching for an
option to support RAID5 in dm but, like you similarly noted above,
didn't find a simple way to wrap it into a dm target so the answer *was*
no. That's why I picked some code (e.g. the RAID adressing) and
implemented a target of my own.

> 
> 
>  2/ It might be useful to have a common view how virtual devices in
>     general should be managed in Linux.  Then we could independently
>     migrated md and dm towards this goal.
> 
>     I imagine a block-layer level function which allows a blank
>     virtual device to be created, with an arbitrary major/minor
>     allocated.
>     e.g.
>          echo foo > /sys/block/.new
>     causes
>          /sys/devices/virtual/block/foo/
>     to be created.
>     Then a similar mechanism associates that with a particular driver.
>     That causes more attributes to appear in  ../block/foo/ which
>     can be used to flesh out the details of the device.
> 
>     There would be library code that a driver could use to:
>       - accept subordinate devices
>       - manage the state of those devices
>       - maintain a write-intent bitmap
>     etc.

Yes, and such library can be filled with ported dm/md and other code.

> 
>     There would also need to be a block-layer function to 
>     suspend/resume or similar so that a block device can be changed
>     underneath a filesystem.

Yes, consolidating such functionality in a central place is the proper
design but we still need an interface into any block driver which is
initiating io on its own behalf (e.g. mirror resynchronization) in order
to ensure, that such io gets suspended/resumed consistently

> 
>     We currently have three structures for a block device:
>       struct block_device -> struct gendisk -> struct request_queue
> 
>     I imagine allow either the "struct gendisk" or  the "struct
>     request_queue" to be swapped between two "struct block_device".
>     I'm not sure which, and the rest of the details are even more
>     fuzzy.
> 
>     That sort of infrastructure would allow interesting migrations
>     without being limited to "just with dm" or "just within md".

Or just with other virtual drivers such as drbd.

Hard to imagine issues at the detailed spec level before they are
fleshed out but this sounds like a good idea to start with.

Heinz

> 
>     Thoughts?
> 
> NeilBrown
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
