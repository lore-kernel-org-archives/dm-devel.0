Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BD96C4167D
	for <dm-devel@archiver.kernel.org>; Tue,  8 Feb 2022 22:34:11 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-4WtX2Xl0PFG37Txi1lCcCA-1; Tue, 08 Feb 2022 17:34:06 -0500
X-MC-Unique: 4WtX2Xl0PFG37Txi1lCcCA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37D3F84B9AC;
	Tue,  8 Feb 2022 22:34:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D42834CEEC;
	Tue,  8 Feb 2022 22:34:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ABAFE576B9;
	Tue,  8 Feb 2022 22:34:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 217EWFJ9012767 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Feb 2022 09:32:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 257B753D6; Mon,  7 Feb 2022 14:32:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F73853D0
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 14:32:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D86F310AF7C8
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 14:32:11 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-249-XhWdvPhyM1W1C7-eVB4cAA-1; Mon, 07 Feb 2022 09:32:10 -0500
X-MC-Unique: XhWdvPhyM1W1C7-eVB4cAA-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id
	20220207142313epoutp0301627698c1a350a6e8dcc944bb595778~RhwSvsd8H0920109201epoutp03m
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 14:23:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
	20220207142313epoutp0301627698c1a350a6e8dcc944bb595778~RhwSvsd8H0920109201epoutp03m
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20220207142311epcas5p13e48ec8391beac99d7a61129d01e70cc~RhwRoDhFV0954809548epcas5p17;
	Mon,  7 Feb 2022 14:23:11 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4JspJn5F15z4x9Pq;
	Mon,  7 Feb 2022 14:23:05 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	95.2E.46822.D9A21026; Mon,  7 Feb 2022 23:20:13 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20220207141948epcas5p4534f6bdc5a1e2e676d7d09c04f8b4a5b~RhtT4zbvD0820008200epcas5p4f;
	Mon,  7 Feb 2022 14:19:48 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20220207141948epsmtrp11be132295d070c75394d594c62df06e6~RhtTx6Ayt0764707647epsmtrp19;
	Mon,  7 Feb 2022 14:19:48 +0000 (GMT)
