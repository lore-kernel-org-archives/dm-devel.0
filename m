Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E0A0C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 06:28:51 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-1oEk2Rb5OdeuYZYvdjMyDQ-1; Thu, 27 Jan 2022 01:28:46 -0500
X-MC-Unique: 1oEk2Rb5OdeuYZYvdjMyDQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AAC9100D680;
	Thu, 27 Jan 2022 06:28:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BB794DC3B;
	Thu, 27 Jan 2022 06:28:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A84294BB7C;
	Thu, 27 Jan 2022 06:28:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20QJMhT6019646 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 26 Jan 2022 14:22:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C2612492D52; Wed, 26 Jan 2022 19:22:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE79A492D4E
	for <dm-devel@redhat.com>; Wed, 26 Jan 2022 19:22:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A41E4811E76
	for <dm-devel@redhat.com>; Wed, 26 Jan 2022 19:22:43 +0000 (UTC)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
	[209.85.219.202]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-651-LfRtmXaWM4yLryj5DQ-K-g-1; Wed, 26 Jan 2022 14:22:42 -0500
X-MC-Unique: LfRtmXaWM4yLryj5DQ-K-g-1
Received: by mail-yb1-f202.google.com with SMTP id
	f12-20020a056902038c00b006116df1190aso1058525ybs.20
	for <dm-devel@redhat.com>; Wed, 26 Jan 2022 11:22:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:in-reply-to:message-id:mime-version
	:references:subject:from:to:cc;
	bh=04sdxbg1x/YeFMRyv9AOCI2xeg6o05KS69MbBAG7QGY=;
	b=bm6n2vFyNmJFjzZU0RSFrHXJRrxDCCVyT1UhWOrXp0QBzkCXbDVLWP5I5SaFGf9Dp4
	YGXgAxGe7yCYjfnxw51edzzHUDFUZlT8ZBof4DY6sI1snr7AgbrpnemNxcDWoDoAZ9W7
	ZRSVpgLKwDqBNVsx3FQj7O+RIRfc/nEsSsVXzv677rqbnjgWf1RQy0iXy2uUl2PFeZXi
	j4PVKZaz3EGKReiXczLKvzp5fieIceLBrE35a74LJUZ8Y3NnELk/zAfDn6slT/L4isqW
	XgFMiFEsP/gZkjZNF6uTcJGZhln+6r6YBbcjzUG8sGmIaygVzTk8l+s9LoNUEbV5vaP9
	q0jg==
X-Gm-Message-State: AOAM533vwz7q7X8Nxw18YR18zscWMyloY5BGMVFlz5K2vX9GKBPBwcRl
	UQARn6j5bJWsWmkQpbir4V8HFz71JsAV
X-Google-Smtp-Source: ABdhPJxnjNIaE09+bgW4aCFWhJbPq7xplPCN0QUq8CKCWlEHAusq4H3cU/VZpfyMHbNlaFIqdSTz5B6bn1Yu
X-Received: from bg.sfo.corp.google.com
	([2620:15c:11a:202:4711:719d:26c1:9f8f])
	(user=bgeffon job=sendgmr) by 2002:a25:6fc4:: with SMTP id
	k187mr480151ybc.709.1643224961441; Wed, 26 Jan 2022 11:22:41 -0800 (PST)
Date: Wed, 26 Jan 2022 11:22:34 -0800
In-Reply-To: <20220125002025.GA21887@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
Message-Id: <20220126192234.572058-1-bgeffon@google.com>
Mime-Version: 1.0
References: <20220125002025.GA21887@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 27 Jan 2022 01:28:33 -0500
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Brian Geffon <bgeffon@google.com>
Subject: [dm-devel] [PATCH] dm: introduce a DM_ENFORCE_OPEN_COUNT flag.
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This change introduces a new flag which can be used with
DM_DEV_CREATE to establish the maximum open count allowed
for a device. When this flag is set on DM_DEV_CREATE the
open_count on dm_ioctl will be intrpreted as an input
parameter. This value must be >= 1 or DM_DEV_CREATE will
return -ERANGE.

When this flag is set when the open count is equal to
the max open count any future opens will result in an
-EBUSY.

