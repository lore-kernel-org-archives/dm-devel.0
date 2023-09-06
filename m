Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDB6CEE14C1
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 17:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694023143;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nr5fr4DhnesfF6zZi7QmetQXrkYMJ/X9frGOpxNOu/k=;
	b=QEnn99/qXR7lKAW0nSLpPQfViPCvzumtiIwqWXLHiRE4fOAjpvFjIbHQobI712Ss20gdnb
	SST/XTNMFHH6FGQ753yv2ibC6grnszSNetmVmGamcTc+av/L9iQb8+9UltfxuhcV56fZo6
	Qz0tGkQ6cDCGvyVVUeya/i67h1amdE4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-278-QOviJElnNze1FCv1MAo5_w-1; Wed, 06 Sep 2023 13:57:58 -0400
X-MC-Unique: QOviJElnNze1FCv1MAo5_w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9ABCB181793F;
	Wed,  6 Sep 2023 17:55:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5482D405221C;
	Wed,  6 Sep 2023 17:55:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 20BF619465B9;
	Wed,  6 Sep 2023 17:55:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 666C71946595
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 17:55:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4DEBD493112; Wed,  6 Sep 2023 17:55:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 46646493110
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 17:55:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C7258279A5
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 17:55:01 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-240-nrsHtkTdMwaOQiGmy4uanQ-1; Wed, 06 Sep 2023 13:54:57 -0400
X-MC-Unique: nrsHtkTdMwaOQiGmy4uanQ-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20230906175454epoutp037f8e1401bada642e125a95bb387dd563~CYNjzcauW1073410734epoutp03v
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 17:54:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20230906175454epoutp037f8e1401bada642e125a95bb387dd563~CYNjzcauW1073410734epoutp03v
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTP id
 20230906175454epcas5p483de28cee6d9f82f3587eefdad7fd868~CYNjW53Q01892318923epcas5p4b;
 Wed,  6 Sep 2023 17:54:54 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.178]) by
 epsnrtp4.localdomain (Postfix) with ESMTP id 4RgqlJ40Wxz4x9Pq; Wed,  6 Sep
 2023 17:54:52 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
 57.04.19094.CECB8F46; Thu,  7 Sep 2023 02:54:52 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
 20230906164425epcas5p4275f672db2cfe129f666d8c929cbd095~CXQBASmK33062630626epcas5p42;
 Wed,  6 Sep 2023 16:44:25 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230906164425epsmtrp1b8691dfa3eb0aeb501c8a7fe38dc1785~CXQA-ThoJ0455204552epsmtrp1J;
 Wed,  6 Sep 2023 16:44:25 +0000 (GMT)
X-AuditID: b6c32a50-64fff70000004a96-e3-64f8bcec4df9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 55.86.08649.96CA8F46; Thu,  7 Sep 2023 01:44:25 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230906164422epsmtip2fddc6ff2b840387871c20033ad2c4f9f~CXP_RKkz_0127201272epsmtip2i;
 Wed,  6 Sep 2023 16:44:22 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair
 Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
 <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>
