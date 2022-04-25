Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 363ECC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 25 Apr 2022 08:28:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-472-uCS6YuBpP7mN4lVH5pRu0A-1; Mon, 25 Apr 2022 04:28:54 -0400
X-MC-Unique: uCS6YuBpP7mN4lVH5pRu0A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E441E800882;
	Mon, 25 Apr 2022 08:28:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 153C2C52D68;
	Mon, 25 Apr 2022 08:28:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D6B221947BBE;
	Mon, 25 Apr 2022 08:28:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C08261947BBD
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Apr 2022 08:28:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AF7E89E75; Mon, 25 Apr 2022 08:28:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AA7207AF9
 for <dm-devel@redhat.com>; Mon, 25 Apr 2022 08:28:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C34A9800882
 for <dm-devel@redhat.com>; Mon, 25 Apr 2022 08:28:44 +0000 (UTC)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-AvHIH4blO6Wuiie5N-DS6Q-1; Mon, 25 Apr 2022 04:28:43 -0400
X-MC-Unique: AvHIH4blO6Wuiie5N-DS6Q-1
Received: by mail-pg1-f201.google.com with SMTP id
 o5-20020a639205000000b003ab492e038dso1307018pgd.12
 for <dm-devel@redhat.com>; Mon, 25 Apr 2022 01:28:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=L/g0bvSDwPnuo+OUPLoiHehwSXqnnWuBcck3d5mIN9M=;
 b=vopWMiLl1y0QX7DXd8DTdee3gAVDtP4m6Qms0BdaAh/9Mj+SF+rs1OiW8DcRjukubK
 w2rhdQZPDWHqlgyXZxjgmEZQDuNuVVipSYVVhY9/MfvRJpQX/vdLlyhNkZxzUV1se2l6
 IHe7cofdNzDPJdL40k3elSYaGQ9YCxQjc6T8rtKazn9V9ZbaakPEuseD3dHNlBAvqJQ+
 k2chrVd4PrKa/QZgo5wWQq7Yjc2zkr9HAbJGSBJ1rjd5ZpCr++10YTdd6rLSUhas05uR
 +bO5KjYo66TfFRBs2VoWGxS4BlIXLUkZsjeQOODI2csX4eKxvw/tRcFa0vbzrBEBF7+b
 ZEmQ==
X-Gm-Message-State: AOAM531kPTycMazgJX5pLYXSyMIB/qgafoOzgWpwboc+GUKAmIoqghDW
 nxfT2nzxjBi16nO66eVrehnjPTICkMOdsA==
X-Google-Smtp-Source: ABdhPJyKgd+B7+akN68eNfEFu0f3pvv3Z+LsqgdmFH8KOvoxR3ca0S+m9ezFTKUSUtq6v9lB4HUsrAun1Ogpng==
X-Received: from akailash.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1e6])
 (user=akailash job=sendgmr) by 2002:a17:90a:9105:b0:1d2:9e98:7e1e with SMTP
 id k5-20020a17090a910500b001d29e987e1emr1365096pjo.0.1650875321248; Mon, 25
 Apr 2022 01:28:41 -0700 (PDT)
Date: Mon, 25 Apr 2022 08:28:12 +0000
Message-Id: <20220425082812.780445-1-akailash@google.com>
Mime-Version: 1.0
From: Akilesh Kailash <akailash@google.com>
To: stable@vger.kernel.org
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH] dm: fix mempool NULL pointer race when
 completing IO
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
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
 dm-devel@redhat.com, Jiazi Li <jqqlijiazi@gmail.com>,
 Jiazi Li <lijiazi@xiaomi.com>, akailash@google.com, kernel-team@android.com,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Jiazi Li <jqqlijiazi@gmail.com>

commit d208b89401e073de986dc891037c5a668f5d5d95 upstream.

This is a backport of the upstream patch to 5.10.y stable branch.

This backport resolves a minor merge-conflict on 5.10.y stable branch.

dm_io_dec_pending() calls end_io_acct() first and will then dec md
in-flight pending count. But if a task is swapping DM table at same
time this can result in a crash due to mempool->elements being NULL:

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

[ 67.330330] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000000
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

Fix this by:
1) Establishing pointers to 'struct dm_io' members in
dm_io_dec_pending() so that they may be passed into end_io_acct()
_after_ free_io() is called.
2) Moving end_io_acct() after free_io().

Link: https://lore.kernel.org/dm-devel/1632916768-22379-1-git-send-email-lijiazi@xiaomi.com/T/#u
Cc: stable@vger.kernel.org
Signed-off-by: Jiazi Li <lijiazi@xiaomi.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Akilesh Kailash <akailash@google.com>
---
 drivers/md/dm.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2836d44094ab..b3d8d9e0e6f6 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -607,18 +607,17 @@ static void start_io_acct(struct dm_io *io)
 				    false, 0, &io->stats_aux);
 }
 
-static void end_io_acct(struct dm_io *io)
+static void end_io_acct(struct mapped_device *md, struct bio *bio,
+			unsigned long start_time, struct dm_stats_aux *stats_aux)
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
@@ -903,6 +902,8 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
 	blk_status_t io_error;
 	struct bio *bio;
 	struct mapped_device *md = io->md;
+	unsigned long start_time = 0;
+	struct dm_stats_aux stats_aux;
 
 	/* Push-back supersedes any I/O errors */
 	if (unlikely(error)) {
@@ -929,8 +930,10 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
 
 		io_error = io->status;
 		bio = io->orig_bio;
-		end_io_acct(io);
+		start_time = io->start_time;
+		stats_aux = io->stats_aux;
 		free_io(md, io);
+		end_io_acct(md, bio, start_time, &stats_aux);
 
 		if (io_error == BLK_STS_DM_REQUEUE)
 			return;
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

