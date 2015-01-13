From: Keith Busch <keith.busch@intel.com>
Subject: Re: blk-mq request allocation stalls
Date: Tue, 13 Jan 2015 15:27:33 +0000 (UTC)
Message-ID: <alpine.LNX.2.00.1501131523050.4026@localhost.lm.intel.com>
References: <alpine.LNX.2.00.1501071755110.4026@localhost.lm.intel.com>
	<20150109194955.GA32641@redhat.com>
	<54B042FE.2000205@kernel.dk> <54B043FC.8000902@kernel.dk>
	<20150109214015.GA1032@redhat.com> <54B04E94.3010403@kernel.dk>
	<20150109222543.GA1190@redhat.com>
	<54B071DC.9000307@kernel.dk> <20150110014811.GA2384@redhat.com>
	<54B08779.2080705@kernel.dk> <20150110031057.GA2823@redhat.com>
	<54B3DE54.7090909@sandisk.com> <54B3EB4A.9090404@kernel.dk>
	<54B3F255.5080802@sandisk.com> <54B3F78D.2020704@kernel.dk>
	<54B3FE89.200@sandisk.com> <54B3FFAE.4070609@kernel.dk>
	<alpine.LNX.2.00.1501121738000.4026@localhost.lm.intel.com>
	<54B40E8A.6010005@kernel.dk>
	<alpine.LNX.2.00.1501121818510.4026@localhost.lm.intel.com>
	<alpine.LNX.2.00.1501121830010.4026@localhost.lm.intel.com>
	<54B532EE.20700@kernel.dk>
	<alpine.LNX.2.00.1501131507570.4026@localhost.lm.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LNX.2.00.1501131507570.4026@localhost.lm.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Tue, 13 Jan 2015, Keith Busch wrote:
> On Tue, 13 Jan 2015, Jens Axboe wrote:
>> Making the two cases different is a bit... nonsensical. We should do this 
>> for both cases, if safe, or move the MQ_INFLIGHT flag and expand the 
>> CLONE_MASK.
>
> Expanding the clone mask won't do any good since the src doesn't come
> from blk-mq and wouldn't ever have MQ_INFLIGHT set. Blk-mq initializes
> the cmd_flags when you get one so I assumed OR'ing was safe. For the
> non-blk-mq case, we have no guarantees how the req was initialized and
> could have nonsense cmd_flags.

I take back the last part. We required blk_rq_init be called on the
request prior to calling blk_rq_prep_clone, making it safe to OR in all
the time.

diff --git a/block/blk-core.c b/block/blk-core.c
index 7e78931..b40b5d2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2895,7 +2895,7 @@ EXPORT_SYMBOL_GPL(blk_rq_unprep_clone);
  static void __blk_rq_prep_clone(struct request *dst, struct request *src)
  {
  	dst->cpu = src->cpu;
-	dst->cmd_flags = (src->cmd_flags & REQ_CLONE_MASK) | REQ_NOMERGE;
+	dst->cmd_flags |= (src->cmd_flags & REQ_CLONE_MASK) | REQ_NOMERGE;
  	dst->cmd_type = src->cmd_type;
  	dst->__sector = blk_rq_pos(src);
  	dst->__data_len = blk_rq_bytes(src);
