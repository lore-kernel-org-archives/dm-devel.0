Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28B1AC04A68
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jul 2022 16:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658940934;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ym9zf57tU3FHzTTSPMAb3CoNcLstRg0OkaUH8b85tbM=;
	b=WAib72EY+D6aiCIFHmY184ViPzxpcjK1T9+mVoiXUXHTNq/P80P4RQ6pO/ezDk4XyYv1SJ
	uwQ7vd0nHbYt9/PVIVCNB9jdVDfnB/3v8bu6MtUvAwtaOLgBRbRG9lHbS7lojPsAO4Y/M0
	xZ0qAq8qWg0YJQ0smZmsJMMRG5EcNc4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-FBkwEipRNB-ymNuLoYpzgg-1; Wed, 27 Jul 2022 12:55:31 -0400
X-MC-Unique: FBkwEipRNB-ymNuLoYpzgg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C07051C01B3C;
	Wed, 27 Jul 2022 16:55:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AE88040CFD0A;
	Wed, 27 Jul 2022 16:55:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2B8971945DB5;
	Wed, 27 Jul 2022 16:55:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B146E1945DA2
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Jul 2022 16:31:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A680CC28100; Wed, 27 Jul 2022 16:31:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A1B2AC2812B
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:31:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B3EE85A587
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:31:26 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-380-MpKHhyCSPLibxOIOrpa9pw-1; Wed, 27 Jul 2022 12:31:25 -0400
X-MC-Unique: MpKHhyCSPLibxOIOrpa9pw-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220727162255euoutp010aac07811f14ecd477d8428130dbe6dd~FvDVwrHzx2487324873euoutp012
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:22:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220727162255euoutp010aac07811f14ecd477d8428130dbe6dd~FvDVwrHzx2487324873euoutp012
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220727162254eucas1p233f05f6d0ebf6420e5c5a1ede6933299~FvDUgkQdX2220522205eucas1p24;
 Wed, 27 Jul 2022 16:22:54 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 36.E8.09580.E5661E26; Wed, 27
 Jul 2022 17:22:54 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220727162253eucas1p1a5912e0494f6918504cc8ff15ad5d31f~FvDUBWZKL2552225522eucas1p1j;
 Wed, 27 Jul 2022 16:22:53 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220727162253eusmtrp22d668828082dcd16db4e000e6aa34a22~FvDUAjAdg0811608116eusmtrp2x;
 Wed, 27 Jul 2022 16:22:53 +0000 (GMT)
X-AuditID: cbfec7f5-9c3ff7000000256c-e4-62e1665ea39d
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id CB.1E.09095.D5661E26; Wed, 27
 Jul 2022 17:22:53 +0100 (BST)
