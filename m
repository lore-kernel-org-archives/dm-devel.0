Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05169C4332F
	for <dm-devel@archiver.kernel.org>; Fri,  4 Nov 2022 13:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667570025;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=o0SyrNVKV6M5JOCy0LcaXjWer9hpfjU1PAQDhAQy++8=;
	b=JQUoKvry6dJASFn4xUqLvvGxzTtQTwUCcWGviHAvubzvoFMTHv5hG3lyGkltDS2qVLxU/J
	+bHG2jfUFNg8mci90G9rmIuqG1W/tyYAxyUKmD5PVJGU06/+HCjRZVv1Ht7euAIYA4z9WY
	v4nnDR+W0/kiXFgVicuw3TFbSYC8odo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-Ezpt-1pIN-uGzTJvvcK9kw-1; Fri, 04 Nov 2022 09:53:44 -0400
X-MC-Unique: Ezpt-1pIN-uGzTJvvcK9kw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42A03185A79C;
	Fri,  4 Nov 2022 13:53:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2DF382024CC5;
	Fri,  4 Nov 2022 13:53:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0DBD71946587;
	Fri,  4 Nov 2022 13:53:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 96E5E1946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  4 Nov 2022 13:53:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 45EF8477F5C; Fri,  4 Nov 2022 13:53:39 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2098B477F55;
 Fri,  4 Nov 2022 13:53:39 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 2A4Drd7p003408; Fri, 4 Nov 2022 09:53:39 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 2A4DrcC1003404; Fri, 4 Nov 2022 09:53:38 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Fri, 4 Nov 2022 09:53:38 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: NeilBrown <neilb@suse.de>
Message-ID: <alpine.LRH.2.21.2211040952390.19553@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH v2] md: fix a crash in mempool_free
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
Cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Guoqing Jiang <guoqing.jiang@linux.dev>, Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There's a crash in mempool_free when running the lvm test
shell/lvchange-rebuild-raid.sh.

The reason for the crash is this:
* super_written calls atomic_dec_and_test(&mddev->pending_writes) and
  wake_up(&mddev->sb_wait). Then it calls rdev_dec_pending(rdev, mddev)
  and bio_put(bio).
* so, the process that waited on sb_wait and that is woken up is racing
  with bio_put(bio).
* if the process wins the race, it calls bioset_exit before bio_put(bio)
  is executed.
* bio_put(bio) attempts to free a bio into a destroyed bio set - causing
  a crash in mempool_free.

We fix this bug by moving bio_put before atomic_dec_and_test.

We also move rdev_dec_pending before atomic_dec_and_test as suggested by
Neil Brown.

The function md_end_flush has a similar bug - we must call bio_put before
we decrement the number of in-progress bios.

 BUG: kernel NULL pointer dereference, address: 0000000000000000
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 PGD 11557f0067 P4D 11557f0067 PUD 0
 Oops: 0002 [#1] PREEMPT SMP
 CPU: 0 PID: 73 Comm: kworker/0:1 Not tainted 6.1.0-rc3 #5
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
 Workqueue: kdelayd flush_expired_bios [dm_delay]
 RIP: 0010:mempool_free+0x47/0x80
 Code: 48 89 ef 5b 5d ff e0 f3 c3 48 89 f7 e8 32 45 3f 00 48 63 53 08 48 89 c6 3b 53 04 7d 2d 48 8b 43 10 8d 4a 01 48 89 df 89 4b 08 <48> 89 2c d0 e8 b0 45 3f 00 48 8d 7b 30 5b 5d 31 c9 ba 01 00 00 00
 RSP: 0018:ffff88910036bda8 EFLAGS: 00010093
 RAX: 0000000000000000 RBX: ffff8891037b65d8 RCX: 0000000000000001
 RDX: 0000000000000000 RSI: 0000000000000202 RDI: ffff8891037b65d8
 RBP: ffff8891447ba240 R08: 0000000000012908 R09: 00000000003d0900
 R10: 0000000000000000 R11: 0000000000173544 R12: ffff889101a14000
 R13: ffff8891562ac300 R14: ffff889102b41440 R15: ffffe8ffffa00d05
 FS:  0000000000000000(0000) GS:ffff88942fa00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000000 CR3: 0000001102e99000 CR4: 00000000000006b0
 Call Trace:
  <TASK>
  clone_endio+0xf4/0x1c0 [dm_mod]
  clone_endio+0xf4/0x1c0 [dm_mod]
  __submit_bio+0x76/0x120
  submit_bio_noacct_nocheck+0xb6/0x2a0
  flush_expired_bios+0x28/0x2f [dm_delay]
  process_one_work+0x1b4/0x300
  worker_thread+0x45/0x3e0
  ? rescuer_thread+0x380/0x380
  kthread+0xc2/0x100
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x1f/0x30
  </TASK>
 Modules linked in: brd dm_delay dm_raid dm_mod af_packet uvesafb cfbfillrect cfbimgblt cn cfbcopyarea fb font fbdev tun autofs4 binfmt_misc configfs ipv6 virtio_rng virtio_balloon rng_core virtio_net pcspkr net_failover failover qemu_fw_cfg button mousedev raid10 raid456 libcrc32c async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx raid1 raid0 md_mod sd_mod t10_pi crc64_rocksoft crc64 virtio_scsi scsi_mod evdev psmouse bsg scsi_common [last unloaded: brd]
 CR2: 0000000000000000
 ---[ end trace 0000000000000000 ]---

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/md.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c	2022-11-03 15:29:02.000000000 +0100
+++ linux-2.6/drivers/md/md.c	2022-11-04 14:29:37.000000000 +0100
@@ -509,13 +509,14 @@ static void md_end_flush(struct bio *bio
 	struct md_rdev *rdev = bio->bi_private;
 	struct mddev *mddev = rdev->mddev;
 
+	bio_put(bio);
+
 	rdev_dec_pending(rdev, mddev);
 
 	if (atomic_dec_and_test(&mddev->flush_pending)) {
 		/* The pre-request flush has finished */
 		queue_work(md_wq, &mddev->flush_work);
 	}
-	bio_put(bio);
 }
 
 static void md_submit_flush_data(struct work_struct *ws);
@@ -913,10 +914,12 @@ static void super_written(struct bio *bi
 	} else
 		clear_bit(LastDev, &rdev->flags);
 
+	bio_put(bio);
+
+	rdev_dec_pending(rdev, mddev);
+
 	if (atomic_dec_and_test(&mddev->pending_writes))
 		wake_up(&mddev->sb_wait);
-	rdev_dec_pending(rdev, mddev);
-	bio_put(bio);
 }
 
 void md_super_write(struct mddev *mddev, struct md_rdev *rdev,

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

