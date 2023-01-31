Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 859A0C38142
	for <dm-devel@archiver.kernel.org>; Tue, 31 Jan 2023 03:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675136696;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=csRx/NzrTAWe6W0dxgEFalAXwMUweYWgWQ9n2G80Euo=;
	b=Cubijf9q5widcJSTdIofv8H5AjVYlJswhlcHYX0+41oqHXq4NuVFWOZq9xdhj4cl9MsPb/
	zuFxQrmiEdTOKaRyD8AlwoxksO9oEjLS9weTEWso1oFaN7fuN3QZte86/YHq23X26fkytI
	NS95DSz9dKrj/UX2JYETO/QN/87SneE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-57-8gcRL_0HO6a_kijmy20IOw-1; Mon, 30 Jan 2023 22:44:52 -0500
X-MC-Unique: 8gcRL_0HO6a_kijmy20IOw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F6C43806102;
	Tue, 31 Jan 2023 03:44:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1A5D340C2064;
	Tue, 31 Jan 2023 03:44:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EE6411946589;
	Tue, 31 Jan 2023 03:44:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AB70B1946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 31 Jan 2023 03:13:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 943E5492B06; Tue, 31 Jan 2023 03:13:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C238492B05
 for <dm-devel@redhat.com>; Tue, 31 Jan 2023 03:13:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C8B13C01DE7
 for <dm-devel@redhat.com>; Tue, 31 Jan 2023 03:13:23 +0000 (UTC)
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-322-UkZM9kYqNsOwzW-DqHv98A-1; Mon, 30 Jan 2023 22:13:19 -0500
X-MC-Unique: UkZM9kYqNsOwzW-DqHv98A-1
Received: by mail-pl1-f198.google.com with SMTP id
 q5-20020a170902788500b0019656571b67so5745614pll.12
 for <dm-devel@redhat.com>; Mon, 30 Jan 2023 19:13:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=mOCanwJBT5m5ofwbdgziDuDgquiPRTHSacBMicyLkZE=;
 b=VWGpjC/tCXLF+iz2renNRZ88Rpz433dMP8y2vc5GlUK8Bs0Xwb8mbpXQi9n2krCWtH
 E06cdcEuZFCtfrdbBDNrxV40UuO3Ljx3iH5gqHQapcAMJr6LLtiU6C6xqmFVVAFUcSLj
 uhed+7MvikMSDglluy8yKcYjye7hNv/5kr93U/EoJ83lQ9nRmp5l5sbjBzjrDCtvfnao
 M7wkRQDXtHETLL9591sY8YEzOUt5A0/gMrKSWEciB5aOcVUVX24cUEhh/lqAqxvL1UG4
 9D1nAwp0HrKcAdCy7b8Myi/tlApsmEF2K/FVtmRy0Pgmi2GCY9xq9lyTa1p46qitLg62
 vdTg==
X-Gm-Message-State: AO0yUKXvMhZt7X1qzy3JynItzpGkCImPiSz05BXOMrOLZLOPh23MTOjQ
 NJlJ0V05T+lDNVOVDG02o2KIcINl5S7ZXDfMpLHZ3Ncg9mbuJcxqObsqos/v4xqRcz49ff8V4s7
 bATbQ3bGkF0ewkr8+GzGkFyfXdxSdTbI=
X-Received: by 2002:a17:902:e9c4:b0:196:6b0d:752b with SMTP id
 4-20020a170902e9c400b001966b0d752bmr1385649plk.19.1675134798508; 
 Mon, 30 Jan 2023 19:13:18 -0800 (PST)
X-Google-Smtp-Source: AK7set8EwH0bWF+QgCx5fzqph3ftumSZOYoaI+K3umE4wm9XYHjxHXz0PlZmqED4hPDq1ImMR8gZJgKcWlBfwXTF/bU=
X-Received: by 2002:a17:902:e9c4:b0:196:6b0d:752b with SMTP id
 4-20020a170902e9c400b001966b0d752bmr1385644plk.19.1675134797965; Mon, 30 Jan
 2023 19:13:17 -0800 (PST)
MIME-Version: 1.0
References: <alpine.LRH.2.21.2301240858250.9655@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.21.2301240858250.9655@file01.intranet.prod.int.rdu2.redhat.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 31 Jan 2023 11:13:05 +0800
Message-ID: <CALTww29HCK0ujvQAJrp8ouQ8pr33f1e78pX9QW3oarO4j_Voyg@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH] md: use preallocated hashed wait queues
 instead of mddev->sb_wait
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Mikulas

