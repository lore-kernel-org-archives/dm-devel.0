Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3084EC77B72
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 06:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681973843;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=93w9ObCccaY2y/XnFI7H4Dj2e8BAA9kP8Np8qT/W1Ks=;
	b=aQKRF+KRV+SaWBx5uB1LZFxccOUNcKMZL9VqwjUI9CRwWjy/N+Bo9MERC9qr5AFnyy4j7v
	lkeWpsxDGq2Df3UAhhcHc2D+dL9om2D4qZ54NLBsEjiCqMwtGFeWiEV18k1Cg/yiVxLQ05
	IraBNM0CCM3AyNZUPyvfv/W5hC47Iys=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-U4dzEPJAP4yY3k3lP3tz9g-1; Thu, 20 Apr 2023 02:57:20 -0400
X-MC-Unique: U4dzEPJAP4yY3k3lP3tz9g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 619371C09536;
	Thu, 20 Apr 2023 06:57:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4B37140C201F;
	Thu, 20 Apr 2023 06:57:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 127751946A6B;
	Thu, 20 Apr 2023 06:57:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A0D5519465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Apr 2023 11:55:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 82F3F2026D16; Wed, 19 Apr 2023 11:55:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A8CD2026D25
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 11:55:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 597133C10242
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 11:55:02 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-9Rt-qevrNH6t0AcYbVPvbQ-1; Wed, 19 Apr 2023 07:55:00 -0400
X-MC-Unique: 9Rt-qevrNH6t0AcYbVPvbQ-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230419115457epoutp028385b0253334cc2e5c9efa4ac4777291~XU-T2ZUgZ3128131281epoutp02K
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 11:54:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230419115457epoutp028385b0253334cc2e5c9efa4ac4777291~XU-T2ZUgZ3128131281epoutp02K
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20230419115456epcas5p2fe3ba66a84ae572af0d21e62bc772135~XU-TbEuka1844418444epcas5p26;
 Wed, 19 Apr 2023 11:54:56 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4Q1fNb2m7sz4x9Py; Wed, 19 Apr
 2023 11:54:55 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 C6.34.09987.F86DF346; Wed, 19 Apr 2023 20:54:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
 20230419114810epcas5p3b10b7eddf9dae9ddc41940f09b483813~XU5Yporf_0874908749epcas5p3G;
 Wed, 19 Apr 2023 11:48:10 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230419114810epsmtrp142f95b564da6872f61544594de8071cf~XU5YofKW61896418964epsmtrp1C;
 Wed, 19 Apr 2023 11:48:10 +0000 (GMT)
X-AuditID: b6c32a4b-a67fd70000002703-72-643fd68fccb9
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 4E.97.08279.AF4DF346; Wed, 19 Apr 2023 20:48:10 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20230419114806epsmtip15324f8047867f14d72c9bdf9f1f60c86~XU5VStBYa2332323323epsmtip1n;
 Wed, 19 Apr 2023 11:48:06 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Date: Wed, 19 Apr 2023 17:13:14 +0530
