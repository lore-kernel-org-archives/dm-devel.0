Return-Path: <SRS0=X4js=PG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F13C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 10:12:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2A2A660E54
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 10:12:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2A2A660E54
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-9b1ZW941Pi6lf_ygfVVgfA-1; Mon, 18 Oct 2021 06:12:45 -0400
X-MC-Unique: 9b1ZW941Pi6lf_ygfVVgfA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37A7E1023F4D;
	Mon, 18 Oct 2021 10:12:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D24B60CC4;
	Mon, 18 Oct 2021 10:12:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DB2594EA40;
	Mon, 18 Oct 2021 10:12:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19IACc0M032529 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 18 Oct 2021 06:12:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DD19A40D1B9E; Mon, 18 Oct 2021 10:12:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D941A40D1B9D
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 10:12:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1CD81066558
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 10:12:38 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-170-EocPMO8TNZiItIpC_6n3tA-1; Mon, 18 Oct 2021 06:12:37 -0400
X-MC-Unique: EocPMO8TNZiItIpC_6n3tA-1
Received: from [2001:4bb8:199:73c5:c70:4a89:bc61:2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mcPd2-00EuYY-1w; Mon, 18 Oct 2021 10:12:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 18 Oct 2021 12:11:19 +0200
Message-Id: <20211018101130.1838532-20-hch@lst.de>
In-Reply-To: <20211018101130.1838532-1-hch@lst.de>
References: <20211018101130.1838532-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	target-devel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	drbd-dev@lists.linbit.com, linux-nilfs@vger.kernel.org,
	linux-scsi@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	linux-ext4@vger.kernel.org, Kees Cook <keescook@chromium.org>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
	David Sterba <dsterba@suse.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Anton Altaparmakov <anton@tuxera.com>,
	linux-block@vger.kernel.org, linux-nfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ntfs-dev@lists.sourceforge.net, Jan Kara <jack@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Phillip Lougher <phillip@squashfs.org.uk>, ntfs3@lists.linux.dev,
	linux-btrfs@vger.kernel.org
Subject: [dm-devel] [PATCH 19/30] nilfs2: use bdev_nr_bytes instead of open
	coding it
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use the proper helper to read the block device size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
---
 fs/nilfs2/ioctl.c     | 2 +-
 fs/nilfs2/super.c     | 2 +-
 fs/nilfs2/the_nilfs.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 640ac8fe891e6..1d0583cfd9701 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -1107,7 +1107,7 @@ static int nilfs_ioctl_set_alloc_range(struct inode *inode, void __user *argp)
 		goto out;
 
 	ret = -ERANGE;
-	if (range[1] > i_size_read(inode->i_sb->s_bdev->bd_inode))
+	if (range[1] > bdev_nr_bytes(inode->i_sb->s_bdev))
 		goto out;
 
 	segbytes = nilfs->ns_blocks_per_segment * nilfs->ns_blocksize;
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index f6b2d280aab5a..3134c0e42fd46 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -403,7 +403,7 @@ int nilfs_resize_fs(struct super_block *sb, __u64 newsize)
 	int ret;
 
 	ret = -ERANGE;
-	devsize = i_size_read(sb->s_bdev->bd_inode);
+	devsize = bdev_nr_bytes(sb->s_bdev);
 	if (newsize > devsize)
 		goto out;
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index c8bfc01da5d71..1bfcb5d3ea480 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -489,7 +489,7 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
 {
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
 	struct buffer_head **sbh = nilfs->ns_sbh;
-	u64 sb2off = NILFS_SB2_OFFSET_BYTES(nilfs->ns_bdev->bd_inode->i_size);
+	u64 sb2off = NILFS_SB2_OFFSET_BYTES(bdev_nr_bytes(nilfs->ns_bdev));
 	int valid[2], swp = 0;
 
 	sbp[0] = nilfs_read_super_block(sb, NILFS_SB_OFFSET_BYTES, blocksize,
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