Can we fix this by this:

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -929,10 +929,10 @@ static void super_written(struct bio *bio)

        bio_put(bio);

-       rdev_dec_pending(rdev, mddev);
-
        if (atomic_dec_and_test(&mddev->pending_writes))
                wake_up(&mddev->sb_wait);
+
+       rdev_dec_pending(rdev, mddev);
 }

Regards
Xiao


On Tue, Jan 24, 2023 at 10:06 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> There's a theoretical race condition in md.
>
> super_written calls:
>         if (atomic_dec_and_test(&mddev->pending_writes))
>                 wake_up(&mddev->sb_wait);
>
> If the process is rescheduled just after atomic_dec_and_test and before
> wake_up, it may happen that the mddev structure is freed (because
> mddev->pending_writes is zero) and on scheduling back,
> wake_up(&mddev->sb_wait) would access freed memory.
>
> Fix this bug by using an array of preallocated wait_queues, so that the
> wait queue exist even after mddev was freed.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
> ---
>  drivers/md/md.c          |   56 ++++++++++++++++++++++++++---------------------
>  drivers/md/md.h          |   10 +++++++-
>  drivers/md/raid10.c      |    4 +--
>  drivers/md/raid5-cache.c |    6 ++---
>  drivers/md/raid5.c       |    8 +++---
>  5 files changed, 49 insertions(+), 35 deletions(-)
>
> Index: linux-2.6/drivers/md/md.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/md.c
> +++ linux-2.6/drivers/md/md.c
> @@ -89,6 +89,9 @@ static struct workqueue_struct *md_wq;
>  static struct workqueue_struct *md_misc_wq;
>  static struct workqueue_struct *md_rdev_misc_wq;
>
> +wait_queue_head_t md_sb_wait_table[MD_SB_WAIT_TABLE_SIZE];
> +EXPORT_SYMBOL(md_sb_wait_table);
> +
>  static int remove_and_add_spares(struct mddev *mddev,
>                                  struct md_rdev *this);
>  static void mddev_detach(struct mddev *mddev);
> @@ -415,7 +418,7 @@ check_suspended:
>                         return;
>                 }
>                 for (;;) {
> -                       prepare_to_wait(&mddev->sb_wait, &__wait,
> +                       prepare_to_wait(md_sb_wait(mddev), &__wait,
>                                         TASK_UNINTERRUPTIBLE);
>                         if (!is_suspended(mddev, bio))
>                                 break;
> @@ -423,19 +426,19 @@ check_suspended:
>                         schedule();
>                         rcu_read_lock();
>                 }
> -               finish_wait(&mddev->sb_wait, &__wait);
> +               finish_wait(md_sb_wait(mddev), &__wait);
>         }
>         atomic_inc(&mddev->active_io);
>         rcu_read_unlock();
>
>         if (!mddev->pers->make_request(mddev, bio)) {
>                 atomic_dec(&mddev->active_io);
> -               wake_up(&mddev->sb_wait);
> +               wake_up_all(md_sb_wait(mddev));
>                 goto check_suspended;
>         }
>
>         if (atomic_dec_and_test(&mddev->active_io) && mddev->suspended)
> -               wake_up(&mddev->sb_wait);
> +               wake_up_all(md_sb_wait(mddev));
>  }
>  EXPORT_SYMBOL(md_handle_request);
>
> @@ -484,13 +487,13 @@ void mddev_suspend(struct mddev *mddev)
>         if (mddev->suspended++)
>                 return;
>         synchronize_rcu();
> -       wake_up(&mddev->sb_wait);
> +       wake_up_all(md_sb_wait(mddev));
>         set_bit(MD_ALLOW_SB_UPDATE, &mddev->flags);
>         smp_mb__after_atomic();
> -       wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0);
> +       wait_event(*md_sb_wait(mddev), atomic_read(&mddev->active_io) == 0);
>         mddev->pers->quiesce(mddev, 1);
>         clear_bit_unlock(MD_ALLOW_SB_UPDATE, &mddev->flags);
> -       wait_event(mddev->sb_wait, !test_bit(MD_UPDATING_SB, &mddev->flags));
> +       wait_event(*md_sb_wait(mddev), !test_bit(MD_UPDATING_SB, &mddev->flags));
>
>         del_timer_sync(&mddev->safemode_timer);
>         /* restrict memory reclaim I/O during raid array is suspend */
> @@ -505,7 +508,7 @@ void mddev_resume(struct mddev *mddev)
>         lockdep_assert_held(&mddev->reconfig_mutex);
>         if (--mddev->suspended)
>                 return;
> -       wake_up(&mddev->sb_wait);
> +       wake_up_all(md_sb_wait(mddev));
>         mddev->pers->quiesce(mddev, 0);
>
>         set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> @@ -585,7 +588,7 @@ static void md_submit_flush_data(struct
>         mddev->prev_flush_start = mddev->start_flush;
>         mddev->flush_bio = NULL;
>         spin_unlock_irq(&mddev->lock);
> -       wake_up(&mddev->sb_wait);
> +       wake_up_all(md_sb_wait(mddev));
>
>         if (bio->bi_iter.bi_size == 0) {
>                 /* an empty barrier - all done */
> @@ -609,7 +612,7 @@ bool md_flush_request(struct mddev *mdde
>         /* flush requests wait until ongoing flush completes,
>          * hence coalescing all the pending requests.
>          */
> -       wait_event_lock_irq(mddev->sb_wait,
> +       wait_event_lock_irq(*md_sb_wait(mddev),
>                             !mddev->flush_bio ||
>                             ktime_before(req_start, mddev->prev_flush_start),
>                             mddev->lock);
> @@ -686,7 +689,6 @@ void mddev_init(struct mddev *mddev)
>         atomic_set(&mddev->active_io, 0);
>         spin_lock_init(&mddev->lock);
>         atomic_set(&mddev->flush_pending, 0);
> -       init_waitqueue_head(&mddev->sb_wait);
>         init_waitqueue_head(&mddev->recovery_wait);
>         mddev->reshape_position = MaxSector;
>         mddev->reshape_backwards = 0;
> @@ -828,7 +830,7 @@ void mddev_unlock(struct mddev *mddev)
>          */
>         spin_lock(&pers_lock);
>         md_wakeup_thread(mddev->thread);
> -       wake_up(&mddev->sb_wait);
> +       wake_up_all(md_sb_wait(mddev));
>         spin_unlock(&pers_lock);
>  }
>  EXPORT_SYMBOL_GPL(mddev_unlock);
> @@ -933,7 +935,7 @@ static void super_written(struct bio *bi
>         rdev_dec_pending(rdev, mddev);
>
>         if (atomic_dec_and_test(&mddev->pending_writes))
> -               wake_up(&mddev->sb_wait);
> +               wake_up_all(md_sb_wait(mddev));
>  }
>
>  void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
> @@ -977,7 +979,7 @@ void md_super_write(struct mddev *mddev,
>  int md_super_wait(struct mddev *mddev)
>  {
>         /* wait for all superblock writes that were scheduled to complete */
> -       wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes)==0);
> +       wait_event(*md_sb_wait(mddev), atomic_read(&mddev->pending_writes)==0);
>         if (test_and_clear_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags))
>                 return -EAGAIN;
>         return 0;
> @@ -2681,7 +2683,7 @@ repeat:
>                                 wake_up(&rdev->blocked_wait);
>                         }
>                 }
> -               wake_up(&mddev->sb_wait);
> +               wake_up_all(md_sb_wait(mddev));
>                 return;
>         }
>
> @@ -2791,7 +2793,7 @@ rewrite:
>                                BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_CLEAN)))
>                 /* have to write it out again */
>                 goto repeat;
> -       wake_up(&mddev->sb_wait);
> +       wake_up_all(md_sb_wait(mddev));
>         if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
>                 sysfs_notify_dirent_safe(mddev->sysfs_completed);
>
> @@ -4383,7 +4385,7 @@ array_state_store(struct mddev *mddev, c
>                         restart_array(mddev);
>                         clear_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
>                         md_wakeup_thread(mddev->thread);
> -                       wake_up(&mddev->sb_wait);
> +                       wake_up_all(md_sb_wait(mddev));
>                 } else /* st == clean */ {
>                         restart_array(mddev);
>                         if (!set_in_sync(mddev))
> @@ -4456,7 +4458,7 @@ array_state_store(struct mddev *mddev, c
>                         if (err)
>                                 break;
>                         clear_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
> -                       wake_up(&mddev->sb_wait);
> +                       wake_up_all(md_sb_wait(mddev));
>                         err = 0;
>                 } else {
>                         mddev->ro = MD_RDWR;
> @@ -6283,7 +6285,7 @@ static int md_set_readonly(struct mddev
>         mddev_unlock(mddev);
>         wait_event(resync_wait, !test_bit(MD_RECOVERY_RUNNING,
>                                           &mddev->recovery));
> -       wait_event(mddev->sb_wait,
> +       wait_event(*md_sb_wait(mddev),
>                    !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
>         mddev_lock_nointr(mddev);
>
> @@ -7564,7 +7566,7 @@ static int md_ioctl(struct block_device
>
>         if (cmd == HOT_REMOVE_DISK)
>                 /* need to ensure recovery thread has run */
> -               wait_event_interruptible_timeout(mddev->sb_wait,
> +               wait_event_interruptible_timeout(*md_sb_wait(mddev),
>                                                  !test_bit(MD_RECOVERY_NEEDED,
>                                                            &mddev->recovery),
>                                                  msecs_to_jiffies(5000));
> @@ -7669,7 +7671,7 @@ static int md_ioctl(struct block_device
>                  */
>                 if (test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags)) {
>                         mddev_unlock(mddev);
> -                       wait_event(mddev->sb_wait,
> +                       wait_event(*md_sb_wait(mddev),
>                                    !test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags) &&
>                                    !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
>                         mddev_lock_nointr(mddev);
> @@ -8529,7 +8531,7 @@ bool md_write_start(struct mddev *mddev,
>                 sysfs_notify_dirent_safe(mddev->sysfs_state);
>         if (!mddev->has_superblocks)
>                 return true;
> -       wait_event(mddev->sb_wait,
> +       wait_event(*md_sb_wait(mddev),
>                    !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) ||
>                    mddev->suspended);
>         if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
> @@ -8674,7 +8676,7 @@ void md_allow_write(struct mddev *mddev)
>                 md_update_sb(mddev, 0);
>                 sysfs_notify_dirent_safe(mddev->sysfs_state);
>                 /* wait for the dirty state to be recorded in the metadata */
> -               wait_event(mddev->sb_wait,
> +               wait_event(*md_sb_wait(mddev),
>                            !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
>         } else
>                 spin_unlock(&mddev->lock);
> @@ -9256,7 +9258,7 @@ void md_check_recovery(struct mddev *mdd
>                 if (test_bit(MD_ALLOW_SB_UPDATE, &mddev->flags))
>                         md_update_sb(mddev, 0);
>                 clear_bit_unlock(MD_UPDATING_SB, &mddev->flags);
> -               wake_up(&mddev->sb_wait);
> +               wake_up_all(md_sb_wait(mddev));
>         }
>
>         if (mddev->suspended)
> @@ -9420,7 +9422,7 @@ void md_check_recovery(struct mddev *mdd
>                                         sysfs_notify_dirent_safe(mddev->sysfs_action);
>                 }
>         unlock:
> -               wake_up(&mddev->sb_wait);
> +               wake_up_all(md_sb_wait(mddev));
>                 mddev_unlock(mddev);
>         }
>  }
> @@ -9608,6 +9610,10 @@ static void md_geninit(void)
>  static int __init md_init(void)
>  {
>         int ret = -ENOMEM;
> +       int i;
> +
> +       for (i = 0; i < MD_SB_WAIT_TABLE_SIZE; i++)
> +               init_waitqueue_head(md_sb_wait_table + i);
>
>         md_wq = alloc_workqueue("md", WQ_MEM_RECLAIM, 0);
>         if (!md_wq)
> Index: linux-2.6/drivers/md/md.h
> ===================================================================
> --- linux-2.6.orig/drivers/md/md.h
> +++ linux-2.6/drivers/md/md.h
> @@ -466,7 +466,6 @@ struct mddev {
>          *   setting MD_RECOVERY_RUNNING (which interacts with resync_{min,max})
>          */
>         spinlock_t                      lock;
> -       wait_queue_head_t               sb_wait;        /* for waiting on superblock updates */
>         atomic_t                        pending_writes; /* number of active superblock writes */
>
>         unsigned int                    safemode;       /* if set, update "clean" superblock
> @@ -584,6 +583,15 @@ static inline void md_sync_acct_bio(stru
>         md_sync_acct(bio->bi_bdev, nr_sectors);
>  }
>
> +#define MD_SB_WAIT_TABLE_BITS  8
> +#define MD_SB_WAIT_TABLE_SIZE  (1U << MD_SB_WAIT_TABLE_BITS)
> +extern wait_queue_head_t md_sb_wait_table[MD_SB_WAIT_TABLE_SIZE];
> +
> +static inline wait_queue_head_t *md_sb_wait(struct mddev *md)
> +{
> +       return md_sb_wait_table + hash_long((unsigned long)md, MD_SB_WAIT_TABLE_BITS);
> +}
> +
>  struct md_personality
>  {
>         char *name;
> Index: linux-2.6/drivers/md/raid10.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/raid10.c
> +++ linux-2.6/drivers/md/raid10.c
> @@ -1446,7 +1446,7 @@ static void raid10_write_request(struct
>                         return;
>                 }
>                 raid10_log(conf->mddev, "wait reshape metadata");
> -               wait_event(mddev->sb_wait,
> +               wait_event(*md_sb_wait(mddev),
>                            !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
>
>                 conf->reshape_safe = mddev->reshape_position;
> @@ -4876,7 +4876,7 @@ static sector_t reshape_request(struct m
>                 conf->reshape_checkpoint = jiffies;
>                 set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>                 md_wakeup_thread(mddev->thread);
> -               wait_event(mddev->sb_wait, mddev->sb_flags == 0 ||
> +               wait_event(*md_sb_wait(mddev), mddev->sb_flags == 0 ||
>                            test_bit(MD_RECOVERY_INTR, &mddev->recovery));
>                 if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
>                         allow_barrier(conf);
> Index: linux-2.6/drivers/md/raid5-cache.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/raid5-cache.c
> +++ linux-2.6/drivers/md/raid5-cache.c
> @@ -691,7 +691,7 @@ static void r5c_disable_writeback_async(
>                 mdname(mddev));
>
>         /* wait superblock change before suspend */
> -       wait_event(mddev->sb_wait,
> +       wait_event(*md_sb_wait(mddev),
>                    conf->log == NULL ||
>                    (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) &&
>                     (locked = mddev_trylock(mddev))));
> @@ -1581,7 +1581,7 @@ void r5l_quiesce(struct r5l_log *log, in
>         if (quiesce) {
>                 /* make sure r5l_write_super_and_discard_space exits */
>                 mddev = log->rdev->mddev;
> -               wake_up(&mddev->sb_wait);
> +               wake_up_all(md_sb_wait(mddev));
>                 kthread_park(log->reclaim_thread->tsk);
>                 r5l_wake_reclaim(log, MaxSector);
>                 r5l_do_reclaim(log);
> @@ -3165,7 +3165,7 @@ void r5l_exit_log(struct r5conf *conf)
>         struct r5l_log *log = conf->log;
>
>         /* Ensure disable_writeback_work wakes up and exits */
> -       wake_up(&conf->mddev->sb_wait);
> +       wake_up_all(md_sb_wait(conf->mddev));
>         flush_work(&log->disable_writeback_work);
>         md_unregister_thread(&log->reclaim_thread);
>
> Index: linux-2.6/drivers/md/raid5.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/raid5.c
> +++ linux-2.6/drivers/md/raid5.c
> @@ -6346,7 +6346,7 @@ static sector_t reshape_request(struct m
>                 conf->reshape_checkpoint = jiffies;
>                 set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>                 md_wakeup_thread(mddev->thread);
> -               wait_event(mddev->sb_wait, mddev->sb_flags == 0 ||
> +               wait_event(*md_sb_wait(mddev), mddev->sb_flags == 0 ||
>                            test_bit(MD_RECOVERY_INTR, &mddev->recovery));
>                 if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
>                         return 0;
> @@ -6454,7 +6454,7 @@ finish:
>                 conf->reshape_checkpoint = jiffies;
>                 set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>                 md_wakeup_thread(mddev->thread);
> -               wait_event(mddev->sb_wait,
> +               wait_event(*md_sb_wait(mddev),
>                            !test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags)
>                            || test_bit(MD_RECOVERY_INTR, &mddev->recovery));
>                 if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
> @@ -6703,7 +6703,7 @@ static void raid5_do_work(struct work_st
>                 if (!batch_size && !released)
>                         break;
>                 handled += batch_size;
> -               wait_event_lock_irq(mddev->sb_wait,
> +               wait_event_lock_irq(*md_sb_wait(mddev),
>                         !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
>                         conf->device_lock);
>         }
> @@ -6792,7 +6792,7 @@ static void raid5d(struct md_thread *thr
>                         continue;
>                 }
>
> -               wait_event_lock_irq(mddev->sb_wait,
> +               wait_event_lock_irq(*md_sb_wait(mddev),
>                         !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
>                         conf->device_lock);
>         }
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

