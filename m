From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: dm-raid: unsynced raid snapshot creation/deletion
 causes panic (work queue teardown race)
Date: Tue, 12 May 2015 12:38:10 +0200
Message-ID: <5551D812.1050106@redhat.com>
References: <1430310789-564-1-git-send-email-heinzm@redhat.com>
	<20150511203003.GB3804@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150511203003.GB3804@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



On 05/11/2015 10:30 PM, Mike Snitzer wrote:
> On Wed, Apr 29 2015 at  8:33am -0400,
> heinzm@redhat.com <heinzm@redhat.com> wrote:
>
>> From: Heinz Mauelshagen <heinzm@redhat.com>
>>
>> This patch avoids oopses caused by a callback racing
>> with the destrution of a mapping.
>>
>>
>> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
>> Tested-by: Heinz Mauelshagen <heinzm@redhat.com>
>>
>>
>> ---
>>   drivers/md/dm-raid.c | 18 ++++++++++++++++++
>>   1 file changed, 18 insertions(+)
>>
>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>> index 88e4c7f..fc4bc83 100644
>> --- a/drivers/md/dm-raid.c
>> +++ b/drivers/md/dm-raid.c
>> @@ -1614,6 +1614,17 @@ static void raid_presuspend(struct dm_target *ti)
>>   {
>>   	struct raid_set *rs = ti->private;
>>   
>> +	/*
>> +	 * Address a teardown race when calling
>> +	 * raid_(pre|post)suspend followed by raid_dtr:
>> +	 *
>> +	 * MD's call chain md_stop_writes()->md_reap_sync_thread()
>> +	 * causes work to be queued on the md_misc_wq queue
>> +	 * not flushing it, hence the callback can occur after
>> +	 * a potential destruction of the raid set causing an oops.
>> +	 */
>> +	rs->md.event_work.func = NULL;
>> +
>>   	md_stop_writes(&rs->md);
>>   }
>>   
>> @@ -1684,6 +1695,13 @@ static void raid_resume(struct dm_target *ti)
>>   {
>>   	struct raid_set *rs = ti->private;
>>   
>> +	/*
>> +	 * See "Address a teardown race" in raid_presuspend()
>> +	 *
>> +	 * Reenable the worker function.
>> +	 */
>> +	rs->md.event_work.func = do_table_event;
>> +
>>   	set_bit(MD_CHANGE_DEVS, &rs->md.flags);
>>   	if (!rs->bitmap_loaded) {
>>   		bitmap_load(&rs->md);
> The subject of this patch is strange (snapshot?)

Mike,
it was hit it with a test where a snapshot LV was created on a raid LV..

>
> Anyway, what flushes the md_misc_wq before you set it to NULL?

The work queue is empty when I set it to NULL, because recovery is still
ongoing. The OOPs is being triggered because md_reap_sync_thread()
being called from __md_stop_writes queues work again in case the worker
function is not NULL, hence causing it to be called when the raid_dtr() 
has teared
down the dm mapping already.

> Shouldn't that happen as part of presuspend?
>
> Also, is it really safe to set this to NULL out from underneath MD?

Rethinking based on your remark there may still be a race, because setting
the worker function to NULL  in raid_preresume() may  occur after an md 
worker
has queued event work for dm-raid already (e.g. in the cours of md error 
processng)
but md_misc_wq has not yet been run.

> Should a helper get exposed from MD with some extra locking?

A lightweight solution could be an MD recovery flag 
(MD_RECOVERY_DONT_CALLBACK ?) set
in raid_presuspend() preventing md_reap_sync_thread() from queueing work?

I.e.:
         if (mddev->event_work.func && 
!test_bit(MD_RECOVERY_DONT_CALLBACK, &mddev->recovery))
                   queue_work(md_misc_wq, &mddev->event_work);

Neil,
what do you think about this idea?

Heinz

>
> Mike
