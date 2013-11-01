From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [RFC PATCH v2] dm mpath: add a queue_if_no_path
 timeout
Date: Fri, 1 Nov 2013 01:58:54 +0000
Message-ID: <11AF7C027C4C02408624617A49860784EE0B3F@BPXM12GP.gisp.nec.co.jp>
References: <20130926232241.GC31328@agk-dp.fab.redhat.com>
	<20130926234957.GA3658@redhat.com>
	<1382036590.1980.32.camel@bobble.lax.corp.google.com>
	<20131017191511.GA30452@redhat.com>
	<1382042759.1980.40.camel@bobble.lax.corp.google.com>
	<20131017211338.GB30993@redhat.com>
	<1382129515.1980.46.camel@bobble.lax.corp.google.com>
	<20131018225350.GB7553@redhat.com> <20131030010246.GA3611@redhat.com>
	<1383145687.6677.49.camel@bobble.lax.corp.google.com>
	<20131030154259.GA8206@redhat.com>
	<1383156565.17572.8.camel@bobble.lax.corp.google.com>
	<11AF7C027C4C02408624617A49860784EDC2C1@BPXM12GP.gisp.nec.co.jp>
	<1383229011.17572.12.camel@bobble.lax.corp.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1383229011.17572.12.camel@bobble.lax.corp.google.com>
Content-Language: ja-JP
Content-ID: <391B3C119B4F594EB9D1E5B0F0CB29AB@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frank Mayhar <fmayhar@google.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 10/31/13 23:16, Frank Mayhar wrote:
> On Thu, 2013-10-31 at 09:36 +0000, Junichi Nomura wrote:
>> On 10/31/13 03:09, Frank Mayhar wrote:
>>> On Wed, 2013-10-30 at 11:43 -0400, Mike Snitzer wrote:
>>>> On Wed, Oct 30 2013 at 11:08am -0400,
>>>> Frank Mayhar <fmayhar@google.com> wrote:
>>>>
>>>>> On Tue, 2013-10-29 at 21:02 -0400, Mike Snitzer wrote:
>>>>>> Any interest in this or should I just table it for >= v3.14?
>>>>>
>>>>> Sorry, I've been busy putting out another fire.  Yes, there's definitely
>>>>> still interest.  I grabbed your revised patch and tested with it.
>>>>> Unfortunately the timeout doesn't actually fire when requests are queued
>>>>> due to queue_if_no_path; IIRC the block request queue timeout logic
>>>>> wasn't triggering.  I planned to look into it more deeply figure out why
>>>>> but I had to spend all last week fixing a nasty race and hadn't gotten
>>>>> back to it yet.
>>>>
>>>> OK, Hannes, any idea why this might be happening?  The patch in question
>>>> is here: https://patchwork.kernel.org/patch/3070391/
>>>
>>> I got to this today and so far the most interesting I see is that the
>>> cloned request that's queued in multipath has no queue associated with
>>> it when it's queued; a printk reveals:
>>>
>>> [  517.610042] map_io: queueing rq ffff8801150e0070 q           (null)
>>>
>>> When it's eventually dequeued, it gets a queue from the destination
>>> device (in the pgpath) via bdev_get_queue().
>>>
>>> Because of this and from just looking at the code, blk_start_request()
>>> (and therefore blk_add_timer()) isn't being called for those requests,
>>> so there's never a chance that the timeout would happen.
>>>
>>> Does this make sense?  Or am I totally off-base?
>>
>> Hi,
>>
>> I haven't checked the above patch in detail but there is a problem;
>> abort_if_no_path() treats "rq" as a clone request, which it isn't.
>> "rq" is an original request.
>>
>> It shouldn't be a correct fix but just for testing purpose, you can try
>> changing:
>>   info = dm_get_rq_mapinfo(rq);
>> to
>>   info = dm_get_rq_mapinfo(rq->special);
>> and see what happens.
> 
> Well, at the moment this is kind of moot since abort_if_no_path() isn't
> being called.  But, regardless, don't we want to time out the clone
> request?  That is, after all, what is being queued in map_io().
> Unfortunately the clones don't appear to be associated with a request
> queue; they're just put on multipath's internal queue.

Hmm, "isn't being called" is strange.
If the clone is in multipath's internal queue, the original
should have been "started" from request queue point of view
and timeout should fire.

As for the "clone or original" question, if you are to use the block timer,
you have to use it for the original request (then perhaps let the handler
find its clone and kill it).
That's because (as you already see) clones are not associated with
request queue when it's queued in multipath internal queue
and when it's associated, it belongs to the lower device's queue.

-- 
Jun'ichi Nomura, NEC Corporation
