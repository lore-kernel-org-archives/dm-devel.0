From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V3 0/5]  dm-rq: improve sequential I/O performance
Date: Sat, 13 Jan 2018 10:10:51 -0500
Message-ID: <20180113151051.GA11158@redhat.com>
References: <20180112015721.GB32298@redhat.com>
 <20180112033308.GC25090@ming.t460p>
 <20180112171840.GA4541@redhat.com>
 <1515778013.2396.3.camel@wdc.com>
 <20180112174000.GB5134@redhat.com>
 <1515779211.2396.11.camel@wdc.com>
 <20180112180635.GD5134@redhat.com>
 <1515783288.2396.37.camel@wdc.com>
 <20180112223117.GA6332@redhat.com>
 <20180113150434.GC8013@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180113150434.GC8013@ming.t460p>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@fb.com" <axboe@fb.com>
List-Id: dm-devel.ids

On Sat, Jan 13 2018 at 10:04am -0500,
Ming Lei <ming.lei@redhat.com> wrote:

> On Fri, Jan 12, 2018 at 05:31:17PM -0500, Mike Snitzer wrote:
> > 
> > Ming or Jens: might you be able to shed some light on how dm-mpath
> > would/could set BLK_MQ_S_SCHED_RESTART?  A new function added that can
> 
> When BLK_STS_RESOURCE is returned from .queue_rq(), blk_mq_dispatch_rq_list()
> will check if BLK_MQ_S_SCHED_RESTART is set.
> 
> If it has been set, the queue won't be rerun for this request, and the queue
> will be rerun until one in-flight request is completed, see blk_mq_sched_restart()
> which is called from blk_mq_free_request().
> 
> If BLK_MQ_S_SCHED_RESTART isn't set, queue is rerun in blk_mq_dispatch_rq_list(),
> and BLK_MQ_S_SCHED_RESTART is set before calling .queue_rq(), see
> blk_mq_sched_mark_restart_hctx() which is called in blk_mq_sched_dispatch_requests().
> 
> This mechanism can avoid continuous running queue in case of STS_RESOURCE, that
> means drivers wouldn't worry about that by adding random delay.

Great, thanks for the overview.  Really appreciate it.

Mike
