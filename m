Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9E7AEEAA68
	for <dm-devel@archiver.kernel.org>; Thu, 14 Sep 2023 19:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694719038;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=D64jTWiMZnWL94rmutKkFug9hzDw9Cp/5f2OZKIuy6I=;
	b=fgOrtvGF4b89rxdbmHPTBjjZ1vBOjWUh/t1wA33jeLf69hBZ67AENQBxI8xbpLG6hcLGLI
	3U2tzVN5JSrns+z24sDG6obwHbXQ6isyUvopx+B6KjJoOVuuBwqJignrjFTLIeQGg1F3QU
	rBn6Yvv9yCZEQFKyxqpMIeNPVNqCCxE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-ZkDqNabRMSqCyXxDU-7RfQ-1; Thu, 14 Sep 2023 15:17:16 -0400
X-MC-Unique: ZkDqNabRMSqCyXxDU-7RfQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB4DD88B7A7;
	Thu, 14 Sep 2023 19:17:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 98C6A9A;
	Thu, 14 Sep 2023 19:17:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 18CE819466E7;
	Thu, 14 Sep 2023 19:16:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 15EDC1946588
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Sep 2023 19:16:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CC4E51054FC0; Thu, 14 Sep 2023 19:16:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C4A4C1054FC1
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:16:40 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A07C3801FA0
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:16:40 +0000 (UTC)
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com
 [209.85.222.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-368-guVKJqbcMtCUb-Z930Hhyg-1; Thu, 14 Sep 2023 15:16:39 -0400
X-MC-Unique: guVKJqbcMtCUb-Z930Hhyg-1
Received: by mail-qk1-f181.google.com with SMTP id
 af79cd13be357-770ef334b4fso65780685a.1
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 12:16:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694718998; x=1695323798;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=jGKwjEuwDCCOyaIw9a0c9gkJ4SBnHBOR+26G/Mlm+7w=;
 b=TP1fppgwZo1NQfgT4yc6ot8XVUdQ6TUm3Vqb0Bzjv2VAh5K9RRF4jE9ax+Ow1M321Y
 y1m4nDs5tVSonu9vhjEfHN9XX5zblquCD7srmT9j10bJHY4bhp9pHkRaSf4zD40Be3Fp
 v370KdGfLYEZMSvE4lKxmIKCMnvpFtR7nTF1l4APEANk8SX5ktx9SsqjwFqjo4I9Cb96
 5d9byQF4JdOun1v4BMB7FVftpNfvifhLpsNBv6mtltzGD3KdtzIyqqbWBY8vo9TEFHpW
 NFdfq1Qx8BEv5GVcFcGYy22VM8c5uNMnCJL8tC7rNszLW5lvm0eQp5NWoLHTq/Ih9aso
 CEDg==
X-Gm-Message-State: AOJu0Ywa792bT124XiYgaVYKqONrCM7Mtp2ZxBa4PH6fvmq1mcCMPgWh
 lvR5Q9oYKusvAfM3slbIQqeTYj4ShZdIgIvemATbEtbiweRPgyUwl6RN+nVwKbEHBw5B73y483J
 MPHvQ7egnhZChxqAqWQBjGgvbPfHDCxr0yJYBaErDwjh/wVWxPAfTPI7CdXeC9PRg6ZIEoTzz
X-Google-Smtp-Source: AGHT+IGQ5dN0hNnzVI+mbpmNpuq6jXwWJ/9kijxwidws+hczWQP+W1b1lHOzg5bjevBq72Ki4dGBRQ==
X-Received: by 2002:a05:620a:370a:b0:76f:5b9:3f29 with SMTP id
 de10-20020a05620a370a00b0076f05b93f29mr3292368qkb.2.1694718997794; 
 Thu, 14 Sep 2023 12:16:37 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 cx21-20020a05620a51d500b0076d74da4481sm676242qkb.23.2023.09.14.12.16.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Sep 2023 12:16:37 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Thu, 14 Sep 2023 15:15:56 -0400
Message-Id: <20230914191635.39805-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH v3 00/39] dm: baseline for the VDO target
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
Cc: Matthew Sakai <msakai@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

