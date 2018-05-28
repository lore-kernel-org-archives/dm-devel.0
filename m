From: Vito Caputo <vcaputo@pengaru.com>
Subject: Re: [REGRESSION] (>= v4.12) IO w/dmcrypt causing audio underruns
Date: Mon, 28 May 2018 10:34:00 -0700
Message-ID: <20180528173400.ph2ugyplbppbyrsd@shells.gnugeneration.com>
References: <20171129183919.GQ692@shells.gnugeneration.com>
 <20171201213322.GW692@shells.gnugeneration.com>
 <CAFqH_51LwG=txh_wDHvztWBN1fU_8zgXzdBJDxmzemcnpohKyg@mail.gmail.com>
 <20180117224852.3cr33lhot3rpahg7@shells.gnugeneration.com>
 <CAFqH_52Bpy8O6-F5XZm6G8emRY1dtufp8jNJTgjMtfvaOZ3okw@mail.gmail.com>
 <20180125083321.jmrsqpfszj6ugsay@shells.gnugeneration.com>
 <20180528033212.bmtxq3zyujsf7x4a@shells.gnugeneration.com>
 <CAFqH_535qWYRv4ApFZN5a-g0-MKxqfStG_FBnG5T+5L7sBpLeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFqH_535qWYRv4ApFZN5a-g0-MKxqfStG_FBnG5T+5L7sBpLeA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Enric Balletbo Serra <eballetbo@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Tim Murray <timmurray@google.com>, tj@kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Mon, May 28, 2018 at 07:01:36PM +0200, Enric Balletbo Serra wrote:
