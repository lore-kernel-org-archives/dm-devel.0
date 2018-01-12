From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V3 0/5]  dm-rq: improve sequential I/O performance
Date: Fri, 12 Jan 2018 12:18:41 -0500
Message-ID: <20180112171840.GA4541@redhat.com>
References: <20180111060159.12991-1-ming.lei@redhat.com>
 <20180111220742.GA31944@redhat.com>
 <1515710256.2752.72.camel@sandisk.com>
 <20180112014232.GB25090@ming.t460p>
 <20180112015721.GB32298@redhat.com>
 <20180112033308.GC25090@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180112033308.GC25090@ming.t460p>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On Thu, Jan 11 2018 at 10:33pm -0500,
Ming Lei <ming.lei@redhat.com> wrote:

> On Thu, Jan 11, 2018 at 08:57:21PM -0500, Mike Snitzer wrote:
> > On Thu, Jan 11 2018 at  8:42pm -0500,
> > Ming Lei <ming.lei@redhat.com> wrote:
> > 
> > > On Thu, Jan 11, 2018 at 10:37:37PM +0000, Bart Van Assche wrote:
> > > > On Thu, 2018-01-11 at 17:07 -0500, Mike Snitzer wrote:
> > > > > Bart, if for some reason we regress for some workload you're able to
> > > > > more readily test we can deal with it.  But I'm too encouraged by Ming's
> > > > > performance improvements to hold these changes back any further.
> > > > 
> > > > Sorry Mike but I think Ming's measurement results are not sufficient to
> > > > motivate upstreaming of these patches. What I remember from previous versions
> > > > of this patch series is that Ming measured the performance impact of this
> > > > patch series only for the Emulex FC driver (lpfc). That driver limits queue
> > > > depth to 3. Instead of modifying the dm code, that driver needs to be fixed
> > > > such that it allows larger queue depths.
> > > > 
> > > > Additionally, some time ago I had explained in detail why I think that patch
> > > > 2/5 in this series is wrong and why it will introduce fairness regressions
> > > > in multi-LUN workloads. I think we need performance measurements for this
> > > > patch series for at least the following two configurations before this patch
> > > > series can be considered for upstream inclusion:
> > > > * The performance impact of this patch series for SCSI devices with a
> > > >   realistic queue depth (e.g. 64 or 128).
> > > 
> > > Please look at the cover letter or patch 5's commit log, it mentions that
> > > dm-mpath over virtio-scsi is tested, and the default queue depth of virito-scsi
> > > is 128.
> > > 
> > > > * The performance impact for this patch series for a SCSI host with which
> > > >   multiple LUNs are associated and for which the target system often replies
> > > >   with the SCSI "BUSY" status.
> > > 
> > > I don't think this patch is related with this case, this patch just provides the
> > > BUSY feedback from underlying queue to blk-mq via dm-rq.
> > 
> > Hi Ming,
> > 
> > Please see https://www.redhat.com/archives/dm-devel/2017-April/msg00190.html
> > 
> > Specifically:
> > "That patch [commit 6077c2d706] can be considered as a first step that
> > can be refined further, namely by modifying the dm-rq code further such
> > that dm-rq queues are only rerun after the busy condition has been
> > cleared. The patch at the start of this thread is easier to review and
> > easier to test than any patch that would only rerun dm-rq queues after
> > the busy condition has been cleared."
> > 
> > Do you have time to reason through Bart's previous proposal for how to
> > better address the specific issue that was documented to be fixed in the
> > header for commit 6077c2d706 ?
> 
> Hi Mike,
> 
> Recently we fixed one such issue in blk-mq (eb619fdb2d4cb8b3d34), and I
> highly guess that may fix Bart's case.

Wow, kind of staggering that there was no mention of this fix prior to
now.  Seems _very_ relevant (like the real fix).

> Let's see this commit 6077c2d706 again, I don't know the idea behind the
> fix, which just adds random of 100ms, and this delay degrades performance a
> lot, since no hctx can be scheduled any more during the delay.

I'd love to try to reproduce the issue documented in commit
6077c2d706 but sadly I cannot get that srp-test to work on my system.
Just fails with:

# while srp-test/run_tests -d -r 30 -t 02-mq; do :; done
Unloaded the ib_srpt kernel module
Unloaded the rdma_rxe kernel module
Zero-initializing /dev/ram0 ... done
Zero-initializing /dev/ram1 ... done
Configured SRP target driver
Running test srp-test/tests/02-mq ...
Test file I/O on top of multipath concurrently with logout and login (0 min; mq)
SRP login failed
Test srp-test/tests/02-mq failed

Think the login is failing due to target not being setup properly?
Yeap, now from reading this thread, it is clear that srp-test only works
if you have an IB HCA:
https://patchwork.kernel.org/patch/10041381/

> So again it is definitely a workaround, no any reasoning, no any theory, just
> say it is a fix. Are there anyone who can explain the story?
> 
> IMO, the blk_get_request() in dm-mpath is just like a kmalloc(ATOMIC) which
> is used in other blk-mq drivers' IO path too, so don't know why dm-mq is so
> strange to require such ugly 100ms delay.

The header for commit 6077c2d706 notes that same action that Jens took
to unwedge the request stalls (in the patchwork thread I referenced
above), with:

echo run > /sys/kernel/debug/block/nullb1/state
vs what Bart noted in commit 6077c2d706:
echo run >/sys/kernel/debug/block/dm-0/state

Really does feel like the issue Jens' shared tags fix addressed _is_ the
root cause that commit 6077c2d706 worked around.

> So I suggest to remove it, let's see if there are reports, and if there
> are, I am quite confident we can root cause that and fix that.

Yeah, it really is rediculous that we're getting this kind of pushback
for something that was/is so poorly justified.  And especially given
that dm_mq_queue_rq() _still_ has this:

        if (ti->type->busy && ti->type->busy(ti))
                return BLK_STS_RESOURCE;

yet our desire to avoid blk_mq_delay_run_hw_queue(hctx, 100/*ms*/) in
response to blk_get_request() failure, just prior to returning
BLK_STS_RESOURCE in dm_mq_queue_rq(), is met with hellfire.

I refuse to submit to this highly unexpected cargo cult programming.

This is going upstream for 4.16:
https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/commit/?h=dm-4.16&id=5b18cff4baedde77e0d69bd62a13ae78f9488d89

I've lost patience with the unwillingness to reassess/justify the need
for commit 6077c2d706 ; SO it is just getting removed and we'll debug
and fix any future reported blk-mq stalls (and/or high cpu load) in a
much more precise manner -- provided the reporter is willing to work
with us!

Mike
