From: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore not mutex
Date: Sun, 12 Nov 2006 18:43:10 +0000
Message-ID: <20061112184310.GC5081@ucw.cz>
References: <20061107183459.GG6993@agk.surrey.redhat.com> <20061109232438.GS30653@agk.surrey.redhat.com> <20061109233258.GH2616@elf.ucw.cz> <200611101303.33685.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752593AbWKLSnc@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200611101303.33685.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alasdair G Kergon <agk@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Nigel Cunningham <nigel@suspend2.net>, David Chinner <dgc@sgi.com>
List-Id: dm-devel.ids

Hi!

> > Okay, so you claim that sys_sync can stall, waiting for administator?
> > 
> > In such case we can simply do one sys_sync() before we start freezing
> > userspace... or just more the only sys_sync() there. That way, admin
> > has chance to unlock his system.
> 
> Well, this is a different story.
> 
> My point is that if we call sys_sync() _anyway_ before calling
> freeze_filesystems(), then freeze_filesystems() is _safe_ (either the
> sys_sync() blocks, or it doesn't in which case freeze_filesystems() won't
> block either).
> 
> This means, however, that we can leave the patch as is (well, with the minor
> fix I have already posted), for now, because it doesn't make things worse a
> bit, but:
> (a) it prevents xfs from being corrupted and

I'd really prefer it to be fixed by 'freezeable workqueues'. Can you
point me into sources -- which xfs workqueues are problematic?

(It would be nice to fix that for 2.6.19, and full bdev freezing looks
intrusive to me).

> (b) it prevents journaling filesystems in general from replaying journals
> after a failing resume.

I do not see b) as an useful goal.
							Pavel

-- 
Thanks for all the (sleeping) penguins.
