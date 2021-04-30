Return-Path: <SRS0=Ylab=J3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E5A7C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 30 Apr 2021 19:33:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D047661474
	for <dm-devel@archiver.kernel.org>; Fri, 30 Apr 2021 19:33:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D047661474
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1619811185;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9tueQ2i0wR0U9nKx2DF60RNwy2/K5A0dnjrGcuC0FH8=;
	b=QfGpZ6HTMaEr8nOWytJw//UlCjyIWm2YTvWm7b/cAAHGSaUrCSRkfjCIP0WdSGG6d8VedM
	amhHl4RhlhZNBXP7X/4+IfIR7zTFjdA5++jgwvvpMiT+g6IgMjSjOjr0b5YCHvIK6scx8N
	Z1t39okvqxg5sqCZCS8x1PqFfhjF0g4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-rmIF5tF1NAKHYM8dsWebpA-1; Fri, 30 Apr 2021 15:33:02 -0400
X-MC-Unique: rmIF5tF1NAKHYM8dsWebpA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64287501F3;
	Fri, 30 Apr 2021 19:32:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18B811037E9A;
	Fri, 30 Apr 2021 19:32:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E1C6C1800BBE;
	Fri, 30 Apr 2021 19:32:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13UJWkOa021509 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 30 Apr 2021 15:32:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D37782E026; Fri, 30 Apr 2021 19:32:46 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 98D7E60853;
	Fri, 30 Apr 2021 19:32:38 +0000 (UTC)
Date: Fri, 30 Apr 2021 15:32:38 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20210430193237.GA7659@redhat.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: JeongHyeon Lee <jhs2.lee@samsung.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Bhaskar Chowdhury <unixbhaskar@gmail.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Matthew Ruffell <matthew.ruffell@canonical.com>,
	linux-block@vger.kernel.org,
	Julia Lawall <julia.lawall@inria.fr>, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>,
	Matthew Wilcox <willy@infradead.org>, Tian Tao <tiantao6@hisilicon.com>,
	Christoph Hellwig <hch@lst.de>,
	Alasdair G Kergon <agk@redhat.com>, Xu Wang <vulab@iscas.ac.cn>
Subject: [dm-devel] [git pull] device mapper changes for 5.13
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

Some changes were slightly late and their inclusion made later because
I had a worse-than-expected reaction to my 2nd covid shot the past
couple days. Nothing crazy here but wanted to explain why some commits
are recent.

