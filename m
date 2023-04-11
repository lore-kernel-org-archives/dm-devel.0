Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F9B7C77B79
	for <dm-devel@archiver.kernel.org>; Wed, 12 Apr 2023 06:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681281569;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Szks3f2vLOChXPLEzJYAsiAG4o6+3f/5aJ9j8ET+88w=;
	b=jF8he4mDDsQkedh5LGymglunuaXJGEJaE7FbeT6rIZ7QFAEV866OJGLU6Usd9/tXLLcQHu
	nY/GLMwcVIM3kHNvELOMY+jH8To0cjtmSGm/4G9ph7nzdMOCyWgioYtUgQaYLgDma1KjGN
	RQF+M1gWEG/aD1nbJDW8h4ihH6HCPR4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-vYZcg9vPMb2aHSR8zau79g-1; Wed, 12 Apr 2023 02:39:26 -0400
X-MC-Unique: vYZcg9vPMb2aHSR8zau79g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18141857FB9;
	Wed, 12 Apr 2023 06:39:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0425B202717E;
	Wed, 12 Apr 2023 06:39:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E481E19472E3;
	Wed, 12 Apr 2023 06:39:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B4B461946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Apr 2023 08:19:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 97AEB14171BF; Tue, 11 Apr 2023 08:19:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F88314171B7
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 08:19:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70AE8855318
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 08:19:58 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-nK05ip3vN12CAWBj4p2lHQ-1; Tue, 11 Apr 2023 04:19:55 -0400
X-MC-Unique: nK05ip3vN12CAWBj4p2lHQ-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20230411081952epoutp01378c8299b39cfd6bdccff86f707bd8e1~U05PL3BdL0717807178epoutp01y
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 08:19:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20230411081952epoutp01378c8299b39cfd6bdccff86f707bd8e1~U05PL3BdL0717807178epoutp01y
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20230411081952epcas5p13d0164cc4c6fc74079317057dbb8f959~U05OscMoq0228502285epcas5p1J;
 Tue, 11 Apr 2023 08:19:52 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4Pwf0647fBz4x9Pr; Tue, 11 Apr
 2023 08:19:50 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 43.9B.09961.62815346; Tue, 11 Apr 2023 17:19:50 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230411081400epcas5p151186138b36daf361520b08618300502~U00HSKMnJ1534615346epcas5p1-;
 Tue, 11 Apr 2023 08:14:00 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230411081400epsmtrp146444ac54d2b6b40e011a9ecd7a73d6a~U00HP9d9s1886118861epsmtrp1Y;
 Tue, 11 Apr 2023 08:14:00 +0000 (GMT)
X-AuditID: b6c32a49-2c1ff700000026e9-ab-643518266927
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 85.2F.08279.8C615346; Tue, 11 Apr 2023 17:14:00 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230411081356epsmtip2a79113ab5665be1b002625fbcee5446c~U00D5G5402416524165epsmtip2Y;
 Tue, 11 Apr 2023 08:13:56 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Date: Tue, 11 Apr 2023 13:40:36 +0530
