Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BBB6EB64DC
	for <dm-devel@archiver.kernel.org>; Fri, 14 Jul 2023 20:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689368060;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ue+8F+bENBVhYJiA7fTfjYD1ys5wsF+RQWLeMVhj2uw=;
	b=LVphXiJ0CmYx41XxfQrpDM03bapqjUNloLg0ctTUPJDV7MUofkw6oFG8K3jNNfhyo9mLg8
	nQtF2ttNiIaGHJ1G9jalTFU2fWQLpA47QDCU0psna/abYUjsCNv+slqE/4e8mjEExAWGkY
	4OXu3NmRQnZ/jm/rnKH+bPwQULJwn14=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-JcE_7sj9NP2OnSXES8utSQ-1; Fri, 14 Jul 2023 16:54:16 -0400
X-MC-Unique: JcE_7sj9NP2OnSXES8utSQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5FCD1C05AB7;
	Fri, 14 Jul 2023 20:54:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8F6DA1454142;
	Fri, 14 Jul 2023 20:54:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3B96A1946594;
	Fri, 14 Jul 2023 20:54:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 56A1E194658F
 for <dm-devel@listman.corp.redhat.com>; Fri, 14 Jul 2023 20:54:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4179EC57964; Fri, 14 Jul 2023 20:54:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 390C0C57963
 for <dm-devel@redhat.com>; Fri, 14 Jul 2023 20:54:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 045278D1681
 for <dm-devel@redhat.com>; Fri, 14 Jul 2023 20:54:02 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-pSUBSUvIOZKi_F52kl9NLw-1; Fri, 14 Jul 2023 16:53:57 -0400
X-MC-Unique: pSUBSUvIOZKi_F52kl9NLw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id B4EBB61D9C;
 Fri, 14 Jul 2023 20:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82138C433C7;
 Fri, 14 Jul 2023 20:53:55 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	heinzm@redhat.com
Date: Fri, 14 Jul 2023 16:53:52 -0400
Message-Id: <20230714205353.1301754-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] Patch "dm: fix undue/missing spaces" has been added to
 the 6.1-stable tree
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm: fix undue/missing spaces

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-fix-undue-missing-spaces.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit c48635352f2ae2859fa3de2e494ecfa079af65cc
Author: Heinz Mauelshagen <heinzm@redhat.com>
Date:   Mon Jan 30 21:43:57 2023 +0100

    dm: fix undue/missing spaces
    
    [ Upstream commit 43be9c743c2553519c2093d1798b542f28095a51 ]
    
    Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Stable-dep-of: 249bed821b4d ("dm ioctl: Avoid double-fetch of version")
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 6ae1c19b82433..9fc4a5d51b3fc 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1572,7 +1572,7 @@ static void retrieve_deps(struct dm_table *table,
 	/*
 	 * Count the devices.
 	 */
-	list_for_each (tmp, dm_table_get_devices(table))
+	list_for_each(tmp, dm_table_get_devices(table))
 		count++;
 
 	/*
@@ -1589,7 +1589,7 @@ static void retrieve_deps(struct dm_table *table,
 	 */
 	deps->count = count;
 	count = 0;
-	list_for_each_entry (dd, dm_table_get_devices(table), list)
+	list_for_each_entry(dd, dm_table_get_devices(table), list)
 		deps->dev[count++] = huge_encode_dev(dd->dm_dev->bdev->bd_dev);
 
 	param->data_size = param->data_start + needed;
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 91c25ad8eed84..66032ab3c4e92 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1086,7 +1086,7 @@ static int parse_hw_handler(struct dm_arg_set *as, struct multipath *m)
 			goto fail;
 		}
 		j = sprintf(p, "%d", hw_argc - 1);
-		for (i = 0, p+=j+1; i <= hw_argc - 2; i++, p+=j+1)
+		for (i = 0, p += j + 1; i <= hw_argc - 2; i++, p += j + 1)
 			j = sprintf(p, "%s", as->argv[i]);
 	}
 	dm_consume_args(as, hw_argc - 1);
