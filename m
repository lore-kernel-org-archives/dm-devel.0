Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19F40C77B75
	for <dm-devel@archiver.kernel.org>; Fri, 21 Apr 2023 06:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682059683;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1POjEcjCGA/olXiNLm2mF0Elp4Bnkec+dxk2DinjTAo=;
	b=cUhFmK4jHrqve0FLrccaceU6t9uFOHT7kPwCaRo66cDL3TSTwtct1lOpcpGOEw4/aRVdZw
	MR4jDjYkdiSSo6sIumwPlBZIVx5GCn9niUJuiYQH1Syqr7QINZOHpluD9VwJ9/EIzwVHeo
	iyTnK41WajC4amu/PS3QetxkrQZ/5ho=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-FuHXgBwoMg6aGdhNIax__g-1; Fri, 21 Apr 2023 02:47:59 -0400
X-MC-Unique: FuHXgBwoMg6aGdhNIax__g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4CA4185A7AB;
	Fri, 21 Apr 2023 06:47:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D1755492C3E;
	Fri, 21 Apr 2023 06:47:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 851A91946A6F;
	Fri, 21 Apr 2023 06:47:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F32021946A66
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Apr 2023 10:06:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D9956492B06; Thu, 20 Apr 2023 10:05:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D231B492B05
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 10:05:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D7913802AC0
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 10:05:55 +0000 (UTC)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
 [209.85.128.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-tG38UMCONdmuOvErYk7O0g-1; Thu, 20 Apr 2023 06:05:51 -0400
X-MC-Unique: tG38UMCONdmuOvErYk7O0g-1
Received: by mail-wm1-f42.google.com with SMTP id
 5b1f17b1804b1-3f178da21afso3703005e9.1; 
 Thu, 20 Apr 2023 03:05:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681985150; x=1684577150;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=ZcXCJ3SJOteyet1IXFZTQ3OoqtJ2euWeW1pB3mgV2W4=;
 b=RqnpmzTFVfGEU+nKZECv0fTg70jWV+KPQNDBLfBxcAcaptx0ZnZFkXUcGqjB3vLTvu
 YCOCIu6HA5kkHkMvCMj04bXIkAHVaD5IGx/uaSWlsJCmb8N2b48Yc4muaI04B01h2OND
 D1/tdjGN/djq1PbQIXtOGus4gMmua8w6sCL45cdhlbfEPC6J/W1wUAQ5vjNsBk4E9dc6
 lScPtSqdRwSl2FL5qErkV/YaAhngCBQr/maPZB0lk6Je5W3rakJ021sKoLZGtCPsNHLG
 JKGl2+qbswXE4ylb6p4obU0OUfvAREmA83DE3iTHI6qhwIehPzcdcETWyKx3PwhbXPrT
 GYPQ==
X-Gm-Message-State: AAQBX9fRmBKNWpRY4QADQEPM5dqgEMlbAPhVxoh/n+gE0fazleLRbmzs
 I5py3jND0TjBdlSda+qNMvc=
X-Google-Smtp-Source: AKy350ZgMStjbiqJTTKXUPdei9S3WxVemsjZICWKQrqIJ34flrxB2Hb2jlcmCp+kqLQGz5LFUepZLA==
X-Received: by 2002:a5d:5683:0:b0:2f7:8acb:b823 with SMTP id
 f3-20020a5d5683000000b002f78acbb823mr707539wrv.56.1681985149859; 
 Thu, 20 Apr 2023 03:05:49 -0700 (PDT)
Received: from localhost.localdomain
 (aftr-62-216-205-208.dynamic.mnet-online.de. [62.216.205.208])
 by smtp.googlemail.com with ESMTPSA id
 l11-20020a5d674b000000b0030276f42f08sm201410wrw.88.2023.04.20.03.05.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 20 Apr 2023 03:05:49 -0700 (PDT)
From: Johannes Thumshirn <jth@kernel.org>
To: axboe@kernel.dk
Date: Thu, 20 Apr 2023 12:04:39 +0200
Message-Id: <20230420100501.32981-1-jth@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Fri, 21 Apr 2023 06:47:49 +0000
Subject: [dm-devel] [PATCH v4 00/22] bio: check return values of bio_add_page
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
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, linux-mm@kvack.org,
 dm-devel@redhat.com, hch@lst.de, agruenba@redhat.com, willy@infradead.org,
 cluster-devel@redhat.com, kch@nvidia.com, snitzer@kernel.org,
 ming.lei@redhat.com, linux-block@vger.kernel.org, rpeterso@redhat.com,
 dsterba@suse.com, linux-raid@vger.kernel.org, damien.lemoal@wdc.com,
 song@kernel.org, johannes.thumshirn@wdc.com, linux-fsdevel@vger.kernel.org,
 Johannes Thumshirn <jth@kernel.org>, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

We have two functions for adding a page to a bio, __bio_add_page() which is
used to add a single page to a freshly created bio and bio_add_page() which is
used to add a page to an existing bio.

While __bio_add_page() is expected to succeed, bio_add_page() can fail.

This series converts the callers of bio_add_page() which can easily use
__bio_add_page() to using it and checks the return of bio_add_page() for
callers that don't work on a freshly created bio.

Lastly it marks bio_add_page() as __must_check so we don't have to go again
and audit all callers.

NOTE: David already applied the two btrfs patches to his tree but I've left
them in the series to make the build bot happy.

Changes to v3:
- Added __bio_add_folio and use it in iomap (Willy)
- Mark bio_add_folio must check (Willy)
- s/GFS/GFS2/ (Andreas)

Changes to v2:
- Removed 'wont fail' comments pointed out by Song

Changes to v1:
- Removed pointless comment pointed out by Willy
- Changed commit messages pointed out by Damien
- Colledted Damien's Reviews and Acks

Johannes Thumshirn (22):
  swap: use __bio_add_page to add page to bio
  drbd: use __bio_add_page to add page to bio
  dm: dm-zoned: use __bio_add_page for adding single metadata page
  fs: buffer: use __bio_add_page to add single page to bio
  md: use __bio_add_page to add single page
  md: raid5-log: use __bio_add_page to add single page
  md: raid5: use __bio_add_page to add single page to new bio
  btrfs: repair: use __bio_add_page for adding single page
  btrfs: raid56: use __bio_add_page to add single page
  jfs: logmgr: use __bio_add_page to add single page to bio
  gfs2: use __bio_add_page for adding single page to bio
  zonefs: use __bio_add_page for adding single page to bio
  zram: use __bio_add_page for adding single page to bio
  floppy: use __bio_add_page for adding single page to bio
  md: check for failure when adding pages in alloc_behind_master_bio
  md: raid1: use __bio_add_page for adding single page to bio
  md: raid1: check if adding pages to resync bio fails
  dm-crypt: check if adding pages to clone bio fails
  block: mark bio_add_page as __must_check
  block: add __bio_add_folio
  fs: iomap: use __bio_add_folio where possible
  block: mark bio_add_folio as __must_check

 block/bio.c                      |  8 ++++++++
 drivers/block/drbd/drbd_bitmap.c |  4 +---
 drivers/block/floppy.c           |  2 +-
 drivers/block/zram/zram_drv.c    |  2 +-
 drivers/md/dm-crypt.c            |  9 ++++++++-
 drivers/md/dm-zoned-metadata.c   |  6 +++---
 drivers/md/md.c                  |  4 ++--
 drivers/md/raid1-10.c            | 11 ++++++-----
 drivers/md/raid1.c               |  7 +++++--
 drivers/md/raid10.c              | 20 ++++++++++----------
 drivers/md/raid5-cache.c         |  2 +-
 drivers/md/raid5-ppl.c           |  4 ++--
 fs/btrfs/bio.c                   |  2 +-
 fs/btrfs/raid56.c                |  2 +-
 fs/buffer.c                      |  2 +-
 fs/gfs2/ops_fstype.c             |  2 +-
 fs/iomap/buffered-io.c           |  6 +++---
 fs/jfs/jfs_logmgr.c              |  4 ++--
 fs/zonefs/super.c                |  2 +-
 include/linux/bio.h              |  5 +++--
 mm/page_io.c                     |  8 ++++----
 21 files changed, 65 insertions(+), 47 deletions(-)


base-commit: af67688dca57999fd848f051eeea1d375ba546b2
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

