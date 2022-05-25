Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 219B0C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 25 May 2022 16:00:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-hxnv7cEiOZuJheEpkiZ8lw-1; Wed, 25 May 2022 12:00:07 -0400
X-MC-Unique: hxnv7cEiOZuJheEpkiZ8lw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14B9E3810D30;
	Wed, 25 May 2022 16:00:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 042DC1410DD5;
	Wed, 25 May 2022 16:00:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AB292194EB8F;
	Wed, 25 May 2022 16:00:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7EF23194EB82
 for <dm-devel@listman.corp.redhat.com>; Wed, 25 May 2022 15:50:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 625281410DDB; Wed, 25 May 2022 15:50:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E5671410DD5
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47D2B3C01C00
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:14 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383-GXNxMJx6PXGrB38Ficioug-1; Wed, 25 May 2022 11:50:12 -0400
X-MC-Unique: GXNxMJx6PXGrB38Ficioug-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220525155011euoutp0260ce36e71da926fdd2e21d6f01c7453b~yY9xNZBZ90326803268euoutp026
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220525155011euoutp0260ce36e71da926fdd2e21d6f01c7453b~yY9xNZBZ90326803268euoutp026
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220525155009eucas1p2d4bd13415b909eaaf6c6ca7e53c3fdb0~yY9vmoDnt0522505225eucas1p2N;
 Wed, 25 May 2022 15:50:09 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id F0.00.10260.1305E826; Wed, 25
 May 2022 16:50:09 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220525155008eucas1p2c843cc9098f2920e961f80ffaf535789~yY9vPWFha2575925759eucas1p23;
 Wed, 25 May 2022 15:50:08 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220525155008eusmtrp1a64719bbb66a103e535236dc149d926e~yY9vMaFka1510315103eusmtrp1M;
 Wed, 25 May 2022 15:50:08 +0000 (GMT)
X-AuditID: cbfec7f5-bddff70000002814-e6-628e503101f0
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id F0.27.09522.0305E826; Wed, 25
 May 2022 16:50:08 +0100 (BST)
