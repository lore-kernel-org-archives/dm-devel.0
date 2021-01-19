Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C15CC433E0
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:10:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ED1B722573
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:10:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED1B722573
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-vsSCzPn5O-aMz1A3ehM9aA-1; Tue, 19 Jan 2021 00:10:49 -0500
X-MC-Unique: vsSCzPn5O-aMz1A3ehM9aA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06C2B8018A1;
	Tue, 19 Jan 2021 05:10:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D8E5E10013BD;
	Tue, 19 Jan 2021 05:10:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AFB7E5002E;
	Tue, 19 Jan 2021 05:10:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J5Agiq021488 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:10:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 914B84411D; Tue, 19 Jan 2021 05:10:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C1C06D9EB
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:10:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 783F8101A53F
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:10:42 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-594-iF-831dpO4igBkupju2aVA-1; Tue, 19 Jan 2021 00:10:35 -0500
X-MC-Unique: iF-831dpO4igBkupju2aVA-1
IronPort-SDR: imccesmc2Sd7NFlzVhepxMiaPW/MyPoyPT5E88iUt6Ks6fVVBmkQS/d+WlsYphTRN9Vkv/HHQZ
	o5TAnrTUmMO5zMyJEeLiG07o4oMEfgngGRQKuiIEh+PzDjLD4esNAIkmtF7DUlrIvkWBr2Y34W
	ltaEsTtmGdoc0o72cyyHyyULgiUSPnQDg09ooC7r57foQQyYczKCOoc54bcQtPqs/mUETtgvSJ
	su+CkW5BySNX3KEtDqS/TG3fWC0ZnODPPAzZYlHK+YfEwRJiop7wKya11ZbXnUOnnLXENlgGGQ
	PT0=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="162201291"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:10:34 +0800
IronPort-SDR: qVT1B/xtHRz2DjV5fgpHSHQ+uiKpvFgAQ1lA7OZJvnwHpivg2HqVOMKFU2rx5MmlFGAXp+0Olm
	i2Ct439rXttOBBoa8W4CbeQrX1ojz8jE+LIVnGYhmHZxtP61Xm3m4eOeS3m4rMeTGMfLYUT7BH
	ENYL/9u+P1RO0/7ZKfWodnvKAQ7HKFSVU82jLTu1sIkeGY+BLUETY9S9Jk5+Zl+r4jwOojevRK
	1SHO82NIfMwnWVGni276qjqi30if/rM+p/6bsf6m5wBzMTFP5pVF3JecdUiAtYnqNfspuhmSQF
	06yKelSe9fBpMUX4Z9lL95Rz
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:53:09 -0800
IronPort-SDR: To60I5qpFjC/qrOYyP0e+8PtEHWn/E+IX3B/NtCL2AEGlknL6XuDdu2+0YOMCEUl9jN0+NDuzq
	dZBtHVmFs8c2MbBK6nyyqiUGvL7D/ICacqAETpUNh7sNU3jN3gr3oMEn5okCkDfyC/0Irc2Fc4
	74E8Jj0L1yozehCSNmdf8CdFJegKv/E3LC+h6Fa4Hmz/L2OxthixlGPQheihc6U0PL3qEeNS+1
	hIM5iqNNXixY/QFjQ8bMwljmNMnnwya/seW7BmRZG7IJzaltfLW+/RKR36uM7dMhYxQCE98dv2
	Nnw=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:10:34 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:06:27 -0800
Message-Id: <20210119050631.57073-34-chaitanya.kulkarni@wdc.com>
In-Reply-To: <20210119050631.57073-1-chaitanya.kulkarni@wdc.com>
References: <20210119050631.57073-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, snitzer@redhat.com,
	gustavo@embeddedor.com, clm@fb.com, dm-devel@redhat.com,
	adilger.kernel@dilger.ca, hch@lst.de, agk@redhat.com,
	naohiro.aota@wdc.com, sagi@grimberg.me, darrick.wong@oracle.com,
	osandov@fb.com, kent.overstreet@gmail.com,
	Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
	josef@toxicpanda.com, efremov@linux.com, colyli@suse.de,
	tj@kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com,
	bvanassche@acm.org, agruenba@redhat.com, axboe@kernel.dk,
	damien.lemoal@wdc.com, tytso@mit.edu, martin.petersen@oracle.com,
	song@kernel.org, philipp.reisner@linbit.com,
	jefflexu@linux.alibaba.com, rpeterso@redhat.com,
	lars.ellenberg@linbit.com, jth@kernel.org, asml.silence@gmail.com
Subject: [dm-devel] [RFC PATCH 33/37] jfs: use bio_init_fields in metadata
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/jfs/jfs_metapage.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index 176580f54af9..5cea9c137a48 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -417,10 +417,10 @@ static int metapage_writepage(struct page *page, struct writeback_control *wbc)
 		len = min(xlen, (int)JFS_SBI(inode->i_sb)->nbperpage);
 
 		bio = bio_alloc(GFP_NOFS, 1);
-		bio_set_dev(bio, inode->i_sb->s_bdev);
-		bio->bi_iter.bi_sector = pblock << (inode->i_blkbits - 9);
-		bio->bi_end_io = metapage_write_end_io;
-		bio->bi_private = page;
+		bio_init_fields(bio, inode->i_sb->s_bdev,
+				pblock << (inode->i_blkbits - 9),
+				page, metapage_write_end_io, 0, 0);
+
 		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 
 		/* Don't call bio_add_page yet, we may add to this vec */
@@ -497,11 +497,9 @@ static int metapage_readpage(struct file *fp, struct page *page)
 				submit_bio(bio);
 
 			bio = bio_alloc(GFP_NOFS, 1);
-			bio_set_dev(bio, inode->i_sb->s_bdev);
-			bio->bi_iter.bi_sector =
-				pblock << (inode->i_blkbits - 9);
-			bio->bi_end_io = metapage_read_end_io;
-			bio->bi_private = page;
+			bio_init_fields(bio, inode->i_sb->s_bdev,
+					pblock << (inode->i_blkbits - 9,
+					page, metapage_read_end_io, 0, 0);
 			bio_set_op_attrs(bio, REQ_OP_READ, 0);
 			len = xlen << inode->i_blkbits;
 			offset = block_offset << inode->i_blkbits;
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

