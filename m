Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7197DC7EE20
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 06:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681973840;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=891paM1cLv4e7h+vlwCKkTvuA9i/vBif7tt7hujffhg=;
	b=HzPNJU/Tqrv7X0kaOoDZOMNZ/hR4/KhTd0qTWX9E6F3skk2JETeXqQQ2CJjfa1hjWb2pRX
	3yac2/zeWDz3tt6se0lik+K601dPzA2vvOhWm+fMXZA237zH4KUD8hJSkJUSD9Xsz4Egm7
	WTNGNTjUia0t7E1XwrgDJVAcEWZ2Kc8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-bQ8DG2-wOWu-suNX42aNNA-1; Thu, 20 Apr 2023 02:57:17 -0400
X-MC-Unique: bQ8DG2-wOWu-suNX42aNNA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 444C93C10C68;
	Thu, 20 Apr 2023 06:57:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2CC80C16047;
	Thu, 20 Apr 2023 06:57:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C292419472DE;
	Thu, 20 Apr 2023 06:57:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C5EC819465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Apr 2023 11:54:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9FF551410F1E; Wed, 19 Apr 2023 11:54:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 97C3A1410F1C
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 11:54:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E975101A54F
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 11:54:55 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-PT5XcbskPBO5TscFAhSJPg-1; Wed, 19 Apr 2023 07:54:53 -0400
X-MC-Unique: PT5XcbskPBO5TscFAhSJPg-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20230419115450epoutp01a540e10708aeee186e83c34ce9a84ae0~XU-NW7SWo1264312643epoutp01i
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 11:54:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20230419115450epoutp01a540e10708aeee186e83c34ce9a84ae0~XU-NW7SWo1264312643epoutp01i
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTP id
 20230419115449epcas5p4b6fef3a1490cdf7179b603d68e3a331e~XU-M4v5Wx0259102591epcas5p4q;
 Wed, 19 Apr 2023 11:54:49 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4Q1fNS1RwPz4x9Pw; Wed, 19 Apr
 2023 11:54:48 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 21.9D.09540.886DF346; Wed, 19 Apr 2023 20:54:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230419114751epcas5p19249dff6e6e2c37795c80f973fd7eee3~XU5HWS7WI1730317303epcas5p1C;
 Wed, 19 Apr 2023 11:47:51 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230419114751epsmtrp1e418d528391252100c289c23958e45e2~XU5HU-fbr1843518435epsmtrp1Z;
 Wed, 19 Apr 2023 11:47:51 +0000 (GMT)
X-AuditID: b6c32a4a-4afff70000002544-95-643fd688b523
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 77.93.08609.7E4DF346; Wed, 19 Apr 2023 20:47:51 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20230419114748epsmtip19e3a900286e835c811f8e90d86182423~XU5ET-Z4x2496324963epsmtip1F;
 Wed, 19 Apr 2023 11:47:48 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Date: Wed, 19 Apr 2023 17:13:12 +0530
