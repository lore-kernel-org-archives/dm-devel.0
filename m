Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2224C00144
	for <dm-devel@archiver.kernel.org>; Mon,  1 Aug 2022 18:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659380339;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NRAQhe0YUKGKvbzTachjL4rShOGMDYovkibIEZ3JCo8=;
	b=JlpT/Sc3MblLm3dxgjdMngp5MvxxHN+aKCrQgDo3VFIeyuHhxULe8dTC1qdOBm3zFKgV0Y
	khNNqTjDrmshWvIcZHA29TQB155+5JQUAyNeO6NGyDoMhTpWaWNvhhfgpbJnk6KzM17nUj
	Xv0GFG8Oeh0qyh97u6s6ktdnZd6Fcmc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-vvnBvp3LOyi-KqhKM1w5sw-1; Mon, 01 Aug 2022 14:58:56 -0400
X-MC-Unique: vvnBvp3LOyi-KqhKM1w5sw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 344263C01E08;
	Mon,  1 Aug 2022 18:58:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B76641121314;
	Mon,  1 Aug 2022 18:58:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A13561946A47;
	Mon,  1 Aug 2022 18:58:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BA3271946A40
 for <dm-devel@listman.corp.redhat.com>; Mon,  1 Aug 2022 18:58:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9AACE400DEF8; Mon,  1 Aug 2022 18:58:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9697840CFD0A
 for <dm-devel@redhat.com>; Mon,  1 Aug 2022 18:58:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F28B3C01DED
 for <dm-devel@redhat.com>; Mon,  1 Aug 2022 18:58:52 +0000 (UTC)
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com
 [209.85.222.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-fxmTalr5My6IZQpKdC9M0w-1; Mon, 01 Aug 2022 14:58:51 -0400
X-MC-Unique: fxmTalr5My6IZQpKdC9M0w-1
Received: by mail-qk1-f169.google.com with SMTP id m7so9101685qkk.6
 for <dm-devel@redhat.com>; Mon, 01 Aug 2022 11:58:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-disposition:mime-version:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc;
 bh=noKfAGA/6Igm9E6+GZzHCeI90DSjIQ4h0rHdnNbwrXg=;
 b=mYfCrIcvzmobIdFNzT6nYbBaiA9n/NujjV/zH5TQk0dxjH11/o9kKF8HCNWF6poCgl
 BqucyeG7GkVpjHbqn+S2bvZjbwtSWotX4l04aQdL5tClaiem30gDnmRjebQZy4Rp9UlQ
 8Y5ad+Dni0LE08zeOh5lXY1RjVGs32sCfba4hhQoNuss37YAyYs9VdcbDS7gBg2CKyik
 a8x1YhOKHlo5q9dwPPcFOz5Meo4nBnVgBpiepDUaVUzKddq54hHCz/AstxLh7wimYOqr
 FbSsFS6E2chvZ8e41L6iqCjONZSeWwM65H9HYh1Fu7qVwa4gnNksatFjQbXzIhvONyRw
 KBWA==
X-Gm-Message-State: AJIora9DzpZhv6v8aVxsa6b1Dojo6R7GQAPKJcogPz227kPvWKnyIX9l
 h1GoVGWdlML6bXVWaigwkxU5OUg=
X-Google-Smtp-Source: AGRyM1vVeSlVLvxMC6UPwEEP3npK0YTnqsmxTV0yEjLx7BD//M5FDl2rm13onmSCQSNOpcLZLy8JQg==
X-Received: by 2002:ae9:e8c9:0:b0:6b5:e58b:7f5a with SMTP id
 a192-20020ae9e8c9000000b006b5e58b7f5amr12755389qkg.741.1659380330710; 
 Mon, 01 Aug 2022 11:58:50 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 x21-20020a05620a0b5500b006a793bde241sm8518820qkg.63.2022.08.01.11.58.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 01 Aug 2022 11:58:50 -0700 (PDT)
Date: Mon, 1 Aug 2022 14:58:49 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YugiaQ1TO+vT1FQ5@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [git pull] device mapper changes for 6.0
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
Cc: JeongHyeon Lee <jhs2.lee@samsung.com>, Steven Lung <1030steven@gmail.com>,
 Zhang Jiaming <jiaming@nfschina.com>, Jiang Jian <jiangjian@cdjrlc.com>,
 Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Mike Christie <michael.christie@oracle.com>,
 Bagas Sanjaya <bagasdotme@gmail.com>, Luo Meng <luomeng12@huawei.com>,
 Mauro Carvalho Chehab <mchehab@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

Stephen had to deal with a couple trivial merge conflicts late in this
cycle, please see: https://lkml.org/lkml/2022/7/27/1819 and
https://lkml.org/lkml/2022/7/28/302

The following changes since commit 22d0c4080fe49299640d9d6c43154c49794c2825:

  block: simplify disk_set_independent_access_ranges (2022-06-29 08:36:46 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.0/dm-changes

for you to fetch changes up to 9dd1cd3220eca534f2d47afad7ce85f4c40118d8:

  dm: fix dm-raid crash if md_handle_request() splits bio (2022-07-28 17:36:30 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Refactor DM core's mempool allocation so that it clearer by not
  being split acorss files.

- Improve DM core's BLK_STS_DM_REQUEUE and BLK_STS_AGAIN handling.

- Optimize DM core's more common bio splitting by eliminating the use
  of bio cloning with bio_split+bio_chain. Shift that cloning cost to
  the relatively unlikely dm_io requeue case that only occurs during
  error handling. Introduces dm_io_rewind() that will clone a bio that
  reflects the subset of the original bio that must be requeued.

- Remove DM core's dm_table_get_num_targets() wrapper and audit all
  dm_table_get_target() callers.

- Fix potential for OOM with DM writecache target by setting a default
  MAX_WRITEBACK_JOBS (set to 256MiB or 1/16 of total system memory,
  whichever is smaller).

- Fix DM writecache target's stats that are reported through
  DM-specific table info.

- Fix use-after-free crash in dm_sm_register_threshold_callback().

- Refine DM core's Persistent Reservation handling in preparation for
  broader work Mike Christie is doing to add compatibility with
  Microsoft Windows Failover Cluster.

- Fix various KASAN reported bugs in the DM raid target.

- Fix DM raid target crash due to md_handle_request() bio splitting
  that recurses to block core without properly initializing the bio's
  bi_dev.

- Fix some code comment typos and fix some Documentation formatting.

----------------------------------------------------------------
Bagas Sanjaya (1):
      Documentation: dm writecache: Render status list as list

Christoph Hellwig (2):
      dm: unexport dm_get_reserved_rq_based_ios
      dm: refactor dm_md_mempool allocation

JeongHyeon Lee (1):
      dm verity: fix checkpatch close brace error

Jiang Jian (1):
      dm raid: remove redundant "the" in parse_raid_params() comment

Luo Meng (1):
      dm thin: fix use-after-free crash in dm_sm_register_threshold_callback

Mauro Carvalho Chehab (1):
      Documentation: dm writecache: add blank line before optional parameters

Mike Christie (4):
      dm: Allow dm_call_pr to be used for path searches
      dm: Start pr_reserve from the same starting path
      dm: Fix PR release handling for non All Registrants
      dm: Start pr_preempt from the same starting path

Mike Snitzer (5):
      dm table: remove dm_table_get_num_targets() wrapper
      dm table: audit all dm_table_get_target() callers
      dm table: rename dm_target variable in dm_table_add_target()
      dm: return early from dm_pr_call() if DM device is suspended
      dm: fix dm-raid crash if md_handle_request() splits bio

Mikulas Patocka (8):
      dm writecache: set a default MAX_WRITEBACK_JOBS
      dm kcopyd: use __GFP_HIGHMEM when allocating pages
      dm writecache: return void from functions
      dm writecache: count number of blocks read, not number of read bios
      dm writecache: count number of blocks written, not number of write bios
      dm writecache: count number of blocks discarded, not number of discard bios
      dm raid: fix address sanitizer warning in raid_status
      dm raid: fix address sanitizer warning in raid_resume

Ming Lei (3):
      dm: improve BLK_STS_DM_REQUEUE and BLK_STS_AGAIN handling
      dm: add dm_bio_rewind() API to DM core
      dm: add two stage requeue mechanism

Steven Lung (1):
      dm cache: fix typo in 2 comment blocks

Zhang Jiaming (1):
      dm snapshot: fix typo in snapshot_map() comment

 .../admin-guide/device-mapper/writecache.rst       |  18 +-
 drivers/md/Makefile                                |   2 +-
 drivers/md/dm-cache-metadata.h                     |   2 +-
 drivers/md/dm-cache-target.c                       |   2 +-
 drivers/md/dm-core.h                               |  23 +-
 drivers/md/dm-ima.c                                |   5 +-
 drivers/md/dm-io-rewind.c                          | 166 ++++++++
 drivers/md/dm-ioctl.c                              |   6 +-
 drivers/md/dm-kcopyd.c                             |   2 +-
 drivers/md/dm-raid.c                               |   7 +-
 drivers/md/dm-rq.c                                 |   1 -
 drivers/md/dm-snap.c                               |   2 +-
 drivers/md/dm-table.c                              | 318 +++++++-------
 drivers/md/dm-thin-metadata.c                      |   7 +-
 drivers/md/dm-thin.c                               |   4 +-
 drivers/md/dm-verity-target.c                      |   7 +-
 drivers/md/dm-writecache.c                         |  43 +-
 drivers/md/dm-zone.c                               |   7 +-
 drivers/md/dm.c                                    | 462 +++++++++++++--------
 drivers/md/dm.h                                    |   4 -
 include/linux/device-mapper.h                      |   7 +-
 include/uapi/linux/dm-ioctl.h                      |   4 +-
 22 files changed, 694 insertions(+), 405 deletions(-)
 create mode 100644 drivers/md/dm-io-rewind.c

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

