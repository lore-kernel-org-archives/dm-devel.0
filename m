Return-Path: <SRS0=s8Rv=LW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C75AC49EA7
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:53:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D297261C5D
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:53:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D297261C5D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-noe3ONKyOiWJKWhqtrPcLg-1; Mon, 28 Jun 2021 05:53:01 -0400
X-MC-Unique: noe3ONKyOiWJKWhqtrPcLg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97A1780BCAD;
	Mon, 28 Jun 2021 09:52:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 56E1810074FD;
	Mon, 28 Jun 2021 09:52:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0328F1809CB3;
	Mon, 28 Jun 2021 09:52:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15S03BFh027035 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 27 Jun 2021 20:03:11 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1BBA41111C6B; Mon, 28 Jun 2021 00:03:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 16E431111C6A
	for <dm-devel@redhat.com>; Mon, 28 Jun 2021 00:03:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 884E3800B28
	for <dm-devel@redhat.com>; Mon, 28 Jun 2021 00:03:07 +0000 (UTC)
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by relay.mimecast.com with ESMTP id us-mta-526-pllZt0qEPfes1yqrL8efaA-2;
	Sun, 27 Jun 2021 20:03:03 -0400
X-MC-Unique: pllZt0qEPfes1yqrL8efaA-2
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AV8gBeKG6lsoZXInUpLqEAMeALOsnbusQ8zAX?=
	=?us-ascii?q?P0AYc3Jom6uj5qSTdZUgpHjJYVkqOE3I9ertBEDiewK4yXcW2/hzAV7KZmCP0w?=
	=?us-ascii?q?HEEGgI1+rfKlPbdBEWjtQtt5uIbZIOc+HYPBxri9rg+gmkH5IFyNmDyqqhguDT?=
	=?us-ascii?q?1B5WPHhXQpAl/wFkERyaD0EzYAFHAKAyHJ2a6tECiCGnfR0sH7yGL0hAT+7evM?=
	=?us-ascii?q?fKiZ6jRRYHAiQs4A6IgSjtyJOSKWn/4isj?=
X-IronPort-AV: E=Sophos;i="5.83,304,1616428800"; d="scan'208";a="110256323"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 28 Jun 2021 08:02:57 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 28CF14D0BA69;
	Mon, 28 Jun 2021 08:02:53 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
	G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Mon, 28 Jun 2021 08:02:44 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
	G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP
	Server
	id 15.0.1497.2 via Frontend Transport; Mon, 28 Jun 2021 08:02:22 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>
Date: Mon, 28 Jun 2021 08:02:09 +0800
Message-ID: <20210628000218.387833-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
X-yoursite-MailScanner-ID: 28CF14D0BA69.A2AEF
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 28 Jun 2021 05:52:34 -0400
Cc: snitzer@redhat.com, darrick.wong@oracle.com, rgoldwyn@suse.de,
	david@fromorbit.com, dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: [dm-devel] [PATCH v5 0/9] fsdax: introduce fs query to support
	reflink
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patchset is aimed to support shared pages tracking for fsdax.

Change from V4:
  - Add nr_pfns for ->memory_failure() to support range based notification
  - Remove struct bdev in dax_holder_notify_failure()
  - Add rwsem for dax_holder
  - Rename functions to (*_)notify_failure()
  - Remove sb->corrupted_range(), implement holder_ops in filesystem and
      MD driver instead
  - Reorganize the patchset, make it easy to review
  - Rebased to v5.13-rc7

This patchset moves owner tracking from dax_assocaite_entry() to pmem
device driver, by introducing an interface ->memory_failure() for struct
pagemap.  This interface is called by memory_failure() in mm, and
implemented by pmem device.

Then call holder operations to find the filesystem which the corrupted
data located in, and call filesystem handler to track files or metadata
associated with this page.

Finally we are able to try to fix the corrupted data in filesystem and
do other necessary processing, such as killing processes who are using
the files affected.

The call trace is like this:
memory_failure()
|* fsdax case
|------------
|pgmap->ops->memory_failure()      => pmem_pgmap_memory_failure()
| dax_holder_notify_failure()      =>
|  dax_device->holder_ops->notify_failure() =>
|                                     - xfs_dax_notify_failure()
|                                     - md_dax_notify_failure()
|  |* xfs_dax_notify_failure()
|  |--------------------------
|  |   xfs_rmap_query_range()
|  |    xfs_currupt_helper()
|  |    * corrupted on metadata
|  |       try to recover data, call xfs_force_shutdown()
|  |    * corrupted on file data
|  |       try to recover data, call mf_dax_kill_procs()
|  |* md_dax_notify_failure()
|  |-------------------------
|      md_targets->iterate_devices()
|      md_targets->rmap()          => linear_rmap()
|       dax_holder_notify_failure()
|* normal case
|-------------
 mf_generic_kill_procs()

The fsdax & reflink support for XFS is not contained in this patchset.

(Rebased on v5.13-rc7)
==

Shiyang Ruan (9):
  pagemap: Introduce ->memory_failure()
  dax: Introduce holder for dax_device
  mm: factor helpers for memory_failure_dev_pagemap
  pmem,mm: Implement ->memory_failure in pmem driver
  mm: Introduce mf_dax_kill_procs() for fsdax case
  xfs: Implement ->corrupted_range() for XFS
  dm: Introduce ->rmap() to find bdev offset
  md: Implement dax_holder_operations
  fs/dax: Remove useless functions

 block/genhd.c                 |  30 +++++++
 drivers/dax/super.c           |  49 ++++++++++
 drivers/md/dm-linear.c        |  20 +++++
 drivers/md/dm.c               | 126 +++++++++++++++++++++++++-
 drivers/nvdimm/pmem.c         |  13 +++
 fs/dax.c                      |  73 ++++-----------
 fs/xfs/xfs_fsops.c            |   5 ++
 fs/xfs/xfs_mount.h            |   1 +
 fs/xfs/xfs_super.c            | 140 +++++++++++++++++++++++++++++
 include/linux/dax.h           |  27 ++++++
 include/linux/device-mapper.h |   5 ++
 include/linux/genhd.h         |   1 +
 include/linux/memremap.h      |   9 ++
 include/linux/mm.h            |  10 +++
 mm/memory-failure.c           | 165 ++++++++++++++++++++++------------
 15 files changed, 564 insertions(+), 110 deletions(-)

--
2.32.0



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

