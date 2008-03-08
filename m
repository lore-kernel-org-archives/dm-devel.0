From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC] An alternative interface to device mapper
Date: Sat, 8 Mar 2008 12:38:04 +0100
Message-ID: <20080308113803.GB4016@ucw.cz>
References: <200803050129.43172.phillips@phunq.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200803050129.43172.phillips@phunq.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Daniel Phillips <phillips@phunq.net>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi!

> The patch below includes a new kernel interface generator called ddlink.  
> The ddsetup device mapper interface is an instance of a ddlink 
> interface, instantiated by supplying domain-specific methods for read, 
> write, ioctl and poll.

> Unlike a pipe, there is no waiting for input on a ddlink: if there is 
> nothing to read then the read returns immediately with zero length.  If 
> some other behavior is desired it can be obtained using poll.

That's kind of strange, no?


> An early version of this code was shown to Eric Biederman and Alasdair 
> Kergon at OLS last year.  After taking all the C99 bits out, I managed 
> to convince Eric and others to actually read the examples.  Let us now 
> see if the (positive) reaction I observed at that time survives wider 
> scrutiny.
> 
> A diffstat for ddlink and ddsetup together:
> 
>  Documentation/ioctl-number.txt |    1

Should not description of interface go to Doc* somewhere?

>  block/ll_rw_blk.c              |    2
>  drivers/Makefile               |    1
>  drivers/ddlink.c               |  294 ++++++++++++++++++++
>  drivers/md/Makefile            |    1
>  drivers/md/dm-ioctl.c          |  593 ++++++++++++++++++++++++++++++++++++++---
>  drivers/md/dm-table.c          |   52 ---
>  drivers/md/dm.c                |   53 ---
>  drivers/md/dm.h                |   78 +++++
>  include/linux/ddlink.h         |   41 ++
>  include/linux/ddsetup.h        |   36 ++
>  include/linux/device-mapper.h  |   37 ++
>  12 files changed, 1056 insertions(+), 133 deletions(-)
> 
> Currently, this implements a majority of the device mapper interface 
> calls, but not all of them, so expect another hundred or two lines 
> before completion.  This is still significantly less code than the 
> original ioctl interface (which is still in there) and much clearer.
> 
> I have written two example programs, ddsetup.c and ddcreate.c.  The 
> former aims to be a drop-in replacement for dmsetup.c and the latter 
> implements a (useful) demonstration command that creates a virtual 
> device consisting of a single device mapper target, with all target 
> parameters supplied on the command line.
> 
> For example:
> 
>    ddcreate foo 10000 linear /dev/ubdb 1234
> 
> ddcreate is 71 lines long including plenty of whitespace, while being 
> quite general.  My message is about the 71 lines.
> 
> So who uses this ddsetup today?  Answer: nobody.  Better answer: the 
> ddsnap cluster snapshot driver has a usability problem because of its 
> reliance on PF_LOCAL sockets to glue components together.  Filesystem 
> based sockets were adopted for the component glue because it is hard to 
> do anything more elegant working with the command line device mapper 
> setup utility.  We looked at hacking the device mapper ioctl interface 
> to do what we needed, but then if we were willing to go that far then 
> why not just drop the other shoe and improve the userspace interface to 
> the point where it is actually pleasant to use, and maintainable too?  
> This is how ddsetup was born.
> 
> The next thing we need to do with this interface is demonstrate a solid 
> use case by adopting it on an experimental branch of zumastor.  I 
> expect both ddsnap and zumastor systems to shrink as a result, 
> including significantly shrinking the documentation.  This has not yet 
> been done yet, and until it is, this effort deserves to be firmly 
> relegated to the "nice but so what" category.  So, profound thanks to 
> you, dear reader, for having had the stamina to read all the way to 
> here, and we will see you here again after having eaten this delicious 
> new dogfood ourselves.
> 
> http://code.google.com/p/zumastor/source/browse/www/ddsetup/ddsetup-2.6.23.12
> http://code.google.com/p/zumastor/source/browse/www/ddsetup/ddsetup.c
> http://code.google.com/p/zumastor/source/browse/www/ddsetup/ddcreate.c
> 
> [ARND 07] How to not invent kernel interfaces, Arnd Bergmann, 
>    arnd@arndb.de, July 31, 2007
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
