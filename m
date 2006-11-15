From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
	not mutex
Date: Wed, 15 Nov 2006 19:50:29 +0100
Message-ID: <20061115185029.GA3722@elf.ucw.cz>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<20061109232438.GS30653@agk.surrey.redhat.com>
	<20061109233258.GH2616@elf.ucw.cz>
	<200611101303.33685.rjw@sisk.pl> <20061112184310.GC5081@ucw.cz>
	<20061112233054.GI11034@melbourne.sgi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061112233054.GI11034@melbourne.sgi.com>
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

> > > This means, however, that we can leave the patch as is (well, with the minor
> > > fix I have already posted), for now, because it doesn't make things worse a
> > > bit, but:
> > > (a) it prevents xfs from being corrupted and
> > 
> > I'd really prefer it to be fixed by 'freezeable workqueues'.
> 
> I'd prefer that you just freeze the filesystem and let the
> filesystem do things correctly.

Well, I'd prefer filesystems not to know about suspend, and current
"freeze the filesystem" does not really nest properly.

> > Can you
> > point me into sources -- which xfs workqueues are problematic?
> 
> AFAIK, its the I/O completion workqueues that are causing problems.
> (fs/xfs/linux-2.6/xfs_buf.c) However, thinking about it, I'm not
> sure that the work queues being left unfrozen is the real problem.
> 
> i.e. after a sync there's still I/O outstanding (e.g. metadata in
> the log but not on disk), and because the kernel threads are frozen
> some time after the sync, we could have issued this delayed write
> metadata to disk after the sync. With XFS, we can have a of queue of

That's okay, snapshot is atomic. As long as data are safely in the
journal, we should be okay.

> However, even if you stop the workqueue processing, you're still
> going to have to wait for all I/O completion to occur before
> snapshotting memory because having any I/O complete changes memory
> state.  Hence I fail to see how freezing the workqueues really helps
> at all here....

It is okay to change memory state, just on disk state may not change
after atomic snapshot.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
