Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F870306D48
	for <dm-devel@lists.linux.dev>; Wed, 15 Oct 2025 06:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760510140; cv=none; b=S2F6WzLnaL0ghn5i709l7qguCodPXuba+BZNz0Wxj6rK3Tmln3pIpSLraV2iv/jnoXyqVjTye7bgRPVhlPyxW8z5o4fvhbVlvY9EuJbIVTdcu14vbajrU47J0eVo0vJ6SgfkHQUigmCi3Nubd+WrMIBTj4eVYpAPSnQQd8jN8Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760510140; c=relaxed/simple;
	bh=LmrULD6ZPcMFJqtDt6Dm2vDZNzPZbxTvsU02YXDct9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P2NDW8DS7i72+67GCT1lZz5VL6Esp1L79YTNcOy8+Z1tfgRtcs1OeI7mRIg3iedwzLE56qt2BNCqOyNoFFso/24WeNoEevSDRrxMQDS8nL/cc39NPVD0vPxWn5RFGCVz3G3YQqme/dRyZ3GN7R/OLPcy1A0xCLYxND/Eb/35J58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.2.212] (p57bd968e.dip0.t-ipconnect.de [87.189.150.142])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2927561E647AB;
	Wed, 15 Oct 2025 08:35:06 +0200 (CEST)
Message-ID: <86705912-07a3-4a24-bacd-ad5ac2038201@molgen.mpg.de>
Date: Wed, 15 Oct 2025 08:35:00 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: fix rcu protection in md_wakeup_thread
To: Yun Zhou <yun.zhou@windriver.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 yukuai3@huawei.com, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org
References: <20251015055924.899423-1-yun.zhou@windriver.com>
Content-Language: en-US, de-DE
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20251015055924.899423-1-yun.zhou@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Yun,


Thank you for your patch.

Am 15.10.25 um 07:59 schrieb Yun Zhou:
> We attempted to use RCU to protect the pointer 'thread', but directly
> passed the value when calling md_wakeup_thread(). This means that the
> RCU pointer has been acquired before rcu_read_lock(), which renders
> rcu_read_lock() ineffective and could lead to a use-after-free.

Could you elaborate a little more – especially as nobody has noticed 
this so far since v6.5-rc1?

The function is defined as

```
void md_wakeup_thread(struct md_thread __rcu *thread)
{
         struct md_thread *t;

         rcu_read_lock();
         t = rcu_dereference(thread);
         if (t) {
                 pr_debug("md: waking up MD thread %s.\n", t->tsk->comm);
                 set_bit(THREAD_WAKEUP, &t->flags);
                 if (wq_has_sleeper(&t->wqueue))
                         wake_up(&t->wqueue);
         }
         rcu_read_unlock();
}
EXPORT_SYMBOL(md_wakeup_thread);
```

Excuse my ignorance, but is there a way to verify, that the correct 
value is passed?


Kind regards,

Paul


