Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F78CC433DB
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A3BDD2068D
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A3BDD2068D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-ZizKm-MxOmizBq3r6oJgsQ-1; Mon, 04 Jan 2021 14:04:12 -0500
X-MC-Unique: ZizKm-MxOmizBq3r6oJgsQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04ECF100C61F;
	Mon,  4 Jan 2021 19:03:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DDCB67094A;
	Mon,  4 Jan 2021 19:03:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B34741809CB7;
	Mon,  4 Jan 2021 19:03:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BOBkbpM022458 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 24 Dec 2020 06:46:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 020722166B2B; Thu, 24 Dec 2020 11:46:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F12172166B29
	for <dm-devel@redhat.com>; Thu, 24 Dec 2020 11:46:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 758B4101A53F
	for <dm-devel@redhat.com>; Thu, 24 Dec 2020 11:46:34 +0000 (UTC)
Received: from out30-45.freemail.mail.aliyun.com
	(out30-45.freemail.mail.aliyun.com [115.124.30.45]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-271-2wpbhELSOhmsGA6QHRVlgw-1;
	Thu, 24 Dec 2020 06:46:29 -0500
X-MC-Unique: 2wpbhELSOhmsGA6QHRVlgw-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R941e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
	TI=SMTPD_---0UJdL5GS_1608810377
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UJdL5GS_1608810377) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 24 Dec 2020 19:46:17 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com
Date: Thu, 24 Dec 2020 19:46:17 +0800
Message-Id: <20201224114617.77530-1-jefflexu@linux.alibaba.com>
In-Reply-To: <CALrw=nGkAgqPDCaYLKreD3+6MGZOW1krAfVfvV0mKH-rjHriFQ@mail.gmail.com>
References: <CALrw=nGkAgqPDCaYLKreD3+6MGZOW1krAfVfvV0mKH-rjHriFQ@mail.gmail.com>
MIME-Version: 1.0
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
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: joseph.qi@linux.alibaba.com, dm-devel@redhat.com, ignat@cloudflare.com
Subject: [dm-devel] [PATCH] dm crypt: fix sysfs name collision when
	reloading table
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The table reload routine will create new table, with the old table
preserved. In this case, the duplicate name collision will happen when
creating the sysfs directory for the workqueue of the newly created
table, since the old table has not been destroyed at that time.

One workaround for this issue is to add unique hash string to the name
of the sysfs directory. The value of dm_target pointer is used to
generate the hash.

This commit also fixes one hidden bug. Prior to this commit, 'devname'
is used to compensate the name of the workqueue. 'devname' represents
the name of the mapped device, such as '253:0', so there will be name
collision if one mapped device corresponds to multiple target devices.
Since currently a string hashed from dm_target pointer is added to the
name, different target device will have unique name now.

Since then, the exported sysfs directory will be named like
'kcryptd-252:0-3a512302'.

It is worth noting that some details need to be handled specifically.
The %p format of printk will print a hexadecimal string after hashing.
In 64-bit architecture, the output will be 16 bytes long, with the
previous 8 bytes zeroed, such as '00000000abcdef12'. Since the length
of the name of workqueue is limited to WQ_NAME_LEN, i.e. 24 bytes, the
previous 8 bytes zeroed need to be discarded.

Reported-by: Ignat Korchagin <ignat@cloudflare.com>
Fixes: a2b8b2d97567 ("dm crypt: export sysfs of kcryptd workqueue")
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/md/dm-crypt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 5f9f9b3a226d..31c153ca6f6c 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3169,10 +3169,11 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		cc->crypt_queue = alloc_workqueue("kcryptd-%s", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
 						  1, devname);
 	else
-		cc->crypt_queue = alloc_workqueue("kcryptd-%s",
+		cc->crypt_queue = alloc_workqueue("kcryptd-%s-%8p",
 						  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM |
 						  WQ_UNBOUND | WQ_SYSFS,
-						  num_online_cpus(), devname);
+						  num_online_cpus(), devname, ti);
+
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
 		goto bad;
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