Message-Id: <20230419114320.13674-10-nj.shetty@samsung.com>
In-Reply-To: <20230419114320.13674-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xbZRTPd297W3CFy8P4DZnDmmU85FFWygeOIQ7wEtSQLCZmQbChN4UA
 bW3pcBId7zAYYzDArMzR6RwUykNgjJWHGwR5CwkDBeQhDze3DFj3ILMCtlzQ/ff7/c453znn
 9+VwcfvLHCdugiyFVsrESXzCmtXa43bYs2gyWOJj7LBBDYM/4yjzwiaOameLCPSwxwhQ+foL
 HJlGRnG08FMw6lytYKOp27cw1PFdCYZ0tb0Yar/6GEO9248IVNI9CdDKhAZDndMeqKNzgIXG
 DZcJVHl9hYO6L2ZhqG05A6BWUyWO6h+usVD/9OtoqSAPoNHNPva7TtT43UhKMz9CULc0sxxq
 dO5HFjU+oqaaas4SVPO1M1T7VDpBFWatmhNy5tnUWtcEQZ1vqQFU81Aa9aTpDapp+REWZXsy
 8Wg8LZbQShdaFieXJMikQfzIE7HHY/1EPgJPQQDy57vIxMl0ED/0gyjP8IQksyF8l1PiJLVZ
 ihKrVHzvY0eVcnUK7RIvV6UE8WmFJEkhVHipxMkqtUzqJaNTAgU+Pr5+5sTPEuPv11WxFd8G
 f5GdN4qngxVhPrDiQlIIx/4Z5+QDa6492Q7glDaXzRAjgBV5dwBDngO4/EMmsVeSUfcbwQQ6
 AZzRGHGG5GBwVL/FygdcLkF6wKFtrkV3JHNx+HjlLMtCcFKPw4V1E7A85UAGwxddZSwLZpGH
 oK7iHMeCeeQ7sHp6BbM8BElvWDRvZ5GtzHJV10WcSbGDA5eWd0px8iDMulGxMwQkm63gXPaf
 bGbUUPi3qYXFYAf4oK+Fw2An+FdR7i5OhbrSaoIpzgZQ86sGMIFgmDNYhFuGwEk32GDwZuQD
 sGywHmMa28BC0zLG6DzYdmUPvwX1Ddpdu/bDyY2MXUzBkmc5uwafB1B3bQZcAC6alxbSvLSQ
 5v/WWoDXgP20QpUspVV+iiMyOvW/f46TJzeBnTNxj2wDiwvrXt0A44JuALk435E3HBYosedJ
 xKe/pJXyWKU6iVZ1Az+z4cW406txcvOdyVJiBcIAH6FIJBIGHBEJ+K/xDgcNxNmTUnEKnUjT
 Clq5V4dxrZzSMfu3i4lGf35Irr7g3r6bDc6+gVfebz02vRBeVfv75xNd4eWNlbdfic5zfR5z
 AeW2xGgXP+nvaSrNsbmrhalrb+rqn6TBG6cChALOmW3pgW+eHgoYc/7jl5D0j+fC+13j7qgf
 0Lw5laeo3HV4yXEpsjE+ctNoJ6sN/cgdi0itc19Uv6d/aviKN+w/FJXe67BqWLW6et9F4FHY
 9SGh8/16ONr/2RQdRri2xxSknjgXlpNh083S62yr08Y2JBEzUyHVtupE6b1Y0F+6NXvSmdto
 6FMWa/dJRxsK2J/a6Oc1Gb1sg9H6Zual69+bTi+7FcUG5G95lx3sj4vmqjd0DhFt8mQ+SxUv
 FrjjSpX4XzyXjwevBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTcRjG+59zdnYcLc+m0V8lq0FSRqZk9ceGMyo7dKOwL2ZSSw/mfWxa
 WVRbWtk0My3DWWgqLq+lZrq8VFMrK5l5KyWdkqNE5iwpMVFzjsBvz/v8nvd9PrwULuwgnKnw
 mDhWHiONEpE84nmzyHXz325JqGfqKImevH+Do6vpszgqHbhNorHmXwBlTUzjaKbdgKOhlxLU
 OJ7DQX2vdBhqyM/AUHFpK4bqH/3EUOu8mUQZ+l6ATD0aDDX2b0INjW0E6nrxgES5RSYu0mcm
 YqhuRAXQ85lcHFWMWQj0rt8FfUtJBsgw+5bj58x0dR9gNMZ2ktFpBriMYbCSYLra45mqkpsk
 U114hanvU5LMrcTxhcA1I4exNPWQTNqzEsBUf7jITFa5MlUjZuyI/XGeOJSNCj/Lyrf4nuKd
 +VGu5cgeSs4nJRtwJTB5q4EdBWlvqCr/QqoBjxLS9QA2t01xbcAJFs224DbtAIvnvnNtoUQM
 ZtaqFwaKIulN8MM8ZfUd6XQcdhqVpHUBpxtwWJy3y6odaAmcbrpHWDVBr4fFOamLBXx6J3zc
 b8KsdyC9Bd42Cqy23YKtbcpc7BXSPjBVPwdscQFsyx4hbOfXwMSaHDwd0JolSLME5QGsBDix
 MkV0WLTCS+YVw57zUEijFfExYR4hsdFVYPHp7hvrQG3JhIceYBTQA0jhIkf+PrFvqJAfKk24
 wMpjT8rjo1iFHrhQhGgVv0PddlJIh0nj2EiWlbHy/xSj7JyVWNqpG/LA1kP+E8I66d1cex/0
 60bOdp9PQ5Eha0V8nRepTcjMsjMOtFfMsC2/z1eeHr+8p2Zq9bJgUeClr70rXCTm6d4f+UEf
 C7PPqTIEY/al3Y6elQJVSM+qmnXu/uSwutBNpjV4kBnkn9jlh7UJrkYsJWD/DoeAhGCZZ++h
 j4LG0b3cstTfZjytLMjk6J2XJubyXr9O4URYfLFa3VFjXOw+3bA2r3tr/aibr2inf+SJyXdh
 k9UbjsbrAgqcWhuOPJWYx7XK8Cmx3qewYHfSSnFdCieOf+zzEGO5479rSnXB0nF9c74f96Bx
 /Tx0v9+5tnrw8l7hNj+niCD9ntVcEaE4I/Vyx+UK6T+V/wzJYwMAAA==
