Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 151F1C19F2C
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 09:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659520104;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iAGkZQXRt2Tjwrmli5Rn4yHVD76WsF92xnssrAogFgU=;
	b=HI2rvUk2s2VAaGwj+FoJnCD4FjwRtRmPv/V0vZf0IvlkrwR02FSWNMYrLxU6t8SGkbzQmh
	sZ2PM9q5yZYsvmMDgprYRTSXLqDg6xMHFsHRTLnuZusg7VOb96JWfuB+Ueyggv2o+urr92
	1zmShHuhWeVpFBq0DRjyPgwe0To5KXo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-L7RjbJNIOiW39RdHvQijEQ-1; Wed, 03 Aug 2022 05:48:20 -0400
X-MC-Unique: L7RjbJNIOiW39RdHvQijEQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB8AB280F2AD;
	Wed,  3 Aug 2022 09:48:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 92C8C2026D4C;
	Wed,  3 Aug 2022 09:48:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4CC4B1946A53;
	Wed,  3 Aug 2022 09:48:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3B0641946A50
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 09:48:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 17647492CA4; Wed,  3 Aug 2022 09:48:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 130A4492C3B
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDC6438217F0
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:16 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-HR2H1FQ_P6GyF3ssKHFghA-1; Wed, 03 Aug 2022 05:48:15 -0400
X-MC-Unique: HR2H1FQ_P6GyF3ssKHFghA-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220803094813euoutp01f8aadfee5b844cddbe26997659a36d3f~HzLuhmVTv3242932429euoutp01S
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220803094813euoutp01f8aadfee5b844cddbe26997659a36d3f~HzLuhmVTv3242932429euoutp01S
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220803094811eucas1p28cd48175b9feac0080f9be506dd1b5b5~HzLspo2by1532415324eucas1p2S;
 Wed,  3 Aug 2022 09:48:11 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 08.FF.09664.B544AE26; Wed,  3
 Aug 2022 10:48:11 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220803094811eucas1p17a2ac191899bba7938de6b9e3a55352f~HzLsBClpH3109631096eucas1p18;
 Wed,  3 Aug 2022 09:48:11 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220803094811eusmtrp1ba4f7f94f43e6937f2a29d964ceaf11c~HzLr5us1F2000320003eusmtrp1Y;
 Wed,  3 Aug 2022 09:48:11 +0000 (GMT)
X-AuditID: cbfec7f2-d81ff700000025c0-8e-62ea445bc010
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 07.9B.09038.A544AE26; Wed,  3
 Aug 2022 10:48:11 +0100 (BST)
