Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97079C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  5 May 2022 13:51:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-TdL0LILfMx2gBcvPKcU6fQ-1; Thu, 05 May 2022 09:51:35 -0400
X-MC-Unique: TdL0LILfMx2gBcvPKcU6fQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 448FB294EDC1;
	Thu,  5 May 2022 13:51:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7C7FD403D195;
	Thu,  5 May 2022 13:51:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2E62C1947047;
	Thu,  5 May 2022 13:51:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A17821947043
 for <dm-devel@listman.corp.redhat.com>; Thu,  5 May 2022 13:51:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 80BFCC15E71; Thu,  5 May 2022 13:51:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CD58C27EBA
 for <dm-devel@redhat.com>; Thu,  5 May 2022 13:51:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A492960C02
 for <dm-devel@redhat.com>; Thu,  5 May 2022 13:51:21 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-TdBPQdbRNjCth56Oj9Fzyw-1; Thu, 05 May 2022 09:51:15 -0400
X-MC-Unique: TdBPQdbRNjCth56Oj9Fzyw-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220505135114euoutp01aaf379f67929a08e521e68a13478ac0d~sOcNG1WOy3079530795euoutp01K
 for <dm-devel@redhat.com>; Thu,  5 May 2022 13:51:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220505135114euoutp01aaf379f67929a08e521e68a13478ac0d~sOcNG1WOy3079530795euoutp01K
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220505135112eucas1p1f5543b0d1b522e3f7a73821940c9d5ed~sOcLiaiOK1070010700eucas1p1J;
 Thu,  5 May 2022 13:51:12 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id B3.0D.10009.056D3726; Thu,  5
 May 2022 14:51:12 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220505135111eucas1p218b79f4b1e54bb3a24d2ec189ec445d1~sOcKzFSGC0041400414eucas1p29;
 Thu,  5 May 2022 13:51:11 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220505135111eusmtrp131b2472d47e1950f5d2b04b938f6ee9e~sOcKyPmFR1310613106eusmtrp1j;
 Thu,  5 May 2022 13:51:11 +0000 (GMT)
X-AuditID: cbfec7f2-e7fff70000002719-52-6273d6501c0d
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id CD.6A.09404.F46D3726; Thu,  5
 May 2022 14:51:11 +0100 (BST)
