Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1CF7C05027
	for <dm-devel@archiver.kernel.org>; Mon, 20 Feb 2023 17:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676914313;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fkTcLPvtKl+rk44FvZYNUb0Xr4ebrxS+hPHgfozF1Eo=;
	b=cOWR41l7s7rHh8KQnJgGWF1He0g32aH81LHMbYzi8dy4OZZrZg8uf8S79wwZ4U211pZT2j
	9UPP0l/xaFIa9ERfiDAK6Hd027v5T2eBQkjapox8Q/l93DzddsnVS+rU9En0GMcXxhb/mL
	2JYrkmgMJTb61GAQ2jSPwzxNtPB6sb0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-Q8sjV7-_NmybCUYhjLXbSg-1; Mon, 20 Feb 2023 12:31:50 -0500
X-MC-Unique: Q8sjV7-_NmybCUYhjLXbSg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BEB618E5341;
	Mon, 20 Feb 2023 17:31:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4AE3C2166B26;
	Mon, 20 Feb 2023 17:31:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0F4F51946587;
	Mon, 20 Feb 2023 17:31:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 10E831946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Feb 2023 17:31:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BCC934015319; Mon, 20 Feb 2023 17:31:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B54C940BC781
 for <dm-devel@redhat.com>; Mon, 20 Feb 2023 17:31:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9589D802D32
 for <dm-devel@redhat.com>; Mon, 20 Feb 2023 17:31:40 +0000 (UTC)
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com
 [209.85.160.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-94-I48WG_q-OJy9GUqJMh5Iyw-1; Mon, 20 Feb 2023 12:31:38 -0500
X-MC-Unique: I48WG_q-OJy9GUqJMh5Iyw-1
Received: by mail-qt1-f180.google.com with SMTP id v19so1382336qtx.1
 for <dm-devel@redhat.com>; Mon, 20 Feb 2023 09:31:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:content-disposition:mime-version
 :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=JFAjKN+tASKOBCXLDBxvQG1iXs5Eh4V92kbLZpnR5ws=;
 b=W7R3xbfAMvdx7d/i3QuHRp/PW4wlupFBYlLK/LuTHesP3T4W2YcgOoR4zUqdggpr76
 5exuXREzM3HBCSPHAISwt6ay9BlHbO5NvBydHFn5X616zI0YTFfepdtzWKrFAxWsPUJ5
 opUixlLweqXD6rphCfEvLpnYZudYF4cWP/M3IrEne5mOPnn7D5F0WfOZlVI+RWMATvLE
 4au/AmEbrf9bqcOeRLYT16SjV57EeQABVSeBUSypWA5ovOjavFE/dlzPvv9T6qW0yXAv
 DjFVMnGoduaFGISCOR7OjTBpszxJHY+Z4ktZ7lrHy2ECZDOLIv1DTpTSnm2XzJJE84Sy
 A9jg==
X-Gm-Message-State: AO0yUKUGT3Hhab2Tz0yifn1quGgiMGm+qgCV5/o/9YtpQTSqxmsJmOs7
 0V74AUXCmBNt9slznyKwUgpmjJOOmS+gCeh97w==
X-Google-Smtp-Source: AK7set9yJ9aCE/vEGSdmqGwUbQuWXtycBISBZDwjXaO+0HptOvAUiF1oxmdyNyJ9T5md078ppHPR7A==
X-Received: by 2002:ac8:5c08:0:b0:3b8:63fa:11be with SMTP id
 i8-20020ac85c08000000b003b863fa11bemr890528qti.66.1676914298002; 
 Mon, 20 Feb 2023 09:31:38 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 14-20020ac84e8e000000b003bd1a798f76sm970891qtp.37.2023.02.20.09.31.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Feb 2023 09:31:37 -0800 (PST)
Date: Mon, 20 Feb 2023 12:31:36 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <Y/OueIbrfUBZRw5J@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [git pull] device mapper changes for 6.3
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
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
 Sergey Shtylyov <s.shtylyov@omp.ru>, Pingfan Liu <piliu@redhat.com>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Heinz Mauelshagen <heinzm@redhat.com>,
 Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
 Joe Thornber <ejt@redhat.com>, Nathan Huckleberry <nhuck@google.com>,
 linux-block@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>, dm-devel@redhat.com,
 XU pengfei <xupengfei@nfschina.com>,
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 Hou Tao <houtao1@huawei.com>, Mikulas Patocka <mpatocka@redhat.com>,
 Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit 4a6a7bc21d4726c5772e47525e6039852555b391=
:

  block: Default to use cgroup support for BFQ (2023-01-30 09:42:42 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git =
tags/for-6.3/dm-changes

for you to fetch changes up to d695e44157c8da8d298295d1905428fb2495bc8b:

  dm: remove unnecessary (void*) conversion in event_callback() (2023-02-20=
 11:52:49 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM cache target to free background tracker work items, otherwise
  slab BUG will occur when kmem_cache_destroy() is called.

- Improve 2 of DM's shrinker names to reflect their use.

- Fix the DM flakey target to not corrupt the zero page. Fix dm-flakey
  on 32-bit hughmem systems by using  bvec_kmap_local instead of
  page_address. Also, fix logic used when imposing the
  "corrupt_bio_byte" feature.

- Stop using WQ_UNBOUND for DM verity target's verify_wq because it
  causes significant Android latencies on ARM64 (and doesn't show real
  benefit on other architectures).

- Add negative check to catch simple case of a DM table referencing
  itself. More complex scenarios that use intermediate devices to
  self-reference still need to be avoided/handled in userspace.

- Fix DM core's resize to only send one uevent instead of two. This
  fixes a race with udev, that if udev wins, will cause udev to miss
  uevents (which caused premature unmount attempts by systemd).

- Add cond_resched() to workqueue functions in DM core, dn-thin and
  dm-cache so that their loops aren't the cause of unintended cpu
  scheduling fairness issues.

- Fix all of DM's checkpatch errors and warnings (famous last words).
  Various other small cleanups.

----------------------------------------------------------------
Benjamin Marzinski (1):
      dm table: check that a dm device doesn't reference itself

Christophe JAILLET (1):
      dm crypt: Slightly simplify crypt_set_keyring_key()

Heinz Mauelshagen (39):
      dm: add missing SPDX-License-Indentifiers
      dm: prefer kmap_local_page() instead of deprecated kmap_atomic()
      dm: use fsleep() instead of msleep() for deterministic sleep duration
      dm: change "unsigned" to "unsigned int"
      dm: avoid assignment in if conditions
      dm: enclose complex macros into parentheses where possible
      dm: avoid initializing static variables
      dm: address space issues relative to switch/while/for/...
      dm: address indent/space issues
      dm: correct block comments format.
      dm: fix undue/missing spaces
      dm: fix trailing statements
      dm crypt: correct 'foo*' to 'foo *'
      dm block-manager: avoid not required parentheses
      dm: avoid spaces before function arguments or in favour of tabs
      dm: add argument identifier names
      dm: add missing empty lines
      dm: remove unnecessary braces from single statement blocks
      dm: avoid split of quoted strings where possible
      dm: adjust EXPORT_SYMBOL() to follow functions immediately
      dm: prefer '"%s...", __func__'
      dm: avoid using symbolic permissions
      dm: favour __aligned(N) versus "__attribute__ (aligned(N))"
      dm: favour __packed versus "__attribute__ ((packed))"
      dm: avoid useless 'else' after 'break' or return'
      dm: add missing blank line after declarations/fix those
      dm: avoid inline filenames
      dm: don't indent labels
      dm ioctl: have constant on the right side of the test
      dm log: avoid trailing semicolon in macro
      dm log: avoid multiple line dereference
      dm: avoid 'do {} while(0)' loop in single statement macros
      dm: fix use of sizeof() macro
      dm integrity: change macros min/max() -> min_t/max_t where appropriat=
e
      dm: avoid void function return statements
      dm ioctl: prefer strscpy() instead of strlcpy()
      dm: fix suspect indent whitespace
      dm: declare variables static when sensible
      dm clone: prefer kvmalloc_array()

Hou Tao (1):
      dm ioctl: remove unnecessary check when using dm_get_mdptr()

Jiapeng Chong (1):
      dm integrity: Remove bi_sector that's only used by commented debug co=
de

Joe Thornber (2):
      dm cache: free background tracker's queued work in btracker_destroy
      dm cache: Add some documentation to dm-cache-background-tracker.h

Mike Snitzer (6):
      dm: improve shrinker debug names
      dm: remove flush_scheduled_work() during local_exit()
      dm: add cond_resched() to dm_wq_requeue_work()
      dm thin: add cond_resched() to various workqueue loops
      dm cache: add cond_resched() to various workqueue loops
      dm ioctl: assert _hash_lock is held in __hash_remove

Mikulas Patocka (4):
      dm flakey: don't corrupt the zero page
      dm flakey: fix a bug with 32-bit highmem systems
      dm flakey: fix logic when corrupting a bio
      dm: send just one event on resize, not two

Nathan Huckleberry (1):
      dm verity: stop using WQ_UNBOUND for verify_wq

Pingfan Liu (1):
      dm: add cond_resched() to dm_wq_work()

Sergey Shtylyov (1):
      dm ioctl: drop always-false condition

Tetsuo Handa (1):
      dm: update targets using system workqueues to use a local workqueue

Thomas Wei=DFschuh (1):
      dm sysfs: make kobj_type structure constant

XU pengfei (1):
      dm: remove unnecessary (void*) conversion in event_callback()

Yu Zhe (1):
      dm raid: fix some spelling mistakes in comments

 drivers/md/dm-audit.c                              |   2 +-
 drivers/md/dm-bio-prison-v1.c                      |  19 +-
 drivers/md/dm-bio-prison-v1.h                      |   1 +
 drivers/md/dm-bio-prison-v2.c                      |  15 +-
 drivers/md/dm-bio-prison-v2.h                      |  11 +-
 drivers/md/dm-bio-record.h                         |   1 +
 drivers/md/dm-bufio.c                              | 130 ++---
 drivers/md/dm-builtin.c                            |   3 +-
 drivers/md/dm-cache-background-tracker.c           |  17 +-
 drivers/md/dm-cache-background-tracker.h           |  47 +-
 drivers/md/dm-cache-block-types.h                  |   1 +
 drivers/md/dm-cache-metadata.c                     |  74 +--
 drivers/md/dm-cache-metadata.h                     |   5 +-
 drivers/md/dm-cache-policy-internal.h              |  14 +-
 drivers/md/dm-cache-policy-smq.c                   | 166 ++++---
 drivers/md/dm-cache-policy.c                       |   3 +-
 drivers/md/dm-cache-policy.h                       |   7 +-
 drivers/md/dm-cache-target.c                       | 141 +++---
 drivers/md/dm-clone-target.c                       |   2 +-
 drivers/md/dm-core.h                               |   9 +-
 drivers/md/dm-crypt.c                              | 117 ++---
 drivers/md/dm-delay.c                              |   7 +-
 drivers/md/dm-dust.c                               |   2 +-
 drivers/md/dm-ebs-target.c                         |   5 +-
 drivers/md/dm-era-target.c                         | 122 +++--
 drivers/md/dm-exception-store.c                    |   7 +-
 drivers/md/dm-exception-store.h                    |  57 +--
 drivers/md/dm-flakey.c                             |  58 ++-
 drivers/md/dm-ima.c                                |   5 +-
 drivers/md/dm-ima.h                                |   7 +-
 drivers/md/dm-init.c                               |   5 +-
 drivers/md/dm-integrity.c                          | 541 +++++++++++------=
----
 drivers/md/dm-io-rewind.c                          |   8 +-
 drivers/md/dm-io-tracker.h                         |   1 +
 drivers/md/dm-io.c                                 |  88 ++--
 drivers/md/dm-ioctl.c                              | 168 ++++---
 drivers/md/dm-kcopyd.c                             |  61 ++-
 drivers/md/dm-linear.c                             |   5 +-
 drivers/md/dm-log-userspace-base.c                 |  15 +-
 drivers/md/dm-log-userspace-transfer.c             |   8 +-
 drivers/md/dm-log-userspace-transfer.h             |   1 +
 drivers/md/dm-log-writes.c                         |  23 +-
 drivers/md/dm-log.c                                |  65 ++-
 drivers/md/dm-mpath.c                              | 125 +++--
 drivers/md/dm-mpath.h                              |   3 +-
 drivers/md/dm-path-selector.c                      |   4 +-
 drivers/md/dm-path-selector.h                      |  28 +-
 drivers/md/dm-ps-historical-service-time.c         |   2 +-
 drivers/md/dm-ps-io-affinity.c                     |   6 +-
 drivers/md/dm-ps-queue-length.c                    |  15 +-
 drivers/md/dm-ps-round-robin.c                     |  22 +-
 drivers/md/dm-ps-service-time.c                    |  26 +-
 drivers/md/dm-raid.c                               |  35 +-
 drivers/md/dm-raid1.c                              |  92 ++--
 drivers/md/dm-region-hash.c                        |  29 +-
 drivers/md/dm-rq.c                                 |  27 +-
 drivers/md/dm-rq.h                                 |   3 +-
 drivers/md/dm-snap-persistent.c                    |  48 +-
 drivers/md/dm-snap-transient.c                     |  18 +-
 drivers/md/dm-snap.c                               |  91 ++--
 drivers/md/dm-stats.c                              | 103 ++--
 drivers/md/dm-stats.h                              |   6 +-
 drivers/md/dm-stripe.c                             |  53 +-
 drivers/md/dm-switch.c                             |  47 +-
 drivers/md/dm-sysfs.c                              |  12 +-
 drivers/md/dm-table.c                              |  58 +--
 drivers/md/dm-target.c                             |   6 +-
 drivers/md/dm-thin-metadata.c                      |  66 +--
 drivers/md/dm-thin-metadata.h                      |   1 +
 drivers/md/dm-thin.c                               |  88 ++--
 drivers/md/dm-uevent.c                             |   6 +-
 drivers/md/dm-uevent.h                             |   6 +-
 drivers/md/dm-unstripe.c                           |   1 +
 drivers/md/dm-verity-fec.c                         |  30 +-
 drivers/md/dm-verity-fec.h                         |  18 +-
 drivers/md/dm-verity-target.c                      |  83 ++--
 drivers/md/dm-verity-verify-sig.c                  |   2 +-
 drivers/md/dm-verity-verify-sig.h                  |   2 +-
 drivers/md/dm-verity.h                             |   8 +-
 drivers/md/dm-writecache.c                         | 171 ++++---
 drivers/md/dm-zero.c                               |   1 +
 drivers/md/dm-zone.c                               |   2 +-
 drivers/md/dm-zoned-metadata.c                     |  22 +-
 drivers/md/dm-zoned-target.c                       |   1 -
 drivers/md/dm.c                                    | 116 +++--
 drivers/md/dm.h                                    |  16 +-
 drivers/md/persistent-data/dm-array.c              |  82 ++--
 drivers/md/persistent-data/dm-array.h              |   3 +-
 drivers/md/persistent-data/dm-bitset.c             |  14 +-
 drivers/md/persistent-data/dm-bitset.h             |   1 +
 drivers/md/persistent-data/dm-block-manager.c      |  32 +-
 drivers/md/persistent-data/dm-block-manager.h      |   7 +-
 drivers/md/persistent-data/dm-btree-internal.h     |   6 +-
 drivers/md/persistent-data/dm-btree-remove.c       |  52 +-
 drivers/md/persistent-data/dm-btree-spine.c        |  21 +-
 drivers/md/persistent-data/dm-btree.c              | 130 ++---
 drivers/md/persistent-data/dm-btree.h              |  15 +-
 .../persistent-data/dm-persistent-data-internal.h  |   7 +-
 drivers/md/persistent-data/dm-space-map-common.c   |  52 +-
 drivers/md/persistent-data/dm-space-map-common.h   |  11 +-
 drivers/md/persistent-data/dm-space-map-disk.c     |  13 +-
 drivers/md/persistent-data/dm-space-map-disk.h     |   1 +
 drivers/md/persistent-data/dm-space-map-metadata.c |  24 +-
 drivers/md/persistent-data/dm-space-map-metadata.h |   1 +
 drivers/md/persistent-data/dm-space-map.h          |   1 +
 .../md/persistent-data/dm-transaction-manager.c    |  18 +-
 .../md/persistent-data/dm-transaction-manager.h    |   3 +-
 include/linux/device-mapper.h                      |  60 ++-
 include/linux/dm-bufio.h                           |  13 +-
 include/linux/dm-dirty-log.h                       |   9 +-
 include/linux/dm-io.h                              |   9 +-
 include/linux/dm-kcopyd.h                          |  23 +-
 include/linux/dm-region-hash.h                     |   9 +-
 113 files changed, 2311 insertions(+), 1849 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

