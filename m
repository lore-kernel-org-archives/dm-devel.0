Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F066C433EF
	for <dm-devel@archiver.kernel.org>; Sun, 24 Jul 2022 18:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658687181;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XZOyXCw040lNqeMu6XNkn2LcRDkNMuRKSu/HYz6gYeo=;
	b=FTM+e8tp+392ndZjrJ/a2B2xxREY7QmMuUjHon9dVfJ4aOOOa2QLRomyg911K91YPl4kC7
	3y1NGviACzSiVof845JdeBsuh58FLIGqvrWBXYTEDWo911an7TMVGDflm3rDBVaOhl2Ul6
	6WxFf5lB3wYe+d69iZRKExZGWidhYJA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-y4f2xGLzNBK3NaT651-QbA-1; Sun, 24 Jul 2022 14:26:19 -0400
X-MC-Unique: y4f2xGLzNBK3NaT651-QbA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E9913C02B75;
	Sun, 24 Jul 2022 18:26:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1D8F82166B26;
	Sun, 24 Jul 2022 18:26:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D2A701945D87;
	Sun, 24 Jul 2022 18:26:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B056C1945D81
 for <dm-devel@listman.corp.redhat.com>; Sun, 24 Jul 2022 18:26:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 92CAC2026609; Sun, 24 Jul 2022 18:26:12 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 815E82026D64;
 Sun, 24 Jul 2022 18:26:12 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 26OIQC75026204; Sun, 24 Jul 2022 14:26:12 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 26OIQCm9026200; Sun, 24 Jul 2022 14:26:12 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Sun, 24 Jul 2022 14:26:12 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Message-ID: <alpine.LRH.2.02.2207130714180.12929@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH] md-raid: destroy the bitmap after destroying the
 thread
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
 dm-devel@redhat.com, Shaohua Li <shli@fb.com>,
 Guoqing Jiang <gqjiang@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When we ran the lvm test "shell/integrity-blocksize-3.sh" on a kernel with 
kasan, we got failure in write_page.

The reason for the failure is that md_bitmap_destroy is called before
destroying the thread and the thread may be waiting in the function
write_page for the bio to complete. When the thread finishes waiting, it
executes "if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))", which
triggers the kasan warning.

Note that the commit 48df498daf62 that caused this bug claims that it is 
neede for md-cluster, you should check md-cluster and possibly find 
another bugfix for it.

BUG: KASAN: use-after-free in write_page+0x18d/0x680 [md_mod]
Read of size 8 at addr ffff889162030c78 by task mdX_raid1/5539

CPU: 10 PID: 5539 Comm: mdX_raid1 Not tainted 5.19.0-rc2 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x34/0x44
 print_report.cold+0x45/0x57a
 ? __lock_text_start+0x18/0x18
 ? write_page+0x18d/0x680 [md_mod]
 kasan_report+0xa8/0xe0
 ? write_page+0x18d/0x680 [md_mod]
 kasan_check_range+0x13f/0x180
 write_page+0x18d/0x680 [md_mod]
 ? super_sync+0x4d5/0x560 [dm_raid]
 ? md_bitmap_file_kick+0xa0/0xa0 [md_mod]
 ? rs_set_dev_and_array_sectors+0x2e0/0x2e0 [dm_raid]
 ? mutex_trylock+0x120/0x120
 ? preempt_count_add+0x6b/0xc0
 ? preempt_count_sub+0xf/0xc0
 md_update_sb+0x707/0xe40 [md_mod]
 md_reap_sync_thread+0x1b2/0x4a0 [md_mod]
 md_check_recovery+0x533/0x960 [md_mod]
 raid1d+0xc8/0x2a20 [raid1]
 ? var_wake_function+0xe0/0xe0
 ? psi_group_change+0x411/0x500
 ? preempt_count_sub+0xf/0xc0
 ? _raw_spin_lock_irqsave+0x78/0xc0
 ? __lock_text_start+0x18/0x18
 ? raid1_end_read_request+0x2a0/0x2a0 [raid1]
 ? preempt_count_sub+0xf/0xc0
 ? _raw_spin_unlock_irqrestore+0x19/0x40
 ? del_timer_sync+0xa9/0x100
 ? try_to_del_timer_sync+0xc0/0xc0
 ? _raw_spin_lock_irqsave+0x78/0xc0
 ? __lock_text_start+0x18/0x18
 ? __list_del_entry_valid+0x68/0xa0
 ? finish_wait+0xa3/0x100
 md_thread+0x161/0x260 [md_mod]
 ? unregister_md_personality+0xa0/0xa0 [md_mod]
 ? _raw_spin_lock_irqsave+0x78/0xc0
 ? prepare_to_wait_event+0x2c0/0x2c0
 ? unregister_md_personality+0xa0/0xa0 [md_mod]
 kthread+0x148/0x180
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x1f/0x30
 </TASK>

Allocated by task 5522:
 kasan_save_stack+0x1e/0x40
 __kasan_kmalloc+0x80/0xa0
 md_bitmap_create+0xa8/0xe80 [md_mod]
 md_run+0x777/0x1300 [md_mod]
 raid_ctr+0x249c/0x4a30 [dm_raid]
 dm_table_add_target+0x2b0/0x620 [dm_mod]
 table_load+0x1c8/0x400 [dm_mod]
 ctl_ioctl+0x29e/0x560 [dm_mod]
 dm_compat_ctl_ioctl+0x7/0x20 [dm_mod]
 __do_compat_sys_ioctl+0xfa/0x160
 do_syscall_64+0x90/0xc0
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Freed by task 5680:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x40
 kasan_set_free_info+0x20/0x40
 __kasan_slab_free+0xf7/0x140
 kfree+0x80/0x240
 md_bitmap_free+0x1c3/0x280 [md_mod]
 __md_stop+0x21/0x120 [md_mod]
 md_stop+0x9/0x40 [md_mod]
 raid_dtr+0x1b/0x40 [dm_raid]
 dm_table_destroy+0x98/0x1e0 [dm_mod]
 __dm_destroy+0x199/0x360 [dm_mod]
 dev_remove+0x10c/0x160 [dm_mod]
 ctl_ioctl+0x29e/0x560 [dm_mod]
 dm_compat_ctl_ioctl+0x7/0x20 [dm_mod]
 __do_compat_sys_ioctl+0xfa/0x160
 do_syscall_64+0x90/0xc0
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 48df498daf62 ("md: move bitmap_destroy to the beginning of __md_stop")

---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c	2022-06-08 15:39:08.000000000 +0200
+++ linux-2.6/drivers/md/md.c	2022-06-24 20:22:34.000000000 +0200
@@ -6244,11 +6244,11 @@ static void mddev_detach(struct mddev *m
 static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
-	md_bitmap_destroy(mddev);
 	mddev_detach(mddev);
 	/* Ensure ->event_work is done */
 	if (mddev->event_work.func)
 		flush_workqueue(md_misc_wq);
+	md_bitmap_destroy(mddev);
 	spin_lock(&mddev->lock);
 	mddev->pers = NULL;
 	spin_unlock(&mddev->lock);
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

