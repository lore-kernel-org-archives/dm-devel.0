Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54B4CC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 16 Jun 2022 18:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655403287;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5P8oQnPxuHRD0Oekc5DByME3dAEiQBK4P43sEAJUq7k=;
	b=SD3fcbfj/JDmhlaOg87vhzIZnsStJN4UPpxoJx4DFrJ8i75N6VfO1z1gt1tJ2q4od0Wfl1
	xKQF1NC1xevebdjj3GSX0eW95lmFqbhoaeoP91IjxxfYFALOs9dYQaegpKk8BDCODyHsvZ
	KbzbzllIlCrCp5wguqMnwUBlfujRW7w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-2ghyBr7kMkiN5F9RUW36yw-1; Thu, 16 Jun 2022 14:14:44 -0400
X-MC-Unique: 2ghyBr7kMkiN5F9RUW36yw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 187A61066543;
	Thu, 16 Jun 2022 18:14:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9BDDA1121319;
	Thu, 16 Jun 2022 18:14:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 57C4C194705F;
	Thu, 16 Jun 2022 18:14:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4F75B1947064
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Jun 2022 18:14:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2B41A40C1289; Thu, 16 Jun 2022 18:14:39 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2431940C1288;
 Thu, 16 Jun 2022 18:14:39 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 25GIEdXj027031; Thu, 16 Jun 2022 14:14:39 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 25GIEde0027027; Thu, 16 Jun 2022 14:14:39 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Thu, 16 Jun 2022 14:14:39 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.02.2206161412490.26972@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH] dm: double-check REQ_NOWAIT flag while we hold
 the table lock
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Starting with the commit 63a225c9fd20, device mapper has an optimization
that it will take cheaper table lock (dm_get_live_table_fast instead of
dm_get_live_table) if the bio has REQ_NOWAIT. The bios with REQ_NOWAIT
must not block in the target request routine, if they did, we would be
blocking while holding rcu_read_lock, which is prohibited.

The targets that are suitable for REQ_NOWAIT optimization (and that don't
block in the map routine) have the flag DM_TARGET_NOWAIT set. Device
mapper will test if all the targets and all the devices in a table
support nowait (see the function dm_table_supports_nowait) and it will set
or clear the QUEUE_FLAG_NOWAIT flag on it's request queue according to
this check.

There's a test in submit_bio_noacct: "if ((bio->bi_opf & REQ_NOWAIT) &&
!blk_queue_nowait(q)) goto not_supported" - this will make sure that
REQ_NOWAIT bios can't enter a request queue that doesn't support them.

This mechanism works to prevent REQ_NOWAIT bios from reaching dm targets
that don't support the REQ_NOWAIT flag (and that may block in the map
routine) - except that there is a small race condition:

submit_bio_noacct checks if the queue has the QUEUE_FLAG_NOWAIT without
holding any locks. Immediatelly after this check, the device mapper table
may be reloaded with a table that doesn't support REQ_NOWAIT (for example,
if we start moving the logical volume or if we activate a snapshot).
However the REQ_NOWAIT bio that already passed the check in
submit_bio_noacct would be sent to device mapper, where it could be
redirected to a dm target that doesn't support REQ_NOWAIT - the result is
sleeping while we hold rcu_read_lock.

In order to fix this race, we double-check if the target supports
REQ_NOWAIT while we hold the table lock (so that the table can't change
under us).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 63a225c9fd20 ("dm: introduce dm_{get,put}_live_table_bio called from dm_submit_bio")

---
 drivers/md/dm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2022-06-16 09:20:45.000000000 +0200
+++ linux-2.6/drivers/md/dm.c	2022-06-16 19:39:04.000000000 +0200
@@ -1609,7 +1609,12 @@ static blk_status_t __split_and_process_
 	ti = dm_table_find_target(ci->map, ci->sector);
 	if (unlikely(!ti))
 		return BLK_STS_IOERR;
-	else if (unlikely(ci->is_abnormal_io))
+
+	if (unlikely((ci->bio->bi_opf & REQ_NOWAIT) != 0) &&
+	    unlikely(!dm_target_supports_nowait(ti->type)))
+		return BLK_STS_NOTSUPP;
+
+	if (unlikely(ci->is_abnormal_io))
 		return __process_abnormal_io(ci, ti);
 
 	/*
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

