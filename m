From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
	not mutex
Date: Fri, 10 Nov 2006 11:36:50 +0100
Message-ID: <20061110103650.GE3196@elf.ucw.cz>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<200611091652.34649.rjw@sisk.pl>
	<20061109160003.GA24156@elf.ucw.cz>
	<200611092059.48722.rjw@sisk.pl> <20061109211722.GA2616@elf.ucw.cz>
	<1163154249.7900.19.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1163154249.7900.19.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@osdl.org>, Eric Sandeen <sandeen@redhat.com>, Nigel Cunningham <nigel@suspend2.net>, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

HI!

> > Why not simply &~ PF_NOFREEZE on that particular process? Filesystems
> > are free to use threads/work queues/whatever, but refrigerator should
> > mean "no writes to filesystem" for them...
> 
> You can't go around altering the flags of another process - what locking
> are you relying upon for this ?

Well, my idea was for process to &~ PF_NOFREEZE on itself.

We are currently (kernel/power/process.c) using &p->sighand->siglock
for some accesses, and no locking for others. There were some attempts
to fix this, but they led to problems, and we are not hitting any
problems... part of reason is that we hot-unplug non-boot cpus before
freezing processes, so we are running UP at that point.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
