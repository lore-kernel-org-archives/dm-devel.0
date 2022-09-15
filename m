Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A184C54EE9
	for <dm-devel@archiver.kernel.org>; Fri, 16 Sep 2022 08:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663317906;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hcT9EujoslrRLfYLTQapsrJAfx0ydx9bKtpkoXOr8IU=;
	b=EhLdM80BjqRhaqSHk2kLTXsVs1lAzhYXh7UaJmD/ER4ujBGDeV7wTRw1+Ij4/E5gIhZnVi
	tsZtuFUQbC+7/NHfym1JoKHSzvrjArqnOmuRf4kDcxEIM0zq+xQqN1UpaUrVsGK9to0ZMh
	5sFAVWUPiwtQTInp3xAFzOpEbAPl0Dw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-b4kR00ssMSCiWac8qs94EA-1; Fri, 16 Sep 2022 04:45:03 -0400
X-MC-Unique: b4kR00ssMSCiWac8qs94EA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3D3B1023115;
	Fri, 16 Sep 2022 08:45:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AECDD4A927F;
	Fri, 16 Sep 2022 08:45:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F20B81946A7F;
	Fri, 16 Sep 2022 08:44:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 480701946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Sep 2022 16:48:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 36E742166B29; Thu, 15 Sep 2022 16:48:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3303A2166B26
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 16:48:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14DD18027EA
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 16:48:59 +0000 (UTC)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-477-JWCsbcqnMCy1YMl3wZrfVg-1; Thu, 15 Sep 2022 12:48:54 -0400
X-MC-Unique: JWCsbcqnMCy1YMl3wZrfVg-1
Received: by mail-pj1-f49.google.com with SMTP id fs14so18342629pjb.5
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 09:48:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date;
 bh=GHq7dVGm2OOxGrPIxR4jW0JwHX2wEssn4Ks1aVeah78=;
 b=gRtmborTIfCxDd+fpjwzC3d25bnYcoAefnJV3GYGPubYzkKlfoH2VodpMWgPj7gbyV
 QRqpZ16g4l49yI4MwVQflkqf62A4QEdSB3u008EDodUvFwLa5R9ftQDwecBhrDKmQQVe
 FOvsq6hxwbDcuiDzQK7gwAv1clorEmVWNh2f9BudLmd+Z2DxGnPEEdFmWSazaLzpgvR/
 sROpwMZmpW+nddP+fSyOJL3ZSesFwZtvINguCl6wA+b3oY1NYg7crP7SNbqQzqFk+sjS
 0oonJt/EclV02LMYI56ua/9wGiEBT2SqYLWRcdvvKID1Z+jaU51NrKxrqNcKdwZpue0e
 dZwg==
X-Gm-Message-State: ACrzQf3/T3CguSzfhFq74KgN2VwAPIzvUgXhTKqHljTLdPRtDfd11tKD
 SSrSS+p/K0i3FlYp5LaKFlbhfy+jY4SbO3MK
X-Google-Smtp-Source: AMsMyM5ttUX80mK/xaqN8PnmPtACWbnNz3msqy9Npe8lr7jxLQP3tkGYZybEvxiT7s/KaSaMZVvSZQ==
X-Received: by 2002:a17:902:dac4:b0:178:3037:680a with SMTP id
 q4-20020a170902dac400b001783037680amr327417plx.37.1663260532933; 
 Thu, 15 Sep 2022 09:48:52 -0700 (PDT)
Received: from sarthakkukreti-glaptop.hsd1.ca.comcast.net
 ([2601:647:4200:b5b0:3af2:34b2:a98a:a652])
 by smtp.gmail.com with ESMTPSA id
 o4-20020a170902bcc400b00177ee563b6dsm13174970pls.33.2022.09.15.09.48.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 15 Sep 2022 09:48:52 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
X-Google-Original-From: Sarthak Kukreti <sarthakkukreti@google.com>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org
Date: Thu, 15 Sep 2022 09:48:24 -0700
Message-Id: <20220915164826.1396245-7-sarthakkukreti@google.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Fri, 16 Sep 2022 08:44:55 +0000
Subject: [dm-devel] [PATCH RFC 6/8] ext4: Add support for FALLOC_FL_PROVISION
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Sarthak Kukreti <sarthakkukreti@chromium.org>

Once ext4 is done mapping blocks for an fallocate() request, send
out an FALLOC_FL_PROVISION request to the underlying layer to
ensure that the space is provisioned for the newly allocated extent
or indirect blocks.

Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
---
 fs/ext4/ext4.h         |  2 ++
 fs/ext4/extents.c      | 15 ++++++++++++++-
 fs/ext4/indirect.c     |  9 +++++++++
 include/linux/blkdev.h | 11 +++++++++++
 4 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9bca5565547b..ec0871e687c1 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -675,6 +675,8 @@ enum {
 #define EXT4_GET_BLOCKS_IO_SUBMIT		0x0400
 	/* Caller is in the atomic contex, find extent if it has been cached */
 #define EXT4_GET_BLOCKS_CACHED_NOWAIT		0x0800
+	/* Provision blocks on underlying storage */
+#define EXT4_GET_BLOCKS_PROVISION		0x1000
 
 /*
  * The bit position of these flags must not overlap with any of the
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c148bb97b527..7a096144b7f8 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4356,6 +4356,13 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
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
@@ -4690,7 +4697,7 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	/* Return error if mode is not supported */
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
 		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
-		     FALLOC_FL_INSERT_RANGE))
+		     FALLOC_FL_INSERT_RANGE | FALLOC_FL_PROVISION))
 		return -EOPNOTSUPP;
 
 	inode_lock(inode);
@@ -4750,6 +4757,12 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
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
index 860fc5119009..860a2560872b 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -640,6 +640,15 @@ int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
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
index a58496d3f922..26b41a6c12f4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1107,6 +1107,17 @@ static inline int sb_issue_zeroout(struct super_block *sb, sector_t block,
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
2.31.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

