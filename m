Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41F2FC4167B
	for <dm-devel@archiver.kernel.org>; Mon,  2 Jan 2023 07:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672645443;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sNc0c/PPcNrHYYD+7FLguvXZXwZCodbMpjMrvmURhQk=;
	b=GG2PxcOgYsBTTVHLwY3qvvh+y2boe3ucE9sYNGyALCx5XO6ykDx0V4XalHClQAkPPHZNgy
	5AvCpRiD2r82Vc4bX7GTmzoR1m7x0gPsQvod/QcdgHGgem0K04Q6vLl1i9f2Tcwvl8+P4N
	Zy9peznvjDi1kDhg6aGWruTn9frKimU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-NzmMI5-BMdyEAT4epDMAxA-1; Mon, 02 Jan 2023 02:43:07 -0500
X-MC-Unique: NzmMI5-BMdyEAT4epDMAxA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB2A72803D60;
	Mon,  2 Jan 2023 07:43:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A9F7F2026D4B;
	Mon,  2 Jan 2023 07:43:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 843641946A78;
	Mon,  2 Jan 2023 07:43:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DEF651946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 29 Dec 2022 08:13:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 93967492B01; Thu, 29 Dec 2022 08:13:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CB39492B00
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 08:13:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7335787B2A0
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 08:13:15 +0000 (UTC)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
 [209.85.214.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-656-RUS2aqdVOlOBHD6Vk6DSyg-2; Thu, 29 Dec 2022 03:13:13 -0500
X-MC-Unique: RUS2aqdVOlOBHD6Vk6DSyg-2
Received: by mail-pl1-f171.google.com with SMTP id 17so18342140pll.0
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 00:13:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=Vv5x1KdmMeVtIhlp3zKOKF7sZVF7KRZLRJQbPD3QKT4=;
 b=L3S/nCsicgxO4HIEdWZiQIGXXq1K6TXvEIiG/mrcuzrn3i+kzmCnluDOwgnAsAero1
 fFSWK9zKobjJ1xY9s66GrDuIQ4kNMJOm7YLk7yZunvIRgGtrpJIoI/QufZx9W89mGNQK
 AdwDjVjQYKOo+E77tr++Mg3LC22hAFIslogAVBbyWTo/vjRCf2URegBfKmFsQkR8PabN
 bxxXZdgH/R8FN3vB/7GHd3rUyVS/847QHI7yMvhhzfPMi5J4CY+sP2IOHlhfTVrmEPi0
 zBvYfahjK2dnBzGLwaqayLftSPD4yliWqWnMYyy9IEt8r1kPixFjMeNCHdYAZB6eHkju
 oZng==
X-Gm-Message-State: AFqh2kp2MaB11pRt5ECJXGG6LqATTKmBPrGdWDtQmGblwIptRBo+s/JV
 na6hp3sx3UfQdeRvKPo51bjGmA==
X-Google-Smtp-Source: AMrXdXvrTl4SO8Hr42En8z77cNqZKNC6eJ1qGCmNwbui5VQ51uN9dxzll3B3KUp7znSacUHIozLKhA==
X-Received: by 2002:a17:902:a70c:b0:189:dcc3:e4a1 with SMTP id
 w12-20020a170902a70c00b00189dcc3e4a1mr28589601plq.9.1672301592863; 
 Thu, 29 Dec 2022 00:13:12 -0800 (PST)
Received: from sarthakkukreti-glaptop.hsd1.ca.comcast.net
 ([2601:647:4200:b5b0:75ff:1277:3d7b:d67a])
 by smtp.gmail.com with ESMTPSA id
 12-20020a170902e9cc00b00192820d00d0sm6496325plk.120.2022.12.29.00.13.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 29 Dec 2022 00:13:12 -0800 (PST)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: sarthakkukreti@google.com, dm-devel@redhat.com,
 linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Thu, 29 Dec 2022 00:12:51 -0800
Message-Id: <20221229081252.452240-7-sarthakkukreti@chromium.org>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Mon, 02 Jan 2023 07:42:59 +0000
Subject: [dm-devel] [PATCH v2 6/7] ext4: Add mount option for provisioning
 blocks during allocations
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add a mount option that sets the default provisioning mode for
all files within the filesystem.

Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
---
 fs/ext4/ext4.h    | 1 +
 fs/ext4/extents.c | 7 +++++++
 fs/ext4/super.c   | 7 +++++++
 3 files changed, 15 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 49832e90b62f..29cab2e2ea20 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1269,6 +1269,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT2_MB_OPTIMIZE_SCAN	0x00000080 /* Optimize group
 						    * scanning in mballoc
 						    */
+#define EXT4_MOUNT2_PROVISION		0x00000100 /* Provision while allocating file blocks */
 
 #define clear_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt &= \
 						~EXT4_MOUNT_##opt
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 2e64a9211792..a73f44264fe2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4441,6 +4441,13 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
 	unsigned int credits;
 	loff_t epos;
 
+	/*
+	 * Attempt to provision file blocks if the mount is mounted with
+	 * provision.
+	 */
+	if (test_opt2(inode->i_sb, PROVISION))
+		flags |= EXT4_GET_BLOCKS_PROVISION;
+
 	BUG_ON(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
 	map.m_lblk = offset;
 	map.m_len = len;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 260c1b3e3ef2..5bc376f6a6f0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1591,6 +1591,7 @@ enum {
 	Opt_max_dir_size_kb, Opt_nojournal_checksum, Opt_nombcache,
 	Opt_no_prefetch_block_bitmaps, Opt_mb_optimize_scan,
 	Opt_errors, Opt_data, Opt_data_err, Opt_jqfmt, Opt_dax_type,
+	Opt_provision, Opt_noprovision,
 #ifdef CONFIG_EXT4_DEBUG
 	Opt_fc_debug_max_replay, Opt_fc_debug_force
 #endif
@@ -1737,6 +1738,8 @@ static const struct fs_parameter_spec ext4_param_specs[] = {
 	fsparam_flag	("reservation",		Opt_removed),	/* mount option from ext2/3 */
 	fsparam_flag	("noreservation",	Opt_removed),	/* mount option from ext2/3 */
 	fsparam_u32	("journal",		Opt_removed),	/* mount option from ext2/3 */
+	fsparam_flag	("provision",		Opt_provision),
+	fsparam_flag	("noprovision",		Opt_noprovision),
 	{}
 };
 
@@ -1826,6 +1829,8 @@ static const struct mount_opts {
 	{Opt_nombcache, EXT4_MOUNT_NO_MBCACHE, MOPT_SET},
 	{Opt_no_prefetch_block_bitmaps, EXT4_MOUNT_NO_PREFETCH_BLOCK_BITMAPS,
 	 MOPT_SET},
+	{Opt_provision, EXT4_MOUNT2_PROVISION, MOPT_SET | MOPT_2},
+	{Opt_noprovision, EXT4_MOUNT2_PROVISION, MOPT_CLEAR | MOPT_2},
 #ifdef CONFIG_EXT4_DEBUG
 	{Opt_fc_debug_force, EXT4_MOUNT2_JOURNAL_FAST_COMMIT,
 	 MOPT_SET | MOPT_2 | MOPT_EXT4_ONLY},
@@ -2977,6 +2982,8 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
 		SEQ_OPTS_PUTS("dax=never");
 	} else if (test_opt2(sb, DAX_INODE)) {
 		SEQ_OPTS_PUTS("dax=inode");
+	} else if (test_opt2(sb, PROVISION)) {
+		SEQ_OPTS_PUTS("provision");
 	}
 
 	if (sbi->s_groups_count >= MB_DEFAULT_LINEAR_SCAN_THRESHOLD &&
-- 
2.37.3

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

