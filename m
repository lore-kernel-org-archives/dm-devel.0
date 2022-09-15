Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3C80C6FA92
	for <dm-devel@archiver.kernel.org>; Fri, 16 Sep 2022 08:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663317905;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nRQ6LNe1WdmpRmqDbLtx3P09Qn7Pbxxnd+GO/zmulDk=;
	b=B4UNJYjLKlJ1sVU14suCSQDzxJiSXIaj3GNgPq7V5XkSvTW/sLjP8UH0yrKqnBBChZyz3u
	z1EuWslWLErmYlFQ8v6g9gpZGi6lsxll9ss3wR5BxTcS8GOj8ZxxtrMgvHuHS5EDpAcVIg
	SxaxmGJ01+ddDbLYBPsCUNTUOD3M2Es=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-313-6mQNpe7CNP263UXtX877Yw-1; Fri, 16 Sep 2022 04:45:02 -0400
X-MC-Unique: 6mQNpe7CNP263UXtX877Yw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6AFBB3C106A5;
	Fri, 16 Sep 2022 08:44:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 56272492B05;
	Fri, 16 Sep 2022 08:44:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A8B93194704D;
	Fri, 16 Sep 2022 08:44:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E4DD51946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Sep 2022 16:48:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CC52617595; Thu, 15 Sep 2022 16:48:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C8B0E10EB8
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 16:48:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B163E801231
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 16:48:53 +0000 (UTC)
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com
 [209.85.214.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-398-9gRp6AmNOhCIRDHw-s2byg-1; Thu, 15 Sep 2022 12:48:52 -0400
X-MC-Unique: 9gRp6AmNOhCIRDHw-s2byg-1
Received: by mail-pl1-f177.google.com with SMTP id s18so12957528plr.4
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 09:48:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date;
 bh=Ez356cXmd+P7nHsJjjr+e0UneH5b2Is7vVwjmIs0dPs=;
 b=kKTrY7OjUqhghnnNviogJgV263RFP5PPcQ7vT7ursP7b6IPkIheF6GgpFWRZY0890P
 vcRkDcqCU4N+aKE7gQUQbNG3KOrI2Hb9i2Qc+kFCqNkKJ6j546LYbMr5DDs9/NOeBxUR
 vV9FVQ65oN9hW8bb4uTmsB6607PBbgAFCPnCPBWmFBrLEza6m/1JM4KHhEL7r2edD134
 oq3UqRmoaz5meNGXc0oKoVuRRJq85o5C+w95TlTJbVeF/CV5d8ut0OKIj8N7JF6XNi4z
 jrAAK83vngdQpmqbT2ABJuGjhyaUr150b761bswwsJ1+at+T/76MiDjnUJl29jNvenZa
 0OgQ==
X-Gm-Message-State: ACrzQf22TB12NFB9LNFmf7NYifLOkvYNW911HVf1FxMFJSTJYCk9m1vN
 e3EV1EcI7jTR5KiBZYr553zIYlcl8GqgVA==
X-Google-Smtp-Source: AMsMyM6TOx0VvMscZBFt6MT5oz7OIxc3H7dIKcJ55IvOLIdBAuHhmlUHl0xBUb5jKhe4p8X37LYvkw==
X-Received: by 2002:a17:902:c106:b0:178:8cb:2762 with SMTP id
 6-20020a170902c10600b0017808cb2762mr482863pli.58.1663260530537; 
 Thu, 15 Sep 2022 09:48:50 -0700 (PDT)
Received: from sarthakkukreti-glaptop.hsd1.ca.comcast.net
 ([2601:647:4200:b5b0:3af2:34b2:a98a:a652])
 by smtp.gmail.com with ESMTPSA id
 o4-20020a170902bcc400b00177ee563b6dsm13174970pls.33.2022.09.15.09.48.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 15 Sep 2022 09:48:49 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
X-Google-Original-From: Sarthak Kukreti <sarthakkukreti@google.com>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org
Date: Thu, 15 Sep 2022 09:48:23 -0700
Message-Id: <20220915164826.1396245-6-sarthakkukreti@google.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Fri, 16 Sep 2022 08:44:55 +0000
Subject: [dm-devel] [PATCH RFC 5/8] loop: Add support for provision requests
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Sarthak Kukreti <sarthakkukreti@chromium.org>

Add support for provision requests to loopback devices.
Loop devices will configure provision support based on
whether the underlying block device/file can support
the provision request and upon receiving a provision bio,
will map it to the backing device/storage.

Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
---
 drivers/block/loop.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index ad92192c7d61..83f486b9bceb 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -327,6 +327,24 @@ static int lo_fallocate(struct loop_device *lo, struct request *rq, loff_t pos,
 	return ret;
 }
 
+static int lo_req_provision(struct loop_device *lo, struct request *rq, loff_t pos)
+{
+	struct file *file = lo->lo_backing_file;
+	struct request_queue *q = lo->lo_queue;
+	int ret;
+
+	if (!q->limits.max_provision_sectors) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	ret = file->f_op->fallocate(file, FALLOC_FL_PROVISION, pos, blk_rq_bytes(rq));
+	if (unlikely(ret && ret != -EINVAL && ret != -EOPNOTSUPP))
+		ret = -EIO;
+ out:
+	return ret;
+}
+
 static int lo_req_flush(struct loop_device *lo, struct request *rq)
 {
 	int ret = vfs_fsync(lo->lo_backing_file, 0);
@@ -488,6 +506,8 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 				FALLOC_FL_PUNCH_HOLE);
 	case REQ_OP_DISCARD:
 		return lo_fallocate(lo, rq, pos, FALLOC_FL_PUNCH_HOLE);
+	case REQ_OP_PROVISION:
+		return lo_req_provision(lo, rq, pos);
 	case REQ_OP_WRITE:
 		if (cmd->use_aio)
 			return lo_rw_aio(lo, cmd, pos, WRITE);
@@ -754,6 +774,25 @@ static void loop_sysfs_exit(struct loop_device *lo)
 				   &loop_attribute_group);
 }
 
