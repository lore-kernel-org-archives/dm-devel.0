Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB6E6C74A5B
	for <dm-devel@archiver.kernel.org>; Fri, 17 Mar 2023 14:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679064410;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=BCDI7zzDdBAWafLD8kpN6QE9xprSqT8EreXeEmLMZBw=;
	b=AzWftO+O2FrardBOnWf/LtGW+Z2vSzF4Jcq4Wbv9etWAr3sb0+qDgp3nECk1I1XbBVWTAE
	kTgdmknPIsstZeGYM7bzXdTSs2bsoOsTIT23WDwvDPBZLDX3kZHfcWrqgVzdEfwhFXIMaM
	f/lLTmhYTww6kd6Wmj7iP93oClKo6cc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-pQGlGTNXNle5hbyQ-7u-xA-1; Fri, 17 Mar 2023 10:46:49 -0400
X-MC-Unique: pQGlGTNXNle5hbyQ-7u-xA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49661101A552;
	Fri, 17 Mar 2023 14:46:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0CE9E1121315;
	Fri, 17 Mar 2023 14:46:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B5D661946597;
	Fri, 17 Mar 2023 14:46:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0E3DE1946597
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Mar 2023 03:26:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9709DC158C2; Thu, 16 Mar 2023 03:26:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E5FAC15A0B
 for <dm-devel@redhat.com>; Thu, 16 Mar 2023 03:26:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 730B02814240
 for <dm-devel@redhat.com>; Thu, 16 Mar 2023 03:26:18 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-BOmZnSwhM4WIkeeo_d4tIg-1; Wed, 15 Mar 2023 23:26:16 -0400
X-MC-Unique: BOmZnSwhM4WIkeeo_d4tIg-1
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20230316031940epoutp049823acfae54616829e789364e32e0fc9~MyBs73Psi3165031650epoutp04-
 for <dm-devel@redhat.com>; Thu, 16 Mar 2023 03:19:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20230316031940epoutp049823acfae54616829e789364e32e0fc9~MyBs73Psi3165031650epoutp04-
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas1p4.samsung.com (KnoxPortal) with ESMTP id
 20230316031940epcas1p4caa8b32f085acd38d3d98e6baa0de599~MyBsl-9vU2301623016epcas1p47;
 Thu, 16 Mar 2023 03:19:40 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.38.241]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4PcXYl4G4Qz4x9Q5; Thu, 16 Mar
 2023 03:19:39 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
 epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
 97.98.54823.8CA82146; Thu, 16 Mar 2023 12:19:36 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20230316031936epcas1p1ebd93477dcf3bf9ab1640306dd1da8ff~MyBpa58kf2332323323epcas1p1c;
 Thu, 16 Mar 2023 03:19:36 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230316031936epsmtrp1a883352cb7166f657325f6a3b10bbcaf~MyBpaMa_20887908879epsmtrp1z;
 Thu, 16 Mar 2023 03:19:36 +0000 (GMT)
X-AuditID: b6c32a39-a97ff7000000d627-52-64128ac87ef3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 AC.71.18071.8CA82146; Thu, 16 Mar 2023 12:19:36 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.99.41]) by
 epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230316031936epsmtip29bbf332b78a1d49bb5febf990943fc99~MyBpQ25921011610116epsmtip2L;
 Thu, 16 Mar 2023 03:19:36 +0000 (GMT)
