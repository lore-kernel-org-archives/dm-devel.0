From: Keith Busch <keith.busch@intel.com>
Subject: Re: blk-mq request allocation stalls
Date: Mon, 12 Jan 2015 18:22:12 +0000 (UTC)
Message-ID: <alpine.LNX.2.00.1501121818510.4026@localhost.lm.intel.com>
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
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54B40E8A.6010005@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Mon, 12 Jan 2015, Jens Axboe wrote:
> On 01/12/2015 10:53 AM, Keith Busch wrote:
>> Is the nr_active count correct prior to starting the mkfs test? Trying
>> to see if someone is calling "blk_mq_alloc_tag_set()" twice on the same
>> set. It might be good to add a WARN if this is detected anyway.
>
> That might be a good debug aid, I agree. But the above doesn't look like it's 
> corrupted. If you add the values, you get 60 and 62 for the two cases, which 
> seems to indicate that we did bump the values correctly, but for some reason 
> we never did the decrement on completion. Hence we stabilize around the queue 
> depth of the device, which will be 62 +/- a bit due to the sharing.
>
> I'm not familiar with how rq based dm works. We clone the original request 
> (which has the RQ_MQ_INFLIGHT flag set), then we issue the clone(s) to the 
> underlying device(s)? And when that completes, we complete the original? That 
> would work fine with the flag on the original request. Maybe I'm missing 
> something, and I'll let more knowledgeable people discuss that.

Oh, let's look at "__blk_rq_prep_clone". dm calls that after
blk_get_request() for the blk-mq based multipath types and overrides the
destinations cmd_flags with the source's even though the source was not
allocated from a blk-mq based queue, much less a shared tag.
