Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49EB2C77B6E
	for <dm-devel@archiver.kernel.org>; Thu, 30 Mar 2023 06:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680157992;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sVtlBSU/mVbN6vvu973VPHMxVO3nRBZJ2w5/pltoknU=;
	b=DHyLoi7iUcy0S//LKy5XzpuSnMfo3M+grIHTIMoNZa/RkbMfl0D1znn7yAoG8uEvg/yz5e
	HtBQBBZ3Ky0W9Aa6cMh7Xu8+IVfQ6nxsRhvMWgL14SoSI8p3bLfORocvPDtcnYXlYiGtKb
	96+lsZFP5ay/H9tfMll42xGPdfYHHlE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-pLG4waV9OXGo9ifMkRNNDw-1; Thu, 30 Mar 2023 02:33:09 -0400
X-MC-Unique: pLG4waV9OXGo9ifMkRNNDw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C15423822E00;
	Thu, 30 Mar 2023 06:33:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AB12F1121339;
	Thu, 30 Mar 2023 06:33:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 882781946597;
	Thu, 30 Mar 2023 06:33:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B857D194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 08:26:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9CEA22166B34; Wed, 29 Mar 2023 08:26:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 954BF2166B33
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:26:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7531B889047
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:26:15 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383-crypoDcvOKOkji_SgOlomQ-1; Wed, 29 Mar 2023 04:26:13 -0400
X-MC-Unique: crypoDcvOKOkji_SgOlomQ-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230329081630epoutp026cc3c31bdfdeb581f1f00cfc607ee299~Q1dlRn-HQ2861228612epoutp02j
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:16:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230329081630epoutp026cc3c31bdfdeb581f1f00cfc607ee299~Q1dlRn-HQ2861228612epoutp02j
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20230329081629epcas5p29eacb83ce69432a0ad642a245c809ee4~Q1dkxESEl1635016350epcas5p2t;
 Wed, 29 Mar 2023 08:16:29 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4PmfXD1pMqz4x9Pp; Wed, 29 Mar
 2023 08:16:28 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 2F.D5.55678.CD3F3246; Wed, 29 Mar 2023 17:16:28 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230327084322epcas5p12f01e676e47d3c8ba880f3f5d58999b4~QOid0ghRO3074330743epcas5p1R;
 Mon, 27 Mar 2023 08:43:22 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230327084322epsmtrp14a16237c5338352e007443853faae221~QOidzab1c3087630876epsmtrp1O;
 Mon, 27 Mar 2023 08:43:22 +0000 (GMT)
X-AuditID: b6c32a4a-909fc7000000d97e-79-6423f3dc0d61
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 C4.4C.18071.92751246; Mon, 27 Mar 2023 17:43:22 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20230327084318epsmtip1e924ae0d72b9b7a598d9de0e0ac183ae~QOiakAl-c3003630036epsmtip1N;
 Mon, 27 Mar 2023 08:43:18 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Date: Mon, 27 Mar 2023 14:10:56 +0530
