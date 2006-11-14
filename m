From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
	not mutex
Date: Tue, 14 Nov 2006 11:10:07 +1100
Message-ID: <20061114001007.GZ8394166@melbourne.sgi.com>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<200611122343.06625.rjw@sisk.pl>
	<20061113054340.GP11034@melbourne.sgi.com>
	<200611131722.55446.rjw@sisk.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200611131722.55446.rjw@sisk.pl>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@osdl.org>, Eric Sandeen <sandeen@redhat.com>, Nigel Cunningham <nigel@suspend2.net>, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Pavel Machek <pavel@ucw.cz>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 13, 2006 at 05:22:54PM +0100, Rafael J. Wysocki wrote:
> On Monday, 13 November 2006 06:43, David Chinner wrote:
> > On Sun, Nov 12, 2006 at 11:43:05PM +0100, Rafael J. Wysocki wrote:
> > Before or after freezing of the kthreads? Order _could_ be
> > important, and different filesystems might require different
> > orders. What then?
> 
> Well, I don't really think the order is important.  If the freezing of work
> queues is done by the freezing of their respective worker threads, the
> other threads won't even know they have been frozen.

True - I just think that some defined ordering semantics might be
helpful for people trying to use workqueues and kthreads in
the future. It would also help us determine if the current usage
is safe as well...

> > > and if the resume is successful, we'll be
> > > able to continue (the state of memory will be the same as before the creation
> > > of the suspend image and the state of the disk will be the same as before the
> > > creation of the suspend image).
> > 
> > Assuming that you actually suspended an idle filesystem, which sync does not
> > guarantee you.
> 
> Even if it's not idle, we are safe as long as the I/O activity doesn't
> continue after the suspend image has been created.

And that is my great concern - there really is nothing to prevent
a fs from having I/O outstanding while the suspend image is being
created.

> > Rather than assuming the filesystem is idle, why not guarantee 
> > that it is idle by freezing it?
> 
> Well, _I_ personally think that the freezing of filesystems is the right thing
> to do, although it may lead to some complications down the road.

*nod*

I would also prefer to start with something we know is safe and work from
there.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
