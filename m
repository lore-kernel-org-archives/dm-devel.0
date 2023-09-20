Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41ED8CE79AB
	for <dm-devel@archiver.kernel.org>; Wed, 20 Sep 2023 09:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695201484;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=22zcPs+/UGeaOmPASGtF26YNxK5m//Ko1vFcRHWJzCo=;
	b=GNJc7U6IvOshPAPMFD5XswlyDuFx5rSS6eJw68m5OUYqv7bhPurAXwt0Yn+WNvYzNQg3VB
	kLTCwDX/FZtZ1o00pvP3WdWZQRgPEtk2JMk4W38W8nblyX+fZrxYP3mg8VByBHXw4qPIB+
	LQr9dVqqZQ+z2DgeAEhkl56wET+s4VU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-CWSBmZgaPoa8ozKkwsShSg-1; Wed, 20 Sep 2023 05:18:00 -0400
X-MC-Unique: CWSBmZgaPoa8ozKkwsShSg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD2713C11A10;
	Wed, 20 Sep 2023 09:17:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AA1B540C6EBF;
	Wed, 20 Sep 2023 09:17:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3593A1946594;
	Wed, 20 Sep 2023 09:17:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EC56C194658D
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Sep 2023 08:58:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C8E42C154CA; Wed, 20 Sep 2023 08:58:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C124DC15BB8
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 08:58:51 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E8393C147E3
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 08:58:51 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-DeZzoNUeOWSv33PLdBUm9A-1; Wed, 20 Sep 2023 04:58:49 -0400
X-MC-Unique: DeZzoNUeOWSv33PLdBUm9A-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20230920085845epoutp01f1fb8d279ada69e0c14cfe99f24e87de~Gj7cGPOgg2974629746epoutp01d
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 08:58:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20230920085845epoutp01f1fb8d279ada69e0c14cfe99f24e87de~Gj7cGPOgg2974629746epoutp01d
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20230920085845epcas5p396c04043dede83074b0dd1971a85635e~Gj7bg7d9g1154211542epcas5p3r;
 Wed, 20 Sep 2023 08:58:45 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
 epsnrtp4.localdomain (Postfix) with ESMTP id 4RrCBB2hH0z4x9Q6; Wed, 20 Sep
 2023 08:58:42 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 F2.FA.09638.244BA056; Wed, 20 Sep 2023 17:58:42 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
 20230920081558epcas5p4d791ba4be2836264a6fb44e06e636d11~GjWEhY0AW3181231812epcas5p41;
 Wed, 20 Sep 2023 08:15:58 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230920081558epsmtrp104f414d8759ea58100910ec961341dab~GjWEgcbpy2250122501epsmtrp14;
 Wed, 20 Sep 2023 08:15:58 +0000 (GMT)
X-AuditID: b6c32a4a-6d5ff700000025a6-b1-650ab4426b85
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
 DC.10.18916.D3AAA056; Wed, 20 Sep 2023 17:15:57 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20230920081554epsmtip10685e21725660c9296a7bfa72629e389~GjWBgYFls2849128491epsmtip1e;
 Wed, 20 Sep 2023 08:15:54 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair
 Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
 <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>
