From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: [PATCH 1/2] md/raid0: Introduce new array state
 'broken' for raid0
Date: Tue, 30 Jul 2019 08:43:13 -0300
Message-ID: <20348d5f-fa41-58f1-a7d8-2989233b97f1@canonical.com>
References: <20190729203135.12934-1-gpiccoli@canonical.com>
	<20190729203135.12934-2-gpiccoli@canonical.com>
	<87wog0l6u2.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87wog0l6u2.fsf@notabene.neil.brown.name>
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
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org, jay.vosburgh@canonical.com, songliubraving@fb.com, dm-devel@redhat.com, Neil F Brown <nfbrown@suse.com>
List-Id: dm-devel.ids

On 29/07/2019 21:11, NeilBrown wrote:
> [...]
>> -	else {
>> +
>> +		if ((mddev->pers->level == 0) &&
> 
> Don't test if ->level is 0.  Instead, test if ->is_missing_dev is not
> NULL.
> 
> NeilBrown

Hi Neil, thanks for the feedback. I'll change that in a potential V2,
(if the patches are likely to be accepted), good idea.
Cheers,


Guilherme


> 
> 
>> +		   ((st == clean) || (st == broken))) {
>> +			if (mddev->pers->is_missing_dev(mddev))
>> +				st = broken;
>> +			else
>> +				st = clean;
>> +		}
>> +	} else {
>>  		if (list_empty(&mddev->disks) &&
>>  		    mddev->raid_disks == 0 &&
>>  		    mddev->dev_sectors == 0)
>> @@ -4315,6 +4329,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
>>  		break;
>>  	case write_pending:
>>  	case active_idle:
>> +	case broken:
>>  		/* these cannot be set */
>>  		break;
>>  	}
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 41552e615c4c..e7b42b75701a 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -590,6 +590,8 @@ struct md_personality
>>  	int (*congested)(struct mddev *mddev, int bits);
>>  	/* Changes the consistency policy of an active array. */
>>  	int (*change_consistency_policy)(struct mddev *mddev, const char *buf);
>> +	/* Check if there is any missing/failed members - RAID0 only for now. */
>> +	bool (*is_missing_dev)(struct mddev *mddev);
>>  };
>>  
>>  struct md_sysfs_entry {
>> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
>> index 58a9cc5193bf..79618a6ae31a 100644
>> --- a/drivers/md/raid0.c
>> +++ b/drivers/md/raid0.c
>> @@ -455,6 +455,31 @@ static inline int is_io_in_chunk_boundary(struct mddev *mddev,
>>  	}
>>  }
>>  
>> +bool raid0_is_missing_dev(struct mddev *mddev)
>> +{
>> +	struct md_rdev *rdev;
>> +	static int already_missing;
>> +	int def_disks, work_disks = 0;
>> +	struct r0conf *conf = mddev->private;
>> +
>> +	def_disks = conf->strip_zone[0].nb_dev;
>> +	rdev_for_each(rdev, mddev)
>> +		if (rdev->bdev->bd_disk->flags & GENHD_FL_UP)
>> +			work_disks++;
>> +
>> +	if (unlikely(def_disks - work_disks)) {
>> +		if (!already_missing) {
>> +			already_missing = 1;
>> +			pr_warn("md: %s: raid0 array has %d missing/failed members\n",
>> +				mdname(mddev), (def_disks - work_disks));
>> +		}
>> +		return true;
>> +	}
>> +
>> +	already_missing = 0;
>> +	return false;
>> +}
>> +
>>  static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
>>  {
>>  	struct r0conf *conf = mddev->private;
>> @@ -789,6 +814,7 @@ static struct md_personality raid0_personality=
>>  	.takeover	= raid0_takeover,
>>  	.quiesce	= raid0_quiesce,
>>  	.congested	= raid0_congested,
>> +	.is_missing_dev	= raid0_is_missing_dev,
>>  };
>>  
>>  static int __init raid0_init (void)
>> -- 
>> 2.22.0