From: Yeongjin Gil <youngjin.gil@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com
Date: Thu, 16 Mar 2023 12:18:42 +0900
Message-Id: <20230316031842.17295-1-youngjin.gil@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJsWRmVeSWpSXmKPExsWy7bCmge6JLqEUg31HjS3WnzrGbLH33WxW
 i8u75rBZbPl3hNXixC1pi43PGC1m7H/K7sDusWBTqcemVZ1sHu/3XWXz6NuyitHj8ya5ANao
 BkabxKLkjMyyVIXUvOT8lMy8dFul0BA3XQslhYz84hJbpWhDQyM9QwNzPSMjIz1To1grI1Ml
 hbzE3FRbpQpdqF4lhaLkAqDa3MpioAE5qXpQcb3i1LwUh6z8UpDD9YoTc4tL89L1kvNzlRTK
 EnNKgUYo6Sd8Y8w4uv4iY8FS7op12z6zNDDu4Oxi5OSQEDCR+LnyA3MXIxeHkMAORonDy06z
 QzifGCWmPHvJCOF8Y5TYuvAsC0zLx+fvWCASexklVu+ZzQiSAGuZuc4TxGYT0JWY+vIpK4gt
 ImAt8aJpJlgDs0ALo8TaR2+YQRLCAq4Sn2edYAexWQRUJW7d7wEaxMHBK2Ar8eWwMogpISAv
 sfiBBEgFr4CgxMmZT8BuYAYKN2+dDXa2hMAldonH05uhjnOR2HJ4LTOELSzx6vgWdghbSuJl
 fxs7REM7o8SKh3MYIZwZjBJ/399nhaiyl2hubWYD2cwsoCmxfpc+RFhRYufvuYwQtqDE6Wvd
 zBBX8Em8+9rDCnEor0RHmxBEiZrElUm/oCbKSPQ9mAV1g4fExE8dTJCwipW4NH870wRGhVlI
 fpuF5LdZCEcsYGRexSiWWlCcm55abFhgihzJmxjBSVXLcgfj9Lcf9A4xMnEwHmKU4GBWEuEN
 ZxFIEeJNSaysSi3Kjy8qzUktPsSYDAzricxSosn5wLSeVxJvaGZmaWFpZGJobGZoSFjYxNLA
 xMzIxMLY0thMSZxX3PZkspBAemJJanZqakFqEcwWJg5OqQamRlunZ/4SV28yRnoyJBhfX7dS
 YJEc4/5CptCGRxyh799tEXsaE2d+wNrqtl/mzxLPR0F21qULlj+dnmtY/83N6cTKnOmG79+t
 vc3spu7J9q5o35wjF9b5aj0oZl5Yy9+uJje9/eTky7dmJ31Ub1IwMbxmqHnc6F14k+6SQyuL
 n+/+9lbjgkMi79Lfx6tvsYqUZMl7rfrkFOjz8VoDM+N87o1fbfznvTkX/PeujyIjz8tvC0/x
 O034+UH79faVr2Jdv//l+CJcp6AVVd30v/orp/Ak7SKrLd/WNMzYp2SSHOqXXM/uzu/zrXPd
 5u+9nbbLpn/r6vleLbuU+dj7QpY9SZtfuK7cZL95eu/MAtcyJZbijERDLeai4kQApGvIz2EE
 AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsWy7bCSvO6JLqEUg3PtShbrTx1jttj7bjar
 xeVdc9gstvw7wmpx4pa0xcZnjBYz9j9ld2D3WLCp1GPTqk42j/f7rrJ59G1ZxejxeZNcAGsU
 l01Kak5mWWqRvl0CV8bR9RcZC5ZyV6zb9pmlgXEHZxcjJ4eEgInEx+fvWLoYuTiEBHYzSuzq
 WsIOkZCR+DPxPVsXIweQLSxx+HAxRM0HRokNh28ygdSwCehKTH35lBXEFhGwl3h6bSsbSBGz
 QAejRPeSlWwgCWEBV4nPs06ADWURUJW4db+HEWQor4CtxJfDyhDz5SUWP5AAqeAVEJQ4OfMJ
 C4jNDBRu3jqbeQIj3ywkqVlIUgsYmVYxSqYWFOem5xYbFhjmpZbrFSfmFpfmpesl5+duYgQH
 p5bmDsbtqz7oHWJk4mA8xCjBwawkwhvOIpAixJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4
 IYH0xJLU7NTUgtQimCwTB6dUA1Ne5PplWhLRh9iF/Rb+6bXuje6e+sH236sPVa98yi9fiVlQ
 uzfn/omutCkRvYFtztqXH3xeVnp3jWz4ris8CyIOarr4ia9V+W6+VEfpzoW4onaro+4CClOl
 u9kuFvx4FSYUIhD462WRsL1EZfeBtDkno1y+bP/lzHTVz0T/4oIDD0TTuY/FtM8o7TU+s/v7
 6hfPWBxchCrW+eutYo2YLcqy43zvO+4Ul1uuH99k8SmyTQ9iUa1h4zh1NXvJ5wneH+Qatv1j
 mjC79ftO3edOoe59Lff2z81QuaCQMH/1YrkXN689Znuu+iy+3++Rv+uHmx9X7+s7Vh6jXrnk
 YYzF/JYHrZxFn7ZuC29KU3o556sSS3FGoqEWc1FxIgCC9DHavQIAAA==
X-CMS-MailID: 20230316031936epcas1p1ebd93477dcf3bf9ab1640306dd1da8ff
X-Msg-Generator: CA
X-Sendblock-Type: SVC_REQ_APPROVE
X-ArchiveUser: EV
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230316031936epcas1p1ebd93477dcf3bf9ab1640306dd1da8ff
References: <CGME20230316031936epcas1p1ebd93477dcf3bf9ab1640306dd1da8ff@epcas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Thu, 16 Mar 2023 07:16:13 +0000
Subject: [dm-devel] [PATCH] dm verity: fix error handling for
 check_at_most_once
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
Cc: Yeongjin Gil <youngjin.gil@samsung.com>,
 Sungjong Seo <sj1557.seo@samsung.com>, totte@google.com,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In verity_work(), the return value of verity_verify_io() is converted to
blk_status and passed to verity_finish_io(). BTW, when a bit is set in
v->validated_blocks, verity_verify_io() skips verification regardless of
I/O error for the corresponding bio. In this case, the I/O error could
not be returned properly, and as a result, there is a problem that
abnormal data could be read for the corresponding block.

To fix this problem, when an I/O error occurs, do not skip verification
even if the bit related is set in v->validated_blocks.

Fixes: 843f38d382b1 ("dm verity: add 'check_at_most_once' option to only validate hashes once")

Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Yeongjin Gil <youngjin.gil@samsung.com>
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
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

