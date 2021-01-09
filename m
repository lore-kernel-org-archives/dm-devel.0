Return-Path: <SRS0=+RIL=GM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8765C433DB
	for <dm-devel@archiver.kernel.org>; Sat,  9 Jan 2021 15:17:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 567A523A04
	for <dm-devel@archiver.kernel.org>; Sat,  9 Jan 2021 15:17:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 567A523A04
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-2s10PmDQOK-Dj72QVookCw-1; Sat, 09 Jan 2021 10:17:40 -0500
X-MC-Unique: 2s10PmDQOK-Dj72QVookCw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B6BB107ACE3;
	Sat,  9 Jan 2021 15:17:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C64B5D755;
	Sat,  9 Jan 2021 15:17:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3D06B4BB7B;
	Sat,  9 Jan 2021 15:17:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 109FHSVe016620 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 9 Jan 2021 10:17:28 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 887192026D3A; Sat,  9 Jan 2021 15:17:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 836272026D14
	for <dm-devel@redhat.com>; Sat,  9 Jan 2021 15:17:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8EDE101A53F
	for <dm-devel@redhat.com>; Sat,  9 Jan 2021 15:17:25 +0000 (UTC)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com
	[209.85.221.51]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-329-RXXR8oy4M2u-Cue0KjUIDg-1; Sat, 09 Jan 2021 10:17:23 -0500
X-MC-Unique: RXXR8oy4M2u-Cue0KjUIDg-1
Received: by mail-wr1-f51.google.com with SMTP id y17so11799593wrr.10
	for <dm-devel@redhat.com>; Sat, 09 Jan 2021 07:17:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=jbX9sBSOqq7HnyVgOIs0Y/3AvCeAvSl2m8KcaMD9b14=;
	b=VojbYE5pJEY/4LLheooJ29T/HHBkzQTsuCBB+BVU+K1L2H3qm2ZxI7QhY6EYZyVsNB
	xgkxCiFj0RjqVkPwsj1Ep6UTBZv5YvJuuPKGZaLvwUfaNDTdU09E+U7iBC/ITG19sH54
	4LGpHHanyQqFwJJAwsoblwnL2ceaNr1ws/YiX/JqAemrCkDmfMI1wJttOkFodsjUyDS1
	Vr+eTwStqBMTffD0ygo3FRVh5gQqE5dua6BnF/NSRxSZqrI1pNwvezLq36ZjQA4UafK8
	W0PbNYb4ab3PCJ+QozcUjQ/edv/9T9fd6a0Pi+K5oZneWXScib7ayxoVEus9hjbKInpy
	6X3Q==
X-Gm-Message-State: AOAM530rPRhXR7tTdqmIYYZutzfJMtuyVwMaVBk9B1vMiMNDo+B9hT/w
	jveFTeq0alubuxsof+gkH0SUMQ==
X-Google-Smtp-Source: ABdhPJy84ymJk61jvZVZl4F+m82bWKREprN+kea/fz/8BHD09MMbKN08wcjL9PWoWHq07WnCEP4n8g==
X-Received: by 2002:adf:dc10:: with SMTP id t16mr8736626wri.345.1610205442583; 
	Sat, 09 Jan 2021 07:17:22 -0800 (PST)
Received: from dev.cfops.net (29.177.200.146.dyn.plus.net. [146.200.177.29])
	by smtp.gmail.com with ESMTPSA id
	m21sm15663601wml.13.2021.01.09.07.17.21
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Sat, 09 Jan 2021 07:17:21 -0800 (PST)
From: Ignat Korchagin <ignat@cloudflare.com>
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, dm-crypt@saout.de,
	linux-kernel@vger.kernel.org
Date: Sat,  9 Jan 2021 15:17:06 +0000
Message-Id: <20210109151706.1466-1-ignat@cloudflare.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: kernel-team@cloudflare.com, stable@vger.kernel.org,
	Ignat Korchagin <ignat@cloudflare.com>
Subject: [dm-devel] [PATCH] dm crypt: do not call bio_endio() from the
	dm-crypt tasklet
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Sometimes, when dm-crypt executes decryption in a tasklet, we may get the
following on a kasan-enabled kernel:

