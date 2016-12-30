From: Eric Wheeler <dm-devel@lists.ewheeler.net>
Subject: Re: dm-crypt: fix lost ioprio when queuing crypto bios from task
 with ioprio
Date: Thu, 29 Dec 2016 20:08:11 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1612291856160.20227@mail.ewheeler.net>
References: <alpine.LRH.2.11.1612141049250.13402@mail.ewheeler.net> <alpine.LRH.2.11.1612161414280.9898@mail.ewheeler.net> <20161217155800.GA6580@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161217155800.GA6580@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>, kent.overstreet@gmail.com
List-Id: dm-devel.ids

On Sat, 17 Dec 2016, Mike Snitzer wrote:
> On Fri, Dec 16 2016 at  5:29pm -0500,
> Eric Wheeler <dm-devel@lists.ewheeler.net> wrote:
> > On Wed, 14 Dec 2016, Eric Wheeler wrote:
> > > Since dm-crypt queues writes (and sometimes reads) to a different kernel
> > > thread (workqueue), the bios will dispatch from tasks with different
> > > io_context->ioprio settings than the submitting task, thus giving
> > > incorrect ioprio hints to the io scheduler.
> > 
> > The motivation of this patch is for ioprio-driven writebackup/bypass 
> > hinting inside bcache when bcache is under dm-crypt which Jens is picking 
> > up for 4.10:
> >   https://lkml.org/lkml/2016/12/6/607
> 
> I now see your commits:
> b71de4659fba4e42c7 bcache: introduce per-process ioprio-based bypass/writeback hints
> 82e7192711c3855038 bcache: documentation for ioprio cache hinting
> 
> You'd think this is the type of thing that you'd have proposed to a
> wider audience.  

( Its not really relevant to this bugfix, but please see this thread since 
  you were curious about a wider audience discussion: 
  https://www.redhat.com/archives/dm-devel/2016-July/msg00556.html )

The note above in the previous email was intended to explain how we 
discovered the dm-crypt problem, purely as an example use case.  The 
stable commit note discusses the real issue: lost elevator hints.

This commit fixes elevator ioprio hints passing through dm-crypt and is 
not intended to address dm-cache, nor enable a bcache feature.

All impementations using ioprio hints beneath dm-crypt would 
benefit---most importantly, _CFQ_ !
  
As it is, all ioprio hints passing through dm-crypt are lost to the 
elevator; the elevator looses those useful bits because of queuing to 
another thread for crypto operations.

> > The ioprio aware schedulers like CFQ and BFQ also benefit with more 
> > knowledge about the bio's when passing through dm-crypt.  It would be 
> > great if this can be accepted for 4.10, too.
> 
> It also needs more review, testing and possible re-working.  Each DM
> target shouldn't have to worry about these details (though I do grant
> that dm-crypt.c:clone_init call to bio_set_prio makes sense).

The patch is trivial: +5 lines in dm-crypt.c (excluding `if` bracing), a 
helper function in bio.h, and a 1-line fixup in bio.c.  Thus, the stable@ 
inclusion since it would probably patch down to v3.x somewhere and help 
everyone who uses dm-crypt with ionice.

Its only 4.10-rc1, and as a bugfix it could be accepted as a stable commit 
for 4.10-rc2 or later if you are willing to help dm-crypt users who use 
ionice.  Indeed, if you so choose, you could both accept this commit and 
still re-work it in 4.11.

This is to benefit everyone, using kernels both old and new.

Cheers,

-Eric