Message-Id: <20230411081041.5328-10-anuj20.g@samsung.com>
In-Reply-To: <20230411081041.5328-1-anuj20.g@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTVxzHc+7tC5bOa9F4YJt2nQOLAdrR4oHwSmbmXViUTLYlbK7etTeF
 UNqmLehGFh4dojwFAxuVyUM35bHiChIEixsMBRwroaDIgpBYHpOnLKtuSFxLYfO/z/d3vt/z
 O+d3cjg4r4Ltx0lWG2idmlIJWN6Mth7hviB/KFWInJd2o+aBWzjKObuOo8aJEhaa71kFqGLl
 bxytDdpwNHUzBlmXzjPR/Z+uY+hGXRmG6ht7MdRZ+xhDvc8XWais+y5A06MmDFnH96Mb1n4G
 sndUsVD199Ns1H3OiKF2RzZAbWvVODLPLzNQ3/gr6GHBaYBs67eZsX6kfSSONE0Ossjrpgk2
 aXvwI4O0D6aRloYzLLLlUibZeT+LRRYZl1yG3Ekmudw1yiKLWxsA2XIng/zTspu0OBax+G2J
 KZFJNKWgdXxaLdcoktXKKEHcUdnbMmmYSBwkDkcHBHw1lUpHCQ6+Fx/0TrLKNRABP51SpblK
 8ZReLwiJjtRp0gw0P0mjN0QJaK1CpZVog/VUqj5NrQxW04YIsUj0ltRlPJ6S9NTsq22OOGlb
 WmJmgTxxPuBwICGBU1XKfODN4RGdAPY09WEesQrg5a+fgXzg5RJOAIeW+VuB8WyZx2MFsMl5
 jekRRgyO2Wdxd4BFBMBfZnOBe2EHcQqHj6fPMNwCJ5pwOLWytrGtDxEN7zbksN3MIN6ED62V
 G2kuEQ7Nl2fZnnYhsGRyu7vs5So/+/Y0y2PZDvsrHQw348QeaLx2HnfvD4lmL2gdKHAJtksc
 hKZItwUSPvDR7Va2h/3gHyWnNlkJn9qnMQ9rofFWF/BwDMwdKMHdJ8AJIWzuCPGUX4PlA2bM
 0/VlWLTm2IxyYfuFLRbAvPqqTYbQ+lvWJpNw7tf2zVkVAnix8wH7LOCbXriN6YXbmP5vXQPw
 BuBLa/WpSlov1YrV9In/XliuSbWAjQ8S+G47mJhaCe4GGAd0A8jBBTu4fz0PVfC4CurzL2id
 RqZLU9H6biB1TbsU99sp17h+mNogE0vCRZKwsDBJeGiYWLCLGxDVL+cRSspAp9C0ltZt5TCO
 l18WFkAJwTxciD0x71zv0AXRPHlN3ZGdKHNE6ftN3OG5J63lDREc8+sJ8uCamSHK8Zl4m2kw
 9upYsdOxq/CCP1/0e3PtVczBmX/jJfzLOxE/rHqVNh5O/0Sc+F15QiSltTGiPpjrevWY//CH
 9OLxEXq4LEHR32tpqT1Ut/yx5GRFYPhXe73juQf22Hmj769Lbl7M6Esqym4XF+d+FF0yZFmw
 5lV1Fe4LbmsaHPlUnxEaU70qHSuFlZlC5yH+vSUwc8555cpk42j1wnrlUVmZ2rzWNjxXaOy3
 /zwpnKnfm2jrqDt7jDmrKkjZ/0/XE++YUYnPvUfm9OqiI53C9CBeTlwsS8DQJ1HiQFynp/4F
 EBl72KkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Re0hTYRjG+845Ox5X1tmM+qZhMYtISxsWfN3sip0ospsRktjQk1lujR1N
 LcjZuuhWuSys1sIVq3CG0rznpjaztLKVZpRd7KKJ2exqWmbmSYL+e/j9Hh5eeClcfJ/woeKV
 iaxaKU+QkkKitFY6eVb9hLmxs3vNElR45xaODhgGcZT/IotE3bVfAMr59ANHA40uHL2qXowc
 PecE6GlNBYbsF7MxlJdfh6HKC58xVDfkJlG28zFAHS1GDDlaA5Hd0UCg5usmEuVe7vBAzpNa
 DJW3pwNUOpCLo4LujwSqb/VFb/UZALkGbwuW+DDNj1YzxrZGkqkwvvBgXC+vEUxzYxJjs2aS
 TJEljal8qiGZY9qe4cKhNgHzsaqFZI4XWwFTdHcf89Xmx9ja3di6cZHChbFsQvweVh0cuk24
 o79Aoiqcn+Lq6RFowBGZDlAUpOfA1vRoHRBSYroSwKGSPg8d8BzmEN7pugxGsjfM+93pMVJK
 x2BfRy/GC5KeDm92HgK8GE8bcNjUpiF5gdN2HOaZl/LZmw6Fj60H/q4S9DT41nEW57MXPQ8W
 XOFX+SuCYVabiMeew/jX+QySx2IaQYudGGmLYMPZdmJkfTLUlpzDDYA2/qeM/ykzwKxAwqo4
 RZyCk6lkSjY5iJMruCRlXFDMboUN/H15wIxyUGb9FOQEGAWcAFK4dLxX71BIrNgrVp66l1Xv
 jlYnJbCcE/hShHSi1wNdQ7SYjpMnsrtYVsWq/1mM8vTRYEXFdaHPw0HOfq06O9Mt6k9JqF8V
 1QjDfbve9cHaUeVdFdy0kgWv1dPx1aqFz/z199yhhmxFxnrFWl1u2kHL7Qfbk7+79cr+ljGq
 gWLzoinajBXCDWlhY6MMd8MOc7VR1nhN2JVEOqc+5sw7SVbA0Z/Bz/JF/mW+ET9TR4tuCru/
 9JqqTHLqjUX0QR939US65VtVvN9KSbXAvHHFVf/AglOZL8c1Zaru+W2qSQWXroV0w0d2WdOy
 pSURhcmFi0/uDOlkAiO8XyWelqSsnDol+knH2BuTMNMH2xpqv2BQeTiylXwYc0m/td/QEhkw
 Mxy9Vym3OEzLSddmvClmn6iyQkpwO+SyAFzNyf8ANvLyWGEDAAA=
