Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDBC7EE14C5
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 17:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694022917;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=C/o0Q4svmDVa81a/quIYdvp417fkvYu3F9MwBZxDAOs=;
	b=gnpBIsX0ef7B3dzq3i3cr2uRhdz9sPaL6Eu0NIbex+589+5ox2dDpumv2XY6z5xaAQLdmk
	dhffY5Gkq2AbQoz3/ENsjHOKj1abx0+WxTBxI0I3yOl/ToT175h+BNxDrvx/+8TuvIwFwh
	mQ8dAq5fUk24Xn1DxzOhjmbFRaP8zPA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-dj84fESOPIKSRKk45eUTyg-1; Wed, 06 Sep 2023 13:55:14 -0400
X-MC-Unique: dj84fESOPIKSRKk45eUTyg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63F8B8A2E3C;
	Wed,  6 Sep 2023 17:55:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1DB4D405D476;
	Wed,  6 Sep 2023 17:55:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C7EAA194658D;
	Wed,  6 Sep 2023 17:55:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CACF0194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 17:54:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BB7B8C03296; Wed,  6 Sep 2023 17:54:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B4156C03292
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 17:54:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9804C8279AA
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 17:54:55 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383--W2EFSN-OvyMQqrXkoFY9w-1; Wed, 06 Sep 2023 13:54:53 -0400
X-MC-Unique: -W2EFSN-OvyMQqrXkoFY9w-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230906175450epoutp0257c86543ac4bd2d1ef8847f2e96d2b1d~CYNgCc_Cz2076020760epoutp02J
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 17:54:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230906175450epoutp0257c86543ac4bd2d1ef8847f2e96d2b1d~CYNgCc_Cz2076020760epoutp02J
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20230906175449epcas5p3a03142c635347310a21db04630b793c7~CYNfUYMVQ0403304033epcas5p3t;
 Wed,  6 Sep 2023 17:54:49 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
 epsnrtp4.localdomain (Postfix) with ESMTP id 4RgqlD1Hltz4x9Pq; Wed,  6 Sep
 2023 17:54:48 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 65.13.09949.8ECB8F46; Thu,  7 Sep 2023 02:54:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
 20230906164416epcas5p307df0f4ab0a6a6a670fb50f6a8420a2a~CXP4zlm2w1472314723epcas5p3z;
 Wed,  6 Sep 2023 16:44:16 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230906164416epsmtrp2a5f2722840cb3de7f54043bc47d8302f~CXP4ypflQ1133211332epsmtrp23;
 Wed,  6 Sep 2023 16:44:16 +0000 (GMT)
X-AuditID: b6c32a49-bd9f8700000026dd-0b-64f8bce8f1f8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
 4A.D9.18916.06CA8F46; Thu,  7 Sep 2023 01:44:16 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230906164413epsmtip2055169562ca828d92df5bb5649e38570~CXP2SHi2N0470904709epsmtip2E;
 Wed,  6 Sep 2023 16:44:13 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair
 Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
 <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>
