From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore not mutex
Date: Thu, 9 Nov 2006 22:41:59 +0100
Message-ID: <20061109214159.GB2616@elf.ucw.cz>
References: <20061107183459.GG6993@agk.surrey.redhat.com> <200611092059.48722.rjw@sisk.pl> <20061109211722.GA2616@elf.ucw.cz> <200611092218.58970.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S966060AbWKIVmT@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200611092218.58970.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alasdair G Kergon <agk@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Nigel Cunningham <nigel@suspend2.net>, David Chinner <dgc@sgi.com>
List-Id: dm-devel.ids

Hi!

> > > This is from a work queue, so in fact from a process context, but from
> > > a process that is running with PF_NOFREEZE.
> > 
> > Why not simply &~ PF_NOFREEZE on that particular process? Filesystems
> > are free to use threads/work queues/whatever, but refrigerator should
> > mean "no writes to filesystem" for them...
> 
> But how we differentiate worker_threads used by filesystems from the
> other ones?

I'd expect filesystems to do &~ PF_NOFREEZE by hand.

> BTW, I think that worker_threads run with PF_NOFREEZE for a reason,
> but what exactly is it?

I do not think we had particulary good reasons...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
