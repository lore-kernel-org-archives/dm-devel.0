Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FDDFC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 16 May 2022 16:54:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-ujStVHwrOcmPfUeOe-L47g-1; Mon, 16 May 2022 12:54:46 -0400
X-MC-Unique: ujStVHwrOcmPfUeOe-L47g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 780F586B8AD;
	Mon, 16 May 2022 16:54:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 63FCD400E122;
	Mon, 16 May 2022 16:54:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 33BE01947074;
	Mon, 16 May 2022 16:54:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2A8EA194704E
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 May 2022 16:54:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1457140147D; Mon, 16 May 2022 16:54:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0FD67492C14
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB752811E81
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:41 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-h4whxek_NuOIGvdQ2oax2A-1; Mon, 16 May 2022 12:54:39 -0400
X-MC-Unique: h4whxek_NuOIGvdQ2oax2A-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220516165438euoutp018967267b2117aeddab48144b81e176ec~vpCeviCGs2241322413euoutp016
 for <dm-devel@redhat.com>; Mon, 16 May 2022 16:54:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220516165438euoutp018967267b2117aeddab48144b81e176ec~vpCeviCGs2241322413euoutp016
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220516165437eucas1p15eb77c4c9a68927fe7695a2e5830dcb7~vpCdkUKeT1545715457eucas1p1f;
 Mon, 16 May 2022 16:54:37 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 66.E6.10260.DC182826; Mon, 16
 May 2022 17:54:37 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220516165436eucas1p178d079302dae3a9fca696b13b0390deb~vpCdOIri62560525605eucas1p1b;
 Mon, 16 May 2022 16:54:36 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220516165436eusmtrp28837a89a06654af7c04d36f8d5949f97~vpCdNanu61030710307eusmtrp26;
 Mon, 16 May 2022 16:54:36 +0000 (GMT)
X-AuditID: cbfec7f5-bddff70000002814-5f-628281cdd3f8
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 23.10.09404.CC182826; Mon, 16
 May 2022 17:54:36 +0100 (BST)
