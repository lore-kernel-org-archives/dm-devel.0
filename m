Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0C76C54EBE
	for <dm-devel@archiver.kernel.org>; Mon,  2 Jan 2023 07:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672645390;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=e7utoMc1El8bnGJviSv1+u1ZM7UfGodhptFAGTWkS4Y=;
	b=FhUzgozsH/zCMTzWQaU6m0ZB49UNIPOk4KAU87SsgluhawB/E7cY3Sj1K8W3RWxKorTMu5
	dTigZYaNb0WHhM2tt70CjIT+lQRpBiVa0Ard5b3Q4rca2xFqCU7BfEaA/XjRlO3xIhJvB0
	9/7LuFBWce6RIo4GCg6s0+NDGNgJPbk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-8Yan887EPXut0obUcp2Org-1; Mon, 02 Jan 2023 02:43:07 -0500
X-MC-Unique: 8Yan887EPXut0obUcp2Org-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 215C32A5957A;
	Mon,  2 Jan 2023 07:43:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D8170C1602A;
	Mon,  2 Jan 2023 07:43:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9577719465B7;
	Mon,  2 Jan 2023 07:43:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A9EB51946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 29 Dec 2022 08:13:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9114D112132D; Thu, 29 Dec 2022 08:13:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 89CCF112132C
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 08:13:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 650941C06911
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 08:13:13 +0000 (UTC)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-65-uEzai3L9P0iaU-DvR_jIEw-4; Thu, 29 Dec 2022 03:13:11 -0500
X-MC-Unique: uEzai3L9P0iaU-DvR_jIEw-4
Received: by mail-pl1-f174.google.com with SMTP id n4so18307670plp.1
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 00:13:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=tknTAYGKiWbOelfCTGAIM4O7q8g3LJuucBsJtaWsm7Y=;
 b=2n330jkQVMgTFcQ2UdFNICvE/JN1CfcM8y9m0D0ulkP5Lo/RlVBXxFjryc2jkIzy9h
 nNtT7wTqxI0Xdg1PTl9I/bcd5ZBDyZVRGGh3xswcF0OBZwVvOfmpPkWJ4SLHrrLIggcY
 /SQWcoqDUdMIJMuVSniWQ49gymw/azBInNnQk08SHoZj3JE/v12d//hozYfTf0rZxzwz
 VTocJ/I9f0F4jezZ1yACBiO62URhO5Y7nlX+SbtJIzuUrGf2aXIGnRBILIER0eawCtWF
 7KS81PY7320FV33xSmyA1tRZA7q2GWQ9uyw+YtZGBwzk1XySINpwXjTZ2y7BoVv4KmYA
 utuQ==
X-Gm-Message-State: AFqh2krP7w0xIF01KLy2WrKqIIebaxLSRiJPRN7aRyaR8zgsHZbpyifY
 6nsqUtUTnyOKbPF8mSaqVG60VA==
X-Google-Smtp-Source: AMrXdXtym0rxjHIaY1zQhiKiElSe51N0oXHJB0JFxm27wv3KTRxbF3edYhG2fNv1/xvRbhTy3gkDbA==
X-Received: by 2002:a17:902:c94f:b0:189:9e91:762e with SMTP id
 i15-20020a170902c94f00b001899e91762emr45014676pla.57.1672301590739; 
 Thu, 29 Dec 2022 00:13:10 -0800 (PST)
Received: from sarthakkukreti-glaptop.hsd1.ca.comcast.net
 ([2601:647:4200:b5b0:75ff:1277:3d7b:d67a])
 by smtp.gmail.com with ESMTPSA id
 12-20020a170902e9cc00b00192820d00d0sm6496325plk.120.2022.12.29.00.13.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 29 Dec 2022 00:13:10 -0800 (PST)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: sarthakkukreti@google.com, dm-devel@redhat.com,
 linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Thu, 29 Dec 2022 00:12:50 -0800
