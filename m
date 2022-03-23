Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C40FC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 23 Mar 2022 20:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648067939;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3rpDglqqYa1nczrpIuq9hJZh8flbTW8256WPqqskirY=;
	b=MnLV0E6YNtZR7uRUl+24WZ892DBmcr03qSC1Qqi8BwfGHalnvZZkfrGhzTfRSP4NetnCq7
	CsoaTig5hKurMrXdcKkehCpRzp5WVnnv6nQkGLr6Xt0BLN16mSrC9ETc5PMbBIYuM5+RMx
	BverHaK4Dy1YxU++iebOtKgL/qJa6SY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-0Hdv3HqfM9Oe2lyKPlKSxA-1; Wed, 23 Mar 2022 16:38:57 -0400
X-MC-Unique: 0Hdv3HqfM9Oe2lyKPlKSxA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9D44811E75;
	Wed, 23 Mar 2022 20:38:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 61E42401E40;
	Wed, 23 Mar 2022 20:38:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 085C91940347;
	Wed, 23 Mar 2022 20:38:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 073521949763
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Mar 2022 20:38:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D630B401E8C; Wed, 23 Mar 2022 20:38:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D2A50401E40
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 20:38:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B94DB85A5A8
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 20:38:52 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-79i0uvwJPs6rKUatGzcBaQ-1; Wed, 23 Mar 2022 16:38:51 -0400
X-MC-Unique: 79i0uvwJPs6rKUatGzcBaQ-1
Received: by mail-qv1-f69.google.com with SMTP id
 d11-20020a0cffab000000b00440f965f77cso2130223qvv.4
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 13:38:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
 :mime-version:content-disposition;
 bh=GIytgxH4Pq4RXhamKNGHt+Bh2DNJS/Td8vkil6LYZ7A=;
 b=awrNhnRGERynYqZnAeoO3Tfew+Va6C3bDrt/2bALzHrV1wlumE4SDvRJkqd4rw1HRG
 exGfeyNa19krhASTPZPrapvFTgPj/tXEnfgP7aGch08o4Qa/j822B9prt41fKqJoogAG
 o3/a1+xMITDEB12lQujC0zqkI/4/mwf67S1PV+PvHZnu+0cSULszUG/Q9JoWMNysbpBu
 B9s3ixvWVAFA3m13zAOZQyFPsPbTPMicbXl9t9XPKP1D0OA+DAS0YLhWI9USx5iw6Ynb
 g6cY6to8AEh6MujcmLJSjS5+b/uursFmFzmR24YlApD5Tct6H/Xs6D0fZFxKTHtC+p4g
 xirA==
X-Gm-Message-State: AOAM530rpYqNLXcWuf1fkycPjCgQCivV3dAiMJsiL6+a/rcYbkNd5/JN
 VsKSm+NtewtW+V+scpXzMqWpz0BgGdIDEzumTF0aaJDOHN6hAsthppDWvV2HFGhMLkq6nyenJZs
 ByrOH7Wi+IVqcSA==
X-Received: by 2002:a05:620a:4e8:b0:67d:4589:abe1 with SMTP id
 b8-20020a05620a04e800b0067d4589abe1mr1221374qkh.211.1648067930931; 
 Wed, 23 Mar 2022 13:38:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIYfvaUIAa84F3dALCaqJZTRMe/cyX1y+MCMaU1Ox7B77DD6EmV0ZmOvyjHvkOwzf/JwMUVA==
X-Received: by 2002:a05:620a:4e8:b0:67d:4589:abe1 with SMTP id
 b8-20020a05620a04e800b0067d4589abe1mr1221355qkh.211.1648067930653; 
 Wed, 23 Mar 2022 13:38:50 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 h206-20020a379ed7000000b0067b5192da4csm504421qke.12.2022.03.23.13.38.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 23 Mar 2022 13:38:50 -0700 (PDT)
From: Mike Snitzer <snitzer@redhat.com>
X-Google-Original-From: Mike Snitzer <snitzer@kernel.org>
Date: Wed, 23 Mar 2022 16:38:49 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YjuFWbp0vdh/7c5A@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [git pull] device mapper changes for 5.18
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
Cc: Aashish Sharma <shraash@google.com>, Wang Qing <wangqing@vivo.com>,
 Zhiqiang Liu <liuzhiqiang26@huawei.com>,
 Jordy Zomer <jordy@jordyzomer.github.io>, Tom Rix <trix@redhat.com>,
 Barry Song <21cnbao@gmail.com>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Kirill Tkhai <ktkhai@virtuozzo.com>, Colin Ian King <colin.i.king@gmail.com>,
 Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>,
 Thore Sommer <public@thson.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

These changes build on Jens' for-5.18 block tree because of various
changes that impacted DM and DM's need for bio_start_io_acct_time().

