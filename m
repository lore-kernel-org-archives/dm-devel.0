Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DA43C74A5B
	for <dm-devel@archiver.kernel.org>; Tue, 21 Mar 2023 07:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679385262;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=gQYNMR3tLtQz0A9tHWAYO7IyVK2YZ6TdLx+81Ya4PrE=;
	b=WvHqHmKFawsxw8N/LEVRnRGVHjcZvM8Ug2Fj+geW4nHAvhzWzseRyTQbZmewkojHLQoDwu
	qq1AsBpo2AsM5OHNI9JRdozQ41+9TVyjbThv+DNitkXgnYsmrfZxW5+PI7Y0SuW2t9AnXx
	OvuD83YJqficRKjNaDvPnEKqqTsaDwY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-471-u1BKgoQPNCGl9EmHwdXAxQ-1; Tue, 21 Mar 2023 03:54:19 -0400
X-MC-Unique: u1BKgoQPNCGl9EmHwdXAxQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19A59185A78F;
	Tue, 21 Mar 2023 07:54:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 065131410F1C;
	Tue, 21 Mar 2023 07:54:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3BD5A19465BA;
	Tue, 21 Mar 2023 07:54:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5A8D6194658F
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Mar 2023 07:00:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 48ACE2027062; Mon, 20 Mar 2023 07:00:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 409022027061
 for <dm-devel@redhat.com>; Mon, 20 Mar 2023 07:00:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16BA03C025C3
 for <dm-devel@redhat.com>; Mon, 20 Mar 2023 07:00:18 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-0t_tHPq6O_ilz9i8H5RloA-1; Mon, 20 Mar 2023 03:00:16 -0400
X-MC-Unique: 0t_tHPq6O_ilz9i8H5RloA-1
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20230320070013epoutp044158365770d4e743188d0de448781375~ODnaPNgIU1556115561epoutp04L
 for <dm-devel@redhat.com>; Mon, 20 Mar 2023 07:00:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20230320070013epoutp044158365770d4e743188d0de448781375~ODnaPNgIU1556115561epoutp04L
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas1p3.samsung.com (KnoxPortal) with ESMTP id
 20230320070012epcas1p36c5e1f20bd123cec8429b50e82a6f4e0~ODnZwRs1g1653816538epcas1p37;
 Mon, 20 Mar 2023 07:00:12 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.38.243]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4Pg5GN3m2qz4x9QY; Mon, 20 Mar
 2023 07:00:12 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
 epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
 9F.29.37890.B7408146; Mon, 20 Mar 2023 16:00:11 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20230320070011epcas1p12f0fe9f9f417dd1a3441efdde55a4132~ODnYa5gYz3100631006epcas1p1S;
 Mon, 20 Mar 2023 07:00:11 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230320070011epsmtrp2f33d745215f7c0110b43a63ec5690021~ODnYZt3m11173411734epsmtrp2n;
 Mon, 20 Mar 2023 07:00:11 +0000 (GMT)
X-AuditID: b6c32a38-bbd3aa8000029402-6a-6418047b3fc6
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 DA.9D.31821.B7408146; Mon, 20 Mar 2023 16:00:11 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.99.41]) by
 epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20230320070011epsmtip1f578457078a6d396ae62894c2ca4fb55~ODnYPeYYN1527015270epsmtip1f;
 Mon, 20 Mar 2023 07:00:11 +0000 (GMT)
From: Yeongjin Gil <youngjin.gil@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
 ebiggers@kernel.org