Received: from localhost (unknown [106.210.248.112]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220803094810eusmtip2b837e592c0d57ed90af9168ead84a75c~HzLrkbg3V1623616236eusmtip29;
 Wed,  3 Aug 2022 09:48:10 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: Johannes.Thumshirn@wdc.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, agk@redhat.com, hch@lst.de
Date: Wed,  3 Aug 2022 11:47:56 +0200
Message-Id: <20220803094801.177490-9-p.raghav@samsung.com>
In-Reply-To: <20220803094801.177490-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsWy7djPc7rRLq+SDM5+NrZYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlXF8
 +hmWgr3cFX/nvmdtYFzH2cXIySEhYCKxc9cV1i5GLg4hgRWMEpvO72OHcL4wSix9vxjK+cwo
 8fT9RRaYlv0PH0G1LGeU2PtoEpTzklHi7OofQA4HB5uAlkRjJ1i3iEAzo8Tdvz1gRcwCB5gk
 Fr3+wQgySlggWGLqqx1MIA0sAqoSJ65EgoR5Bawkmg89Y4bYJi8x89J3dhCbU8BaYsq/f8wQ
 NYISJ2c+AbuIGaimeetsZpD5EgK7OSUe3z7LCNHsIvH14nGos4UlXh3fwg5hy0icntwDFa+W
 eHrjN1RzC6NE/871bCAHSQBt6zuTA2IyC2hKrN+lDxF1lOh94Qth8knceCsIcQGfxKRt05kh
 wrwSHW1CELOVJHb+fAK1U0LictMcqJ0eEltf3mWewKg4C8kvs5D8Mgth7QJG5lWM4qmlxbnp
 qcWGeanlesWJucWleel6yfm5mxiBCfH0v+OfdjDOffVR7xAjEwfjIUYJDmYlEd47Ls+ThHhT
 EiurUovy44tKc1KLDzFKc7AoifMmZ25IFBJITyxJzU5NLUgtgskycXBKNTC1mfEsnBhTnH89
 fv8xJ/Fd2dNmGMZa/BeYPePNh9rIRetjklqLFoUoGEXONFw84fj+BX2XFTQYQor2iMV/lu67
 FWsu7zjr5KLOdSI3Kl1L2QoXLK9wfqG00Wp13dqPKgpnkq8nz+WpvdhvKr+8711/GsOHOYUn
 nMRzkjkXqnHo2PxVzQmJP72N54HI/ovPFyYxrjcwi9z/t/FWQVp+u17xAnetl0F7NgonH/G+
 c+B0W2mgiOMVE2af7sbrLLNfT3C+r2t2JWD/gq9MMavPivrs+bF9SdlDX8/o3M7a9AV5732s
 phscru0Qy53fNMtPSdAzcEpX3W1eq/X8cWVuZjMOOYnJsm+JSVLcoXaYU4mlOCPRUIu5qDgR
 ALVI1Yn3AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t/xe7rRLq+SDNZcZrRYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBOlZ1OUX1qSqpCRX1xiqxRt
 aGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl3F8+hmWgr3cFX/nvmdtYFzH2cXI
 ySEhYCKx/+EjVhBbSGApo8T1S5IQcQmJ2wubGCFsYYk/17rYuhi5gGqeM0osOvCduYuRg4NN
 QEuisZMdJC4i0M0ocfnMOVYQh1ngHJPE8+9dYN3CAoESy7dfZwFpYBFQlThxJRIkzCtgJdF8
 6BkzxAJ5iZmXvrOD2JwC1hJT/v1jhjjISmLd31msEPWCEidnPmEBsZmB6pu3zmaewCgwC0lq
 FpLUAkamVYwiqaXFuem5xUZ6xYm5xaV56XrJ+bmbGIGxu+3Yzy07GFe++qh3iJGJg/EQowQH
 s5II7x2X50lCvCmJlVWpRfnxRaU5qcWHGE2Bzp7ILCWanA9MHnkl8YZmBqaGJmaWBqaWZsZK
 4ryeBR2JQgLpiSWp2ampBalFMH1MHJxSDUy8DglX0y5Os9431+SK32yn9srn2cviUpdsjzvU
 +Pm0pvmsys28b973PDlXf2V1bHqUiPOurFzhokVHlMq3RMSm9H97/HdRvVznunfmdcdqM+Zo
 qSZLPmqxPB951fb9ar+Lrz5YTl7w5NXkl4Hbiw6631adkyf+jlGJ42ez6DsfaS5BNY0ZiT88
 NXsNVjxjSH+YH7rpzwGV+yGx/YcLHZsiMqpqV5znuBx8aOpa9x0vf8i6zzz9lJ9vGV9J8DOd
 uQw3dOS27eovfJUT7SZyJmjT1wn7rgZvc/rbKBQZYLdx5zNbZe5vJQxbeW8mJWzea/2j7kPt
 wjXF4i1blRNj9zou0WXfWFjwbMs1jYe+Oz8qsRRnJBpqMRcVJwIARSsy8WYDAAA=
X-CMS-MailID: 20220803094811eucas1p17a2ac191899bba7938de6b9e3a55352f
X-Msg-Generator: CA
X-RootMTR: 20220803094811eucas1p17a2ac191899bba7938de6b9e3a55352f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220803094811eucas1p17a2ac191899bba7938de6b9e3a55352f
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094811eucas1p17a2ac191899bba7938de6b9e3a55352f@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v9 08/13] dm-zoned: ensure only power of 2 zone
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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

