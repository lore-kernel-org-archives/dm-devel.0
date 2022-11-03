Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8E7CC43219
	for <dm-devel@archiver.kernel.org>; Fri,  4 Nov 2022 06:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667544612;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Nik1ToNz+py1MOOECADkLTeRsHrhLZNEDYQqZvxOQog=;
	b=aTfFS08eF6hAhiiWu42Cao3E/zcJPrwb0t/WdBJDWYCWV4wTptvWFzp2cW1iI8LvTwjpqL
	e7JOb1lqK/xDzt4D+4O1hPd55REMryx1uaVaz1eJTB0cS5qbBF1mBAzQBNk8H4RCE57rBO
	GDgKXhjYF4WKQp25kSZGGdvz9yFQlSg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-iPGegeInMRWAQ78DT1w69Q-1; Fri, 04 Nov 2022 02:50:11 -0400
X-MC-Unique: iPGegeInMRWAQ78DT1w69Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A247A1C07831;
	Fri,  4 Nov 2022 06:50:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8CB841121339;
	Fri,  4 Nov 2022 06:50:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 350BD1946A67;
	Fri,  4 Nov 2022 06:50:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AE0381946594
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Nov 2022 15:26:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 467E6C16932; Thu,  3 Nov 2022 15:26:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FB90C15BAB
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 15:26:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26089811E7A
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 15:26:14 +0000 (UTC)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com
 [67.231.153.30]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-342-BCYw2X8eMoKwQyHqE45a0w-1; Thu, 03 Nov 2022 11:26:12 -0400
X-MC-Unique: BCYw2X8eMoKwQyHqE45a0w-1
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
 by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3CAdCC010471
 for <dm-devel@redhat.com>; Thu, 3 Nov 2022 08:26:10 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
 by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kmddh1kqu-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
 for <dm-devel@redhat.com>; Thu, 03 Nov 2022 08:26:10 -0700
Received: from twshared21592.39.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 08:26:09 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
 id 1652BAA9A072; Thu,  3 Nov 2022 08:26:00 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <dm-devel@redhat.com>, <axboe@kernel.dk>
Date: Thu, 3 Nov 2022 08:25:56 -0700
Message-ID: <20221103152559.1909328-1-kbusch@meta.com>
MIME-Version: 1.0
X-FB-Internal: Safe
X-Proofpoint-ORIG-GUID: pMNS0Cf10Z4Q6ms5YljpsJs1NQpNlVAB
X-Proofpoint-GUID: pMNS0Cf10Z4Q6ms5YljpsJs1NQpNlVAB
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Fri, 04 Nov 2022 06:50:05 +0000
Subject: [dm-devel] [PATCH 0/3] fix direct io errors on dm-crypt
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Keith Busch <kbusch@kernel.org>

The 6.0 kernel made some changes to the direct io interface to allow
offsets in user addresses. This based on the hardware's capabilities
reported in the request_queue's dma_alignment attribute.

dm-crypt requires direct io be aligned to the block size. Since it was
only ever using the default 511 dma mask, this requirement may fail if
formatted to something larger, like 4k, which will result in unexpected
behavior with direct-io.

There are two parts to fixing this:

  First, the attribute needs to be moved to the queue_limit so that it
  can properly stack with device mappers.

  Second, dm-crypt provides its minimum required limit to match the
  logical block size.

Keith Busch (3):
  block: make dma_alignment a stacking queue_limit
  dm-crypt: provide dma_alignment limit in io_hints
  block: make blk_set_default_limits() private

 block/blk-core.c       |  1 -
 block/blk-settings.c   |  9 +++++----
 block/blk.h            |  1 +
 drivers/md/dm-crypt.c  |  1 +
 include/linux/blkdev.h | 16 ++++++++--------
 5 files changed, 15 insertions(+), 13 deletions(-)

-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

