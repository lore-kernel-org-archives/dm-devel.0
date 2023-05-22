Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 044E6C7EE26
	for <dm-devel@archiver.kernel.org>; Mon, 22 May 2023 16:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684772973;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=C/o0Q4svmDVa81a/quIYdvp417fkvYu3F9MwBZxDAOs=;
	b=iMUL50A2tzzTihRQZKqeSUvKkX5CUEty5aYCMDfmS+SMYN7SfVBjTLwxqbmM+GG3106eWm
	GJiUOmK8GZ2ZKD5Bh8Fhk2k7sIOu6PlRx1rXlJkwPlQGBvbjn3QTXNsK5rwGideJmE6to2
	9//fz77TRz/k1G+ypMiUxLIkd01hIKA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-LgTPKUOZOAKLvItM6tTtcw-1; Mon, 22 May 2023 12:29:30 -0400
X-MC-Unique: LgTPKUOZOAKLvItM6tTtcw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B2913C14108;
	Mon, 22 May 2023 16:29:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0A50340D1B62;
	Mon, 22 May 2023 16:29:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AA39719465A0;
	Mon, 22 May 2023 16:29:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DBBB81946595
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 May 2023 11:11:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BE43F2029F71; Mon, 22 May 2023 11:11:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B729C2029F6E
 for <dm-devel@redhat.com>; Mon, 22 May 2023 11:11:02 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A7B51C0A584
 for <dm-devel@redhat.com>; Mon, 22 May 2023 11:11:02 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-247-0rhRR-WyNn2mmzTWlJ1Aqw-1; Mon, 22 May 2023 07:10:58 -0400
X-MC-Unique: 0rhRR-WyNn2mmzTWlJ1Aqw-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230522111055epoutp02a21a89ea161caf4108c25fa6acdd342c~hcrSPC2SY1081810818epoutp022
 for <dm-devel@redhat.com>; Mon, 22 May 2023 11:10:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230522111055epoutp02a21a89ea161caf4108c25fa6acdd342c~hcrSPC2SY1081810818epoutp022
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20230522111054epcas5p33acd05785f22834d299a20230b560857~hcrRipPPd1390713907epcas5p3i;
 Mon, 22 May 2023 11:10:54 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4QPvrX4txBz4x9Ps; Mon, 22 May
 2023 11:10:52 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 FB.03.54880.CBD4B646; Mon, 22 May 2023 20:10:52 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230522104657epcas5p19117017c9dfd3d7a4860d2f9122b1277~hcWXN8Hld1779017790epcas5p18;
 Mon, 22 May 2023 10:46:57 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230522104657epsmtrp151d988d04f34f0cc5a959c2d73aa022c~hcWXM9K5l1501415014epsmtrp1W;
 Mon, 22 May 2023 10:46:57 +0000 (GMT)
X-AuditID: b6c32a49-b21fa7000001d660-f2-646b4dbc5e45
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 07.FF.28392.1284B646; Mon, 22 May 2023 19:46:57 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230522104653epsmtip2d7d619611d9ae6ee3b4a9dd3ccc0c4dd~hcWTcnaV61590015900epsmtip2B;
 Mon, 22 May 2023 10:46:53 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 22 May 2023 16:11:39 +0530