Date: Wed,  6 Sep 2023 22:08:36 +0530
Message-Id: <20230906163844.18754-12-nj.shetty@samsung.com>
In-Reply-To: <20230906163844.18754-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxbZRTOe+/t5RYpXgrE1y58WGaydQNaLfWisM2B8yqLkkz8sZhBQ29a
 QmmbfgxBg90QGEwoMAlSQNiodcCAURkiXyKjwDATdRnrqlBNIGaAfIzJFgdoS0H373mec857
 znPeHALlruM8IkOlZ7QqqZKP+2Ld1/cLIhf7H8mEpmke1TExilJnyzdRqnXahFML1+8Danao
 CFADS7Us6u7QNwjV3GpHqMrhKUDN3TYj1IDzAHWx0IJR/QM3MOpWbx1ONVjnfKgvx7YQylE+
 B6juxw0o1b6wjFHjzj3U5OYY60gwPTnTidG3bhpoW0sxTn9l+Yjuu2vE6aayCyy6NH8Jp1fn
 nBi9PHgbp8u6WgC9ZgulbbN/Isl+JzPjFIxUxmjDGVW6Wpahksfzk06kJqTGSISiSFEs9RI/
 XCXNYuL5iceTI49lKN1e+eGnpUqDW0qW6nT86ENxWrVBz4Qr1Dp9PJ/RyJQasSZKJ83SGVTy
 KBWjf1kkFL4Q405My1R8sfgZS+Pkvl9hLGIZweLTJYBNQFIMXWVLaAnwJbhkP4Abha075D6A
 NV3zmJesA9jlqEB2S36v62F5AwMAmhqKfbykAIHWpTZQAggCJw/A7/8hPHoQaUTh1b4m4CEo
 2Y7AGsvPqOepQPJ1+Effio8HY+TzsNv29bbOIV+Bxl+tLM9DkIyGJleAR2a75bNnfgLelAB4
 o2YW82CUDIP512q354ZkERu2ls1j3lETof3Buo8XB8L5sa4dzIP3TIU7OBs2f3oZ9xZ/DKD5
 jhl4A4dhwYQJ9QyBkvthR2+0Vw6BVRPtiLexPyx9PLuzFg7s+XwXR8ArHY24Fz8Lpx6ewb1e
 aLh1M9Mjc8kyAEfuvVMOws1P2DE/Ycf8f+NGgLYAHqPRZcmZ9BiNKFLFZP/3zenqLBvYPgBB
 cg9ovboZNQwQAgwDSKD8IM5S2LqMy5FJc3IZrTpVa1AyumEQ4953BcoLTle7L0ilTxWJY4Vi
 iUQijn1RIuI/w1koqJdxSblUz2QyjIbR7tYhBJtnRKrjI9d/TNELq2I2bEnLzfb8vVJ7lJ+C
 0/ndcKM/4bKItUHxXb+4zj/Ffnc+ezVpazW4In2tOoTfXde8Epcmn6/FTjinqlWXXddyHDnO
 T07dyX07opk4HJdXa7UNTYcMimNBzkbBoCCw31dpTQlcSagx+B0/qP9LvncGX7Gkncsd9xld
 O6nZmImtV85V5BXYJZUTFogcu/Tt5MUPQ2yCt3RNB2eSRRFhH+yzTjykekec9SVvvBpQXM3T
 LuddOT+SkrDYtifRwVYYUkLaUg4lVT0oLQ8YzdA898j/yNRvb0rPtbN+6AwVhrou/U2EOiqP
 vncqyTF+2i5gjgZ39yP7XuNjOoVUJEC1Oum/DsYkgIkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWy7bCSvG7mmh8pBtdaRSzWnzrGbNE04S+z
 xeq7/WwWrw9/YrR4cqCd0WLvu9msFjcP7GSyWLn6KJPFpEPXGC2eXp3FZLH3lrbFwrYlLBZ7
 9p5ksbi8aw6bxfxlT9ktlh//x2RxY8JTRottv+czW6x7/Z7F4sQtaYvzf4+zOoh6nL+3kcXj
 8tlSj02rOtk8Ni+p99h9s4HNY3HfZFaP3uZ3bB4fn95i8Xi/7yqbR9+WVYwenzfJeWx68pYp
 gCeKyyYlNSezLLVI3y6BK2PpmxmsBbeEKiY2tLM2ML7h72Lk5JAQMJF4OGcHaxcjF4eQwG5G
 iev3e9ggEpISy/4eYYawhSVW/nvODlHUzCTR/m0uSxcjBwebgLbE6f8cIHERgS5mic6d71hA
 HGaBHUwSz/+3sYN0Cwu4Szzf/QHMZhFQldi2aTvYVF4Ba4mGO8tYQQZJCOhL9N8XBAlzAoWb
 Gi8ygthCAlYSd1a9ZoQoF5Q4OfMJC4jNLCAv0bx1NvMERoFZSFKzkKQWMDKtYpRMLSjOTc9N
 NiwwzEst1ytOzC0uzUvXS87P3cQIjlAtjR2M9+b/0zvEyMTBeIhRgoNZSYT3nfy3FCHelMTK
 qtSi/Pii0pzU4kOM0hwsSuK8hjNmpwgJpCeWpGanphakFsFkmTg4pRqYaifvcDzvHtVy92nz
 st3WW8K/FsnIZpv5MV1dOTdcbpU8S9Jzb7WoDUZ/NCaITHPUmdh7/l6cbcGazTEJdq9Dz4Y5
 7a43uD9D6PzB5yrhE9ZqM6po8748dO96oen5mTsMGThiqyep7ZzIeP+ceZn9nAMqDge97Hec
 jOe7kBAWxFklVXXeeDPDlK6we0Eq5l6J/e/+nQisei8u13Ij+/Xho77Ly5bU2i66d/Dem/Vz
 2TzWiGusjm9TbpfJNdu1+pTHFt/YPdJTpi9z8lte9lllptDLxYlMvKUmsW3//ldHm08RvRjC
 p2/ya7PhBvYGqTPp6ksfdWpMmi3mll+ldSph+meOF+HN8gatXs1O2ReVWIozEg21mIuKEwHl
 CyCePwMAAA==