The following changes since commit 4edbe1d7bcffcd6269f3b5eb63f710393ff2ec7a:

  dm ioctl: fix out of bounds array access when no devices (2021-03-26 14:51:50 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.13/dm-changes

for you to fetch changes up to ca4a4e9a55beeb138bb06e3867f5e486da896d44:

  dm raid: remove unnecessary discard limits for raid0 and raid10 (2021-04-30 14:38:37 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Improve scalability of DM's device hash by switching to rbtree

- Extend DM ioctl's DM_LIST_DEVICES_CMD handling to include UUID and
  allow filtering based on name or UUID prefix.

- Various small fixes for typos, warnings, unused function, or
  needlessly exported interfaces.

- Remove needless request_queue NULL pointer checks in DM thin and
  cache targets.

- Remove unnecessary loop in DM core's __split_and_process_bio().

- Remove DM core's dm_vcalloc() and just use kvcalloc or
  kvmalloc_array instead (depending whether zeroing is useful).

- Fix request-based DM's double free of blk_mq_tag_set in device
  remove after table load fails.

- Improve DM persistent data performance on non-x86 by fixing packed
  structs to have a stated alignment. Also remove needless extra work
  from redundant calls to sm_disk_get_nr_free() and a paranoid BUG_ON()
  that caused duplicate checksum calculation.

- Fix missing goto in DM integrity's bitmap_flush_interval error
  handling.

- Add "reset_recalculate" feature flag to DM integrity.

- Improve DM integrity by leveraging discard support to avoid needless
  re-writing of metadata and also use discard support to improve
  hash recalculation.

- Fix race with DM raid target's reshape and MD raid4/5/6 resync that
  resulted in inconsistant reshape state during table reloads.

- Update DM raid target to temove unnecessary discard limits for raid0
  and raid10 now that MD has optimized discard handling for both raid
  levels.

----------------------------------------------------------------
Benjamin Block (1):
      dm rq: fix double free of blk_mq_tag_set in dev remove after table load fails

Bhaskar Chowdhury (1):
      dm ebs: fix a few typos

Christoph Hellwig (1):
      dm: unexport dm_{get,put}_table_device

Gustavo A. R. Silva (1):
      dm raid: fix fall-through warning in rs_check_takeover() for Clang

Heinz Mauelshagen (1):
      dm raid: fix inconclusive reshape layout on fast raid4/5/6 table reload sequences

JeongHyeon Lee (1):
      dm verity: allow only one error handling mode

Jiapeng Chong (2):
      dm persistent data: remove unused return from exit_shadow_spine()
      dm clone metadata: remove unused function

Joe Thornber (4):
      dm space map disk: remove redundant calls to sm_disk_get_nr_free()
      dm btree spine: remove paranoid node_check call in node_prep_for_write()
      dm persistent data: packed struct should have an aligned() attribute too
      dm space map common: fix division bug in sm_ll_find_free_block()

Julia Lawall (1):
      dm writecache: fix flexible_array.cocci warnings

Matthew Wilcox (Oracle) (1):
      dm: replace dm_vcalloc()

Mike Snitzer (1):
      dm raid: remove unnecessary discard limits for raid0 and raid10

Mikulas Patocka (8):
      dm: remove useless loop in __split_and_process_bio
      dm ioctl: replace device hash with red-black tree
      dm ioctl: return UUID in DM_LIST_DEVICES_CMD result
      dm ioctl: filter the returned values according to name or uuid prefix
      dm integrity: add the "reset_recalculate" feature flag
      dm integrity: don't re-write metadata if discarding same blocks
      dm integrity: increase RECALC_SECTORS to improve recalculate speed
      dm integrity: use discard support when recalculating

Tian Tao (1):
      dm integrity: fix missing goto in bitmap_flush_interval error handling

Xu Wang (2):
      dm thin: remove needless request_queue NULL pointer check
      dm cache: remove needless request_queue NULL pointer checks

 drivers/md/dm-cache-target.c                     |   2 +-
 drivers/md/dm-clone-metadata.c                   |   6 -
 drivers/md/dm-ebs-target.c                       |   6 +-
 drivers/md/dm-integrity.c                        |  85 ++++---
 drivers/md/dm-ioctl.c                            | 294 ++++++++++++++---------
 drivers/md/dm-raid.c                             |  44 ++--
 drivers/md/dm-rq.c                               |   2 +
 drivers/md/dm-snap-persistent.c                  |   6 +-
 drivers/md/dm-snap.c                             |   5 +-
 drivers/md/dm-table.c                            |  30 +--
 drivers/md/dm-thin.c                             |   2 +-
 drivers/md/dm-verity-target.c                    |  40 ++-
 drivers/md/dm-writecache.c                       |   2 +-
 drivers/md/dm.c                                  |  63 +++--
 drivers/md/persistent-data/dm-btree-internal.h   |   6 +-
 drivers/md/persistent-data/dm-btree-spine.c      |   8 +-
 drivers/md/persistent-data/dm-space-map-common.c |   2 +
 drivers/md/persistent-data/dm-space-map-common.h |   8 +-
 drivers/md/persistent-data/dm-space-map-disk.c   |   9 -
 include/linux/device-mapper.h                    |   5 -
 include/uapi/linux/dm-ioctl.h                    |  18 +-
 21 files changed, 372 insertions(+), 271 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