> Fixes: 446931543982 ("md: protect md_thread with rcu")
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> ---
>   drivers/md/dm-raid.c     |  4 +--
>   drivers/md/md-bitmap.c   |  6 ++---
>   drivers/md/md-cluster.c  | 20 +++++++--------
>   drivers/md/md.c          | 54 ++++++++++++++++++++--------------------
>   drivers/md/md.h          |  4 +--
>   drivers/md/raid1.c       | 10 ++++----
>   drivers/md/raid10.c      | 12 ++++-----
>   drivers/md/raid5-cache.c | 12 ++++-----
>   drivers/md/raid5-ppl.c   |  2 +-
>   drivers/md/raid5.c       | 30 +++++++++++-----------
>   10 files changed, 77 insertions(+), 77 deletions(-)
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index f4b904e24328..d4b55387b382 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3781,11 +3781,11 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
>   		 */
>   		mddev->ro = 0;
>   		if (!mddev->suspended)
> -			md_wakeup_thread(mddev->sync_thread);
> +			md_wakeup_thread(&mddev->sync_thread);
>   	}
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   	if (!mddev->suspended)
> -		md_wakeup_thread(mddev->thread);
> +		md_wakeup_thread(&mddev->thread);
>   
>   	return 0;
>   }
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 334b71404930..85b08814c21e 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2272,7 +2272,7 @@ static int bitmap_load(struct mddev *mddev)
>   	set_bit(MD_RECOVERY_NEEDED, &bitmap->mddev->recovery);
>   
>   	mddev_set_timeout(mddev, mddev->bitmap_info.daemon_sleep, true);
> -	md_wakeup_thread(mddev->thread);
> +	md_wakeup_thread(&mddev->thread);
>   
>   	bitmap_update_sb(bitmap);
>   
> @@ -2695,7 +2695,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
>   		 * metadata promptly.
>   		 */
>   		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> -		md_wakeup_thread(mddev->thread);
> +		md_wakeup_thread(&mddev->thread);
>   	}
>   	rv = 0;
>   out:
> @@ -2782,7 +2782,7 @@ timeout_store(struct mddev *mddev, const char *buf, size_t len)
>   
>   	mddev->bitmap_info.daemon_sleep = timeout;
>   	mddev_set_timeout(mddev, timeout, false);
> -	md_wakeup_thread(mddev->thread);
> +	md_wakeup_thread(&mddev->thread);
>   
>   	return len;
>   }
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 5497eaee96e7..d9ca007ad3c8 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -334,7 +334,7 @@ static void recover_bitmaps(struct md_thread *thread)
>   		if (test_bit(MD_RESYNCING_REMOTE, &mddev->recovery) &&
>   		    test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>   		    mddev->reshape_position != MaxSector)
> -			md_wakeup_thread(mddev->sync_thread);
> +			md_wakeup_thread(&mddev->sync_thread);
>   
>   		if (hi > 0) {
>   			if (lo < mddev->resync_offset)
> @@ -349,7 +349,7 @@ static void recover_bitmaps(struct md_thread *thread)
>   				clear_bit(MD_RESYNCING_REMOTE,
>   					  &mddev->recovery);
>   				set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -				md_wakeup_thread(mddev->thread);
> +				md_wakeup_thread(&mddev->thread);
>   			}
>   		}
>   clear_bit:
> @@ -378,7 +378,7 @@ static void __recover_slot(struct mddev *mddev, int slot)
>   			return;
>   		}
>   	}
> -	md_wakeup_thread(cinfo->recovery_thread);
> +	md_wakeup_thread(&cinfo->recovery_thread);
>   }
>   
>   static void recover_slot(void *arg, struct dlm_slot *slot)
> @@ -432,7 +432,7 @@ static void ack_bast(void *arg, int mode)
>   
>   	if (mode == DLM_LOCK_EX) {
>   		if (test_bit(MD_CLUSTER_ALREADY_IN_CLUSTER, &cinfo->state))
> -			md_wakeup_thread(cinfo->recv_thread);
> +			md_wakeup_thread(&cinfo->recv_thread);
>   		else
>   			set_bit(MD_CLUSTER_PENDING_RECV_EVENT, &cinfo->state);
>   	}
> @@ -465,7 +465,7 @@ static void process_suspend_info(struct mddev *mddev,
>   		remove_suspend_info(mddev, slot);
>   		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   		clear_bit(MD_CLUSTER_WAITING_FOR_SYNC, &cinfo->state);
> -		md_wakeup_thread(mddev->thread);
> +		md_wakeup_thread(&mddev->thread);
>   		return;
>   	}
>   
> @@ -568,7 +568,7 @@ static void process_remove_disk(struct mddev *mddev, struct cluster_msg *msg)
>   	if (rdev) {
>   		set_bit(ClusterRemove, &rdev->flags);
>   		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -		md_wakeup_thread(mddev->thread);
> +		md_wakeup_thread(&mddev->thread);
>   	}
>   	else
>   		pr_warn("%s: %d Could not find disk(%d) to REMOVE\n",
> @@ -723,7 +723,7 @@ static int lock_comm(struct md_cluster_info *cinfo, bool mddev_locked)
>   		rv = test_and_set_bit_lock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
>   					      &cinfo->state);
>   		WARN_ON_ONCE(rv);
> -		md_wakeup_thread(mddev->thread);
> +		md_wakeup_thread(&mddev->thread);
>   		set_bit = 1;
>   	}
>   
> @@ -995,7 +995,7 @@ static void load_bitmaps(struct mddev *mddev, int total_slots)
>   	set_bit(MD_CLUSTER_ALREADY_IN_CLUSTER, &cinfo->state);
>   	/* wake up recv thread in case something need to be handled */
>   	if (test_and_clear_bit(MD_CLUSTER_PENDING_RECV_EVENT, &cinfo->state))
> -		md_wakeup_thread(cinfo->recv_thread);
> +		md_wakeup_thread(&cinfo->recv_thread);
>   }
>   
>   static void resync_bitmap(struct mddev *mddev)
> @@ -1076,7 +1076,7 @@ static int metadata_update_start(struct mddev *mddev)
>   	ret = test_and_set_bit_lock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
>   				    &cinfo->state);
>   	WARN_ON_ONCE(ret);
> -	md_wakeup_thread(mddev->thread);
> +	md_wakeup_thread(&mddev->thread);
>   
>   	wait_event(cinfo->wait,
>   		   !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state) ||
> @@ -1485,7 +1485,7 @@ static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
>   		/* Since MD_CHANGE_DEVS will be set in add_bound_rdev which
>   		 * will run soon after add_new_disk, the below path will be
>   		 * invoked:
> -		 *   md_wakeup_thread(mddev->thread)
> +		 *   md_wakeup_thread(&mddev->thread)
>   		 *	-> conf->thread (raid1d)
>   		 *	-> md_check_recovery -> md_update_sb
>   		 *	-> metadata_update_start/finish
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4e033c26fdd4..491ee3d116fd 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -100,7 +100,7 @@ static int remove_and_add_spares(struct mddev *mddev,
>   				 struct md_rdev *this);
>   static void mddev_detach(struct mddev *mddev);
>   static void export_rdev(struct md_rdev *rdev, struct mddev *mddev);
> -static void md_wakeup_thread_directly(struct md_thread __rcu *thread);
> +static void md_wakeup_thread_directly(struct md_thread __rcu **thread);
>   
>   /*
>    * Default number of read corrections we'll attempt on an rdev
> @@ -534,8 +534,8 @@ static void __mddev_resume(struct mddev *mddev, bool recovery_needed)
>   
>   	if (recovery_needed)
>   		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -	md_wakeup_thread(mddev->thread);
> -	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
> +	md_wakeup_thread(&mddev->thread);
> +	md_wakeup_thread(&mddev->sync_thread); /* possibly kick off a reshape */
>   
>   	mutex_unlock(&mddev->suspend_mutex);
>   }
> @@ -869,7 +869,7 @@ void mddev_unlock(struct mddev *mddev)
>   	} else
>   		mutex_unlock(&mddev->reconfig_mutex);
>   
> -	md_wakeup_thread(mddev->thread);
> +	md_wakeup_thread(&mddev->thread);
>   	wake_up(&mddev->sb_wait);
>   
>   	list_for_each_entry_safe(rdev, tmp, &delete, same_set) {
> @@ -4482,7 +4482,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
>   		if (st == active) {
>   			restart_array(mddev);
>   			clear_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
> -			md_wakeup_thread(mddev->thread);
> +			md_wakeup_thread(&mddev->thread);
>   			wake_up(&mddev->sb_wait);
>   		} else /* st == clean */ {
>   			restart_array(mddev);
> @@ -4982,7 +4982,7 @@ static void stop_sync_thread(struct mddev *mddev, bool locked)
>   	 * Thread might be blocked waiting for metadata update which will now
>   	 * never happen
>   	 */
> -	md_wakeup_thread_directly(mddev->sync_thread);
> +	md_wakeup_thread_directly(&mddev->sync_thread);
>   	if (work_pending(&mddev->sync_work))
>   		flush_work(&mddev->sync_work);
>   
> @@ -5019,7 +5019,7 @@ void md_unfrozen_sync_thread(struct mddev *mddev)
>   
>   	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -	md_wakeup_thread(mddev->thread);
> +	md_wakeup_thread(&mddev->thread);
>   	sysfs_notify_dirent_safe(mddev->sysfs_action);
>   }
>   EXPORT_SYMBOL_GPL(md_unfrozen_sync_thread);
> @@ -5134,11 +5134,11 @@ action_store(struct mddev *mddev, const char *page, size_t len)
>   		 * canceling read-auto mode
>   		 */
>   		mddev->ro = MD_RDWR;
> -		md_wakeup_thread(mddev->sync_thread);
> +		md_wakeup_thread(&mddev->sync_thread);
>   	}
>   
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -	md_wakeup_thread(mddev->thread);
> +	md_wakeup_thread(&mddev->thread);
>   	sysfs_notify_dirent_safe(mddev->sysfs_action);
>   	ret = len;
>   
> @@ -6128,7 +6128,7 @@ static void md_safemode_timeout(struct timer_list *t)
>   	if (mddev->external)
>   		sysfs_notify_dirent_safe(mddev->sysfs_state);
>   
> -	md_wakeup_thread(mddev->thread);
> +	md_wakeup_thread(&mddev->thread);
>   }
>   
>   static int start_dirty_degraded;
> @@ -6404,7 +6404,7 @@ int do_md_run(struct mddev *mddev)
>   	/* run start up tasks that require md_thread */
>   	md_start(mddev);
>   
> -	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
> +	md_wakeup_thread(&mddev->sync_thread); /* possibly kick off a reshape */
>   
>   	set_capacity_and_notify(mddev->gendisk, mddev->array_sectors);
>   	clear_bit(MD_NOT_READY, &mddev->flags);
> @@ -6426,7 +6426,7 @@ int md_start(struct mddev *mddev)
>   		set_bit(MD_RECOVERY_WAIT, &mddev->recovery);
>   		ret = mddev->pers->start(mddev);
>   		clear_bit(MD_RECOVERY_WAIT, &mddev->recovery);
> -		md_wakeup_thread(mddev->sync_thread);
> +		md_wakeup_thread(&mddev->sync_thread);
>   	}
>   	return ret;
>   }
> @@ -6468,7 +6468,7 @@ static int restart_array(struct mddev *mddev)
>   	pr_debug("md: %s switched to read-write mode.\n", mdname(mddev));
>   	/* Kick recovery or resync if necessary */
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -	md_wakeup_thread(mddev->sync_thread);
> +	md_wakeup_thread(&mddev->sync_thread);
>   	sysfs_notify_dirent_safe(mddev->sysfs_state);
>   	return 0;
>   }
> @@ -8194,23 +8194,23 @@ static int md_thread(void *arg)
>   	return 0;
>   }
>   
> -static void md_wakeup_thread_directly(struct md_thread __rcu *thread)
> +static void md_wakeup_thread_directly(struct md_thread __rcu **thread)
>   {
>   	struct md_thread *t;
>   
>   	rcu_read_lock();
> -	t = rcu_dereference(thread);
> +	t = rcu_dereference(*thread);
>   	if (t)
>   		wake_up_process(t->tsk);
>   	rcu_read_unlock();
>   }
>   
> -void md_wakeup_thread(struct md_thread __rcu *thread)
> +void md_wakeup_thread(struct md_thread __rcu **thread)
>   {
>   	struct md_thread *t;
>   
>   	rcu_read_lock();
> -	t = rcu_dereference(thread);
> +	t = rcu_dereference(*thread);
>   	if (t) {
>   		pr_debug("md: waking up MD thread %s.\n", t->tsk->comm);
>   		set_bit(THREAD_WAKEUP, &t->flags);
> @@ -8283,7 +8283,7 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
>   	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>   	if (!test_bit(MD_BROKEN, &mddev->flags)) {
>   		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -		md_wakeup_thread(mddev->thread);
> +		md_wakeup_thread(&mddev->thread);
>   	}
>   	if (mddev->event_work.func)
>   		queue_work(md_misc_wq, &mddev->event_work);
> @@ -8763,7 +8763,7 @@ void md_done_sync(struct mddev *mddev, int blocks, int ok)
>   	if (!ok) {
>   		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>   		set_bit(MD_RECOVERY_ERROR, &mddev->recovery);
> -		md_wakeup_thread(mddev->thread);
> +		md_wakeup_thread(&mddev->thread);
>   		// stop recovery, signal do_sync ....
>   	}
>   }
> @@ -8788,8 +8788,8 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
>   		/* need to switch to read/write */
>   		mddev->ro = MD_RDWR;
>   		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -		md_wakeup_thread(mddev->thread);
> -		md_wakeup_thread(mddev->sync_thread);
> +		md_wakeup_thread(&mddev->thread);
> +		md_wakeup_thread(&mddev->sync_thread);
>   		did_change = 1;
>   	}
>   	rcu_read_lock();
> @@ -8804,7 +8804,7 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
>   			mddev->in_sync = 0;
>   			set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
>   			set_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
> -			md_wakeup_thread(mddev->thread);
> +			md_wakeup_thread(&mddev->thread);
>   			did_change = 1;
>   		}
>   		spin_unlock(&mddev->lock);
> @@ -8841,7 +8841,7 @@ void md_write_end(struct mddev *mddev)
>   	percpu_ref_put(&mddev->writes_pending);
>   
>   	if (mddev->safemode == 2)
> -		md_wakeup_thread(mddev->thread);
> +		md_wakeup_thread(&mddev->thread);
>   	else if (mddev->safemode_delay)
>   		/* The roundup() ensures this only performs locking once
>   		 * every ->safemode_delay jiffies
> @@ -9442,7 +9442,7 @@ void md_do_sync(struct md_thread *thread)
>   	spin_unlock(&mddev->lock);
>   
>   	wake_up(&resync_wait);
> -	md_wakeup_thread(mddev->thread);
> +	md_wakeup_thread(&mddev->thread);
>   	return;
>   }
>   EXPORT_SYMBOL_GPL(md_do_sync);
> @@ -9705,7 +9705,7 @@ static void md_start_sync(struct work_struct *ws)
>   	 */
>   	if (suspend)
>   		__mddev_resume(mddev, false);
> -	md_wakeup_thread(mddev->sync_thread);
> +	md_wakeup_thread(&mddev->sync_thread);
>   	sysfs_notify_dirent_safe(mddev->sysfs_action);
>   	md_new_event();
>   	return;
> @@ -10022,7 +10022,7 @@ bool rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
>   	sysfs_notify_dirent_safe(rdev->sysfs_state);
>   	set_mask_bits(&mddev->sb_flags, 0,
>   		      BIT(MD_SB_CHANGE_CLEAN) | BIT(MD_SB_CHANGE_PENDING));
> -	md_wakeup_thread(rdev->mddev->thread);
> +	md_wakeup_thread(&rdev->mddev->thread);
>   	return true;
>   }
>   EXPORT_SYMBOL_GPL(rdev_set_badblocks);
> @@ -10200,7 +10200,7 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
>   				/* wakeup mddev->thread here, so array could
>   				 * perform resync with the new activated disk */
>   				set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -				md_wakeup_thread(mddev->thread);
> +				md_wakeup_thread(&mddev->thread);
>   			}
>   			/* device faulty
>   			 * We just want to do the minimum to mark the disk
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 51af29a03079..2f029a5ebeba 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -891,7 +891,7 @@ extern struct md_thread *md_register_thread(
>   	struct mddev *mddev,
>   	const char *name);
>   extern void md_unregister_thread(struct mddev *mddev, struct md_thread __rcu **threadp);
> -extern void md_wakeup_thread(struct md_thread __rcu *thread);
> +extern void md_wakeup_thread(struct md_thread __rcu **thread);
>   extern void md_check_recovery(struct mddev *mddev);
>   extern void md_reap_sync_thread(struct mddev *mddev);
>   extern enum sync_action md_sync_action(struct mddev *mddev);
> @@ -959,7 +959,7 @@ static inline void rdev_dec_pending(struct md_rdev *rdev, struct mddev *mddev)
>   	int faulty = test_bit(Faulty, &rdev->flags);
>   	if (atomic_dec_and_test(&rdev->nr_pending) && faulty) {
>   		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -		md_wakeup_thread(mddev->thread);
> +		md_wakeup_thread(&mddev->thread);
>   	}
>   }
>   
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index d30b82beeb92..ab37e65887bc 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -288,7 +288,7 @@ static void reschedule_retry(struct r1bio *r1_bio)
>   	spin_unlock_irqrestore(&conf->device_lock, flags);
>   
>   	wake_up(&conf->wait_barrier);
> -	md_wakeup_thread(mddev->thread);
> +	md_wakeup_thread(&mddev->thread);
>   }
>   
>   /*
> @@ -1278,7 +1278,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
>   		bio_list_merge(&conf->pending_bio_list, &plug->pending);
>   		spin_unlock_irq(&conf->device_lock);
>   		wake_up_barrier(conf);
> -		md_wakeup_thread(mddev->thread);
> +		md_wakeup_thread(&mddev->thread);
>   		kfree(plug);
>   		return;
>   	}
> @@ -1666,7 +1666,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   			spin_lock_irqsave(&conf->device_lock, flags);
>   			bio_list_add(&conf->pending_bio_list, mbio);
>   			spin_unlock_irqrestore(&conf->device_lock, flags);
> -			md_wakeup_thread(mddev->thread);
> +			md_wakeup_thread(&mddev->thread);
>   		}
>   	}
>   
> @@ -2616,7 +2616,7 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
>   		 * get_unqueued_pending() == extra to be true.
>   		 */
>   		wake_up(&conf->wait_barrier);
> -		md_wakeup_thread(conf->mddev->thread);
> +		md_wakeup_thread(&conf->mddev->thread);
>   	} else {
>   		if (test_bit(R1BIO_WriteError, &r1_bio->state))
>   			close_write(r1_bio);
> @@ -3436,7 +3436,7 @@ static int raid1_reshape(struct mddev *mddev)
>   
>   	set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -	md_wakeup_thread(mddev->thread);
> +	md_wakeup_thread(&mddev->thread);
>   
>   	mempool_destroy(oldpool);
>   	return 0;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 9832eefb2f15..1e4b827adf41 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -309,7 +309,7 @@ static void reschedule_retry(struct r10bio *r10_bio)
>   	/* wake up frozen array... */
>   	wake_up(&conf->wait_barrier);
>   
> -	md_wakeup_thread(mddev->thread);
> +	md_wakeup_thread(&mddev->thread);
>   }
>   
>   /*
> @@ -1091,7 +1091,7 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
>   		bio_list_merge(&conf->pending_bio_list, &plug->pending);
>   		spin_unlock_irq(&conf->device_lock);
>   		wake_up_barrier(conf);
> -		md_wakeup_thread(mddev->thread);
> +		md_wakeup_thread(&mddev->thread);
>   		kfree(plug);
>   		return;
>   	}
> @@ -1284,7 +1284,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
>   		spin_lock_irqsave(&conf->device_lock, flags);
>   		bio_list_add(&conf->pending_bio_list, mbio);
>   		spin_unlock_irqrestore(&conf->device_lock, flags);
> -		md_wakeup_thread(mddev->thread);
> +		md_wakeup_thread(&mddev->thread);
>   	}
>   }
>   
> @@ -1390,7 +1390,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>   		mddev->reshape_position = conf->reshape_progress;
>   		set_mask_bits(&mddev->sb_flags, 0,
>   			      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
> -		md_wakeup_thread(mddev->thread);
> +		md_wakeup_thread(&mddev->thread);
>   		if (bio->bi_opf & REQ_NOWAIT) {
>   			allow_barrier(conf);
>   			bio_wouldblock_error(bio);
> @@ -2966,7 +2966,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
>   			 * nr_pending == nr_queued + extra to be true.
>   			 */
>   			wake_up(&conf->wait_barrier);
> -			md_wakeup_thread(conf->mddev->thread);
> +			md_wakeup_thread(&conf->mddev->thread);
>   		} else {
>   			if (test_bit(R10BIO_WriteError,
>   				     &r10_bio->state))
> @@ -4760,7 +4760,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
>   			mddev->curr_resync_completed = conf->reshape_progress;
>   		conf->reshape_checkpoint = jiffies;
>   		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> -		md_wakeup_thread(mddev->thread);
> +		md_wakeup_thread(&mddev->thread);
>   		wait_event(mddev->sb_wait, mddev->sb_flags == 0 ||
>   			   test_bit(MD_RECOVERY_INTR, &mddev->recovery));
>   		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index ba768ca7f422..819b198cc1a0 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -599,7 +599,7 @@ static void r5l_log_endio(struct bio *bio)
>   	spin_unlock_irqrestore(&log->io_list_lock, flags);
>   
>   	if (log->need_cache_flush)
> -		md_wakeup_thread(log->rdev->mddev->thread);
> +		md_wakeup_thread(&log->rdev->mddev->thread);
>   
>   	/* finish flush only io_unit and PAYLOAD_FLUSH only io_unit */
>   	if (has_null_flush) {
> @@ -1488,7 +1488,7 @@ static void r5c_do_reclaim(struct r5conf *conf)
>   	if (!test_bit(R5C_LOG_CRITICAL, &conf->cache_state))
>   		r5l_run_no_space_stripes(log);
>   
> -	md_wakeup_thread(conf->mddev->thread);
> +	md_wakeup_thread(&conf->mddev->thread);
>   }
>   
>   static void r5l_do_reclaim(struct r5l_log *log)
> @@ -1516,7 +1516,7 @@ static void r5l_do_reclaim(struct r5l_log *log)
>   		     list_empty(&log->finished_ios)))
>   			break;
>   
> -		md_wakeup_thread(log->rdev->mddev->thread);
> +		md_wakeup_thread(&log->rdev->mddev->thread);
>   		wait_event_lock_irq(log->iounit_wait,
>   				    r5l_reclaimable_space(log) > reclaimable,
>   				    log->io_list_lock);
> @@ -1568,7 +1568,7 @@ void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
>   		if (new < target)
>   			return;
>   	} while (!try_cmpxchg(&log->reclaim_target, &target, new));
> -	md_wakeup_thread(log->reclaim_thread);
> +	md_wakeup_thread(&log->reclaim_thread);
>   }
>   
>   void r5l_quiesce(struct r5l_log *log, int quiesce)
> @@ -2765,7 +2765,7 @@ void r5c_release_extra_page(struct stripe_head *sh)
>   
>   	if (using_disk_info_extra_page) {
>   		clear_bit(R5C_EXTRA_PAGE_IN_USE, &conf->cache_state);
> -		md_wakeup_thread(conf->mddev->thread);
> +		md_wakeup_thread(&conf->mddev->thread);
>   	}
>   }
>   
> @@ -2820,7 +2820,7 @@ void r5c_finish_stripe_write_out(struct r5conf *conf,
>   
>   	if (test_and_clear_bit(STRIPE_FULL_WRITE, &sh->state))
>   		if (atomic_dec_and_test(&conf->pending_full_writes))
> -			md_wakeup_thread(conf->mddev->thread);
> +			md_wakeup_thread(&conf->mddev->thread);
>   
>   	spin_lock_irq(&log->stripe_in_journal_lock);
>   	list_del_init(&sh->r5c);
> diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
> index 56b234683ee6..68d30b7b9886 100644
> --- a/drivers/md/raid5-ppl.c
> +++ b/drivers/md/raid5-ppl.c
> @@ -601,7 +601,7 @@ static void ppl_flush_endio(struct bio *bio)
>   
>   	if (atomic_dec_and_test(&io->pending_flushes)) {
>   		ppl_io_unit_finished(io);
> -		md_wakeup_thread(conf->mddev->thread);
> +		md_wakeup_thread(&conf->mddev->thread);
>   	}
>   }
>   
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index e385ef1355e8..8dda3c38e539 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -196,7 +196,7 @@ static void raid5_wakeup_stripe_thread(struct stripe_head *sh)
>   	}
>   
>   	if (conf->worker_cnt_per_group == 0) {
> -		md_wakeup_thread(conf->mddev->thread);
> +		md_wakeup_thread(&conf->mddev->thread);
>   		return;
>   	}
>   
> @@ -269,13 +269,13 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
>   				return;
>   			}
>   		}
> -		md_wakeup_thread(conf->mddev->thread);
> +		md_wakeup_thread(&conf->mddev->thread);
>   	} else {
>   		BUG_ON(stripe_operations_active(sh));
>   		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>   			if (atomic_dec_return(&conf->preread_active_stripes)
>   			    < IO_THRESHOLD)
> -				md_wakeup_thread(conf->mddev->thread);
> +				md_wakeup_thread(&conf->mddev->thread);
>   		atomic_dec(&conf->active_stripes);
>   		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
>   			if (!r5c_is_writeback(conf->log))
> @@ -357,7 +357,7 @@ static void release_inactive_stripe_list(struct r5conf *conf,
>   		if (atomic_read(&conf->active_stripes) == 0)
>   			wake_up(&conf->wait_for_quiescent);
>   		if (conf->retry_read_aligned)
> -			md_wakeup_thread(conf->mddev->thread);
> +			md_wakeup_thread(&conf->mddev->thread);
>   	}
>   }
>   
> @@ -408,7 +408,7 @@ void raid5_release_stripe(struct stripe_head *sh)
>   		goto slow_path;
>   	wakeup = llist_add(&sh->release_list, &conf->released_stripes);
>   	if (wakeup)
> -		md_wakeup_thread(conf->mddev->thread);
> +		md_wakeup_thread(&conf->mddev->thread);
>   	return;
>   slow_path:
>   	/* we are ok here if STRIPE_ON_RELEASE_LIST is set or not */
> @@ -987,7 +987,7 @@ static void stripe_add_to_batch_list(struct r5conf *conf,
>   	if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>   		if (atomic_dec_return(&conf->preread_active_stripes)
>   		    < IO_THRESHOLD)
> -			md_wakeup_thread(conf->mddev->thread);
> +			md_wakeup_thread(&conf->mddev->thread);
>   
>   	if (test_and_clear_bit(STRIPE_BIT_DELAY, &sh->state)) {
>   		int seq = sh->bm_seq;
> @@ -3678,7 +3678,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>   
>   	if (test_and_clear_bit(STRIPE_FULL_WRITE, &sh->state))
>   		if (atomic_dec_and_test(&conf->pending_full_writes))
> -			md_wakeup_thread(conf->mddev->thread);
> +			md_wakeup_thread(&conf->mddev->thread);
>   }
>   
>   static void
> @@ -4070,7 +4070,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
>   
>   	if (test_and_clear_bit(STRIPE_FULL_WRITE, &sh->state))
>   		if (atomic_dec_and_test(&conf->pending_full_writes))
> -			md_wakeup_thread(conf->mddev->thread);
> +			md_wakeup_thread(&conf->mddev->thread);
>   
>   	if (head_sh->batch_head && do_endio)
>   		break_stripe_batch_list(head_sh, STRIPE_EXPAND_SYNC_FLAGS);
> @@ -5269,7 +5269,7 @@ static void handle_stripe(struct stripe_head *sh)
>   		atomic_dec(&conf->preread_active_stripes);
>   		if (atomic_read(&conf->preread_active_stripes) <
>   		    IO_THRESHOLD)
> -			md_wakeup_thread(conf->mddev->thread);
> +			md_wakeup_thread(&conf->mddev->thread);
>   	}
>   
>   	clear_bit_unlock(STRIPE_ACTIVE, &sh->state);
> @@ -5336,7 +5336,7 @@ static void add_bio_to_retry(struct bio *bi,struct r5conf *conf)
>   	conf->retry_read_aligned_list = bi;
>   
>   	spin_unlock_irqrestore(&conf->device_lock, flags);
> -	md_wakeup_thread(conf->mddev->thread);
> +	md_wakeup_thread(&conf->mddev->thread);
>   }
>   
>   static struct bio *remove_bio_from_retry(struct r5conf *conf,
> @@ -5814,7 +5814,7 @@ static int add_all_stripe_bios(struct r5conf *conf,
>   				raid5_release_stripe(ctx->batch_last);
>   				ctx->batch_last = NULL;
>   			}
> -			md_wakeup_thread(conf->mddev->thread);
> +			md_wakeup_thread(&conf->mddev->thread);
>   			wait_on_bit(&dev->flags, R5_Overlap, TASK_UNINTERRUPTIBLE);
>   			return 0;
>   		}
> @@ -5981,7 +5981,7 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
>   	}
>   
>   	if (test_bit(STRIPE_EXPANDING, &sh->state)) {
> -		md_wakeup_thread(mddev->thread);
> +		md_wakeup_thread(&mddev->thread);
>   		ret = STRIPE_SCHEDULE_AND_RETRY;
>   		goto out_release;
>   	}
> @@ -6350,7 +6350,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
>   
>   		conf->reshape_checkpoint = jiffies;
>   		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> -		md_wakeup_thread(mddev->thread);
> +		md_wakeup_thread(&mddev->thread);
>   		wait_event(mddev->sb_wait, mddev->sb_flags == 0 ||
>   			   test_bit(MD_RECOVERY_INTR, &mddev->recovery));
>   		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
> @@ -6458,7 +6458,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
>   					rdev->recovery_offset = sector_nr;
>   		conf->reshape_checkpoint = jiffies;
>   		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> -		md_wakeup_thread(mddev->thread);
> +		md_wakeup_thread(&mddev->thread);
>   		wait_event(mddev->sb_wait,
>   			   !test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags)
>   			   || test_bit(MD_RECOVERY_INTR, &mddev->recovery));
> @@ -8754,7 +8754,7 @@ static int raid5_check_reshape(struct mddev *mddev)
>   			mddev->chunk_sectors = new_chunk;
>   		}
>   		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> -		md_wakeup_thread(mddev->thread);
> +		md_wakeup_thread(&mddev->thread);
>   	}
>   	return check_reshape(mddev);
>   }

