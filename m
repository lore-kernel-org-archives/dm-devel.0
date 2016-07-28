From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 7/7] multipathd: Fix a use-after-free
Date: Thu, 28 Jul 2016 06:57:20 -0700
Message-ID: <869a0286-9951-5d4a-256a-94df13c5bbe7@sandisk.com>
References: <bbd91f1e-a995-29d7-03cd-3e779249ec15@sandisk.com>
	<86fd1f05-b386-6d80-e537-ba8c78d23268@sandisk.com>
	<0d1da974-b53e-80fb-a533-b31cb558a6ca@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0d1da974-b53e-80fb-a533-b31cb558a6ca@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 07/28/16 06:45, Hannes Reinecke wrote:
> On 07/27/2016 11:14 PM, Bart Van Assche wrote:
>> diff --git a/multipathd/main.c b/multipathd/main.c
>> index f4c8245..6a4135c 100644
>> --- a/multipathd/main.c
>> +++ b/multipathd/main.c
>> @@ -2376,9 +2376,11 @@ child (void * param)
>>  	}
>>
>>  	lock(vecs->lock);
>> +	conf = get_multipath_config();
>>  	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
>>  		vector_foreach_slot(vecs->mpvec, mpp, i)
>>  			dm_queue_if_no_path(mpp->alias, 0);
>> +	put_multipath_config(conf);
>>  	remove_maps_and_stop_waiters(vecs);
>>  	unlock(vecs->lock);
>>
>>
> This one is already included in my patch 'multipathd: Correctly
> invalidate configuration during shutdown', which also contains some
> additional fixes for RCU config access.
>
> I would prefer taking that instead of this patch.

Hello Hannes,

You are right. I had not yet noticed that your patch includes the above 
change. Christophe, please drop this patch.

Bart.
