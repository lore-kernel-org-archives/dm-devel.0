Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85D3EE94139
	for <dm-devel@archiver.kernel.org>; Sat,  7 Oct 2023 01:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696642126;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AaPMh4m6x27/LWAxttKwK4aO4v1YcZQBrbOGomkl1TY=;
	b=FIUeYuo+ap36I85gnkT2lccB4a7EqeKhnmQ5x74Cv/oU1TIDJmgJtKeiBMp7NH6VGZLMFx
	TAFkxfukqbtQdkgVFzXXd1swIkQtfUKOJkvX21oMB1Pmmm/mBsWsXDwGdmwCczSyI3SOoV
	IaVzuiN5gzCCNuShY8GssMY6engtbEM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-83-xT0njwcEOOWeMnUUGgXRKw-1; Fri, 06 Oct 2023 21:28:43 -0400
X-MC-Unique: xT0njwcEOOWeMnUUGgXRKw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85DFF8039CB;
	Sat,  7 Oct 2023 01:28:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7365FC15BB8;
	Sat,  7 Oct 2023 01:28:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3C2EE1946589;
	Sat,  7 Oct 2023 01:28:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 269E01946588
 for <dm-devel@listman.corp.redhat.com>; Sat,  7 Oct 2023 01:28:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 068882027046; Sat,  7 Oct 2023 01:28:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F29982027045
 for <dm-devel@redhat.com>; Sat,  7 Oct 2023 01:28:38 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D475C8007A4
 for <dm-devel@redhat.com>; Sat,  7 Oct 2023 01:28:38 +0000 (UTC)
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com
 [209.85.215.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-KzwEYFeNPfWpjEQir4W_8w-1; Fri, 06 Oct 2023 21:28:32 -0400
X-MC-Unique: KzwEYFeNPfWpjEQir4W_8w-1
Received: by mail-pg1-f182.google.com with SMTP id
 41be03b00d2f7-564af0ac494so1959853a12.0
 for <dm-devel@redhat.com>; Fri, 06 Oct 2023 18:28:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696642111; x=1697246911;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=qwbLxQP2MlVOvPJLqOZgvAlqQEss4gZRIzs/TWsm4fw=;
 b=JT4dvHELb6uHzxu8GSArPFUgi63unmxII/WUI+NBzd3N4eAcquWctrbY1oYKp2JqlO
 l5lIvIXtdnOY5To+nr34QfR6V9lkZgcC07oEK1YS02z75WYj2chTQtaq1YugH2Tz4d9u
 bVrU9dZa9xYVZyBhs1y8RGWOF84Q5ghSMFdQIw3AqWoqINDlahiw5Hfd5EtAiq1HQdQW
 Jz3yJKlUSFHWZ982hE2Md7WrDSl2m2J051tTHVESPEvH+Y5LTh+Y9UsyZ0Lxy5vl7A+C
 bJkwPLHxx2lP4xVNeQAELn+9XNE9GmPLoLhRUPm7BVljtpukQsbfxchUyqXtgCZgwTmE
 Xg9g==
X-Gm-Message-State: AOJu0Yzx/sKgHItSXp89WVZ9KUJFGLtzukF9KNHmxteDltLvTfMDDAsr
 jNia07Lg71esTzTOS1H3ApXH9fx4ufeRZq++7xA=
X-Google-Smtp-Source: AGHT+IF+irPpdEsFSzOYVv3XaMow6Yl8idZjKB2cup9iOgYxOd9Vuvg5EJUKwvZgFUUl2r+4ILiQzw==
X-Received: by 2002:a17:903:25c3:b0:1c5:76b6:d4f7 with SMTP id
 jc3-20020a17090325c300b001c576b6d4f7mr8553824plb.36.1696642110765; 
 Fri, 06 Oct 2023 18:28:30 -0700 (PDT)
Received: from localhost ([2620:15c:9d:2:138c:8976:eb4a:a91c])
 by smtp.gmail.com with UTF8SMTPSA id
 o18-20020a170902d4d200b001c73fb506aesm4524873plg.128.2023.10.06.18.28.29
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 06 Oct 2023 18:28:30 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Fri,  6 Oct 2023 18:28:15 -0700
Message-ID: <20231007012817.3052558-4-sarthakkukreti@chromium.org>
In-Reply-To: <20231007012817.3052558-1-sarthakkukreti@chromium.org>
References: <20231007012817.3052558-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v8 3/5] loop: Add support for provision requests
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
Cc: Jens Axboe <axboe@kernel.dk>, Dave Chinner <david@fromorbit.com>,
 Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>,
 Brian Foster <bfoster@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Sarthak Kukreti <sarthakkukreti@chromium.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add support for provision requests to loopback devices.
Loop devices will configure provision support based on
whether the underlying block device/file can support
the provision request and upon receiving a provision bio,
will map it to the backing device/storage. For loop devices
over files, a REQ_OP_PROVISION request will translate to
an fallocate mode 0 call on the backing file.

Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/block/loop.c | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 9f2d412fc560..abb4dddbd4fd 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -311,16 +311,20 @@ static int lo_fallocate(struct loop_device *lo, struct request *rq, loff_t pos,
 {
 	/*
 	 * We use fallocate to manipulate the space mappings used by the image
-	 * a.k.a. discard/zerorange.
+	 * a.k.a. discard/provision/zerorange.
 	 */
 	struct file *file = lo->lo_backing_file;
 	int ret;
 
-	mode |= FALLOC_FL_KEEP_SIZE;
+	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE) &&
+	    !bdev_max_discard_sectors(lo->lo_device))
+		return -EOPNOTSUPP;
 
-	if (!bdev_max_discard_sectors(lo->lo_device))
+	if (mode == 0 && !bdev_max_provision_sectors(lo->lo_device))
 		return -EOPNOTSUPP;
 
+	mode |= FALLOC_FL_KEEP_SIZE;
+
 	ret = file->f_op->fallocate(file, mode, pos, blk_rq_bytes(rq));
 	if (unlikely(ret && ret != -EINVAL && ret != -EOPNOTSUPP))
 		return -EIO;
@@ -488,6 +492,8 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 				FALLOC_FL_PUNCH_HOLE);
 	case REQ_OP_DISCARD:
 		return lo_fallocate(lo, rq, pos, FALLOC_FL_PUNCH_HOLE);
+	case REQ_OP_PROVISION:
+		return lo_fallocate(lo, rq, pos, 0);
 	case REQ_OP_WRITE:
 		if (cmd->use_aio)
 			return lo_rw_aio(lo, cmd, pos, ITER_SOURCE);
@@ -754,6 +760,25 @@ static void loop_sysfs_exit(struct loop_device *lo)
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
@@ -1092,6 +1117,7 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
 	blk_queue_io_min(lo->lo_queue, bsize);
 
 	loop_config_discard(lo);
+	loop_config_provision(lo);
 	loop_update_rotational(lo);
 	loop_update_dio(lo);
 	loop_sysfs_init(lo);
@@ -1304,6 +1330,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	}
 
 	loop_config_discard(lo);
+	loop_config_provision(lo);
 
 	/* update dio if lo_offset or transfer is changed */
 	__loop_update_dio(lo, lo->use_dio);
@@ -1857,6 +1884,7 @@ static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	case REQ_OP_FLUSH:
 	case REQ_OP_DISCARD:
 	case REQ_OP_WRITE_ZEROES:
+	case REQ_OP_PROVISION:
 		cmd->use_aio = false;
 		break;
 	default:
-- 
2.42.0.609.gbb76f46606-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