Message-Id: <20221229081252.452240-6-sarthakkukreti@chromium.org>
In-Reply-To: <20221229081252.452240-1-sarthakkukreti@chromium.org>
References: <20221229081252.452240-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Mon, 02 Jan 2023 07:42:59 +0000
Subject: [dm-devel] [PATCH v2 5/7] ext4: Add support for FALLOC_FL_PROVISION
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Once ext4 is done mapping blocks for an fallocate() request, send
out an FALLOC_FL_PROVISION request to the underlying layer to
ensure that the space is provisioned for the newly allocated extent
or indirect blocks.

There is an expected performance degradation with fallocate() calls made
with this flag due to the extra REQ_OP_PROVISIONs sent to the underlying
storage.

Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
---
 fs/ext4/ext4.h         |  2 ++
 fs/ext4/extents.c      | 15 ++++++++++++++-
 fs/ext4/indirect.c     |  9 +++++++++
 include/linux/blkdev.h | 11 +++++++++++
 4 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 140e1eb300d1..49832e90b62f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -673,6 +673,8 @@ enum {
 #define EXT4_GET_BLOCKS_IO_SUBMIT		0x0400
 	/* Caller is in the atomic contex, find extent if it has been cached */
 #define EXT4_GET_BLOCKS_CACHED_NOWAIT		0x0800
+	/* Provision blocks on underlying storage */
+#define EXT4_GET_BLOCKS_PROVISION		0x1000
 
 /*
  * The bit position of these flags must not overlap with any of the
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9de1c9d1a13d..2e64a9211792 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4361,6 +4361,13 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 		}
 	}
 
+	/* Attempt to provision blocks on underlying storage */
+	if (flags & EXT4_GET_BLOCKS_PROVISION) {
+		err = sb_issue_provision(inode->i_sb, pblk, ar.len, GFP_NOFS);
+		if (err)
+			goto out;
+	}
+
 	/*
 	 * Cache the extent and update transaction to commit on fdatasync only
 	 * when it is _not_ an unwritten extent.
@@ -4694,7 +4701,7 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	/* Return error if mode is not supported */
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
 		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
-		     FALLOC_FL_INSERT_RANGE))
+		     FALLOC_FL_INSERT_RANGE | FALLOC_FL_PROVISION))
 		return -EOPNOTSUPP;
 
 	inode_lock(inode);
@@ -4754,6 +4761,12 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (ret)
 		goto out;
 
+	/* Ensure that preallocation provisions the blocks on the underlying
+	 * storage device.
+	 */
+	if (mode & FALLOC_FL_PROVISION)
+		flags |= EXT4_GET_BLOCKS_PROVISION;
+
 	ret = ext4_alloc_file_blocks(file, lblk, max_blocks, new_size, flags);
 	if (ret)
 		goto out;
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index c68bebe7ff4b..a8065aae7563 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -647,6 +647,15 @@ int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 	if (err)
 		goto cleanup;
 
+	/* Attempt to provision blocks on underlying storage */
+	if (flags & EXT4_GET_BLOCKS_PROVISION) {
+		err = sb_issue_provision(inode->i_sb,
+					 le32_to_cpu(chain[depth-1].key),
+					 ar.len, GFP_NOFS);
+		if (err)
+			goto out;
+	}
+
 	map->m_flags |= EXT4_MAP_NEW;
 
 	ext4_update_inode_fsync_trans(handle, inode, 1);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f1abc7b43e25..b2e3244e9f3d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1093,6 +1093,17 @@ static inline int sb_issue_zeroout(struct super_block *sb, sector_t block,
 				    gfp_mask, 0);
 }
 
+static inline int sb_issue_provision(struct super_block *sb, sector_t block,
+		sector_t nr_blocks, gfp_t gfp_mask)
+{
+	return blkdev_issue_provision(sb->s_bdev,
+				      block << (sb->s_blocksize_bits -
+					      SECTOR_SHIFT),
+				      nr_blocks << (sb->s_blocksize_bits -
+						    SECTOR_SHIFT),
+				      gfp_mask);
+}
+
 static inline bool bdev_is_partition(struct block_device *bdev)
 {
 	return bdev->bd_partno;
-- 
2.37.3

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