X-AuditID: b6c32a4a-dfbff7000000b6e6-5f-62012a9d50ea
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F3.04.29871.38A21026; Mon,  7 Feb 2022 23:19:47 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
	[107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20220207141944epsmtip1ab1f2316a40c9f0431d8aa6129dda20a~RhtQBjgka0743607436epsmtip1C;
	Mon,  7 Feb 2022 14:19:43 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: mpatocka@redhat.com
Date: Mon,  7 Feb 2022 19:43:46 +0530
Message-Id: <20220207141348.4235-9-nj.shetty@samsung.com>
In-Reply-To: <20220207141348.4235-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta1BUZRjuO2f37C4zaydc44Ng2lmTERDc5bJ+oIQlOGfAKSbTxqakFY7L
	dXfbXa5NXMNEWLlUhksqFEJAAwaIDLCmEKKBBAMswoBFgCIZGBAuskDAgfLf8z7v83zv5ZuX
	i1v+yLHhhim0tFohixQRFqy6FgcH5wuO4IRYn2qBmgZm2ahiOJtA554s4Gj65igb5WXnc1DP
	2BZkmCpgoy5TCoZGq1cw1PRtHobKKlox9LD0O4Ay2rswZB6RoNaVvwiU12wEyDDohJoMd1jo
	Usk4B2X21xPo+p8GHJW2LWMo93Qfhjr1ZgLVLV7CUcv9PhaqMCOUnrXAQZM/Hd9vR/X0BlC5
	aVMcKq1wiEX13I2mqsszCKqmOIn64l4poBoHkgkqtaMVp/Jn5giqv+MaRunSpgjq7/FBFlU3
	ouNQ09f7COpsbTkIFLwfsS+UloXQaiGtCFaGhCnk3qKAw0EHgjykYomzxBPtEQkVsijaW+R7
	KND5YFjk6pJEwhhZZPQqFSjTaES7X9+nVkZraWGoUqP1FtGqkEiVu8pFI4vSRCvkLgpa6yUR
	i109VoUfRYSaGuc4qoxX4gaSM7FkkPHyGcDjQtIdNpSM42eABdeSbARwqriOxQQzADa2VWNM
	MA9g2dla1qZlKb+ZYBIGABf+6Nzwp2OwqHgGnAFcLkE6wfYV7ppBQFpBc1cdWNPg5CwLGvv1
	nLXEVnIv/CZ3eR2zyB1wsOnyOuaTnvB2XjqHqbYdFo3cZK9hHukF583nWIzmJXjn/Ng6xslX
	YdrVgvUmIGnkwWHTlxtmX/hgOAsweCucbKvd4G3go+xTHMaQCaCp4zeMCfIBTMtJIxiVD+xu
	WsLWxsFJB1jVsJuh7eBXv1RiTOUtULc4hjE8H9Zf3MTb4Q9VhRvPWEPj05QNTMG7xiU2s65e
	AGvK2okcINQ/N5H+uYn0/5cuBHg5sKZVmig5rfFQuSro2P8+OlgZVQ3Wb8fRvx6M/P7EpRlg
	XNAMIBcXCfi2mSsyS36ILD6BViuD1NGRtKYZeKyuPBe32RasXD0+hTZI4u4pdpdKpe6eblKJ
	yIrfLr8isyTlMi0dQdMqWr3pw7g8m2Ts8+pncsFRoeGpMidMJ5xb0u9xKFOcTHD5oNX/ay0p
	uEXtKopYtDhql/RZVHhHr4W/jf1p8amxIb+Hk+/a2scfzio40r3X4+0brbdeXE7VTUsSQ7sM
	V+3rp4uanuWdjz1Q6ff9/KHcHdyqmBQJy4V38tiR8E+Lx2ou8i2jBiUfvrF/Ujr96Nfb1oIH
	0rnX2Mced5re65x1+jihX3w/yy/ghjXqHnqcyCt703eXj9tyQ0Qs70rKzk/YQ0Y3H7ZVgIa8
	7OCXNN+S6xV+L071QsA7oyPa8H8ieirtJhrjw/THTe3eBuFErckqPWbC9hq3TzfmGmeeCgoo
	Ka3elrfTP3H55wv8E2+JWJpQmcQRV2tk/wKmbiIdxAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsWy7bCSnG6zFmOSwe6nVhZ7bn5mtVh9t5/N
	YtqHn8wW7w8+ZrWY1D+D3eLyEz6Lve9ms1pc+NHIZPF4038miz2LJjFZrFx9lMni+fLFjBad
	py8wWfx5aGhx9P9bNotJh64xWuy9pW2xZ+9JFov5y56yW3Rf38Fmse/1XmaL5cf/MVlM7LjK
	ZHFu1h82i22/5zNbHL53lcVi9R8Li9aen+wWr/bHOch6XL7i7TGx+R27R/OCOywel8+Wemxa
	1cnmsXlJvcfkG8sZPXbfbGDzaDpzlNljxqcvbB7Xz2xn8uhtfsfm8fHpLRaPbQ972T3e77vK
	5tG3ZRVjgEgUl01Kak5mWWqRvl0CV8aP3V/YCzqlK242dDM1MHaKdTFyckgImEj8nXGIrYuR
	i0NIYDejxIPpu1ghEpISy/4eYYawhSVW/nvODlHUzCSx5EQPUAcHB5uAtsTp/xwgNSIC4hJ/
	LmxjBKlhFpjOKtFw6jITSEJYwFpizsR/7CA2i4CqxK09S8FsXgFLiROTWtkhFihLLHx4EGwx
	p4CVxLc/01ggljUwSjScW8EK0SAocXLmExYQm1lAXqJ562zmCYwCs5CkZiFJLWBkWsUomVpQ
	nJueW2xYYJiXWq5XnJhbXJqXrpecn7uJEZwUtDR3MG5f9UHvECMTB+MhRgkOZiURXpnu/4lC
	vCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1MLnaTDyv8L7A
	sNjvoMMSy5jMPcGrvwcyPmFS/fmJtSKr6pgLx8H5q2yifkpmHX6itUZsXkvgDsVXS00T5vi+
	YBHqqitjFZXPj59h/szy8Ia93SIM9xQro9XncgsdtQo9vdTD4Ea0Ics2ZdupL+7ZreVf+Xkb
	Q8uaeJHcR9E2jp/1cj5fY0hOfHvq6gWFjkpuQwcesQ8CoWL3BLauftO8P0Ngv8byA+dFXpx4
	7nfy4JoivawbESL14nHGAflTJD5wLAtQzOnaarj6vHV6CMe9D9Fe+Xc+P5x4P8Zv8oYzDee2
	Lr/x9pWtqvzDVOb3pbq7HwiefNXR3512uP191PJVEnHyi5Z90Jhb8O5pUJGhkhJLcUaioRZz
	UXEiALBzErx5AwAA
X-CMS-MailID: 20220207141948epcas5p4534f6bdc5a1e2e676d7d09c04f8b4a5b
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220207141948epcas5p4534f6bdc5a1e2e676d7d09c04f8b4a5b
References: <CAOSviJ0HmT9iwdHdNtuZ8vHETCosRMpR33NcYGVWOV0ki3EYgw@mail.gmail.com>
	<20220207141348.4235-1-nj.shetty@samsung.com>
	<CGME20220207141948epcas5p4534f6bdc5a1e2e676d7d09c04f8b4a5b@epcas5p4.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 217EWFJ9012767
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 08 Feb 2022 02:51:51 -0500
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
	dm-devel@redhat.com, osandov@fb.com, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org, hch@lst.de,
	roland@purestorage.com, nj.shetty@samsung.com, zach.brown@ni.com,
	chaitanyak@nvidia.com, msnitzer@redhat.com, josef@toxicpanda.com,
	linux-block@vger.kernel.org, dsterba@suse.com, kbusch@kernel.org,
	Frederick.Knight@netapp.com, axboe@kernel.dk, tytso@mit.edu,
	joshi.k@samsung.com, martin.petersen@oracle.com,
	arnav.dawn@samsung.com, jack@suse.com,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
Subject: [dm-devel] [PATCH v2 08/10] dm: Add support for copy offload.
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Before enabling copy for dm target, check if underlaying devices and
dm target support copy. Avoid split happening inside dm target.
Fail early if the request needs split, currently spliting copy
request is not supported

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 drivers/md/dm-table.c         | 43 +++++++++++++++++++++++++++++++++++
 drivers/md/dm.c               |  6 +++++
 include/linux/device-mapper.h |  5 ++++
 3 files changed, 54 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index e43096cfe9e2..cb5cdaf1d8b9 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1903,6 +1903,39 @@ static bool dm_table_supports_nowait(struct dm_table *t)
 	return true;
 }
 
