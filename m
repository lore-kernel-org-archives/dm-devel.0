From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
	not mutex
Date: Fri, 17 Nov 2006 00:38:53 +0100
Message-ID: <20061116233853.GB6757@elf.ucw.cz>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<200611152100.35054.rjw@sisk.pl> <20061115202348.GB3875@elf.ucw.cz>
	<200611152258.52160.rjw@sisk.pl>
	<20061116232057.GH11034@melbourne.sgi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061116232057.GH11034@melbourne.sgi.com>
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

> > > > I think I'll prepare a patch for freezing the work queues and we'll see what
> > > > to do next.
> > > 
> > > Thanks!
> > 
> > Okay, the patch follows.
> > 
> > I've been running it for some time on my boxes and it doesn't seem to break
> > anything.  However, I don't use XFS, so well ...
> 
> So you haven't actually tested whether it fixes anything or whether
> it introduces any regressions?

Noone has a testcase for a problem; swsusp just does not eat
filesystems in practice. Fill free to test the patch, but I'm pretty
sure it will not break anything.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
