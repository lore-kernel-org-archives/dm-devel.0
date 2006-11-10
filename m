From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
	not mutex
Date: Fri, 10 Nov 2006 11:38:35 +0100
Message-ID: <20061110103835.GF3196@elf.ucw.cz>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<200611081310.19100.rjw@sisk.pl> <20061108180921.GA7708@ucw.cz>
	<200611091652.34649.rjw@sisk.pl>
	<20061109160003.GA24156@elf.ucw.cz>
	<20061110003332.GM8394166@melbourne.sgi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061110003332.GM8394166@melbourne.sgi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Chinner <dgc@sgi.com>
Cc: Andrew Morton <akpm@osdl.org>, Eric Sandeen <sandeen@redhat.com>, Nigel Cunningham <nigel@suspend2.net>, linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi!

> > > OTOH I have no idea _how_ we can tell xfs that the processes have been
> > > frozen.  Should we introduce a global flag for that or something?
> > 
> > I guess XFS should just do all the writes from process context, and
> > refuse any writing when its threads are frozen... I actually still
> > believe it is doing the right thing, because you can't really write to
> > disk from timer.
> 
> As per the recent thread about this, XFS threads suspend correctly
> and XFS doesn't issue I/O from timers.
> 
> The problem appears to be per-cpu workqueues that don't get
> suspended because suspend does not shut down workqueue threads. You

Workqueues should be easy to handle. current->flags &= ~PF_NONFREEZE,
and problem should be solved.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
