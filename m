From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 0/8] dm: add request-based blk-mq support
Date: Wed, 24 Dec 2014 14:26:43 -0500
Message-ID: <20141224192643.GA30461@redhat.com>
References: <20141219153801.GA8697@redhat.com>
	<20141219171438.GA6347@redhat.com> <5498389D.6070909@acm.org>
	<20141222184910.GB8054@redhat.com> <54999756.70303@acm.org>
	<1v2g6masssbu88ans1r6lres.1419354811001@email.android.com>
	<CAMM=eLd_A+fRBHDvcDqwF1a9co+G7XZvVhRyBd1AjxOdgjKhbA@mail.gmail.com>
	<549AB979.4050302@acm.org> <20141224182143.GA12922@redhat.com>
	<20141224185529.GA13246@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20141224185529.GA13246@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On Wed, Dec 24 2014 at  1:55pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, Dec 24 2014 at  1:21pm -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > This is odd considering blk-mq defaults to setting QUEUE_FLAG_IO_STAT,
> > so each request will have REQ_IO_STAT set.
> > 
> > I'm not sure what would account for this NULL pointer (my code appears
> > to be slightly different than yours but AFAICT req->part is NULL in your
> > crash, which shouldn't ever happen if IO stats are enabled).
> > 
> > Are you manually enabling/disabling IO stats via sysfs at all?
> 
> Answering my own question: unlikely.  Considering I was able to
> reproduce merely by creating an mpath device ontop of a blk-mq device
> (now that dm-mpath.c:__multipath_map sets rq->rq_disk).
> 
> I'll try to get to the bottom of it (it still seems pretty weird to me).

This fixes it:

diff --git a/block/blk-core.c b/block/blk-core.c
index cdd84e9..138ffb2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2030,6 +2030,8 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 		return -EIO;
 
 	if (q->mq_ops) {
+		if (blk_queue_io_stat(rq->q))
+			blk_account_io_start(rq, true);
 		blk_mq_insert_request(rq, false, true, true);
 		return 0;
 	}

I've folded this fix into this commit (and rebased the 'for-next' and
'dm-for-3.20-blk-mq' branches):
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=1fd5e9c83c4ae6a5144783855e9b29a8f42bdc4a
