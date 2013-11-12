From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] dm-mpath: push back requests instead of
 queueing
Date: Tue, 12 Nov 2013 10:09:21 +0000
Message-ID: <11AF7C027C4C02408624617A49860784F0AF4D@BPXM12GP.gisp.nec.co.jp>
References: <1383901339-81536-1-git-send-email-hare@suse.de>
	<11AF7C027C4C02408624617A49860784F0A5F4@BPXM12GP.gisp.nec.co.jp>
	<5281E403.5020005@suse.de> <5281EB8C.9010800@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5281EB8C.9010800@suse.de>
Content-Language: ja-JP
Content-ID: <AAC1ED2C1D99B440B58983B67F9A4CA2@gisp.nec.co.jp>
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
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, device-mapper development <dm-devel@redhat.com>, Frank Mayhar <fmayhar@google.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 11/12/13 17:49, Hannes Reinecke wrote:
> On 11/12/2013 09:17 AM, Hannes Reinecke wrote:
>> On 11/12/2013 08:48 AM, Junichi Nomura wrote:
>>> On 11/08/13 18:02, Hannes Reinecke wrote:
>>>> @@ -1241,7 +1168,8 @@ static void pg_init_done(void *data, int errors)
>>>>  		m->queue_io = 0;
>>>>  
>>>>  	m->pg_init_delay_retry = delay_retry;
>>>> -	queue_work(kmultipathd, &m->process_queued_ios);
>>>> +	if (!m->queue_io)
>>>> +		dm_table_run_queue(m->ti->table);
>>>>  
>>>>  	/*
>>>>  	 * Wake up any thread waiting to suspend.
>>>
>>> process_queued_ios was responsible for retrying pg_init.
>>> And when retrying, m->queue_io is still 0.
>>> So don't we have to run queue unconditionally here
>>> or call __pg_init_all_paths() directly?

Sorry, I was going to write:
    And when retrying, m->queue_io is still *1*.
    So don't we have to run queue unconditionally here
    or call __pg_init_all_paths() directly?

# Though as far as a request has been requeued, blk_delay_queue
# repeatedly runs it anyway, as the queue isn't stopped..

>> In my rework I've _tried_ to separate both functions from
>> process_queued_ios().
>> But yes, you are right; I haven't considered pg_init_retry.
>> Will be updating the patch.
>>
> Actually, I have. I just had a closer look at the patch,
> and pg_init retry is handled, albeit differently than in
> the original.
> 
> It now works like this:
> 
> ->map_io() is called
>   -> calls '__switch_pg', which sets 'queue_io'
>   -> calls __pg_init_all_paths, which pushes activate_path
>      onto a workqueue
>   -> returns 'MAPIO_REQUEUE'
> 
> -> pg_init_done()
>   -> Checks pg_init_required
>      -> if non-zero some other I/O already
>         kicked off an 'activate_path',
>         so nothing to be done from our side
>      -> if zero we're calling kicking the queue
>         via blk_run_queue
> 
> And blk_run_queue() will be calling into ->request_fn,
> which will pull requests off the queue.
> So on the next request we're calling 'map_io', so the
> entire game starts anew, retrying pg_init.
> 
> The only thing we're not handling properly is the
> 'pg_init_delay_retry', as for that we should've
> started the queue with a certain delay, which
> we currently don't. But that's easily fixable.

-- 
Jun'ichi Nomura, NEC Corporation
