Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FA71C001DB
	for <dm-devel@archiver.kernel.org>; Thu, 10 Aug 2023 06:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691650059;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Uh8ktIUraUvnM3zu6bj7tbu18Ic7M7eT7ShilcD76uY=;
	b=QBypbZPwfGJIZbyD0YaR2RuxBiqH5O2FTeh1zR/m9YZTMgMaxmMaVH/j1upnl9TolWNlaI
	cU256ybo0DTH4ECsEDjfc2DUVopn4FEe1rUJ+SGqNSQrzLQhRJ0muoxfhA36WIU8rWx0ex
	rc49rJLyZJg1szZQ+7yq3zrO5dkku+k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-YAm8jOeBMdesPs8qfg4jKw-1; Thu, 10 Aug 2023 02:47:35 -0400
X-MC-Unique: YAm8jOeBMdesPs8qfg4jKw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F2C8858EED;
	Thu, 10 Aug 2023 06:47:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C5C542026D4B;
	Thu, 10 Aug 2023 06:47:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 982E71946589;
	Thu, 10 Aug 2023 06:47:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 76C1B1946588
 for <dm-devel@listman.corp.redhat.com>; Thu, 10 Aug 2023 06:47:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 516161121315; Thu, 10 Aug 2023 06:47:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 498AB1121314
 for <dm-devel@redhat.com>; Thu, 10 Aug 2023 06:47:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2AC998DC666
 for <dm-devel@redhat.com>; Thu, 10 Aug 2023 06:47:32 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com
 [45.249.212.255]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-RWXllzPhOQSXuKecvQmtEg-1; Thu, 10 Aug 2023 02:47:28 -0400
X-MC-Unique: RWXllzPhOQSXuKecvQmtEg-1
Received: from dggpemm500011.china.huawei.com (unknown [172.30.72.57])
 by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RLyBD0W61z1L9Vb;
 Thu, 10 Aug 2023 14:46:12 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpemm500011.china.huawei.com
 (7.185.36.110) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 10 Aug
 2023 14:47:23 +0800
From: Li Lingfeng <lilingfeng3@huawei.com>
To: <dm-devel@redhat.com>
Date: Thu, 10 Aug 2023 14:44:06 +0800
Message-ID: <20230810064406.1672148-1-lilingfeng3@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500011.china.huawei.com (7.185.36.110)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH -next] dm snapshot: record cause of invalidating
 snapshot
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, snitzer@kernel.org,
 lilingfeng@huaweicloud.com, linan122@huawei.com, houtao1@huawei.com,
 yukuai3@huawei.com, lilingfeng3@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huawei.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The cause of invalidating snapshot will be print in log. However, if we
lost the log, we will never get the cause. What we can get by "dmsetup
status" is the state of "Invalid" without the cause.

Record cause of invalidating snapshot in snapshot->valid, so that we can
query the cause by "dmsetup status".

Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
---
 drivers/md/dm-snap.c | 60 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 45 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 41735a25d50a..48788431e7bf 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -39,6 +39,28 @@ static const char dm_snapshot_merge_target_name[] = "snapshot-merge";
 #define DM_TRACKED_CHUNK_HASH(x)	((unsigned long)(x) & \
 					 (DM_TRACKED_CHUNK_HASH_SIZE - 1))
 
