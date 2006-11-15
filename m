From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore not mutex
Date: Wed, 15 Nov 2006 21:23:48 +0100
Message-ID: <20061115202348.GB3875@elf.ucw.cz>
References: <20061107183459.GG6993@agk.surrey.redhat.com> <20061115185029.GA3722@elf.ucw.cz> <200611152056.48218.rjw@sisk.pl> <200611152100.35054.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030969AbWKOUYH@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200611152100.35054.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Chinner <dgc@sgi.com>, Alasdair G Kergon <agk@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Nigel Cunningham <nigel@suspend2.net>
List-Id: dm-devel.ids

Hi!

> > There's one more thing, actually.  If the on-disk data and metadata are
> > changed _after_ the sync we do and _before_ we create the snapshot image,
> > and the subsequent  resume fails,
> 
> Well, but this is equivalent to a power failure immediately after the sync, so
> there _must_ be a way to recover the filesystem from that, no?

Exactly.

> I think I'll prepare a patch for freezing the work queues and we'll see what
> to do next.

Thanks!
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
