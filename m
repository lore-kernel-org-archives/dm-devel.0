Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CC30C6FA91
	for <dm-devel@archiver.kernel.org>; Tue, 20 Sep 2022 09:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663665106;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8w07r74GgA7Uyd8ojEZv8X0WK3gEgHX+x2NcLOEBLhA=;
	b=Zf+w6ULTc6NTUuw429f6GWXo4Zuqi0e4ugvTATxxdgy5UP4tbhFG+alXt3TLEwXezqjdvK
	9KM8VguyhbLZBBsx6CXbjCFxh+PUExeZhko749kGtjqTlJ3F/c0AHsamRx8rMr6kHlC5mg
	/Sq0h26pKqR6qaR2PMgl+Jj7J5hA3dQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-aj-HcDsyPo6mvEAjSADE5g-1; Tue, 20 Sep 2022 05:11:43 -0400
X-MC-Unique: aj-HcDsyPo6mvEAjSADE5g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16DD980C8C5;
	Tue, 20 Sep 2022 09:11:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 03B3C2166B36;
	Tue, 20 Sep 2022 09:11:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E4E1F19465A3;
	Tue, 20 Sep 2022 09:11:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 98DCD19465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 09:11:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8B52540C206B; Tue, 20 Sep 2022 09:11:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8411D40C2064
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64731299E74B
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:37 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-xri_r7c7PPqCotm9mnbezQ-1; Tue, 20 Sep 2022 05:11:34 -0400
X-MC-Unique: xri_r7c7PPqCotm9mnbezQ-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220920091133euoutp023adb46c99be5cc4942c2805092dd1d1a~Whpaal3pH2895428954euoutp02H
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220920091133euoutp023adb46c99be5cc4942c2805092dd1d1a~Whpaal3pH2895428954euoutp02H
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220920091131eucas1p247204f6a63f7aefc2c1301f141ebda8f~WhpYddF052051120511eucas1p2E;
 Tue, 20 Sep 2022 09:11:31 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 20.3E.29727.3C389236; Tue, 20
 Sep 2022 10:11:31 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220920091131eucas1p1ab4ef3ac98b2fd27c546a44b583a1745~WhpX4jabH2927429274eucas1p1e;
 Tue, 20 Sep 2022 09:11:31 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220920091131eusmtrp1377130c21e3f808f237dad059e13bbd8~WhpX3npdA0212802128eusmtrp1y;
 Tue, 20 Sep 2022 09:11:31 +0000 (GMT)
X-AuditID: cbfec7f2-205ff7000001741f-4f-632983c3706c
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 2B.53.10862.2C389236; Tue, 20
 Sep 2022 10:11:30 +0100 (BST)
