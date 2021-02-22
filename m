Return-Path: <SRS0=l+U7=HY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7995C433DB
	for <dm-devel@archiver.kernel.org>; Mon, 22 Feb 2021 18:15:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4536864F44
	for <dm-devel@archiver.kernel.org>; Mon, 22 Feb 2021 18:15:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4536864F44
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1614017758;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oAWzaD28atrjK9YXm45nelSYt+1j1gTp/TILfETtgeM=;
	b=bXp9jOgjz/LgS+9CsIaTw9CQYFVkibrYN3RGkqq9aqivMob8UEgJw4u3Kp7U6n2ahmDz0p
	tITP8jWMskT/D/SNIoBHH48Fkf8d97awq5iFe6XAVr3AXp/5ryCXjKYwonmRK+rX4Sq/9M
	d7IkeUaaw+xWCVic9twQQERR9mQ1vMg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-IE13BxavP8Gtb0xUYz9NwA-1; Mon, 22 Feb 2021 13:15:53 -0500
X-MC-Unique: IE13BxavP8Gtb0xUYz9NwA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85B801005501;
	Mon, 22 Feb 2021 18:15:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB82C60DA0;
	Mon, 22 Feb 2021 18:15:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F2F6157DFA;
	Mon, 22 Feb 2021 18:15:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11MIFbr6026502 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 22 Feb 2021 13:15:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E8E205D71D; Mon, 22 Feb 2021 18:15:37 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 350A45D6D5;
	Mon, 22 Feb 2021 18:15:33 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 11MIFW0P006167; Mon, 22 Feb 2021 13:15:32 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 11MIFW2J006163; Mon, 22 Feb 2021 13:15:32 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Mon, 22 Feb 2021 13:15:32 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Jens Axboe <axboe@kernel.dk>, Marian Csontos <mcsontos@redhat.com>
Message-ID: <alpine.LRH.2.02.2102221312070.5407@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH] blk-settings: make sure that max_sectors is
 aligned on "logical_block_size" boundary. (fwd)
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



---------- Forwarded message ----------
Date: Thu, 19 Nov 2020 15:36:51 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: David Teigland <teigland@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: heinzm@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>,
    Marian Csontos <mcsontos@redhat.com>, linux-block@vger.kernel.org,
    dm-devel@redhat.com
Subject: [PATCH] blk-settings: make sure that max_sectors is aligned on
    "logical_block_size" boundary.

We get these I/O errors when we run md-raid1 on the top of dm-integrity on 
the top of ramdisk:
device-mapper: integrity: Bio not aligned on 8 sectors: 0xff00, 0xff
device-mapper: integrity: Bio not aligned on 8 sectors: 0xff00, 0xff
device-mapper: integrity: Bio not aligned on 8 sectors: 0xffff, 0x1
device-mapper: integrity: Bio not aligned on 8 sectors: 0xffff, 0x1
device-mapper: integrity: Bio not aligned on 8 sectors: 0x8048, 0xff
device-mapper: integrity: Bio not aligned on 8 sectors: 0x8147, 0xff
device-mapper: integrity: Bio not aligned on 8 sectors: 0x8246, 0xff
device-mapper: integrity: Bio not aligned on 8 sectors: 0x8345, 0xbb

The ramdisk device has logical_block_size 512 and max_sectors 255. The 
dm-integrity device uses logical_block_size 4096 and it doesn't affect the 
"max_sectors" value - thus, it inherits 255 from the ramdisk. So, we have 
a device with max_sectors not aligned on logical_block_size.

The md-raid device sees that the underlying leg has max_sectors 255 and it
will split the bios on 255-sector boundary, making the bios unaligned on
logical_block_size.

In order to fix the bug, we round down max_sectors to logical_block_size.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 block/blk-settings.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6/block/blk-settings.c
===================================================================
--- linux-2.6.orig/block/blk-settings.c	2020-10-29 12:20:46.000000000 +0100
+++ linux-2.6/block/blk-settings.c	2020-11-19 21:20:18.000000000 +0100
@@ -591,6 +591,16 @@ int blk_stack_limits(struct queue_limits
 		ret = -1;
 	}
 
+	t->max_sectors = round_down(t->max_sectors, t->logical_block_size / 512);
+	if (t->max_sectors < PAGE_SIZE / 512)
+		t->max_sectors = PAGE_SIZE / 512;
+	t->max_hw_sectors = round_down(t->max_hw_sectors, t->logical_block_size / 512);
+	if (t->max_sectors < PAGE_SIZE / 512)
+		t->max_hw_sectors = PAGE_SIZE / 512;
+	t->max_dev_sectors = round_down(t->max_dev_sectors, t->logical_block_size / 512);
+	if (t->max_sectors < PAGE_SIZE / 512)
+		t->max_dev_sectors = PAGE_SIZE / 512;
+
 	/* Discard alignment and granularity */
 	if (b->discard_granularity) {
 		alignment = queue_limit_discard_alignment(b, start);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

