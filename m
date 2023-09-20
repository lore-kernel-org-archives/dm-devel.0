Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFDA8CE79AC
	for <dm-devel@archiver.kernel.org>; Wed, 20 Sep 2023 09:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695202063;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KL4eLo7DTXy/ze6HtxjYVp0yIztu7CR/+7tEVemovQI=;
	b=FbT9MaWrVoYcl9ZN63LmWURhHHYyxGzbFJiPudyWuVcG+Q4X0tnwVbAEaOC4EPb6hw+mZR
	FCiD/JVlNmVMsG6D2sabIYil22lnXlW2u4FIYSC6c00iD6JGMPMgpLFu1ya74kwCtTpG/k
	53vsjRkY29DcgZTa23fSr3JsNiB/fS0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-322-AhpjE2jyM4SBWEI5DmPpeQ-1; Wed, 20 Sep 2023 05:27:39 -0400
X-MC-Unique: AhpjE2jyM4SBWEI5DmPpeQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A37C6185A78E;
	Wed, 20 Sep 2023 09:27:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A8E0220268CC;
	Wed, 20 Sep 2023 09:27:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1451E19465BC;
	Wed, 20 Sep 2023 09:27:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BBE16194658D
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Sep 2023 08:58:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AE771140E953; Wed, 20 Sep 2023 08:58:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A6551140E950
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 08:58:46 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88DE138008B2
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 08:58:46 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-345-A07PJ-OaMmK8mEpNNSIiiQ-1; Wed, 20 Sep 2023 04:58:44 -0400
X-MC-Unique: A07PJ-OaMmK8mEpNNSIiiQ-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230920085841epoutp02ed241bf3dba2afdd83dcefe708702e4a~Gj7XmNPXO2757227572epoutp02Z
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 08:58:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230920085841epoutp02ed241bf3dba2afdd83dcefe708702e4a~Gj7XmNPXO2757227572epoutp02Z
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20230920085840epcas5p3beb33fd273b4b923788b1dad210b43b3~Gj7W4-4Zz1154211542epcas5p3e;
 Wed, 20 Sep 2023 08:58:40 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.176]) by
 epsnrtp4.localdomain (Postfix) with ESMTP id 4RrCB66xRDz4x9Q9; Wed, 20 Sep
 2023 08:58:38 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
 54.F1.19094.E34BA056; Wed, 20 Sep 2023 17:58:38 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230920081548epcas5p14d9620a58744270e4f31a7cea4eec920~GjV7u96b42942529425epcas5p1j;
 Wed, 20 Sep 2023 08:15:48 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230920081548epsmtrp2376c601f064748387c98462119b603fd~GjV7t1bN80262802628epsmtrp2U;
 Wed, 20 Sep 2023 08:15:48 +0000 (GMT)
X-AuditID: b6c32a50-39fff70000004a96-c7-650ab43e328d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 56.0F.08742.43AAA056; Wed, 20 Sep 2023 17:15:48 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20230920081545epsmtip11c54e63139d09068832067b7cda16d8d~GjV4v7hjY0186201862epsmtip1g;
 Wed, 20 Sep 2023 08:15:45 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair
 Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
 <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>