Message-Id: <20230419114320.13674-8-nj.shetty@samsung.com>
In-Reply-To: <20230419114320.13674-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02TeVATVxzH+3bDZqHGWRHGZ2pbGkYtUEKCITwuYabgrFoZevzRsX/gDlmO
 AkkmR7m0TUSpoICcrUENSkcEFUaucopFkUuEIUoHKEgZcFSMiDClqJQSAq3/fX7H93e9eSRu
 f4rLJ2PkGlYlZ+IEhB2n7pbLTvcTg4Ey0ePrBKrsvoOjo6eXcHRlNJtA07deAlT4YhFH462B
 qOV5kQ0autmAoeaLuRgqu9KOoaYLsxhqXzYTKLdtEKCpBwYMtQy7oeaWLg4yNZ4lkPHSFBe1
 5aViqH5SD1DdayOOKqZnOKhz+D3Ut9RhEwRp0/39tOFhL0E3GEa5dN/YdQ5t6tXSVeXpBF39
 yw9005COoDNTnxP0zI0HBJ1VUw7o6p4Ueq7qA7pq0oyFbTwY6x/NMjJW5cTKIxSyGHlUgGD/
 l+GfhntJRWJ3sQ/yFjjJmXg2QBD8WZj7npi4lQsInL5j4rQrrjBGrRZ47PZXKbQa1ilaodYE
 CFilLE4pUQrVTLxaK48SylmNr1gk8vRaSTwUGz1ZUgKUNfzEiceduA40OmYAWxJSEniq/w4n
 A9iR9lQTgOdzytaMlwDW6qfXjDkAnxaP2KxL8otMhDXQCGCf7hlhCdhTxzGYNSHLACRJUG6w
 Z5m05DhQaTicnUpfrYRTAxh8UzODWwSbKR84d21gtSqH2g7H7w+tMo/yhaUlr3BLIUh5wOyH
 myxuW8oPlt7Iw60pm2DXmUmOhXHqQ5haW4Rb6kOqxBaaF65i1kmDobG0FbfyZvi0o4ZrZT58
 kp22xgmwLP8yYRUfA9DwuwFYA4HweHf26hA45QIrGz2s7vdhQXcFZm28EWa+nlzrxYP159fZ
 GV6tLCasvBUOLujXmIY9f2Vg1stlAdhU2M05DZwMby1keGshw/+tiwFeDraySnV8FKv2UnrK
 2YT/njlCEV8FVr+F67568Of4C2EbwEjQBiCJCxx4d0N8ZfY8GZOUzKoU4SptHKtuA14rB8/B
 +Y4RipV/JdeEiyU+IolUKpX47JKKBVt4OwO6IuypKEbDxrKsklWt6zDSlq/DPE8W6oJ+3fBz
 inna8/KjeZQZqQ+u/7x9b/zI3/cOG/v8Q0JTooeoNO5NRh+7QRKEA5KhyTfN7t7mAZ1v6xHj
 SOS2tJRDJ0w970qnL4REmKuEs5ec60IXOz+e65h1EO7+YmZJdDCL+0eu//jXJ9+p7j98+5ue
 A3NuttWu9Hx/KG/gWWJHcmT695pCfUHyaC9Wm9g/fG7q0UI+Xzh/jQ/ctBNnikSlvq29LpRz
 YKaRPHskM2dB3Ji6/OP2eYef/DySbjumNW175ZddYfeJuJkdKx08MP/RV//sSeof6s7bV3Ds
 yW+mgC2DA0xLTHKDZq8qXHrOc8e9sF3e3x69m9C3OJYbJOCooxmxK65SM/8CI3yEVZ8EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Rf0yMcRzH932ep6fn4uxx/fC9apkzP3ZWZJpv+ZERHmPJH0YZ7uaeFeqc
 u87vqWSjU8rVqKuUSnXXMJVc3JFLiOzoynYXSi6ZSj+uLWmFu9j899r79f58Pn98KJxnInyp
 g9JEVi4VxwtID6KuURAQ2NsWLlmWNTof3Xn5DEfnsiZxVPUhk0R9jSMAXR0ax1HX43Bk/J7v
 hqwN9RgylKgxpK1qwtDDG8MYavo1QCK16R1APe0aDBltS5DB2Ewgy4MCEhWV97gjU3YqhvT2
 FIDqJopwdLtvkEAvbH7IPPncbR1kLG1bGU3na5Kp13xwZ8wf7xKM5bWSqdalkUxNWRLz0JpM
 Mhmp30lm8FE7yVyu1QGm5tVpxlEdwFTbB7CoWTEeqyVs/MFjrHzpWpFHnL20FMhqfU90f32B
 J4MH3irAoSC9AubkW0gV8KB4tB7Asif38WnBh+WTT/+yJ9RO9bpPl1IxaFRdBCpAUSS9BL76
 RTlzLzoLh62dya5NON2FQXPvqJtz2pMOhY5brS4m6AWwq83qYi4dBitKf+LORZBeCjM7Zztj
 Dr0KVjzKdh3m/amkm6bAdH02bM6zE07G6bkw9V4+ngVozX9K858qBpgO8FmZIiE2QREsWy5l
 jwcpxAkKpTQ26MCRhGrgerNQqAcG3VCQCWAUMAFI4QIvbsvGMAmPKxGfPMXKj+yXK+NZhQn4
 UYRgDveNqnk/j44VJ7KHWVbGyv9ZjOL4JmPlV/KCpyICaiPCutMtaYW7ZlRmYCLOuu4c9cJF
 UeqNXfXbDGMF45LbSSPplZ9ztEHvSDyiBno3fLQP7NYj2Bi5cy/G507tSnGIvIo3ZPhfQwEV
 uZttcSVfrmsL40Wx/mWd4Rda2yr4jw3ejsCWe4sLA/fYrMdvPn2/KeSyT4ZxWPSytoM/sSN8
 3oRx7JsmNL09LXrm2TXD/XXtMR1q8/bNsvuO8TkWn9ZPE9FeX2MKFnL0N/fdamw545MTEuk2
 FtmwXizN6x+2zli5vq5HvKAD+JaURWf2s99WLtv29pBnWqSsv8+2yFEojFJajmZfz5WiuPMh
 Qu2Wk5d+NFm+PFcKCEWcOFiIyxXi3zWsV8RVAwAA
