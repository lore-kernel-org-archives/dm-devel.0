From: Eric Wheeler <dm-devel@lists.ewheeler.net>
Subject: Re: [dm-devel] dm-crypt: fix lost ioprio when queuing crypto bios
 from task with ioprio
Date: Fri, 10 Mar 2017 17:08:48 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1703101651490.21446@mail.ewheeler.net>
References: <alpine.LRH.2.11.1612141049250.13402@mail.ewheeler.net> <alpine.LRH.2.11.1612161414280.9898@mail.ewheeler.net> <20161217155800.GA6580@redhat.com> <alpine.LRH.2.11.1612291856160.20227@mail.ewheeler.net> <20170105165518.GA7376@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170105165518.GA7376@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>, Shaohua Li <shli@kernel.org>, kent.overstreet@gmail.com, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Thu, 5 Jan 2017, Mike Snitzer wrote:

> On Thu, Dec 29 2016 at 11:08pm -0500,
> Eric Wheeler <dm-devel@lists.ewheeler.net> wrote:
> 
> > On Sat, 17 Dec 2016, Mike Snitzer wrote:
> > > On Fri, Dec 16 2016 at  5:29pm -0500,
> > > Eric Wheeler <dm-devel@lists.ewheeler.net> wrote:
> > > > On Wed, 14 Dec 2016, Eric Wheeler wrote:
> > > > > Since dm-crypt queues writes (and sometimes reads) to a different kernel
> > > > > thread (workqueue), the bios will dispatch from tasks with different
> > > > > io_context->ioprio settings than the submitting task, thus giving
> > > > > incorrect ioprio hints to the io scheduler.
> > > > 
> > > > The motivation of this patch is for ioprio-driven writebackup/bypass 
> > > > hinting inside bcache when bcache is under dm-crypt which Jens is picking 
> > > > up for 4.10:
> > > >   https://lkml.org/lkml/2016/12/6/607
> > > 
> > > I now see your commits:
> > > b71de4659fba4e42c7 bcache: introduce per-process ioprio-based bypass/writeback hints
> > > 82e7192711c3855038 bcache: documentation for ioprio cache hinting
> > > 
> > > You'd think this is the type of thing that you'd have proposed to a
> > > wider audience.  
> > 
> > ( Its not really relevant to this bugfix, but please see this thread since 
> >   you were curious about a wider audience discussion: 
> >   https://www.redhat.com/archives/dm-devel/2016-July/msg00556.html )
> > 
> > The note above in the previous email was intended to explain how we 
> > discovered the dm-crypt problem, purely as an example use case.  The 
> > stable commit note discusses the real issue: lost elevator hints.
> > 
> > This commit fixes elevator ioprio hints passing through dm-crypt and is 
> > not intended to address dm-cache, nor enable a bcache feature.
> > 
> > All impementations using ioprio hints beneath dm-crypt would 
> > benefit---most importantly, _CFQ_ !
> >   
> > As it is, all ioprio hints passing through dm-crypt are lost to the 
> > elevator; the elevator looses those useful bits because of queuing to 
> > another thread for crypto operations.
> 
> How did you test the change?

We discovered this by noticing that bcache never receives bios marked with 
ioprios that were submitted for writing by dm-crypt, but this seems to be 
an issue with dm-crypt specifically. Bcache gets ioprio information from 
upper-level drivers submitting from the original process context just 
fine. If the information is lost to bcache, it is certainly lost to the IO 
scheduler. Of course if ioprios are mapped between processes in some other 
way that I am missing, then please point that out for me.

Interestingly, before bio_ioprio was split out from bi_rw in about 
4.2-4.4, dm-crypt reads were marked fine because they do not usually get 
punted to another thread and complete from the submitting process. After 
splitting bi_ioprio out of bi_rw, reads broke because the simple cloning 
assignment of dst_bio->bi_rw = src_bio->bi_rw loses the priority bits. Of 
course this continues now that bi_rw has been pulled and changed into 
bi_opf.

I suspect there are other places where bi_rw assignments lost bi_ioprio 
assignments long ago, and this probably needs some research and 
fixup---but that is a separate issue from the dm-crypt issue.
 
> Or put differently: what is the easiest test to run against a dm-crypt
> device to verify that ioprio is being passed through?

You would probably need to modify dm-crypt just before it calls 
generic_make_request on the way out of writing bio's after encrypting 
either in kcryptd_crypt_write_io_submit or dmcrypt_write and calling 
something like WARN_ONCE if ioprio_valid(bio_prio(bio)).

Then set your IO priority using ionice on some process writing with direct 
IO to the mapper device and see if you get any warnings:
	ionice -c3 dd bs=1 of=/dev/mapper/cryptotest if=/dev/zero oflag=direct count=1

My guess is that you will not since bios are cloned without copying ioprio 
information and submitted from processes different from those of the 
calling thread.

I am curious what you find on your end, please let me know if you have any 
questions and thank you for your help!

--
Eric Wheeler

 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
