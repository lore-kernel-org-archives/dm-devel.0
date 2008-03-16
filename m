From: David Chinner <dgc@sgi.com>
Subject: Re: INFO: task mount:11202 blocked for more than 120
	seconds
Date: Mon, 17 Mar 2008 07:33:47 +1100
Message-ID: <20080316203347.GX95344431@sgi.com>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de>
	<20080307224040.GV155259@sgi.com>
	<alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de>
	<20080309213441.GQ155407@sgi.com> <47DA44EB.8000307@redhat.com>
	<alpine.DEB.1.00.0803150044130.4696@sheep.housecafe.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0803150044130.4696@sheep.housecafe.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com, David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Mar 15, 2008 at 12:58:02AM +0100, Christian Kujau wrote:
> On Fri, 14 Mar 2008, Milan Broz wrote:
> >Yes, there is bug in dm-crypt...
> >Please try if the patch here helps: http://lkml.org/lkml/2008/3/14/71
> 
> Hm, it seems to help the hangs, yes. Applied to today's -git a few hours 
> ago, the hangs are gone. However, when doing lots of disk I/O, the machine 
> locks up after a few (10-20) minutes. Sadly, netconsole got nothing :(
> 
> After the first lockup I tried again and shortly after bootup I got:

False positive. Memory reclaim can inverts the order of iprune_mutex and
the normal inode locking orders. i.e. Both of these are possible:

	do_something()
	enter memory reclaim
	iprune_mutex
	inode lock

or
	do_something()
	inode lock
	do_something_else
	enter memory reclaim
	iprune_mutex
	inode lock on different inode

So depending on what is seen first (in this case the first), the second
will trip lockdep. Neither are a deadlock, because the inode lock
held before memory reclaim is a referenced inode and will *never* be
on the free list for memory reclaim to deadlock on....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