Message-Id: <20230522104146.2856-9-nj.shetty@samsung.com>
In-Reply-To: <20230522104146.2856-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01TazBcZxie75zdY5nqHCTjw0T1JJ2W1GUTtp97tUnmGDFxq8500pEde1hj
 9+x2dyW0yWRFJaLDujVkaUPT0QRFEHWNlorQMSY2rkFIKaIukalUDbprafPveZ/3fd7L883H
 wy3rTGx5cayKUbBCCUWYceo7HB2dW4LjRW65Px5CVT33cVRUVUGgS1mbOCof1xBooWMVoGsr
 6ziabPNHrUuFXDTycyOGWr7LwdDt8k4M3dHwUHPJcwx1bi8SKKd9EKCZAS2GWkcPo5bWbg7S
 NRURaKJim4tulM6YoK+GGgj0Q9cWhtpzUzDUMJ0MUP3GDRxVLixz0INRO9S32cVFG38XEe/b
 07pHQbT2SS9BN2rHTei+iTsc+lpOD0HX3nKidb0JdE3ZVYKuWc0xoR8UbHDo2u8v0s0jaoLO
 SFki6Oczoxx6+d4AQWfWlYEQq0/ifcSMUMQoHBg2WiaKY2N9qaDwqA+jPARufGe+J3qPcmCF
 UsaXOnYyxPlEnETvFOVwVihJ0FMhQqWScvXzUcgSVIyDWKZU+VKMXCSRu8tdlEKpMoGNdWEZ
 lRffze2Ih77wTLw4vyyfK0/mJv6x+QuhBgWcdGDKg6Q7LBi4jBmwJdkMYFpyQjow0+NVACsq
 87jG4AWA/feriT1FsfrZbqIJwPS0IWAMUjFYODanz/B4BHkY/rbNM/D7yGkcLjb9iRsCnOzC
 YVZpN25oZUUeh9Ulv+8M55BvwT7dDDBgc9IT5s9V7zSCpCvUPLEw0KakF5x7qMWNJRaw+/r0
 zg04+QZMuVu40x+SE6awNq8UN656DK4XLAMjtoLPuupMjNgWzmsu7+Jz8HbeLcIo/hJA7ZB2
 V+APU3s0uGEJnHSEVU2uRvoA/LqnEjMOfh1mbExjRt4cNny7hw/CiqriXbts4ODL5F1Mw1+n
 SnbdygDwytNqIgs4aF85SPvKQdr/RxcDvAzYMHKlNJZResj5LHPuv2eOlklrwM73cQpsAOOT
 Ky7tAOOBdgB5OLXPPDQzWmRpLhImfc4oZFGKBAmjbAceesOzcdv90TL9/2NVUXx3Tzd3gUDg
 7nlUwKeszd/27Y62JGOFKiaeYeSMYk+H8Uxt1Vgae1ISUCm8ZBGw348fofkiidqK++t0xEJY
 umkklLG6RU1fr+7U9Q9aT0HtN62RmaKYjs3J+nKz0rGpm2tJ/LHOYxuDIXlBF+zPlygu3sxQ
 n7jS9VgXcPT82pqd9KV41Tp0q6LbP/g1aWV6meDTF2dOu/jZ+36c6KMO5siveqtj/CNxb+5C
 ugk1JesvfSRKpMad0w6kFsxbD4es/4MrZv3bbGwc2Y9S7/0ERrzDYLY3792Vp3ltY4HhDd6W
 EXZzoRes3nkoIKzm2IPhw7lpTLHtbE2V1GuiWhmt+6wxDD1uGZNIZv2yhwfy598U97NHDiHx
 9NnALd8lxULM3ZbcYYqjFAv5TrhCKfwXX8ItBscEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02SXUxTZxzG855zenpoqBxaZa9gdOvYxWpAQI2vH/Ej6vImEIEtW9hEoaFn
 yIBCWnDDXazYaGKNtKsKpTThQ8egOj6KlGKLsCpSJMikU1KUShAUx5QCXmgIViuaePfk+f3+
 z9WfIUXTVCSToyjilApZnoQWULbrknUxn+FceVxA/TlqvnWTRObmyzQ6rl8i0aUxHY1mrs8D
 VO5/RaLx7l2o63kVD3l7OgnkrDMQqPFSL4FadQxy1M4RqDfwjEYG1z2Apu6aCNQ1uh45u/op
 5LlqppHvcoCHquun+Oj0iJ1Gf/a9JpDrrIZA9slSgGyL1SRqmpmlkHs0Cg0t9fHQ4kszvXst
 9vybiE0PB2ncaRrj4yFfK4XLDbdo3NYgxZ7BYmy1nKKxdd7Ax27jIoXbLv6GHV41jc9ontN4
 bmqUwrPX7tK47IoFpIh/EOyQc3k5Rznlhp2ZgiMVlgpeYSnvl8dLf9NqYKS0IISB7CZYo/6P
 pwUCRsTaAeypXngPVsP6pRvkchbDxtdP+MuShoDW3/20FjAMza6HAwEm2K9k/SRsvlIHggck
 e5+EtpG0YBaz+2FL7SMimCn2CzjkmXrnCNmtsGK6hRfcgewGqHsYHqxD2G1w+o6JDNait4q+
 PmHZDof9lZPU8vo6qGmvIvWANX2ETB+hGkBYwGquUJWfna+KL0xQcD/HqmT5qmJFdmxWQb4V
 vHsGqdQOnBZ/rAsQDHAByJCSlcLUsiy5SCiXlRzjlAUZyuI8TuUCUQwl+UT4j7Y/Q8Rmy4q4
 XI4r5JQfKMGERKqJ6Ju3XzR8ZYhOf/LguPQPz0u3+evNzj2mVWJizVhcajhaSORvDHPuajiz
 IrlAH+MY/7/1wrPHZ8/zB35t3Bum3+9rcRXPDib21e8rCZXqLm4M9PvW+hO6S73DvsrWqKfe
 sttf5oyv+BS6ztd4mrj0trQ1w8b4FxUdfRPfMsmqcz9mLhg7Zzo7xt1JJQ1mOzV47bCwRaRo
 qs3N2xc6eyMiK+5AxkQEq7EZfyqr3PJNe8FYVtIdddpBNy9i+6aYvw7pTuTOWT0dTYLQyMnv
 UpNsaNW27zOTy+dThuSjzipn0cDJC9HNTgerlobV8lO8igmt1jEs6H1wbkTsJvfEnFpsk1Cq
 I7J4KalUyd4AmRghvnsDAAA=
X-CMS-MailID: 20230522104657epcas5p19117017c9dfd3d7a4860d2f9122b1277
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230522104657epcas5p19117017c9dfd3d7a4860d2f9122b1277
References: <20230522104146.2856-1-nj.shetty@samsung.com>
 <CGME20230522104657epcas5p19117017c9dfd3d7a4860d2f9122b1277@epcas5p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Mon, 22 May 2023 16:29:19 +0000
Subject: [dm-devel] [PATCH v11 8/9] dm: Enable copy offload for dm-linear
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
Cc: linux-block@vger.kernel.org, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-mm@kvack.org, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, ming.lei@redhat.com,
 James.Bottomley@HansenPartnership.com, linux-fsdevel@vger.kernel.org,
 dlemoal@kernel.org, Nitesh Shetty <nj.shetty@samsung.com>, joshi.k@samsung.com,
 nitheshshetty@gmail.com, bvanassche@acm.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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

