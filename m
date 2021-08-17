Return-Path: <SRS0=ouO8=NI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA94C4338F
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 11:34:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6F73760FE6
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 11:34:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6F73760FE6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-dGTQ0WVwPViMK1WsrzXczA-1; Tue, 17 Aug 2021 07:34:38 -0400
X-MC-Unique: dGTQ0WVwPViMK1WsrzXczA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9F44871803;
	Tue, 17 Aug 2021 11:34:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A61C719C46;
	Tue, 17 Aug 2021 11:34:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4315B4BB7C;
	Tue, 17 Aug 2021 11:34:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17HBYUAr010095 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 17 Aug 2021 07:34:30 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AA32D114B31A; Tue, 17 Aug 2021 11:34:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A5AF110F8E3F
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 11:34:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7EAF101A529
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 11:34:24 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-455-FpGnlDVRM2SDKd26etr_iw-1; Tue, 17 Aug 2021 07:34:22 -0400
X-MC-Unique: FpGnlDVRM2SDKd26etr_iw-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id
	20210817112859epoutp018374472aa8ee7da4c0cf7dac4928955a~cFIgClVLi2658626586epoutp016
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 11:28:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
	20210817112859epoutp018374472aa8ee7da4c0cf7dac4928955a~cFIgClVLi2658626586epoutp016
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20210817112858epcas5p22783cb3d20c2c36d7fcc5ff299ae74da~cFIe23gd31218412184epcas5p20;
	Tue, 17 Aug 2021 11:28:58 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Gppgz1k5tz4x9Ps;
	Tue, 17 Aug 2021 11:28:47 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	41.AD.41701.F6D9B116; Tue, 17 Aug 2021 20:28:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20210817101753epcas5p4f4257f8edda27e184ecbb273b700ccbc~cEKavAPR62768027680epcas5p4G;
	Tue, 17 Aug 2021 10:17:53 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20210817101753epsmtrp2a9f778c4fe57b2289c6f982dd4085289~cEKat0o112821228212epsmtrp2C;
	Tue, 17 Aug 2021 10:17:53 +0000 (GMT)
X-AuditID: b6c32a4b-0abff7000001a2e5-ca-611b9d6f9869
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	92.5E.08394.0DC8B116; Tue, 17 Aug 2021 19:17:53 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20210817101749epsmtip2865161915607c3347d306ff9267e2714~cEKW6oO2d0132601326epsmtip2Z;
	Tue, 17 Aug 2021 10:17:49 +0000 (GMT)
