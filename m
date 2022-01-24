Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44B43C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 25 Jan 2022 06:16:08 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-6vB-l9r4M224TBkcEdj0NA-1; Tue, 25 Jan 2022 01:16:03 -0500
X-MC-Unique: 6vB-l9r4M224TBkcEdj0NA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8065B1083F7E;
	Tue, 25 Jan 2022 06:15:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6123D108C9;
	Tue, 25 Jan 2022 06:15:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B0ECC4CA93;
	Tue, 25 Jan 2022 06:15:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20OF2MUN017132 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 24 Jan 2022 10:02:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9C7F7C202CB; Mon, 24 Jan 2022 15:02:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 98B39C202CA
	for <dm-devel@redhat.com>; Mon, 24 Jan 2022 15:02:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79FD6857BFC
	for <dm-devel@redhat.com>; Mon, 24 Jan 2022 15:02:22 +0000 (UTC)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
	[209.85.219.202]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-496-u_1FGd-RP7W1AZBaiILiaQ-1; Mon, 24 Jan 2022 10:02:19 -0500
X-MC-Unique: u_1FGd-RP7W1AZBaiILiaQ-1
Received: by mail-yb1-f202.google.com with SMTP id
	127-20020a250f85000000b00611ab6484abso35150548ybp.23
	for <dm-devel@redhat.com>; Mon, 24 Jan 2022 07:02:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
	bh=P9O4S8d3oVVuE/vD4lm4oLLN+5OcE1ItgKs9PC2D6EQ=;
	b=AfJ5ZEL0T1BwMfG+rJiOK5Q0CwLT+prkFZ+0XfHAPZSDgJej/R4/e0jAryMDXKKWXG
	i+ZSaRFyXexXMWM57jQ+e9dkzlYMmVzkJAda6/fGQKKdQNb5CDAQqd17JX3kjh57as3X
	fqVu56ApeGHybXBct3e1TXvY7tdA4ecBUuMdD3P0+iGUkQBmgiC+Pf9jlAxbeVWLRjA8
	C3Z1VKFUYraIf56/l7pTtNC5quNvjburtxK6tDjdQrnbY4uNOM65CG1uX/PFTQ/6YyQ9
	0MX9jdG2FW3qbKkdNAECBtw8iaq/eVxSRP6J4tLNV3Otwncmb13/DUA2wTzU0pQtoaxw
	CjYQ==
X-Gm-Message-State: AOAM533Zci08m8ulyy8cuZPwUzD2zHJTtVw0s2NWEBMwc3T+bTSMRXnd
	bMzPOFnECPebFOS1t2TrTJuD2R1DgWOD
X-Google-Smtp-Source: ABdhPJxEDxMzU3Yk4N5L5onA4XuAOtA/Fbwxz6Je+TTJqD3UwlmWmOg3jITYTUdrlKYe14tuDKOK/3SDtfDw
X-Received: from bg.sfo.corp.google.com ([2620:15c:11a:202:9491:3e69:9a74:1f3])
	(user=bgeffon job=sendgmr) by 2002:a25:bb0e:: with SMTP id
	z14mr26156550ybg.762.1643036538880;
	Mon, 24 Jan 2022 07:02:18 -0800 (PST)
Date: Mon, 24 Jan 2022 07:02:09 -0800
Message-Id: <20220124150209.22202-1-bgeffon@google.com>
Mime-Version: 1.0
From: Brian Geffon <bgeffon@google.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 25 Jan 2022 01:15:54 -0500
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Brian Geffon <bgeffon@google.com>
Subject: [dm-devel] [PATCH] dm: introduce a no open flag for deferred remove
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When a device is being removed with deferred remove it's
still possible to open and use the device. This change
introduces a flag called DM_DEFERRED_REMOVE_NO_OPEN_FLAG
which when used with DM_DEFERRED_REMOVE will cause any
new opens to fail with -ENXIO.

If this flag is used without DM_DEFERRED_REMOVE it will
result in an -EINVAL.