> Hi Vito,
> 
> cc: dm-devel, Alasdair and Mike Snitzer
> 
> 2018-05-28 5:32 GMT+02:00 Vito Caputo <vcaputo@pengaru.com>:
> > On Thu, Jan 25, 2018 at 12:33:21AM -0800, vcaputo@pengaru.com wrote:
> >> On Fri, Jan 19, 2018 at 11:57:32AM +0100, Enric Balletbo Serra wrote:
> >> > Hi Vito,
> >> >
> >> > 2018-01-17 23:48 GMT+01:00  <vcaputo@pengaru.com>:
> >> > > On Mon, Dec 18, 2017 at 10:25:33AM +0100, Enric Balletbo Serra wrote:
> >> > >> Hi Vito,
> >> > >>
> >> > >> 2017-12-01 22:33 GMT+01:00  <vcaputo@pengaru.com>:
> >> > >> > On Wed, Nov 29, 2017 at 10:39:19AM -0800, vcaputo@pengaru.com wrote:
> >> > >> >> Hello,
> >> > >> >>
> >> > >> >> Recently I noticed substantial audio dropouts when listening to MP3s in
> >> > >> >> `cmus` while doing big and churny `git checkout` commands in my linux git
> >> > >> >> tree.
> >> > >> >>
> >> > >> >> It's not something I've done much of over the last couple months so I
> >> > >> >> hadn't noticed until yesterday, but didn't remember this being a problem in
> >> > >> >> recent history.
> >> > >> >>
> >> > >> >> As there's quite an accumulation of similarly configured and built kernels
> >> > >> >> in my grub menu, it was trivial to determine approximately when this began:
> >> > >> >>
> >> > >> >> 4.11.0: no dropouts
> >> > >> >> 4.12.0-rc7: dropouts
> >> > >> >> 4.14.0-rc6: dropouts (seem more substantial as well, didn't investigate)
> >> > >> >>
> >> > >> >> Watching top while this is going on in the various kernel versions, it's
> >> > >> >> apparent that the kworker behavior changed.  Both the priority and quantity
> >> > >> >> of running kworker threads is elevated in kernels experiencing dropouts.
> >> > >> >>
> >> > >> >> Searching through the commit history for v4.11..v4.12 uncovered:
> >> > >> >>
> >> > >> >> commit a1b89132dc4f61071bdeaab92ea958e0953380a1
> >> > >> >> Author: Tim Murray <timmurray@google.com>
> >> > >> >> Date:   Fri Apr 21 11:11:36 2017 +0200
> >> > >> >>
> >> > >> >>     dm crypt: use WQ_HIGHPRI for the IO and crypt workqueues
> >> > >> >>
> >> > >> >>     Running dm-crypt with workqueues at the standard priority results in IO
> >> > >> >>     competing for CPU time with standard user apps, which can lead to
> >> > >> >>     pipeline bubbles and seriously degraded performance.  Move to using
> >> > >> >>     WQ_HIGHPRI workqueues to protect against that.
> >> > >> >>
> >> > >> >>     Signed-off-by: Tim Murray <timmurray@google.com>
> >> > >> >>     Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> >> > >> >>     Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> >> > >> >>
> >> > >> >> ---
> >> > >> >>
> >> > >> >> Reverting a1b8913 from 4.14.0-rc6, my current kernel, eliminates the
> >> > >> >> problem completely.
> >> > >> >>
> >> > >> >> Looking at the diff in that commit, it looks like the commit message isn't
> >> > >> >> even accurate; not only is the priority of the dmcrypt workqueues being
> >> > >> >> changed - they're also being made "CPU intensive" workqueues as well.
> >> > >> >>
> >> > >> >> This combination appears to result in both elevated scheduling priority and
> >> > >> >> greater quantity of participant worker threads effectively starving any
> >> > >> >> normal priority user task under periods of heavy IO on dmcrypt volumes.
> >> > >> >>
> >> > >> >> I don't know what the right solution is here.  It seems to me we're lacking
> >> > >> >> the appropriate mechanism for charging CPU resources consumed on behalf of
> >> > >> >> user processes in kworker threads to the work-causing process.
> >> > >> >>
> >> > >> >> What effectively happens is my normal `git` user process is able to
> >> > >> >> greatly amplify what share of CPU it takes from the system by generating IO
> >> > >> >> on what happens to be a high-priority CPU-intensive storage volume.
> >> > >> >>
> >> > >> >> It looks potentially complicated to fix properly, but I suspect at its core
> >> > >> >> this may be a fairly longstanding shortcoming of the page cache and its
> >> > >> >> asynchronous design.  Something that has been exacerbated substantially by
> >> > >> >> the introduction of CPU-intensive storage subsystems like dmcrypt.
> >> > >> >>
> >> > >> >> If we imagine the whole stack simplified, where all the IO was being done
> >> > >> >> synchronously in-band, and the dmcrypt kernel code simply ran in the
> >> > >> >> IO-causing process context, it would be getting charged to the calling
> >> > >> >> process and scheduled accordingly.  The resource accounting and scheduling
> >> > >> >> problems all emerge with the page cache, buffered IO, and async background
> >> > >> >> writeback in a pool of unrelated worker threads, etc.  That's how it
> >> > >> >> appears to me anyways...
> >> > >> >>
> >> > >> >> The system used is a X61s Thinkpad 1.8Ghz with 840 EVO SSD, lvm on dmcrypt.
> >> > >> >> The kernel .config is attached in case it's of interest.
> >> > >> >>
> >> > >> >> Thanks,
> >> > >> >> Vito Caputo
> >> > >> >
> >> > >> >
> >> > >> >
> >> > >> > Ping...
> >> > >> >
> >> > >> > Could somebody please at least ACK receiving this so I'm not left wondering
> >> > >> > if my mails to lkml are somehow winding up flagged as spam, thanks!
> >> > >>
> >> > >> Sorry I did not notice your email before you ping me directly. It's
> >> > >> interesting that issue, though we didn't notice this problem. It's a
> >> > >> bit far since I tested this patch but I'll setup the environment again
> >> > >> and do more tests to understand better what is happening.
> >> > >>
> >> > >
> >> > > Any update on this?
> >> > >
> >> >
> >> > I did not reproduce the issue for now. Can you try what happens if you
> >> > remove the WQ_CPU_INTENSIVE in the kcryptd_io workqueue?
> >> >
> >> > - cc->io_queue = alloc_workqueue("kcryptd_io", WQ_HIGHPRI |
> >> > WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM, 1);
> >> > cc->io_queue = alloc_workqueue("kcryptd_io", WQ_HIGHPRI | WQ_MEM_RECLAIM, 1);
> >> >
> >>
> >> FWIW if I change both "kcryptd" and "kcryptd_io" workqueues to just
> >> WQ_CPU_INTENSIVE, removing WQ_HIGHPRIO, the problem goes away.
> >>
> >> Doing this to "kcryptd_io" alone, as mentioned in my previous email, was
> >> ineffective.
> >>
> >> Perhaps revert just the WQ_HIGHPRIO bit from the dmcrypt workqueues?
> >>
> >
> >
> > Guys... this is still a problem in 4.17-rc6.
> >
> > I don't understand why this is being ignored.  It's pathetic, my laptop
> > can't even do a git checkout of the linux tree while playing mp3s
> > without the music skipping.
> >
> 
> Sorry, but it's easy to lost something on lkml, so adding the dm-devel
> ML and the maintainers.
> 
> > Reverting a1b8913 completely eliminates the problem.  What gives?
> >
> 
> IIRC the patch is there since 4.12 and I tried to reproduce the issue
> on at least two devices, my laptop and a Chromebook Pixel 2 without
> luck. Also, I am a bit surprised that nobody else has complained,
> maybe I missed it, and *of course*, this doesn't mean the issue is not
> there.
> 
> So, did anyone experience the same issue?
> 

FYI I've created https://bugzilla.kernel.org/show_bug.cgi?id=199857 to
track this issue more formally.

Thanks,
Vito Caputo