X-CMS-MailID: 20230411081400epcas5p151186138b36daf361520b08618300502
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230411081400epcas5p151186138b36daf361520b08618300502
References: <20230411081041.5328-1-anuj20.g@samsung.com>
 <CGME20230411081400epcas5p151186138b36daf361520b08618300502@epcas5p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Wed, 12 Apr 2023 06:39:18 +0000
Subject: [dm-devel] [PATCH v9 9/9] null_blk: add support for copy offload
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nitesh Shetty <nj.shetty@samsung.com>

Implementaion is based on existing read and write infrastructure.
copy_max_bytes: A new configfs and module parameter is introduced, which
can be used to set hardware/driver supported maximum copy limit.

Suggested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 drivers/block/null_blk/main.c     | 101 ++++++++++++++++++++++++++++++
 drivers/block/null_blk/null_blk.h |   8 +++
 2 files changed, 109 insertions(+)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index bc2c58724df3..e273e18ace74 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -157,6 +157,10 @@ static int g_max_sectors;
 module_param_named(max_sectors, g_max_sectors, int, 0444);
 MODULE_PARM_DESC(max_sectors, "Maximum size of a command (in 512B sectors)");
 
+static int g_copy_max_bytes = COPY_MAX_BYTES;
+module_param_named(copy_max_bytes, g_copy_max_bytes, int, 0444);
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
@@ -631,6 +637,7 @@ static ssize_t memb_group_features_show(struct config_item *item, char *page)
 			"badblocks,blocking,blocksize,cache_size,"
 			"completion_nsec,discard,home_node,hw_queue_depth,"
 			"irqmode,max_sectors,mbps,memory_backed,no_sched,"
+			"copy_max_bytes,"
 			"poll_queues,power,queue_mode,shared_tag_bitmap,size,"
 			"submit_queues,use_per_node_hctx,virt_boundary,zoned,"
 			"zone_capacity,zone_max_active,zone_max_open,"
@@ -693,6 +700,7 @@ static struct nullb_device *null_alloc_dev(void)
 	dev->queue_mode = g_queue_mode;
 	dev->blocksize = g_bs;
 	dev->max_sectors = g_max_sectors;
+	dev->copy_max_bytes = g_copy_max_bytes;
 	dev->irqmode = g_irqmode;
 	dev->hw_queue_depth = g_hw_queue_depth;
 	dev->blocking = g_blocking;
@@ -1242,6 +1250,81 @@ static int null_transfer(struct nullb *nullb, struct page *page,
 	return err;
 }
 
+static inline int nullb_setup_copy_read(struct nullb *nullb,
+		struct bio *bio)
+{
+	struct nullb_copy_token *token = bvec_kmap_local(&bio->bi_io_vec[0]);
+
+	memcpy(token->subsys, "nullb", 5);
+	token->sector_in = bio->bi_iter.bi_sector;
+	token->nullb = nullb;
+	token->sectors = bio->bi_iter.bi_size >> SECTOR_SHIFT;
+
+	return 0;
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
@@ -1252,6 +1335,13 @@ static int null_handle_rq(struct nullb_cmd *cmd)
 	struct req_iterator iter;
 	struct bio_vec bvec;
 
+	if (rq->cmd_flags & REQ_COPY) {
+		if (op_is_write(req_op(rq)))
+			return nullb_setup_copy_write(nullb, rq->bio,
+						rq->cmd_flags & REQ_FUA);
+		return nullb_setup_copy_read(nullb, rq->bio);
+	}
+
 	spin_lock_irq(&nullb->lock);
 	rq_for_each_segment(bvec, rq, iter) {
 		len = bvec.bv_len;
@@ -1279,6 +1369,13 @@ static int null_handle_bio(struct nullb_cmd *cmd)
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 
+	if (bio->bi_opf & REQ_COPY) {
+		if (op_is_write(bio_op(bio)))
+			return nullb_setup_copy_write(nullb, bio,
+							bio->bi_opf & REQ_FUA);
+		return nullb_setup_copy_read(nullb, bio);
+	}
+
 	spin_lock_irq(&nullb->lock);
 	bio_for_each_segment(bvec, bio, iter) {
 		len = bvec.bv_len;
@@ -2109,6 +2206,10 @@ static int null_add_dev(struct nullb_device *dev)
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
index eb5972c50be8..c67c098d92fa 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -67,6 +67,13 @@ enum {
 	NULL_Q_MQ	= 2,
 };
 
+struct nullb_copy_token {
+	char subsys[5];
+	struct nullb *nullb;
+	u64 sector_in;
+	u64 sectors;
+};
+
 struct nullb_device {
 	struct nullb *nullb;
 	struct config_item item;
@@ -102,6 +109,7 @@ struct nullb_device {
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

