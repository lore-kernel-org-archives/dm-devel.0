Return-Path: <SRS0=Z7ED=LY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B62CC11F65
	for <dm-devel@archiver.kernel.org>; Wed, 30 Jun 2021 17:27:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3839961426
	for <dm-devel@archiver.kernel.org>; Wed, 30 Jun 2021 17:27:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3839961426
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1625074047;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iYn8cZlNlEimMl13POMpgEMPknEt+e8vsOZEaEYq17Q=;
	b=fKIUvrC1brqeaw8jMl2BI1CqRjEZOrZ4XyW7C8vigPvnXRrvM1hTK78AqVl6u+evAno/WY
	kzvyW3vHW6KcVRET7DyA/l8Pp0xvRtlDgcIzK9Fo7DXjppOJAfG23KZzMgogZhs+pPOUf0
	IybS20FhYAYI3XXROlPDXft87M5qOUk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-NKsQ4tfWM2SbAC0jVLilIA-1; Wed, 30 Jun 2021 13:27:25 -0400
X-MC-Unique: NKsQ4tfWM2SbAC0jVLilIA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1659800C60;
	Wed, 30 Jun 2021 17:27:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9880A101E663;
	Wed, 30 Jun 2021 17:27:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AD1501818450;
	Wed, 30 Jun 2021 17:27:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15UHRGqw001792 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 30 Jun 2021 13:27:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5529EF89E8; Wed, 30 Jun 2021 17:27:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5015EF8978
	for <dm-devel@redhat.com>; Wed, 30 Jun 2021 17:27:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9ACE780D1BF
	for <dm-devel@redhat.com>; Wed, 30 Jun 2021 17:27:13 +0000 (UTC)
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com
	[209.85.222.179]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-281-rxTzKQf6MzuQNWDsdUx_aA-1; Wed, 30 Jun 2021 13:27:09 -0400
X-MC-Unique: rxTzKQf6MzuQNWDsdUx_aA-1
Received: by mail-qk1-f179.google.com with SMTP id z3so3250424qkl.4;
	Wed, 30 Jun 2021 10:27:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:mime-version:content-disposition;
	bh=zB+yYeYlRbesjsTSmi355np3eoCrr3mJXJ6lzxXNB20=;
	b=ZOBzSXeHQ0mFWcUt2sV+piJxYEmniuLm+ddU3QN3pekQLvGUDIPyndukhP0Na7Q9jt
	YdesdExDBmS3zNVCDCBbu7fhcXlOpu1sM4yFUMYDqhshCwma2H5/TEROCVfjmorv9TUT
	SGzqjA3fYE0fMMsflhBhltmTdLABgN7cSYutHCAYN2t4DfBD2T03Hr9/RxnDpqoHegY7
	16ksIfMz1p+3c/bQpdyxcu7cY2H7GSErbzvqfNovxW3m5FrLtIchBQvgNQCdjZ3EIeWd
	f/qsI9nGMbWwhc+zURrUBTe63axGW54yFAePhAJzei+FKoUQE2D3kLV+sS5TBfGyCN7t
	fE3A==
X-Gm-Message-State: AOAM5308LFNeZhgpMg0G/Iqj+qiHJNmP3l/GMXAsuNeHjwV6N0MCJdFf
	2+aK9vOO/8ifRiMLrc4FT4w=
X-Google-Smtp-Source: ABdhPJwiTb3gcWZhVWRtc8I1GvgfTk1j5fxrpTENxnEk+CvU6HeMrYenvZ7JAuXyQOVt8bG3ZeuCSw==
X-Received: by 2002:a37:4685:: with SMTP id
	t127mr37627406qka.384.1625074028318; 
	Wed, 30 Jun 2021 10:27:08 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	h6sm10806403qta.65.2021.06.30.10.27.07
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 30 Jun 2021 10:27:07 -0700 (PDT)
Date: Wed, 30 Jun 2021 13:27:06 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YNyparaGoPleiSxX@redhat.com>
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
Cc: Damien Le Moal <damien.lemoal@wdc.com>,
	Mikulas Patocka <mpatocka@redhat.com>, Joe Thornber <ejt@redhat.com>,
	Rikard Falkeborn <rikard.falkeborn@gmail.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Baokun Li <libaokun1@huawei.com>, Hou Tao <houtao1@huawei.com>,
	Colin Ian King <colin.king@canonical.com>,
	Alasdair G Kergon <agk@redhat.com>
