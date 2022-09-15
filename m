Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B8BCC6FA8B
	for <dm-devel@archiver.kernel.org>; Fri, 16 Sep 2022 08:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663317901;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zDb9oFIIL63ihVhKqNsyop306xdQguoboxfcw0aHwyM=;
	b=IB8A1+ir4GNxLoSNvnvRIG8FXDQHzkmIhQld/SVW4STZYw7GOVYxFW0kNZqdl29v+XWCbd
	TdliHEGCcfvK5pcjTjg4/t/N0OgNgp6oBYdI8jxC9h7Y2YZRNcJC/DihnUwdyJ2hRqml6+
	jvXLUrXmEHjNIlvw10d0Cpf3o0T0AXs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-60-Wqx1GNuGP7KZuxQOx27Xzg-1; Fri, 16 Sep 2022 04:45:00 -0400
X-MC-Unique: Wqx1GNuGP7KZuxQOx27Xzg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2762802C16;
	Fri, 16 Sep 2022 08:44:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D1B0D40C6EC2;
	Fri, 16 Sep 2022 08:44:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5FB621946A72;
	Fri, 16 Sep 2022 08:44:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 81ACF1946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Sep 2022 16:48:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 545FC207B34B; Thu, 15 Sep 2022 16:48:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 50829207B34A
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 16:48:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 363FF38041C1
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 16:48:48 +0000 (UTC)
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com
 [209.85.215.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-614-CBPtrcdBNGSl2iMmqffh-A-1; Thu, 15 Sep 2022 12:48:46 -0400
X-MC-Unique: CBPtrcdBNGSl2iMmqffh-A-1
Received: by mail-pg1-f172.google.com with SMTP id g4so17877770pgc.0
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 09:48:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date;
 bh=8dGdE7yXwxpNJrtc0jzeOng2rxu8z4FK39IlQ5rLaw4=;
 b=6CPddsiuqLSqHkmU6M1y3oB0yMfXD4se90ItLKT+9k/JHqvCna9rG0RorJdC8mxuRE
 6ImwZH7VZinjQc2w8SFcj2NfpIR2NTKIPXkrz6WbDiimn72dyYGVerBsKc1Em3CY1n9h
 eoZcsaPqR3S2HgLfMXBO0MGm5FzPtzCMlWHg4MJcKGPJPm9qBp79NcRdM5auEjk+puzK
 S8Ow4T7G3G7QgFNcLgy3tKCDpxukoXF8F62YRQSbkbsWt/dw2OzRU9+9QGa/cNBNzvit
 zCZY1+RcUSsU4unSitB7dY++Y0JEfPC9l4QuSV/vauz5Ji+P7fvW0WOrDvKTfTsedMjT
 UVSg==
X-Gm-Message-State: ACrzQf2rlbFKC9YALtAPE8AM2ydfcMAwBIvbX0EZSwgLMn9nSkDPZNEo
 xhZ8OGpehUUJFBXqAX35twvRasncs9pCtQ==
X-Google-Smtp-Source: AMsMyM4ZjbUOIq/Q41w/OvvKUkmXpRr0bP+C56mI+0JSOF5eLhseKC9OgxfT03jMUgCb5sBQJ9O12g==
X-Received: by 2002:a63:1d25:0:b0:437:ec38:bd0e with SMTP id
 d37-20020a631d25000000b00437ec38bd0emr675973pgd.478.1663260525220; 
 Thu, 15 Sep 2022 09:48:45 -0700 (PDT)
Received: from sarthakkukreti-glaptop.hsd1.ca.comcast.net
 ([2601:647:4200:b5b0:3af2:34b2:a98a:a652])
 by smtp.gmail.com with ESMTPSA id
 o4-20020a170902bcc400b00177ee563b6dsm13174970pls.33.2022.09.15.09.48.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 15 Sep 2022 09:48:44 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
X-Google-Original-From: Sarthak Kukreti <sarthakkukreti@google.com>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org
Date: Thu, 15 Sep 2022 09:48:21 -0700
Message-Id: <20220915164826.1396245-4-sarthakkukreti@google.com>
In-Reply-To: <20220915164826.1396245-1-sarthakkukreti@google.com>
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Fri, 16 Sep 2022 08:44:55 +0000
Subject: [dm-devel] [PATCH RFC 3/8] virtio_blk: Add support for provision
 requests
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
Cc: Jens Axboe <axboe@kernel.dk>, Gwendal Grignou <gwendal@google.com>,
 Theodore Ts'o <tytso@mit.edu>, Sarthak Kukreti <sarthakkukreti@chromium.org>,
 "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Mike Snitzer <snitzer@kernel.org>,
 Evan Green <evgreen@google.com>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Daniil Lunev <dlunev@google.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Sarthak Kukreti <sarthakkukreti@chromium.org>

Adds support for provision requests. Provision requests act like
the inverse of discards.

Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
---
 drivers/block/virtio_blk.c      | 48 +++++++++++++++++++++++++++++++++
 include/uapi/linux/virtio_blk.h |  9 +++++++
 2 files changed, 57 insertions(+)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 30255fcaf181..eacc2bffe1d1 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -178,6 +178,39 @@ static int virtblk_setup_discard_write_zeroes(struct request *req, bool unmap)
 	return 0;
 }
 
