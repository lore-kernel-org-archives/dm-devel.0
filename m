Return-Path: <SRS0=+DI7=OU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72097C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 30 Sep 2021 05:07:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B58A561381
	for <dm-devel@archiver.kernel.org>; Thu, 30 Sep 2021 05:07:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B58A561381
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-iNBVy30nNN6PPoM_c32Kig-1; Thu, 30 Sep 2021 01:06:59 -0400
X-MC-Unique: iNBVy30nNN6PPoM_c32Kig-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF7F01084683;
	Thu, 30 Sep 2021 05:06:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 942DD62465;
	Thu, 30 Sep 2021 05:06:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2D1BF1803B30;
	Thu, 30 Sep 2021 05:06:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18TBxjuX013759 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 29 Sep 2021 07:59:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E5852C77DB; Wed, 29 Sep 2021 11:59:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E04DCBC86
	for <dm-devel@redhat.com>; Wed, 29 Sep 2021 11:59:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 310D71066563
	for <dm-devel@redhat.com>; Wed, 29 Sep 2021 11:59:41 +0000 (UTC)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
	[209.85.216.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-303-rRwKCfSuMH-7h7bXqyYVAw-1; Wed, 29 Sep 2021 07:59:39 -0400
X-MC-Unique: rRwKCfSuMH-7h7bXqyYVAw-1
Received: by mail-pj1-f53.google.com with SMTP id
	il14-20020a17090b164e00b0019c7a7c362dso3820495pjb.0; 
	Wed, 29 Sep 2021 04:59:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id;
	bh=vqMXPrGIwsyV/TUPg2eCtcJ95AHXhCdLhGm9utRjM0Y=;
	b=2c08sORS4jZtHgK0x583IB0YtLEtlwlS6YcWgULh/HloaIDI7WQ5CNwOJp1hGstOVJ
	bWDArunplyVyrjRXwCD/IGA0FGqopKCRp91BE7vr6Y0S/eu6/lOl2Q8Tti4wJardxSQD
	ddH5GG5sMjhZdqjjC3ZzvBGO4yRQppVIq8nd1hbcRyWfiNeg8/0cOTw/ykfZrge9nQ97
	iYnvf1TaypgWk/8rSpdpJ0u0EtNTdEKAnRJjbt/YqQ19cfZcX25Rrvluo7a39abpdAsE
	lumxpO4yiLxx1TRWNAgDT6pGT8uQwXF5Ki4Wl2xEqX9pfdnLVrQVXGT0AYFthFdKAiT1
	x6Gg==
X-Gm-Message-State: AOAM531BS6ez5TnQQsFZ0n+n99WfuYbIG9WnX+lyVfp0WNp1Rwm0Ztv3
	RUiBwLbxwVevpSYbFrV1u162eiW1tDU=
X-Google-Smtp-Source: ABdhPJw5X0W48E2R7LbygWszsPCue9gH/enrOH6dlP+ZCKjZFjiXslc425rvHxOcmXvhHjhB/Vpr0A==
X-Received: by 2002:a17:90b:4f4d:: with SMTP id
	pj13mr6059655pjb.47.1632916777546; 
	Wed, 29 Sep 2021 04:59:37 -0700 (PDT)
Received: from localhost ([43.224.245.179]) by smtp.gmail.com with ESMTPSA id
	t14sm2424546pga.62.2021.09.29.04.59.36
	(version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
	Wed, 29 Sep 2021 04:59:36 -0700 (PDT)
From: Jiazi Li <jqqlijiazi@gmail.com>
X-Google-Original-From: Jiazi Li <lijiazi@xiaomi.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Date: Wed, 29 Sep 2021 19:59:28 +0800
Message-Id: <1632916768-22379-1-git-send-email-lijiazi@xiaomi.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 30 Sep 2021 01:06:48 -0400
Cc: Jiazi Li <lijiazi@xiaomi.com>, dm-devel@redhat.com
Subject: [dm-devel] [PATCH] dm: fix NULL pointer issue when free bio
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm_io_dec_pending call end_io_acct first, will dec md in-flight
pending count. If a task is swapping table at same time.
task1                             task2
do_resume
 ->do_suspend
  ->dm_wait_for_completion
                                  bio_endio
				   ->clone_endio
				    ->dm_io_dec_pending
				     ->end_io_acct
				      ->wakeup task1
 ->dm_swap_table
  ->__bind
   ->__bind_mempools
    ->bioset_exit
     ->mempool_exit
                                     ->free_io
mempool->elements is NULL, and lead to following crash:
[ 67.330330] Unable to handle kernel NULL pointer dereference at virtual
address 0000000000000000
......
[ 67.330494] pstate: 80400085 (Nzcv daIf +PAN -UAO)
[ 67.330510] pc : mempool_free+0x70/0xa0
[ 67.330515] lr : mempool_free+0x4c/0xa0
[ 67.330520] sp : ffffff8008013b20
[ 67.330524] x29: ffffff8008013b20 x28: 0000000000000004
[ 67.330530] x27: ffffffa8c2ff40a0 x26: 00000000ffff1cc8
[ 67.330535] x25: 0000000000000000 x24: ffffffdada34c800
[ 67.330541] x23: 0000000000000000 x22: ffffffdada34c800
[ 67.330547] x21: 00000000ffff1cc8 x20: ffffffd9a1304d80
[ 67.330552] x19: ffffffdada34c970 x18: 000000b312625d9c
[ 67.330558] x17: 00000000002dcfbf x16: 00000000000006dd
[ 67.330563] x15: 000000000093b41e x14: 0000000000000010
[ 67.330569] x13: 0000000000007f7a x12: 0000000034155555
[ 67.330574] x11: 0000000000000001 x10: 0000000000000001
[ 67.330579] x9 : 0000000000000000 x8 : 0000000000000000
[ 67.330585] x7 : 0000000000000000 x6 : ffffff80148b5c1a
[ 67.330590] x5 : ffffff8008013ae0 x4 : 0000000000000001
[ 67.330596] x3 : ffffff80080139c8 x2 : ffffff801083bab8
[ 67.330601] x1 : 0000000000000000 x0 : ffffffdada34c970
[ 67.330609] Call trace:
[ 67.330616] mempool_free+0x70/0xa0
[ 67.330627] bio_put+0xf8/0x110
[ 67.330638] dec_pending+0x13c/0x230
[ 67.330644] clone_endio+0x90/0x180
[ 67.330649] bio_endio+0x198/0x1b8
[ 67.330655] dec_pending+0x190/0x230
[ 67.330660] clone_endio+0x90/0x180
[ 67.330665] bio_endio+0x198/0x1b8
[ 67.330673] blk_update_request+0x214/0x428
[ 67.330683] scsi_end_request+0x2c/0x300
[ 67.330688] scsi_io_completion+0xa0/0x710
[ 67.330695] scsi_finish_command+0xd8/0x110
[ 67.330700] scsi_softirq_done+0x114/0x148
[ 67.330708] blk_done_softirq+0x74/0xd0
[ 67.330716] __do_softirq+0x18c/0x374
[ 67.330724] irq_exit+0xb4/0xb8
[ 67.330732] __handle_domain_irq+0x84/0xc0
[ 67.330737] gic_handle_irq+0x148/0x1b0
[ 67.330744] el1_irq+0xe8/0x190
[ 67.330753] lpm_cpuidle_enter+0x4f8/0x538
[ 67.330759] cpuidle_enter_state+0x1fc/0x398
[ 67.330764] cpuidle_enter+0x18/0x20
[ 67.330772] do_idle+0x1b4/0x290
[ 67.330778] cpu_startup_entry+0x20/0x28
[ 67.330786] secondary_start_kernel+0x160/0x170

Move end_io_acct after free_io to fix this issue.

Signed-off-by: Jiazi Li <lijiazi@xiaomi.com>
---
 drivers/md/dm.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a011d09..245fa41 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -496,18 +496,17 @@ static void start_io_acct(struct dm_io *io)
 				    false, 0, &io->stats_aux);
 }
 
