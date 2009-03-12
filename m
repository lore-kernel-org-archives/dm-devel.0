From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 0/8] dm: request-based dm-multipath
Date: Thu, 12 Mar 2009 10:40:29 +0900
Message-ID: <49B8680D.6050007@ct.jp.nec.com>
References: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>	<20090128154019.GB23158@agk.fab.redhat.com>	<49815863.8040806@ct.jp.nec.com>	<20090129104147.GB9870@pentland.suse.de>	<4982B4C6.8050904@ct.jp.nec.com>	<49B60444.2090008@ct.jp.nec.com>
	<49B613FE.3060501@suse.de>	<49B6221E.1030203@ct.jp.nec.com>
	<49B7AE6D.1080301@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49B7AE6D.1080301@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Hannes,

On 2009/03/11 21:28 +0900, Hannes Reinecke wrote:
> Hi Kiyoshi,
> 
> Kiyoshi Ueda wrote:
>> Hi Hannes,
>>
> [ .. ]
>>
>> Suspend was broken.
>> dm_suspend() recognized that suspend completed while some requests
>> were still in flight.  So we could swap/free the in-use table while
>> there was in_flight request.
>> The patch is like the attached one, although it is not finalized and
>> I'm testing now.
>> I'll post an updated patch-set including the attached patch
>> this week or next week.
>>
>>
>> ---
>>  drivers/md/dm.c |  236
>> ++++++++++++++++++++++++++++++++++----------------------
>>  1 file changed, 144 insertions(+), 92 deletions(-)
>>
>> Index: 2.6.29-rc2/drivers/md/dm.c
>> ===================================================================
>> --- 2.6.29-rc2.orig/drivers/md/dm.c
>> +++ 2.6.29-rc2/drivers/md/dm.c
>> @@ -701,11 +701,17 @@ static void free_bio_clone(struct reques
>>      }
>>  }
>>  
>> -static void dec_rq_pending(struct dm_rq_target_io *tio)
>> +/*
>> + * XXX: Not taking queue lock for efficiency.
>> + *      For correctness, waiters will check that again with queue
>> lock held.
>> + *      No false negative because this function will be called everytime
>> + *      in_flight is decremented.
>> + */
>> +static void rq_completed(struct mapped_device *md)
>>  {
>> -    if (!atomic_dec_return(&tio->md->pending))
>> +    if (!md->queue->in_flight)
>>          /* nudge anyone waiting on suspend queue */
>> -        wake_up(&tio->md->wait);
>> +        wake_up(&md->wait);
>>  }
>>  
> Hmm. Don't think that's a good idea. Either take the spinlock here or
> in_flight should be atomic.

Thank you for the comment.
OK, I'll change to take queue_lock here for maintenancability now,
although the queue_lock is not needed logically.
Then, I'll have another patch to drop the queue_lock for efficiency
in the future.

Thanks,
Kiyoshi Ueda