Date: Mon, 20 Mar 2023 15:59:32 +0900
Message-Id: <20230320065932.28116-1-youngjin.gil@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIJsWRmVeSWpSXmKPExsWy7bCmrm41i0SKwdoVBhbrTx1jttj7bjar
 xdo9f5gtLu+aw2ax5d8RVosTt6QtFmx8xGgxY/9TdgcOj02rOtk83u+7yubRt2UVo8fnTXIB
 LFENjDaJRckZmWWpCql5yfkpmXnptkqhIW66FkoKGfnFJbZK0YaGRnqGBuZ6RkZGeqZGsVZG
 pkoKeYm5qbZKFbpQvUoKRckFQLW5lcVAA3JS9aDiesWpeSkOWfmlIKfrFSfmFpfmpesl5+cq
 KZQl5pQCjVDST/jGmLHg0CXWgi88FR/3L2BuYLzP1cXIwSEhYCKx6ZxDFyMXh5DADkaJmdcn
 skE4nxglZt3uYIFwPjNKbJo3l6mLkROs40LrF0aIxC5GielLtrPCtZw+voQZpIpNQFdi6sun
 rCC2iECQxJPmXWBzmQW6GCWae56CFQkLBErc2DeTBcRmEVCVeNE8gRHkKF4BW4lHPfUQ2+Ql
 GjvOsYPYvAKCEidnPgErZwaKN2+dzQwyU0LgHLvE/4lbGCEaXCTuXdrADGELS7w6voUdwpaS
 +PxuLxtEQzujxIqHcxghnBmMEn/f32eFqLKXaG5tZgO5gllAU2L9Ln2IsKLEzt9zoRYISpy+
 1s0McQWfxLuvPayQkOSV6GgTgihRk7gy6RfURBmJvgezoG7wkGh6cw+sVUggVuJ31wyWCYwK
 s5D8NgvJb7MQjljAyLyKUSy1oDg3PbXYsMAEOZY3MYJTq5bFDsa5bz/oHWJk4mA8xCjBwawk
 wuvGLJEixJuSWFmVWpQfX1Sak1p8iDEZGNgTmaVEk/OByT2vJN7QzMzSwtLIxNDYzNCQsLCJ
 pYGJmZGJhbGlsZmSOK+47clkIYH0xJLU7NTUgtQimC1MHJxSDUy8N3R2iwnLfbaOPfPglLdM
 wdSnWqurzt5T37zjwobJ21//7fJTdLd+0XO+U2VFKUPnoub/7rMn9TyYPKVbX+y03K8jd9/9
 faT5o/zxPeGS/Quq910RkNPYK1LD4DTF1ipT5l70MrZj2k39OemKLUsffH48VeNBxaeabStE
 V+7qWfhpw+SeH/0m1x9bXD9x5F3sWgZmT7WpvVl9cffFp3tqTJ/3/swMi2IzeU7ePavcfqxU
 3G537vJmh67NScrbou0dlWKW79zQ9y++QHitX79f+jTWqpcPpK80OXsZeNy2vLh9rt9Uzx9z
 POLr9hkuX7G/j3VvyqutryKlmLY5rRAWv/YjfDLvRAbOctc3d1S0lViKMxINtZiLihMBWYP2
 gGQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsWy7bCSnG41i0SKwZwZEhbrTx1jttj7bjar
 xdo9f5gtLu+aw2ax5d8RVosTt6QtFmx8xGgxY/9TdgcOj02rOtk83u+7yubRt2UVo8fnTXIB
 LFFcNimpOZllqUX6dglcGQsOXWIt+MJT8XH/AuYGxvtcXYycHBICJhIXWr8wdjFycQgJ7GCU
 +Pf2DTNEQkbiz8T3bF2MHEC2sMThw8UQNR8YJbZdv84KUsMmoCsx9eVTMFtEIEzix7Q7TCBF
 zAJ9jBJ7L71lB0kIC/hL3Lj1C2woi4CqxIvmCYwgQ3kFbCUe9dRD7JKXaOw4B1bOKyAocXLm
 ExYQmxko3rx1NvMERr5ZSFKzkKQWMDKtYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQI
 DlEtrR2Me1Z90DvEyMTBeIhRgoNZSYTXjVkiRYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T
 8UIC6YklqdmpqQWpRTBZJg5OqQYmQZYzNuw/zb5EvMi/ob48IjD6xrnkoIAVfOG5L6K3nlhd
 fPcXn5T5yx1XD1TWul9KTLB5793Q8WMLs/hZtjfpPCzbAncwPVrmfrIuQ9h9a73lLBd3yaiv
 IZIVl/XV+QIkLp/U1PhR8f0xH5O3QyDHYtntXtp/ORlLvVNXVm77qJcUoRXvNuNc1+muk8Ua
 Jv+bst0Ka3qe1htcXTbpi6FywuX5f0sjv7eFCkWc1p815ZnFTTUHhk0HZLNqODdJ7dBkdf+l
 4i026WJ0T0r5s66iefFqt15nRQTdjNeqZ2h9ltFV9SR+j8S2Oc2hOZ35tTkfHrr4FDWt7d/x
 wuNnqp3/Z80DJu8WGM2SmB/Zo8RSnJFoqMVcVJwIALLTqgLAAgAA
X-CMS-MailID: 20230320070011epcas1p12f0fe9f9f417dd1a3441efdde55a4132
X-Msg-Generator: CA
X-Sendblock-Type: SVC_REQ_APPROVE
X-ArchiveUser: EV
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230320070011epcas1p12f0fe9f9f417dd1a3441efdde55a4132
References: <CGME20230320070011epcas1p12f0fe9f9f417dd1a3441efdde55a4132@epcas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Tue, 21 Mar 2023 07:54:06 +0000
Subject: [dm-devel] [PATCH v2] dm verity: fix error handling for
 check_at_most_once on FEC
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
Cc: Sungjong Seo <sj1557.seo@samsung.com>,
 Yeongjin Gil <youngjin.gil@samsung.com>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In verity_end_io(), if bi_status is not BLK_STS_OK, it can be return
directly. But if FEC configured, it is desired to correct the data page
through verity_verify_io. And the return value will be converted to
blk_status and passed to verity_finish_io().

BTW, when a bit is set in v->validated_blocks, verity_verify_io() skips
verification regardless of I/O error for the corresponding bio. In this
case, the I/O error could not be returned properly, and as a result,
there is a problem that abnormal data could be read for the
corresponding block.

To fix this problem, when an I/O error occurs, do not skip verification
even if the bit related is set in v->validated_blocks.

Fixes: 843f38d382b1 ("dm verity: add 'check_at_most_once' option to only validate hashes once")
Cc: stable@vger.kernel.org
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Yeongjin Gil <youngjin.gil@samsung.com>
---
v2:
-change commit message and tag
---
 drivers/md/dm-verity-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index ade83ef3b439..9316399b920e 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -523,7 +523,7 @@ static int verity_verify_io(struct dm_verity_io *io)
 		sector_t cur_block = io->block + b;
 		struct ahash_request *req = verity_io_hash_req(v, io);
 
-		if (v->validated_blocks &&
+		if (v->validated_blocks && bio->bi_status == BLK_STS_OK &&
 		    likely(test_bit(cur_block, v->validated_blocks))) {
 			verity_bv_skip_block(v, io, iter);
 			continue;
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

