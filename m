Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64CE6C43334
	for <dm-devel@archiver.kernel.org>; Wed, 13 Jul 2022 11:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657710551;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jKG7PDd4RQXXZAzaHwJNOAgcSc16RHHbeZvKTS7nGks=;
	b=ZbIWOMVkPUXLpAbXGYSmHcjLwlfAai9nulXcEEPkUeTRB8IjsXZhazKRBR2EuRMn0XtyHg
	bwuv401vke+vDtJYWMFpYFr7+kTOqrt64f+nXESFdtaa1qK0VP3Ay8euYvCDgjGQcjl306
	otxxSXK0bAnuADdY9cvm1B+B0Q5QCZY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-t4UoYJvKNgymwOJrOsdIoQ-1; Wed, 13 Jul 2022 07:09:07 -0400
X-MC-Unique: t4UoYJvKNgymwOJrOsdIoQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2844F3802B80;
	Wed, 13 Jul 2022 11:09:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 16FEC1121314;
	Wed, 13 Jul 2022 11:09:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CB9111947066;
	Wed, 13 Jul 2022 11:09:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 32DB6194705F
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Jul 2022 11:09:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 206E42026D07; Wed, 13 Jul 2022 11:09:05 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 159212026D64;
 Wed, 13 Jul 2022 11:09:05 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 26DB95XF012791; Wed, 13 Jul 2022 07:09:05 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 26DB95NL012787; Wed, 13 Jul 2022 07:09:05 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Wed, 13 Jul 2022 07:09:04 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.02.2207130705520.12621@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH] dm-writecache: set MAX_WRITEBACK_JOBS
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
Cc: dm-devel@redhat.com, David Teigland <teigland@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm-writecache has the capability to limit the number of writeback jobs in
progress. However, this feature is off by default. There were some
observed out-of-memory crashes when lowering the low watermark while the
cache is full.

This commit enables writeback limit by default. It is set to 1GiB or 1/16
of total system memory, whichever is smaller.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-writecache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2022-07-13 13:07:52.000000000 +0200
+++ linux-2.6/drivers/md/dm-writecache.c	2022-07-13 13:08:19.000000000 +0200
@@ -22,7 +22,7 @@
 
 #define HIGH_WATERMARK			50
 #define LOW_WATERMARK			45
-#define MAX_WRITEBACK_JOBS		0
+#define MAX_WRITEBACK_JOBS		min(0x10000000 / PAGE_SIZE, totalram_pages() / 16)
 #define ENDIO_LATENCY			16
 #define WRITEBACK_LATENCY		64
 #define AUTOCOMMIT_BLOCKS_SSD		65536
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

