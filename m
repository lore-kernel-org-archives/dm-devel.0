Return-Path: <SRS0=2AwM=KV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14EC6C47088
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 16:16:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8DC34613DE
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 16:16:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DC34613DE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1622045762;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=91vbwcaOUN9ZdxcLIOyXZu4TOAbbVHHfl0PRWR8+Nss=;
	b=e3A/LlCg8MotuckgxstVkHPOHG9Bng3NVfKI397wSp6IzynTpYL0xahHeKszL8NM4o/pPJ
	KGsxuoD3vFXJ1oLvvY5zLKGJuYJcIc4pR8ZlrZWdytRgE3Cm0SizmimKHojk7u5wzfdI75
	XzEAt5FRNYLud0yae9NpR2cjjNEMbWM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-ky-C0kVHMp23LFM4plkWng-1; Wed, 26 May 2021 12:16:00 -0400
X-MC-Unique: ky-C0kVHMp23LFM4plkWng-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D33E6D24E;
	Wed, 26 May 2021 16:15:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 786DA90BE;
	Wed, 26 May 2021 16:15:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9E6B2180B463;
	Wed, 26 May 2021 16:15:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14QGFpa3008541 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 26 May 2021 12:15:51 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4970961F5E; Wed, 26 May 2021 16:15:51 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 253C75D6D3;
	Wed, 26 May 2021 16:15:51 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 14QGFoAD007635; Wed, 26 May 2021 12:15:50 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 14QGFo6d007631; Wed, 26 May 2021 12:15:50 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Wed, 26 May 2021 12:15:50 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.02.2105261213010.7447@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: [dm-devel] [PATCH] dm-writecache: use early kcopyd callback
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

Hi

You can add this to the kernel that will be used for testing writecache.

Another suggestion is to try to use the dm table argument "writeback_jobs" 
- for example:
dmsetup create wc --table "0 `blockdev --getsize /dev/vdb` writecache s /dev/vdb /dev/vdc 4096 2 writeback_jobs 65536"

It limits the number of work that is submitted to kcopyd and it may 
improve latency.

Mikulas


Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c
+++ linux-2.6/drivers/md/dm-writecache.c
@@ -1538,14 +1538,15 @@ static void writecache_copy_endio(int re
 {
 	struct copy_struct *c = ptr;
 	struct dm_writecache *wc = c->wc;
+	unsigned long flags;
 
 	c->error = likely(!(read_err | write_err)) ? 0 : -EIO;
 
-	raw_spin_lock_irq(&wc->endio_list_lock);
+	raw_spin_lock_irqsave(&wc->endio_list_lock, flags);
 	if (unlikely(list_empty(&wc->endio_list)))
 		wake_up_process(wc->endio_thread);
 	list_add_tail(&c->endio_entry, &wc->endio_list);
-	raw_spin_unlock_irq(&wc->endio_list_lock);
+	raw_spin_unlock_irqrestore(&wc->endio_list_lock, flags);
 }
 
 static void __writecache_endio_pmem(struct dm_writecache *wc, struct list_head *list)
@@ -1799,7 +1800,7 @@ static void __writecache_writeback_ssd(s
 			from.count = to.count = wc->data_device_sectors - to.sector;
 		}
 
-		dm_kcopyd_copy(wc->dm_kcopyd, &from, 1, &to, 0, writecache_copy_endio, c);
+		dm_kcopyd_copy(wc->dm_kcopyd, &from, 1, &to, BIT(DM_KCOPYD_EARLY_CALLBACK), writecache_copy_endio, c);
 
 		__writeback_throttle(wc, wbl);
 	}

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

