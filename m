Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE195C77B7C
	for <dm-devel@archiver.kernel.org>; Wed, 19 Apr 2023 03:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681876550;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8CznyCZWs4+Bh/IOyxX3j+1DrdIR+X8C9AVTc56MaMU=;
	b=FrJOSGfm+TdaHfa+OtCdZHzAuMQnRzauLxZWkBs061dEZpk3w9/EVcH7pC5+4AtC8TCi6b
	Fj3AlTmiNrnOaN1CXSags5R1B4gighLL+VMPbnSIBRM2KRC9PN0yv0AAHRxyWCCTEOfryS
	WHTYo667iCBpWwI+SSx04AZc6gwXgIQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403-w7yK2cc4ONWWPm0h5SiwzQ-1; Tue, 18 Apr 2023 23:55:47 -0400
X-MC-Unique: w7yK2cc4ONWWPm0h5SiwzQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABAFE3806735;
	Wed, 19 Apr 2023 03:55:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2A2071410F21;
	Wed, 19 Apr 2023 03:55:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9A0521946A51;
	Wed, 19 Apr 2023 03:55:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 17529194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Apr 2023 22:12:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EE98C4292DD; Tue, 18 Apr 2023 22:12:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E7315492C3E
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 22:12:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7667299E762
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 22:12:39 +0000 (UTC)
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com
 [209.85.214.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-pOcT03wfPQKAw1n5KXe6iQ-1; Tue, 18 Apr 2023 18:12:36 -0400
X-MC-Unique: pOcT03wfPQKAw1n5KXe6iQ-1
Received: by mail-pl1-f169.google.com with SMTP id
 d9443c01a7336-1a6762fd23cso21481895ad.3
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 15:12:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681855955; x=1684447955;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=DJ+yGPB/3GoY7peOyZ+CblNlWIiKQ+IujQrkD9HaThI=;
 b=Bc2PZ+gnMjI+XWatK+cLnaHLtOgY7mMjeafOwt8eoWtV2G68ZD/PSprXqIh2xeybrk
 KD2jrKbC6CL3W6jBP1NniuJSG1ZUKBgTeQXRGq7TpELvmxXpVRZ2NNZjDuAc1z6BRi7g
 M7jyriqt+ORAHG0o/7s1hnYb43/Z9dMpSr+4WVCfqPhht9juFv1Rbh047elPjhiOF7aL
 ck4bhdjFgkC8C3cDuQnOgT8XpuiMKL2u44Ov9GefFazV45niAX5W4SY/AzrMboosoNce
 jCaK3nhP+kzBeWi8WxxDitRbN2aVi6ujUI8JPxs2btYjukM33WuA3v+O9/uU3VFF0K1g
 9K7Q==
X-Gm-Message-State: AAQBX9eA6/kbVtk+9DUbdsDY9oxoPBexUYVBe79fQwSTQZWV68jGvJYu
 dGBacLX/2zRmG/RwtYh9RMdVSI04mjPVXGumaFs=
X-Google-Smtp-Source: AKy350bdGW8lcpNwvg5/Io7seNtW+tP5EWMmhIyDjAkmWhtkJNkd0WaYZiBs0G+Q7zXofrJZlCjQtg==
X-Received: by 2002:a17:903:11cc:b0:1a6:4541:73c with SMTP id
 q12-20020a17090311cc00b001a64541073cmr3738421plh.33.1681855955208; 
 Tue, 18 Apr 2023 15:12:35 -0700 (PDT)
Received: from sarthakkukreti-glaptop.corp.google.com
 ([2620:15c:9d:200:e38b:ca5e:3203:48d3])
 by smtp.gmail.com with ESMTPSA id
 x1-20020a1709029a4100b001a687c505e9sm9911892plv.237.2023.04.18.15.12.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 18 Apr 2023 15:12:34 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Tue, 18 Apr 2023 15:12:07 -0700
Message-ID: <20230418221207.244685-5-sarthakkukreti@chromium.org>
In-Reply-To: <20230418221207.244685-1-sarthakkukreti@chromium.org>
References: <20230414000219.92640-1-sarthakkukreti@chromium.org>
 <20230418221207.244685-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Wed, 19 Apr 2023 03:55:32 +0000
Subject: [dm-devel] [PATCH v4 4/4] loop: Add support for provision requests
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
Cc: Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>,
 "Michael S. Tsirkin" <mst@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
---
 drivers/block/loop.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index bc31bb7072a2..13c4b4f8b9c1 100644
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
+	ret = file->f_op->fallocate(file, 0, pos, blk_rq_bytes(rq));
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
 			return lo_rw_aio(lo, cmd, pos, ITER_SOURCE);
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
@@ -1830,6 +1871,7 @@ static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	case REQ_OP_FLUSH:
 	case REQ_OP_DISCARD:
 	case REQ_OP_WRITE_ZEROES:
+	case REQ_OP_PROVISION:
 		cmd->use_aio = false;
 		break;
 	default:
-- 
2.40.0.634.g4ca3ef3211-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

