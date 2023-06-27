Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90800EB64D7
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jun 2023 06:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687934708;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=C/o0Q4svmDVa81a/quIYdvp417fkvYu3F9MwBZxDAOs=;
	b=TnMTDXjmTXN/nitMTv6PT0MmGF2DzculAQ5W51OcEq4b6gA4CnZvzZWl2n8kpDhF8UaGBQ
	9lzKSz67pHQg32JTjcWEBCYWGpA8aVafCOd0zFfzuXPIKTYuiuYZJ/xrY2jBrFK7QSDFAA
	NY3F1ZbWAhKHYEqlOxPVlsMSWqdYjrY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-ddly_HAuMpaQJEgWuKilOg-1; Wed, 28 Jun 2023 02:45:05 -0400
X-MC-Unique: ddly_HAuMpaQJEgWuKilOg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B9561C08DAF;
	Wed, 28 Jun 2023 06:45:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4931E40D1A4;
	Wed, 28 Jun 2023 06:45:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F0B9E1946587;
	Wed, 28 Jun 2023 06:45:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 323461946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 28 Jun 2023 06:45:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E4A8E1120AC4; Wed, 28 Jun 2023 06:45:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DC724111F3B6
 for <dm-devel@redhat.com>; Wed, 28 Jun 2023 06:45:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2E722823801
 for <dm-devel@redhat.com>; Wed, 28 Jun 2023 06:45:01 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-LIF0gP-iP4SpWI2ZZyBCPw-1; Wed, 28 Jun 2023 02:44:58 -0400
X-MC-Unique: LIF0gP-iP4SpWI2ZZyBCPw-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230628064455epoutp02f919a0d997d421e26e85828aea42a199~sv6mmPvVs2914529145epoutp020
 for <dm-devel@redhat.com>; Wed, 28 Jun 2023 06:44:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230628064455epoutp02f919a0d997d421e26e85828aea42a199~sv6mmPvVs2914529145epoutp020
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20230628064454epcas5p1105def2a4a48815b269ffb5a749e4a74~sv6l3pwdt2101721017epcas5p1Q;
 Wed, 28 Jun 2023 06:44:54 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4QrXBY5TSZz4x9Q1; Wed, 28 Jun
 2023 06:44:53 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 46.4D.06099.5E6DB946; Wed, 28 Jun 2023 15:44:53 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
 20230627184107epcas5p3e01453c42bafa3ba08b8c8ba183927e6~smCo_byDD0780707807epcas5p3p;
 Tue, 27 Jun 2023 18:41:07 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230627184107epsmtrp10062d7cd1e21b793dd2a7d1a851343b4~smCo9f2dH1856518565epsmtrp1a;
 Tue, 27 Jun 2023 18:41:07 +0000 (GMT)
X-AuditID: b6c32a4b-cafff700000017d3-cc-649bd6e5a170
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 09.49.34491.34D2B946; Wed, 28 Jun 2023 03:41:07 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230627184103epsmtip21d124411e8c89e5b7683f606750615a0~smClcbl4h0383203832epsmtip2j;
 Tue, 27 Jun 2023 18:41:03 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair
 Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
 <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>