Received: from localhost (unknown [106.210.248.8]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220727162253eusmtip153d4fe6af3d463321ed8ca423b743eac~FvDTsxnYN0064100641eusmtip1R;
 Wed, 27 Jul 2022 16:22:53 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: damien.lemoal@opensource.wdc.com, hch@lst.de, axboe@kernel.dk,
 snitzer@kernel.org, Johannes.Thumshirn@wdc.com
Date: Wed, 27 Jul 2022 18:22:41 +0200
Message-Id: <20220727162245.209794-8-p.raghav@samsung.com>
In-Reply-To: <20220727162245.209794-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsWy7djPc7pxaQ+TDNp3sFisvtvPZjHtw09m
 i99nzzNb7H03m9Xi5oGdTBZ7Fk1isli5+iiTxZP1s5gt/nbdY7LYe0vb4vKuOWwW85c9ZbeY
 0PaV2eLGhKeMFp+XtrBbrLn5lMXixC1pB0GPy1e8PXbOusvucflsqcemVZ1sHpuX1HvsvtnA
 5rGz9T6rx/t9V9k8+rasYvTYfLra4/MmOY/2A91MATxRXDYpqTmZZalF+nYJXBl9dy6wFkzl
 rrhw6ANTA2MXZxcjJ4eEgInEobV/WLsYuTiEBFYwSjQfnMQM4XxhlNg54TQLSJWQwGdGiTML
 YmE6Tr9dzgJRtJxR4uru2WwQznNGie1/NgLN4uBgE9CSaOxkB2kQESiWePiuFayBWeAAk8Tv
 Q/eZQRLCAsESZ7buYgSpZxFQlbjzUQ0kzCtgJfHx6SxmiGXyEjMvfQebwylgLbF5yjwmiBpB
 iZMzn4AdxwxU07x1NtjVEgLrOSW2XNnJDtHsIvF1wU6oQcISr45vgYrLSPzfOZ8Jwq6WeHrj
 N1RzC6NE/871bCAHSQBt6zuTA2IyC2hKrN+lD1HuKHF/4l5GiAo+iRtvBSFO4JOYtG06M0SY
 V6KjTQiiWkli588nUEslJC43zWGBsD0k9i2bzzKBUXEWkmdmIXlmFsLeBYzMqxjFU0uLc9NT
 i43zUsv1ihNzi0vz0vWS83M3MQKT4Ol/x7/uYFzx6qPeIUYmDsZDjBIczEoivAnR95OEeFMS
 K6tSi/Lji0pzUosPMUpzsCiJ8yZnbkgUEkhPLEnNTk0tSC2CyTJxcEo1MBUoTlhY4DCNwdf9
 2ymJNzdjNjNz886pfzrrdfS0TarGt2e5PQryPGb6u2Px26LOQq1PW6O/SxqlsiptS3JZljgx
 /llBdZr/ooL0uuOf4oN2iMS1RKU23go+6l7CP1/du6Sq6f3db43SnGbCzJ13XpgcLra0bw/d
 1mnqOHXl4gWHxQ72CaYpRbz9tUpPirneStN1vWFi1aopKhXbvbUT2V/N+McmabosJ2+C353l
 r9uz9CvWX7u4ZGeZfpL2yytJ7s4h98+kyq90P85u3dd+8d/8rbnHGypeV6z/aNb9vj3Tcd1G
 7jssKr0mFr6btt9xDpq4eM5qs4P1Xa8OnMhRPqxw+NO6Sscvt4931xxPVGIpzkg01GIuKk4E
 AGlHgy3xAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t/xu7qxaQ+TDA7tkbNYfbefzWLah5/M
 Fr/Pnme22PtuNqvFzQM7mSz2LJrEZLFy9VEmiyfrZzFb/O26x2Sx95a2xeVdc9gs5i97ym4x
 oe0rs8WNCU8ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAnii9GyK8ktLUhUy8otLbJWiDS2M9Awt
 LfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DL67lxgLZjKXXHh0AemBsYuzi5GTg4JAROJ
 02+Xs3QxcnEICSxllFj58RQjREJC4vbCJihbWOLPtS42iKKnjBLX2l+ydjFycLAJaEk0drKD
 mCIClRJnv8iClDALnGOSWHnhNhNIr7BAoMS6hn42kBoWAVWJOx/VQMK8AlYSH5/OYoYYLy8x
 89J3dhCbU8BaYvOUeWCtQkA1zx58ZIOoF5Q4OfMJC4jNDFTfvHU28wRGgVlIUrOQpBYwMq1i
 FEktLc5Nzy021CtOzC0uzUvXS87P3cQIjNdtx35u3sE479VHvUOMTByMhxglOJiVRHgTou8n
 CfGmJFZWpRblxxeV5qQWH2I0BTp7IrOUaHI+MGHklcQbmhmYGpqYWRqYWpoZK4nzehZ0JAoJ
 pCeWpGanphakFsH0MXFwSjUwbROfev/Onbu3ft9yjM3+2iC3zm56J/OMXXtMqhwaJHcKvLzo
 7d65b3Lzd5N735utvj+xccndmHbkFtfTP/vvHwtesVhwW7RRcYb6r2tsh27IClUw7kziczz5
 LcsghlMq0NGwK+RY+PU378IdfqyOMFG+maBiWnlBz1Xz+XfBW9k94cX/zxzeMDX5xiybm1NX
 bKqP4J3gqqWcezFIrS7wv+ODReXLnyrM7ZHqSTlwJ19kluxqf69iJ/mzlhtZ1jxLP1isWfM8
 XfLD7sAbcwR0jJpPn91W8njhVCXzx3umHjtUGZLwyElmb+nVzPCuiRJhnI+YxDzKfe3DOE6u
 1p+v/GfP7wq3mL5jRacrhKtNlViKMxINtZiLihMBuerqPWADAAA=
X-CMS-MailID: 20220727162253eucas1p1a5912e0494f6918504cc8ff15ad5d31f
X-Msg-Generator: CA
X-RootMTR: 20220727162253eucas1p1a5912e0494f6918504cc8ff15ad5d31f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220727162253eucas1p1a5912e0494f6918504cc8ff15ad5d31f
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162253eucas1p1a5912e0494f6918504cc8ff15ad5d31f@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH v8 07/11] dm-zoned: ensure only power of 2 zone
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, bvanassche@acm.org,
 pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Luis Chamberlain <mcgrof@kernel.org>

dm-zoned relies on the assumption that the zone size is a
power-of-2(po2) and the zone capacity is same as the zone size.

Ensure only po2 devices can be used as dm-zoned target until a native
non po2 support is added.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/md/dm-zoned-target.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 95b132b52f33..16499b75c5ee 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -792,6 +792,10 @@ static int dmz_fixup_devices(struct dm_target *ti)
 				return -EINVAL;
 			}
 			zone_nr_sectors = bdev_zone_sectors(bdev);
+			if (!is_power_of_2(zone_nr_sectors)) {
+				ti->error = "Zone size is not power of 2";
+				return -EINVAL;
+			}
 			zoned_dev->zone_nr_sectors = zone_nr_sectors;
 			zoned_dev->nr_zones = bdev_nr_zones(bdev);
 		}
@@ -804,6 +808,10 @@ static int dmz_fixup_devices(struct dm_target *ti)
 			return -EINVAL;
 		}
 		zoned_dev->zone_nr_sectors = bdev_zone_sectors(bdev);
+		if (!is_power_of_2(zoned_dev->zone_nr_sectors)) {
+			ti->error = "Zone size is not power of 2";
+			return -EINVAL;
+		}
 		zoned_dev->nr_zones = bdev_nr_zones(bdev);
 	}
 
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