Received: from localhost (unknown [106.210.248.7]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220516165436eusmtip27c52763e39356a08b7d9cbb75f4140dd~vpCc05sQp3184631846eusmtip2E;
 Mon, 16 May 2022 16:54:36 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, damien.lemoal@opensource.wdc.com, pankydev8@gmail.com,
 dsterba@suse.com, hch@lst.de
Date: Mon, 16 May 2022 18:54:16 +0200
Message-Id: <20220516165416.171196-14-p.raghav@samsung.com>
In-Reply-To: <20220516165416.171196-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsWy7djP87pnG5uSDLb9FbJYfbefzeL32fPM
 FnvfzWa1uPCjkcni5oGdTBZ7Fk1isli5+iiTRc+BDywWe29pW1x6vILdYs/ekywWl3fNYbOY
 v+wpu8WNCU8ZLT4vbWG3WHPzKYuDgMe/E2vYPHbOusvucflsqcemVZ1sHpuX1HvsvtkAFG69
 z+rxft9VNo++LasYPdZvucrisfl0tcfnTXIBPFFcNimpOZllqUX6dglcGT277jEVzOCquHX2
 AGsD4yqOLkZODgkBE4npK7YydzFycQgJrGCUOPphLRuE84VR4tflmUwQzmdGiVNPTrDAtOyZ
 fBkqsZxRonXqK3YI5zmjRMOWaYxdjBwcbAJaEo2d7CANIgJZEtNOPGQEqWEWOMwk8fzofFaQ
 hLBAsMSqZ7fYQGwWAVWJztfPwOK8AtYSr1a8ZoXYJi8x89J3dpCZnEDx1V3cECWCEidnPgE7
 iBmopHnrbLAfJASWc0q0Hj4KVi8h4CLRedYHYoywxKvjW9ghbBmJ/zvnM0HY1RJPb/yG6m1h
 lOjfuZ4Notdaou9MDojJLKApsX6XPkS5o8TWLytZISr4JG68FYS4gE9i0rbpzBBhXomONiGI
 aiWJnT+fQC2VkLjcNAcagh4S99d/YJ/AqDgLyS+zkPwyC2HvAkbmVYziqaXFuempxcZ5qeV6
 xYm5xaV56XrJ+bmbGIHp7/S/4193MK549VHvECMTB+MhRgkOZiURXoOKhiQh3pTEyqrUovz4
 otKc1OJDjNIcLErivMmZGxKFBNITS1KzU1MLUotgskwcnFINTEE/cltaBJZybQq4ve86NzeT
 VsGkKjd2sZ22K8P8759Y+qz3xz4bkY9dmtyd4jGs2+5rhDmlVKxL3z9T3b3OfbVggsbU5QcY
 3/+56/HP6Ed60qln1ZMVV1f8j55/UehI/AW93O4jSeznVgdVvHuR9vr0QjdJhQ1Gh1/eZV3e
 8E7s64SSitWaLjx3VrimPebbt+7VvoWpp9PWRO7rnXObS7B1MdOKRoPTPCa2h5qvRxyM2MM9
 P25955LzhvxfXGWc7A6t0z39MnL+vtPLk7OzzyptnCIe+kuwX07RTXePS/r0h3P5K3eYq8kx
 7xbgOCRn/shmDu995+d7L2S+zQrI0/X2Wc7v2LRoObPOsbfTK5VYijMSDbWYi4oTAX69IDHu
 AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t/xe7pnGpuSDO5tN7ZYfbefzeL32fPM
 FnvfzWa1uPCjkcni5oGdTBZ7Fk1isli5+iiTRc+BDywWe29pW1x6vILdYs/ekywWl3fNYbOY
 v+wpu8WNCU8ZLT4vbWG3WHPzKYuDgMe/E2vYPHbOusvucflsqcemVZ1sHpuX1HvsvtkAFG69
 z+rxft9VNo++LasYPdZvucrisfl0tcfnTXIBPFF6NkX5pSWpChn5xSW2StGGFkZ6hpYWekYm
 lnqGxuaxVkamSvp2NimpOZllqUX6dgl6GT277jEVzOCquHX2AGsD4yqOLkZODgkBE4k9ky8z
 dTFycQgJLGWUOLjjKQtEQkLi9sImRghbWOLPtS42iKKnjBInJxwHSnBwsAloSTR2soPUiAgU
 SMzp3wLWyyxwnkli/3p3EFtYIFBi0rZmJhCbRUBVovP1M1YQm1fAWuLVitesEPPlJWZe+s4O
 MpITKL66ixskLCRgJfH1yS12iHJBiZMzn0CNl5do3jqbeQKjwCwkqVlIUgsYmVYxiqSWFuem
 5xYb6RUn5haX5qXrJefnbmIERuq2Yz+37GBc+eqj3iFGJg7GQ4wSHMxKIrwGFQ1JQrwpiZVV
 qUX58UWlOanFhxhNgc6eyCwlmpwPTBV5JfGGZgamhiZmlgamlmbGSuK8ngUdiUIC6Yklqdmp
 qQWpRTB9TBycUg1Mk6fvdjfa5ON/83dYHLet8aHDRgZJm/7YMf6cwtBzuV9CcP2hI984F6z/
 seXGjM/F12TvZ65qnTA74+361NWKzd1vUmt975ZEH01/uWZJ6bX7DEdaLcJcd29JOizBtSrp
 /ZxYBjkRM9OMFQYs7780Rlw1CcpKK14we0//w40XXTsfr6lyDPmRmXv+6+q8JsuPd7iq890/
 NKztO32j2k/8xM/V/+43BTOsWGIi95gla1/szVtnXB6FxSsd47z/WPRCpMyzahaujsfW23oZ
 FLZ0GJYLeLIIOs7s2Z5f0ST/oPfmzT8XwhN95j1bnOKeecU2YY39l+OzpF49miMRb77ok5qX
 ycEXx+bd+KtxtLG5XYmlOCPRUIu5qDgRAFdHucBdAwAA
X-CMS-MailID: 20220516165436eucas1p178d079302dae3a9fca696b13b0390deb
X-Msg-Generator: CA
X-RootMTR: 20220516165436eucas1p178d079302dae3a9fca696b13b0390deb
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220516165436eucas1p178d079302dae3a9fca696b13b0390deb
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165436eucas1p178d079302dae3a9fca696b13b0390deb@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH v4 13/13] dm-zoned: ensure only power of 2 zone
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
Cc: p.raghav@samsung.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
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
index 3e7b1fe15..f0c588c02 100644
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
+		DMWARN("%s: %s only power of two zone size supported",
+		       dm_device_name(md),
+		       bdevname(bdev, bname));
+		return -EINVAL;
+	}
 
 	/*
 	 * Check if something changed. If yes, cleanup the current resources
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

