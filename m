Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 337C0C77B78
	for <dm-devel@archiver.kernel.org>; Wed, 12 Apr 2023 06:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681281569;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Rj0fZwUBXcOR4hVAG8du7h261kOHhkfA6dbrhkL/BrM=;
	b=UGUhk1EfOwowWgTWMdAsp/FLWhXrI+NUhOIlbYtHOMVcrr8juIKhj847B4LzpalNuDY6UP
	sdK4YTSnZDl+K+Ldbsn0P5zaePS+uTra+dvjJaPF5v+G49jkcKPLCKsf6V58yFlJsOJhCl
	svDA6Nmn5B75t8OWLLFK45rxGsDAbhU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-1Y2lQL9XN9GzYKRth1XvCw-1; Wed, 12 Apr 2023 02:39:26 -0400
X-MC-Unique: 1Y2lQL9XN9GzYKRth1XvCw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A08B03C0F68D;
	Wed, 12 Apr 2023 06:39:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8FF41492C13;
	Wed, 12 Apr 2023 06:39:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 203AA19472F3;
	Wed, 12 Apr 2023 06:39:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B7FC31946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Apr 2023 08:19:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9B901202701E; Tue, 11 Apr 2023 08:19:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 93A0D2027040
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 08:19:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7921A3813F3A
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 08:19:51 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-oul967L7PdmO4pIk0m7dbQ-1; Tue, 11 Apr 2023 04:19:48 -0400
X-MC-Unique: oul967L7PdmO4pIk0m7dbQ-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20230411081945epoutp017f17da8cd0371fdcaea426674aac51c7~U05IZRnm_0630906309epoutp01f
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 08:19:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20230411081945epoutp017f17da8cd0371fdcaea426674aac51c7~U05IZRnm_0630906309epoutp01f
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20230411081944epcas5p32c059cbc4322d2f40a830470c4961fae~U05Hws4EY0205802058epcas5p3V;
 Tue, 11 Apr 2023 08:19:44 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4Pwdzy6Jcqz4x9QK; Tue, 11 Apr
 2023 08:19:42 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 A1.EC.09987.E1815346; Tue, 11 Apr 2023 17:19:42 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20230411081342epcas5p22a4c587babd6a373cfa709d9609f65f4~U0z2KF_911873318733epcas5p2C;
 Tue, 11 Apr 2023 08:13:42 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230411081342epsmtrp165a97aca7b9f744fe5e1ac9e658333dc~U0z2HYLTt1918219182epsmtrp1T;
 Tue, 11 Apr 2023 08:13:42 +0000 (GMT)
X-AuditID: b6c32a4b-7fbff70000002703-5d-6435181e2d29
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 4A.FD.08609.5B615346; Tue, 11 Apr 2023 17:13:42 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230411081338epsmtip254352bf2c68432e6e66ec343cd492f17~U0zyW-oCI2386223862epsmtip2T;
 Tue, 11 Apr 2023 08:13:37 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Date: Tue, 11 Apr 2023 13:40:34 +0530