X-CMS-MailID: 20230419114810epcas5p3b10b7eddf9dae9ddc41940f09b483813
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230419114810epcas5p3b10b7eddf9dae9ddc41940f09b483813
References: <20230419114320.13674-1-nj.shetty@samsung.com>
 <CGME20230419114810epcas5p3b10b7eddf9dae9ddc41940f09b483813@epcas5p3.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Thu, 20 Apr 2023 06:57:04 +0000
Subject: [dm-devel] [PATCH v10 9/9] null_blk: add support for copy offload
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
Cc: Vincent Fu <vincent.fu@samsung.com>, bvanassche@acm.org,
 joshi.k@samsung.com, gost.dev@samsung.com, anuj20.g@samsung.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 ming.lei@redhat.com, linux-block@vger.kernel.org, dlemoal@kernel.org,
 Nitesh Shetty <nj.shetty@samsung.com>, linux-fsdevel@vger.kernel.org,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Implementaion is based on existing read and write infrastructure.
copy_max_bytes: A new configfs and module parameter is introduced, which
can be used to set hardware/driver supported maximum copy limit.

Suggested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 drivers/block/null_blk/main.c     | 108 ++++++++++++++++++++++++++++--
 drivers/block/null_blk/null_blk.h |   8 +++
 2 files changed, 111 insertions(+), 5 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 5d54834d8690..9028aae1efbd 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -157,6 +157,10 @@ static int g_max_sectors;
 module_param_named(max_sectors, g_max_sectors, int, 0444);
 MODULE_PARM_DESC(max_sectors, "Maximum size of a command (in 512B sectors)");
 
+static unsigned long g_copy_max_bytes = COPY_MAX_BYTES;
+module_param_named(copy_max_bytes, g_copy_max_bytes, ulong, 0444);
+MODULE_PARM_DESC(copy_max_bytes, "Maximum size of a copy command (in bytes)");
+
 static unsigned int nr_devices = 1;
 module_param(nr_devices, uint, 0444);
 MODULE_PARM_DESC(nr_devices, "Number of devices to register");
@@ -409,6 +413,7 @@ NULLB_DEVICE_ATTR(home_node, uint, NULL);
 NULLB_DEVICE_ATTR(queue_mode, uint, NULL);
 NULLB_DEVICE_ATTR(blocksize, uint, NULL);
 NULLB_DEVICE_ATTR(max_sectors, uint, NULL);
+NULLB_DEVICE_ATTR(copy_max_bytes, uint, NULL);
 NULLB_DEVICE_ATTR(irqmode, uint, NULL);
 NULLB_DEVICE_ATTR(hw_queue_depth, uint, NULL);
 NULLB_DEVICE_ATTR(index, uint, NULL);
