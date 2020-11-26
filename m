Return-Path: <SRS0=cgFg=FA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8295DC56202
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 13:33:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DDD2521D40
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 13:33:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDD2521D40
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-iuOdhYkOOS-A9SKIH8jzDw-1; Thu, 26 Nov 2020 08:33:55 -0500
X-MC-Unique: iuOdhYkOOS-A9SKIH8jzDw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E6C6100C665;
	Thu, 26 Nov 2020 13:33:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D99B5D6D1;
	Thu, 26 Nov 2020 13:33:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4E4CE1809CA4;
	Thu, 26 Nov 2020 13:33:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AQDXmh1006367 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 26 Nov 2020 08:33:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B00C92166B2A; Thu, 26 Nov 2020 13:33:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB0E32166B27
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 13:33:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 956888007DF
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 13:33:48 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-347-WwMlowNmMPSMgr9k-t9lqQ-1; Thu, 26 Nov 2020 08:33:46 -0500
X-MC-Unique: WwMlowNmMPSMgr9k-t9lqQ-1
Received: from [2001:4bb8:18c:1dd6:27b8:b8a1:c13e:ceb1] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kiGys-0003wR-ME; Thu, 26 Nov 2020 13:06:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu, 26 Nov 2020 14:03:41 +0100
Message-Id: <20201126130422.92945-4-hch@lst.de>
In-Reply-To: <20201126130422.92945-1-hch@lst.de>
References: <20201126130422.92945-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Tejun Heo <tj@kernel.org>
Subject: [dm-devel] [PATCH 03/44] fs: remove get_super_thawed and
	get_super_exclusive_thawed
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

Just open code the wait in the only caller of both functions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 fs/internal.h      |  2 ++
 fs/quota/quota.c   | 31 +++++++++++++++++++++-------
 fs/super.c         | 51 ++--------------------------------------------
 include/linux/fs.h |  4 +---
 4 files changed, 29 insertions(+), 59 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index a7cd0f64faa4ab..47be21dfeebef5 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -114,7 +114,9 @@ extern struct file *alloc_empty_file_noaccount(int, const struct cred *);
  */
 extern int reconfigure_super(struct fs_context *);
 extern bool trylock_super(struct super_block *sb);
+struct super_block *__get_super(struct block_device *bdev, bool excl);
 extern struct super_block *user_get_super(dev_t);
+void put_super(struct super_block *sb);
 extern bool mount_capable(struct fs_context *);
 
 /*
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 9af95c7a0bbe3c..f3d32b0d9008f2 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -20,6 +20,7 @@
 #include <linux/writeback.h>
 #include <linux/nospec.h>
 #include "compat.h"
+#include "../internal.h"
 
 static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
 				     qid_t id)
@@ -868,6 +869,7 @@ static struct super_block *quotactl_block(const char __user *special, int cmd)
 	struct block_device *bdev;
 	struct super_block *sb;
 	struct filename *tmp = getname(special);
+	bool excl = false, thawed = false;
 
 	if (IS_ERR(tmp))
 		return ERR_CAST(tmp);
@@ -875,17 +877,32 @@ static struct super_block *quotactl_block(const char __user *special, int cmd)
 	putname(tmp);
 	if (IS_ERR(bdev))
 		return ERR_CAST(bdev);
-	if (quotactl_cmd_onoff(cmd))
-		sb = get_super_exclusive_thawed(bdev);
-	else if (quotactl_cmd_write(cmd))
-		sb = get_super_thawed(bdev);
-	else
-		sb = get_super(bdev);
+
+	if (quotactl_cmd_onoff(cmd)) {
+		excl = true;
+		thawed = true;
+	} else if (quotactl_cmd_write(cmd)) {
+		thawed = true;
+	}
+
+retry:
+	sb = __get_super(bdev, excl);
+	if (thawed && sb && sb->s_writers.frozen != SB_UNFROZEN) {
+		if (excl)
+			up_write(&sb->s_umount);
+		else
+			up_read(&sb->s_umount);
+		wait_event(sb->s_writers.wait_unfrozen,
+			   sb->s_writers.frozen == SB_UNFROZEN);
+		put_super(sb);
+		goto retry;
+	}
+
 	bdput(bdev);
 	if (!sb)
 		return ERR_PTR(-ENODEV);
-
 	return sb;
+
 #else
 	return ERR_PTR(-ENODEV);
 #endif
diff --git a/fs/super.c b/fs/super.c
index 98bb0629ee108e..343e5c1e538d2a 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -307,7 +307,7 @@ static void __put_super(struct super_block *s)
  *	Drops a temporary reference, frees superblock if there's no
  *	references left.
  */