From: SelvaKumar S <selvakuma.s1@samsung.com>
To: linux-nvme@lists.infradead.org, linux-block@vger.kernel.org
Date: Tue, 17 Aug 2021 15:44:18 +0530
Message-Id: <20210817101423.12367-3-selvakuma.s1@samsung.com>
In-Reply-To: <20210817101423.12367-1-selvakuma.s1@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te1BUVRzH59y73N210CuSndYX7oQ8ElhyWQ4FqAPYncCGommUwfAGd4CA
	3W0fYVEJJYlrYBCCLBAJhIImw7LgikCxCMiCMbIKI0QxvOIxvANRIttlsfzv8/ud7/d85/zO
	/Di4zXk2jxMjVjAyMR3HJzawapqcHF0kBdtogWGQiyoMLTjKL68B6Er/OQJlzz7CUcrpJQwZ
	hzei+uk8K1R2pRlDQ78tsNGq6ncMNT+ZIlDnVBOGMvXdANVpslio6mEqgep7X0F19W0sVFg6
	wkZne3QEutT6D4YyUu9jSDecDFDNSiGO7mUV4WhgpoeNJpfbCPR15SJAK8v5xIHtlPFeIHVD
	3c+mqi47U8Y7SkpTfoagqkpOUjcfJBHU3Egvi5ppuE9Q6dpyQC1odlKnfzmLBT8fGusdzdCR
	jMyOEUdIImPEUT78wJBwv3APkcDdxd0LefLtxHQ848P3Dwp2ORQTZxoG3+5jOk5pagXTcjnf
	zddbJlEqGLtoiVzhw2ekkXFSodRVTsfLleIoVzGjeM1dIHjVwyQ8HhudU/oAl646nxhR12BJ
	oPFlFeByICmEfbmdQAU2cGzImwCm3FnELMU8gAWnBwmzyoZcMp1M+D515Ksb1kX1AJYlTbIs
	xQKApzIm1xwE6QK7SzQsM9uS+2HZo3IrswgnDSyYM1PENh9sIQPhr1f7MTOzSHvYVzwAzGxN
	+sDVrMdWlrhdMLfroUnP4XBJX1g7b2+RbIZtucNr9+MmyVfVebj5fkhWcKFqcGHd6w//NvYA
	C2+BE61atoV5cGG6nrBwAhw9k41ZOAnA9JkEC++Hd+tWMXMuTjrBilo3S3sHPG+4hllyN8K0
	leF1qzXUfT+8JofkHmi4LrK0t8PZptr1JAo2zqevjzoDwMelxVbfAjv1M89RP/Mc9f/JPwC8
	HLzESOXxUYzcQ7pPzCT898kRkngNWNsP50AdGByYddUDjAP0AHJwvq21A4dH21hH0p98ysgk
	4TJlHCPXAw/TuDNw3gsREtOCiRXh7kIvgVAkEgm99onc+S9ahwVto23IKFrBxDKMlJE99WEc
	Li8JU7b2poskgrfhuKJOtdch5Y34Wbbjc5UXl+q2bgod6Hr/u7mjo+fGG/RzM2EGbcGPiR07
	HBzDDmcnF+0Jmes7rkrEPxRnfuP02ea3srryWphWp3HRl7v4Q/S7vddDrjnaO+S7njzyp6ZR
	PeZ428H3i45TCStl7wWoIz5vzzzWMlH6Tpqx5/KRi7rCg3jL0amf3lRtSiweGhjL6bDrnBbr
	V4S83Luhbtrm/LEL7W3VCv+d1VJugm5RXxLA1/jZD1V6lx2Q+C1zZ7O0HdzDly5oPcm0RuOJ
	IOcyz/gnqcc+GE5me/7x827V3kMRt27l2KZEjXpT4MbW9m6971+34z5qfX331QAXPkseTbs7
	4zI5/S/ElVd9qAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0xSYRzGe885HY5O3BGdvaFpw6xFw8ty6y3TtPXhbNXyQ31xbUV4RpYi
	QWKxmjZnGpplkSVZdnFesKZhESV2wbSoDEu0tEhdOl03pfJSDEu0tr49+/9+e54PfwrntRN8
	KlW2n1XIxGkC0pswtghCRS+LgsRRxQMYqn/ahqNyvRGgOscJEpWO/cRRXv4EhjoHfVHz1/Pz
	UW1dK4Y+vPvOQW7Newy1/v5CItuXFgydsnQDZDZoCdQ4WUCi5t4VyNxsJVBF1RAHFb42kaj6
	8TSGSgq6MGQaPAKQ0VWBI7v2Co76R19z0KcpK4mO3hgHyDVVTiYEM532jcwdnYPDNNYImc72
	TMagP0YyjZXZTFNPDsk4h3oJZvReF8kU39QD5rshhMl/UIgl+SR7r01h01JVrCIyfqf37rNV
	PbjcLTwwpDNiOeDhEg3woiAdA8t19zAN8KZ4dBOAfafN8+dAMLzuOEbOZX9YOz3MmZOcAI7m
	OTgeQNIi2F1pIDw5gE6Ez74ZZ5tw+iMB3zuacA/wpzfCF9ccmCcTdDh8e7UfeDKXjoNu7a+/
	a6Gw7NXkTClFedHx8O63cM+ZN6PcN5/hzOl+0Fo2OLuFz+i5t87jJwGt+w/p/kOXAKYHC1m5
	Ml2aroyWR8vYrAilOF2ZKZNGSDLSDWD248LlJnBbPxZhARgFLABSuCCAu4zii3ncFPFBNavI
	2KHITGOVFhBEEYIF3A6NdQePlor3s3tZVs4q/lGM8uLnYAkjU4UuEX+A/mx9vvJCrCgv9+YD
	y+P+krstiuitt2qimpU250BbRbzGbghVNa7JnCd89Wtd0XbR5oWfQ2SL9paeq+28/qNvsaRh
	9YYXRTH8uOqwa7V+a22l7jTXrrDlleY7yeolZd1T82JNv/ttkUEq7ctzdIp2U+BOqSog92Li
	gkdhJndf1/qJLdn+9tREv0PVS+tH9nRIWiXq47acJ4rcWN99+zomOc4s53BCwciN43zoMyFK
	inpanDVsjH2iFmzreRZJ1j86XM9tSPwIzkjtvW1r3sRZJF+rerOniwSjrnWqwJiQVUnB8sBy
	38qjLlcDqV76dprHjB+4cvqyoURAKHeLo4W4Qin+A10p3OdgAwAA