@@ -550,6 +555,7 @@ static struct configfs_attribute *nullb_device_attrs[] = {
 	&nullb_device_attr_queue_mode,
 	&nullb_device_attr_blocksize,
 	&nullb_device_attr_max_sectors,
+	&nullb_device_attr_copy_max_bytes,
 	&nullb_device_attr_irqmode,
 	&nullb_device_attr_hw_queue_depth,
 	&nullb_device_attr_index,
@@ -656,7 +662,8 @@ static ssize_t memb_group_features_show(struct config_item *item, char *page)
 			"poll_queues,power,queue_mode,shared_tag_bitmap,size,"
 			"submit_queues,use_per_node_hctx,virt_boundary,zoned,"
 			"zone_capacity,zone_max_active,zone_max_open,"
-			"zone_nr_conv,zone_offline,zone_readonly,zone_size\n");
+			"zone_nr_conv,zone_offline,zone_readonly,zone_size,"
+			"copy_max_bytes\n");
 }
 
 CONFIGFS_ATTR_RO(memb_group_, features);
@@ -722,6 +729,7 @@ static struct nullb_device *null_alloc_dev(void)
 	dev->queue_mode = g_queue_mode;
 	dev->blocksize = g_bs;
 	dev->max_sectors = g_max_sectors;
+	dev->copy_max_bytes = g_copy_max_bytes;
 	dev->irqmode = g_irqmode;
 	dev->hw_queue_depth = g_hw_queue_depth;
 	dev->blocking = g_blocking;
@@ -1271,6 +1279,78 @@ static int null_transfer(struct nullb *nullb, struct page *page,
 	return err;
 }
 