-static void put_super(struct super_block *sb)
+void put_super(struct super_block *sb)
 {
 	spin_lock(&sb_lock);
 	__put_super(sb);
@@ -740,7 +740,7 @@ void iterate_supers_type(struct file_system_type *type,
 
 EXPORT_SYMBOL(iterate_supers_type);
 
-static struct super_block *__get_super(struct block_device *bdev, bool excl)
+struct super_block *__get_super(struct block_device *bdev, bool excl)
 {
 	struct super_block *sb;
 
@@ -789,53 +789,6 @@ struct super_block *get_super(struct block_device *bdev)
 }
 EXPORT_SYMBOL(get_super);
 
-static struct super_block *__get_super_thawed(struct block_device *bdev,
-					      bool excl)
-{
-	while (1) {
-		struct super_block *s = __get_super(bdev, excl);
-		if (!s || s->s_writers.frozen == SB_UNFROZEN)
-			return s;
-		if (!excl)
-			up_read(&s->s_umount);
-		else
-			up_write(&s->s_umount);
-		wait_event(s->s_writers.wait_unfrozen,
-			   s->s_writers.frozen == SB_UNFROZEN);
-		put_super(s);
-	}
-}
-
-/**
- *	get_super_thawed - get thawed superblock of a device
- *	@bdev: device to get the superblock for
- *
- *	Scans the superblock list and finds the superblock of the file system
- *	mounted on the device. The superblock is returned once it is thawed
- *	(or immediately if it was not frozen). %NULL is returned if no match
- *	is found.
- */
-struct super_block *get_super_thawed(struct block_device *bdev)
-{
-	return __get_super_thawed(bdev, false);
-}
-EXPORT_SYMBOL(get_super_thawed);
-
-/**
- *	get_super_exclusive_thawed - get thawed superblock of a device
- *	@bdev: device to get the superblock for
- *
- *	Scans the superblock list and finds the superblock of the file system
- *	mounted on the device. The superblock is returned once it is thawed
- *	(or immediately if it was not frozen) and s_umount semaphore is held
- *	in exclusive mode. %NULL is returned if no match is found.
- */
-struct super_block *get_super_exclusive_thawed(struct block_device *bdev)
-{
-	return __get_super_thawed(bdev, true);
-}
-EXPORT_SYMBOL(get_super_exclusive_thawed);
-
 /**
  * get_active_super - get an active reference to the superblock of a device
  * @bdev: device to get the superblock for
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8667d0cdc71e76..a61df0dd4f1989 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1409,7 +1409,7 @@ enum {
 
 struct sb_writers {
 	int				frozen;		/* Is sb frozen? */
-	wait_queue_head_t		wait_unfrozen;	/* for get_super_thawed() */
+	wait_queue_head_t		wait_unfrozen;	/* wait for thaw */
 	struct percpu_rw_semaphore	rw_sem[SB_FREEZE_LEVELS];
 };
 
@@ -3132,8 +3132,6 @@ extern struct file_system_type *get_filesystem(struct file_system_type *fs);
 extern void put_filesystem(struct file_system_type *fs);
 extern struct file_system_type *get_fs_type(const char *name);
 extern struct super_block *get_super(struct block_device *);
-extern struct super_block *get_super_thawed(struct block_device *);
-extern struct super_block *get_super_exclusive_thawed(struct block_device *bdev);
 extern struct super_block *get_active_super(struct block_device *bdev);
 extern void drop_super(struct super_block *sb);
 extern void drop_super_exclusive(struct super_block *sb);
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

