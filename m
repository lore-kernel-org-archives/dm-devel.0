Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C91EC433DB
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8B7A122BE9
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B7A122BE9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-rMAct-dKNy-q-Zqthww_Bw-1; Tue, 19 Jan 2021 00:08:50 -0500
X-MC-Unique: rMAct-dKNy-q-Zqthww_Bw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC21C59;
	Tue, 19 Jan 2021 05:08:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BFF83620D7;
	Tue, 19 Jan 2021 05:08:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 940011809CA0;
	Tue, 19 Jan 2021 05:08:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J58iAc020706 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:08:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 528D32166B2B; Tue, 19 Jan 2021 05:08:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D9642166B29
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:08:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38A89858280
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:08:44 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-362-kupwOWy9O--ngkBOi7q3ug-1; Tue, 19 Jan 2021 00:08:40 -0500
X-MC-Unique: kupwOWy9O--ngkBOi7q3ug-1
IronPort-SDR: zuv0Sic16TV+RSPgNZ0vx9ayFgchK67r1qyuGIO6bQN8y8Wj+tnBeZuumxS6bw+svOpgFj1fnY
	PfvHcza1r4/PZgekEgLEjf46Yc0BSHv7U/Z5BJ8hiqCuAk2Ajd2jtfTK47qGUaKMM/mkcH1E5e
	2uE8rKih1unKUJ4svlzZ0tcVnJORPkXRiN5CMtP3l4SEqH8zy5PJrYMtolejAh13NlgBPmxE0g
	/lKwHGLsynuXfZ9pqNSmHcsgNCLHPCiUUNxLGywhKhJEftC53pA6W009xS0uiwnhWLeXHsuOO0
	WPQ=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="261722074"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:16:17 +0800
IronPort-SDR: kDAV98WrMKdWNsVd+kjt3Il7e/hxnmNytGvNVA2iyuTVuEJkQw/QWa4apW8MadUlzhbW5vQrdT
	qQXdawUsByrsorTZCGWE0pchPWL1K6/YH3zxHRlL7DyPKrKsD4gFf3Y/4ovwTk/ni1Jovmpr9m
	kIvKt5EUJmyK/zi7snulxlqmhPbrknvF8VDep+0rZUMJgxGz+vXOQ/MVF5ONz9LxPyUbqKzdy4
	yjGUJsqjDYFRLinOKAiYQX/2mmaP2757ts+u6+1GeMrO9l3CnhA5xkANvQW6bUeHMW+Kq4FtWr
	bL7OUBDn5B6XLAakDgF0hDRh
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:49:09 -0800
IronPort-SDR: w8TQaHPmOf4afpFLhHFiHm4s9YBVvwz1nCheCJ4OBOH8yQ2UY0NC3Tt/JdFHF9KkeR+DlxZGUH
	e7bQB+02ddXqKaR8b/7v1Y7wXKviC9dKqJTPF9aSTC9cHooTn06sxWBBnh6ybRkpJPiq1eaXml
	Li9XSEIsEl1dTBAvxWyxQKBso9dBp+WZiRKxmJUsbAqs+G/qtiWTWXlVZWjYoZKV0OKSYwZfdM
	WxDGvor0MhqHOPvWCUI9b0h4sFeSeNraJk/cdT+mEYZtqS1ubVV2lyl7ZqDz6u2Z/jCzzw/RkG
	Jdo=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:06:34 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:05:54 -0800
Message-Id: <20210119050631.57073-1-chaitanya.kulkarni@wdc.com>
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
Subject: [dm-devel] [RFC PATCH 00/37] block: introduce bio_init_fields()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============2286876457411413387=="

--===============2286876457411413387==
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit

Hi,

This is a *compile only RFC* which adds a generic helper to initialize
the various fields of the bio that is repeated all the places in
file-systems, block layer, and drivers.

The new helper allows callers to initialize various members such as
bdev, sector, private, end io callback, io priority, and write hints.

The objective of this RFC is to only start a discussion, this it not 
completely tested at all. Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â  Ã‚Â 
Following diff shows code level benefits of this helper :-
Ã‚Â 38 files changed, 124 insertions(+), 236 deletions(-)

-ck

