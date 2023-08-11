Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A270C001DB
	for <dm-devel@archiver.kernel.org>; Fri, 11 Aug 2023 11:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691752855;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=C/o0Q4svmDVa81a/quIYdvp417fkvYu3F9MwBZxDAOs=;
	b=UpA0B12U5TSKGRqjCuQAycwmNkXoxFwmureH6pYEKVUwSwEfhm1qVe9CSYeZdQ2zKKa2dv
	YrxL/RYSu79wXmjBK6cE3xoLA1NJZ9pP2tnNHHIU/8nNefgPUsz5hn4SgwPSK8IgVE6rb7
	lAQ/LtQ8l0E/iahTZRveCN8nXSsQSJA=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-QHYcKL6jPEKbtornp2NrZg-1; Fri, 11 Aug 2023 07:20:52 -0400
X-MC-Unique: QHYcKL6jPEKbtornp2NrZg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08FBB29AA39D;
	Fri, 11 Aug 2023 11:20:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E5394C15BB8;
	Fri, 11 Aug 2023 11:20:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C762F1946595;
	Fri, 11 Aug 2023 11:20:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3EC7519465B2
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Aug 2023 11:20:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2FFE0140E96E; Fri, 11 Aug 2023 11:20:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 27283140E96D
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 11:20:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CDCB185A793
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 11:20:49 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-k1DfR7pJOvKZRhym0zepAQ-1; Fri, 11 Aug 2023 07:20:46 -0400
X-MC-Unique: k1DfR7pJOvKZRhym0zepAQ-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20230811112043epoutp045ad28f490546a4e43794f04ac49d6e6f~6UD_D7qsl1412514125epoutp04s
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 11:20:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20230811112043epoutp045ad28f490546a4e43794f04ac49d6e6f~6UD_D7qsl1412514125epoutp04s
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20230811112043epcas5p25d147b9f2216bcf295549d0750a03a75~6UD9abQAJ0760807608epcas5p2k;
 Fri, 11 Aug 2023 11:20:43 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4RMhDS4Dsxz4x9Pr; Fri, 11 Aug
 2023 11:20:40 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 87.7D.55522.88916D46; Fri, 11 Aug 2023 20:20:40 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
 20230811105819epcas5p40ddff0991c70b6d80d516dfe055bd673~6TwZyFW5P1386113861epcas5p4G;
 Fri, 11 Aug 2023 10:58:19 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230811105819epsmtrp1cae6dab938a725a7ce3ed467ec718df1~6TwZxHHYy0371503715epsmtrp1C;
 Fri, 11 Aug 2023 10:58:19 +0000 (GMT)
X-AuditID: b6c32a49-67ffa7000000d8e2-10-64d61988985e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
 E2.23.64355.A4416D46; Fri, 11 Aug 2023 19:58:18 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230811105814epsmtip2d7a93644a1886d650dc65130c3e958bb~6TwVB4lIO1103411034epsmtip28;
 Fri, 11 Aug 2023 10:58:13 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair
 Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
 <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>
