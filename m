Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31B64C4167B
	for <dm-devel@archiver.kernel.org>; Thu,  3 Nov 2022 07:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667462244;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ksfSYZidYAa22rb3vMGPS3MfOCCbBKwUPXQfaQNzkZY=;
	b=LQ1DzHoogc3ZQOKC0k4pXF5bv+3RdAKWbmsUxyAJKS9BS19JIASmI8MQhg7xo+c/UTyDdh
	tyLWkdNdyUX6pxonT3hd2sDlzvdVtW+1O0G5xaLNN7XmOjmsN4p1Ium3yKK8qoozXX13lx
	uYQ018v4J+k2DpVzAfZRImwl7VKRooU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-mfdpfW5tNbKmxZnmJJZ8kg-1; Thu, 03 Nov 2022 03:57:20 -0400
X-MC-Unique: mfdpfW5tNbKmxZnmJJZ8kg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2AF1138149AF;
	Thu,  3 Nov 2022 07:57:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 179CF4EA4C;
	Thu,  3 Nov 2022 07:57:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E3E1C1946A75;
	Thu,  3 Nov 2022 07:57:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B72811946594
 for <dm-devel@listman.corp.redhat.com>; Wed,  2 Nov 2022 20:10:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A5EE0C15BAB; Wed,  2 Nov 2022 20:10:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E7ADC15BA4
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 20:10:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8127E185A7A3
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 20:10:02 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-92EgIIQSPZuQZhSMepqaNQ-1; Wed, 02 Nov 2022 16:09:58 -0400
X-MC-Unique: 92EgIIQSPZuQZhSMepqaNQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id DFED161BDF;
 Wed,  2 Nov 2022 20:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1E7C433C1;
 Wed,  2 Nov 2022 20:09:57 +0000 (UTC)
Date: Wed, 2 Nov 2022 14:09:54 -0600
From: Keith Busch <kbusch@kernel.org>
To: Dmitrii Tcvetkov <me@demsh.org>
Message-ID: <Y2LOkmU0IJUTyYza@kbusch-mbp.dhcp.thefacebook.com>
References: <Y2Hf08vIKBkl5tu0@sol.localdomain>
 <Y2KEH6OZ0MDf5cSh@kbusch-mbp.dhcp.thefacebook.com>
 <Y2KXfNZzwPZBJRTW@kbusch-mbp.dhcp.thefacebook.com>
 <20221102200345.0800a8bf@xps.demsh.org>
MIME-Version: 1.0
In-Reply-To: <20221102200345.0800a8bf@xps.demsh.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Thu, 03 Nov 2022 07:57:17 +0000
Subject: Re: [dm-devel] Regression: wrong DIO alignment check with dm-crypt
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
Cc: Eric Biggers <ebiggers@kernel.org>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 02, 2022 at 08:03:45PM +0300, Dmitrii Tcvetkov wrote:
> 
> Applied on top 6.1-rc3, the issue still reproduces.

Yeah, I see that now. I needed to run a dm-crypt setup to figure out how
they're actually doing this, so now I have that up and running.

I think this type of usage will require the dma_alignment to move from
the request_queue to the queue_limits. Here's that, and I've
successfully tested this with cryptsetup. I still need more work to get
mdraid atop that working on my dev machine, but I'll post this now since
it's looking better:

---
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 8bb9eef5310e..e84304959318 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -81,6 +81,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->max_dev_sectors = UINT_MAX;
 	lim->max_write_zeroes_sectors = UINT_MAX;
 	lim->max_zone_append_sectors = UINT_MAX;
+	lim->dma_alignment = 511;
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
 
@@ -600,6 +601,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 
 	t->io_min = max(t->io_min, b->io_min);
 	t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
+	t->dma_alignment = max(t->dma_alignment, b->dma_alignment);
 
 	/* Set non-power-of-2 compatible chunk_sectors boundary */
 	if (b->chunk_sectors)
@@ -773,7 +775,7 @@ EXPORT_SYMBOL(blk_queue_virt_boundary);
  **/
 void blk_queue_dma_alignment(struct request_queue *q, int mask)
 {
-	q->dma_alignment = mask;
+	q->limits.dma_alignment = mask;
 }
 EXPORT_SYMBOL(blk_queue_dma_alignment);
 
@@ -795,8 +797,8 @@ void blk_queue_update_dma_alignment(struct request_queue *q, int mask)
 {
 	BUG_ON(mask > PAGE_SIZE);
 
-	if (mask > q->dma_alignment)
-		q->dma_alignment = mask;
+	if (mask > q->limits.dma_alignment)
+		q->limits.dma_alignment = mask;
 }
 EXPORT_SYMBOL(blk_queue_update_dma_alignment);
 
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 159c6806c19b..2653516bcdef 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3630,6 +3630,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	limits->physical_block_size =
 		max_t(unsigned, limits->physical_block_size, cc->sector_size);
 	limits->io_min = max_t(unsigned, limits->io_min, cc->sector_size);
+	limits->dma_alignment = limits->logical_block_size - 1;
 }
 
 static struct target_type crypt_target = {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 854b4745cdd1..69ee5ea29e2f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -310,6 +310,13 @@ struct queue_limits {
 	unsigned char		discard_misaligned;
 	unsigned char		raid_partial_stripes_expensive;
 	enum blk_zoned_model	zoned;
+
+	/*
+	 * Drivers that set dma_alignment to less than 511 must be prepared to
+	 * handle individual bvec's that are not a multiple of a SECTOR_SIZE
+	 * due to possible offsets.
+	 */
+	unsigned int		dma_alignment;
 };
 
 typedef int (*report_zones_cb)(struct blk_zone *zone, unsigned int idx,
@@ -455,12 +462,6 @@ struct request_queue {
 	unsigned long		nr_requests;	/* Max # of requests */
 
 	unsigned int		dma_pad_mask;
-	/*
-	 * Drivers that set dma_alignment to less than 511 must be prepared to
-	 * handle individual bvec's that are not a multiple of a SECTOR_SIZE
-	 * due to possible offsets.
-	 */
-	unsigned int		dma_alignment;
 
 #ifdef CONFIG_BLK_INLINE_ENCRYPTION
 	struct blk_crypto_profile *crypto_profile;
@@ -1318,7 +1319,7 @@ static inline sector_t bdev_zone_sectors(struct block_device *bdev)
 
 static inline int queue_dma_alignment(const struct request_queue *q)
 {
-	return q ? q->dma_alignment : 511;
+	return q ? q->limits.dma_alignment : 511;
 }
 
 static inline unsigned int bdev_dma_alignment(struct block_device *bdev)
--

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

