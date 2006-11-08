From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore not mutex
Date: Wed, 8 Nov 2006 18:09:22 +0000
Message-ID: <20061108180921.GA7708@ucw.cz>
References: <20061107183459.GG6993@agk.surrey.redhat.com> <20061107234951.GD30653@agk.surrey.redhat.com> <20061108023039.GF30653@agk.surrey.redhat.com> <200611081310.19100.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754430AbWKIJMU@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200611081310.19100.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alasdair G Kergon <agk@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Nigel Cunningham <nigel@suspend2.net>
List-Id: dm-devel.ids

Hi!

> > swsusp-freeze-filesystems-during-suspend-rev-2.patch
> > 
> > I think you need to give more thought to device-mapper
> > interactions here.  If an underlying device is suspended
> > by device-mapper without freezing the filesystem (the
> > normal state) and you issue a freeze_bdev on a device
> > above it, the freeze_bdev may never return if it attempts
> > any synchronous I/O (as it should).
> 
> Well, it looks like the interactions with dm add quite a bit of
> complexity here.

What about just fixing xfs (thou shall not write to disk when kernel
threads are frozen), and getting rid of blockdev freezing?

						Pavel
-- 
Thanks for all the (sleeping) penguins.
