From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
	not mutex
Date: Fri, 10 Nov 2006 11:33:33 +1100
Message-ID: <20061110003332.GM8394166@melbourne.sgi.com>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<200611081310.19100.rjw@sisk.pl> <20061108180921.GA7708@ucw.cz>
	<200611091652.34649.rjw@sisk.pl>
	<20061109160003.GA24156@elf.ucw.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061109160003.GA24156@elf.ucw.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@osdl.org>, Eric Sandeen <sandeen@redhat.com>, Nigel Cunningham <nigel@suspend2.net>, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Nov 09, 2006 at 05:00:03PM +0100, Pavel Machek wrote:
> > > > Well, it looks like the interactions with dm add quite a bit of
> > > > complexity here.
> > > 
> > > What about just fixing xfs (thou shall not write to disk when kernel
> > > threads are frozen), and getting rid of blockdev freezing?
> > 
> > Well, first I must admit you were absolutely right being suspicious with
> > respect to this stuff.
> 
> (OTOH your patch found real bugs in suspend.c, so...)
> 
> > OTOH I have no idea _how_ we can tell xfs that the processes have been
> > frozen.  Should we introduce a global flag for that or something?
> 
> I guess XFS should just do all the writes from process context, and
> refuse any writing when its threads are frozen... I actually still
> believe it is doing the right thing, because you can't really write to
> disk from timer.

As per the recent thread about this, XFS threads suspend correctly
and XFS doesn't issue I/O from timers.

The problem appears to be per-cpu workqueues that don't get
suspended because suspend does not shut down workqueue threads. You
haven't quiesced the filesystem, you haven't shut down work
queues, but you're expecting the filesystem to magically stop
using them when suspend starts up?

You can't lay the blame on any subsystem for using an interface that
suspend doesn't quiesce when you *haven't told the subsystem it
should suspend itself*. This is true regardless of whether the
subsystem is a device driver, part of the network stack or a
filesystem.

e.g. A struct device has suspend and resume callouts so that each
device can be safely suspended and resumed. Suspend uses these and
you sure as hell don't expect a device to work properly after a
resume if you don't use these interfaces.

So why do you think filesystems should be treated differently?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
