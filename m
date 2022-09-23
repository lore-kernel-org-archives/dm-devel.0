Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27BD9C6FA82
	for <dm-devel@archiver.kernel.org>; Fri, 23 Sep 2022 17:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663954605;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RPUjXoy/I4wmstxi8pEcNi2ISwWmXasYElj7VOoSvcs=;
	b=JzruQyD9WJfQflRrbfWVox4aNWMEx95qfgawiY2TKz08QllUvSRZyPNuBVqbHr50pz1HgW
	n2as+GE7jPGlX9pRg8mKgh8HtdQBLPTo7nk550i+szcUEpwo1ilvNBBCDouyljcFewhIDz
	HInkYgQSXHoubpuSegHrdgmjUpdzxhg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-sSRPo8taP4aXZapg0lsjKQ-1; Fri, 23 Sep 2022 13:36:41 -0400
X-MC-Unique: sSRPo8taP4aXZapg0lsjKQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1218862FE6;
	Fri, 23 Sep 2022 17:36:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AF5FC17593;
	Fri, 23 Sep 2022 17:36:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9DF8019465B9;
	Fri, 23 Sep 2022 17:36:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 667D919465B6
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Sep 2022 17:36:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 56C41C15BB5; Fri, 23 Sep 2022 17:36:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E49FC15BBC
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32C76811E87
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:35 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-PdtnfC4dPUWTMx1CJS7pUA-1; Fri, 23 Sep 2022 13:36:33 -0400
X-MC-Unique: PdtnfC4dPUWTMx1CJS7pUA-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220923173631euoutp0262f1151a2c3d23b3d92a418b067d8a80~XjeJxqGDI2651126511euoutp02U
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220923173631euoutp0262f1151a2c3d23b3d92a418b067d8a80~XjeJxqGDI2651126511euoutp02U
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220923173629eucas1p154098704c1831a81a84dd94904edeaca~XjeIEqbmj0982609826eucas1p1c;
 Fri, 23 Sep 2022 17:36:29 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id F0.2F.07817.D9EED236; Fri, 23
 Sep 2022 18:36:29 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220923173628eucas1p1837557826439e7cd6690b46628290037~XjeHc5DH_1389413894eucas1p1L;
 Fri, 23 Sep 2022 17:36:28 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220923173628eusmtrp284d8470063727d7d00d16705db25226b~XjeHcIpBM1023410234eusmtrp28;
 Fri, 23 Sep 2022 17:36:28 +0000 (GMT)
X-AuditID: cbfec7f4-8abff70000011e89-38-632dee9d21a9
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 69.5F.10862.C9EED236; Fri, 23
 Sep 2022 18:36:28 +0100 (BST)