Chaitanya Kulkarni (37):
  block: introduce bio_init_fields() helper
  fs: use bio_init_fields in block_dev
  btrfs: use bio_init_fields in disk-io
  btrfs: use bio_init_fields in volumes
  ext4: use bio_init_fields in page_io
  gfs2: use bio_init_fields in lops
  gfs2: use bio_init_fields in meta_io
  gfs2: use bio_init_fields in ops_fstype
  iomap: use bio_init_fields in buffered-io
  iomap: use bio_init_fields in direct-io
  jfs: use bio_init_fields in logmgr
  zonefs: use bio_init_fields in append
  drdb: use bio_init_fields in actlog
  drdb: use bio_init_fields in bitmap
  drdb: use bio_init_fields in receiver
  floppy: use bio_init_fields
  pktcdvd: use bio_init_fields
  bcache: use bio_init_fields in journal
  bcache: use bio_init_fields in super
  bcache: use bio_init_fields in writeback
  dm-bufio: use bio_init_fields
  dm-crypt: use bio_init_fields
  dm-zoned: use bio_init_fields metadata
  dm-zoned: use bio_init_fields target
  dm-zoned: use bio_init_fields
  dm log writes: use bio_init_fields
  nvmet: use bio_init_fields in bdev-ns
  target: use bio_init_fields in iblock
  btrfs: use bio_init_fields in scrub
  fs: use bio_init_fields in buffer
  eros: use bio_init_fields in data
  eros: use bio_init_fields in zdata
  jfs: use bio_init_fields in metadata
  nfs: use bio_init_fields in blocklayout
  ocfs: use bio_init_fields in heartbeat
  xfs: use bio_init_fields in xfs_buf
  xfs: use bio_init_fields in xfs_log

 block/blk-lib.c                     | 13 +++++--------
 drivers/block/drbd/drbd_actlog.c    |  5 +----
 drivers/block/drbd/drbd_bitmap.c    |  5 +----
 drivers/block/drbd/drbd_receiver.c  | 11 +++--------
 drivers/block/floppy.c              |  5 +----
 drivers/block/pktcdvd.c             | 12 ++++--------
 drivers/md/bcache/journal.c         | 21 ++++++++-------------
 drivers/md/bcache/super.c           | 19 +++++--------------
 drivers/md/bcache/writeback.c       | 14 ++++++--------
 drivers/md/dm-bufio.c               |  5 +----
 drivers/md/dm-crypt.c               |  4 +---
 drivers/md/dm-log-writes.c          | 21 ++++++---------------
 drivers/md/dm-zoned-metadata.c      | 15 +++++----------
 drivers/md/dm-zoned-target.c        |  9 +++------
 drivers/md/md.c                     |  6 ++----
 drivers/nvme/target/io-cmd-bdev.c   |  4 +---
 drivers/target/target_core_iblock.c | 11 +++--------
 fs/block_dev.c                      | 17 +++++------------
 fs/btrfs/disk-io.c                  | 11 ++++-------
 fs/btrfs/scrub.c                    |  6 ++----
 fs/btrfs/volumes.c                  |  4 +---
 fs/buffer.c                         |  7 ++-----
 fs/erofs/data.c                     |  6 ++----
 fs/erofs/zdata.c                    |  9 +++------
 fs/ext4/page-io.c                   |  6 ++----
 fs/gfs2/lops.c                      |  6 ++----
 fs/gfs2/meta_io.c                   |  5 ++---
 fs/gfs2/ops_fstype.c                |  7 ++-----
 fs/iomap/buffered-io.c              |  5 ++---
 fs/iomap/direct-io.c                | 15 +++++----------
 fs/jfs/jfs_logmgr.c                 | 16 ++++------------
 fs/jfs/jfs_metapage.c               | 16 +++++++---------
 fs/nfs/blocklayout/blocklayout.c    |  8 ++------
 fs/ocfs2/cluster/heartbeat.c        |  4 +---
 fs/xfs/xfs_buf.c                    |  6 ++----
 fs/xfs/xfs_log.c                    |  6 ++----
 fs/zonefs/super.c                   |  7 +++----
 include/linux/bio.h                 | 13 +++++++++++++
 38 files changed, 124 insertions(+), 236 deletions(-)

-- 
2.22.1


--===============2286876457411413387==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============2286876457411413387==--