Received: from localhost (unknown [106.210.248.20]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220525155008eusmtip1a64c0e3e336ababa11af2ab44dfa7e53~yY9u2GdvG1782817828eusmtip1c;
 Wed, 25 May 2022 15:50:08 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, damien.lemoal@opensource.wdc.com, snitzer@redhat.com,
 Johannes.Thumshirn@wdc.com, hch@lst.de, hare@suse.de
Date: Wed, 25 May 2022 17:49:57 +0200
Message-Id: <20220525154957.393656-9-p.raghav@samsung.com>
In-Reply-To: <20220525154957.393656-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsWy7djPc7qGAX1JBsdu8FmsvtvPZvH77Hlm
 i73vZrNaXPjRyGRx88BOJos9iyYxWaxcfZTJ4sn6WcwWPQc+sFj87brHZLH3lrbF5V1z2Czm
 L3vKbvF5aQu7RdvGr4wO/B7/Tqxh87h8ttRj06pONo/NS+o9dt9sYPPY2Xqf1eP9vqtsHn1b
 VjF6rN9ylcVj8+lqj8+b5DzaD3QzBfBEcdmkpOZklqUW6dslcGXMW/eGreAbe0XXa7MGxnVs
 XYycHBICJhJ/T9xh72Lk4hASWMEosf7NXEYI5wujxImtHWwQzmdGiS0HX8G1PH97kRkisZxR
 ou/iFhaQhJDAC0aJKYtquhg5ONgEtCQaO8HGigg0MkpMfXkCbCyzwFdGiRsHnzOCNAgLeEp0
 N04Dm8oioCox+fJ7sEG8AlYSLQveM0Nsk5eYeek7O4jNKWAtMX//Z2aIGkGJkzOfgNUzA9U0
 b50NdpGEwGJOiaN7rkCd6iKx+OITJghbWOLV8S3sELaMxOnJPSwQdrXE0xu/oZpbGCX6d65n
 A3lBAmhb35kcEJNZQFNi/S59iHJHiZ+N15ghKvgkbrwVhDiBT2LStulQYV6JjjYhiGoliZ0/
 n0AtlZC43DQHaqmHxJSTF1gmMCrOQvLMLCTPzELYu4CReRWjeGppcW56arFxXmq5XnFibnFp
 Xrpecn7uJkZg2jv97/jXHYwrXn3UO8TIxMF4iFGCg1lJhPfC094kId6UxMqq1KL8+KLSnNTi
 Q4zSHCxK4rzJmRsShQTSE0tSs1NTC1KLYLJMHJxSDUyJ6TkRuum2ISueNB1e+yQ47OuCfMP0
 k10y4j/ecET7zHvWlHVB8MK1K+UCWytTMv/vCPzxVvbMu+aY2u0e07r+Tlg2dWrSrM9nV6+c
 uyn6ycfq+Ly+m8cWO9n1eZzZ78la8WzdH+m7m8xf3dA6xrBr0pLMoM4VX+W4b2/7HyW4meXO
 /i2sX7bYG6kmZDi9upBx+PmOSVGZq8tmXN+3dkuX0fRao0k7/iSV2ASveXOOyaq3kOmR3kGD
 ICEeq5ai3R5nr3tY6Nft3+/G7W2ROiVZauukrqNvHj6uYz2+QaYwvdRRPJbn4aG3sk9L9X6I
 pcQcnu1nffBe+qn+iexPrDKaVqb4lTz49o9/hsFtxnWlSizFGYmGWsxFxYkADVfSLuoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t/xu7oGAX1JBrOe6lmsvtvPZvH77Hlm
 i73vZrNaXPjRyGRx88BOJos9iyYxWaxcfZTJ4sn6WcwWPQc+sFj87brHZLH3lrbF5V1z2Czm
 L3vKbvF5aQu7RdvGr4wO/B7/Tqxh87h8ttRj06pONo/NS+o9dt9sYPPY2Xqf1eP9vqtsHn1b
 VjF6rN9ylcVj8+lqj8+b5DzaD3QzBfBE6dkU5ZeWpCpk5BeX2CpFG1oY6RlaWugZmVjqGRqb
 x1oZmSrp29mkpOZklqUW6dsl6GXMW/eGreAbe0XXa7MGxnVsXYycHBICJhLP315k7mLk4hAS
 WMoocar/AjNEQkLi9sImRghbWOLPtS6wBiGBZ4wSH3ZrdzFycLAJaEk0drKD9IoIdDJKzNnX
 CuYwC/xnlPjTcRGsWVjAU6K7cRpYM4uAqsTky+9ZQGxeASuJlgXvoZbJS8y89J0dxOYUsJaY
 v/8zM8QyK4mvd76yQtQLSpyc+QSslxmovnnrbOYJjAKzkKRmIUktYGRaxSiSWlqcm55bbKhX
 nJhbXJqXrpecn7uJERih24793LyDcd6rj3qHGJk4GA8xSnAwK4nwXnjamyTEm5JYWZValB9f
 VJqTWnyI0RTo7onMUqLJ+cAUkVcSb2hmYGpoYmZpYGppZqwkzutZ0JEoJJCeWJKanZpakFoE
 08fEwSnVwLT8TdKR9fHVn7LiXvbuO/F603rt914ZSf9WP+KKPLZwilHkxQfNRlP0w5Zu/8Ne
 F6WX6a3lrOYjpjZB5fZZdUmD7Aa1f1cncGZ+vGv2x97q1aufmzzYr7YkfDu2tW1Ww4lEv3Yf
 fZ3Drp9uCX7X9IndVbN95aWK0j1LXI593+0Y01nmtWfTBbXDHM/s/t1QTWq18g4/MtNfaPIp
 jrQnukVzJvs+m1Whttwr0/6VjHReo0tK5I2Y/3J2jVXuDxx3Pv603vSSe/HMvninLXmGm+LX
 TFvna3TNaea2M2t790UFXcq4vLLo6Mq+ktdWXW9368wt8DXbsOef5skakSDLwBm7p6yS/RJQ
 2P1ue9Wn43uVWIozEg21mIuKEwHyFF8FWQMAAA==
X-CMS-MailID: 20220525155008eucas1p2c843cc9098f2920e961f80ffaf535789
X-Msg-Generator: CA
X-RootMTR: 20220525155008eucas1p2c843cc9098f2920e961f80ffaf535789
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220525155008eucas1p2c843cc9098f2920e961f80ffaf535789
References: <20220525154957.393656-1-p.raghav@samsung.com>
 <CGME20220525155008eucas1p2c843cc9098f2920e961f80ffaf535789@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH v6 8/8] dm: ensure only power of 2 zone sizes are
 allowed
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Ensure that only power of 2 zoned devices are enabled for dm targets that
supports zoned devices. This constraint can be relaxed once non power of
2 zone size support is added to the DM layer.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/md/dm-table.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 03541cfc2317..2a8af70d1d4a 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -251,6 +251,12 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 	if (bdev_is_zoned(bdev)) {
 		unsigned int zone_sectors = bdev_zone_sectors(bdev);
 
+		if (!is_power_of_2(zone_sectors)) {
+			DMWARN("%s: %pg only power of two zone size supported",
+			       dm_device_name(ti->table->md), bdev);
+			return 1;
+		}
+
 		if (start & (zone_sectors - 1)) {
 			DMWARN("%s: start=%llu not aligned to h/w zone size %u of %pg",
 			       dm_device_name(ti->table->md),
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

