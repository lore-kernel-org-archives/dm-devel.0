Return-Path: <SRS0=t7n3=MW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4887DC432BE
	for <dm-devel@archiver.kernel.org>; Fri, 30 Jul 2021 13:55:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6E7CB60F94
	for <dm-devel@archiver.kernel.org>; Fri, 30 Jul 2021 13:55:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6E7CB60F94
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-EHDnHoFiM7GUX02h3cdIwA-1; Fri, 30 Jul 2021 09:55:03 -0400
X-MC-Unique: EHDnHoFiM7GUX02h3cdIwA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DDBA80292B;
	Fri, 30 Jul 2021 13:54:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 125DC5278E;
	Fri, 30 Jul 2021 13:54:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D7BE74A700;
	Fri, 30 Jul 2021 13:54:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16UA2IMn022145 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 30 Jul 2021 06:02:18 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 29C7A2102B30; Fri, 30 Jul 2021 10:02:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 242E42102B2F
	for <dm-devel@redhat.com>; Fri, 30 Jul 2021 10:02:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F10B31802CE2
	for <dm-devel@redhat.com>; Fri, 30 Jul 2021 10:02:14 +0000 (UTC)
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by relay.mimecast.com with ESMTP id us-mta-408-1LKxfxXCN5OmiysgHZWzIg-1;
	Fri, 30 Jul 2021 06:02:09 -0400
X-MC-Unique: 1LKxfxXCN5OmiysgHZWzIg-1
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3A8+cL/arpl8z7A3Y9qNRPyyEaV5rDeYIsimQD?=
	=?us-ascii?q?101hICG8cqSj+fxG+85rsSMc6QxhP03I9urhBEDtex/hHP1OkOws1NWZLWrbUQ?=
	=?us-ascii?q?KTRekIh+bfKlbbehEWmNQz6U4ZSdkdNDTvNykAse/KpBm/D807wMSKtIShheLl?=
	=?us-ascii?q?xX9rSg1wApsQljtRO0KKFFFsXglaCd4cHJqY3MBOoD2tYjA5dcK+b0N1J9Trlp?=
	=?us-ascii?q?nako78ex4aC1oC4AmKtzmh77n3CFy5834lIlVy/Ys=3D?=
X-IronPort-AV: E=Sophos;i="5.84,281,1620662400"; d="scan'208";a="112074003"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 30 Jul 2021 18:02:07 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 8FBC94D0D49D;
	Fri, 30 Jul 2021 18:02:01 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
	G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP
	Server (TLS) id 15.0.1497.23; Fri, 30 Jul 2021 18:02:01 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
	G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP
	Server
	id 15.0.1497.23 via Frontend Transport; Fri, 30 Jul 2021 18:02:00 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>
Date: Fri, 30 Jul 2021 18:01:49 +0800
Message-ID: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
X-yoursite-MailScanner-ID: 8FBC94D0D49D.A3938
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 30 Jul 2021 09:53:42 -0400
Cc: snitzer@redhat.com, djwong@kernel.org, david@fromorbit.com,
	dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: [dm-devel] [PATCH RESEND v6 0/9] fsdax: introduce fs query to
	support reflink
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patchset is aimed to support shared pages tracking for fsdax.

Changes for RESEND:
  - update the title of patch 6
  - update the wrong email address of one receiver

Changes from V5:
  - fix dax_load_pfn(), take locked,empty,zero dax entry into
       consideration
  - fix the usage of rwsem lock for dax_device's holder
  - fix build error reported by kernelbot
  - keep functionality of dax_{,dis}assocaite_entry() for filesystems
       doesn't have rmapbt feature
  - Rebased to v5.14-rc3

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

(Rebased on v5.14-rc3)
==

Shiyang Ruan (9):
  pagemap: Introduce ->memory_failure()
  dax: Introduce holder for dax_device
  mm: factor helpers for memory_failure_dev_pagemap
  pmem,mm: Implement ->memory_failure in pmem driver
  mm: Introduce mf_dax_kill_procs() for fsdax case
  xfs: Implement ->notify_failure() for XFS
  dm: Introduce ->rmap() to find bdev offset
  md: Implement dax_holder_operations
  fsdax: add exception for reflinked files

 block/genhd.c                 |  56 +++++++++++
 drivers/dax/super.c           |  58 ++++++++++++
 drivers/md/dm-linear.c        |  20 ++++
 drivers/md/dm.c               | 126 ++++++++++++++++++++++++-
 drivers/nvdimm/pmem.c         |  13 +++
 fs/dax.c                      |  59 ++++++++----
 fs/xfs/xfs_fsops.c            |   5 +
 fs/xfs/xfs_mount.h            |   1 +
 fs/xfs/xfs_super.c            | 135 +++++++++++++++++++++++++++
 include/linux/dax.h           |  46 +++++++++
 include/linux/device-mapper.h |   5 +
 include/linux/genhd.h         |   1 +
 include/linux/memremap.h      |   9 ++
 include/linux/mm.h            |  10 ++
 mm/memory-failure.c           | 169 +++++++++++++++++++++++-----------
 15 files changed, 641 insertions(+), 72 deletions(-)

-- 
2.32.0



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

