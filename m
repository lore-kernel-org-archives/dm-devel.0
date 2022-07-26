Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48170CCA489
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jul 2022 08:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658824400;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fo6vGmkR0vUv/Wdbdv5IWBsN4OGdNtkeo8mAJqjqRkQ=;
	b=c/N1BizE0tS7HzUuX7ikn4RTn6+sdNKscF+yr7q08WTGZkuQMl5UUWiS3t2a2R3PowDPyS
	498DbQlr2b4vm4Yww56hFh/wL5ptF8p01Z3StePACzv0H8K2ymd3FmONI6CEPf2MBRIbuq
	VV+/uTYLUxA5AMgXlndpDhLqMWS2KMo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-O5R8W1DzPc2RAXWs_qk4mQ-1; Tue, 26 Jul 2022 04:33:17 -0400
X-MC-Unique: O5R8W1DzPc2RAXWs_qk4mQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1952A38173C1;
	Tue, 26 Jul 2022 08:33:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F36E118EA8;
	Tue, 26 Jul 2022 08:33:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A34EB1945D89;
	Tue, 26 Jul 2022 08:33:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 24B651945D86
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Jul 2022 08:33:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 12A9A2166B2C; Tue, 26 Jul 2022 08:33:13 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 077992166B2A;
 Tue, 26 Jul 2022 08:33:13 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 26Q8XCG9000421; Tue, 26 Jul 2022 04:33:12 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 26Q8XCS8000417; Tue, 26 Jul 2022 04:33:12 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Tue, 26 Jul 2022 04:33:12 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Song Liu <song@kernel.org>
In-Reply-To: <CAPhsuW7-NtUDEqBCSnjQPW+Z8bcgMkaK6BsWUN4_fuULcpoCiw@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.2207260431020.32515@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2207241426320.26078@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPhsuW7-NtUDEqBCSnjQPW+Z8bcgMkaK6BsWUN4_fuULcpoCiw@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH] md-raid10: fix KASAN warning
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
Cc: linux-raid <linux-raid@vger.kernel.org>,
 Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There's a KASAN warning in raid10_remove_disk when running the lvm
test lvconvert-raid-reshape.sh. We fix this warning by verifying that the
value "number" is valid.

BUG: KASAN: slab-out-of-bounds in raid10_remove_disk+0x61/0x2a0 [raid10]
Read of size 8 at addr ffff889108f3d300 by task mdX_raid10/124682

CPU: 3 PID: 124682 Comm: mdX_raid10 Not tainted 5.19.0-rc6 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x34/0x44
 print_report.cold+0x45/0x57a
 ? __lock_text_start+0x18/0x18
 ? raid10_remove_disk+0x61/0x2a0 [raid10]
 kasan_report+0xa8/0xe0
 ? raid10_remove_disk+0x61/0x2a0 [raid10]
 raid10_remove_disk+0x61/0x2a0 [raid10]
Buffer I/O error on dev dm-76, logical block 15344, async page read
 ? __mutex_unlock_slowpath.constprop.0+0x1e0/0x1e0
 remove_and_add_spares+0x367/0x8a0 [md_mod]
 ? super_written+0x1c0/0x1c0 [md_mod]
 ? mutex_trylock+0xac/0x120
 ? _raw_spin_lock+0x72/0xc0
 ? _raw_spin_lock_bh+0xc0/0xc0
 md_check_recovery+0x848/0x960 [md_mod]
 raid10d+0xcf/0x3360 [raid10]
 ? sched_clock_cpu+0x185/0x1a0
 ? rb_erase+0x4d4/0x620
 ? var_wake_function+0xe0/0xe0
 ? psi_group_change+0x411/0x500
 ? preempt_count_sub+0xf/0xc0
 ? _raw_spin_lock_irqsave+0x78/0xc0
 ? __lock_text_start+0x18/0x18
 ? raid10_sync_request+0x36c0/0x36c0 [raid10]
 ? preempt_count_sub+0xf/0xc0
 ? _raw_spin_unlock_irqrestore+0x19/0x40
 ? del_timer_sync+0xa9/0x100
 ? try_to_del_timer_sync+0xc0/0xc0
 ? _raw_spin_lock_irqsave+0x78/0xc0
 ? __lock_text_start+0x18/0x18
 ? _raw_spin_unlock_irq+0x11/0x24
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

Allocated by task 124495:
 kasan_save_stack+0x1e/0x40
 __kasan_kmalloc+0x80/0xa0
 setup_conf+0x140/0x5c0 [raid10]
 raid10_run+0x4cd/0x740 [raid10]
 md_run+0x6f9/0x1300 [md_mod]
 raid_ctr+0x2531/0x4ac0 [dm_raid]
 dm_table_add_target+0x2b0/0x620 [dm_mod]
 table_load+0x1c8/0x400 [dm_mod]
 ctl_ioctl+0x29e/0x560 [dm_mod]
 dm_compat_ctl_ioctl+0x7/0x20 [dm_mod]
 __do_compat_sys_ioctl+0xfa/0x160
 do_syscall_64+0x90/0xc0
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Last potentially related work creation:
 kasan_save_stack+0x1e/0x40
 __kasan_record_aux_stack+0x9e/0xc0
 kvfree_call_rcu+0x84/0x480
 timerfd_release+0x82/0x140
L __fput+0xfa/0x400
 task_work_run+0x80/0xc0
 exit_to_user_mode_prepare+0x155/0x160
 syscall_exit_to_user_mode+0x12/0x40
 do_syscall_64+0x42/0xc0
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Second to last potentially related work creation:
 kasan_save_stack+0x1e/0x40
 __kasan_record_aux_stack+0x9e/0xc0
 kvfree_call_rcu+0x84/0x480
 timerfd_release+0x82/0x140
 __fput+0xfa/0x400
 task_work_run+0x80/0xc0
 exit_to_user_mode_prepare+0x155/0x160
 syscall_exit_to_user_mode+0x12/0x40
 do_syscall_64+0x42/0xc0
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

The buggy address belongs to the object at ffff889108f3d200
 which belongs to the cache kmalloc-256 of size 256
The buggy address is located 0 bytes to the right of
 256-byte region [ffff889108f3d200, ffff889108f3d300)

The buggy address belongs to the physical page:
page:000000007ef2a34c refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1108f3c
head:000000007ef2a34c order:2 compound_mapcount:0 compound_pincount:0
flags: 0x4000000000010200(slab|head|zone=2)
raw: 4000000000010200 0000000000000000 dead000000000001 ffff889100042b40
raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff889108f3d200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff889108f3d280: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff889108f3d300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff889108f3d380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff889108f3d400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/raid10.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/raid10.c
===================================================================
--- linux-2.6.orig/drivers/md/raid10.c	2022-07-13 19:05:50.000000000 +0200
+++ linux-2.6/drivers/md/raid10.c	2022-07-13 19:07:05.000000000 +0200
@@ -2167,9 +2167,12 @@ static int raid10_remove_disk(struct mdd
 	int err = 0;
 	int number = rdev->raid_disk;
 	struct md_rdev **rdevp;
-	struct raid10_info *p = conf->mirrors + number;
+	struct raid10_info *p;
 
 	print_conf(conf);
+	if (unlikely(number >= mddev->raid_disks))
+		return 0;
+	p = conf->mirrors + number;
 	if (rdev == p->rdev)
 		rdevp = &p->rdev;
 	else if (rdev == p->replacement)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