Date: Wed, 20 Sep 2023 13:37:46 +0530
Message-Id: <20230920080756.11919-10-nj.shetty@samsung.com>
In-Reply-To: <20230920080756.11919-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf1CTZRzned/t3eBYvQIeDyuTRtIJARtt86GA5CJ6T6vj8q7rvJR28ArE
 2Hb7RYkZIr/EY5tYmZsgHRwgeIATaAJLghKHISE4YIF2OqxzByqkZYi0uVH+9/l8nu+vz/e5
 LxsPKmdx2bkyNa2USaQ8IoDRPbg5Kia5M4DmG1xi1D58AUf37i8zUOusnkCuwUWAnP3lAFkX
 TEw03X8OQ6daf8JQ9YAdoLmrRgxZHdHo27IGBuqz2hhovOcEgU42zrHQ4UkLgZqGHmNoyjAH
 kMV5AKDu5ZM4anPdYaCLjufQ6MoQc2sodc44y6JGr51hUOMjGsrccoigzjZ8QfVOFxFUve4o
 k6o6uEBQ9+YcDOrO91cJStfZAqgl8wuU2TmPpXN25iXm0JIsWhlOyzLlWbmy7CTe9h0Zb2aI
 xHxBjCABbeGFyyT5dBIv9Z30mLRcqds6L1wrkWrcUrpEpeLFJScq5Ro1HZ4jV6mTeLQiS6oQ
 KmJVknyVRpYdK6PVrwn4/HiRO/DjvJyKywu44sewT0/fHMOLwK2QSuDPhqQQ3lw0MSpBADuI
 7AOw97ti3EsWAXSV9PvIAwCr9GVgLaX+ktH3YAVw0mXCvKQUg4biGncUm02Q0fDSKtujh5BF
 OOzorQcegpPTGBw53415SgWTr8PqGjPuwQxyEyy12ZgezHHrh1ZLMU8hSMZB/fV1HtnfLS81
 TLK8Ieug7biT4cE4uREe7DI9mQiSJn9o+MPC9I6aCvVlJsKLg+HtoU6WF3Ph0oLVpxfAU182
 E97kEgCNk0afzzdg6bAe9wyBk5the0+cV94Avxpuw7yNn4FVy07Mq3OgpXYNR8DT7XW++mHQ
 /tcBH6ag/vwV37Z1AK40d7IMINz4lCHjU4aM/7euA3gL4NIKVX42nSlSCGJkdMF/H50pzzeD
 JxcRlW4BrR0rsQMAY4MBANk4L4STHxlAB3GyJJ/tpZXyDKVGSqsGgMi98SM4d32m3H1SMnWG
 QJjAF4rFYmHCq2IBL5TjKq3JCiKzJWo6j6YVtHItD2P7c4uwFwlp1bHlfYXFZ2+32WWRh1nV
 jyyz1ydCTrylOsPc3wAujD1Mfkm9u7Bx/ed/b3lIvB0dEVIxvi/l0YYH5Zf70V3/yOniXXVU
 49Z5P9eex99ENJekOXfurdVpfjGPT6Tx/T6o3b87UTLbMq+Nabo2Y4vfKKXnqeP/3GrSKuX6
 EW3Xxe2y+yVax5VuZsHyR4N+rbB2suUVaUWS6909Myk67ScVP3+t+XPGeoM71rfY9NvLO+zj
 gUdsol14qrrDVngj7Af7VCIdqHs2vtLataQ7Jvowc1teT9iKflNg6GhFeav9/cG6bVNRsbXP
 dx2V/7oaLnQkTvxuCSL9gg1xtCNh4m7KezyGKkciiMKVKsm/YnSQgZoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTcRjG+59zdnZczU5T2N8Mg4VCSaZ0+2Mp9aE8fZHKCLpArTyZ5Oba
 1CysJqKlecMiaJqXWpabuVqpM1uJpnMus6g0l3ahbYrS0ixJp1tOCfr2vM/veZ/3w0vhgmZi
 OZUoTWHlUnGSiOQRDW2ioLUbNDw2vN2wAum6OnA0/ttFIO1gEYlG234CZGu5BJDRWcpB/S1N
 GKrRtmOopLUXIPt7FYaM1lBUlaMm0FOjmUBvn5SRqKLazkVX+gwkumtyY+hDsR0ggy0ToAZX
 BY7qRn8QqNMaiHpmTZxtQqZJNchlej49JJi33amMXpNLMo/UF5nmfiXJ3C68ymEKspwkM263
 EsyPZ+9JpvCxBjAT+iBGb/uO7eYf5G2NZ5MS01j5uuijvJOXXzlx2YuA9Npvb3AlcPjnAR8K
 0hvgbYsKzwM8SkA3A+jKe85ZAAGwevYFvqD9YI17iLsQysJgf3XHHKAokg6FFg/l9f3pPBzm
 NjkJ74DTdgyOT00C77YfvQWW3NTPNxF0MMw2m+cv8Of8XE825i2C9DpY9HmZ1/aZsyfUfVyv
 FtCR0PK6grsQXwbNN2yEV+P0SphVX4oXA1r1H1L9hyoBpgEBrEwhSZAoImQRUvZMmEIsUaRK
 E8KOJ0v0YP6/a1YbQKNmLKwVYBRoBZDCRf58SQiPFfDjxWfPsfLkI/LUJFbRCgIpQiTkC4cL
 4gV0gjiFPcWyMlb+j2KUz3Il9mAix2+XK1KzNebCAXdy13SHNi0GO+bDGksTu4FHMirMeNOx
 qXe71JmTxrk/5jaFzCxh6PrUrj2O9NDfv7Cv6/dFTo1xSCz9cXRdzZdHlwe6PpuU11tehgt0
 K0umzwV79sYYlSqHMmrHoaNZnYz12oW+WJG/aSg8LmT0mi528UB5pTm7Nj8luaJQ8t0t6R35
 GWWrPFHf/mm3LqApKUNmbL8Xl88b/tIYNpj2x+Kr3n5w063IjQMjZewp+1DnZHTsDK/6252Z
 4jKL53hBprVBiC1ShsvPb5ad1jYsDR5eX9DmUAb5uoodq6oO7NfWfqxrrIq+eqVw5zvd4YeT
 bkO5iFCcFEesweUK8V93BZtWTgMAAA==