-static void end_io_acct(struct dm_io *io)
+static void end_io_acct(struct mapped_device *md, struct bio *bio,
+		unsigned long start_time, struct dm_stats_aux *stats_aux)
 {
-	struct mapped_device *md = io->md;
-	struct bio *bio = io->orig_bio;
-	unsigned long duration = jiffies - io->start_time;
+	unsigned long duration = jiffies - start_time;
 
-	bio_end_io_acct(bio, io->start_time);
+	bio_end_io_acct(bio, start_time);
 
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
-				    true, duration, &io->stats_aux);
+				    true, duration, stats_aux);
 
 	/* nudge anyone waiting on suspend queue */
 	if (unlikely(wq_has_sleeper(&md->wait)))
@@ -790,6 +789,8 @@ void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
 	blk_status_t io_error;
 	struct bio *bio;
 	struct mapped_device *md = io->md;
+	unsigned long start_time = 0;
+	struct dm_stats_aux stats_aux;
 
 	/* Push-back supersedes any I/O errors */
 	if (unlikely(error)) {
@@ -821,8 +822,10 @@ void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
 		}
 
 		io_error = io->status;
-		end_io_acct(io);
+		start_time = io->start_time;
+		stats_aux = io->stats_aux;
 		free_io(md, io);
+		end_io_acct(md, bio, start_time, &stats_aux);
 
 		if (io_error == BLK_STS_DM_REQUEUE)
 			return;
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

