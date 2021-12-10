Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82455C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 13 Dec 2021 06:17:40 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-585-o48CdR-yPv6ZcQ8XKHhlHw-1; Mon, 13 Dec 2021 01:17:35 -0500
X-MC-Unique: o48CdR-yPv6ZcQ8XKHhlHw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7DCC1853028;
	Mon, 13 Dec 2021 06:17:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9500061082;
	Mon, 13 Dec 2021 06:17:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6BC714CA93;
	Mon, 13 Dec 2021 06:17:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BAEGcJT004419 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 10 Dec 2021 09:16:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 32A0D40CFD12; Fri, 10 Dec 2021 14:16:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D90340CFD0A
	for <dm-devel@redhat.com>; Fri, 10 Dec 2021 14:16:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14BB7811E7F
	for <dm-devel@redhat.com>; Fri, 10 Dec 2021 14:16:38 +0000 (UTC)
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-296-0is0Og5hN3C1OqcQLaUqQw-1; Fri, 10 Dec 2021 09:16:34 -0500
X-MC-Unique: 0is0Og5hN3C1OqcQLaUqQw-1
Received: from [192.168.0.175] (ip5f5aed0f.dynamic.kabel-deutschland.de
	[95.90.237.15])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest
	SHA256) (No client certificate requested)
	(Authenticated sender: buczek)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 9179E61E5FE00;
	Fri, 10 Dec 2021 15:16:32 +0100 (CET)
To: song@kernel.org, Guoqing Jiang <guoqing.jiang@linux.dev>
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
From: Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <8312a154-14fb-6f07-0cf1-8c970187cc49@molgen.mpg.de>
Date: Fri, 10 Dec 2021 15:16:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 13 Dec 2021 01:17:24 -0500
Cc: linux-raid@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
	dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH V2] md: don't unregister sync_thread with
 reconfig_mutex held
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Dear Guoqing,

On 13.02.21 01:49, Guoqing Jiang wrote:
> Unregister sync_thread doesn't need to hold reconfig_mutex since it
> doesn't reconfigure array.
> 
> And it could cause deadlock problem for raid5 as follows:
> 
> 1. process A tried to reap sync thread with reconfig_mutex held after echo
>     idle to sync_action.
> 2. raid5 sync thread was blocked if there were too many active stripes.
> 3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
>     which causes the number of active stripes can't be decreased.
> 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
>     to hold reconfig_mutex.
> 
> More details in the link:
> https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t
> 
> And add one parameter to md_reap_sync_thread since it could be called by
> dm-raid which doesn't hold reconfig_mutex.
> 
> Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> ---
> V2:
> 1. add one parameter to md_reap_sync_thread per Jack's suggestion.
> 
>   drivers/md/dm-raid.c |  2 +-
>   drivers/md/md.c      | 14 +++++++++-----
>   drivers/md/md.h      |  2 +-
>   3 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index cab12b2..0c4cbba 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3668,7 +3668,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
>   	if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
>   		if (mddev->sync_thread) {
>   			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> -			md_reap_sync_thread(mddev);
> +			md_reap_sync_thread(mddev, false);
>   		}
>   	} else if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
>   		return -EBUSY;
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ca40942..0c12b7f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4857,7 +4857,7 @@ action_store(struct mddev *mddev, const char *page, size_t len)
>   				flush_workqueue(md_misc_wq);
>   			if (mddev->sync_thread) {
>   				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> -				md_reap_sync_thread(mddev);
> +				md_reap_sync_thread(mddev, true);
>   			}
>   			mddev_unlock(mddev);
>   		}
> @@ -6234,7 +6234,7 @@ static void __md_stop_writes(struct mddev *mddev)
>   		flush_workqueue(md_misc_wq);
>   	if (mddev->sync_thread) {
>   		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> -		md_reap_sync_thread(mddev);
> +		md_reap_sync_thread(mddev, true);
>   	}
>   
>   	del_timer_sync(&mddev->safemode_timer);
> @@ -9256,7 +9256,7 @@ void md_check_recovery(struct mddev *mddev)
>   			 * ->spare_active and clear saved_raid_disk
>   			 */
>   			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> -			md_reap_sync_thread(mddev);
> +			md_reap_sync_thread(mddev, true);
>   			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>   			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>   			clear_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
> @@ -9291,7 +9291,7 @@ void md_check_recovery(struct mddev *mddev)
>   			goto unlock;
>   		}
>   		if (mddev->sync_thread) {
> -			md_reap_sync_thread(mddev);
> +			md_reap_sync_thread(mddev, true);
>   			goto unlock;
>   		}
>   		/* Set RUNNING before clearing NEEDED to avoid
> @@ -9364,14 +9364,18 @@ void md_check_recovery(struct mddev *mddev)
>   }
>   EXPORT_SYMBOL(md_check_recovery);
>   
> -void md_reap_sync_thread(struct mddev *mddev)
> +void md_reap_sync_thread(struct mddev *mddev, bool reconfig_mutex_held)
>   {
>   	struct md_rdev *rdev;
>   	sector_t old_dev_sectors = mddev->dev_sectors;
>   	bool is_reshaped = false;
>   
>   	/* resync has finished, collect result */
> +	if (reconfig_mutex_held)
> +		mddev_unlock(mddev);


If one thread got here, e.g. via action_store( /* "idle" */ ), now that the mutex is unlocked, is there anything which would prevent another thread getting  here as well, e.g. via the same path?

If not, they both might call

>   	md_unregister_thread(&mddev->sync_thread);

Which is not reentrant:

void md_unregister_thread(struct md_thread **threadp)
{
	struct md_thread *thread = *threadp;
	if (!thread)
		return;
	pr_debug("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
	/* Locking ensures that mddev_unlock does not wake_up a
	 * non-existent thread
	 */
	spin_lock(&pers_lock);
	*threadp = NULL;
	spin_unlock(&pers_lock);

	kthread_stop(thread->tsk);
	kfree(thread);
}

This might be a preexisting problem, because the call site in dm-raid.c, which you updated to `md_reap_sync_thread(mddev, false);`, didn't hold the mutex anyway.

Am I missing something? Probably, I do.

Otherwise: Move the deref of threadp in md_unregister_thread() into the spinlock scope?

Best
   Donald

> +	if (reconfig_mutex_held)
> +		mddev_lock_nointr(mddev);
>   	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
>   	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
>   	    mddev->degraded != mddev->raid_disks) {
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 34070ab..7ae3d98 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -705,7 +705,7 @@ extern struct md_thread *md_register_thread(
>   extern void md_unregister_thread(struct md_thread **threadp);
>   extern void md_wakeup_thread(struct md_thread *thread);
>   extern void md_check_recovery(struct mddev *mddev);
> -extern void md_reap_sync_thread(struct mddev *mddev);
> +extern void md_reap_sync_thread(struct mddev *mddev, bool reconfig_mutex_held);
>   extern int mddev_init_writes_pending(struct mddev *mddev);
>   extern bool md_write_start(struct mddev *mddev, struct bio *bi);
>   extern void md_write_inc(struct mddev *mddev, struct bio *bi);
> 

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