diff --git a/drivers/md/dm-ps-service-time.c b/drivers/md/dm-ps-service-time.c
index 84d26234dc053..eba2293be6864 100644
--- a/drivers/md/dm-ps-service-time.c
+++ b/drivers/md/dm-ps-service-time.c
@@ -127,8 +127,7 @@ static int st_add_path(struct path_selector *ps, struct dm_path *path,
 	 * 			The valid range: 0-<ST_MAX_RELATIVE_THROUGHPUT>
 	 *			If not given, minimum value '1' is used.
 	 *			If '0' is given, the path isn't selected while
-	 * 			other paths having a positive value are
-	 * 			available.
+	 *			other paths having a positive value are	available.
 	 */
 	if (argc > 2) {
 		*error = "service-time ps: incorrect number of arguments";
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index c64d987c544d7..cb80d03b37370 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -388,7 +388,7 @@ static struct origin *__lookup_origin(struct block_device *origin)
 	struct origin *o;
 
 	ol = &_origins[origin_hash(origin)];
-	list_for_each_entry (o, ol, hash_list)
+	list_for_each_entry(o, ol, hash_list)
 		if (bdev_equal(o->bdev, origin))
 			return o;
 
@@ -407,7 +407,7 @@ static struct dm_origin *__lookup_dm_origin(struct block_device *origin)
 	struct dm_origin *o;
 
 	ol = &_dm_origins[origin_hash(origin)];
-	list_for_each_entry (o, ol, hash_list)
+	list_for_each_entry(o, ol, hash_list)
 		if (bdev_equal(o->dev->bdev, origin))
 			return o;
 
@@ -2446,7 +2446,7 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 	chunk_t chunk;
 
 	/* Do all the snapshots on this origin */
-	list_for_each_entry (snap, snapshots, list) {
+	list_for_each_entry(snap, snapshots, list) {
 		/*
 		 * Don't make new exceptions in a merging snapshot
 		 * because it has effectively been deleted
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 3acded2f976db..337e667323c4a 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -211,7 +211,7 @@ static struct dm_dev_internal *find_device(struct list_head *l, dev_t dev)
 {
 	struct dm_dev_internal *dd;
 
-	list_for_each_entry (dd, l, list)
+	list_for_each_entry(dd, l, list)
 		if (dd->dm_dev->bdev->bd_dev == dev)
 			return dd;
 
diff --git a/drivers/md/dm-uevent.h b/drivers/md/dm-uevent.h
index 2c9ba561fd8e9..12a5d4fb7d441 100644
--- a/drivers/md/dm-uevent.h
+++ b/drivers/md/dm-uevent.h
@@ -3,7 +3,7 @@
  * Device Mapper Uevent Support
  *
  * Copyright IBM Corporation, 2007
- * 	Author: Mike Anderson <andmike@linux.vnet.ibm.com>
+ *	Author: Mike Anderson <andmike@linux.vnet.ibm.com>
  */
 #ifndef DM_UEVENT_H
 #define DM_UEVENT_H
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 431c84595ddb7..c6ff43a8f0b25 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -85,12 +85,12 @@ struct wc_entry {
 	unsigned short wc_list_contiguous;
 	bool write_in_progress
 #if BITS_PER_LONG == 64
-		:1
+		: 1
 #endif
 	;
 	unsigned long index
 #if BITS_PER_LONG == 64
-		:47
+		: 47
 #endif
 	;
 	unsigned long age;
diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index c795ea7da7917..13070c25adc3d 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1013,7 +1013,7 @@ static int dmz_check_sb(struct dmz_metadata *zmd, struct dmz_sb *dsb,
 	}
 
 	sb_block = le64_to_cpu(sb->sb_block);
-	if (sb_block != (u64)dsb->zone->id << zmd->zone_nr_blocks_shift ) {
+	if (sb_block != (u64)dsb->zone->id << zmd->zone_nr_blocks_shift) {
 		dmz_dev_err(dev, "Invalid superblock position "
 			    "(is %llu expected %llu)",
 			    sb_block,

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