X-CMS-MailID: 20210817101753epcas5p4f4257f8edda27e184ecbb273b700ccbc
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210817101753epcas5p4f4257f8edda27e184ecbb273b700ccbc
References: <20210817101423.12367-1-selvakuma.s1@samsung.com>
	<CGME20210817101753epcas5p4f4257f8edda27e184ecbb273b700ccbc@epcas5p4.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17HBYUAr010095
X-loop: dm-devel@redhat.com
Cc: snitzer@redhat.com, djwong@kernel.org, dm-devel@redhat.com, hch@lst.de,
	agk@redhat.com, bvanassche@acm.org, linux-scsi@vger.kernel.org,
	nitheshshetty@gmail.com, willy@infradead.org,
	nj.shetty@samsung.com, kch@kernel.org,
	SelvaKumar S <selvakuma.s1@samsung.com>, selvajove@gmail.com,
	mpatocka@redhat.com, javier.gonz@samsung.com, kbusch@kernel.org,
	axboe@kernel.dk, damien.lemoal@wdc.com, joshi.k@samsung.com,
	martin.petersen@oracle.com, linux-api@vger.kernel.org,
	johannes.thumshirn@wdc.com, linux-fsdevel@vger.kernel.org,
	joshiiitr@gmail.com, asml.silence@gmail.com
Subject: [dm-devel] [PATCH 2/7] block: Introduce queue limits for
	copy-offload support
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nitesh Shetty <nj.shetty@samsung.com>

Add device limits as sysfs entries,
        - copy_offload (READ_WRITE)
        - max_copy_sectors (READ_ONLY)
        - max_copy_ranges_sectors (READ_ONLY)
        - max_copy_nr_ranges (READ_ONLY)

copy_offload(= 0), is disabled by default. This needs to be enabled if
copy-offload needs to be used.
max_copy_sectors = 0, indicates the device doesn't support native copy.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/blk-settings.c   |  4 ++++
 block/blk-sysfs.c      | 51 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |  6 +++++
 3 files changed, 61 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 3613d2cc0688..ac59922e0cde 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -57,6 +57,10 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->misaligned = 0;
 	lim->zoned = BLK_ZONED_NONE;
 	lim->zone_write_granularity = 0;
+	lim->copy_offload = 0;
+	lim->max_copy_sectors = 0;
+	lim->max_copy_nr_ranges = 0;
+	lim->max_copy_range_sectors = 0;
 }
 EXPORT_SYMBOL(blk_set_default_limits);
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 1832587dce3a..aabab65f10ab 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -169,6 +169,48 @@ static ssize_t queue_discard_granularity_show(struct request_queue *q, char *pag
 	return queue_var_show(q->limits.discard_granularity, page);
 }
 
