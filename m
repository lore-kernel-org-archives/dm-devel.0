Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 592FFC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 28 Mar 2022 16:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648485281;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fmZrZ7CQCXFr0BmVSmfDTxydu84IdchiNsacRyGFDLk=;
	b=PHXybm2tEa+JSOEiB2vOnVbRDChPffwOJCVqR67w+nXH8xvAMk/8YjfZ9Wfhh/1wQHNZ/8
	1E63dwlcRV6U8IwcFZdlsKdoawbU7H/XNCZHn7Ea71g/sonSEZzgRbrfMaHL4hT/NXp7da
	IiHyWFbjPhK6JDleG0/tptBo8zc7r/E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-IlZ_UzH-Og6GN55wZjFYQQ-1; Mon, 28 Mar 2022 12:34:37 -0400
X-MC-Unique: IlZ_UzH-Og6GN55wZjFYQQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2FF480159B;
	Mon, 28 Mar 2022 16:34:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EBB8D7AD8;
	Mon, 28 Mar 2022 16:34:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B26CC1947BBF;
	Mon, 28 Mar 2022 16:34:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CA9131947BBE
 for <dm-devel@listman.corp.redhat.com>; Mon, 28 Mar 2022 16:34:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B969E4010A35; Mon, 28 Mar 2022 16:34:31 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B30BA40149B2;
 Mon, 28 Mar 2022 16:34:31 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 22SGYVnQ011593; Mon, 28 Mar 2022 12:34:31 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 22SGYVvZ011589; Mon, 28 Mar 2022 12:34:31 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 28 Mar 2022 12:34:31 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Message-ID: <alpine.LRH.2.02.2203281232060.11240@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH] dm: fix race condition on Alpha
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Early alpha processors cannot write a single byte or short; they read 8
bytes, modify the value in registers and write back 8 bytes.

This could cause race condition in the structure dm_io - if the fields
flags and io_count are modified simultaneously.

Fix this bug by using 32-bit flags if we are on Alpha and if we are
compiling for a processor that doesn't have the byte-word-extension.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: bd4a6dd241ae ("dm: reduce size of dm_io and dm_target_io structs")

---
 drivers/md/dm-core.h      |    4 ++--
 include/linux/blk_types.h |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/blk_types.h
===================================================================
--- linux-2.6.orig/include/linux/blk_types.h	2022-03-28 18:11:15.000000000 +0200
+++ linux-2.6/include/linux/blk_types.h	2022-03-28 18:20:23.000000000 +0200
@@ -85,8 +85,10 @@ struct block_device {
  */
 #if defined(CONFIG_ALPHA) && !defined(__alpha_bwx__)
 typedef u32 __bitwise blk_status_t;
+typedef u32 blk_short_t;
 #else
 typedef u8 __bitwise blk_status_t;
+typedef u16 blk_short_t;
 #endif
 #define	BLK_STS_OK 0
 #define BLK_STS_NOTSUPP		((__force blk_status_t)1)
Index: linux-2.6/drivers/md/dm-core.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-core.h	2022-03-28 18:11:11.000000000 +0200
+++ linux-2.6/drivers/md/dm-core.h	2022-03-28 18:21:34.000000000 +0200
@@ -210,7 +210,7 @@ struct dm_table {
 #define DM_TIO_MAGIC 28714
 struct dm_target_io {
 	unsigned short magic;
-	unsigned short flags;
+	blk_short_t flags;
 	unsigned int target_bio_nr;
 	struct dm_io *io;
 	struct dm_target *ti;
@@ -244,7 +244,7 @@ static inline void dm_tio_set_flag(struc
 #define DM_IO_MAGIC 19577
 struct dm_io {
 	unsigned short magic;
-	unsigned short flags;
+	blk_short_t flags;
 	atomic_t io_count;
 	struct mapped_device *md;
 	struct bio *orig_bio;
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

