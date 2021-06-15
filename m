Return-Path: <SRS0=rgwX=LJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28131C48BE5
	for <dm-devel@archiver.kernel.org>; Tue, 15 Jun 2021 17:48:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BA95161009
	for <dm-devel@archiver.kernel.org>; Tue, 15 Jun 2021 17:48:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA95161009
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1623779279;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9vEYu+liNWbaMDatwgfgiJeLPLIE4C3G8hSZ3y8wwNM=;
	b=QjBe0x8ud8rQNBYfn2ymCGdzlrL9rzTnhtW/7drmNxj5e8cnfOHYCCgUJJNFlfEWej5hZJ
	6YVLkgS+T7OwVyyA21L1NebRPoTK0Aql7+miMp3+nv3nRTCeY0TW55KCbX2XVw1+YjwUrl
	/TumZM/GZbRM6V9q0B5q/wYzr8E7J2w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601-6pySQdhzPkWoMjc73DRFVg-1; Tue, 15 Jun 2021 13:47:58 -0400
X-MC-Unique: 6pySQdhzPkWoMjc73DRFVg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AF1A101C8AD;
	Tue, 15 Jun 2021 17:47:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F49F19C66;
	Tue, 15 Jun 2021 17:47:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 10F414A717;
	Tue, 15 Jun 2021 17:47:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15FHlpSQ001176 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Jun 2021 13:47:51 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 45E1F100E113; Tue, 15 Jun 2021 17:47:51 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E416F1002D71;
	Tue, 15 Jun 2021 17:47:47 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 15FHllea000958; Tue, 15 Jun 2021 13:47:47 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 15FHllF3000954; Tue, 15 Jun 2021 13:47:47 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Tue, 15 Jun 2021 13:47:47 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.02.2106151346100.29600@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com,
	Joe Thornber <thornber@redhat.com>
Subject: [dm-devel] [PATCH] dm-writecache: back off if the kcopyd workqueue
	is blocked
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

This patch makes dm-writecache wait if the kcopyd workqueue is blocked (it 
happens when one of the devices is contested). It improves performance of 
"mkfs.ext2" by approximatelly 20%.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux/drivers/md/dm-kcopyd.c
===================================================================
--- linux.orig/drivers/md/dm-kcopyd.c
+++ linux/drivers/md/dm-kcopyd.c
@@ -888,6 +888,12 @@ void dm_kcopyd_do_callback(void *j, int
 }
 EXPORT_SYMBOL(dm_kcopyd_do_callback);
 
+void dm_kcopyd_wait_if_busy(struct dm_kcopyd_client *kc)
+{
+	flush_workqueue(kc->kcopyd_wq);
+}
+EXPORT_SYMBOL(dm_kcopyd_wait_if_busy);
+
 /*
  * Cancels a kcopyd job, eg. someone might be deactivating a
  * mirror.
Index: linux/drivers/md/dm-writecache.c
===================================================================
--- linux.orig/drivers/md/dm-writecache.c
+++ linux/drivers/md/dm-writecache.c
@@ -1819,6 +1819,9 @@ static void writecache_writeback(struct
 	struct writeback_list wbl;
 	unsigned long n_walked;
 
+	if (!WC_MODE_PMEM(wc))
+		dm_kcopyd_wait_if_busy(wc->dm_kcopyd);
+
 	wc_lock(wc);
 restart:
 	if (writecache_has_error(wc)) {
Index: linux/include/linux/dm-kcopyd.h
===================================================================
--- linux.orig/include/linux/dm-kcopyd.h
+++ linux/include/linux/dm-kcopyd.h
@@ -81,6 +81,8 @@ void *dm_kcopyd_prepare_callback(struct
 				 dm_kcopyd_notify_fn fn, void *context);
 void dm_kcopyd_do_callback(void *job, int read_err, unsigned long write_err);
 
+void dm_kcopyd_wait_if_busy(struct dm_kcopyd_client *kc);
+
 void dm_kcopyd_zero(struct dm_kcopyd_client *kc,
 		    unsigned num_dests, struct dm_io_region *dests,
 		    unsigned flags, dm_kcopyd_notify_fn fn, void *context);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