Message-Id: <20230327084103.21601-9-anuj20.g@samsung.com>
In-Reply-To: <20230327084103.21601-1-anuj20.g@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ta0xbZRjHfc9pT8uweLiYvesca85QBAVabOFljKkZM2cbM3iJH9SBDT2B
 BmhLL264MJEONggVZJFpQS6KRugyXMe4toQxGQKBjnBZysZtlk1ABhveCcOWFt233/N/nn+e
 y5uXi/uVcvhcuULLqBXSDIrYxmq+FhIcdnt1j0xoKfJGjf3XcZRXuo4j02QJgRavPQSofOVv
 HK0N2nBkvV/BRvauNgxZvi7DUL2pB0MdtQ8w1LOxRKCy7nGA5saMGLJOvIAs1j4WGmmvJFD1
 d3Mc1H1Oj6FWxycANa9V4+ji4jIL/TSxE9nWe9mvQHpk9AhtnB4k6DbjJIe2TV1i0SODOtrc
 UEjQl+s+pjvsuQRt0N93FuRPs+nlzjGC/rSpAdCXB07Sq+ZA2uxYwhKfejd9XxojlTFqAaNI
 UcrkitQ46shbyQeSJVFCUZgoBkVTAoU0k4mj4hMSw16TZzjvQAk+lGbonFKiVKOhIvbvUyt1
 WkaQptRo4yhGJctQiVXhGmmmRqdIDVcw2r0ioTBS4iz8ID0t1z5AqH5gn7i7scrOBV2sIuDF
 haQYnq+/hReBbVw/sgPATrsFcwcPAbRZhgh38AeA9QY7sWWx9q1y3AkrgNbmBeBK+JF6DE6O
 8l1MkMHwx3v5wFUUQBbg8MFcIcsV4OQMBqvz6jYd/mQ87DPUYC5mkc9CU3mLU+dweWQMrFEU
 Aa6zWQQsmfZ1FXiRe2Flaz/bxTzSF/Z96dhcASd3Q/2Vis0VIGnygu2dXRz3oPFw6c6wZ2h/
 uNDb5NH5cL6kwMOp8K+ROczNKqi/3gnc/DLM7y/BXTPgZAhsbI9wy7vg5/0XMXdfH2hYc3is
 PNhatcUUPFNf6WEIrUO5HqbhvZ5lz6kNzuv+focoBQLjY/sYH9vH+H/rGoA3gB2MSpOZymgk
 qkgFc/y/R05RZprB5tcIPdwKZmdWwrsBxgXdAHJxKoC3Nk7J/HgyafZHjFqZrNZlMJpuIHFe
 +zOc/3SK0vm3FNpkkThGKI6KihLHvBQlorbzguP6UvzIVKmWSWcYFaPe8mFcL34uVqrzbju6
 Wm6pOsM6uHBMeywlZ/aXcPuTsT4jOq9hzqFvbxb8s8N/PYcsaLka32l+u6dWaHguizkRG3ng
 ktZcm1N1oeK906ySR/B4Ul6gXo4/keu4m7T4RWjSm2L72KNfT8dNZ/k2JVC20v0FU5KAd1Rn
 DytuFbeMB8nBhiDrmarW+Whlw7n3K4dnp9jz2ljiSn3xSu/VhubdpqYuZbf1+ehD/SEHT/qs
 h8qGlm2OIPafr18Iq5q48bOJVJcbkkzBjZIXEwLPZ8Z775Tv2c4/RRTSFZNv/Fa78lXdwO3i
 /KxRfZBp19m47Fdnyk7Jh28mH2V9k11d3nqjSxezEiD+XhTVmEexNGlSUSiu1kj/BXih46aj
 BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Re0hTYRjG/c45OzsuVscp9JVkNMrKanNd4OtedOGUUCPoKmWrnSzTaZuW
 WayjdqGRzQykpunsYjnD1sy7ps4spy0jU5hdhqJZmJtlRiWzmhX03+/leZ73eeGlcNFjYjJ1
 SBXPqlWKaDEpIEobxEHzQrZPU4ZWpWDoXvNjHKWke3BU+EZPov6GzwBlDn7H0Yi9FUc1riwe
 ctRVYKj6egaGCgobMVSV9wlDjT8HSJRh7QCot92AoZrOOai6xkagtspsEuXm9/KR9XIqhsp7
 kgEqHcnFUVG/m0BNnYGo1fOEtwoybS/DGIPTTjIVhjd8pvXtfYJpsycwFtN5kim+eYqpcnAk
 k5bq+m044+Qx7oftJHPxgQkwxS0nmCFLEGPpGcDkE3YJlinZ6ENHWbV0xV7BQc7RQsaZeYnv
 fg7xOFBH6IAvBemFsMY2xNcBASWiqwC8OlgG/ggQNn/I/8v+sGC0j+9lEZ2MwdLOMSbpmfBR
 3xngDQfQ6Th84eRI74DTLgyauvJ5Xpc/vRba0oyYlwl6BizM9DbwKSG9GBpVOkD93i+Feqef
 1+BLL4HZ5c28P1WLof5c5VhQSPtB29WesZtxeipMLcnC0wFt+E8y/CcZAWYCk9g4TUxkjEYW
 J1OxxyQaRYwmQRUp2R8bYwFjrw6ZXQ7KTIMSK8AoYAWQwsUBwuKwaUqRUKk4nsSqYyPUCdGs
 xgoCKUI8UfhcZ4sQ0ZGKePYwy8ax6n8qRvlO5rDwJZuad4yETrG3b1sqT0zRxXNrTE7zwHBw
 Cy/xyxOLNsJUFxhq3DEasF3l5mJ3n1zqMd96tdrsDHfIfc6iJkdtXvzw1g5DwfiF9d9G0etF
 TfyLG80PTcsEXXvu6lMaRleFpXFZ8tUr7+Tv8QQv8sOeVa7s6rib9DTp/L4cqf1933Ltlymy
 5OgTXffXefr12pe1Ubk/sg+IG3Wnr8y/pfQpn7W594LWsv5a9biGxJPpStfbGz/c/ve+HRmv
 zfnUsvVjTma4qJtlurmPM6IqNmwxlmxbIMheQWbJpEU+EyQlRvexw/LMeqck6tLAhjs76eTb
 8unPvq7rFL7fEiQtut7tmismNAcVshBcrVH8AmNSxplZAwAA
X-CMS-MailID: 20230327084322epcas5p12f01e676e47d3c8ba880f3f5d58999b4
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230327084322epcas5p12f01e676e47d3c8ba880f3f5d58999b4
References: <20230327084103.21601-1-anuj20.g@samsung.com>
 <CGME20230327084322epcas5p12f01e676e47d3c8ba880f3f5d58999b4@epcas5p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Thu, 30 Mar 2023 06:32:57 +0000
Subject: [dm-devel] [PATCH v8 8/9] dm: Enable copy offload for dm-linear
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
Cc: bvanassche@acm.org, joshi.k@samsung.com, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, ming.lei@redhat.com,
 linux-block@vger.kernel.org, nitheshshetty@gmail.com,
 linux-fsdevel@vger.kernel.org, damien.lemoal@opensource.wdc.com,
 Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nitesh Shetty <nj.shetty@samsung.com>

Setting copy_offload_supported flag to enable offload.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 drivers/md/dm-linear.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 3e622dcc9dbd..785a6822d06c 100644
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