Date: Wed, 20 Sep 2023 13:37:47 +0530
Message-Id: <20230920080756.11919-11-nj.shetty@samsung.com>
In-Reply-To: <20230920080756.11919-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf1CTdRi/7/uOdxvn6HVAfF1SuI5qePyYMfySUPzw6L3wD87OK82gxd74
 uR9uLJCua4DIyWQThMohCIImUxgBcRuIrREBI49LggGm6AGnRQgyOyMubWNo/vd5Ps/neT7f
 5/new8K5WiaPlSXLo5UycS6f8GZ09wsEoQld3nSE/bYPMtl/wtH9v9YY6OINPYEW+lcAmrOW
 AdR3r9YLTVktGLp8tgpDLRcHMFRlmwBoftyAob7p7ajxaDMDXe4bZqCxntMEOnN+nom0DjOB
 vhl8hKHJE/MAmeeKAOpeO4OjtoUlBhqafgGN/jvoFQcpi+EGkxq9+S2DGruqpjqMxwiqs/kL
 qndKQ1BNupNeVEXJPYK6Pz/NoJaujBOUrssIqM6Rzyhnx4tUx9wiluJzICcmkxZLaGUQLUuX
 S7JkGbH85HfTEtNEURHCUGE02skPkomldCx/956U0KSsXNcO+EGfinPVLipFrFLxw9+MUcrV
 eXRQplyVF8unFZJcRaQiTCWWqtSyjDAZnfeGMCJih8gl/Cgn03rXiinavAq+vl4NNMDKKAds
 FiQjYcOXQ1g58GZxyV4AzdX1hDvBJVcAtIztfYrLzsWUA9Z6wZ3ZRI/eAuCKa5ueoBSDhpvd
 hFtEkNvhyGOWm/cjNThs720C7gAnVzFYcmEIuLv6km/D840DTDdmkMFw2fGA6S7mkLtg36VM
 j1k41M9sdivYLtbZ7FhXc8jNcPjU3PoAOPkSLPmuFne3h2QtG94p0m9Mthv+2FNOeLAv/GOw
 i+nBPPi7/ugGzoct1RcIT/ERAA0OA/Ak3oKldj3ufgROCqCpJ9xDB8IaexvmMfaBFWtzmIfn
 QHP9E/wyvGRq2PDdAiceFm1gCtZVOhmeZekAPNd+nDgBggzPDGR4ZiDD/9YNADeCLbRCJc2g
 VSLFDhmd//SP0+XSDrB+FSHvmMHtW8thNoCxgA1AFs7340hf8aa5HIn4cCGtlKcp1bm0ygZE
 rn1X4jz/dLnrrGR5acLI6IjIqKioyOjXo4T8AM5CaZ2ES2aI8+gcmlbQyid1GIvN02A7JyzH
 nFPD2f0HjbNZna8datE+TGo1Haqkry0WFsfsqcvZpEqXjgm2hZ9aUByPXjXe4sz6av8+sFys
 SxJkBxxM3dsS2Lg1ePGx7JNQTeimw5b8WX9YR1Rp4wTf7xMnjKtTy2qzavJnrkiSgu8GaCZD
 Om2G+LL4uNY/Nc5tkzqN9fMG3ujPPe0//HL1VeuumBl2irW0rlf0YOmapXWkouv6o/hehpX/
 YZMkf7lKaTLzCoxKbs3JgXb5jMMemLxv3LTaL1u0J9RPsIF/9v7k92y/Zow0j49Nbi3/WJRe
 nKiTnNbZAhvS/3muwKn9Ch7R6EVFH7y/7OfY/3xhaj3x29kePkOVKRaG4EqV+D9/tfJVngQA
 AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Re0hTYRjG+c45nnNcrI7a6ktNa1HiJGtg9jEviAV9QlBJUBhkQw9abVM3
 jW7UUkq2yFK72LosS6xmLbIsZ86Gl9SWaZqZihWorbKclyxCtDpK0H+/97nAAy9LetspX3a3
 JpPXapQqKS2iHtVJA1ZGWUT86n5XBLr3/BmJRicmKVTWd5pGQ3VjAA04cgGyD1/yQN0OG4Gq
 rxcQ6HZZA4EKat8ANNhpIpC9JwQVnyihULW9mUIdVZdpZC4dZNDJrkoa3WycJtDbM4MAVQ4c
 A+jRpJlE1iE3hZp6/FDrVKNHDMQ2Ux+DW9/dp3BHSxYutxho/KDkKH7SrafxjbxCD3wqZ5jG
 o4M9FHbXdNI476EF4AfOQ3i8PACXD3wjNs9NEEUm86rd+3jtquhdolTHJweRbvXYX9R7FuiB
 gzICloVcGHT1rzMCT9abewxgmzNDYMgtgqVT9eQs+8Db0y7GCER/MzkEfGobBUKX5kKg8zcr
 6PM5IwkNtmFKOEgul4TOL0OE0PbhNsDS4gZGYIpbDke6vjNCWcxFQPud1NkNq+Dp915CwvOv
 Ol7SxczuUUBnm3mGxZwXbL44QAlMcoEwp+ISeQZwpv8s03/WNUBYgIRP16lT1Enp8lCdUq3L
 0qSEJqWpy8HMh2XxlaD03lRoLSBYUAsgS0rni9UrRLy3OFl54CCvTUvUZql4XS3wYynpQvEy
 lSHZm0tRZvJ7eT6d1/5zCdbTV0/oblmbcQM4srX9sWa9LMwn6XDGyA6v3pgyoNmW9+GLoabn
 fJpFuvOCbGnwj2pXvgLb50T3J1TYX/jO+fnUX1O0xc8cl3o9/H74gslEvL1JbmttiL5SfO3q
 8u6NCrzWLbFuXpK9eFEQHxyxz72mcB4v2WR1mxm9KyrwZfhnkdwYFWhNKFydlz8RL3lR9Spu
 ewhj+CjpaHFGBPnHBtZlxW46Nx3a2uLQhEX+2lAzz1Xfe76t/n1jX5Ao5xZjatcZ4tCR3HjF
 7+Cmg3L/6bfZmQsnrpirr1486TOmb3/zKjv+W9X6rsjXI/mqgAIUu+WwomjPV/9TNccrS+6W
 PfGTObRSSpeqlMtIrU75B4DsOJ1QAwAA
X-CMS-MailID: 20230920081558epcas5p4d791ba4be2836264a6fb44e06e636d11
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230920081558epcas5p4d791ba4be2836264a6fb44e06e636d11
References: <20230920080756.11919-1-nj.shetty@samsung.com>
 <CGME20230920081558epcas5p4d791ba4be2836264a6fb44e06e636d11@epcas5p4.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH v16 10/12] dm: Enable copy offload for dm-linear
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
Cc: anuj1072538@gmail.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, gost.dev@samsung.com,
 nitheshshetty@gmail.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, mcgrof@kernel.org,
 linux-fsdevel@vger.kernel.org, Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Setting copy_offload_supported flag to enable offload.

Reviewed-by: Hannes Reinecke <hare@suse.de>
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

