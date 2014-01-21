From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 1/2] dm-multipath: push back requests instead
 of queueing
Date: Tue, 21 Jan 2014 09:07:52 +0000
Message-ID: <11AF7C027C4C02408624617A4986078401028BC8@BPXM12GP.gisp.nec.co.jp>
References: <1389955328-107148-1-git-send-email-hare@suse.de>
	<1389955328-107148-2-git-send-email-hare@suse.de>
	<11AF7C027C4C02408624617A4986078401024EB7@BPXM12GP.gisp.nec.co.jp>
	<52DD4593.7090106@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <52DD4593.7090106@suse.de>
Content-Language: ja-JP
Content-ID: <9A737F1B09CDD046B0DF4603D02A1F7F@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 01/21/14 00:49, Hannes Reinecke wrote:
> On 01/20/2014 12:57 PM, Junichi Nomura wrote:
>> On 01/17/14 19:42, Hannes Reinecke wrote:
>>> @@ -1256,7 +1188,8 @@ static void pg_init_done(void *data, int errors)
>>>  		m->queue_io = 0;
>>>  
>>>  	m->pg_init_delay_retry = delay_retry;
>>> -	queue_work(kmultipathd, &m->process_queued_ios);
>>> +	if (!m->queue_io)
>>> +		dm_table_run_queue(m->ti->table);
>>>  
>>>  	/*
>>>  	 * Wake up any thread waiting to suspend.
>>
>> Does pg_init retry still work with this change?
>>
>> I suspect it doesn't. When a retry is requested in pg_init_done(),
>> m->queue_io is still 0 and somebody has to kick pg_init.
>>
>> Instead of replacing "process_queued_ios" work completely,
>> how about keeping it around and just replacing dispatch_queued_ios() by
>> dm_table_run_queue()?
>>
> I'd rather prefer to schedule the activate_path() workqueue item
> directly; no need to involve yet another workqueue here.

I would prefer it, too.
I thought it would make review easier if you could split this patch in 2;
one for removing the internal queue, the other for optimizing
process_queued_ios work.

> And we already know which path to activate.
>
> But yeah, it looks as if we need to reschedule activate_path() here.

-- 
Jun'ichi Nomura, NEC Corporation
