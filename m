Return-Path: <SRS0=ANAI=JO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98C63C433B4
	for <dm-devel@archiver.kernel.org>; Sat, 17 Apr 2021 02:34:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2449561166
	for <dm-devel@archiver.kernel.org>; Sat, 17 Apr 2021 02:34:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2449561166
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-3f2uA7ooPdCnOFqrtrRf_A-1; Fri, 16 Apr 2021 22:33:58 -0400
X-MC-Unique: 3f2uA7ooPdCnOFqrtrRf_A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8598A8030A1;
	Sat, 17 Apr 2021 02:33:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 67BCE5D9C0;
	Sat, 17 Apr 2021 02:33:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3A49944A62;
	Sat, 17 Apr 2021 02:33:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13H2Xb09031297 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 22:33:37 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7B43A1054E49; Sat, 17 Apr 2021 02:33:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 763A61054E4A
	for <dm-devel@redhat.com>; Sat, 17 Apr 2021 02:33:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE3E2805F48
	for <dm-devel@redhat.com>; Sat, 17 Apr 2021 02:33:34 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-328-CWeY_4C-N6OjNDGhr8KkBw-2; Fri, 16 Apr 2021 22:33:32 -0400
X-MC-Unique: CWeY_4C-N6OjNDGhr8KkBw-2
IronPort-SDR: FosYsSUDzcxgMionuMboYd0pTiJfjrmVcVBBHOCiy4Xy1dbbCWdPAnmClUNd3w1fyjxSBOEx7g
	uC5KUFfw2J62L8K313yFNvT0aXficie0TC4gyGxPUbHzEr3M15ciH4CfLfG/UENh5mTUUHHpvf
	UdnplGsjo6BYkHahfUmU4nHK0KRCDMjEW+++W+l7+Q7eY5ITuLnwDPr/lTFghsJRkPnzP23q/3
	6qhaW1k+TSi64knXMtUO2ZDbR5pV9X9pMs5k6xoaSgiTGnPjtHsI69iG4E6JETDqo8CLCa0flY
	+Ic=
X-IronPort-AV: E=Sophos;i="5.82,228,1613404800"; d="scan'208";a="164553506"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 17 Apr 2021 10:33:32 +0800
IronPort-SDR: aoKvPZmPGrxi7v0tbaVNo9jdZvAJI+T+B8dbwfAHs2RRLc7RJeSPZf6oF5fN7nLR7pdiJq6tcN
	nBLtJarABcfuNyJJMAVtepQZUrJ98eocNoCUFXjA1jR9Rp+Dr6DxJxsDRCEDw20WSK45y8U4TG
	Q9+LbbwEUFexqWXU2JLJqaJSU7tiApXahxLfylpKJed5bZApUrH7jOi/TcuqeZr+6NdFKpavoh
	ka1T+k21xd5/YxeWqCki/brh0EbP4tEzaRXGaZj8jNeQt6Hs5zKWI6HeMptKuKL7jCJKmNOR7B
	R4xQxiJX4Z8RGZJEvHQeJg3Z
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	16 Apr 2021 19:14:20 -0700
IronPort-SDR: ffwDuNJdgpDyZs+F+I7hb5tSfdWh7H3NQY/F8KVBqjx1K+WoPrmksYPHiqq3maw5NfYpqZctE9
	gWv+C7z7BiidjMOBh+0BeZRwHA5xPSD1s6Kg3GUZiliiyyBB0i0Uv2nQz0774FLe8UiAoCUSqt
	e+5ZqS22Z3zk1jmc+G8LVLkZJk8bruBBF+amRb69DmiJ5Lq6G3GvG7tTV6S+KC5sTAewBEgA84
	hAnkDYwYNQCOL+1UEM6V12/EMZYtLQG3IrKQoLYYc5WTTO5MKtF+ZIu3Pf8XRj1vqGFTTgE1HH
	LWc=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip01.wdc.com with ESMTP; 16 Apr 2021 19:33:31 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org
Date: Sat, 17 Apr 2021 11:33:23 +0900
Message-Id: <20210417023323.852530-4-damien.lemoal@wdc.com>
In-Reply-To: <20210417023323.852530-1-damien.lemoal@wdc.com>
References: <20210417023323.852530-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [dm-devel] [PATCH v2 3/3] zonefs: fix synchronous write to
	sequential zone files
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

Fixes: 02ef12a663c7 ("zonefs: use REQ_OP_ZONE_APPEND for sync DIO")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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

