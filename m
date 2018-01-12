From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V3 0/5]  dm-rq: improve sequential I/O performance
Date: Fri, 12 Jan 2018 09:42:37 +0800
Message-ID: <20180112014232.GB25090@ming.t460p>
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On Thu, Jan 11, 2018 at 10:37:37PM +0000, Bart Van Assche wrote:
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
> 
> Additionally, some time ago I had explained in detail why I think that patch
> 2/5 in this series is wrong and why it will introduce fairness regressions
> in multi-LUN workloads. I think we need performance measurements for this
> patch series for at least the following two configurations before this patch
> series can be considered for upstream inclusion:
> * The performance impact of this patch series for SCSI devices with a
>   realistic queue depth (e.g. 64 or 128).

Please look at the cover letter or patch 5's commit log, it mentions that
dm-mpath over virtio-scsi is tested, and the default queue depth of virito-scsi
is 128.

> * The performance impact for this patch series for a SCSI host with which
>   multiple LUNs are associated and for which the target system often replies
>   with the SCSI "BUSY" status.

I don't think this patch is related with this case, this patch just provides the
BUSY feedback from underlying queue to blk-mq via dm-rq.

Thanks,
Ming