Signed-off-by: Brian Geffon <bgeffon@google.com>
---
 drivers/md/dm-core.h          |  2 ++
 drivers/md/dm-ioctl.c         | 13 ++++++++++++
 drivers/md/dm.c               | 39 ++++++++++++++++++++++++++++++++---
 drivers/md/dm.h               |  7 +++++++
 include/uapi/linux/dm-ioctl.h |  9 +++++++-
 5 files changed, 66 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 55dccdfbcb22..57922a80026e 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -57,6 +57,7 @@ struct mapped_device {
 
 	atomic_t holders;
 	atomic_t open_count;
+	int max_open_count;
 
 	struct dm_target *immutable_target;
 	struct target_type *immutable_target_type;
@@ -139,6 +140,7 @@ struct mapped_device {
 #define DMF_SUSPENDED_INTERNALLY 7
 #define DMF_POST_SUSPENDING 8
 #define DMF_EMULATE_ZONE_APPEND 9
+#define DMF_ENFORCE_OPEN_COUNT 10
 
 void disable_discard(struct mapped_device *md);
 void disable_write_same(struct mapped_device *md);
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 21fe8652b095..8ddf3ab99ef6 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -814,6 +814,9 @@ static void __dev_status(struct mapped_device *md, struct dm_ioctl *param)
 	if (dm_test_deferred_remove_flag(md))
 		param->flags |= DM_DEFERRED_REMOVE;
 
+	if (dm_test_enforce_open_count_flag(md))
+		param->flags |= DM_ENFORCE_OPEN_COUNT_FLAG;
+
 	param->dev = huge_encode_dev(disk_devt(disk));
 
 	/*
@@ -866,6 +869,16 @@ static int dev_create(struct file *filp, struct dm_ioctl *param, size_t param_si
 	if (r)
 		return r;
 
+	if (param->flags & DM_ENFORCE_OPEN_COUNT_FLAG) {
+		if (param->open_count < 1) {
+			dm_put(md);
+			dm_destroy(md);
+			return -ERANGE;
+		}
+
+		dm_set_max_open_count(md, param->open_count);
+	}
+
 	r = dm_hash_insert(param->name, *param->uuid ? param->uuid : NULL, md);
 	if (r) {
 		dm_put(md);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 76d9da49fda7..718bc9fce7c1 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -307,6 +307,7 @@ int dm_deleting_md(struct mapped_device *md)
 static int dm_blk_open(struct block_device *bdev, fmode_t mode)
 {
 	struct mapped_device *md;
+	int ret = -ENXIO;
 
 	spin_lock(&_minor_lock);
 
@@ -316,16 +317,28 @@ static int dm_blk_open(struct block_device *bdev, fmode_t mode)
 
 	if (test_bit(DMF_FREEING, &md->flags) ||
 	    dm_deleting_md(md)) {
-		md = NULL;
 		goto out;
 	}
 
 	dm_get(md);
+
+	if (test_bit(DMF_ENFORCE_OPEN_COUNT, &md->flags)) {
+		/*
+		 * No opens or closes can happen in parallel as both
+		 * paths hold the _minor_lock.
+		 */
+		if (atomic_read(&md->open_count) + 1 > md->max_open_count) {
+			dm_put(md);
+			ret = -EBUSY;
+			goto out;
+		}
+	}
+
 	atomic_inc(&md->open_count);
+	ret = 0;
 out:
 	spin_unlock(&_minor_lock);
-
-	return md ? 0 : -ENXIO;
+	return ret;
 }
 
 static void dm_blk_close(struct gendisk *disk, fmode_t mode)
@@ -2219,6 +2232,21 @@ void dm_put(struct mapped_device *md)
 }
 EXPORT_SYMBOL_GPL(dm_put);
 
+/*
+ * dm_set_max_open count can only be called when the device is created,
+ * it cannot be changed once set.
+ */
+void dm_set_max_open_count(struct mapped_device *md, int count)
+{
+	/*
+	 * The max open count cannot be changed
+	 */
+	BUG_ON(test_bit(DMF_ENFORCE_OPEN_COUNT, &md->flags));
+
+	set_bit(DMF_ENFORCE_OPEN_COUNT, &md->flags);
+	md->max_open_count = count;
+}
+
 static bool md_in_flight_bios(struct mapped_device *md)
 {
 	int cpu;
@@ -2795,6 +2823,11 @@ int dm_test_deferred_remove_flag(struct mapped_device *md)
 	return test_bit(DMF_DEFERRED_REMOVE, &md->flags);
 }
 
+int dm_test_enforce_open_count_flag(struct mapped_device *md)
+{
+	return test_bit(DMF_ENFORCE_OPEN_COUNT, &md->flags);
+}
+
 int dm_suspended(struct dm_target *ti)
 {
 	return dm_suspended_md(ti->table->md);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 742d9c80efe1..82f56a066b83 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -84,6 +84,8 @@ void dm_set_md_type(struct mapped_device *md, enum dm_queue_mode type);
 enum dm_queue_mode dm_get_md_type(struct mapped_device *md);
 struct target_type *dm_get_immutable_target_type(struct mapped_device *md);
 
+void dm_set_max_open_count(struct mapped_device *md, int count);
+
 int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
 
 /*
@@ -162,6 +164,11 @@ void dm_internal_resume(struct mapped_device *md);
  */
 int dm_test_deferred_remove_flag(struct mapped_device *md);
 
+/*
+ * Test if the device is enforcing an open count.
+ */
+int dm_test_enforce_open_count_flag(struct mapped_device *md);
+
 /*
  * Try to remove devices marked for deferred removal.
  */
diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index c12ce30b52df..9da3700c0442 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -123,7 +123,7 @@ struct dm_ioctl {
 				 * relative to start of this struct */
 
 	__u32 target_count;	/* in/out */
-	__s32 open_count;	/* out */
+	__s32 open_count;	/* in/out, in on DM_DEV_CREATE only */
 	__u32 flags;		/* in/out */
 
 	/*
@@ -382,4 +382,11 @@ enum {
  */
 #define DM_IMA_MEASUREMENT_FLAG	(1 << 19) /* In */
 
+/*
+ * If set with DM_DEV_CREATE then the open_count on device creation
+ * will be set as the maximum concurrent opens allowed on the device.
+ * Once the open_count has been hit any new opens will result in
+ * -EBUSY until other users close the device.
+ */
+#define DM_ENFORCE_OPEN_COUNT_FLAG	 (1 << 20) /* In/Out */
 #endif				/* _LINUX_DM_IOCTL_H */
-- 
2.35.0.rc0.227.g00780c9af4-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

