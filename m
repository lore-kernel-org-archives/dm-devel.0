From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore not mutex
Date: Thu, 9 Nov 2006 17:00:03 +0100
Message-ID: <20061109160003.GA24156@elf.ucw.cz>
References: <20061107183459.GG6993@agk.surrey.redhat.com> <200611081310.19100.rjw@sisk.pl> <20061108180921.GA7708@ucw.cz> <200611091652.34649.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1424089AbWKIQAS@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200611091652.34649.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alasdair G Kergon <agk@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Nigel Cunningham <nigel@suspend2.net>, David Chinner <dgc@sgi.com>
List-Id: dm-devel.ids

Hi!

> > > Well, it looks like the interactions with dm add quite a bit of
> > > complexity here.
> > 
> > What about just fixing xfs (thou shall not write to disk when kernel
> > threads are frozen), and getting rid of blockdev freezing?
> 
> Well, first I must admit you were absolutely right being suspicious with
> respect to this stuff.

(OTOH your patch found real bugs in suspend.c, so...)

> OTOH I have no idea _how_ we can tell xfs that the processes have been
> frozen.  Should we introduce a global flag for that or something?

I guess XFS should just do all the writes from process context, and
refuse any writing when its threads are frozen... I actually still
believe it is doing the right thing, because you can't really write to
disk from timer.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
