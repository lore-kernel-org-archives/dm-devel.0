From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/5] dm-multipath: push back requests instead
	of queueing
Date: Sat, 01 Feb 2014 14:51:36 +0100
Message-ID: <52ECFBE8.9090003@suse.de>
References: <1391159444-17987-1-git-send-email-hare@suse.de>
	<1391159444-17987-3-git-send-email-hare@suse.de>
	<20140131154042.GA17221@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140131154042.GA17221@redhat.com>
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
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 01/31/2014 04:40 PM, Mike Snitzer wrote:
> On Fri, Jan 31 2014 at  4:10am -0500,
> Hannes Reinecke <hare@suse.de> wrote:
>
>> There is no reason why multipath needs to queue requests
>> internally for queue_if_no_path or pg_init; we should
>> rather push them back onto the request queue.
>>
>> And while we're at it we can simplify the conditional
>> statement in map_io() to make it easier to read.
>>
>> Cc: Mike Snitzer <snitzer@redhat.com>
>> Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/md/dm-mpath.c         | 115 ++++++++++++++--------------------=
--------
>>   drivers/md/dm.c               |  13 +++++
>>   include/linux/device-mapper.h |   1 +
>>   3 files changed, 52 insertions(+), 77 deletions(-)
>
> ...
>
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index 0704c52..291491b 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -1912,6 +1912,19 @@ static int dm_any_congested(void *congested_data,=
 int bdi_bits)
>>   	return r;
>>   }
>>
>> +void dm_table_run_queue(struct dm_table *t)
>> +{
>> +	struct mapped_device *md =3D dm_table_get_md(t);
>> +	unsigned long flags;
>> +
>> +	if (md->queue) {
>> +		spin_lock_irqsave(md->queue->queue_lock, flags);
>> +		blk_run_queue_async(md->queue);
>> +		spin_unlock_irqrestore(md->queue->queue_lock, flags);
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(dm_table_run_queue);
>> +
>
> I think I agree with Junichi's previous point that this should live in
> dm-table.c.  You don't need the mapped_device, only the associated
> request_queue, so... I know I implemented something like
> dm_get_md_queue() before, but obviously it never went in for whatever
> reason.
>
> Anyway, I think something like this would be ideal (I renamed to
> dm_table_run_md_queue_async).  Please feel free to fold this in and
> repost with v4 of your patchset (assuming you'll be fixing up patch 3
> after you get Jun'ichi's feedback):
>
As mentioned, I don't mind.
The layering conventions in the device-mapper code still confuses
me occasionally.

I'll be folding it in.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