+static ssize_t queue_copy_offload_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->limits.copy_offload, page);
+}
+
+static ssize_t queue_copy_offload_store(struct request_queue *q,
+				       const char *page, size_t count)
+{
+	unsigned long copy_offload;
+	ssize_t ret = queue_var_store(&copy_offload, page, count);
+
+	if (ret < 0)
+		return ret;
+
+	if (copy_offload && q->limits.max_copy_sectors == 0)
+		return -EINVAL;
+
+	if (copy_offload)
+		q->limits.copy_offload = BLK_COPY_OFFLOAD_SCC;
+	else
+		q->limits.copy_offload = 0;
+
+	return ret;
+}
+
+static ssize_t queue_max_copy_sectors_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->limits.max_copy_sectors, page);
+}
+
+static ssize_t queue_max_copy_range_sectors_show(struct request_queue *q,
+		char *page)
+{
+	return queue_var_show(q->limits.max_copy_range_sectors, page);
+}
+
+static ssize_t queue_max_copy_nr_ranges_show(struct request_queue *q,
+		char *page)
+{
+	return queue_var_show(q->limits.max_copy_nr_ranges, page);
+}
+
 static ssize_t queue_discard_max_hw_show(struct request_queue *q, char *page)
 {
 
@@ -611,6 +653,11 @@ QUEUE_RO_ENTRY(queue_nr_zones, "nr_zones");
 QUEUE_RO_ENTRY(queue_max_open_zones, "max_open_zones");
 QUEUE_RO_ENTRY(queue_max_active_zones, "max_active_zones");
 
+QUEUE_RW_ENTRY(queue_copy_offload, "copy_offload");
+QUEUE_RO_ENTRY(queue_max_copy_sectors, "max_copy_sectors");
+QUEUE_RO_ENTRY(queue_max_copy_range_sectors, "max_copy_range_sectors");
+QUEUE_RO_ENTRY(queue_max_copy_nr_ranges, "max_copy_nr_ranges");
+
 QUEUE_RW_ENTRY(queue_nomerges, "nomerges");
 QUEUE_RW_ENTRY(queue_rq_affinity, "rq_affinity");
 QUEUE_RW_ENTRY(queue_poll, "io_poll");
@@ -657,6 +704,10 @@ static struct attribute *queue_attrs[] = {
 	&queue_discard_max_entry.attr,
 	&queue_discard_max_hw_entry.attr,
 	&queue_discard_zeroes_data_entry.attr,
+	&queue_copy_offload_entry.attr,
+	&queue_max_copy_sectors_entry.attr,
+	&queue_max_copy_range_sectors_entry.attr,
+	&queue_max_copy_nr_ranges_entry.attr,
 	&queue_write_same_max_entry.attr,
 	&queue_write_zeroes_max_entry.attr,
 	&queue_zone_append_max_entry.attr,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 28a193225cf2..fd4cfaadda5b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -321,10 +321,14 @@ struct queue_limits {
 	unsigned int		discard_granularity;
 	unsigned int		discard_alignment;
 	unsigned int		zone_write_granularity;
+	unsigned int            copy_offload;
+	unsigned int            max_copy_sectors;
 
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
 	unsigned short		max_discard_segments;
+	unsigned short          max_copy_range_sectors;
+	unsigned short          max_copy_nr_ranges;
 
 	unsigned char		misaligned;
 	unsigned char		discard_misaligned;
@@ -600,6 +604,7 @@ struct request_queue {
 #define QUEUE_FLAG_RQ_ALLOC_TIME 27	/* record rq->alloc_time_ns */
 #define QUEUE_FLAG_HCTX_ACTIVE	28	/* at least one blk-mq hctx is active */
 #define QUEUE_FLAG_NOWAIT       29	/* device supports NOWAIT */
+#define QUEUE_FLAG_SIMPLE_COPY	30	/* supports simple copy */
 
 #define QUEUE_FLAG_MQ_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_SAME_COMP) |		\
@@ -622,6 +627,7 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
 #define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->queue_flags)
 #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
+#define blk_queue_copy(q)	test_bit(QUEUE_FLAG_SIMPLE_COPY, &(q)->queue_flags)
 #define blk_queue_zone_resetall(q)	\
 	test_bit(QUEUE_FLAG_ZONE_RESETALL, &(q)->queue_flags)
 #define blk_queue_secure_erase(q) \
-- 
2.25.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