X-CMS-MailID: 20230419114751epcas5p19249dff6e6e2c37795c80f973fd7eee3
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230419114751epcas5p19249dff6e6e2c37795c80f973fd7eee3
References: <20230419114320.13674-1-nj.shetty@samsung.com>
 <CGME20230419114751epcas5p19249dff6e6e2c37795c80f973fd7eee3@epcas5p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Thu, 20 Apr 2023 06:57:04 +0000
Subject: [dm-devel] [PATCH v10 7/9] dm: Add support for copy offload
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
Cc: bvanassche@acm.org, joshi.k@samsung.com, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, ming.lei@redhat.com,
 linux-block@vger.kernel.org, dlemoal@kernel.org,
 Nitesh Shetty <nj.shetty@samsung.com>, linux-fsdevel@vger.kernel.org,
 nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
 drivers/md/dm-table.c         | 41 +++++++++++++++++++++++++++++++++++
 drivers/md/dm.c               |  7 ++++++
 include/linux/device-mapper.h |  5 +++++
 3 files changed, 53 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 1398f1d6e83e..b3269271e761 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1867,6 +1867,39 @@ static bool dm_table_supports_nowait(struct dm_table *t)
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
+		     ti->type->iterate_devices(ti,
+			     device_not_copy_capable, NULL))
+			return false;
+	}
+
+	return true;
+}
+
 static int device_not_discard_capable(struct dm_target *ti, struct dm_dev *dev,
 				      sector_t start, sector_t len, void *data)
 {
@@ -1949,6 +1982,14 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 		q->limits.discard_misaligned = 0;
 	}
 
+	if (!dm_table_supports_copy(t)) {
+		blk_queue_flag_clear(QUEUE_FLAG_COPY, q);
+		q->limits.max_copy_sectors = 0;
+		q->limits.max_copy_sectors_hw = 0;
+	} else {
+		blk_queue_flag_set(QUEUE_FLAG_COPY, q);
+	}
+
 	if (!dm_table_supports_secure_erase(t))
 		q->limits.max_secure_erase_sectors = 0;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3b694ba3a106..ab9069090a7d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1720,6 +1720,13 @@ static blk_status_t __split_and_process_bio(struct clone_info *ci)
 	if (unlikely(ci->is_abnormal_io))
 		return __process_abnormal_io(ci, ti);
 
+	if ((unlikely(op_is_copy(ci->bio->bi_opf)) &&
+			max_io_len(ti, ci->sector) < ci->sector_count)) {
+		DMERR("Error, IO size(%u) > max target size(%llu)\n",
+			ci->sector_count, max_io_len(ti, ci->sector));
+		return BLK_STS_IOERR;
+	}
+
 	/*
 	 * Only support bio polling for normal IO, and the target io is
 	 * exactly inside the dm_io instance (verified in dm_poll_dm_io)
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index a52d2b9a6846..04016bd76e73 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -398,6 +398,11 @@ struct dm_target {
 	 * bio_set_dev(). NOTE: ideally a target should _not_ need this.
 	 */
 	bool needs_bio_set_dev:1;
+
+	/*
+	 * copy offload is supported
+	 */
+	bool copy_offload_supported:1;
 };
 
 void *dm_per_bio_data(struct bio *bio, size_t data_size);
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

