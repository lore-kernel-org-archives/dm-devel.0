From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V3 0/5]  dm-rq: improve sequential I/O performance
Date: Thu, 11 Jan 2018 17:58:30 -0500
Message-ID: <20180111225830.GE31944@redhat.com>
References: <20180111060159.12991-1-ming.lei@redhat.com>
 <20180111220742.GA31944@redhat.com>
 <1515710256.2752.72.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515710256.2752.72.camel@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On Thu, Jan 11 2018 at  5:37pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Thu, 2018-01-11 at 17:07 -0500, Mike Snitzer wrote:
> > Bart, if for some reason we regress for some workload you're able to
> > more readily test we can deal with it.  But I'm too encouraged by Ming's
> > performance improvements to hold these changes back any further.
> 
> Sorry Mike but I think Ming's measurement results are not sufficient to
> motivate upstreaming of these patches. What I remember from previous versions
> of this patch series is that Ming measured the performance impact of this
> patch series only for the Emulex FC driver (lpfc). That driver limits queue
> depth to 3. Instead of modifying the dm code, that driver needs to be fixed
> such that it allows larger queue depths.

Sorry Bart but even in my test (using null_blk with queue depth of 8, 12
hw queues on 12 cpu system, with 12 fio jobs) it is yielding performance
improvement.  Going from 1350K iops to 1420K iops.  And 5275MB/s to
5532MB/s.  For sequential fio workload.

This test has been a staple of mine for a very long time.  The
improvement is very real (and hard to come by).  The iops improvement is
a bellweather for improved efficiency in the fast path.

So all your concern about Ming's testing is fine.  But you'd really help
me out a lot if you could give these changes a test.
 
> Additionally, some time ago I had explained in detail why I think that patch
> 2/5 in this series is wrong and why it will introduce fairness regressions
> in multi-LUN workloads.

You may think you explained it.. but IIRC it was very hand-wavvy.  If
you can provide a pointer to what you think was a compelling argument
then please do.

But I'm left very much unconvinced with your argument given what I see
in patch 2.  If blk_get_request() fails it follows that BLK_STS_RESOURCE
should be returned.  Why is the 100ms delay meaningful in that case for
SCSI?

> I think we need performance measurements for this
> patch series for at least the following two configurations before this patch
> series can be considered for upstream inclusion:
> * The performance impact of this patch series for SCSI devices with a
>   realistic queue depth (e.g. 64 or 128).
> * The performance impact for this patch series for a SCSI host with which
>   multiple LUNs are associated and for which the target system often replies
>   with the SCSI "BUSY" status.

OK, so please test it.

The changes are pretty easy to review.  This notion that these changes
are problematic rings very hollow given your lack of actual numbers (or
some other concerning observation rooted in testing fact) to back up
your position.

Mike