Subject: [dm-devel] [git pull] device mapper changes for 5.14
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit 7e768532b2396bcb7fbf6f82384b85c0f1d2f197:

  dm snapshot: properly fix a crash when an origin has no snapshots (2021-05-25 16:19:58 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.14/dm-changes

for you to fetch changes up to 5c0de3d72f8c05678ed769bea24e98128f7ab570:

  dm writecache: make writeback pause configurable (2021-06-28 16:30:13 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Various DM persistent-data library improvements and fixes that
  benefit both the DM thinp and cache targets.

- A few small DM kcopyd efficiency improvements.

- Significant zoned related block core, DM core and DM zoned target
  changes that culminate with adding zoned append emulation (which is
  required to properly fix DM crypt's zoned support).

- Various DM writecache target changes that improve efficiency. Adds
  an optional "metadata_only" feature that only promotes bios flagged
  with REQ_META. But the most significant improvement is writecache's
  ability to pause writeback, for a confiurable time, if/when the
  working set is larger than the cache (and the cache is full) -- this
  ensures performance is no worse than the slower origin device.

----------------------------------------------------------------
Baokun Li (1):
      dm writecache: use list_move instead of list_del/list_add in writecache_writeback()

Colin Ian King (1):
      dm ps io affinity: remove redundant continue statement

Damien Le Moal (13):
      dm zoned: check zone capacity
      dm: Fix dm_accept_partial_bio() relative to zone management commands
      dm: cleanup device_area_is_invalid()
      dm: move zone related code to dm-zone.c
      dm: Introduce dm_report_zones()
      dm: Forbid requeue of writes to zones
      block: improve handling of all zones reset operation
      block: introduce bio zone helpers
      block: introduce BIO_ZONE_WRITE_LOCKED bio flag
      dm: rearrange core declarations for extended use from dm-zone.c
      dm: introduce zone append emulation
      dm crypt: Fix zoned block device support
      dm zone: fix dm_revalidate_zones() memory allocation

Hou Tao (1):
      dm btree remove: assign new_root only when removal succeeds

Joe Thornber (4):
      dm btree: improve btree residency
      dm space maps: don't reset space map allocation cursor when committing
      dm space maps: improve performance with inc/dec on ranges of blocks
      dm space map disk: cache a small number of index entries

Mike Snitzer (2):
      dm writecache: add "cleaner" and "max_age" to Documentation
      dm io tracker: factor out IO tracker

Mikulas Patocka (12):
      dm kcopyd: avoid useless atomic operations
      dm kcopyd: avoid spin_lock_irqsave from process context
      dm writecache: don't split bios when overwriting contiguous cache content
      dm writecache: interrupt writeback if suspended
      dm writecache: remove unused gfp_t argument from wc_add_block()
      dm writecache: commit just one block, not a full page
      dm writecache: have ssd writeback wait if the kcopyd workqueue is busy
      dm writecache: flush origin device when writing and cache is full
      dm writecache: write at least 4k when committing
      dm writecache: add optional "metadata_only" parameter
      dm writecache: pause writeback if cache full and origin being written directly
      dm writecache: make writeback pause configurable

Rikard Falkeborn (1):
      dm table: Constify static struct blk_ksm_ll_ops

 .../admin-guide/device-mapper/writecache.rst       |  25 +-
 block/blk-zoned.c                                  | 119 +++-
 drivers/md/Makefile                                |   4 +
 drivers/md/dm-cache-target.c                       |  82 +--
 drivers/md/dm-core.h                               |  65 ++
 drivers/md/dm-crypt.c                              |  31 +-
 drivers/md/dm-era-target.c                         |  24 +-
 drivers/md/dm-flakey.c                             |   7 +-
 drivers/md/dm-io-tracker.h                         |  81 +++
 drivers/md/dm-kcopyd.c                             |  41 +-
 drivers/md/dm-linear.c                             |   7 +-
 drivers/md/dm-ps-io-affinity.c                     |   1 -
 drivers/md/dm-raid1.c                              |   2 +-
 drivers/md/dm-table.c                              |  23 +-
 drivers/md/dm-thin-metadata.c                      |  91 +--
 drivers/md/dm-writecache.c                         | 140 ++++-
 drivers/md/dm-zone.c                               | 660 +++++++++++++++++++++
 drivers/md/dm-zoned-metadata.c                     |   7 +
 drivers/md/dm-zoned-reclaim.c                      |   2 +-
 drivers/md/dm.c                                    | 208 ++-----
 drivers/md/dm.h                                    |  30 +-
 drivers/md/persistent-data/dm-array.c              |  52 +-
 drivers/md/persistent-data/dm-btree-internal.h     |  13 +
 drivers/md/persistent-data/dm-btree-remove.c       |   7 +-
 drivers/md/persistent-data/dm-btree-spine.c        |  16 +-
 drivers/md/persistent-data/dm-btree.c              | 542 +++++++++++++++--
 drivers/md/persistent-data/dm-btree.h              |  10 +-
 drivers/md/persistent-data/dm-space-map-common.c   | 534 ++++++++++++++++-
 drivers/md/persistent-data/dm-space-map-common.h   |  34 +-
 drivers/md/persistent-data/dm-space-map-disk.c     |  83 +--
 drivers/md/persistent-data/dm-space-map-metadata.c | 105 ++--
 drivers/md/persistent-data/dm-space-map.h          |  18 +-
 .../md/persistent-data/dm-transaction-manager.c    |  61 ++
 .../md/persistent-data/dm-transaction-manager.h    |  22 +-
 include/linux/blk_types.h                          |   1 +
 include/linux/blkdev.h                             |  12 +
 include/linux/device-mapper.h                      |   9 +-
 include/linux/dm-kcopyd.h                          |   1 +
 38 files changed, 2548 insertions(+), 622 deletions(-)
 create mode 100644 drivers/md/dm-io-tracker.h
 create mode 100644 drivers/md/dm-zone.c

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

