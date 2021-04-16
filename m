Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA1BC43460
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 03:07:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B4C52611AB
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 03:07:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4C52611AB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-BETqKYHOPGmjPVfTRbMSCw-1; Thu, 15 Apr 2021 23:07:08 -0400
X-MC-Unique: BETqKYHOPGmjPVfTRbMSCw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 156D1801597;
	Fri, 16 Apr 2021 03:07:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EF6FB6E403;
	Fri, 16 Apr 2021 03:07:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BE3E344A5F;
	Fri, 16 Apr 2021 03:07:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13G372eD030721 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 15 Apr 2021 23:07:02 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E40E420CA24E; Fri, 16 Apr 2021 03:07:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DE70620AE85D
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 03:06:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6520100DE78
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 03:06:54 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-335-cv9JnA6NPEKadt-dos_WmQ-1; Thu, 15 Apr 2021 23:06:52 -0400
X-MC-Unique: cv9JnA6NPEKadt-dos_WmQ-1
IronPort-SDR: oewOfnxa10OvJ2s8ES16JKHCX51b9Q/g0o0ALu//4HcT5lyfgeo220KEZ+dAPys3HlqpXi2OHu
	k1TiaToJJENrONO6BemIPPc4XE2zIqQP7NreBnYZJLPBguiX9sN+EH8bQipxf0OZQ9PNge/FgI
	MlfPHly+ynsn2ofTZPelBMQpSVA0eZ9V3yIveUHSRUtUuSsc47yxTmSHIoRgbIhYLBAKCPNjy3
	ISS6ZnxqDZlRoWV4uzhu2yL4NDMKtSHwypwtFcoPe4uZ4lYGM0vzoM1QnbhwVxd+cFnahCsna0
	wEM=
X-IronPort-AV: E=Sophos;i="5.82,226,1613404800"; d="scan'208";a="269048687"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 16 Apr 2021 11:06:30 +0800
IronPort-SDR: XfE8Wqaj3vwgngI/epvO81whqLfQSIs+jsG/jYdgTqJEFf2cXKR/F+ZC47JtpGoKCwKRrgxyvC
	qO/zr1t65xl4YezACI662bcQjZU/RRt8HtC6H24qo7jy70mSEcYwfp3Ev082s1bkoLVLFuZSs5
	drtMP650ylAASwXhh1QHQvjts+zPuJOWImdsz+lAncdjLlkv5ba2o7cEanH8yRFhJR4Hsqr73l
	BfC8PZ9va5f+FWTuLcn2mIHjvogkmiQzME7LmUFyx/MTqJIoNwOiboe8xFC8DfUlQDK8G8yeAJ
	M4fXU5pWdUoAxijPvomrfZi3
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	15 Apr 2021 19:46:35 -0700
IronPort-SDR: u5Gc1810z5GreDYJpvaZDBd+bkB81RNJhYok8IDgPhe6JYgYj4b/4/fYIpyX1cNfJVEHlvUAnA
	MvOAeuVc8FBQZXEYMRwsr7AEl4o9EH4ZWc0IZfF4PcbzBOhhh0kx5kXMSJLHk9aqaOUbscvFQO
	cnR+SMMtVcof5L8EjlIR/eC/8XN0d4vx2Lzk9Lhsnt21cd/URva91ybcVwFbQqbeHdz6R/7aav
	OkHZyDzHZ5SnIdccJAHt+KUB7t7KMxH5k97pMJAwdRTYfFo0Amj59jJpiDg1hrSqHsfS+f5qTA
	0pc=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 15 Apr 2021 20:05:40 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>
Date: Fri, 16 Apr 2021 12:05:28 +0900
Message-Id: <20210416030528.757513-5-damien.lemoal@wdc.com>
In-Reply-To: <20210416030528.757513-1-damien.lemoal@wdc.com>
References: <20210416030528.757513-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: [dm-devel] [PATCH 4/4] zonefs: fix synchronous write to sequential
	zone files
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

Synchronous writes to sequential zone files cannot use zone append
operations if the underlying zoned device queue limit
max_zone_append_sectors is 0, indicating that the device does not
support this operation. In this case, fall back to using regular write
operations.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 fs/zonefs/super.c  | 16 ++++++++++++----
 fs/zonefs/zonefs.h |  2 ++
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 049e36c69ed7..b97566b9dff7 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -689,14 +689,15 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
-	struct block_device *bdev = inode->i_sb->s_bdev;
-	unsigned int max;
+	struct super_block *sb = inode->i_sb;
+	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
+	struct block_device *bdev = sb->s_bdev;
+	sector_t max = sbi->s_max_zone_append_sectors;
 	struct bio *bio;
 	ssize_t size;
 	int nr_pages;
 	ssize_t ret;
 
-	max = queue_max_zone_append_sectors(bdev_get_queue(bdev));
 	max = ALIGN_DOWN(max << SECTOR_SHIFT, inode->i_sb->s_blocksize);
 	iov_iter_truncate(from, max);
 
@@ -853,6 +854,8 @@ static ssize_t zonefs_file_dio_write(struct kiocb *iocb, struct iov_iter *from)
 
 	/* Enforce sequential writes (append only) in sequential zones */
 	if (zi->i_ztype == ZONEFS_ZTYPE_SEQ) {
+		struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
+
 		mutex_lock(&zi->i_truncate_mutex);
 		if (iocb->ki_pos != zi->i_wpoffset) {
 			mutex_unlock(&zi->i_truncate_mutex);
@@ -860,7 +863,7 @@ static ssize_t zonefs_file_dio_write(struct kiocb *iocb, struct iov_iter *from)
 			goto inode_unlock;
 		}
 		mutex_unlock(&zi->i_truncate_mutex);
-		append = sync;
+		append = sync && sbi->s_max_zone_append_sectors;
 	}
 
 	if (append)
@@ -1683,6 +1686,11 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
 		sbi->s_mount_opts &= ~ZONEFS_MNTOPT_EXPLICIT_OPEN;
 	}
 
+	sbi->s_max_zone_append_sectors =
+		queue_max_zone_append_sectors(bdev_get_queue(sb->s_bdev));
+	if (!sbi->s_max_zone_append_sectors)
+		zonefs_info(sb, "Zone append is not supported: falling back to using regular writes\n");
+
 	ret = zonefs_read_super(sb);
 	if (ret)
 		return ret;
diff --git a/fs/zonefs/zonefs.h b/fs/zonefs/zonefs.h
index 51141907097c..2b8c3b1a32ea 100644
--- a/fs/zonefs/zonefs.h
+++ b/fs/zonefs/zonefs.h
@@ -185,6 +185,8 @@ struct zonefs_sb_info {
 
 	unsigned int		s_max_open_zones;
 	atomic_t		s_open_zones;
+
+	sector_t		s_max_zone_append_sectors;
 };
 
 static inline struct zonefs_sb_info *ZONEFS_SB(struct super_block *sb)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

