Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60231C4332F
	for <dm-devel@archiver.kernel.org>; Fri, 11 Nov 2022 07:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668152367;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=w15Lr9Ig400nvpR7of4sWR33yMxoukPjKHbyHCDKM6g=;
	b=HuZrWvkLLeaOqh+5pdeYtZvTtbZniWcJC9L7Y548eRBHm92FKxc1yRnR9JWFi6Jo/GUWYc
	3jJfqhud7N21eIFyW1s2DNnpDRRvTRZU3MZavBvrgFbBxwW6SFhSSTYcga85DRaSaIfgrw
	xW7Rpclhzn/m4Pgvr0KhTsaVNvZHUjw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-83-u2UHyzpKOh2a-8UBxHPYhg-1; Fri, 11 Nov 2022 02:39:25 -0500
X-MC-Unique: u2UHyzpKOh2a-8UBxHPYhg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C59ED2999B51;
	Fri, 11 Nov 2022 07:39:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3A192202903F;
	Fri, 11 Nov 2022 07:39:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 212381946595;
	Fri, 11 Nov 2022 07:39:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 48D841946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 10 Nov 2022 18:45:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0FF282166B30; Thu, 10 Nov 2022 18:45:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 091212166B29
 for <dm-devel@redhat.com>; Thu, 10 Nov 2022 18:45:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE37C1C087A4
 for <dm-devel@redhat.com>; Thu, 10 Nov 2022 18:45:14 +0000 (UTC)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com
 [67.231.153.30]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569--YrOxgAdMCeneMtwzeirNQ-1; Thu, 10 Nov 2022 13:45:13 -0500
X-MC-Unique: -YrOxgAdMCeneMtwzeirNQ-1
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
 by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAIf64Q016781
 for <dm-devel@redhat.com>; Thu, 10 Nov 2022 10:45:12 -0800
Received: from maileast.thefacebook.com ([163.114.130.8])
 by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kr3jpfdps-4
 (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
 for <dm-devel@redhat.com>; Thu, 10 Nov 2022 10:45:12 -0800
Received: from twshared5287.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 10:45:10 -0800
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
 id BA18FB08CDE0; Thu, 10 Nov 2022 10:45:02 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <dm-devel@redhat.com>, <axboe@kernel.dk>
Date: Thu, 10 Nov 2022 10:44:56 -0800
Message-ID: <20221110184501.2451620-1-kbusch@meta.com>
X-FB-Internal: Safe
X-Proofpoint-GUID: eHQXTgR2JMk8PdC5Fyw41gZX4cXjXuzb
X-Proofpoint-ORIG-GUID: eHQXTgR2JMk8PdC5Fyw41gZX4cXjXuzb
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_12,2022-11-09_01,2022-06-22_01
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Fri, 11 Nov 2022 07:39:20 +0000
Subject: [dm-devel] [PATCHv2 0/5] fix direct io device mapper errors
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Keith Busch <kbusch@kernel.org>

The 6.0 kernel made some changes to the direct io interface to allow
offsets in user addresses. This based on the hardware's capabilities
reported in the request_queue's dma_alignment attribute.

dm-crypt, -log-writes and -integrity require direct io be aligned to the
block size. Since it was only ever using the default 511 dma mask, this
requirement may fail if formatted to something larger, like 4k, which
will result in unexpected behavior with direct-io.

Changes since v1: Added the same fix for -integrity and -log-writes

The first three were reported successfully tested by Dmitrii Tcvetkov,
but I don't have an official Tested-by: tag.

  https://lore.kernel.org/linux-block/20221103194140.06ce3d36@xps.demsh.org/T/#mba1d0b13374541cdad3b669ec4257a11301d1860

Keitio errors on Busch (5):
  block: make dma_alignment a stacking queue_limit
  dm-crypt: provide dma_alignment limit in io_hints
  block: make blk_set_default_limits() private
  dm-integrity: set dma_alignment limit in io_hints
  dm-log-writes: set dma_alignment limit in io_hints

 block/blk-core.c           |  1 -
 block/blk-settings.c       |  9 +++++----
 block/blk.h                |  1 +
 drivers/md/dm-crypt.c      |  1 +
 drivers/md/dm-integrity.c  |  1 +
 drivers/md/dm-log-writes.c |  1 +
 include/linux/blkdev.h     | 16 ++++++++--------
 7 files changed, 17 insertions(+), 13 deletions(-)

-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

