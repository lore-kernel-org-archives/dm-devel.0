Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBC23C636D4
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319276;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RLCJhpreluHge6PIr0KzKnMwHXde4UcX8KVFLmgBTSw=;
	b=XtqeWUoF+oIVyklAL2YAVbSXoEJHcu8j9mpeVt3nGuX6mBlAxMJXPRTaXwGI6Eats/hrUX
	gk3BUS9fyyTJN1HTMrQVRo7XLn3VKDrv1BBEWvDiFH+OsycSonramDyyyv5DbjmAZXqlJS
	EJgKjhyvgMIeZ2w1SX1AF/ao6ZSrPCI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-t6iUwrAyONadtkbiiKWgGw-1; Mon, 13 Feb 2023 15:14:32 -0500
X-MC-Unique: t6iUwrAyONadtkbiiKWgGw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10AC886C14B;
	Mon, 13 Feb 2023 20:14:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0038D2166B26;
	Mon, 13 Feb 2023 20:14:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DF7531946588;
	Mon, 13 Feb 2023 20:14:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0EBEB1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:14:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E383F2026D68; Mon, 13 Feb 2023 20:14:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DC2422026D4B
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD65A101A55E
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:28 +0000 (UTC)
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com
 [209.85.160.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-120-H6xsfdL7PuSbYoxKi_qWeQ-1; Mon, 13 Feb 2023 15:14:27 -0500
X-MC-Unique: H6xsfdL7PuSbYoxKi_qWeQ-1
Received: by mail-qt1-f178.google.com with SMTP id z5so15165445qtn.8
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:14:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=3mk4bLIngw3x2m6G4wUqm6RCVlCLbmDjvBOQDhN8saA=;
 b=1Z8WUfUG8k3zFAzG1deBrfF+DDb4BzA8NHxOfgHvGsJWAS2BpoU7Gn7uYNycm4kXqz
 buKl13mumQxXOZ3ExB/sGl66TbdUgWa+6xaIASHTYpCLS4SsqMNr2UCScLIWzfZHI9UK
 SJ4CsSlcX9ZFs7opuTKPVSWn5IxMgfSWmx1misdR3jjybBhvEhgQ93VrKQ/8kaYpFHdK
 KGk9Wgd5Fx3oLYU3FvJ/+qcZJuTYfGqm7UrD9cvKks+1BDLll0vHzgPG8YZ3c9YNrFiC
 t4ATlYqWdqhpdx4O5T+3lUl6FcJ2JLpD+IJFXFhqdfo3c5hNAVfLgGB9PvTe2ZxZoe9G
 8A1Q==
X-Gm-Message-State: AO0yUKV1J5P59eaZZi52alhrtY7fuxj42Axg2joK6Rai7DBbuyNjTMX8
 LAsOBUfOJGDhL9ohxq0bIZ+vc/d69mZOsLrcsBoiX7Gr6rxwtniM8bn+9uaLqbr3IUqUHySzYOQ
 MEg3vCavRz6LEW8npyTFPtM15VEfaqx9w4xhPtRNDBkeRnG5AnpuRlOpO5u4F9bHyZEl3vQ==
X-Google-Smtp-Source: AK7set/5muRYf2+XC/Dp1zxh/fzEVprZ0ijTIHBkc94WnElLzycbiH+XdEWjrKypX4m1fuVpOcK72g==
X-Received: by 2002:a05:622a:d6:b0:3b6:2dc7:de7d with SMTP id
 p22-20020a05622a00d600b003b62dc7de7dmr47489745qtw.22.1676319266291; 
 Mon, 13 Feb 2023 12:14:26 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 p11-20020a05622a00cb00b003b86d3ee49asm10218873qtw.74.2023.02.13.12.14.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:14:25 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:22 -0500
Message-Id: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 00/39] dm: fix checkpatch errors and warnings
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
Cc: ebiggers@kernel.org, Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

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
  dm integrity: change macros min/max() -> min_t/max_t where appropriate
  dm: avoid void function return statements
  dm ioctl: prefer strscpy() instead of strlcpy()
  dm: fix suspect indent whitespace
  dm: declare variables static when sensible
  dm clone: prefer kvmalloc_array()

 drivers/md/dm-bio-prison-v1.c                 |  19 +-
 drivers/md/dm-bio-prison-v1.h                 |   1 +
 drivers/md/dm-bio-prison-v2.c                 |  15 +-
 drivers/md/dm-bio-prison-v2.h                 |  11 +-
 drivers/md/dm-bio-record.h                    |   1 +
 drivers/md/dm-bufio.c                         | 128 +++--
 drivers/md/dm-builtin.c                       |   1 -
 drivers/md/dm-cache-background-tracker.c      |   9 +-
 drivers/md/dm-cache-background-tracker.h      |   7 +-
 drivers/md/dm-cache-block-types.h             |   1 +
 drivers/md/dm-cache-metadata.c                |  74 +--
 drivers/md/dm-cache-metadata.h                |   5 +-
 drivers/md/dm-cache-policy-internal.h         |  14 +-
 drivers/md/dm-cache-policy-smq.c              | 166 +++---
 drivers/md/dm-cache-policy.c                  |   3 +-
 drivers/md/dm-cache-policy.h                  |   7 +-
 drivers/md/dm-cache-target.c                  | 137 +++--
 drivers/md/dm-clone-target.c                  |   2 +-
 drivers/md/dm-core.h                          |   9 +-
 drivers/md/dm-crypt.c                         | 115 ++--
 drivers/md/dm-delay.c                         |   7 +-
 drivers/md/dm-ebs-target.c                    |   5 +-
 drivers/md/dm-era-target.c                    | 122 ++--
 drivers/md/dm-exception-store.c               |   7 +-
 drivers/md/dm-exception-store.h               |  57 +-
 drivers/md/dm-flakey.c                        |  27 +-
 drivers/md/dm-ima.c                           |   3 +-
 drivers/md/dm-ima.h                           |   7 +-
 drivers/md/dm-init.c                          |   4 +-
 drivers/md/dm-integrity.c                     | 534 ++++++++++--------
 drivers/md/dm-io-rewind.c                     |   8 +-
 drivers/md/dm-io-tracker.h                    |   1 +
 drivers/md/dm-io.c                            |  88 +--
 drivers/md/dm-ioctl.c                         | 142 ++---
 drivers/md/dm-kcopyd.c                        |  61 +-
 drivers/md/dm-linear.c                        |   5 +-
 drivers/md/dm-log-userspace-base.c            |  15 +-
 drivers/md/dm-log-userspace-transfer.c        |   8 +-
 drivers/md/dm-log-userspace-transfer.h        |   1 +
 drivers/md/dm-log-writes.c                    |  23 +-
 drivers/md/dm-log.c                           |  65 ++-
 drivers/md/dm-mpath.c                         | 108 ++--
 drivers/md/dm-mpath.h                         |   3 +-
 drivers/md/dm-path-selector.c                 |   4 +-
 drivers/md/dm-path-selector.h                 |  28 +-
 drivers/md/dm-ps-io-affinity.c                |   6 +-
 drivers/md/dm-ps-queue-length.c               |  15 +-
 drivers/md/dm-ps-round-robin.c                |  22 +-
 drivers/md/dm-ps-service-time.c               |  26 +-
 drivers/md/dm-raid.c                          |  29 +-
 drivers/md/dm-raid1.c                         |  78 +--
 drivers/md/dm-region-hash.c                   |  29 +-
 drivers/md/dm-rq.c                            |  27 +-
 drivers/md/dm-rq.h                            |   3 +-
 drivers/md/dm-snap-persistent.c               |  48 +-
 drivers/md/dm-snap-transient.c                |  18 +-
 drivers/md/dm-snap.c                          |  91 +--
 drivers/md/dm-stats.c                         | 101 ++--
 drivers/md/dm-stats.h                         |   6 +-
 drivers/md/dm-stripe.c                        |  41 +-
 drivers/md/dm-switch.c                        |  47 +-
 drivers/md/dm-sysfs.c                         |  10 +-
 drivers/md/dm-table.c                         |  56 +-
 drivers/md/dm-target.c                        |   6 +-
 drivers/md/dm-thin-metadata.c                 |  66 ++-
 drivers/md/dm-thin-metadata.h                 |   1 +
 drivers/md/dm-thin.c                          |  86 +--
 drivers/md/dm-uevent.c                        |   6 +-
 drivers/md/dm-uevent.h                        |   6 +-
 drivers/md/dm-unstripe.c                      |   1 +
 drivers/md/dm-verity-fec.c                    |  30 +-
 drivers/md/dm-verity-fec.h                    |  18 +-
 drivers/md/dm-verity-target.c                 |  77 +--
 drivers/md/dm-verity-verify-sig.h             |   2 +-
 drivers/md/dm-verity.h                        |   8 +-
 drivers/md/dm-writecache.c                    | 169 +++---
 drivers/md/dm-zero.c                          |   1 +
 drivers/md/dm-zoned-metadata.c                |  20 +-
 drivers/md/dm-zoned-target.c                  |   1 -
 drivers/md/dm.c                               |  87 +--
 drivers/md/dm.h                               |  17 +-
 drivers/md/persistent-data/dm-array.c         |  82 +--
 drivers/md/persistent-data/dm-array.h         |   3 +-
 drivers/md/persistent-data/dm-bitset.c        |  14 +-
 drivers/md/persistent-data/dm-bitset.h        |   1 +
 drivers/md/persistent-data/dm-block-manager.c |  32 +-
 drivers/md/persistent-data/dm-block-manager.h |   7 +-
 .../md/persistent-data/dm-btree-internal.h    |   6 +-
 drivers/md/persistent-data/dm-btree-remove.c  |  52 +-
 drivers/md/persistent-data/dm-btree-spine.c   |  21 +-
 drivers/md/persistent-data/dm-btree.c         | 130 +++--
 drivers/md/persistent-data/dm-btree.h         |  15 +-
 .../dm-persistent-data-internal.h             |   7 +-
 .../md/persistent-data/dm-space-map-common.c  |  52 +-
 .../md/persistent-data/dm-space-map-common.h  |  11 +-
 .../md/persistent-data/dm-space-map-disk.c    |  13 +-
 .../md/persistent-data/dm-space-map-disk.h    |   1 +
 .../persistent-data/dm-space-map-metadata.c   |  24 +-
 .../persistent-data/dm-space-map-metadata.h   |   1 +
 drivers/md/persistent-data/dm-space-map.h     |   1 +
 .../persistent-data/dm-transaction-manager.c  |  18 +-
 .../persistent-data/dm-transaction-manager.h  |   3 +-
 include/linux/device-mapper.h                 |  60 +-
 include/linux/dm-bufio.h                      |  13 +-
 include/linux/dm-dirty-log.h                  |   9 +-
 include/linux/dm-io.h                         |   9 +-
 include/linux/dm-kcopyd.h                     |  23 +-
 include/linux/dm-region-hash.h                |   9 +-
 108 files changed, 2154 insertions(+), 1776 deletions(-)

-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