The following changes since commit bcd2be763252f3a4d5fc4d6008d4d96c601ee74b:

  block/bfq_wf2q: correct weight to ioprio (2022-02-16 20:09:14 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.18/dm-changes

for you to fetch changes up to 4d7bca13dd9a5033174b0735056c5658cb893e76:

  dm: consolidate spinlocks in dm_io struct (2022-03-21 14:15:36 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Significant refactoring and fixing of how DM core does bio-based IO
  accounting with focus on fixing wildly inaccurate IO stats for
  dm-crypt (and other DM targets that defer bio submission in their
  own workqueues). End result is proper IO accounting, made possible
  by targets being updated to use the new dm_submit_bio_remap()
  interface.

- Add hipri bio polling support (REQ_POLLED) to bio-based DM.

- Reduce dm_io and dm_target_io structs so that a single dm_io (which
  contains dm_target_io and first clone bio) weighs in at 256 bytes.
  For reference the bio struct is 128 bytes.

- Various other small cleanups, fixes or improvements in DM core and
  targets.

- Update MAINTAINERS with my kernel.org email address to allow
  distinction between my "upstream" and "Red" Hats.

----------------------------------------------------------------
Aashish Sharma (1):
      dm crypt: fix get_key_size compiler warning if !CONFIG_KEYS

Barry Song (1):
      dm io: remove stale comment block for dm_io()

Christoph Hellwig (2):
      dm-zoned: remove the ->name field in struct dmz_dev
      dm: stop using bdevname

Colin Ian King (1):
      dm cache policy smq: make static read-only array table const

Jordy Zomer (1):
      dm ioctl: prevent potential spectre v1 gadget

Kirill Tkhai (1):
      dm: fix use-after-free in dm_cleanup_zoned_dev()

Mike Snitzer (33):
      dm: interlock pending dm_io and dm_wait_for_bios_completion
      dm: fix double accounting of flush with data
      dm stats: fix too short end duration_ns when using precise_timestamps
      dm: eliminate copying of dm_io fields in dm_io_dec_pending
      dm: reorder members in mapped_device struct
      dm: rename split functions
      dm: fold __clone_and_map_data_bio into __split_and_process_bio
      dm: refactor dm_split_and_process_bio a bit
      dm: reduce code duplication in __map_bio
      dm: remove impossible BUG_ON in __send_empty_flush
      dm: remove unused mapped_device argument from free_tio
      dm: remove legacy code only needed before submit_bio recursion
      dm: record old_sector in dm_target_io before calling map function
      dm: move duplicate code from callers of alloc_tio into alloc_tio
      dm: reduce dm_io and dm_target_io struct sizes
      dm: flag clones created by __send_duplicate_bios
      dm: add dm_submit_bio_remap interface
      dm crypt: use dm_submit_bio_remap
      dm delay: use dm_submit_bio_remap
      dm: requeue IO if mapping table not yet available
      dm: remove unnecessary local variables in __bind
      dm mpath: use DMINFO instead of printk with KERN_INFO
      dm: add WARN_ON_ONCE to dm_submit_bio_remap
      dm thin: use dm_submit_bio_remap
      dm: simplify dm_sumbit_bio_remap interface
      dm cache: use dm_submit_bio_remap
      dm: factor out dm_io_complete
      dm: return void from __send_empty_flush
      dm: update email address in MAINTAINERS
      dm: switch dm_io booleans over to proper flags
      dm: switch dm_target_io booleans over to proper flags
      dm: reduce size of dm_io and dm_target_io structs
      dm: consolidate spinlocks in dm_io struct

Ming Lei (2):
      block: add ->poll_bio to block_device_operations
      dm: support bio polling

Thore Sommer (1):
      dm ima: fix wrong length calculation for no_data string

Tom Rix (1):
      dm: cleanup double word in comment

Wang Qing (1):
      dm thin: use time_is_before_jiffies instead of open coding it

Zhiqiang Liu (1):
      dm thin metadata: remove unused dm_thin_remove_block and __remove

 MAINTAINERS                      |   2 +-
 block/blk-core.c                 |  14 +-
 block/genhd.c                    |   4 +
 drivers/md/dm-cache-policy-smq.c |   4 +-
 drivers/md/dm-cache-target.c     |  17 +-
 drivers/md/dm-clone-target.c     |  10 +-
 drivers/md/dm-core.h             |  99 ++++--
 drivers/md/dm-crypt.c            |  15 +-
 drivers/md/dm-delay.c            |   5 +-
 drivers/md/dm-ima.c              |   6 +-
 drivers/md/dm-io.c               |   8 -
 drivers/md/dm-ioctl.c            |   2 +
 drivers/md/dm-mpath.c            |   5 +-
 drivers/md/dm-rq.c               |   7 +-
 drivers/md/dm-stats.c            |  34 +-
 drivers/md/dm-stats.h            |  11 +-
 drivers/md/dm-table.c            |  57 +++-
 drivers/md/dm-thin-metadata.c    |  28 --
 drivers/md/dm-thin-metadata.h    |   1 -
 drivers/md/dm-thin.c             |  15 +-
 drivers/md/dm-zoned-metadata.c   |   4 +-
 drivers/md/dm-zoned-target.c     |   1 -
 drivers/md/dm-zoned.h            |   9 +-
 drivers/md/dm.c                  | 673 ++++++++++++++++++++++++++-------------
 include/linux/blkdev.h           |   2 +
 include/linux/device-mapper.h    |   9 +-
 include/uapi/linux/dm-ioctl.h    |   4 +-
 27 files changed, 685 insertions(+), 361 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