Date: Fri, 11 Aug 2023 16:22:53 +0530
Message-Id: <20230811105300.15889-11-nj.shetty@samsung.com>
In-Reply-To: <20230811105300.15889-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIJsWRmVeSWpSXmKPExsWy7bCmhm6H5LUUg7bVchbrTx1jtlh9t5/N
 4vXhT4wWTw60M1o82G9vsffdbFaLmwd2MlmsXH2UyWLSoWuMFk+vzmKy2HtL22Jh2xIWiz17
 T7JYXN41h81i/rKn7BbLj/9jsrgx4Smjxbbf85kt1r1+z2Jx4pa0xfm/x1kdRD3O39vI4nH5
 bKnHplWdbB6bl9R77L7ZwOaxuG8yq0dv8zs2j49Pb7F4vN93lc2jb8sqRo/Pm+Q8Nj15yxTA
 E5Vtk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0qpJC
 WWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwKRArzgxt7g0L10vL7XEytDAwMgUqDAh
 O2P6qumsBY2sFc/+HmRrYJzB0sXIySEhYCLRM/UQkM3FISSwm1HizdvlzBDOJ0aJxo3LGeGc
 uUfOMsG0vLt7lAkisZNRYlPnFaiWViaJH3/WsnYxcnCwCWhLnP7PARIXEWhgltiwezEjSDez
 wHwmib3vIkFqhAXcJY6cYgYxWQRUJfq6RUEqeAWsJaZ0T2QECUsI6Ev03xcECXMChd9vusQG
 USIocXLmExaIgfISzVtnM0Oc9p9D4sVxVQjbRaJ36mWoL4UlXh3fwg5hS0m87G+DssslVk5Z
 wQZypYRAC6PErOuzGCES9hKtp/rBTmMW0JRYv0sfIiwrMfXUOiaIvXwSvb+fQIOEV2LHPBhb
 WWLN+gVsELakxLXvjVC2h0TvtK9g9wgJ9DFKvNhiPYFRYRaSd2YheWcWwuYFjMyrGCVTC4pz
 01OLTQsM81LL4VGcnJ+7iRGc9rU8dzDeffBB7xAjEwfjIUYJDmYlEV7b4EspQrwpiZVVqUX5
 8UWlOanFhxhNgaE9kVlKNDkfmHnySuINTSwNTMzMzEwsjc0MlcR5X7fOTRESSE8sSc1OTS1I
 LYLpY+LglGpg4p5i02o0Y9Kz55Y1Gt4ujW90uI+m6FZOWSI937bg4aEKl7UhS/0TCpOfpeuV
 Kx7687frkOPqTimjGTpWnsukpTbErpc6r7Xvxt1/HGfSYtRq9PbypdrMVVr4xWbHPG7nP97r
 D29xKGH9a5eekr3vseL+7vc3vtz/FCK0+drMgLs6EidvXzEPS0mcq79d5s4fK4YFy9nWsEqs
 8urmtxdNtfoQZ6twRevGC65Ebk+r06/ut/Sv2cIWvnQvb5Z/zVQNhsAFx46sair465GhkNHk
 fFv42RZZ4Z8vv7NK73vaIVs9cf/uL9er1tmvPdp09Efl1y28d/3WX9v+PHn2pYb86lxTXrfl
 619r1RgWd/SuU2Ipzkg01GIuKk4EAD5Wi+2EBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWy7bCSvK6XyLUUg11/bCzWnzrGbLH6bj+b
 xevDnxgtnhxoZ7R4sN/eYu+72awWNw/sZLJYufook8WkQ9cYLZ5encVksfeWtsXCtiUsFnv2
 nmSxuLxrDpvF/GVP2S2WH//HZHFjwlNGi22/5zNbrHv9nsXixC1pi/N/j7M6iHqcv7eRxePy
 2VKPTas62Tw2L6n32H2zgc1jcd9kVo/e5ndsHh+f3mLxeL/vKptH35ZVjB6fN8l5bHrylimA
 J4rLJiU1J7MstUjfLoErY/qq6awFjawVz/4eZGtgnMHSxcjJISFgIvHu7lGmLkYuDiGB7YwS
 f2buYoVISEos+3uEGcIWllj57zk7RFEzk8SBr0+AHA4ONgFtidP/OUDiIgJdzBKdO9+xgDjM
 AiuZJHYenskIUiQs4C5x5BQziMkioCrR1y0KMpNXwFpiSvdEsAoJAX2J/vuCIGFOoPD7TZfY
 QGwhASuJD8sOMkKUC0qcnPkE7GZmAXmJ5q2zmScwCsxCkpqFJLWAkWkVo2hqQXFuem5ygaFe
 cWJucWleul5yfu4mRnBMagXtYFy2/q/eIUYmDsZDjBIczEoivLbBl1KEeFMSK6tSi/Lji0pz
 UosPMUpzsCiJ8yrndKYICaQnlqRmp6YWpBbBZJk4OKUamHK+z4189cfz4oJFETfYRPe29elG
 7ajpun5mNvMbjnJPXuFzL1S+7bK57stx++2l7fG3J9++fIPx8unLNj9K9/27fafnxqlpkW63
 o/e+2BHorPBTmXHbJMNlL9ZNmbsrZ8c2i///PvoITWz7ymYQsHGlqbJ9VfX9HzZe0+u5pyzS
 e//+llVouPdN1q7yt7cj3r9749iwkSnfbv7P8zkLzI9Lv02bvOV21cLMz5pbvyzPTp7xzUFx
 R/OTJal7c/Y3v8o6xcCVOX0/P1eS7fvGqDm11zTTp8XKO+w0r1c4WRYd/SRKre/YednMeMFV
 LSIvjx8M/9SY3j4v+sncuMdT5h1jnOCbzyR0rnPdiVXsrTHzlFiKMxINtZiLihMB2tOUUzgD
 AAA=
X-CMS-MailID: 20230811105819epcas5p40ddff0991c70b6d80d516dfe055bd673
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230811105819epcas5p40ddff0991c70b6d80d516dfe055bd673
References: <20230811105300.15889-1-nj.shetty@samsung.com>
 <CGME20230811105819epcas5p40ddff0991c70b6d80d516dfe055bd673@epcas5p4.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH v14 10/11] dm: Enable copy offload for dm-linear
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
 linux-block@vger.kernel.org, mcgrof@kernel.org, dlemoal@kernel.org,
 linux-fsdevel@vger.kernel.org, Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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