Message-Id: <20230411081041.5328-8-anuj20.g@samsung.com>
In-Reply-To: <20230411081041.5328-1-anuj20.g@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0zTVxTHc3+/8mshKSkg2wUcdl0IAQRaWsoFAcl0+kvYli5mD0kca+gv
 lEcf6WPKyBAhPETkUdBAYbzHAmw4ChIEioaXFoPMoU1kMhnSoGOAIkQIICu0bP73Oed+z/2e
 c24uA3ctpHsykuQaSiUXp3IIJ1r3kJ9voDcMlXAXSv3RtbFRHGWVbOOobbqYQAtDKwBdfbGB
 o5mbR5FxqcoBPbp1A0P9DToMtbSNYKiv/iWGRnYWCaQbNANkeajHkHEqAPUbTTQ02VtNoNpm
 Cx0NlmVjqGfuAkDdm7U4al9YpqE7U15oYvu2QwwkJx/Ekvon4wR5Qz9NJyf+7KCRk+Na0tB6
 kSA7m86TfY8yCfJy9hJBLg88JMiirlZAdt5NJ18ZvEnD3CImco5LiZRSYgmlYlPyBIUkSZ4Y
 xYk9FX8sPlTI5QXywlEYhy0Xy6gozvGPRYEnklKtG+CwvxWnaq0pkVit5gRHR6oUWg3FlirU
 migOpZSkKgXKILVYptbKE4PklCaCx+WGhFqF36RI51vqgPKp57l7Dfm0TDDrXgAcGZAlgI39
 r0EBcGK4svoA7FlsxG3BCoD3LR10W/AKQHPJG3y/pKW8gLAd9AL4uvmxXZWNwbH1sj0VwfKF
 w/M5excfYOXi8KXlIm03wFm/Y3Cra3lP5cZC8A9DDX2XaSwfqNus32OmNZ+1U2H1YFj9gmHx
 E5fdtCMrHG79kE/YJC7QVDlH22WcdQhmX6+yt1frCCfKP7fxcdi+cMXBxm7w79tddBt7wufF
 uXZOhOuTFszGSpg9OgBsfBTmjBXjuy3gLD94rTfYln4PXhlrx2y2zvDy5py9lAl7avaZA/Na
 qu0MofFepp1JOD72o32/hQAO360DJYCtf2sc/Vvj6P+3rgN4K/CglGpZIqUOVfLl1Nn/njlB
 ITOAvW/hH9sDZmdeBA0CjAEGAWTgnAPMtR2+xJUpEad9R6kU8SptKqUeBKHWdZfinu4JCuu/
 kmvieYJwrkAoFArC+UIe512mb5QpwZWVKNZQKRSlpFT7dRjD0TMTy7iZPntm2Xzy/cPsIw61
 t76mzqokHZEzRc3HHie7Vw7FO05GbZ8Y4eeMrDYItCerYngtSvPzhW0vXd5qepylMV/oKnBL
 ykxLkM0MdKw+2OHxL60tf2ZuE/nFBjr7pFXi2s7DF6i1S3e2RoimkI+CTn0ljT6vypuqPXOw
 YqN7RVfE/cL7YENAtCmLbzkkW6molpm6yqZLRXlvapoCMlSn/zLyTsvjNvuXPtkq73lWXubh
 nszI4jwN1xjDvIaPuCRvlGb88v2Q9JzH5gemyJ/DIr4Uad8pkcy3job8thFjqE+bzv3QSee3
 XvTp+n3zs5+md9JH1/+5Wni9jNnZ+SsZ4VPD59DUUjHPH1epxf8C1XKlyJ8EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsWy7bCSvO42MdMUg+mfmCzWnzrGbNE04S+z
 xeq7/WwWrw9/YrSY9uEns8WD/fYWe9/NZrW4eWAnk8WeRZOYLFauPspksXvhRyaLo//fsllM
 OnSN0eLp1VlMFntvaVvs2XuSxeLyrjlsFvOXPWW3ODS5mclix5NGRottv+czW6x7/Z7F4sQt
 aYvzf4+zOkh4XL7i7THr/lk2j52z7rJ7nL+3kcXj8tlSj02rOtk8Ni+p99h9s4HNo7f5HZvH
 +31X2Tz6tqxi9Nh8utrj8yY5j01P3jIF8EVx2aSk5mSWpRbp2yVwZTxfuYCx4LFUxblFHSwN
 jI9Euxg5OSQETCRWTuli62Lk4hAS2MEocetVAwtEQkLi1MtljBC2sMTKf8/ZIYoamSTmzWxn
 BkmwCahLHHneygiSEBGYwCxx6X4D2ChmgQdMEueff2EFqRIWsJC4vWkeO4jNIqAqMen3QjCb
 Fyje9H8GUAMH0Ap9if77giBhTgFLiT9zO8DCQkAlS/awQFQLSpyc+QTMZhaQl2jeOpt5AqPA
 LCSpWUhSCxiZVjFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBEezltYOxj2rPugdYmTi
 YDzEKMHBrCTC+/W/cYoQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotg
 skwcnFINTPmCcb2L42xae/jWPFtmeUK74bLT6knaaQFir3TUC3ZoPuqY53mBf09PchmDau6z
 7NJtv/w64s/OesG7b0sxi627huG1T5qS3ou4r/4LLRX6O79Ys+qk1ayU47P33pfwjpq5QvvW
 Ib3Hlyy/TfM9kbFcWKgqke+jbKDc1GSneSxnTBY0xb1X6n05UYHD2t81j9v80++0E0k/zn2L
 /nghz7r4u9DPBfJOrcuPh2//9YFBWKA0sCdoxfSvuzYtyfFjPbdJw9xie1mvg1X3p/nHVfdF
 h1ufCVcsesB18Hm3nWBE1dfvHxfXsHClhBZlx95eEm2+evWKr6lv1S1XTQhm+R9YeWz1/jNV
 Do07KiRYlViKMxINtZiLihMBKOh6SlUDAAA=
X-CMS-MailID: 20230411081342epcas5p22a4c587babd6a373cfa709d9609f65f4
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230411081342epcas5p22a4c587babd6a373cfa709d9609f65f4
References: <20230411081041.5328-1-anuj20.g@samsung.com>
 <CGME20230411081342epcas5p22a4c587babd6a373cfa709d9609f65f4@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Wed, 12 Apr 2023 06:39:18 +0000
Subject: [dm-devel] [PATCH v9 7/9] dm: Add support for copy offload
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nitesh Shetty <nj.shetty@samsung.com>

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
index 20c6b72a0245..1492bea4d605 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1709,6 +1709,13 @@ static blk_status_t __split_and_process_bio(struct clone_info *ci)
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
index 8aa6b3ea91fa..70142fff417c 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -386,6 +386,11 @@ struct dm_target {
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

