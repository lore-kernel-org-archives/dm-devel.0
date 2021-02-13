Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D5BC433E0
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:39:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0D66E64DA1
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:39:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D66E64DA1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-MN7NKLboNHi4DJWFbzM5Rg-1; Wed, 17 Feb 2021 10:39:32 -0500
X-MC-Unique: MN7NKLboNHi4DJWFbzM5Rg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52C0F107ACC7;
	Wed, 17 Feb 2021 15:39:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 33C045D9C2;
	Wed, 17 Feb 2021 15:39:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E781958078;
	Wed, 17 Feb 2021 15:39:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11D0oOP6024230 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Feb 2021 19:50:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 592E72026D16; Sat, 13 Feb 2021 00:50:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 53EDF2026D14
	for <dm-devel@redhat.com>; Sat, 13 Feb 2021 00:50:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B408A811E88
	for <dm-devel@redhat.com>; Sat, 13 Feb 2021 00:50:21 +0000 (UTC)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com
	[209.85.208.44]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-574-YrahDaqxNY2Wr_EvQG-qlw-1; Fri, 12 Feb 2021 19:50:19 -0500
X-MC-Unique: YrahDaqxNY2Wr_EvQG-qlw-1
Received: by mail-ed1-f44.google.com with SMTP id s11so1869692edd.5
	for <dm-devel@redhat.com>; Fri, 12 Feb 2021 16:50:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id;
	bh=Vjj9qYSvQfQbP8LLjapg+ws1IefrfhkmMhOgFWMI9Dc=;
	b=nodKsSPB46FmbslHX8gbL4zdjDdbgJZ9rYJpVeOE5pCziAhbUug82CgIVrzW8t0ej1
	zLkvTKUuCjow9Qikh4NLFv8H3rOvLRKTHl6RlrtD8RWFTLY01MpclYmdT5OumTSHW/ZJ
	gd67/kUcmNaHSLi4C3m0Enm7Yjeoc2eXuR7upuVsC4CabOJLGhmfrjy4ub4AavOzaXXu
	UpqJ9wp7540rWz2Fxcbns9ijCMt8elQ5e3Y+g3+l+Qz0o6M/BVd1vxT7/GIvBDUvwZG4
	Lxf2dHv7HqTht2D2PsJBRiCV/ww6yJ4DE1+8+FmTx23ON6mX1UFiLmniNfI4w2OcmEQG
	ogIQ==
X-Gm-Message-State: AOAM530oDpV8rdZOrjMvBOUsx2pRNemSRT93kSVuEvnzNwUadNlXq3n5
	yot0RyjKkHb45uGyLG0SSCXfgQ==
X-Google-Smtp-Source: ABdhPJwUUaMKuOdiJtXAePFBpMkAkKWzwNC9+NnwNOWYpuQaM5sgSKzXETgpdcKfunQ5LYMJm75ilQ==
X-Received: by 2002:aa7:ce13:: with SMTP id d19mr6123370edv.208.1613177418112; 
	Fri, 12 Feb 2021 16:50:18 -0800 (PST)
Received: from gqjiang-home.profitbricks.net
	([240e:304:2c81:30a4:4403:7938:f6d4:38b1])
	by smtp.gmail.com with ESMTPSA id q10sm393817edr.51.2021.02.12.16.50.12
	(version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
	Fri, 12 Feb 2021 16:50:17 -0800 (PST)
From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
To: song@kernel.org
Date: Sat, 13 Feb 2021 01:49:59 +0100
Message-Id: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
	dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com
Subject: [dm-devel] [PATCH V2] md: don't unregister sync_thread with
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Unregister sync_thread doesn't need to hold reconfig_mutex since it
doesn't reconfigure array.

And it could cause deadlock problem for raid5 as follows:

1. process A tried to reap sync thread with reconfig_mutex held after echo
   idle to sync_action.
2. raid5 sync thread was blocked if there were too many active stripes.
3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
   which causes the number of active stripes can't be decreased.
4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
   to hold reconfig_mutex.

More details in the link:
https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t

And add one parameter to md_reap_sync_thread since it could be called by
dm-raid which doesn't hold reconfig_mutex.

Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
V2:
1. add one parameter to md_reap_sync_thread per Jack's suggestion.

 drivers/md/dm-raid.c |  2 +-
 drivers/md/md.c      | 14 +++++++++-----
 drivers/md/md.h      |  2 +-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index cab12b2..0c4cbba 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3668,7 +3668,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
 	if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
 		if (mddev->sync_thread) {
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			md_reap_sync_thread(mddev);
+			md_reap_sync_thread(mddev, false);
 		}
 	} else if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
 		return -EBUSY;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ca40942..0c12b7f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4857,7 +4857,7 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 				flush_workqueue(md_misc_wq);
 			if (mddev->sync_thread) {
 				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-				md_reap_sync_thread(mddev);
+				md_reap_sync_thread(mddev, true);
 			}
 			mddev_unlock(mddev);
 		}
@@ -6234,7 +6234,7 @@ static void __md_stop_writes(struct mddev *mddev)
 		flush_workqueue(md_misc_wq);
 	if (mddev->sync_thread) {
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-		md_reap_sync_thread(mddev);
+		md_reap_sync_thread(mddev, true);
 	}
 
 	del_timer_sync(&mddev->safemode_timer);
@@ -9256,7 +9256,7 @@ void md_check_recovery(struct mddev *mddev)
 			 * ->spare_active and clear saved_raid_disk
 			 */
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			md_reap_sync_thread(mddev);
+			md_reap_sync_thread(mddev, true);
 			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			clear_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
@@ -9291,7 +9291,7 @@ void md_check_recovery(struct mddev *mddev)
 			goto unlock;
 		}
 		if (mddev->sync_thread) {
-			md_reap_sync_thread(mddev);
+			md_reap_sync_thread(mddev, true);
 			goto unlock;
 		}
 		/* Set RUNNING before clearing NEEDED to avoid
@@ -9364,14 +9364,18 @@ void md_check_recovery(struct mddev *mddev)
 }
 EXPORT_SYMBOL(md_check_recovery);
 
-void md_reap_sync_thread(struct mddev *mddev)
+void md_reap_sync_thread(struct mddev *mddev, bool reconfig_mutex_held)
 {
 	struct md_rdev *rdev;
 	sector_t old_dev_sectors = mddev->dev_sectors;
 	bool is_reshaped = false;
 
 	/* resync has finished, collect result */
+	if (reconfig_mutex_held)
+		mddev_unlock(mddev);
 	md_unregister_thread(&mddev->sync_thread);
+	if (reconfig_mutex_held)
+		mddev_lock_nointr(mddev);
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
 	    mddev->degraded != mddev->raid_disks) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 34070ab..7ae3d98 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -705,7 +705,7 @@ extern struct md_thread *md_register_thread(
 extern void md_unregister_thread(struct md_thread **threadp);
 extern void md_wakeup_thread(struct md_thread *thread);
 extern void md_check_recovery(struct mddev *mddev);
-extern void md_reap_sync_thread(struct mddev *mddev);
+extern void md_reap_sync_thread(struct mddev *mddev, bool reconfig_mutex_held);
 extern int mddev_init_writes_pending(struct mddev *mddev);
 extern bool md_write_start(struct mddev *mddev, struct bio *bi);
 extern void md_write_inc(struct mddev *mddev, struct bio *bi);
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

