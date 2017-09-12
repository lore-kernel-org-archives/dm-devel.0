From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: dm-zoned: Avoid metadata flush writeback throttling
Date: Tue, 12 Sep 2017 17:01:52 +0900
Message-ID: <12416c57-9f34-07a0-154d-51ef62d61de5@wdc.com>
References: <20170724074422.23948-1-damien.lemoal@wdc.com>
	<20170724080320.GA16608@infradead.org>
	<0ee663a1-f497-1d10-f252-91fee072322a@wdc.com>
	<20170911150555.GA15818@redhat.com>
	<alpine.LRH.2.02.1709120206430.12577@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1709120206430.12577@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Mikulas,

On 9/12/17 15:12, Mikulas Patocka wrote:
> 
> 
> On Mon, 11 Sep 2017, Mike Snitzer wrote:
> 
>> On Mon, Jul 24 2017 at  5:16am -0400,
>> Damien Le Moal <damien.lemoal@wdc.com> wrote:
>>
>>>
>>>
>>> On 7/24/17 17:03, Christoph Hellwig wrote:
>>>> On Mon, Jul 24, 2017 at 04:44:22PM +0900, Damien Le Moal wrote:
>>>>> Avoid metadata flush to be blocked by the writeback throttling code in
>>>>> wbt_wait(). Otherwise, we can end up with a deadlock under heavy write
>>>>> load with all chunk works active. In such situation, a deadlock can
>>>>> happen if the flush work is blocked by the throttling code while holding
>>>>> the metadata lock: as the chunk works will wait for the metadata lock
>>>>> too, no progress can be made.
> 
> Could you explain, what's the specific problem here?
> 
> The writeback throttling code is executed at request level and the 
> dm-zoned target working above it, at bio level. So I don't see how 
> dm-zoned progress could be blocked by writeback throttling.

Request layer? All the code in block/blk-wbt.c acts on BIOs, in
particular the function wbt_wait() which is called before get_request()
in blk_queue_bio(), which is q->make_request_fn, so all of this happens
before a request even exists for the BIO. wbt_wait() calls
wbt_should_throttle() for the BIO to queue and will cause
blk_queue_bio() to sleep if that functions returns true and the number
of in-flight BIOs exceeds the set limit (wb_max, wb_normal or
wb_background).

Are we talking about a different throttling here ? Or am I entirely
missing something ?

> Maybe you have some other bug in your code and this patch just masks it?

Doing more testing with the current 4.13, I am now failing to reproduce
the hang. So you are right, it likely was something else.

In fact, analyzing writeback throttling more carefully, I realized that
the BIOs received by the chunk work and the metadata flush work BIOs are
throttled against different in-flight counters as the former BIOs are
issued to the target device queue while the latter are issued to the
target backing dev queue. As a result, one should not be blocking the
other. Chunk works may have to wait for metadata flush to complete
first, but that is before these works issue BIOs on the target bdev so
they cannot in turn block flush on a throttling condition.

Thanks for asking these hard questions!

Mike,

I will keep an eye open for issues but everything seems OK for now. So
let's drop this patch. My apologies for the noise.
Since bio_set_op_attrs() is deprecated, I will send a patch to remove
these calls.

Best regards.

-- 
Damien Le Moal,
Western Digital