This patchset reflects a baseline of the VDO DM target.  It is still
very much under active review and development, and will likley
continue to be until the end of this year.  So while the code isn't
yet ready for upstream inclusion it will evolve so that one day it
hopefully is, and moving forward that evolution will be visible both
on dm-devel and in this linux-dm.git 'dm-vdo' branch:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-vdo

I've already made a series of changes to this baseline which are
visible on this 'dm-vdo-wip' branch:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-vdo-wip

As you'll see: a lot of coding style, whitespace, and data structure
and file renames -- and there is much more to come.

dm-vdo-wip will always be based on dm-vdo, but both branches will be
periodically rebased to track the main linux-dm.git upstream DM
changes over time (e.g. they are currently based on 'dm-6.5' but will
be rebased as needed).

I've been working with Matt Sakai to help him understand the upstream
Linux release cadance and associated git workflows.  Matt isn't yet
named in MAINTAINERS in the 'dm-vdo' branch but will be in the near
future. Matt will be the upstream maintainer for the dm-vdo target.

Thanks,
Mike

Matthew Sakai (39):
  dm: add documentation for dm-vdo target
  dm vdo: add the MurmurHash3 fast hashing algorithm
  dm vdo: add memory allocation utilities
  dm vdo: add basic logging and support utilities
  dm vdo: add type declarations, constants, and simple data structures
  dm vdo: add thread and synchronization utilities
  dm vdo: add specialized request queueing functionality
  dm vdo: add basic hash map data structures
  dm vdo: add deduplication configuration structures
  dm vdo: add deduplication index storage interface
  dm vdo: implement the delta index
  dm vdo: implement the volume index
  dm vdo: implement the open chapter and chapter indexes
  dm vdo: implement the chapter volume store
  dm vdo: implement top-level deduplication index
  dm vdo: implement external deduplication index interface
  dm vdo: add administrative state and action manager
  dm vdo: add vio, the request object for vdo metadata
  dm vdo: add data_vio, the request object which services incoming bios
  dm vdo: add flush support
  dm vdo: add the io_submitter
  dm vdo: add hash locks and hash zones
  dm vdo: add use of the deduplication index in hash zones
  dm vdo: add the compressed block bin packer
  dm vdo: add slab structure, slab journal and reference counters
  dm vdo: add the slab summary
  dm vdo: add the block allocators and physical zones
  dm vdo: add the slab depot
  dm vdo: add the block map
  dm vdo: implement the vdo block map page cache
  dm vdo: add the vdo recovery journal
  dm vdo: add repair of damanged vdo volumes
  dm vdo: add the vdo structure itself
  dm vdo: add the on-disk formats and marshalling of vdo structures
  dm vdo: add statistics reporting
  dm vdo: add sysfs support for setting vdo params and reading stats
  dm vdo: add debugging support
  dm vdo: add the top-level DM target
  dm vdo: enable configuration and building of dm-vdo

 .../admin-guide/device-mapper/vdo-design.rst  |  415 ++
 .../admin-guide/device-mapper/vdo.rst         |  388 ++
 drivers/md/Kconfig                            |   16 +
 drivers/md/Makefile                           |    2 +
 drivers/md/dm-vdo-target.c                    | 2982 ++++++++++
 drivers/md/dm-vdo/action-manager.c            |  410 ++
 drivers/md/dm-vdo/action-manager.h            |  117 +
 drivers/md/dm-vdo/admin-state.c               |  512 ++
 drivers/md/dm-vdo/admin-state.h               |  180 +
 drivers/md/dm-vdo/block-map.c                 | 3376 +++++++++++
 drivers/md/dm-vdo/block-map.h                 |  397 ++
 drivers/md/dm-vdo/chapter-index.c             |  304 +
 drivers/md/dm-vdo/chapter-index.h             |   66 +
 drivers/md/dm-vdo/completion.c                |  141 +
 drivers/md/dm-vdo/completion.h                |  155 +
 drivers/md/dm-vdo/config.c                    |  389 ++
 drivers/md/dm-vdo/config.h                    |  125 +
 drivers/md/dm-vdo/constants.c                 |   15 +
 drivers/md/dm-vdo/constants.h                 |  102 +
 drivers/md/dm-vdo/cpu.h                       |   58 +
 drivers/md/dm-vdo/data-vio.c                  | 2076 +++++++
 drivers/md/dm-vdo/data-vio.h                  |  683 +++
 drivers/md/dm-vdo/dedupe.c                    | 3073 ++++++++++
 drivers/md/dm-vdo/dedupe.h                    |  119 +
 drivers/md/dm-vdo/delta-index.c               | 2018 +++++++
 drivers/md/dm-vdo/delta-index.h               |  292 +
 drivers/md/dm-vdo/dump.c                      |  288 +
 drivers/md/dm-vdo/dump.h                      |   17 +
 drivers/md/dm-vdo/encodings.c                 | 1488 +++++
 drivers/md/dm-vdo/encodings.h                 | 1307 +++++
 drivers/md/dm-vdo/errors.c                    |  316 +
 drivers/md/dm-vdo/errors.h                    |   83 +
 drivers/md/dm-vdo/flush.c                     |  563 ++
 drivers/md/dm-vdo/flush.h                     |   44 +
 drivers/md/dm-vdo/funnel-queue.c              |  169 +
 drivers/md/dm-vdo/funnel-queue.h              |  110 +
 drivers/md/dm-vdo/geometry.c                  |  205 +
 drivers/md/dm-vdo/geometry.h                  |  137 +
 drivers/md/dm-vdo/hash-utils.h                |   66 +
 drivers/md/dm-vdo/index-layout.c              | 1775 ++++++
 drivers/md/dm-vdo/index-layout.h              |   42 +
 drivers/md/dm-vdo/index-page-map.c            |  181 +
 drivers/md/dm-vdo/index-page-map.h            |   54 +
 drivers/md/dm-vdo/index-session.c             |  815 +++
 drivers/md/dm-vdo/index-session.h             |   84 +
 drivers/md/dm-vdo/index.c                     | 1403 +++++
 drivers/md/dm-vdo/index.h                     |   83 +
 drivers/md/dm-vdo/int-map.c                   |  710 +++
 drivers/md/dm-vdo/int-map.h                   |   40 +
 drivers/md/dm-vdo/io-factory.c                |  472 ++
 drivers/md/dm-vdo/io-factory.h                |   66 +
 drivers/md/dm-vdo/io-submitter.c              |  483 ++
 drivers/md/dm-vdo/io-submitter.h              |   52 +
 drivers/md/dm-vdo/logger.c                    |  304 +
 drivers/md/dm-vdo/logger.h                    |  112 +
 drivers/md/dm-vdo/logical-zone.c              |  378 ++
 drivers/md/dm-vdo/logical-zone.h              |   87 +
 drivers/md/dm-vdo/memory-alloc.c              |  447 ++
 drivers/md/dm-vdo/memory-alloc.h              |  181 +
 drivers/md/dm-vdo/message-stats.c             | 1215 ++++
 drivers/md/dm-vdo/message-stats.h             |   13 +
 drivers/md/dm-vdo/murmurhash3.c               |  175 +
 drivers/md/dm-vdo/murmurhash3.h               |   15 +
 drivers/md/dm-vdo/numeric.h                   |   78 +
 drivers/md/dm-vdo/open-chapter.c              |  433 ++
 drivers/md/dm-vdo/open-chapter.h              |   79 +
 drivers/md/dm-vdo/packer.c                    |  794 +++
 drivers/md/dm-vdo/packer.h                    |  123 +
 drivers/md/dm-vdo/permassert.c                |   35 +
 drivers/md/dm-vdo/permassert.h                |   65 +
 drivers/md/dm-vdo/physical-zone.c             |  650 ++
 drivers/md/dm-vdo/physical-zone.h             |  115 +
 drivers/md/dm-vdo/pointer-map.c               |  691 +++
 drivers/md/dm-vdo/pointer-map.h               |   81 +
 drivers/md/dm-vdo/pool-sysfs-stats.c          | 2063 +++++++
 drivers/md/dm-vdo/pool-sysfs.c                |  193 +
 drivers/md/dm-vdo/pool-sysfs.h                |   19 +
 drivers/md/dm-vdo/priority-table.c            |  226 +
 drivers/md/dm-vdo/priority-table.h            |   48 +
 drivers/md/dm-vdo/radix-sort.c                |  349 ++
 drivers/md/dm-vdo/radix-sort.h                |   28 +
 drivers/md/dm-vdo/recovery-journal.c          | 1772 ++++++
 drivers/md/dm-vdo/recovery-journal.h          |  313 +
 drivers/md/dm-vdo/repair.c                    | 1775 ++++++
 drivers/md/dm-vdo/repair.h                    |   14 +
 drivers/md/dm-vdo/request-queue.c             |  284 +
 drivers/md/dm-vdo/request-queue.h             |   30 +
 drivers/md/dm-vdo/slab-depot.c                | 5213 +++++++++++++++++
 drivers/md/dm-vdo/slab-depot.h                |  594 ++
 drivers/md/dm-vdo/sparse-cache.c              |  595 ++
 drivers/md/dm-vdo/sparse-cache.h              |   49 +
 drivers/md/dm-vdo/statistics.h                |  278 +
 drivers/md/dm-vdo/status-codes.c              |  126 +
 drivers/md/dm-vdo/status-codes.h              |  112 +
 drivers/md/dm-vdo/string-utils.c              |   28 +
 drivers/md/dm-vdo/string-utils.h              |   23 +
 drivers/md/dm-vdo/sysfs.c                     |   84 +
 drivers/md/dm-vdo/thread-cond-var.c           |   46 +
 drivers/md/dm-vdo/thread-device.c             |   35 +
 drivers/md/dm-vdo/thread-device.h             |   19 +
 drivers/md/dm-vdo/thread-registry.c           |   93 +
 drivers/md/dm-vdo/thread-registry.h           |   33 +
 drivers/md/dm-vdo/time-utils.h                |   28 +
 drivers/md/dm-vdo/types.h                     |  393 ++
 drivers/md/dm-vdo/uds-sysfs.c                 |  185 +
 drivers/md/dm-vdo/uds-sysfs.h                 |   12 +
 drivers/md/dm-vdo/uds-threads.c               |  186 +
 drivers/md/dm-vdo/uds-threads.h               |  115 +
 drivers/md/dm-vdo/uds.h                       |  334 ++
 drivers/md/dm-vdo/vdo.c                       | 1845 ++++++
 drivers/md/dm-vdo/vdo.h                       |  381 ++
 drivers/md/dm-vdo/vio.c                       |  525 ++
 drivers/md/dm-vdo/vio.h                       |  221 +
 drivers/md/dm-vdo/volume-index.c              | 1277 ++++
 drivers/md/dm-vdo/volume-index.h              |  192 +
 drivers/md/dm-vdo/volume.c                    | 1792 ++++++
 drivers/md/dm-vdo/volume.h                    |  174 +
 drivers/md/dm-vdo/wait-queue.c                |  223 +
 drivers/md/dm-vdo/wait-queue.h                |  129 +
 drivers/md/dm-vdo/work-queue.c                |  659 +++
 drivers/md/dm-vdo/work-queue.h                |   53 +
 121 files changed, 58701 insertions(+)
 create mode 100644 Documentation/admin-guide/device-mapper/vdo-design.rst
 create mode 100644 Documentation/admin-guide/device-mapper/vdo.rst
 create mode 100644 drivers/md/dm-vdo-target.c
 create mode 100644 drivers/md/dm-vdo/action-manager.c
 create mode 100644 drivers/md/dm-vdo/action-manager.h
 create mode 100644 drivers/md/dm-vdo/admin-state.c
 create mode 100644 drivers/md/dm-vdo/admin-state.h
 create mode 100644 drivers/md/dm-vdo/block-map.c
 create mode 100644 drivers/md/dm-vdo/block-map.h
 create mode 100644 drivers/md/dm-vdo/chapter-index.c
 create mode 100644 drivers/md/dm-vdo/chapter-index.h
 create mode 100644 drivers/md/dm-vdo/completion.c
 create mode 100644 drivers/md/dm-vdo/completion.h
 create mode 100644 drivers/md/dm-vdo/config.c
 create mode 100644 drivers/md/dm-vdo/config.h
 create mode 100644 drivers/md/dm-vdo/constants.c
 create mode 100644 drivers/md/dm-vdo/constants.h
 create mode 100644 drivers/md/dm-vdo/cpu.h
 create mode 100644 drivers/md/dm-vdo/data-vio.c
 create mode 100644 drivers/md/dm-vdo/data-vio.h
 create mode 100644 drivers/md/dm-vdo/dedupe.c
 create mode 100644 drivers/md/dm-vdo/dedupe.h
 create mode 100644 drivers/md/dm-vdo/delta-index.c
 create mode 100644 drivers/md/dm-vdo/delta-index.h
 create mode 100644 drivers/md/dm-vdo/dump.c
 create mode 100644 drivers/md/dm-vdo/dump.h
 create mode 100644 drivers/md/dm-vdo/encodings.c
 create mode 100644 drivers/md/dm-vdo/encodings.h
 create mode 100644 drivers/md/dm-vdo/errors.c
 create mode 100644 drivers/md/dm-vdo/errors.h
 create mode 100644 drivers/md/dm-vdo/flush.c
 create mode 100644 drivers/md/dm-vdo/flush.h
 create mode 100644 drivers/md/dm-vdo/funnel-queue.c
 create mode 100644 drivers/md/dm-vdo/funnel-queue.h
 create mode 100644 drivers/md/dm-vdo/geometry.c
 create mode 100644 drivers/md/dm-vdo/geometry.h
 create mode 100644 drivers/md/dm-vdo/hash-utils.h
 create mode 100644 drivers/md/dm-vdo/index-layout.c
 create mode 100644 drivers/md/dm-vdo/index-layout.h
 create mode 100644 drivers/md/dm-vdo/index-page-map.c
 create mode 100644 drivers/md/dm-vdo/index-page-map.h
 create mode 100644 drivers/md/dm-vdo/index-session.c
 create mode 100644 drivers/md/dm-vdo/index-session.h
 create mode 100644 drivers/md/dm-vdo/index.c
 create mode 100644 drivers/md/dm-vdo/index.h
 create mode 100644 drivers/md/dm-vdo/int-map.c
 create mode 100644 drivers/md/dm-vdo/int-map.h
 create mode 100644 drivers/md/dm-vdo/io-factory.c
 create mode 100644 drivers/md/dm-vdo/io-factory.h
 create mode 100644 drivers/md/dm-vdo/io-submitter.c
 create mode 100644 drivers/md/dm-vdo/io-submitter.h
 create mode 100644 drivers/md/dm-vdo/logger.c
 create mode 100644 drivers/md/dm-vdo/logger.h
 create mode 100644 drivers/md/dm-vdo/logical-zone.c
 create mode 100644 drivers/md/dm-vdo/logical-zone.h
 create mode 100644 drivers/md/dm-vdo/memory-alloc.c
 create mode 100644 drivers/md/dm-vdo/memory-alloc.h
 create mode 100644 drivers/md/dm-vdo/message-stats.c
 create mode 100644 drivers/md/dm-vdo/message-stats.h
 create mode 100644 drivers/md/dm-vdo/murmurhash3.c
 create mode 100644 drivers/md/dm-vdo/murmurhash3.h
 create mode 100644 drivers/md/dm-vdo/numeric.h
 create mode 100644 drivers/md/dm-vdo/open-chapter.c
 create mode 100644 drivers/md/dm-vdo/open-chapter.h
 create mode 100644 drivers/md/dm-vdo/packer.c
 create mode 100644 drivers/md/dm-vdo/packer.h
 create mode 100644 drivers/md/dm-vdo/permassert.c
 create mode 100644 drivers/md/dm-vdo/permassert.h
 create mode 100644 drivers/md/dm-vdo/physical-zone.c
 create mode 100644 drivers/md/dm-vdo/physical-zone.h
 create mode 100644 drivers/md/dm-vdo/pointer-map.c
 create mode 100644 drivers/md/dm-vdo/pointer-map.h
 create mode 100644 drivers/md/dm-vdo/pool-sysfs-stats.c
 create mode 100644 drivers/md/dm-vdo/pool-sysfs.c
 create mode 100644 drivers/md/dm-vdo/pool-sysfs.h
 create mode 100644 drivers/md/dm-vdo/priority-table.c
 create mode 100644 drivers/md/dm-vdo/priority-table.h
 create mode 100644 drivers/md/dm-vdo/radix-sort.c
 create mode 100644 drivers/md/dm-vdo/radix-sort.h
 create mode 100644 drivers/md/dm-vdo/recovery-journal.c
 create mode 100644 drivers/md/dm-vdo/recovery-journal.h
 create mode 100644 drivers/md/dm-vdo/repair.c
 create mode 100644 drivers/md/dm-vdo/repair.h
 create mode 100644 drivers/md/dm-vdo/request-queue.c
 create mode 100644 drivers/md/dm-vdo/request-queue.h
 create mode 100644 drivers/md/dm-vdo/slab-depot.c
 create mode 100644 drivers/md/dm-vdo/slab-depot.h
 create mode 100644 drivers/md/dm-vdo/sparse-cache.c
 create mode 100644 drivers/md/dm-vdo/sparse-cache.h
 create mode 100644 drivers/md/dm-vdo/statistics.h
 create mode 100644 drivers/md/dm-vdo/status-codes.c
 create mode 100644 drivers/md/dm-vdo/status-codes.h
 create mode 100644 drivers/md/dm-vdo/string-utils.c
 create mode 100644 drivers/md/dm-vdo/string-utils.h
 create mode 100644 drivers/md/dm-vdo/sysfs.c
 create mode 100644 drivers/md/dm-vdo/thread-cond-var.c
 create mode 100644 drivers/md/dm-vdo/thread-device.c
 create mode 100644 drivers/md/dm-vdo/thread-device.h
 create mode 100644 drivers/md/dm-vdo/thread-registry.c
 create mode 100644 drivers/md/dm-vdo/thread-registry.h
 create mode 100644 drivers/md/dm-vdo/time-utils.h
 create mode 100644 drivers/md/dm-vdo/types.h
 create mode 100644 drivers/md/dm-vdo/uds-sysfs.c
 create mode 100644 drivers/md/dm-vdo/uds-sysfs.h
 create mode 100644 drivers/md/dm-vdo/uds-threads.c
 create mode 100644 drivers/md/dm-vdo/uds-threads.h
 create mode 100644 drivers/md/dm-vdo/uds.h
 create mode 100644 drivers/md/dm-vdo/vdo.c
 create mode 100644 drivers/md/dm-vdo/vdo.h
 create mode 100644 drivers/md/dm-vdo/vio.c
 create mode 100644 drivers/md/dm-vdo/vio.h
 create mode 100644 drivers/md/dm-vdo/volume-index.c
 create mode 100644 drivers/md/dm-vdo/volume-index.h
 create mode 100644 drivers/md/dm-vdo/volume.c
 create mode 100644 drivers/md/dm-vdo/volume.h
 create mode 100644 drivers/md/dm-vdo/wait-queue.c
 create mode 100644 drivers/md/dm-vdo/wait-queue.h
 create mode 100644 drivers/md/dm-vdo/work-queue.c
 create mode 100644 drivers/md/dm-vdo/work-queue.h

-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

