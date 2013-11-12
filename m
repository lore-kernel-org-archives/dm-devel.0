From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] dm-mpath: push back requests instead of
 queueing
Date: Tue, 12 Nov 2013 10:00:52 +0000
Message-ID: <11AF7C027C4C02408624617A49860784F0AE9C@BPXM12GP.gisp.nec.co.jp>
References: <1383901339-81536-1-git-send-email-hare@suse.de>
	<11AF7C027C4C02408624617A49860784F0A5F4@BPXM12GP.gisp.nec.co.jp>
	<5281E403.5020005@suse.de>
	<11AF7C027C4C02408624617A49860784F0A9D8@BPXM12GP.gisp.nec.co.jp>
	<5281EF56.8030808@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5281EF56.8030808@suse.de>
Content-Language: ja-JP
Content-ID: <9A8877D3FB1A774ABBC530E7E472AB51@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, device-mapper development <dm-devel@redhat.com>, Frank Mayhar <fmayhar@google.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 11/12/13 18:05, Hannes Reinecke wrote:
> On 11/12/2013 09:43 AM, Junichi Nomura wrote:
>> On 11/12/13 17:17, Hannes Reinecke wrote:
>>> On 11/12/2013 08:48 AM, Junichi Nomura wrote:
>>>> On 11/08/13 18:02, Hannes Reinecke wrote:
>>>>> In doing so we can also remove the ->busy check as a requeue is identical
>>>>> to ->busy returning 'true' from the callers perspective. This simplifies
>>>>> the code by quite a lot.
>>>>
>>>> They are not identical.
>>>> ->busy returns true when underlying path cannot dispatch a request
>>>> immediately. In that case it's better to keep the request in queue
>>>> to allow merges.  (It used to have real impact on buffered sequential
>>>> write + fsync workload, though the performance impact might become
>>>> smaller in recent kernels due to plugging change.)
>>>> Also ->busy can be used by upper layer (dm_table_any_busy_target).
>>>> So you can't just remove it.
>>>>
>>> But they are identical from the callers perspective:
>>> drivers/md/dm.c:dm_request_fn()
>>>
>>> 		if (ti->type->busy && ti->type->busy(ti))
>>> 			goto delay_and_out;
>>>
>>> 		clone = dm_start_request(md, rq);
>>>
>>> 		spin_unlock(q->queue_lock);
>>> 		if (map_request(ti, clone, md))
>>> 			goto requeued;
>>>
>>> 		BUG_ON(!irqs_disabled());
>>> 		spin_lock(q->queue_lock);
>>> 	}
>>>
>>> 	goto out;
>>>
>>> requeued:
>>> 	BUG_ON(!irqs_disabled());
>>> 	spin_lock(q->queue_lock);
>>>
>>> delay_and_out:
>>> 	blk_delay_queue(q, HZ / 10);
>>>
>>> So the only difference between ->busy and return 'DM_MAPIO_REQUEUE'
>>> is that 'busy' runs under the queue_lock.
>>
>> A difference is whether the request is once dequeued or not.
>> I think requeued request does not accept any merge.
>>
> Hmm. Now _that_ is a valid point.
> But I would've thought all possible merges are already done by
> the time request_fn() is called.
> If not multipathing would be working suboptimal anyway, as a
> potential merge has been missed even during normal I/O.
> 
>> But the point is not there; if you remove ->busy, nobody checks whether
>> underlying device is busy and DM_MAPIO_REQUEUE won't be returned.
>> So the other option might be moving ->busy check in request_fn to
>> inside of map function and let it return DM_MAPIO_REQUEUE.
>>
> ???
> 
> But that's precisely what the patch is doing, no?
> The only thing we're not doing in map_io() is to check for
> pgpath_busy(), but that would be pointless as a busy pgpath
> would return DM_MAPIO_REQUEUE anyway.

No.  As you've removed __pgpath_busy(), nobody calls
dm_underlying_device_busy(), which calls scsi_lld_busy().

> We _could_ optimize this in __switch_pg(), to call pgpath_busy()
> when selecting the paths. But that should be done by the path selector.
> So for that we would need to separate the functionality of the
> path selector and __switch_pg; currently it's unclear whether
> we need to call pgpath_busy() in __switch_pg or not.

There is no need to call pgpath_busy in __switch_pg.

If we call __pgpath_busy() in map function, I think it's here:

	if (pgpath) {
+ 		if (__pgpath_busy(pgpath))
+ 			r = DM_MAPIO_REQUEUE;
		else if (pg_ready(m)) {
			... // remap
			r = DM_MAPIO_REMAPPED;
		} else {
			__pg_init_all_paths(m);
			r = DM_MAPIO_REQUEUE;
		}
	...

or in a path selector.

> The main reason for removing 'busy' is that it's really hard
> to do right for the queue_if_no_path case.
> We can easily do a ->busy check during pg_init (by just checking
> ->queue_io), but the queue_if_no_path _condition_ is only
> established after we've called __switch_pg(). Which is precisely
> what we do _not_ want here.
> Maybe we should add a flag here; 'all_paths_down' or something.
> That could be easily checked from ->busy. Plus it can only be
> unset on 'reinstate_path'. Hmm.

-- 
Jun'ichi Nomura, NEC Corporation