Received: from localhost (unknown [106.210.248.170]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220505135111eusmtip25f1e0efa88e3a562d73f5ea4b94fbc5f~sOcKeCtqw1486514865eusmtip2I;
 Thu,  5 May 2022 13:51:11 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, hch@lst.de, damien.lemoal@opensource.wdc.com,
 dsterba@suse.com, jaegeuk@kernel.org, bvanassche@acm.org, hare@suse.de
Date: Thu,  5 May 2022 15:47:11 +0200
Message-Id: <20220505134710.132630-12-p.raghav@samsung.com>
In-Reply-To: <20220505134710.132630-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01SbUxTZxjlve/t7W23NtdK5jsomHXMBIxFXOPupjFua7K7OTOZP7ZpjLZw
 RTZaSSsbG2YpguVDtNXNbZbilA2krbNY+RDxo2syoK2Mhs7ZmoFA2mSSiWAxUt3YWi5m/jvP
 Oed5z3OSl4SSGV4aWazdx+q0qhIZIcS7+uK/rtryu169+nv/87TT1wdpx4iJoL+ZjkP68eAQ
 pK9MNfLowFwlRofdPRh9ufkYRtscv2B0xGmBdIN7Gqdt1eOQDl6yErTZ+ADSIXMU0LGWaj59
 NhzF6YFb6RslTPC3Tcz8wFmC6bGM8JngYBnjstcRzGnDccj0hg0J/uBtHnPv6g2COdJhB4yz
 4wbOXPBXMDFXJlPjPoRtEW8Tri9kS4o/ZXW5G3YJ9/QHA6D0a2G5L+gABtBK1gMBiSgFehhp
 hfVASEqoNoCMXXUgKUioWYAcVQpOiAHU1jCFPdkIDLUCTjgDkC8wRnDDHYACN9v49YAkCSoH
 Vdbxk3wqdQigwaq/8OQAKS+Gjs/d5yefWkptRe3nWxfycOol9M/syYUIEbUOtbkGCC5uOTox
 /HDBL0jw1rpxHudZgrwnIngSw4SnqrNxoQSifAJkjd6F3LISjVmnAIeXosn+Dj6Hpcj/VQPO
 4QoUDT1eXK4GyNTjJJIVUCLtyPWSJIRUNnJeyuXsryPbv8mbkw4xCt1dwp0gRse6voUcLUK1
 RgnnlqGeeGQxFKHgAetiKIP+cHlxM3jB8lQZy1NlLP/nngLQDpaxZXpNEavP07KfyfUqjb5M
 WyQv2KtxgcSv9M/3378ImiZn5B6AkcADEAllqaI3W0rVElGh6vMvWN3enbqyElbvAekkLlsm
 KihuV0moItU+9hOWLWV1T1SMFKQZsOpC93i23daQ/hP2seO9zj9blsvfNu0abfFl7m5Se1kI
 f6iQO38uqNr28oY3Tnf7j24SxF/k5/gnpBm9OyyvXM9dg10L7Xx2perdZ1Tnat95f2ssYr8w
 Qa3o3b4eqOdoZbhGUR5qDl48E8lakzVkeS31g/KP8o3GRqj98fyd6QPbXf0bHx0uOlj+XPt8
 YbplRpeS/0jPfDeckgJn80ynCtQec7M5T3rTMPrWuYyYR8EzN6XV3FsRGNXMbS6dGNl/q/bw
 rNSWJR7O7Bz5ku+e3C9eB1avNLPxvpOa+ssPlGutps0fZjBSRbgbxV/tO5o2VJl/W5kt8O7u
 HvtbeTU3ulaG6/eo8nKgTq/6D/qtA9EEBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t/xe7r+14qTDJZd0rBYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS0u/Ghksrh5YCeTxZ5Fk5gsVq4+ymTxZP0sZoueAx9YLFa2PGS2
 uLxrDpvFhLavzBY3JjxltPi8tIXdYs3NpywWJ25JOwh5XL7i7fHvxBo2j52z7rJ7XD5b6rFp
 VSebx8KGqcweu282AMVb77N6vN93lc2jb8sqRo/1W66yeGw+Xe3xeZOcR/uBbqYAvig9m6L8
 0pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy1CJ9uwS9jOOXLzAWTOGq
 OHV5NWMD4zKOLkZODgkBE4kL55cxdjFycQgJLGWUmHL8FgtEQkLi9sImRghbWOLPtS42iKLn
 jBJ313QBJTg42AS0JBo72UHiIgJTGSUubL/AAuIwC1xlkri4eT8zSLewQKDE/t6jYJNYBFQl
 /n6ZxwRi8wpYS6zYdIINYoO8xMxL39lBbE6g+JzOh6wgtpCAlcTEh+/YIOoFJU7OfAJ2HTNQ
 ffPW2cwTGAVmIUnNQpJawMi0ilEktbQ4Nz232EivODG3uDQvXS85P3cTIzCutx37uWUH48pX
 H/UOMTJxMB5ilOBgVhLhdV5akCTEm5JYWZValB9fVJqTWnyI0RTo7onMUqLJ+cDEklcSb2hm
 YGpoYmZpYGppZqwkzutZ0JEoJJCeWJKanZpakFoE08fEwSnVwCTeXTNtRfn7G4HrZKYESNgq
 lfwIffq7W+bLx+q+Vw6+i1MnblA+mMJ9P/ey2tUD4a2z7v2WkFI7mNTHucvv7sXibbyNPYGc
 mh6y+rbHxHi11s5we5TbF/Xv4mSd4ukq6m+uaWZl8MTrBudlLVGQ/75dhoVTxFnjpOPvxXsq
 9T5yMnad7V407xJbu57ryisqK1h1tO8+uTNPaNPjx4wnpbQExWp2hjw6bOAWa6ylczy3Pi2k
 gynVqGvqq6oFm/jkenwtDsp1RS9SVTgYfWjhvYPWXL5PAlwWn2dSErsdIDh1dnxd0oZ4mZ1V
 PXVXTRTOBKn3TLr5rXVD9/ylBdPd5xfl7Pc96vtV0bJw2vsaJZbijERDLeai4kQAYjOhCXQD
 AAA=
X-CMS-MailID: 20220505135111eucas1p218b79f4b1e54bb3a24d2ec189ec445d1
X-Msg-Generator: CA
X-RootMTR: 20220505135111eucas1p218b79f4b1e54bb3a24d2ec189ec445d1
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220505135111eucas1p218b79f4b1e54bb3a24d2ec189ec445d1
References: <20220505134710.132630-1-p.raghav@samsung.com>
 <CGME20220505135111eucas1p218b79f4b1e54bb3a24d2ec189ec445d1@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH v2 11/11] dm-zoned: ensure only power of 2 zone
 sizes are allowed
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, dm-devel@redhat.com,
 pankydev8@gmail.com, gost.dev@samsung.com, Mike Snitzer <snitzer@kernel.org>,
 jiangbo.365@bytedance.com, linux-kernel@vger.kernel.org,
 Luis Chamberlain <mcgrof@kernel.org>, Alasdair Kergon <agk@redhat.com>,
 jonathan.derrick@linux.dev, matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Luis Chamberlain <mcgrof@kernel.org>

Today dm-zoned relies on the assumption that you have a zone size
with a power of 2. Even though the block layer today enforces this
requirement, these devices do exist and so provide a stop-gap measure
to ensure these devices cannot be used by mistake

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/md/dm-zone.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 3e7b1fe15..27dc4ddf2 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -231,6 +231,18 @@ static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
 	struct request_queue *q = md->queue;
 	unsigned int noio_flag;
 	int ret;
+	struct block_device *bdev = md->disk->part0;
+	sector_t zone_sectors;
+	char bname[BDEVNAME_SIZE];
+
+	zone_sectors = bdev_zone_sectors(bdev);
+
+	if (!is_power_of_2(zone_sectors)) {
+		DMWARN("%s: %s only power of two zone size supported\n",
+		       dm_device_name(md),
+		       bdevname(bdev, bname));
+		return 1;
+	}
 
 	/*
 	 * Check if something changed. If yes, cleanup the current resources
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

