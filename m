From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore not mutex
Date: Thu, 9 Nov 2006 22:18:57 +0100
Message-ID: <200611092218.58970.rjw@sisk.pl>
References: <20061107183459.GG6993@agk.surrey.redhat.com> <200611092059.48722.rjw@sisk.pl> <20061109211722.GA2616@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1424150AbWKIVVm@vger.kernel.org>
In-Reply-To: <20061109211722.GA2616@elf.ucw.cz>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Alasdair G Kergon <agk@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Nigel Cunningham <nigel@suspend2.net>, David Chinner <dgc@sgi.com>
List-Id: dm-devel.ids

Hi,

On Thursday, 9 November 2006 22:17, Pavel Machek wrote:
> Hi!
> 
> > > > OTOH I have no idea _how_ we can tell xfs that the processes have been
> > > > frozen.  Should we introduce a global flag for that or something?
> > > 
> > > I guess XFS should just do all the writes from process context, and
> > > refuse any writing when its threads are frozen... I actually still
> > > believe it is doing the right thing, because you can't really write to
> > > disk from timer.
> > 
> > This is from a work queue, so in fact from a process context, but from
> > a process that is running with PF_NOFREEZE.
> 
> Why not simply &~ PF_NOFREEZE on that particular process? Filesystems
> are free to use threads/work queues/whatever, but refrigerator should
> mean "no writes to filesystem" for them...

But how we differentiate worker_threads used by filesystems from the
other ones?

BTW, I think that worker_threads run with PF_NOFREEZE for a reason,
but what exactly is it?

Rafael


-- 
You never change things by fighting the existing reality.
		R. Buckminster Fuller