+#define INVALID_CAUSE_BIT		16
+#define DM_SNAPSHOT_VALID(s)		(s->valid & \
+					((1 << INVALID_CAUSE_BIT) - 1))
+#define DM_SNAPSHOT_INVALID_CAUSE(s)	(s->valid >> INVALID_CAUSE_BIT)
+#define SET_INVALID_CAUSE(s, cause)	(s->valid = \
+					(DM_SNAPSHOT_VALID(s) | \
+					(cause << INVALID_CAUSE_BIT)))
+
+enum invalid_cause {
+	INVALID_BY_METADATA = 1,
+	INVALID_BY_HANDOVER = 2,
+	INVALID_BY_CACELLING_HANDOVER = 3,
+	INVALID_BY_EIO = 4,
+	INVALID_BY_ENOMEM = 5
+};
+
+char *display_invalid_cause[] = {"by METADATA",
+				 "by HANDOVER",
+				 "by CANCELLING HANDOVER",
+				 "by EIO",
+				 "by ENOMEM"};
+
 struct dm_exception_table {
 	uint32_t hash_mask;
 	unsigned hash_shift;
@@ -1054,7 +1076,7 @@ static void snapshot_merge_next_chunks(struct dm_snapshot *s)
 	/*
 	 * valid flag never changes during merge, so no lock required.
 	 */
-	if (!s->valid) {
+	if (!DM_SNAPSHOT_VALID(s)) {
 		DMERR("Snapshot is invalid: can't merge");
 		goto shut;
 	}
@@ -1403,6 +1425,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad_read_metadata;
 	} else if (r > 0) {
 		s->valid = 0;
+		SET_INVALID_CAUSE(s, INVALID_BY_METADATA);
 		DMWARN("Snapshot is marked invalid.");
 	}
 
@@ -1480,6 +1503,7 @@ static void __handover_exceptions(struct dm_snapshot *snap_src,
 	 * Set source invalid to ensure it receives no further I/O.
 	 */
 	snap_src->valid = 0;
+	SET_INVALID_CAUSE(snap_src, INVALID_BY_HANDOVER);
 }
 
 static void snapshot_dtr(struct dm_target *ti)
@@ -1496,6 +1520,7 @@ static void snapshot_dtr(struct dm_target *ti)
 	if (snap_src && snap_dest && (s == snap_src)) {
 		down_write(&snap_dest->lock);
 		snap_dest->valid = 0;
+		SET_INVALID_CAUSE(snap_dest, INVALID_BY_HANDOVER);
 		up_write(&snap_dest->lock);
 		DMERR("Cancelling snapshot handover.");
 	}
@@ -1635,18 +1660,21 @@ static void error_bios(struct bio *bio)
 
 static void __invalidate_snapshot(struct dm_snapshot *s, int err)
 {
-	if (!s->valid)
+	if (!DM_SNAPSHOT_VALID(s))
 		return;
 
-	if (err == -EIO)
-		DMERR("Invalidating snapshot: Error reading/writing.");
-	else if (err == -ENOMEM)
-		DMERR("Invalidating snapshot: Unable to allocate exception.");
-
 	if (s->store->type->drop_snapshot)
 		s->store->type->drop_snapshot(s->store);
 
 	s->valid = 0;
+	if (err == -EIO) {
+		SET_INVALID_CAUSE(s, INVALID_BY_EIO);
+		DMERR("Invalidating snapshot: Error reading/writing.");
+	} else if (err == -ENOMEM) {
+		SET_INVALID_CAUSE(s, INVALID_BY_ENOMEM);
+		DMERR("Invalidating snapshot: Unable to allocate exception.");
+	}
+
 
 	dm_table_event(s->ti->table);
 }
@@ -1692,7 +1720,7 @@ static void pending_complete(void *context, int success)
 
 	down_read(&s->lock);
 	dm_exception_table_lock(&lock);
-	if (!s->valid) {
+	if (!DM_SNAPSHOT_VALID(s)) {
 		up_read(&s->lock);
 		free_completed_exception(e);
 		error = 1;
@@ -1984,7 +2012,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 
 	/* Full snapshots are not usable */
 	/* To get here the table must be live so s->active is always set. */
-	if (!s->valid)
+	if (!DM_SNAPSHOT_VALID(s))
 		return DM_MAPIO_KILL;
 
 	if (bio_data_dir(bio) == WRITE) {
@@ -1995,7 +2023,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 	down_read(&s->lock);
 	dm_exception_table_lock(&lock);
 
-	if (!s->valid || (unlikely(s->snapshot_overflowed) &&
+	if (!DM_SNAPSHOT_VALID(s) || (unlikely(s->snapshot_overflowed) &&
 	    bio_data_dir(bio) == WRITE)) {
 		r = DM_MAPIO_KILL;
 		goto out_unlock;
@@ -2068,7 +2096,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 				down_write(&s->lock);
 
 				if (s->store->userspace_supports_overflow) {
-					if (s->valid && !s->snapshot_overflowed) {
+					if (DM_SNAPSHOT_VALID(s) && !s->snapshot_overflowed) {
 						s->snapshot_overflowed = 1;
 						DMERR("Snapshot overflowed: Unable to allocate exception.");
 					}
@@ -2159,7 +2187,7 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio)
 	down_write(&s->lock);
 
 	/* Full merging snapshots are redirected to the origin */
-	if (!s->valid)
+	if (!DM_SNAPSHOT_VALID(s))
 		goto redirect_to_origin;
 
 	/* If the block is already remapped - use that */
@@ -2344,8 +2372,10 @@ static void snapshot_status(struct dm_target *ti, status_type_t type,
 
 		down_write(&snap->lock);
 
-		if (!snap->valid)
-			DMEMIT("Invalid");
+		if (!DM_SNAPSHOT_VALID(snap))
+			DMEMIT("Invalid %s", DM_SNAPSHOT_INVALID_CAUSE(snap) ?
+					display_invalid_cause[DM_SNAPSHOT_INVALID_CAUSE(snap) - 1] :
+					"");
 		else if (snap->merge_failed)
 			DMEMIT("Merge failed");
 		else if (snap->snapshot_overflowed)
@@ -2477,7 +2507,7 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 		dm_exception_table_lock(&lock);
 
 		/* Only deal with valid and active snapshots */
-		if (!snap->valid || !snap->active)
+		if (!DM_SNAPSHOT_VALID(snap) || !snap->active)
 			goto next_snapshot;
 
 		pe = __lookup_pending_exception(snap, chunk);
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

