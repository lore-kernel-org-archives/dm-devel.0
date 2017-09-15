From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 5/5] dm-mpath: improve I/O schedule
Date: Fri, 15 Sep 2017 16:10:24 -0400
Message-ID: <20170915201023.GB28136@redhat.com>
References: <20170915164456.9803-1-ming.lei@redhat.com>
 <20170915164456.9803-6-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170915164456.9803-6-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: dm-devel@redhat.com, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>
List-Id: dm-devel.ids

On Fri, Sep 15 2017 at 12:44pm -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> The actual I/O schedule is done in dm-mpath layer, and the
> underlying I/O schedule is simply bypassed.
> 
> This patch sets underlying queue's nr_requests as its queue's
> queue_depth, then  we can get its queue busy feedback by simply
> checking if blk_get_request() returns successfully.
> 
> In this way, dm-mpath can reports its queue busy to block layer
> effectively, so I/O scheduling is improved much.
> 
> Follows the test results on lpfc*:
> 
> - fio(libaio, bs:4k, dio, queue_depth:64, 64 jobs,
>       over dm-mpath disk)
> - system(12 cores, dual sockets, mem: 64G)
> 
> ---------------------------------------
>           |v4.13+         |v4.13+
>           |+scsi_mq_perf  |+scsi_mq_perf+patches
> -----------------------------------------
>  IOPS(K)  |MQ-DEADLINE    |MQ-DEADLINE
> ------------------------------------------
> read      |       30.71   |      343.91
> -----------------------------------------
> randread  |       22.98   |       17.17
> ------------------------------------------
> write     |       16.45   |      390.88
> ------------------------------------------
> randwrite |       16.21   |       16.09
> ---------------------------------------
> 
> *:
> 1) lpfc.lpfc_lun_queue_depth=3, so that it is same with .cmd_per_lun
> 2) scsi_mq_perf means the patchset of 'blk-mq-sched: improve SCSI-MQ performance(V4)'[1]
> 3) v4.13+: top commit is 46c1e79fee41 Merge branch 'perf-urgent-for-linus'
> 4) the patchset 'blk-mq-sched: improve SCSI-MQ performance(V4)' focuses
> on improving on SCSI-MQ, and all the test result in that coverletter was
> against the raw lpfc/ib(run after 'multipath -F'), instead of dm-mpath.
> 5) this patchset itself doesn't depend on the scsi_mq_perf patchset[1]
> 
> [1] https://marc.info/?t=150436555700002&r=1&w=2
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Very impressive gains Ming!

I'll review in more detail next week but Bart's concerns on patch 1 and
2 definitely need consideration.

Thanks,
Mike