+static void loop_config_provision(struct loop_device *lo)
+{
+	struct file *file = lo->lo_backing_file;
+	struct inode *inode = file->f_mapping->host;
+
+	/*
+	 * If the backing device is a block device, mirror its provisioning
+	 * capability.
+	 */
+	if (S_ISBLK(inode->i_mode)) {
+		blk_queue_max_provision_sectors(lo->lo_queue,
+			bdev_max_provision_sectors(I_BDEV(inode)));
+	} else if (file->f_op->fallocate) {
+		blk_queue_max_provision_sectors(lo->lo_queue, UINT_MAX >> 9);
+	} else {
+		blk_queue_max_provision_sectors(lo->lo_queue, 0);
+	}
+}
+
 static void loop_config_discard(struct loop_device *lo)
 {
 	struct file *file = lo->lo_backing_file;
@@ -1092,6 +1131,7 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 	blk_queue_io_min(lo->lo_queue, bsize);
 
 	loop_config_discard(lo);
+	loop_config_provision(lo);
 	loop_update_rotational(lo);
 	loop_update_dio(lo);
 	loop_sysfs_init(lo);
@@ -1304,6 +1344,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	}
 
 	loop_config_discard(lo);
+	loop_config_provision(lo);
 
 	/* update dio if lo_offset or transfer is changed */
 	__loop_update_dio(lo, lo->use_dio);
@@ -1815,6 +1856,7 @@ static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	case REQ_OP_FLUSH:
 	case REQ_OP_DISCARD:
 	case REQ_OP_WRITE_ZEROES:
+	case REQ_OP_PROVISION:
 		cmd->use_aio = false;
 		break;
 	default:
-- 
2.31.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

