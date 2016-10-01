From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] dm: Change return type of
 pg_init_all_paths() from int into void
Date: Sat, 1 Oct 2016 08:30:04 -0700
Message-ID: <47820332-7b29-96f7-a1c7-a7c6c00ccd56@sandisk.com>
References: <159b1209-ab2b-a0a0-bfeb-89edcefbc1a0@sandisk.com>
	<7c9f5edb-e967-d4da-9437-ff8a9a375b72@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7c9f5edb-e967-d4da-9437-ff8a9a375b72@suse.de>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 10/01/16 00:53, Hannes Reinecke wrote:
> On 09/30/2016 07:44 PM, Bart Van Assche wrote:
>> None of the callers of pg_init_all_paths() check its return value.
>> Hence change the return type of pg_init_all_paths() from int into
>> void.
>>
>> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
>> ---
>>  drivers/md/dm-mpath.c | 7 ++-----
>>  1 file changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
>> index dd66653..8e2341d 100644
>> --- a/drivers/md/dm-mpath.c
>> +++ b/drivers/md/dm-mpath.c
>> @@ -378,16 +378,13 @@ static int __pg_init_all_paths(struct multipath *m)
>>  	return atomic_read(&m->pg_init_in_progress);
>>  }
>>
>> -static int pg_init_all_paths(struct multipath *m)
>> +static void pg_init_all_paths(struct multipath *m)
>>  {
>> -	int r;
>>  	unsigned long flags;
>>
>>  	spin_lock_irqsave(&m->lock, flags);
>> -	r = __pg_init_all_paths(m);
>> +	__pg_init_all_paths(m);
>>  	spin_unlock_irqrestore(&m->lock, flags);
>> -
>> -	return r;
>>  }
>>
>>  static void __switch_pg(struct multipath *m, struct priority_group *pg)
>>
> Hmm. But this would invalidate your earlier patch, now would it not?
>
> And at least in my code we _do_ check the return value in
> pg_init_done(), and it's return value is used to check if we need to
> wake up for submitting waiting I/O.
>
> Which tree is the patch made against?

Hello Hannes,

This patch applies on top of kernel v4.8-rc8. In that kernel version the 
return value of __pg_init_all_paths() is used but the return value of 
pg_init_all_paths() is not used by any caller.

Bart.
