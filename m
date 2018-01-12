From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V3 0/5]  dm-rq: improve sequential I/O performance
Date: Fri, 12 Jan 2018 11:33:09 +0800
Message-ID: <20180112033308.GC25090@ming.t460p>
References: <20180111060159.12991-1-ming.lei@redhat.com>
 <20180111220742.GA31944@redhat.com>
 <1515710256.2752.72.camel@sandisk.com>
 <20180112014232.GB25090@ming.t460p>
 <20180112015721.GB32298@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180112015721.GB32298@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On Thu, Jan 11, 2018 at 08:57:21PM -0500, Mike Snitzer wrote:
> On Thu, Jan 11 2018 at  8:42pm -0500,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > On Thu, Jan 11, 2018 at 10:37:37PM +0000, Bart Van Assche wrote:
> > > On Thu, 2018-01-11 at 17:07 -0500, Mike Snitzer wrote:
> > > > Bart, if for some reason we regress for some workload you're able to
> > > > more readily test we can deal with it.  But I'm too encouraged by Ming's
> > > > performance improvements to hold these changes back any further.
> > > 
> > > Sorry Mike but I think Ming's measurement results are not sufficient to
> > > motivate upstreaming of these patches. What I remember from previous versions
> > > of this patch series is that Ming measured the performance impact of this
> > > patch series only for the Emulex FC driver (lpfc). That driver limits queue
> > > depth to 3. Instead of modifying the dm code, that driver needs to be fixed
> > > such that it allows larger queue depths.
> > > 
> > > Additionally, some time ago I had explained in detail why I think that patch
> > > 2/5 in this series is wrong and why it will introduce fairness regressions
> > > in multi-LUN workloads. I think we need performance measurements for this
> > > patch series for at least the following two configurations before this patch
> > > series can be considered for upstream inclusion:
> > > * The performance impact of this patch series for SCSI devices with a
> > >   realistic queue depth (e.g. 64 or 128).
> > 
> > Please look at the cover letter or patch 5's commit log, it mentions that
> > dm-mpath over virtio-scsi is tested, and the default queue depth of virito-scsi
> > is 128.
> > 
> > > * The performance impact for this patch series for a SCSI host with which
> > >   multiple LUNs are associated and for which the target system often replies
> > >   with the SCSI "BUSY" status.
> > 
> > I don't think this patch is related with this case, this patch just provides the
> > BUSY feedback from underlying queue to blk-mq via dm-rq.
> 
> Hi Ming,
> 
> Please see https://www.redhat.com/archives/dm-devel/2017-April/msg00190.html
> 
> Specifically:
> "That patch [commit 6077c2d706] can be considered as a first step that
> can be refined further, namely by modifying the dm-rq code further such
> that dm-rq queues are only rerun after the busy condition has been
> cleared. The patch at the start of this thread is easier to review and
> easier to test than any patch that would only rerun dm-rq queues after
> the busy condition has been cleared."
> 
> Do you have time to reason through Bart's previous proposal for how to
> better address the specific issue that was documented to be fixed in the
> header for commit 6077c2d706 ?

Hi Mike,

Recently we fixed one such issue in blk-mq (eb619fdb2d4cb8b3d34), and I
highly guess that may fix Bart's case.

Let's see this commit 6077c2d706 again, I don't know the idea behind the
fix, which just adds random of 100ms, and this delay degrades performance a
lot, since no hctx can be scheduled any more during the delay.

So again it is definitely a workaround, no any reasoning, no any theory, just
say it is a fix. Are there anyone who can explain the story?

IMO, the blk_get_request() in dm-mpath is just like a kmalloc(ATOMIC) which
is used in other blk-mq drivers' IO path too, so don't know why dm-mq is so
strange to require such ugly 100ms delay.

So I suggest to remove it, let's see if there are reports, and if there
are, I am quite confident we can root cause that and fix that.

> 
> Otherwise I fear we'll just keep hitting a wall with Bart...

I do test dm-mq over scsi-debug which is setup as two LUNs, and set
can_queue as 1, and this patchset just works well, not any IO hang.
And anyone can try and play with it.

Thanks,
Ming