+static int virtblk_setup_provision(struct request *req)
+{
+	unsigned short segments = blk_rq_nr_discard_segments(req);
+	unsigned short n = 0;
+
+	struct virtio_blk_discard_write_zeroes *range;
+	struct bio *bio;
+	u32 flags = 0;
+
+	range = kmalloc_array(segments, sizeof(*range), GFP_ATOMIC);
+	if (!range)
+		return -ENOMEM;
+
+	__rq_for_each_bio(bio, req) {
+		u64 sector = bio->bi_iter.bi_sector;
+		u32 num_sectors = bio->bi_iter.bi_size >> SECTOR_SHIFT;
+
+		range[n].flags = cpu_to_le32(flags);
+		range[n].num_sectors = cpu_to_le32(num_sectors);
+		range[n].sector = cpu_to_le64(sector);
+		n++;
+	}
+
+	WARN_ON_ONCE(n != segments);
+
+	req->special_vec.bv_page = virt_to_page(range);
+	req->special_vec.bv_offset = offset_in_page(range);
+	req->special_vec.bv_len = sizeof(*range) * segments;
+	req->rq_flags |= RQF_SPECIAL_PAYLOAD;
+
+	return 0;
+}
+
 static void virtblk_unmap_data(struct request *req, struct virtblk_req *vbr)
 {
 	if (blk_rq_nr_phys_segments(req))
@@ -243,6 +276,9 @@ static blk_status_t virtblk_setup_cmd(struct virtio_device *vdev,
 	case REQ_OP_DRV_IN:
 		type = VIRTIO_BLK_T_GET_ID;
 		break;
+	case REQ_OP_PROVISION:
+		type = VIRTIO_BLK_T_PROVISION;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		return BLK_STS_IOERR;
@@ -256,6 +292,11 @@ static blk_status_t virtblk_setup_cmd(struct virtio_device *vdev,
 			return BLK_STS_RESOURCE;
 	}
 
+	if (type == VIRTIO_BLK_T_PROVISION) {
+		if (virtblk_setup_provision(req))
+			return BLK_STS_RESOURCE;
+	}
+
 	return 0;
 }
 
@@ -1075,6 +1116,12 @@ static int virtblk_probe(struct virtio_device *vdev)
 		blk_queue_max_write_zeroes_sectors(q, v ? v : UINT_MAX);
 	}
 
+	if (virtio_has_feature(vdev, VIRTIO_BLK_F_PROVISION)) {
+		virtio_cread(vdev, struct virtio_blk_config,
+			     max_provision_sectors, &v);
+		q->limits.max_provision_sectors = v ? v : UINT_MAX;
+	}
+
 	virtblk_update_capacity(vblk, false);
 	virtio_device_ready(vdev);
 
@@ -1177,6 +1224,7 @@ static unsigned int features[] = {
 	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
 	VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_CONFIG_WCE,
 	VIRTIO_BLK_F_MQ, VIRTIO_BLK_F_DISCARD, VIRTIO_BLK_F_WRITE_ZEROES,
+	VIRTIO_BLK_F_PROVISION,
 };
 
 static struct virtio_driver virtio_blk = {
diff --git a/include/uapi/linux/virtio_blk.h b/include/uapi/linux/virtio_blk.h
index d888f013d9ff..184f8cf6d185 100644
--- a/include/uapi/linux/virtio_blk.h
+++ b/include/uapi/linux/virtio_blk.h
@@ -40,6 +40,7 @@
 #define VIRTIO_BLK_F_MQ		12	/* support more than one vq */
 #define VIRTIO_BLK_F_DISCARD	13	/* DISCARD is supported */
 #define VIRTIO_BLK_F_WRITE_ZEROES	14	/* WRITE ZEROES is supported */
+#define VIRTIO_BLK_F_PROVISION	15	/* provision is supported */
 
 /* Legacy feature bits */
 #ifndef VIRTIO_BLK_NO_LEGACY
@@ -120,6 +121,11 @@ struct virtio_blk_config {
 	 */
 	__u8 write_zeroes_may_unmap;
 
+	/*
+	 * The maximum number of sectors in a provision request.
+	 */
+	__virtio32 max_provision_sectors;
+
 	__u8 unused1[3];
 } __attribute__((packed));
 
@@ -155,6 +161,9 @@ struct virtio_blk_config {
 /* Write zeroes command */
 #define VIRTIO_BLK_T_WRITE_ZEROES	13
 
+/* Provision command */
+#define VIRTIO_BLK_T_PROVISION	14
+
 #ifndef VIRTIO_BLK_NO_LEGACY
 /* Barrier before this op. */
 #define VIRTIO_BLK_T_BARRIER	0x80000000
-- 
2.31.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

