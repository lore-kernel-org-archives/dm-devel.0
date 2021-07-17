Return-Path: <SRS0=EhVD=MJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 581CAC636C9
	for <dm-devel@archiver.kernel.org>; Sat, 17 Jul 2021 15:55:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E98C76115A
	for <dm-devel@archiver.kernel.org>; Sat, 17 Jul 2021 15:55:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E98C76115A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=126.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-IXzYu8XNMSib33BHoa1UFQ-1; Sat, 17 Jul 2021 11:55:29 -0400
X-MC-Unique: IXzYu8XNMSib33BHoa1UFQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DBB1343CE;
	Sat, 17 Jul 2021 15:55:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B601010027A5;
	Sat, 17 Jul 2021 15:55:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A36CC1809C99;
	Sat, 17 Jul 2021 15:55:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16HFtDLC011178 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 17 Jul 2021 11:55:13 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 971F22160292; Sat, 17 Jul 2021 15:55:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 92C472160291
	for <dm-devel@redhat.com>; Sat, 17 Jul 2021 15:55:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5925802E55
	for <dm-devel@redhat.com>; Sat, 17 Jul 2021 15:55:09 +0000 (UTC)
Received: from m15111.mail.126.com (m15111.mail.126.com [220.181.15.111]) by
	relay.mimecast.com with ESMTP id us-mta-515-dZjIglwNN8yzJGfMDVZE3g-1;
	Sat, 17 Jul 2021 11:55:06 -0400
X-MC-Unique: dZjIglwNN8yzJGfMDVZE3g-1
Received: from 192.168.137.133 (unknown [112.10.74.16])
	by smtp1 (Coremail) with SMTP id C8mowAB3Ol1S_fJg_DnxTA--.9273S3;
	Sat, 17 Jul 2021 23:55:03 +0800 (CST)
From: Xianting Tian <xianting_tian@126.com>
To: agk@redhat.com, snitzer@redhat.com
Date: Sat, 17 Jul 2021 11:54:23 -0400
Message-Id: <1626537263-8752-1-git-send-email-xianting_tian@126.com>
X-CM-TRANSID: C8mowAB3Ol1S_fJg_DnxTA--.9273S3
X-Coremail-Antispam: 1Uf129KBjvdXoWruF1UKFykZF4kZw45AFy5Jwb_yoWkAFX_Cr
	90qa97Wr1YkF13Kr43Gr4avr95KrZ7uF1xWF1UKa9xWa40vws0qr9rKrnxKr1UZayxCa98
	GFWkJ34rC3y09jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnKhF7UUUUU==
X-Originating-IP: [112.10.74.16]
X-CM-SenderInfo: h0ld03plqjs3xldqqiyswou0bp/1tbizhfSpF8RNK227wAAsh
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
Cc: Xianting Tian <xianting.tian@linux.alibaba.com>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH] dm io: fix comments to align with on-stack
	plugging
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Xianting Tian <xianting.tian@linux.alibaba.com>

Ther is no unplugging timer now, on-stack io plugging is used:
	struct blk_plug plug;

	blk_start_plug(&plug);
	submit_batch_of_io();
	blk_finish_plug(&plug);

So remove the old comments for unplugging timer.

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
---
 drivers/md/dm-io.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 2d3cda0..7dba193 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -528,11 +528,6 @@ static int dp_init(struct dm_io_request *io_req, struct dpages *dp,
 
 /*
  * New collapsed (a)synchronous interface.
- *
- * If the IO is asynchronous (i.e. it has notify.fn), you must either unplug
- * the queue with blk_unplug() some time later or set REQ_SYNC in
- * io_req->bi_opf. If you fail to do one of these, the IO will be submitted to
- * the disk after q->unplug_delay, which defaults to 3ms in blk-settings.c.
  */
 int dm_io(struct dm_io_request *io_req, unsigned num_regions,
 	  struct dm_io_region *where, unsigned long *sync_error_bits)
-- 
1.8.3.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