+static inline void nullb_setup_copy_read(struct nullb *nullb, struct bio *bio)
+{
+	struct nullb_copy_token *token = bvec_kmap_local(&bio->bi_io_vec[0]);
+
+	token->subsys = "nullb";
+	token->sector_in = bio->bi_iter.bi_sector;
+	token->nullb = nullb;
+	token->sectors = bio->bi_iter.bi_size >> SECTOR_SHIFT;
+}
+
+static inline int nullb_setup_copy_write(struct nullb *nullb,
+		struct bio *bio, bool is_fua)
+{
+	struct nullb_copy_token *token = bvec_kmap_local(&bio->bi_io_vec[0]);
+	sector_t sector_in, sector_out;
+	void *in, *out;
+	size_t rem, temp;
+	unsigned long offset_in, offset_out;
+	struct nullb_page *t_page_in, *t_page_out;
+	int ret = -EIO;
+
+	if (unlikely(memcmp(token->subsys, "nullb", 5)))
+		return -EINVAL;
+	if (unlikely(token->nullb != nullb))
+		return -EINVAL;
+	if (WARN_ON(token->sectors != bio->bi_iter.bi_size >> SECTOR_SHIFT))
+		return -EINVAL;
+
+	sector_in = token->sector_in;
+	sector_out = bio->bi_iter.bi_sector;
+	rem = token->sectors << SECTOR_SHIFT;
+
+	spin_lock_irq(&nullb->lock);
+	while (rem > 0) {
+		temp = min_t(size_t, nullb->dev->blocksize, rem);
+		offset_in = (sector_in & SECTOR_MASK) << SECTOR_SHIFT;
+		offset_out = (sector_out & SECTOR_MASK) << SECTOR_SHIFT;
+
+		if (null_cache_active(nullb) && !is_fua)
+			null_make_cache_space(nullb, PAGE_SIZE);
+
+		t_page_in = null_lookup_page(nullb, sector_in, false,
+			!null_cache_active(nullb));
+		if (!t_page_in)
+			goto err;
+		t_page_out = null_insert_page(nullb, sector_out,
+			!null_cache_active(nullb) || is_fua);
+		if (!t_page_out)
+			goto err;
+
+		in = kmap_local_page(t_page_in->page);
+		out = kmap_local_page(t_page_out->page);
+
+		memcpy(out + offset_out, in + offset_in, temp);
+		kunmap_local(out);
+		kunmap_local(in);
+		__set_bit(sector_out & SECTOR_MASK, t_page_out->bitmap);
+
+		if (is_fua)
+			null_free_sector(nullb, sector_out, true);
+
+		rem -= temp;
+		sector_in += temp >> SECTOR_SHIFT;
+		sector_out += temp >> SECTOR_SHIFT;
+	}
+
+	ret = 0;
+err:
+	spin_unlock_irq(&nullb->lock);
+	return ret;
+}
+
 static int null_handle_rq(struct nullb_cmd *cmd)
 {
 	struct request *rq = cmd->rq;
@@ -1280,13 +1360,20 @@ static int null_handle_rq(struct nullb_cmd *cmd)
 	sector_t sector = blk_rq_pos(rq);
 	struct req_iterator iter;
 	struct bio_vec bvec;
+	bool fua = rq->cmd_flags & REQ_FUA;
+
+	if (rq->cmd_flags & REQ_COPY) {
+		if (op_is_write(req_op(rq)))
+			return nullb_setup_copy_write(nullb, rq->bio, fua);
+		nullb_setup_copy_read(nullb, rq->bio);
+		return 0;
+	}
 
 	spin_lock_irq(&nullb->lock);
 	rq_for_each_segment(bvec, rq, iter) {
 		len = bvec.bv_len;
 		err = null_transfer(nullb, bvec.bv_page, len, bvec.bv_offset,
-				     op_is_write(req_op(rq)), sector,
-				     rq->cmd_flags & REQ_FUA);
+				     op_is_write(req_op(rq)), sector, fua);
 		if (err) {
 			spin_unlock_irq(&nullb->lock);
 			return err;
@@ -1307,13 +1394,20 @@ static int null_handle_bio(struct nullb_cmd *cmd)
 	sector_t sector = bio->bi_iter.bi_sector;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
+	bool fua = bio->bi_opf & REQ_FUA;
+
+	if (bio->bi_opf & REQ_COPY) {
+		if (op_is_write(bio_op(bio)))
+			return nullb_setup_copy_write(nullb, bio, fua);
+		nullb_setup_copy_read(nullb, bio);
+		return 0;
+	}
 
 	spin_lock_irq(&nullb->lock);
 	bio_for_each_segment(bvec, bio, iter) {
 		len = bvec.bv_len;
 		err = null_transfer(nullb, bvec.bv_page, len, bvec.bv_offset,
-				     op_is_write(bio_op(bio)), sector,
-				     bio->bi_opf & REQ_FUA);
+				     op_is_write(bio_op(bio)), sector, fua);
 		if (err) {
 			spin_unlock_irq(&nullb->lock);
 			return err;
@@ -2157,6 +2251,10 @@ static int null_add_dev(struct nullb_device *dev)
 		dev->max_sectors = queue_max_hw_sectors(nullb->q);
 	dev->max_sectors = min(dev->max_sectors, BLK_DEF_MAX_SECTORS);
 	blk_queue_max_hw_sectors(nullb->q, dev->max_sectors);
+	blk_queue_max_copy_sectors_hw(nullb->q,
+			       dev->copy_max_bytes >> SECTOR_SHIFT);
+	if (dev->copy_max_bytes)
+		blk_queue_flag_set(QUEUE_FLAG_COPY, nullb->disk->queue);
 
 	if (dev->virt_boundary)
 		blk_queue_virt_boundary(nullb->q, PAGE_SIZE - 1);
diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
index 929f659dd255..3dda593b0747 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -67,6 +67,13 @@ enum {
 	NULL_Q_MQ	= 2,
 };
 
+struct nullb_copy_token {
+	char *subsys;
+	struct nullb *nullb;
+	sector_t sector_in;
+	sector_t sectors;
+};
+
 struct nullb_device {
 	struct nullb *nullb;
 	struct config_group group;
@@ -107,6 +114,7 @@ struct nullb_device {
 	unsigned int queue_mode; /* block interface */
 	unsigned int blocksize; /* block size */
 	unsigned int max_sectors; /* Max sectors per command */
+	unsigned long copy_max_bytes; /* Max copy offload length in bytes */
 	unsigned int irqmode; /* IRQ completion handler */
 	unsigned int hw_queue_depth; /* queue depth */
 	unsigned int index; /* index of the disk, only valid with a disk */
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

