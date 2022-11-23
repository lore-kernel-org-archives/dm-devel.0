Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8B15C46467
	for <dm-devel@archiver.kernel.org>; Wed, 23 Nov 2022 08:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669191967;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8lOzSFuFXTz0h2kUA7DL300AU2JmSVUdTuIdpUDeFuc=;
	b=WLa/pY9m4YCN/mennYBMg5TBWUfujzpD5OSYyPh95r8E8iYcCMCCAjHXCezxcQY4GfBEZn
	8/oKM6n0COk6tu5oNgDGzhHIe8kblFy/cNnSo80v2UVu/O0qc+6q2N+MzoJJKSk/iEVE9e
	TB/SW79gRQFUsBBAckNcIs68O1XCxI4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-DQkOxn51PnyxX3IFGZ1e6A-1; Wed, 23 Nov 2022 03:26:04 -0500
X-MC-Unique: DQkOxn51PnyxX3IFGZ1e6A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEA60101A528;
	Wed, 23 Nov 2022 08:25:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AC4674EA61;
	Wed, 23 Nov 2022 08:25:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9E87919465A4;
	Wed, 23 Nov 2022 08:25:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CC7A0194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Nov 2022 06:21:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BFC7F39D7C; Wed, 23 Nov 2022 06:21:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B75AB4EA5B
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 06:21:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C1EE29DD99B
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 06:21:09 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-GZhT2WqENIGSyHjyvtSzPw-1; Wed, 23 Nov 2022 01:21:07 -0500
X-MC-Unique: GZhT2WqENIGSyHjyvtSzPw-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20221123061339epoutp020f7134ffa10e7733e112ce64a410b69c~qIgWUsSbA1821018210epoutp02x
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 06:13:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20221123061339epoutp020f7134ffa10e7733e112ce64a410b69c~qIgWUsSbA1821018210epoutp02x
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20221123061338epcas5p19a10d044dd5231ab4c410f9e745d3588~qIgVsGcz_0806308063epcas5p1o;
 Wed, 23 Nov 2022 06:13:38 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4NH9mc6sMzz4x9Pp; Wed, 23 Nov
 2022 06:13:36 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 0D.27.56352.01ABD736; Wed, 23 Nov 2022 15:13:36 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
 20221123061034epcas5p3fe90293ad08df4901f98bae2d7cfc1ba~qIdqbAfxR2070420704epcas5p3G;
 Wed, 23 Nov 2022 06:10:34 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20221123061034epsmtrp2602de2e166f8f56c95c08c75cbe028c4~qIdqaBxvZ0466304663epsmtrp2x;
 Wed, 23 Nov 2022 06:10:34 +0000 (GMT)
X-AuditID: b6c32a4b-5f7fe7000001dc20-0e-637dba10585d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 52.1B.14392.A59BD736; Wed, 23 Nov 2022 15:10:34 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20221123061031epsmtip1a9bf6055f42237a716527282c7e5298d~qIdnbPUwA1988319883epsmtip1d;
 Wed, 23 Nov 2022 06:10:31 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
 james.smart@broadcom.com, kch@nvidia.com, damien.lemoal@opensource.wdc.com,
 naohiro.aota@wdc.com, jth@kernel.org, viro@zeniv.linux.org.uk