Date: Wed, 28 Jun 2023 00:06:22 +0530
Message-Id: <20230627183629.26571-9-nj.shetty@samsung.com>
In-Reply-To: <20230627183629.26571-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfzCbdxzH+32e5BFu0UdQX3qzXLZ2h5GE0C+jdiv1qF3nzna36/6ITJ7D
 iSRNomV2N6q0rJrWj7LI0eG2+p3SWgilWjO6nZqWlWMO2c60GF0xZ1sibP3v9fl8P+/Pr+99
 WDin2s6DlSzX0Cq5RMYjHBjt97y8fM1jFVLB1EVn1DL0HY4aprQEWry3CtC1lU0czfdeAGh0
 3hHN9ISj7qUKJnrS24GhruoiDNU19GOoqG8MIPNjHYa6J3zQV3m1DNTVPchAo516AlV9bbZD
 X4wbCfTNwN8Y6ivOwZBxPhug9q0qHDUvLjPQ9xMH0fD2ABNtbeiJdw5So49iqA7dlB01PH2T
 QbXd8KZGf0yjWuvzCaqt9nPK9CSLoGouFzOpwpwlgvrDPMGglu88JqjLt+oB1fYgk1pr9aRa
 559hseSplNAkWiKlVVxanqCQJssTw3gxceJj4sAggdBXGIyO8LhySSodxot4L9b3eLLMshge
 94xElmZxxUrUah7/aKhKkaahuUkKtSaMRyulMqVI6aeWpKrT5Il+cloTIhQI/AMtgfEpSWX1
 ZUxlNjP91+27RBYoZxQAexYkRbCy6S5RABxYHNIEoH590s5mrAJoql5i2IwXAF6aasb3JBf/
 MgArc8huAAc7Q21BuRg0Gs5bcrFYBOkDH/zDsvpdyCwcGkw1wGrgZC0O656uMK1qZzIS6v8c
 tLMygzwEF8zbO2I2GQKbJvytCEk+1P7iZI2wJ9+GpuH7O0o26QQHv5zfGQEnX4M5tytwa3pI
 DtnDH3L0mK3RCKgv3dplZ/j7wC07G3vABW3eLp+FdSU3CJv4PIC6cR2wPYTD3CEtbm0CJ71g
 Syff5n4Vlg41Y7bCjrBwa343PxsaK/f4ddjYcp2wsTscW8/eZQoW9z/cXe9lAC/U92NXAFf3
 0kC6lwbS/V/6OsDrgTutVKcm0upAZYCcPvvfLycoUlvBzrF4xxjB7MyKXx/AWKAPQBbOc2Ef
 2CiTcthSScantEohVqXJaHUfCLTs+yru4ZqgsFybXCMWioIFoqCgIFFwQJCQ58YeGS+UcshE
 iYZOoWklrdrTYSx7jyys0e3FUk97tO+J8lXKaJ78WVpy5tTmm3GFEdsHuub6p9dWMjO1s+dq
 VKcV68OfeV+J/NYU9a56M9u13SX6FUWj+0YTL+D4c96++KcZxWX5prw49wLRzaM1zw7JmSvv
 Lxr4czHayoQZGGmmqejD/CX/24bqOIOnMOoTcfLIkcN1uucc5vBpbrbAnhPVGJ8b7bxQEjk7
 Ev6xLOOYmM23/zDdT6+fGxTd3+x49MZGcIBS4RPQ89bCSfYH7qVrWR+d3MoJdkoMEJ5IL2+6
 Ni5vMuuX3bSODHqu/U7B8G/nUiOxqnjX/SH7ZJ4J7IfbRfkdkz81zE2Hdo7u1wtiFb2ZDpdE
 ZTyGOkki9MZVasm/d9PekrUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsWy7bCSvK6z7uwUg2efpC3WnzrGbLH6bj+b
 xevDnxgtpn34yWzx5EA7o8XlJ3wWD/bbW+x9N5vV4uaBnUwWexZNYrJYufook8WkQ9cYLZ5e
 ncVksfeWtsXCtiUsFnv2nmSxuLxrDpvF/GVP2S26r+9gs1h+/B+TxaHJzUwWO540Mlps+z2f
 2WLd6/csFiduSVuc/3uc1eL3jzlsDtIel694e+ycdZfd4/y9jSwem1doeVw+W+qxaVUnm8fm
 JfUeu282sHks7pvM6tHb/I7N4+PTWywe7/ddZfPo27KK0WPz6WqPz5vkPDY9ecsUIBDFZZOS
 mpNZllqkb5fAlTF91XTWgkbWimd/D7I1MM5g6WLk5JAQMJHo+LWBsYuRi0NIYDejxK27ixkh
 EpISy/4eYYawhSVW/nvODlHUzCRx9dUjoG4ODjYBbYnT/zlA4iICXcwSnTvfsYA4zALbmCU+
 fPjCDtItLOAqMefrSTCbRUBV4uXTv2wgzbwCVhJrbxmBmBIC+hL99wVBKjgFrCV2nz/CChIW
 Aqp4fzwAJMwrIChxcuYTsJuZBeQlmrfOZp7AKDALSWoWktQCRqZVjJKpBcW56bnFhgWGeanl
 esWJucWleel6yfm5mxjBca+luYNx+6oPeocYmTgYDzFKcDArifCK/ZieIsSbklhZlVqUH19U
 mpNafIhRmoNFSZxX/EVvipBAemJJanZqakFqEUyWiYNTqoFpUVz7lax1vkX732xdJf3RU333
 QfMKFfE8LyGOxYH1mvmnFs3tW37KI+XahRj/GVLrslxFz2kbtfXc/+fevPaaxCrRqQ/qotbP
 MLlkP0PUPzVl5xltoe7mrM3OVob2K5bOC2H6x/th4trOUL4m55kn+eYc4ds/V+nvLvfsyyu5
 HRxdDhU+/P0sPvfainV9jysS23dFXvmYHXdT5867Vb0uhwun/H5e1zrNrcPD5pjGhc9Fa15J
 vAq+Uvf999+G2LA8w7pXB6u28bxiNlg2/fvib2fKNuiYr992auV92+dfWHsDL9qsCdC5Iljx
 b+Es7mbGJu5TO9MfiMnzJzX5P1nDfPJW/fmwuaExxzd0HFvrqsRSnJFoqMVcVJwIAJFLCRlq
 AwAA
X-CMS-MailID: 20230627184107epcas5p3e01453c42bafa3ba08b8c8ba183927e6
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230627184107epcas5p3e01453c42bafa3ba08b8c8ba183927e6
References: <20230627183629.26571-1-nj.shetty@samsung.com>
 <CGME20230627184107epcas5p3e01453c42bafa3ba08b8c8ba183927e6@epcas5p3.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH v13 8/9] dm: Enable copy offload for dm-linear
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
Cc: linux-nvme@lists.infradead.org, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, djwong@kernel.org,
 nitheshshetty@gmail.com, linux-kernel@vger.kernel.org, willy@infradead.org,
 ming.lei@redhat.com, linux-block@vger.kernel.org, dlemoal@kernel.org,
 martin.petersen@oracle.com, linux-fsdevel@vger.kernel.org,
 gost.dev@samsung.com, Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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

