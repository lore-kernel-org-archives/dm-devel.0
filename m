Return-Path: <SRS0=SJ91=MM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957FAC07E95
	for <dm-devel@archiver.kernel.org>; Tue, 20 Jul 2021 07:50:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2524B61175
	for <dm-devel@archiver.kernel.org>; Tue, 20 Jul 2021 07:50:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2524B61175
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=fudan.edu.cn
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-KrnJ-BekMYe_xbNZ8Gt5eg-1; Tue, 20 Jul 2021 03:50:46 -0400
X-MC-Unique: KrnJ-BekMYe_xbNZ8Gt5eg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1238CA0CCD;
	Tue, 20 Jul 2021 07:50:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3688678C00;
	Tue, 20 Jul 2021 07:50:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8063E1809C99;
	Tue, 20 Jul 2021 07:50:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16J8cwVZ027740 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 19 Jul 2021 04:38:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6E227111143C; Mon, 19 Jul 2021 08:38:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 69D4F1111439
	for <dm-devel@redhat.com>; Mon, 19 Jul 2021 08:38:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D1D280D09C
	for <dm-devel@redhat.com>; Mon, 19 Jul 2021 08:38:55 +0000 (UTC)
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net
	(zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27]) by
	relay.mimecast.com with ESMTP id us-mta-64-E-S30sJiOJenk8bNV5-MYA-1;
	Mon, 19 Jul 2021 04:38:51 -0400
X-MC-Unique: E-S30sJiOJenk8bNV5-MYA-1
Received: from localhost.localdomain (unknown [10.162.86.133])
	by app2 (Coremail) with SMTP id XQUFCgCnbGtKOPVgu13pBA--.3229S3;
	Mon, 19 Jul 2021 16:31:07 +0800 (CST)
From: Xiyu Yang <xiyuyang19@fudan.edu.cn>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org
Date: Mon, 19 Jul 2021 16:31:02 +0800
Message-Id: <1626683462-64030-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-CM-TRANSID: XQUFCgCnbGtKOPVgu13pBA--.3229S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Wry3tF17ZF18JF47ZFyrZwb_yoW5Jr1kpF
	4jg39Y9FWrJF17tw4kAay0vF1rAa4qkrWrArWUKw43AFyfWryYva18Kryjqas7JFy7AFWU
	ZF1j9FZI9a1DAa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvm14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
	648v4I1lc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI
	8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AK
	xVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI
	8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E
	87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnU
	UI43ZEXa7VUjiF4JUUUUU==
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 20 Jul 2021 03:50:34 -0400
Cc: Xin Tan <tanxin.ctf@gmail.com>, yuanxzhang@fudan.edu.cn,
	Xiyu Yang <xiyuyang19@fudan.edu.cn>
Subject: [dm-devel] [PATCH] dm io: Convert from atomic_t to refcount_t on
	io->count
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

refcount_t type and corresponding API can protect refcounters from
accidental underflow and overflow and further use-after-free situations.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 drivers/md/dm-io.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 2d3cda0acacb..f296bba86d14 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -5,6 +5,7 @@
  * This file is released under the GPL.
  */
 
+#include <linux/refcount.h>
 #include "dm-core.h"
 
 #include <linux/device-mapper.h>
@@ -32,7 +33,7 @@ struct dm_io_client {
  */
 struct io {
 	unsigned long error_bits;
-	atomic_t count;
+	refcount_t count;
 	struct dm_io_client *client;
 	io_notify_fn callback;
 	void *context;
@@ -130,7 +131,7 @@ static void dec_count(struct io *io, unsigned int region, blk_status_t error)
 	if (error)
 		set_bit(region, &io->error_bits);
 
-	if (atomic_dec_and_test(&io->count))
+	if (refcount_dec_and_test(&io->count))
 		complete_io(io);
 }
 
@@ -319,7 +320,7 @@ static void do_region(int op, int op_flags, unsigned region,
 		special_cmd_max_sectors = q->limits.max_write_same_sectors;
 	if ((op == REQ_OP_DISCARD || op == REQ_OP_WRITE_ZEROES ||
 	     op == REQ_OP_WRITE_SAME) && special_cmd_max_sectors == 0) {
-		atomic_inc(&io->count);
+		refcount_inc(&io->count);
 		dec_count(io, region, BLK_STS_NOTSUPP);
 		return;
 	}
@@ -382,7 +383,7 @@ static void do_region(int op, int op_flags, unsigned region,
 			dp->next_page(dp);
 		}
 
-		atomic_inc(&io->count);
+		refcount_inc(&io->count);
 		submit_bio(bio);
 	} while (remaining);
 }
@@ -445,7 +446,7 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 
 	io = mempool_alloc(&client->pool, GFP_NOIO);
 	io->error_bits = 0;
-	atomic_set(&io->count, 1); /* see dispatch_io() */
+	refcount_set(&io->count, 1); /* see dispatch_io() */
 	io->client = client;
 	io->callback = sync_io_complete;
 	io->context = &sio;
@@ -477,7 +478,7 @@ static int async_io(struct dm_io_client *client, unsigned int num_regions,
 
 	io = mempool_alloc(&client->pool, GFP_NOIO);
 	io->error_bits = 0;
-	atomic_set(&io->count, 1); /* see dispatch_io() */
+	refcount_set(&io->count, 1); /* see dispatch_io() */
 	io->client = client;
 	io->callback = fn;
 	io->context = context;
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