X-CMS-MailID: 20230920081548epcas5p14d9620a58744270e4f31a7cea4eec920
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230920081548epcas5p14d9620a58744270e4f31a7cea4eec920
References: <20230920080756.11919-1-nj.shetty@samsung.com>
 <CGME20230920081548epcas5p14d9620a58744270e4f31a7cea4eec920@epcas5p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH v16 09/12] dm: Add support for copy offload
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
Cc: anuj1072538@gmail.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, gost.dev@samsung.com,
 nitheshshetty@gmail.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, mcgrof@kernel.org,
 linux-fsdevel@vger.kernel.org, Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Before enabling copy for dm target, check if underlying devices and
dm target support copy. Avoid split happening inside dm target.
Fail early if the request needs split, currently splitting copy
request is not supported.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 drivers/md/dm-table.c         | 37 +++++++++++++++++++++++++++++++++++
 drivers/md/dm.c               |  7 +++++++
 include/linux/device-mapper.h |  3 +++
 3 files changed, 47 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 37b48f63ae6a..8803c351624c 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1878,6 +1878,38 @@ static bool dm_table_supports_nowait(struct dm_table *t)
 	return true;
 }
 
+static int device_not_copy_capable(struct dm_target *ti, struct dm_dev *dev,
+				   sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return !q->limits.max_copy_sectors;
+}
+
+static bool dm_table_supports_copy(struct dm_table *t)
+{
+	struct dm_target *ti;
+	unsigned int i;
+
+	for (i = 0; i < t->num_targets; i++) {
+		ti = dm_table_get_target(t, i);
+
+		if (!ti->copy_offload_supported)
+			return false;
+
+		/*
+		 * target provides copy support (as implied by setting
+		 * 'copy_offload_supported')
+		 * and it relies on _all_ data devices having copy support.
+		 */
+		if (!ti->type->iterate_devices ||
+		    ti->type->iterate_devices(ti, device_not_copy_capable, NULL))
+			return false;
+	}
+
+	return true;
+}
+
 static int device_not_discard_capable(struct dm_target *ti, struct dm_dev *dev,
 				      sector_t start, sector_t len, void *data)
 {
@@ -1960,6 +1992,11 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 		q->limits.discard_misaligned = 0;
 	}
 
+	if (!dm_table_supports_copy(t)) {
+		q->limits.max_copy_sectors = 0;
+		q->limits.max_copy_hw_sectors = 0;
+	}
+
 	if (!dm_table_supports_secure_erase(t))
 		q->limits.max_secure_erase_sectors = 0;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 64a1f306c96c..eca336487d44 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1714,6 +1714,13 @@ static blk_status_t __split_and_process_bio(struct clone_info *ci)
 	if (unlikely(ci->is_abnormal_io))
 		return __process_abnormal_io(ci, ti);
 
+	if ((unlikely(op_is_copy(ci->bio->bi_opf)) &&
+	    max_io_len(ti, ci->sector) < ci->sector_count)) {
+		DMERR("Error, IO size(%u) > max target size(%llu)\n",
+		      ci->sector_count, max_io_len(ti, ci->sector));
+		return BLK_STS_IOERR;
+	}
+
 	/*
 	 * Only support bio polling for normal IO, and the target io is
 	 * exactly inside the dm_io instance (verified in dm_poll_dm_io)
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 69d0435c7ebb..98db52d1c773 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -396,6 +396,9 @@ struct dm_target {
 	 * bio_set_dev(). NOTE: ideally a target should _not_ need this.
 	 */
 	bool needs_bio_set_dev:1;
+
+	/* copy offload is supported */
+	bool copy_offload_supported:1;
 };
 
 void *dm_per_bio_data(struct bio *bio, size_t data_size);
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