+static int device_not_copy_capable(struct dm_target *ti, struct dm_dev *dev,
+				      sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return !blk_queue_copy(q);
+}
+
+static bool dm_table_supports_copy(struct dm_table *t)
+{
+	struct dm_target *ti;
+	unsigned int i;
+
+	for (i = 0; i < dm_table_get_num_targets(t); i++) {
+		ti = dm_table_get_target(t, i);
+
+		if (!ti->copy_supported)
+			return false;
+
+		/*
+		 * Either the target provides copy support (as implied by setting
+		 * 'copy_supported') or it relies on _all_ data devices having
+		 * discard support.
+		 */
+		if (!ti->copy_supported &&
+		    (!ti->type->iterate_devices ||
+		     ti->type->iterate_devices(ti, device_not_copy_capable, NULL)))
+			return false;
+	}
+
+	return true;
+}
+
 static int device_not_discard_capable(struct dm_target *ti, struct dm_dev *dev,
 				      sector_t start, sector_t len, void *data)
 {
@@ -2000,6 +2033,16 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	} else
 		blk_queue_flag_set(QUEUE_FLAG_DISCARD, q);
 
+	if (!dm_table_supports_copy(t)) {
+		blk_queue_flag_clear(QUEUE_FLAG_COPY, q);
+		/* Must also clear discard limits... */
+		q->limits.max_copy_sectors = 0;
+		q->limits.max_copy_range_sectors = 0;
+		q->limits.max_copy_nr_ranges = 0;
+	} else {
+		blk_queue_flag_set(QUEUE_FLAG_COPY, q);
+	}
+
 	if (dm_table_supports_secure_erase(t))
 		blk_queue_flag_set(QUEUE_FLAG_SECERASE, q);
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index fa596b654c99..2a6d55722139 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1420,6 +1420,12 @@ static int __split_and_process_non_flush(struct clone_info *ci)
 	if (__process_abnormal_io(ci, ti, &r))
 		return r;
 
+	if ((unlikely(op_is_copy(ci->bio->bi_opf)) &&
+				max_io_len(ti, ci->sector) < ci->sector_count)) {
+		DMERR("%s: Error IO size(%u) is greater than maximum target size(%llu)\n",
+				__func__, ci->sector_count, max_io_len(ti, ci->sector));
+		return -EIO;
+	}
 	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
 
 	r = __clone_and_map_data_bio(ci, ti, ci->sector, &len);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index b26fecf6c8e8..acfd4018125a 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -362,6 +362,11 @@ struct dm_target {
 	 * zone append operations using regular writes.
 	 */
 	bool emulate_zone_append:1;
+
+	/*
+	 * copy offload is supported
+	 */
+	bool copy_supported:1;
 };
 
 void *dm_per_bio_data(struct bio *bio, size_t data_size);
-- 
2.30.0-rc0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

