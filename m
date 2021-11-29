Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9460DC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 10:40:42 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-HYf-FH6VOOGz7ugi7Wu3BA-1; Mon, 29 Nov 2021 05:40:37 -0500
X-MC-Unique: HYf-FH6VOOGz7ugi7Wu3BA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2C901927800;
	Mon, 29 Nov 2021 10:40:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DC96150D3F;
	Mon, 29 Nov 2021 10:40:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B97FA1802FEA;
	Mon, 29 Nov 2021 10:40:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ATAeVIN014702 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 05:40:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 54CFA1402408; Mon, 29 Nov 2021 10:40:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FB3B1402406
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 10:40:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36098811E7A
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 10:40:31 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-376-i6DFEMojNkSFQsZ3OVcbZg-1; Mon, 29 Nov 2021 05:40:27 -0500
X-MC-Unique: i6DFEMojNkSFQsZ3OVcbZg-1
Received: from [2001:4bb8:184:4a23:724a:c057:c7bf:4643] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mrdnr-0073T8-He; Mon, 29 Nov 2021 10:22:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Nov 2021 11:21:54 +0100
Message-Id: <20211129102203.2243509-21-hch@lst.de>
In-Reply-To: <20211129102203.2243509-1-hch@lst.de>
References: <20211129102203.2243509-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Ira Weiny <ira.weiny@intel.com>
Subject: [dm-devel] [PATCH 20/29] ext4: cleanup the dax handling in
	ext4_fill_super
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Only call fs_dax_get_by_bdev once the sbi has been allocated and remove
the need for the dax_dev local variable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/ext4/super.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index fd3d68f10ee55..8d7e3449c6472 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3878,7 +3878,6 @@ static void ext4_setup_csum_trigger(struct super_block *sb,
 
 static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 {
-	struct dax_device *dax_dev = fs_dax_get_by_bdev(sb->s_bdev);
 	char *orig_data = kstrdup(data, GFP_KERNEL);
 	struct buffer_head *bh, **group_desc;
 	struct ext4_super_block *es = NULL;
@@ -3909,12 +3908,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if ((data && !orig_data) || !sbi)
 		goto out_free_base;
 
-	sbi->s_daxdev = dax_dev;
 	sbi->s_blockgroup_lock =
 		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
 	if (!sbi->s_blockgroup_lock)
 		goto out_free_base;
 
+	sbi->s_daxdev = fs_dax_get_by_bdev(sb->s_bdev);
 	sb->s_fs_info = sbi;
 	sbi->s_sb = sb;
 	sbi->s_inode_readahead_blks = EXT4_DEF_INODE_READAHEAD_BLKS;
@@ -4299,7 +4298,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
-	if (dax_dev) {
+	if (sbi->s_daxdev) {
 		if (blocksize == PAGE_SIZE)
 			set_bit(EXT4_FLAGS_BDEV_IS_DAX, &sbi->s_ext4_flags);
 		else
@@ -5095,10 +5094,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 out_fail:
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
+	fs_put_dax(sbi->s_daxdev);
 out_free_base:
 	kfree(sbi);
 	kfree(orig_data);
-	fs_put_dax(dax_dev);
 	return err ? err : ret;
 }
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

