Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 401B9C6FD18
	for <dm-devel@archiver.kernel.org>; Tue, 18 Apr 2023 19:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681847809;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0lxDfSbfaGWna69y7U9fR6Q58uUoet+Q3j75p8U/JwA=;
	b=fU7TXUaI2F7j3g8gd/l7ThwXxSf+kL6zMFD588uSQba7dHYOGQy0u9GqvPMNmO3d/WbCXX
	lD+GfVtt0lEp4Vc2KJVjOIeXDh68HFM85TQ2acPPRj2Jm8RPOydUxj2bWczMiU4cDCTf+X
	akp+uig0ToHufO6biUwA2Dd6dehzj8M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-ucQK-S5ONJ2JV_xlawMN1g-1; Tue, 18 Apr 2023 15:56:46 -0400
X-MC-Unique: ucQK-S5ONJ2JV_xlawMN1g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A4733801F56;
	Tue, 18 Apr 2023 19:56:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 098C9202A428;
	Tue, 18 Apr 2023 19:56:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BDCD31946594;
	Tue, 18 Apr 2023 19:56:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 30876194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Apr 2023 19:56:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1BA2540BC79A; Tue, 18 Apr 2023 19:56:42 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E38F40BC799;
 Tue, 18 Apr 2023 19:56:42 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 33IJugJP030186; Tue, 18 Apr 2023 15:56:42 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 33IJufCb030182; Tue, 18 Apr 2023 15:56:41 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Tue, 18 Apr 2023 15:56:41 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.21.2304181556120.30044@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH 2/5] dm flakey: add an "error_reads" option
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm-flakey returns error on reads if no other argument is specified. We
simplify the logic, introduce an "error_reads" argument and an ERROR_READS
flag.

If no argument is specified, we set ERROR_READS, so that it behaves just
like before this patch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 Documentation/admin-guide/device-mapper/dm-flakey.rst |    4 +
 drivers/md/dm-flakey.c                                |   39 ++++++++++++------
 2 files changed, 31 insertions(+), 12 deletions(-)

Index: linux-2.6/Documentation/admin-guide/device-mapper/dm-flakey.rst
===================================================================
--- linux-2.6.orig/Documentation/admin-guide/device-mapper/dm-flakey.rst
+++ linux-2.6/Documentation/admin-guide/device-mapper/dm-flakey.rst
@@ -39,6 +39,10 @@ Optional feature parameters:
   If no feature parameters are present, during the periods of
   unreliability, all I/O returns errors.
 
+  error_reads:
+	All read I/O is failed with an error signalled.
+	Write I/O is handled correctly.
+
   drop_writes:
 	All write I/O is silently ignored.
 	Read I/O is handled correctly.
Index: linux-2.6/drivers/md/dm-flakey.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-flakey.c
+++ linux-2.6/drivers/md/dm-flakey.c
@@ -37,6 +37,7 @@ struct flakey_c {
 };
 
 enum feature_flag_bits {
+	ERROR_READS,
 	DROP_WRITES,
 	ERROR_WRITES
 };
@@ -53,7 +54,7 @@ static int parse_features(struct dm_arg_
 	const char *arg_name;
 
 	static const struct dm_arg _args[] = {
-		{0, 6, "Invalid number of feature args"},
+		{0, 7, "Invalid number of feature args"},
 		{1, UINT_MAX, "Invalid corrupt bio byte"},
 		{0, 255, "Invalid corrupt value to write into bio byte (0-255)"},
 		{0, UINT_MAX, "Invalid corrupt bio flags mask"},
@@ -77,6 +78,17 @@ static int parse_features(struct dm_arg_
 		}
 
 		/*
+		 * error_reads
+		 */
+		if (!strcasecmp(arg_name, "error_reads")) {
+			if (test_and_set_bit(ERROR_READS, &fc->flags)) {
+				ti->error = "Feature error_reads duplicated";
+				return -EINVAL;
+			}
+			continue;
+		}
+
+		/*
 		 * drop_writes
 		 */
 		if (!strcasecmp(arg_name, "drop_writes")) {
@@ -171,6 +183,12 @@ static int parse_features(struct dm_arg_
 		return -EINVAL;
 	}
 
+	if (!fc->corrupt_bio_byte && !test_bit(ERROR_READS, &fc->flags) &&
+	    !test_bit(DROP_WRITES, &fc->flags) && !test_bit(ERROR_WRITES, &fc->flags)) {
+		set_bit(ERROR_WRITES, &fc->flags);
+		set_bit(ERROR_READS, &fc->flags);
+	}
+
 	return 0;
 }
 
@@ -346,8 +364,7 @@ static int flakey_map(struct dm_target *
 		 * Otherwise, flakey_end_io() will decide if the reads should be modified.
 		 */
 		if (bio_data_dir(bio) == READ) {
-			if (!fc->corrupt_bio_byte && !test_bit(DROP_WRITES, &fc->flags) &&
-			    !test_bit(ERROR_WRITES, &fc->flags))
+			if (test_bit(ERROR_READS, &fc->flags))
 				return DM_MAPIO_KILL;
 			goto map_bio;
 		}
@@ -373,11 +390,6 @@ static int flakey_map(struct dm_target *
 			}
 			goto map_bio;
 		}
-
-		/*
-		 * By default, error all I/O.
-		 */
-		return DM_MAPIO_KILL;
 	}
 
 map_bio:
@@ -404,8 +416,8 @@ static int flakey_end_io(struct dm_targe
 				 */
 				corrupt_bio_data(bio, fc);
 			}
-		} else if (!test_bit(DROP_WRITES, &fc->flags) &&
-			   !test_bit(ERROR_WRITES, &fc->flags)) {
+		}
+		if (test_bit(ERROR_READS, &fc->flags)) {
 			/*
 			 * Error read during the down_interval if drop_writes
 			 * and error_writes were not configured.
@@ -422,7 +434,7 @@ static void flakey_status(struct dm_targ
 {
 	unsigned int sz = 0;
 	struct flakey_c *fc = ti->private;
-	unsigned int drop_writes, error_writes;
+	unsigned int error_reads, drop_writes, error_writes;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -434,10 +446,13 @@ static void flakey_status(struct dm_targ
 		       (unsigned long long)fc->start, fc->up_interval,
 		       fc->down_interval);
 
+		error_reads = test_bit(ERROR_READS, &fc->flags);
 		drop_writes = test_bit(DROP_WRITES, &fc->flags);
 		error_writes = test_bit(ERROR_WRITES, &fc->flags);
-		DMEMIT(" %u", drop_writes + error_writes + (fc->corrupt_bio_byte > 0) * 5);
+		DMEMIT(" %u", error_reads + drop_writes + error_writes + (fc->corrupt_bio_byte > 0) * 5);
 
+		if (error_reads)
+			DMEMIT(" error_reads");
 		if (drop_writes)
 			DMEMIT(" drop_writes");
 		else if (error_writes)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

