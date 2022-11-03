Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 273C4C4321E
	for <dm-devel@archiver.kernel.org>; Fri,  4 Nov 2022 06:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667544613;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=APofu6KFRLMbTJPuR60Qa4wl11bbgJubgk0EYpSJZx4=;
	b=Nr+QKsGMAERU31hr18uF8AVpyEzne2/v6ybhcp9KVC9tSZmUZTDZs80Dh6HaxYxCdAPtyH
	5M77ZO9dUMGBqYpB9UVi31Ijzv/lgz6bf1+YQaCNi3vSwHSbOZ7vzjWKNl0wnyosaH9ydL
	9yKAlxhwfEfiTTLfZneAme9wsq/4nfs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-gKENCJddMAinRibIL7wQWg-1; Fri, 04 Nov 2022 02:50:09 -0400
X-MC-Unique: gKENCJddMAinRibIL7wQWg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 359E280254B;
	Fri,  4 Nov 2022 06:50:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 206894EA61;
	Fri,  4 Nov 2022 06:50:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3FCD21946A7A;
	Fri,  4 Nov 2022 06:50:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 02F8D19465A4
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Nov 2022 15:26:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EABC12166B2E; Thu,  3 Nov 2022 15:26:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E40732166B26
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 15:26:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFF75101E152
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 15:26:15 +0000 (UTC)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com
 [67.231.153.30]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-XAv1ufVZMbqHY9q-P6ySfA-1; Thu, 03 Nov 2022 11:26:14 -0400
X-MC-Unique: XAv1ufVZMbqHY9q-P6ySfA-1
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
 by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3CAIaO010064
 for <dm-devel@redhat.com>; Thu, 3 Nov 2022 08:26:13 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
 by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kmddh1kr0-3
 (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
 for <dm-devel@redhat.com>; Thu, 03 Nov 2022 08:26:13 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub101.TheFacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 08:26:11 -0700
Received: from twshared25017.14.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 08:26:11 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
 id 6AAF0AA9A07C; Thu,  3 Nov 2022 08:26:00 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <dm-devel@redhat.com>, <axboe@kernel.dk>
Date: Thu, 3 Nov 2022 08:25:58 -0700
Message-ID: <20221103152559.1909328-3-kbusch@meta.com>
In-Reply-To: <20221103152559.1909328-1-kbusch@meta.com>
References: <20221103152559.1909328-1-kbusch@meta.com>
MIME-Version: 1.0
X-FB-Internal: Safe
X-Proofpoint-ORIG-GUID: JnUOgPTqxzf75w6-L3as-OdFPN25gmSp
X-Proofpoint-GUID: JnUOgPTqxzf75w6-L3as-OdFPN25gmSp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_04,2022-11-03_01,2022-06-22_01
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Fri, 04 Nov 2022 06:50:05 +0000
Subject: [dm-devel] [PATCH 2/3] dm-crypt: provide dma_alignment limit in
 io_hints
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
Cc: ebiggers@kernel.org, Keith Busch <kbusch@kernel.org>, mpatocka@redhat.com,
 me@demsh.org, stefanha@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Keith Busch <kbusch@kernel.org>

This device mapper needs bio vectors to be sized and memory aligned to
the logical block size. Set the minimum required queue limit
accordingly.

Fixes: b1a000d3b8ec5 ("block: relax direct io memory alignment")
Reportred-by: Eric Biggers <ebiggers@kernel.org>
Reported-by: Dmitrii Tcvetkov <me@demsh.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/md/dm-crypt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 159c6806c19b..2653516bcdef 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3630,6 +3630,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	limits->physical_block_size =
 		max_t(unsigned, limits->physical_block_size, cc->sector_size);
 	limits->io_min = max_t(unsigned, limits->io_min, cc->sector_size);
+	limits->dma_alignment = limits->logical_block_size - 1;
 }
 
 static struct target_type crypt_target = {
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

