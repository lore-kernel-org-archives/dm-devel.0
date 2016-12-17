From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt: fix lost ioprio when queuing crypto bios from task
 with ioprio
Date: Sat, 17 Dec 2016 10:58:00 -0500
Message-ID: <20161217155800.GA6580@redhat.com>
References: <alpine.LRH.2.11.1612141049250.13402@mail.ewheeler.net>
 <alpine.LRH.2.11.1612161414280.9898@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1612161414280.9898@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
To: Eric Wheeler <dm-devel@lists.ewheeler.net>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Fri, Dec 16 2016 at  5:29pm -0500,
Eric Wheeler <dm-devel@lists.ewheeler.net> wrote:

> On Wed, 14 Dec 2016, Eric Wheeler wrote:
> > Since dm-crypt queues writes (and sometimes reads) to a different kernel
> > thread (workqueue), the bios will dispatch from tasks with different
> > io_context->ioprio settings than the submitting task, thus giving
> > incorrect ioprio hints to the io scheduler.
> 
> The motivation of this patch is for ioprio-driven writebackup/bypass 
> hinting inside bcache when bcache is under dm-crypt which Jens is picking 
> up for 4.10:
>   https://lkml.org/lkml/2016/12/6/607

I now see your commits:
b71de4659fba4e42c7 bcache: introduce per-process ioprio-based bypass/writeback hints
82e7192711c3855038 bcache: documentation for ioprio cache hinting

You'd think this is the type of thing that you'd have proposed to a
wider audience.  I'm sure you're aware that dm-cache exists?

If you did then it would've been on my radar with a shot of having DM in
shape in time for 4.10.

> Without assigning the ioprio before queuing to the en/decrypt queues, 
> bcache isn't notified of the priority---and presumably neither is the IO 
> scheduler.
> 
> The ioprio aware schedulers like CFQ and BFQ also benefit with more 
> knowledge about the bio's when passing through dm-crypt.  It would be 
> great if this can be accepted for 4.10, too.

The time for 4.10 inclusion has passed.  This needs to wait until 4.11.

It also needs more review, testing and possible re-working.  Each DM
target shouldn't have to worry about these details (though I do grant
that dm-crypt.c:clone_init call to bio_set_prio makes sense).

A more generic solution is needed (likely in DM core).

A while ago, Vivek floated a patch that spoke to the need for iocontext
(for the purposes of cgroups):
 https://patchwork.kernel.org/patch/8485451/

I don't consider your patch too dissimilar.  But it just needs to be
worked on during a development window.  On to 4.11 ;)

Mike
