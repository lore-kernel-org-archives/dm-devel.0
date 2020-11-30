Return-Path: <SRS0=byOr=FF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F93C71155
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 11:24:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C7B1E206E3
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 11:24:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7B1E206E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-vI9mroQlO_O1xNfCuAaYaA-1; Tue, 01 Dec 2020 06:24:08 -0500
X-MC-Unique: vI9mroQlO_O1xNfCuAaYaA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA6F11005E46;
	Tue,  1 Dec 2020 11:24:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 462535D9C2;
	Tue,  1 Dec 2020 11:24:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A8E7E4BB7B;
	Tue,  1 Dec 2020 11:23:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AUBXshQ027900 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 06:33:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 28E7F20296AA; Mon, 30 Nov 2020 11:33:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 254132026D49
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 11:33:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CC648007DF
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 11:33:50 +0000 (UTC)
Received: from out30-132.freemail.mail.aliyun.com
	(out30-132.freemail.mail.aliyun.com [115.124.30.132]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-485-wVbiaMoQOmWTtnfaUPPtDg-1;
	Mon, 30 Nov 2020 06:33:45 -0500
X-MC-Unique: wVbiaMoQOmWTtnfaUPPtDg-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R121e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
	TI=SMTPD_---0UH0DVk8_1606736019
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UH0DVk8_1606736019) by smtp.aliyun-inc.com(127.0.0.1);
	Mon, 30 Nov 2020 19:33:40 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com
Date: Mon, 30 Nov 2020 19:33:39 +0800
Message-Id: <20201130113339.42817-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 01 Dec 2020 06:23:42 -0500
Cc: joseph.qi@linux.alibaba.com, dm-devel@redhat.com
Subject: [dm-devel] [PATCH] dm crypt: export sysfs of kcryptd workqueue
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

It should be helpful to export sysfs of "kcryptd" workqueue in some
cases, such as setting specific CPU affinity of the workqueue.

Besides, also tweak the name format a little. The slash inside a
directory name will be translate into exclamation mark, such as
/sys/devices/virtual/workqueue/'kcryptd!253:0'.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/md/dm-crypt.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 392337f16ecf..6b4c1f674239 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3166,11 +3166,12 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	if (test_bit(DM_CRYPT_SAME_CPU, &cc->flags))
-		cc->crypt_queue = alloc_workqueue("kcryptd/%s", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
+		cc->crypt_queue = alloc_workqueue("kcryptd-%s", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
 						  1, devname);
 	else
-		cc->crypt_queue = alloc_workqueue("kcryptd/%s",
-						  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND,
+		cc->crypt_queue = alloc_workqueue("kcryptd-%s",
+						  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM |
+						  WQ_UNBOUND | WQ_SYSFS,
 						  num_online_cpus(), devname);
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