Received: from localhost (unknown [106.210.248.192]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220920091130eusmtip28e17e5680947414d0bbdb37cc38fc1db~WhpXgqteE2421324213eusmtip2H;
 Tue, 20 Sep 2022 09:11:30 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 20 Sep 2022 11:11:16 +0200
Message-Id: <20220920091119.115879-11-p.raghav@samsung.com>
In-Reply-To: <20220920091119.115879-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsWy7djPc7qHmzWTDW5eUbFYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAniiuGxSUnMyy1KL9O0SuDI+LP/LVrCG
 r2L+hwuMDYyXuLsYOTkkBEwkNp6ZxtTFyMUhJLCCUeL69m8sEM4XRonulg+sEM5nRok/2zYy
 djFygLWs+CQKEV/OKHHo7ReoopeMEnePrWcDKWIT0JJo7GQHWSEikC7x9esGRpAaZoGXTBLN
 51cygySEBSIlJr27zQRiswioSmx40QTWwCtgLXG+tYMF4j55iZmXvoPFOYHic3a3sEHUCEqc
 nPkErIYZqKZ562xmkAUSAus5Ja6sXMkGcamLxKHNUHOEJV4d38IOYctInJ7cAxWvlnh64zdU
 bwujRP/O9VC91hJ9Z3JATGYBTYn1u/Qhyh0lXi9fzAJRwSdx460gxAV8EpO2TWeGCPNKdLQJ
 QVQrSez8+QRqqYTE5aY5UEs9JBqv3WaZwKg4C8kvs5D8Mgth7wJG5lWM4qmlxbnpqcWGeanl
 esWJucWleel6yfm5mxiBSfD0v+OfdjDOffVR7xAjEwfjIUYJDmYlEd4Wf81kId6UxMqq1KL8
 +KLSnNTiQ4zSHCxK4rzJmRsShQTSE0tSs1NTC1KLYLJMHJxSDUzmgV5zrGfnFhXP1pmnp5XO
 1zDr+ddyhsh9BoGtbnxhwsyhhY9vfFZ7prCHI2bi2j+/Is6cEOfbJCLnJNzQGWm58qnbZdHD
 IdzlPzm46z1NmBOsb6fPe3dHqkPpf8X2Z/Gv3tsEfxVufRnMvrtvlvz/Ow5nH+T8nfL+R6nC
 ihNHrAON10cwnfZ5bTP7TCvT0liG1dar96htnXZNwrFu7/0+FaaS2mc3qk4z+LQyr/e9KnTX
 9fFk9XtG2/4X/ZFiTzu9Z/opO51tB+dlyIgE1YgoO88O2dq0yiyeo+2W667dpj6HXU3ebF49
 VXbXZPnlDRKsc/Yeu3dKJKQibXe3mOp35gmizKZxAf4R1mefrFJiKc5INNRiLipOBADIjk7K
 8QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t/xe7qHmjWTDaauNrdYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAnii9GyK8ktLUhUy8otLbJWiDS2M9Awt
 LfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DI+LP/LVrCGr2L+hwuMDYyXuLsYOTgkBEwk
 VnwS7WLk4hASWMoocffUa8YuRk6guITE7YVNULawxJ9rXWwQRc8ZJZqevWMGaWYT0JJo7GQH
 qRERyJU4vHkCE0gNs8B3JomGnwdYQWqEBcIltpzSB6lhEVCV2PCiCayeV8Ba4nxrBwvEfHmJ
 mZe+g8U5geJzdrewgdhCAlYSHbM2s0HUC0qcnPkErJ4ZqL5562zmCYwCs5CkZiFJLWBkWsUo
 klpanJueW2ykV5yYW1yal66XnJ+7iREYr9uO/dyyg3Hlq496hxiZOBgPMUpwMCuJ8Lb4ayYL
 8aYkVlalFuXHF5XmpBYfYjQFunsis5Rocj4wYeSVxBuaGZgamphZGphamhkrifN6FnQkCgmk
 J5akZqemFqQWwfQxcXBKNTDJ/g1nP878ymvO5Haz3ZYq2y8/n23870yKZq1mTnrFrZBr9Yvf
 SXf8uRW3WIsxfeaLzFWPSkQKNSvn23+8tSj5OfcTpTtbNjUuW/Gj7FfEowczYic2dczm2f7y
 0+VbFWlJx9bZvU7YdWaKxPvQ7Ktf99ovK4r9OfXlpkNb72VKTdLaIN243Hza/O0dVzQTp0Xe
 qP3IU5vV9mznGfYM9n4Ws+8f9uu/3d6c3iDg9kiwIatua3D6Xfv+s+29Qe0nmqTadvT4LRaZ
 yfnm9/MFC7x17PJNrF09fj77Y6NZbT5x7dnmCbqvCzap7NApqnuteVRj55t1rUF3dynVzCrs
 u70mXdFBy3j9hwgeid2eB7KVlFiKMxINtZiLihMBzBSj1WADAAA=
X-CMS-MailID: 20220920091131eucas1p1ab4ef3ac98b2fd27c546a44b583a1745
X-Msg-Generator: CA
X-RootMTR: 20220920091131eucas1p1ab4ef3ac98b2fd27c546a44b583a1745
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220920091131eucas1p1ab4ef3ac98b2fd27c546a44b583a1745
References: <20220920091119.115879-1-p.raghav@samsung.com>
 <CGME20220920091131eucas1p1ab4ef3ac98b2fd27c546a44b583a1745@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH v14 10/13] dm-table: allow zoned devices with non
 power-of-2 zone sizes
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, bvanassche@acm.org,
 pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 jaegeuk@kernel.org, matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Allow dm to support zoned devices with non power-of-2(po2) zone sizes as
the block layer now supports it.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-table.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index e42016359a77..38b83c383e8f 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -250,7 +250,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 	if (bdev_is_zoned(bdev)) {
 		unsigned int zone_sectors = bdev_zone_sectors(bdev);
 
-		if (start & (zone_sectors - 1)) {
+		if (!bdev_is_zone_start(bdev, start)) {
 			DMERR("%s: start=%llu not aligned to h/w zone size %u of %pg",
 			      dm_device_name(ti->table->md),
 			      (unsigned long long)start,
@@ -267,7 +267,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		 * devices do not end up with a smaller zone in the middle of
 		 * the sector range.
 		 */
-		if (len & (zone_sectors - 1)) {
+		if (!bdev_is_zone_start(bdev, len)) {
 			DMERR("%s: len=%llu not aligned to h/w zone size %u of %pg",
 			      dm_device_name(ti->table->md),
 			      (unsigned long long)len,
@@ -1647,8 +1647,7 @@ static int validate_hardware_zoned_model(struct dm_table *t,
 		return -EINVAL;
 	}
 
-	/* Check zone size validity and compatibility */
-	if (!zone_sectors || !is_power_of_2(zone_sectors))
+	if (!zone_sectors)
 		return -EINVAL;
 
 	if (dm_table_any_dev_attr(t, device_not_matches_zone_sectors, &zone_sectors)) {
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