Received: from localhost (unknown [106.210.248.168]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220923173628eusmtip22a852fb35c4b3f403d76af36b71e56e1~XjeHE23u92337923379eusmtip2d;
 Fri, 23 Sep 2022 17:36:28 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: snitzer@kernel.org, axboe@kernel.dk, agk@redhat.com, hch@lst.de,
 damien.lemoal@opensource.wdc.com
Date: Fri, 23 Sep 2022 19:36:13 +0200
Message-Id: <20220923173618.6899-9-p.raghav@samsung.com>
In-Reply-To: <20220923173618.6899-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsWy7djPc7pz3+kmG7zrYbVYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlXGh
 dSZLwX7eivU3lzM1ME7l7mLk5JAQMJG4sOw9WxcjF4eQwApGicMPlkM5Xxglll49BuV8ZpTY
 ffgQE0zLrxlvWSESyxklLr07xgqSEBJ4ySixeLtYFyMHB5uAlkRjJztIWEQgXeL41pvsIPXM
 Av3MEp9nvGUBSQgLhEi83fsebCiLgKrEwW3vwBp4BSwkpq/7ygixTF5i5qXv7CAzOQUsJfob
 ayBKBCVOznwCNoYZqKR562xmkPkSAps5Je5t3gdWLyHgIrFmOtQYYYlXx7ewQ9gyEv93zof6
 pVri6Y3fUL0tjBL9O9ezQfRaS/SdyQExmQU0Jdbv0ocod5R49+AZM0QFn8SNt4IQF/BJTNo2
 HSrMK9HRJgRRrSSx8+cTqKUSEpeb5rBA2B4SLQ9ms01gVJyF5JdZSH6ZhbB3ASPzKkbx1NLi
 3PTUYqO81HK94sTc4tK8dL3k/NxNjMBkePrf8S87GJe/+qh3iJGJg/EQowQHs5IIb8pF3WQh
 3pTEyqrUovz4otKc1OJDjNIcLErivGwztJKFBNITS1KzU1MLUotgskwcnFINTDaXLkxplj6W
 YV4azZl//3LTh2eaH28Uyh3W8DnUHqJgz7/iV8uxXKveivpdLYyTCh4G3Sme+M/pkc8Tn1fn
 hCI3cX0+fv2bokrDcW2Z7WuO/d19WPf9QrlXUxzNBCftLcjJlCw4lcJeU8C5MV1ua1bsRpUZ
 lzu2c1VtWeJmXcf4djnTtdm6rHkpdwO0JzbwNuur2c+rMFHMbFvbfStvbvuMCwsebeZdu0Vo
 re4jl/7N7wv3Nt/l+b62TPCcJ6sex237O2X3F5sHPxZ7Jrnl5nm3O6yyD5r3qSzsObuQ9ZT/
 LZfemwwbGhafU7k+6RaLeGD0RtaDl34FWUueOp554rTW8j0v9c/pWEeZbMmIMlRiKc5INNRi
 LipOBADhCLR59QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t/xe7pz3ukmG0x6IWOx/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW9yY8JTR4vPSFnaLNTefslicuCXtIORx+Yq3x85Zd9k9Lp8t9di0qpPNY/OS
 eo/dNxvYPHa23mf1eL/vKptH35ZVjB6bT1d7fN4k59F+oJspgCdKz6Yov7QkVSEjv7jEVina
 0MJIz9DSQs/IxFLP0Ng81srIVEnfziYlNSezLLVI3y5BL+NC60yWgv28FetvLmdqYJzK3cXI
 ySEhYCLxa8Zb1i5GLg4hgaWMEk3r3zFBJCQkbi9sYoSwhSX+XOtigyh6zijxsvMCexcjBweb
 gJZEYyc7SI2IQK7EsbX3WEFsZoH5zBLHV/uB2MICQRINp0+xgdgsAqoSB7e9A6vnFbCQmL7u
 K9R8eYmZl76DjeQUsJTob6wBCQsBlZxf/AiqXFDi5MwnLBDj5SWat85mnsAoMAtJahaS1AJG
 plWMIqmlxbnpucVGesWJucWleel6yfm5mxiBkbvt2M8tOxhXvvqod4iRiYPxEKMEB7OSCG/K
 Rd1kId6UxMqq1KL8+KLSnNTiQ4ymQGdPZJYSTc4Hpo68knhDMwNTQxMzSwNTSzNjJXFez4KO
 RCGB9MSS1OzU1ILUIpg+Jg5OqQamsqI/x+4m/pP2V7s/cX2Xsc5speW/9n7u2C9bai2i82ey
 aaj9hMOnpFVfXj737Jmr0Y3MiiCVl+sEOdf5T3i/UO7Z1BUSOtYNvtY5a+x0YuRXZl6L+bSC
 N/SffG4jr7m8zkLJY9GT4sIzu56+uiTroFmvGbbd+9lkhyu2E5o+n4nebr6asYvLlb35zyb1
 fzUTN5YeelQsLuZdtFnvgYmEQodz0lPGMqnbcd71q0TfX4oL4j+5I0X1a0qDquvX4upChw2t
 pz5yrHbsbf9y7tmHmWoHDr/Zo/HURSvG0isvI6FdtOxDSnvX7es/QuIb5tYHyHtpLr3Yczfm
 8NFvuuX+D7pL/rVd2xsdKqJauV+JpTgj0VCLuag4EQD/43E5ZQMAAA==
X-CMS-MailID: 20220923173628eucas1p1837557826439e7cd6690b46628290037
X-Msg-Generator: CA
X-RootMTR: 20220923173628eucas1p1837557826439e7cd6690b46628290037
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220923173628eucas1p1837557826439e7cd6690b46628290037
References: <20220923173618.6899-1-p.raghav@samsung.com>
 <CGME20220923173628eucas1p1837557826439e7cd6690b46628290037@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH v15 08/13] dm-zoned: ensure only power of 2 zone
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
 dm-devel@redhat.com, Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Luis Chamberlain <mcgrof@kernel.org>

dm-zoned relies on the assumption that the zone size is a
power-of-2(po2) and the zone capacity is same as the zone size.

Ensure only po2 devices can be used as dm-zoned target until a native
support for zoned devices with non-po2 zone size is added.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/md/dm-zoned-target.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 95b132b52f33..9325bf5dee81 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -792,6 +792,10 @@ static int dmz_fixup_devices(struct dm_target *ti)
 				return -EINVAL;
 			}
 			zone_nr_sectors = bdev_zone_sectors(bdev);
+			if (!is_power_of_2(zone_nr_sectors)) {
+				ti->error = "Zone size is not a power-of-2 number of sectors";
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
+			ti->error = "Zone size is not a power-of-2 number of sectors";
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