Signed-off-by: Brian Geffon <bgeffon@google.com>
---
 drivers/md/dm-core.h          |  1 +
 drivers/md/dm-ioctl.c         | 39 +++++++++++++++++++++++++++--------
 drivers/md/dm.c               | 21 ++++++++++++++++---
 drivers/md/dm.h               |  9 +++++++-
 include/uapi/linux/dm-ioctl.h | 12 +++++++++--
 5 files changed, 67 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index b855fef4f38a..b30e59deb4a8 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -139,6 +139,7 @@ struct mapped_device {
 #define DMF_SUSPENDED_INTERNALLY 7
 #define DMF_POST_SUSPENDING 8
 #define DMF_EMULATE_ZONE_APPEND 9
+#define DMF_DEFERRED_REMOVE_NO_OPEN 10
 
 void disable_discard(struct mapped_device *md);
 void disable_write_same(struct mapped_device *md);
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 21fe8652b095..07bb679880de 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -60,7 +60,8 @@ struct vers_iter {
 static struct rb_root name_rb_tree = RB_ROOT;
 static struct rb_root uuid_rb_tree = RB_ROOT;
 
-static void dm_hash_remove_all(bool keep_open_devices, bool mark_deferred, bool only_deferred);
+static void dm_hash_remove_all(bool keep_open_devices, bool mark_deferred,
+		bool deferred_no_open, bool only_deferred);
 
 /*
  * Guards access to both hash tables.
@@ -74,7 +75,7 @@ static DEFINE_MUTEX(dm_hash_cells_mutex);
 
 static void dm_hash_exit(void)
 {
-	dm_hash_remove_all(false, false, false);
+	dm_hash_remove_all(false, false, false, false);
 }
 
 /*-----------------------------------------------------------------
@@ -315,7 +316,8 @@ static struct dm_table *__hash_remove(struct hash_cell *hc)
 	return table;
 }
 
-static void dm_hash_remove_all(bool keep_open_devices, bool mark_deferred, bool only_deferred)
+static void dm_hash_remove_all(bool keep_open_devices, bool mark_deferred,
+		bool deferred_no_open, bool only_deferred)
 {
 	int dev_skipped;
 	struct rb_node *n;
@@ -334,7 +336,8 @@ static void dm_hash_remove_all(bool keep_open_devices, bool mark_deferred, bool
 		dm_get(md);
 
 		if (keep_open_devices &&
-		    dm_lock_for_deletion(md, mark_deferred, only_deferred)) {
+		    dm_lock_for_deletion(md, mark_deferred, deferred_no_open,
+				    only_deferred)) {
 			dm_put(md);
 			dev_skipped++;
 			continue;
@@ -496,7 +499,7 @@ static struct mapped_device *dm_hash_rename(struct dm_ioctl *param,
 
 void dm_deferred_remove(void)
 {
-	dm_hash_remove_all(true, false, true);
+	dm_hash_remove_all(true, false, false, true);
 }
 
 /*-----------------------------------------------------------------
@@ -510,7 +513,13 @@ typedef int (*ioctl_fn)(struct file *filp, struct dm_ioctl *param, size_t param_
 
 static int remove_all(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
-	dm_hash_remove_all(true, !!(param->flags & DM_DEFERRED_REMOVE), false);
+	if (param->flags & DM_DEFERRED_REMOVE_NO_OPEN_FLAG &&
+			!(param->flags & DM_DEFERRED_REMOVE)) {
+		return -EINVAL;
+	}
+
+	dm_hash_remove_all(true, !!(param->flags & DM_DEFERRED_REMOVE),
+			!!(param->flags & DM_DEFERRED_REMOVE_NO_OPEN_FLAG), false);
 	param->data_size = 0;
 	return 0;
 }
@@ -811,9 +820,13 @@ static void __dev_status(struct mapped_device *md, struct dm_ioctl *param)
 	if (dm_suspended_internally_md(md))
 		param->flags |= DM_INTERNAL_SUSPEND_FLAG;
 
-	if (dm_test_deferred_remove_flag(md))
+	if (dm_test_deferred_remove_flag(md)) {
 		param->flags |= DM_DEFERRED_REMOVE;
 
+		if (dm_test_deferred_remove_no_open_flag(md))
+			param->flags |= DM_DEFERRED_REMOVE_NO_OPEN_FLAG;
+	}
+
 	param->dev = huge_encode_dev(disk_devt(disk));
 
 	/*
@@ -960,10 +973,18 @@ static int dev_remove(struct file *filp, struct dm_ioctl *param, size_t param_si
 
 	md = hc->md;
 
+	if (param->flags & DM_DEFERRED_REMOVE_NO_OPEN_FLAG &&
+			!(param->flags & DM_DEFERRED_REMOVE)) {
+		up_write(&_hash_lock);
+		dm_put(md);
+		return -EINVAL;
+	}
+
 	/*
 	 * Ensure the device is not open and nothing further can open it.
 	 */
-	r = dm_lock_for_deletion(md, !!(param->flags & DM_DEFERRED_REMOVE), false);
+	r = dm_lock_for_deletion(md, !!(param->flags & DM_DEFERRED_REMOVE),
+			!!(param->flags & DM_DEFERRED_REMOVE_NO_OPEN_FLAG), false);
 	if (r) {
 		if (r == -EBUSY && param->flags & DM_DEFERRED_REMOVE) {
 			up_write(&_hash_lock);
@@ -984,7 +1005,7 @@ static int dev_remove(struct file *filp, struct dm_ioctl *param, size_t param_si
 		dm_table_destroy(t);
 	}
 
-	param->flags &= ~DM_DEFERRED_REMOVE;
+	param->flags &= ~(DM_DEFERRED_REMOVE | DM_DEFERRED_REMOVE_NO_OPEN_FLAG);
 
 	dm_ima_measure_on_device_remove(md, false);
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c0ae8087c602..90b74043e162 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -315,7 +315,10 @@ static int dm_blk_open(struct block_device *bdev, fmode_t mode)
 		goto out;
 
 	if (test_bit(DMF_FREEING, &md->flags) ||
+	    test_bit(DMF_DEFERRED_REMOVE_NO_OPEN, &md->flags) ||
 	    dm_deleting_md(md)) {
+		BUG_ON(test_bit(DMF_DEFERRED_REMOVE_NO_OPEN, &md->flags) &&
+		       !test_bit(DMF_DEFERRED_REMOVE, &md->flags));
 		md = NULL;
 		goto out;
 	}
@@ -355,7 +358,8 @@ int dm_open_count(struct mapped_device *md)
 /*
  * Guarantees nothing is using the device before it's deleted.
  */
-int dm_lock_for_deletion(struct mapped_device *md, bool mark_deferred, bool only_deferred)
+int dm_lock_for_deletion(struct mapped_device *md, bool mark_deferred,
+		bool deferred_no_open, bool only_deferred)
 {
 	int r = 0;
 
@@ -363,8 +367,12 @@ int dm_lock_for_deletion(struct mapped_device *md, bool mark_deferred, bool only
 
 	if (dm_open_count(md)) {
 		r = -EBUSY;
-		if (mark_deferred)
+		if (mark_deferred) {
 			set_bit(DMF_DEFERRED_REMOVE, &md->flags);
+
+			if (deferred_no_open)
+				set_bit(DMF_DEFERRED_REMOVE_NO_OPEN, &md->flags);
+		}
 	} else if (only_deferred && !test_bit(DMF_DEFERRED_REMOVE, &md->flags))
 		r = -EEXIST;
 	else
@@ -383,8 +391,10 @@ int dm_cancel_deferred_remove(struct mapped_device *md)
 
 	if (test_bit(DMF_DELETING, &md->flags))
 		r = -EBUSY;
-	else
+	else {
 		clear_bit(DMF_DEFERRED_REMOVE, &md->flags);
+		clear_bit(DMF_DEFERRED_REMOVE_NO_OPEN, &md->flags);
+	}
 
 	spin_unlock(&_minor_lock);
 
@@ -2718,6 +2728,11 @@ int dm_test_deferred_remove_flag(struct mapped_device *md)
 	return test_bit(DMF_DEFERRED_REMOVE, &md->flags);
 }
 
+int dm_test_deferred_remove_no_open_flag(struct mapped_device *md)
+{
+	return test_bit(DMF_DEFERRED_REMOVE_NO_OPEN, &md->flags);
+}
+
 int dm_suspended(struct dm_target *ti)
 {
 	return dm_suspended_md(ti->table->md);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 9013dc1a7b00..8d0d4344f882 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -158,6 +158,12 @@ void dm_internal_resume(struct mapped_device *md);
  */
 int dm_test_deferred_remove_flag(struct mapped_device *md);
 
+/*
+ * Test if the device is scheduled for deferred remove while
+ * disallowing opens.
+ */
+int dm_test_deferred_remove_no_open_flag(struct mapped_device *md);
+
 /*
  * Try to remove devices marked for deferred removal.
  */
@@ -198,7 +204,8 @@ void dm_stripe_exit(void);
 void dm_destroy(struct mapped_device *md);
 void dm_destroy_immediate(struct mapped_device *md);
 int dm_open_count(struct mapped_device *md);
-int dm_lock_for_deletion(struct mapped_device *md, bool mark_deferred, bool only_deferred);
+int dm_lock_for_deletion(struct mapped_device *md, bool mark_deferred,
+			 bool deferred_no_open, bool only_deferred);
 int dm_cancel_deferred_remove(struct mapped_device *md);
 int dm_request_based(struct mapped_device *md);
 int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index c12ce30b52df..c0fee607b827 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -286,9 +286,9 @@ enum {
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	45
+#define DM_VERSION_MINOR	46
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2021-03-22)"
+#define DM_VERSION_EXTRA	"-ioctl (2022-01-21)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
@@ -382,4 +382,12 @@ enum {
  */
 #define DM_IMA_MEASUREMENT_FLAG	(1 << 19) /* In */
 
+/* If set with DF_DEFERRED_REMOVE if an immediate remove is not
+ * possible because the device is still open any new additional
+ * opens will also be rejected.
+ *
+ * It is an error to specify this flag without DM_DEFERRED_REMOVE.
+ */
+#define DM_DEFERRED_REMOVE_NO_OPEN_FLAG	(1 << 20) /* In/Out */
+
 #endif				/* _LINUX_DM_IOCTL_H */
-- 
2.35.0.rc0.227.g00780c9af4-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

