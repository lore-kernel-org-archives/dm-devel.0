Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0192837F
	for <dm-devel@lists.linux.dev>; Mon,  4 Dec 2023 14:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.40] (g40.guest.molgen.mpg.de [141.14.220.40])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 371C261E5FE03;
	Mon,  4 Dec 2023 15:08:20 +0100 (CET)
Message-ID: <83ad1add-314e-4e1a-bfd4-30123b032460@molgen.mpg.de>
Date: Mon, 4 Dec 2023 15:08:19 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] md: split MD_RECOVERY_NEEDED out of mddev_resume
Content-Language: en-US
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 dm-devel@lists.linux.dev, song@kernel.org, yukuai3@huawei.com,
 janpieter.sollie@edpnet.be, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com
References: <20231204031703.3102254-1-yukuai1@huaweicloud.com>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20231204031703.3102254-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Yu,


Thank you for your patch.

Am 04.12.23 um 04:17 schrieb Yu Kuai:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> New mddev_resume() calls are added to synchroniza IO with array

synchronize

> reconfiguration, however, this introduce a regression while adding it in

1.  Maybe: … performance regression …
2.  introduce*s*

> md_start_sync():
> 
> 1) someone set MD_RECOVERY_NEEDED first;

set*s*

> 2) daemon thread grab reconfig_mutex, then clear MD_RECOVERY_NEEDED and
>     queue a new sync work;

grab*s*, clear*s*, queue*s*

> 3) daemon thread release reconfig_mutex;

release*s*

> 4) in md_start_sync
>     a) check that there are spares that can be added/removed, then suspend
>        the array;
>     b) remove_and_add_spares may not be called, or called without really
>        add/remove spares;
>     c) resume the array, then set MD_RECOVERY_NEEDED again!
> 
> Loop between 2 - 4, then mddev_suspend() will be called quite often, for
> consequence, normal IO will be quite slow.

It’d be great if you could document the exact “test case”, and numbers.

> Fix this problem by spliting MD_RECOVERY_NEEDED out of mddev_resume(), so

split*t*ing

> that md_start_sync() won't set such flag and hence the loop will be broken.
> 
> Fixes: bc08041b32ab ("md: suspend array in md_start_sync() if array need reconfiguration")
> Reported-and-tested-by: Janpieter Sollie <janpieter.sollie@edpnet.be>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218200
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/dm-raid.c   | 1 +
>   drivers/md/md-bitmap.c | 2 ++
>   drivers/md/md.c        | 6 +++++-
>   drivers/md/raid5.c     | 4 ++++
>   4 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index eb009d6bb03a..e9c0d70f7fe5 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -4059,6 +4059,7 @@ static void raid_resume(struct dm_target *ti)
>   		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>   		mddev->ro = 0;
>   		mddev->in_sync = 0;
> +		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   		mddev_unlock_and_resume(mddev);
>   	}
>   }
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 9672f75c3050..16112750ee64 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2428,6 +2428,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
>   	}
>   	rv = 0;
>   out:
> +	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	mddev_unlock_and_resume(mddev);
>   	if (rv)
>   		return rv;
> @@ -2571,6 +2572,7 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
>   	if (old_mwb != backlog)
>   		md_bitmap_update_sb(mddev->bitmap);
>   
> +	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	mddev_unlock_and_resume(mddev);
>   	return len;
>   }
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4b1e8007dd15..48a1b12f3c2c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -515,7 +515,6 @@ void mddev_resume(struct mddev *mddev)
>   	percpu_ref_resurrect(&mddev->active_io);
>   	wake_up(&mddev->sb_wait);
>   
> -	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	md_wakeup_thread(mddev->thread);
>   	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
>   
> @@ -4146,6 +4145,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
>   	md_new_event();
>   	rv = len;
>   out_unlock:
> +	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	mddev_unlock_and_resume(mddev);
>   	return rv;
>   }
> @@ -4652,6 +4652,8 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
>    out:
>   	if (err)
>   		export_rdev(rdev, mddev);
> +	else
> +		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	mddev_unlock_and_resume(mddev);
>   	if (!err)
>   		md_new_event();
> @@ -5533,6 +5535,7 @@ serialize_policy_store(struct mddev *mddev, const char *buf, size_t len)
>   		mddev_destroy_serial_pool(mddev, NULL);
>   	mddev->serialize_policy = value;
>   unlock:
> +	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	mddev_unlock_and_resume(mddev);
>   	return err ?: len;
>   }
> @@ -6593,6 +6596,7 @@ static void autorun_devices(int part)
>   					export_rdev(rdev, mddev);
>   			}
>   			autorun_array(mddev);
> +			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   			mddev_unlock_and_resume(mddev);
>   		}
>   		/* on success, candidates will be empty, on error
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 42ba3581cfea..f88f92517a18 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6989,6 +6989,7 @@ raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_t len)
>   	mutex_unlock(&conf->cache_size_mutex);
>   
>   out_unlock:
> +	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	mddev_unlock_and_resume(mddev);
>   	return err ?: len;
>   }
> @@ -7090,6 +7091,7 @@ raid5_store_skip_copy(struct mddev *mddev, const char *page, size_t len)
>   		else
>   			blk_queue_flag_clear(QUEUE_FLAG_STABLE_WRITES, q);
>   	}
> +	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	mddev_unlock_and_resume(mddev);
>   	return err ?: len;
>   }
> @@ -7169,6 +7171,7 @@ raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
>   			kfree(old_groups);
>   		}
>   	}
> +	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	mddev_unlock_and_resume(mddev);
>   
>   	return err ?: len;
> @@ -8920,6 +8923,7 @@ static int raid5_change_consistency_policy(struct mddev *mddev, const char *buf)
>   	if (!err)
>   		md_update_sb(mddev, 1);
>   
> +	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	mddev_unlock_and_resume(mddev);
>   
>   	return err;

Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