Date: Wed,  6 Sep 2023 22:08:35 +0530
Message-Id: <20230906163844.18754-11-nj.shetty@samsung.com>
In-Reply-To: <20230906163844.18754-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTVxzeuff2ciHrdqkwjjiVdJkR5NWt1MsmbJkwrtNMErKYMSIr9Kaw
 Qtv0Fp3GhCIPEcOrCkJFW4Q4qK48ZIyHOAcbDBjDjcEEw1SkBEUBLbI5Aqzthc3/vt93vu/3
 OucQqGAO9yaSlVpGo5SmCHE3rLnLd3vA9LW/ZcGVYxhV19eNUpfHC3FqpuspoCZvnABUx+w5
 HjV6oxWhai//iFD6zhFAWYcNCNUxtoOqzKnGqGsdvRg11FaBU8ZLVhfqq54VhLpVZAVU85IR
 pSwzcxj109gmanC5h/e+Bz34ZwNGDw2k0Y3mkzh9tTqdbh/V4XRVwWkenZ85i9NPrGMYPXd9
 GKcLmsyAtjVuoRsnHyPRL8cqdiUxUhmj8WGUiSpZslIeJtwbE787PkQSLAoQhVI7hT5KaSoT
 JozYFx3wYXKKfUyhzyFpSpqdipayrDAofJdGlaZlfJJUrDZMyKhlKWqxOpCVprJpSnmgktG+
 IwoOfivELvxckXTWfJanzuB9ObX8Pa4DZVgecCUgKYZXjI/wPOBGCMh2AM3GUsAFTwG06Fd4
 DpUzuJ9xcN1x+odanONbASxq5XGGbAQW59bb3QSBkztg/yrh4D1IHQrr26ucWVHyJAL7l/qd
 7g1kFFz9Jxc4MEa+CQee5SMOM598F1ptcQ4IySBYeMfdoXC1s8czfnWq+aQ77C2fdE6Aklth
 5jfnUEd6SC4Q8LnFhnONRsC7+u94HN4AH/Y0uXDYG9pmO9Y0h2HtmRqcM2cBaPjDALiD92B2
 XyHqaAIlfWFdWxBHb4YlfRaEK/wKzF+aRDieD1surOM34JU601r+jXDkr4w1TMPKkYm17RYA
 aDLluBQBH8MLAxleGMjwf2kTQM1gI6NmU+UMG6IWKZnD/11yoiq1EThfvt+eFjB+dz6wEyAE
 6ASQQIUe/NmtizIBXyY9cpTRqOI1aSkM2wlC7PsuRr09E1X2r6PUxovEocFiiUQiDn1bIhJ6
 8Weyz8sEpFyqZRQMo2Y06z6EcPXWIZ8M9Clk3Y96jCsVOSOqFjJmrxz4xjb0RuyvfLL90r6j
 vQ+yEuRhS0Tb6vR5xTiJuIh2xj10/8zvIps5Ii7PWlm8PXFnU/1CqdhL7lc9GinpvDjeNSF6
 vvxLeq6n5xf5JteoZ6aaCnnxq1djkAOnrB+dmPzga3VeVaC42oY9OBan+H1622vNZVOeC0cs
 e24O049DEoea6d8Mx66Hfyoyv1Tonh+hTzhwwS/qY33k5vLFW1MGr6b9ZYO+2+77ixO39E7d
 u1fDdFvkitj5zNKlhtL6eot/ZM1NY1D78d20oD28QVf7evpt8UGspKukgUkt9dcsyk8JvBPm
 03/+1q3SFnlIJ8TYJKnID9Ww0n8BmvMluIIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsWy7bCSvG7Cmh8pBveWqVqsP3WM2WL13X42
 i9eHPzFaPDnQzmix991sVoubB3YyWaxcfZTJYtKha4wWT6/OYrLYe0vbYmHbEhaLPXtPslhc
 3jWHzWL+sqfsFsuP/2OyuDHhKaPFtt/zmS3WvX7PYnHilrTF+b/HWR1EPM7f28jicflsqcem
 VZ1sHpuX1HvsvtnA5rG4bzKrR2/zOzaPj09vsXi833eVzaNvyypGj8+b5Dw2PXnLFMATxWWT
 kpqTWZZapG+XwJUxfdV01oJG1opnfw+yNTDOYOli5OSQEDCRmHxkJVsXIxeHkMB2RokNq/dC
 JSQllv09wgxhC0us/PecHaKomUnix7EHQEUcHGwC2hKn/3OAxEUEupglOne+YwFxmAUmM0ms
 Or8UbJKwgLvE/18djCA2i4CqxNmvvUwgzbwC1hJPP8eAmBIC+hL99wVBKjiBok2NF8GqhQSs
 JO6seg1m8woISpyc+QRsIrOAvETz1tnMExgFZiFJzUKSWsDItIpRNLWgODc9N7nAUK84Mbe4
 NC9dLzk/dxMjOBq1gnYwLlv/V+8QIxMH4yFGCQ5mJRHed/LfUoR4UxIrq1KL8uOLSnNSiw8x
 SnOwKInzKud0pggJpCeWpGanphakFsFkmTg4pRqYglsTrvFsaZQVWtl7dNnHnQ0qKetcd058
 xPnmh5OEeABrZLfuibD9j7jClc6x35lruKP4/bF1onKT5dQ+6F2aeNFIonLLOofvTr+UeE4X
 zF5dp9DZ0Xr79Rt/PWuraianOoVSD7aFO7/9sM84v9zMb0NFzrYtHtHPorKO/X9i4XaM6fVt
 E5Zci9+Wfx+2pJ+3i9jGNOf6+WV/jS7W5tkHNtfXXtf4P+WiqM26SU+8NmTM+e3DJ3b7ROX2
 zOCDXB062ZKWgmZr6x539xnrGqnsir7NueTXcwfVH10v71esu215RVvSO91m444XHNLlB9ty
 r6m4MnxN43W9sIm5+WJa7MSVeTrzPzQFzL+n+EBeiaU4I9FQi7moOBEAhMsC/zUDAAA=
X-CMS-MailID: 20230906164416epcas5p307df0f4ab0a6a6a670fb50f6a8420a2a
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230906164416epcas5p307df0f4ab0a6a6a670fb50f6a8420a2a
References: <20230906163844.18754-1-nj.shetty@samsung.com>
 <CGME20230906164416epcas5p307df0f4ab0a6a6a670fb50f6a8420a2a@epcas5p3.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH v15 10/12] dm: Enable copy offload for dm-linear
 target
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
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, mcgrof@kernel.org, linux-fsdevel@vger.kernel.org,
 Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Setting copy_offload_supported flag to enable offload.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 drivers/md/dm-linear.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index f4448d520ee9..1d1ee30bbefb 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -62,6 +62,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_discard_bios = 1;
 	ti->num_secure_erase_bios = 1;
 	ti->num_write_zeroes_bios = 1;
+	ti->copy_offload_supported = 1;
 	ti->private = lc;
 	return 0;
 
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