X-CMS-MailID: 20230906164425epcas5p4275f672db2cfe129f666d8c929cbd095
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230906164425epcas5p4275f672db2cfe129f666d8c929cbd095
References: <20230906163844.18754-1-nj.shetty@samsung.com>
 <CGME20230906164425epcas5p4275f672db2cfe129f666d8c929cbd095@epcas5p4.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH v15 11/12] null: Enable trace capability for null
 block
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
Cc: martin.petersen@oracle.com, linux-doc@vger.kernel.org, gost.dev@samsung.com,
 Anuj Gupta <anuj20.g@samsung.com>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, mcgrof@kernel.org,
 linux-fsdevel@vger.kernel.org, Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a prep patch to enable copy trace capability.
At present only zoned null_block is using trace, so we decoupled trace
and zoned dependency to make it usable in null_blk driver also.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/block/null_blk/Makefile | 2 --
 drivers/block/null_blk/main.c   | 3 +++
 drivers/block/null_blk/trace.h  | 2 ++
 drivers/block/null_blk/zoned.c  | 1 -
 4 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/block/null_blk/Makefile b/drivers/block/null_blk/Makefile
index 84c36e512ab8..672adcf0ad24 100644
--- a/drivers/block/null_blk/Makefile
+++ b/drivers/block/null_blk/Makefile
@@ -5,7 +5,5 @@ ccflags-y			+= -I$(src)
 
 obj-$(CONFIG_BLK_DEV_NULL_BLK)	+= null_blk.o
 null_blk-objs			:= main.o
-ifeq ($(CONFIG_BLK_DEV_ZONED), y)
 null_blk-$(CONFIG_TRACING) 	+= trace.o
-endif
 null_blk-$(CONFIG_BLK_DEV_ZONED) += zoned.o
diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 864013019d6b..b48901b2b573 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -11,6 +11,9 @@
 #include <linux/init.h>
 #include "null_blk.h"
 
+#define CREATE_TRACE_POINTS
+#include "trace.h"
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"null_blk: " fmt
 
diff --git a/drivers/block/null_blk/trace.h b/drivers/block/null_blk/trace.h
index 6b2b370e786f..91446c34eac2 100644
--- a/drivers/block/null_blk/trace.h
+++ b/drivers/block/null_blk/trace.h
@@ -30,6 +30,7 @@ static inline void __assign_disk_name(char *name, struct gendisk *disk)
 }
 #endif
 
+#ifdef CONFIG_BLK_DEV_ZONED
 TRACE_EVENT(nullb_zone_op,
 	    TP_PROTO(struct nullb_cmd *cmd, unsigned int zone_no,
 		     unsigned int zone_cond),
@@ -67,6 +68,7 @@ TRACE_EVENT(nullb_report_zones,
 	    TP_printk("%s nr_zones=%u",
 		      __print_disk_name(__entry->disk), __entry->nr_zones)
 );
+#endif /* CONFIG_BLK_DEV_ZONED */
 
 #endif /* _TRACE_NULLB_H */
 
diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index 55c5b48bc276..9694461a31a4 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -3,7 +3,6 @@
 #include <linux/bitmap.h>
 #include "null_blk.h"
 
-#define CREATE_TRACE_POINTS
 #include "trace.h"
 
 #undef pr_fmt
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