Date: Wed, 23 Nov 2022 11:28:24 +0530
Message-Id: <20221123055827.26996-8-nj.shetty@samsung.com>
In-Reply-To: <20221123055827.26996-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxTZxTOe2+5LSyVK199BURSMpZC+Ogo5UVgM5lxl0kmiZhl+gPu2ruC
 QNv0Y04iAwdMZMqHgNEy+dgUJyBsBRRayhgbVpAOpyKCQDdCl30ERFlGHDLWcnHz33POeZ5z
 nnPevDzc6xOuPy9LqWM0SjpHSHhwrn0nEkWQpnxZdP9SDOoYuYGjjyvXcNQ6U0GgVdsYjiyL
 dW5ocqAXQ1dahzBkbnqMoaH1BQL9/OcUB50ZvA+QY9yAIctUOOqzDHPQXdNnBGpodnBRlbXT
 DfXMHwfo2moDjpYvFXNR+x+POOjmVAAaW7O67RJQBruNoHoNM1xqbPZrDnXXpqeMLScJqvNi
 AWWeLCSo00WLTkKJ3Y161D9OUOVdLYBaNgZRJwY+xSjj/AKWuuVgdmImQ8sZTTCjlKnkWUpF
 knDv/vQ30mOl0eIIcTyKEwYr6VwmSbg7JTViT1aOc39h8Ad0jt6ZSqW1WmHUa4kalV7HBGeq
 tLokIaOW56gl6kgtnavVKxWRSka3Uxwd/Wqsk5iRnTn+zQqhnvH/cOLqALcQTPqWAR4PkhL4
 eVdgGXDneZFmAK+25ZcBDyd+AqC5rgawwV8AjtS2u7lYLsHsHTvGFiwAnlqyEKy8BIOXFvWu
 rgQZDm+t81wcH7Icg6XmAdwV4GQdBhean3FdAm8yAVpLhze6csiX4frwdeDCfHInnD7nwFl7
 UbDCvtWVdnfSR380YSxlKxw+P89xYZzcAYu663DWXIM7vDd9jMW74WJz9aZpb/i7tYvLYn+4
 vMh6huQReKXmS8LlDZLFABomDIAtvA5LRio2POCkCHaYotj0dlg70o6xc7fA06vzGJvnw576
 5zgEtnU0bvbfBu+vHN/EFGxous1hb1UO4PhQaCUINrywjuGFdQz/T24EeAvYxqi1uQpGG6uO
 UTJH/ntimSrXCDY+RNjeHjD301LkIMB4YBBAHi704RckH5N58eX00TxGo0rX6HMY7SCIdZ67
 Cvf3lamcP0qpSxdL4qMlUqlUEh8jFQsF/C/Ohcm8SAWtY7IZRs1onuswnrt/IZYSRIQeWBMp
 vjKJ6s9Axo5Z056NBaw9jOoWvWl/C4Vk5Hsa4ox3VHy68qkUBNUcbrZtr6u3rThMnpVPFSuF
 fVP7eb8KHOIZh2Niat86jsy3A3/pP4iSHe8QAo7sQPdHKRZpX2rpD378Qzd+c2RkdJbk0e+n
 yb3eviUxJFx/5UFc6IU9AD8cf2juaOC78n1zgecLmcbw1pVSAVLcu5xQ79eXeHHX5cb0m7Nt
 aQmevu+N2qpPhJbXXgjIW4V/V2Rm9fhINC3Ncd58VLU7mfas8uAUpw2shRSc/FaQgfGJJ36a
 3qIdTWN26z/Tp15a/b7a+EBVdZZ82KcIeOxuG20RcrSZtDgM12jpfwEIyS52mQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWy7bCSnG7Uztpkg5eXFS3WnzrGbNE04S+z
 xeq7/WwWv8+eZ7bY+242q8XNAzuZLFauPspksXvhRyaLo//fslk8/HKLxWLSoWuMFk+vzmKy
 2HtL22LP3pMsFpd3zWGzmL/sKbvFxOObWS12PGlktNj2ez6zxeelLewW616/Z7E4cUva4vzf
 46wO4h6z7p9l89g56y67x/l7G1k8Lp8t9di0qpPNY/OSeo/dNxvYPHqb3wEVtN5n9Xi/7yqb
 R9+WVYwenzfJebQf6Gby2PTkLVMAXxSXTUpqTmZZapG+XQJXxtX939kK7kpVXF97gL2B8aZo
 FyMnh4SAicS9S/eZuhi5OIQEdjNKLNs8gREiISmx7O8RZghbWGLlv+fsEEXNTBJnW3cBFXFw
 sAloS5z+zwESFxFYwCRx+d4rZhCHWWApk8TsK3fZQLqFBawljnecZAWxWQRUJf6f3A62gVfA
 SuLOjKfMIIMkBPQl+u8LgoQ5gcrPXNzFBBIWAirZs0wHolpQ4uTMJywgNrOAvETz1tnMExgF
 ZiFJzUKSWsDItIpRMrWgODc9t9iwwDAvtVyvODG3uDQvXS85P3cTIziOtTR3MG5f9UHvECMT
 B+MhRgkOZiUR3nrPmmQh3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbB
 ZJk4OKUamDzePZG6uYuBaYZieZKjvIJKgOPil6H1epy1kxV/x0Vy1j/qVL0xgeXShGuLrVtq
 wva9+O0jG30od36n5OIpNQHq4l+Fp+3KmWd78qOi0vSFj/33B6hPX8X/+Etlq8vxi7LHg894
 ygcd7bslsfKwsO2jPeU3ROImzpyncjDy6OTX2ozul9jmf1fscensWPNScdHi5xZyx31zO0p6
 L3xP79z/9eXKjIN3PWruN0zeG8AXs93Me8XjLdb2UhUbfxeu9tq/In+ytLRZzImeuN9He99v
 KQ8tWySmK8LEPJFb5dBhh00ZXOlbQhUj53/tXRB81d/jdr21sqmrWvp1I69Go30bNpz0mpEa
 brRx8dkfukosxRmJhlrMRcWJAFoIfGtSAwAA
X-CMS-MailID: 20221123061034epcas5p3fe90293ad08df4901f98bae2d7cfc1ba
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221123061034epcas5p3fe90293ad08df4901f98bae2d7cfc1ba
References: <20221123055827.26996-1-nj.shetty@samsung.com>
 <CGME20221123061034epcas5p3fe90293ad08df4901f98bae2d7cfc1ba@epcas5p3.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Wed, 23 Nov 2022 08:25:56 +0000
Subject: [dm-devel] [PATCH v5 07/10] dm: Add support for copy offload.
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
Cc: p.raghav@samsung.com, joshi.k@samsung.com, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, Nitesh Shetty <nj.shetty@samsung.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Before enabling copy for dm target, check if underlying devices and
dm target support copy. Avoid split happening inside dm target.
Fail early if the request needs split, currently splitting copy
request is not supported.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 drivers/md/dm-table.c         | 42 +++++++++++++++++++++++++++++++++++
 drivers/md/dm.c               |  7 ++++++
 include/linux/device-mapper.h |  5 +++++
 3 files changed, 54 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 078da18bb86d..b2073e857a74 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1875,6 +1875,39 @@ static bool dm_table_supports_nowait(struct dm_table *t)
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
@@ -1957,6 +1990,15 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 		q->limits.discard_misaligned = 0;
 	}
 
+	if (!dm_table_supports_copy(t)) {
+		blk_queue_flag_clear(QUEUE_FLAG_COPY, q);
+		/* Must also clear copy limits... */
+		q->limits.max_copy_sectors = 0;
+		q->limits.max_copy_sectors_hw = 0;
+	} else {
+		blk_queue_flag_set(QUEUE_FLAG_COPY, q);
+	}
+
 	if (!dm_table_supports_secure_erase(t))
 		q->limits.max_secure_erase_sectors = 0;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e1ea3a7bd9d9..713335995290 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1690,6 +1690,13 @@ static blk_status_t __split_and_process_bio(struct clone_info *ci)
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
index 04c6acf7faaa..da4e77e81011 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -379,6 +379,11 @@ struct dm_target {
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

