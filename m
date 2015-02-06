From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH v2] block: do not merge two requests with sg
 gaps if unsupported
Date: Fri, 6 Feb 2015 22:13:27 +0000 (UTC)
Message-ID: <alpine.LNX.2.00.1502062207520.15481@localhost.lm.intel.com>
References: <1422137448-14747-1-git-send-email-keith.busch@intel.com>
	<20150206220053.GA12141@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150206220053.GA12141@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 6 Feb 2015, Mike Snitzer wrote:
> On Sat, Jan 24 2015 at  5:10P -0500,
> Keith Busch <keith.busch@intel.com> wrote:
>
>> This has request based dm inherit the QUEUE_FLAG_SG_GAPS flags from its
>> underlying block devices' request queues, and does not merge two requests
>> with sg gaps when required. This fixes problems when submitting cloned
>> requests to multipathed devices requiring virtually contiguous buffers.
>>
>> Signed-off-by: Keith Busch <keith.busch@intel.com>
>
> Hi Keith,
>
> I reviewed your patch and cleaned it up a little.  Just some whitespace
> nits and used test_bit().  I also renamed dm-table.c's
> queue_contiguous_sg() to queue_supports_sg_gaps() to follow the pattern
> established by the existing queue_supports_sg_merge().

Thanks Mike! Your modifications look good to me. I try to adapt to the
local lingo, but rarely get it right. :)

> Jens, provided you and Keith agree with my changes, and given that the
> initial request-based DM support for blk-mq will land during the 3.20
> merge: can you please pick this fix up for 3.20?  If you'd prefer to
> just take the block change I'm fine with picking up the DM portion.
>
> Let me know, thanks!
> Mike
