Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54410C433E6
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:38:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A7E9D64D9A
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:38:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7E9D64D9A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-MUAu8oasNQ61j3HIfxhUVA-1; Wed, 17 Feb 2021 10:38:32 -0500
X-MC-Unique: MUAu8oasNQ61j3HIfxhUVA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E478107ACF2;
	Wed, 17 Feb 2021 15:38:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 197E319D6C;
	Wed, 17 Feb 2021 15:38:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D70FE18095CA;
	Wed, 17 Feb 2021 15:38:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11FBEo9P024493 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 15 Feb 2021 06:14:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C31394405C; Mon, 15 Feb 2021 11:14:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BC9835F253
	for <dm-devel@redhat.com>; Mon, 15 Feb 2021 11:14:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0ECA3857AB1
	for <dm-devel@redhat.com>; Mon, 15 Feb 2021 11:14:44 +0000 (UTC)
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-156-KLZzO1mnOwK-V1Mzl-CqCA-1; Mon, 15 Feb 2021 06:14:40 -0500
X-MC-Unique: KLZzO1mnOwK-V1Mzl-CqCA-1
Received: from [192.168.0.6] (ip5f5aea71.dynamic.kabel-deutschland.de
	[95.90.234.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested) (Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 788182064791F;
	Mon, 15 Feb 2021 12:07:58 +0100 (CET)
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, song@kernel.org
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
From: Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
Date: Mon, 15 Feb 2021 12:07:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.1
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
Cc: snitzer@redhat.com, linux-raid@vger.kernel.org, dm-devel@redhat.com,
	agk@redhat.com, Donald Buczek <buczek@molgen.mpg.de>, it+raid@molgen.mpg.de
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

[+cc Donald]

Am 13.02.21 um 01:49 schrieb Guoqing Jiang:
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
>   	md_unregister_thread(&mddev->sync_thread);
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
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

