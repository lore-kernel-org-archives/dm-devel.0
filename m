Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AB46FC5
	for <dm-devel@lists.linux.dev>; Sat, 11 Nov 2023 04:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VZmUey24"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699677050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WHKUzCujTCQXQ8MfrEp01hdmYf4+Dp1Vpzzb9nmBKSA=;
	b=VZmUey24sCjU5k8KnDPJPP4kTXVXYN97NtVijaFo+2EybBmi5A6ib90mrKlQQ7DZ7RrfaA
	kkknhegKjBscL5FHwK2f5+jZdVwlIqUOop9HbmmONn8M1za14qJPtOZyWjF79twEdOaNv6
	sRud3FGE/abZdPnyiqPkLSNtn4JXgSA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-He3BrgZfM--TFnGN621JRA-1; Fri, 10 Nov 2023 23:30:45 -0500
X-MC-Unique: He3BrgZfM--TFnGN621JRA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B511811E7D;
	Sat, 11 Nov 2023 04:30:45 +0000 (UTC)
Received: from pbitcolo-build-10.permabit.com (pbitcolo-build-10.permabit.lab.eng.bos.redhat.com [10.19.117.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2BFA72026D4C;
	Sat, 11 Nov 2023 04:30:45 +0000 (UTC)
Received: by pbitcolo-build-10.permabit.com (Postfix, from userid 1138)
	id D22553003D; Fri, 10 Nov 2023 23:30:44 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/8] dm vdo memory-alloc: improve interface
Date: Fri, 10 Nov 2023 23:30:35 -0500
Message-ID: <cover.1699676411.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
Message-ID: <20231111043035.RJ-TCimuCewAVxnGOvg8eUNkL91tDuCThuud_GEDr_A@z>

This patchset includes various fixes to make the interface to the
dm-vdo memory allocator cleaner.

Mike Snitzer (8):
  dm vdo memory-alloc: remove UDS_ALLOCATE_NOWAIT macro
  dm vdo memory-alloc: rename UDS_FORGET to uds_forget
  dm vdo memory-alloc: rename UDS_FREE to uds_free
  dm vdo memory-alloc: rename UDS_ALLOCATE to uds_allocate
  dm vdo memory-alloc: rename UDS_ALLOCATE_EXTENDED to
    uds_allocate_extended
  dm vdo memory-alloc: rename uds_free_memory to uds_free
  dm vdo memory-alloc: cleanup flow of memory-alloc.h
  dm vdo memory-alloc: mark branch unlikely() in uds_allocate_memory()

 drivers/md/dm-vdo-target.c              | 36 +++++------
 drivers/md/dm-vdo/action-manager.c      |  2 +-
 drivers/md/dm-vdo/admin-state.c         |  2 +-
 drivers/md/dm-vdo/block-map.c           | 58 ++++++++---------
 drivers/md/dm-vdo/chapter-index.c       |  6 +-
 drivers/md/dm-vdo/config.c              |  4 +-
 drivers/md/dm-vdo/data-vio.c            | 18 +++---
 drivers/md/dm-vdo/dedupe.c              | 30 ++++-----
 drivers/md/dm-vdo/delta-index.c         | 20 +++---
 drivers/md/dm-vdo/encodings.c           |  4 +-
 drivers/md/dm-vdo/flush.c               | 12 ++--
 drivers/md/dm-vdo/funnel-queue.c        |  4 +-
 drivers/md/dm-vdo/funnel-requestqueue.c |  4 +-
 drivers/md/dm-vdo/funnel-workqueue.c    | 26 ++++----
 drivers/md/dm-vdo/geometry.c            |  4 +-
 drivers/md/dm-vdo/index-layout.c        | 58 ++++++++---------
 drivers/md/dm-vdo/index-page-map.c      | 20 +++---
 drivers/md/dm-vdo/index-session.c       | 14 ++--
 drivers/md/dm-vdo/index.c               | 28 ++++----
 drivers/md/dm-vdo/int-map.c             | 14 ++--
 drivers/md/dm-vdo/io-factory.c          | 14 ++--
 drivers/md/dm-vdo/io-submitter.c        | 10 +--
 drivers/md/dm-vdo/logical-zone.c        |  8 +--
 drivers/md/dm-vdo/memory-alloc.c        | 24 +++----
 drivers/md/dm-vdo/memory-alloc.h        | 65 +++++++++----------
 drivers/md/dm-vdo/message-stats.c       |  4 +-
 drivers/md/dm-vdo/open-chapter.c        |  6 +-
 drivers/md/dm-vdo/packer.c              | 14 ++--
 drivers/md/dm-vdo/physical-zone.c       | 16 ++---
 drivers/md/dm-vdo/pointer-map.c         | 14 ++--
 drivers/md/dm-vdo/pool-sysfs.c          |  2 +-
 drivers/md/dm-vdo/priority-table.c      |  4 +-
 drivers/md/dm-vdo/radix-sort.c          |  4 +-
 drivers/md/dm-vdo/recovery-journal.c    | 36 +++++------
 drivers/md/dm-vdo/repair.c              | 24 +++----
 drivers/md/dm-vdo/slab-depot.c          | 80 +++++++++++------------
 drivers/md/dm-vdo/slab-depot.h          |  2 +-
 drivers/md/dm-vdo/sparse-cache.c        | 18 +++---
 drivers/md/dm-vdo/uds-sysfs.c           |  4 +-
 drivers/md/dm-vdo/uds-threads.c         |  6 +-
 drivers/md/dm-vdo/vdo.c                 | 86 ++++++++++++-------------
 drivers/md/dm-vdo/vio.c                 | 20 +++---
 drivers/md/dm-vdo/volume-index.c        | 16 ++---
 drivers/md/dm-vdo/volume.c              | 36 +++++------
 44 files changed, 434 insertions(+), 443 deletions(-)

-- 
2.40.0