[  397.613621][   C74] ==================================================================
[  397.621794][   C74] BUG: KASAN: use-after-free in tasklet_action_common.constprop.0+0x151/0x2b0
[  397.630759][   C74] Write of size 8 at addr ffff88a139054648 by task swapper/74/0
[  397.638465][   C74]
[  397.640725][   C74] CPU: 74 PID: 0 Comm: swapper/74 Not tainted 5.10.5-cloudflare-kasan-2021.1.3 #1
[  397.650048][   C74] Hardware name: does not matter
[  397.658834][   C74] Call Trace:
[  397.662073][   C74]  <IRQ>
[  397.664862][   C74]  dump_stack+0x7d/0xa3
[  397.668994][   C74]  print_address_description.constprop.0+0x1c/0x210
[  397.675632][   C74]  ? _raw_spin_lock_irqsave+0x87/0xe0
[  397.681017][   C74]  ? _raw_write_unlock_bh+0x60/0x60
[  397.686221][   C74]  ? tasklet_action_common.constprop.0+0x151/0x2b0
[  397.692772][   C74]  ? tasklet_action_common.constprop.0+0x151/0x2b0
[  397.699324][   C74]  kasan_report.cold+0x1f/0x37
[  397.704086][   C74]  ? tasklet_action_common.constprop.0+0x151/0x2b0
[  397.710634][   C74]  check_memory_region+0x13c/0x180
[  397.715752][   C74]  tasklet_action_common.constprop.0+0x151/0x2b0
[  397.722122][   C74]  __do_softirq+0x1a0/0x667
[  397.732905][   C74]  asm_call_irq_on_stack+0x12/0x20
[  397.744322][   C74]  </IRQ>
[  397.753537][   C74]  do_softirq_own_stack+0x37/0x40
[  397.764745][   C74]  irq_exit_rcu+0x110/0x1b0
[  397.775248][   C74]  common_interrupt+0x74/0x120
[  397.785851][   C74]  asm_common_interrupt+0x1e/0x40
[  397.796568][   C74] RIP: 0010:cpuidle_enter_state+0x188/0xab0
[  397.808040][   C74] Code: 89 c4 0f 1f 44 00 00 31 ff e8 d4 bc a4 fe 80 3c 24 00 74 12 9c 58 f6 c4 02 0f 85 2f 06 00 00 31 ff e8 2c 9d b6 fe fb 45 85 f6 <0f> 88 8d 03 00 00 4d 63 ee 49 83 fd 09 0f 87 e1 06 00 00 49 6b c5
[  397.845062][   C74] RSP: 0018:ffff88a05325fe10 EFLAGS: 00000202
[  397.857116][   C74] RAX: dffffc0000000000 RBX: ffff88a068850800 RCX: 000000000000001f
[  397.871232][   C74] RDX: 1ffff115f9f76634 RSI: 0000000037a6f674 RDI: ffff88afcfbb31a0
[  397.885178][   C74] RBP: ffffffff969c0920 R08: 0000011bef59a0e8 R09: ffff88afcfbb3383
[  397.899043][   C74] R10: ffffed15f9f76670 R11: 0000005c1545d831 R12: 0000005c939dd540
[  397.912779][   C74] R13: 0000000000000002 R14: 0000000000000002 R15: ffffffff969c0a48
[  397.926511][   C74]  cpuidle_enter+0x4a/0xa0
[  397.936547][   C74]  ? call_cpuidle+0x3c/0xb0
[  397.946522][   C74]  do_idle+0x2bd/0x320
[  397.955903][   C74]  ? arch_cpu_idle_exit+0x40/0x40
[  397.966195][   C74]  ? swake_up_locked+0x72/0x190
[  397.976193][   C74]  cpu_startup_entry+0x19/0x20
[  397.985918][   C74]  secondary_startup_64_no_verify+0xb0/0xbb
[  397.996679][   C74]
[  398.003698][   C74] Allocated by task 0:
[  398.012533][   C74] (stack is not available)
[  398.021729][   C74]
[  398.028707][   C74] Freed by task 0:
[  398.037155][   C74]  kasan_save_stack+0x20/0x50
[  398.046457][   C74]  kasan_set_track+0x1c/0x30
[  398.055610][   C74]  kasan_set_free_info+0x1b/0x30
[  398.065170][   C74]  __kasan_slab_free+0x110/0x150
[  398.074676][   C74]  slab_free_freelist_hook+0x66/0x120
[  398.084586][   C74]  kmem_cache_free+0x104/0x480
[  398.093834][   C74]  dec_pending+0x1ed/0x8f0 [dm_mod]
[  398.103486][   C74]  clone_endio+0x215/0x870 [dm_mod]
[  398.113058][   C74]  tasklet_action_common.constprop.0+0x20d/0x2b0
[  398.123838][   C74]  __do_softirq+0x1a0/0x667
[  398.132768][   C74]
[  398.139448][   C74] The buggy address belongs to the object at ffff88a139054600
[  398.139448][   C74]  which belongs to the cache bio-5 of size 1144
[  398.162373][   C74] The buggy address is located 72 bytes inside of
[  398.162373][   C74]  1144-byte region [ffff88a139054600, ffff88a139054a78)
[  398.185131][   C74] The buggy address belongs to the page:
[  398.195384][   C74] page:0000000020f4c3cc refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2139050
[  398.214988][   C74] head:0000000020f4c3cc order:3 compound_mapcount:0 compound_pincount:0
[  398.228183][   C74] flags: 0xaffff800010200(slab|head)
[  398.238146][   C74] raw: 00affff800010200 dead000000000100 dead000000000122 ffff88a13b99da00
[  398.251691][   C74] raw: 0000000000000000 0000000080190019 00000001ffffffff 0000000000000000
[  398.265140][   C74] page dumped because: kasan: bad access detected
[  398.276422][   C74]
[  398.283502][   C74] Memory state around the buggy address:
[  398.293892][   C74]  ffff88a139054500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  398.306895][   C74]  ffff88a139054580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  398.319841][   C74] >ffff88a139054600: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  398.332767][   C74]                                               ^
[  398.344064][   C74]  ffff88a139054680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  398.357159][   C74]  ffff88a139054700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  398.370160][   C74] ==================================================================

When the decryption fully completes in the tasklet, dm-crypt will call
bio_endio(), which in turn will call clone_endio() from dm.c core code. That
function frees the resources associated with the bio, including per bio private
structures. For dm-crypt it will free the current struct dm_crypt_io, which
contains our tasklet object, causing use-after-free, when the tasklet is being
dequeued by the kernel.

To avoid this, do not call bio_endio() from the current tasklet context, but
delay its execution to the dm-crypt IO workqueue.

Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd workqueues")
Cc: <stable@vger.kernel.org> # v5.9+
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
---
 drivers/md/dm-crypt.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 53791138d78b..90f109d8a4a7 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1691,6 +1691,12 @@ static void crypt_inc_pending(struct dm_crypt_io *io)
 	atomic_inc(&io->io_pending);
 }
 
+static void kcryptd_io_bio_endio(struct work_struct *work)
+{
+	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
+	bio_endio(io->base_bio);
+}
+
 /*
  * One of the bios was finished. Check for completion of
  * the whole request and correctly clean up the buffer.
@@ -1713,7 +1719,23 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 		kfree(io->integrity_metadata);
 
 	base_bio->bi_status = error;
-	bio_endio(base_bio);
+
+	/*
+	 * If we are running this function from our tasklet,
+	 * we can't call bio_endio() here, because it will call
+	 * clone_endio() from dm.c, which in turn will
+	 * free the current struct dm_crypt_io structure with
+	 * our tasklet. In this case we need to delay bio_endio()
+	 * execution to after the tasklet is done and dequeued.
+	 */
+	if (tasklet_trylock(&io->tasklet)) {
+		tasklet_unlock(&io->tasklet);
+		bio_endio(base_bio);
+		return;
+	}
+
+	INIT_WORK(&io->work, kcryptd_io_bio_endio);
+	queue_work(cc->io_queue, &io->work);
 }
 
 /*
-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

