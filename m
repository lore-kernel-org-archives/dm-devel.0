Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1BE2798E8
	for <dm-devel@lists.linux.dev>; Fri, 27 Feb 2026 01:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772154733; cv=none; b=MqPJFmDOjl3PBIVvT+4SKt0C5m26eYJP4RdSTT+7AeyxxWDrnHf6rVNYvtU20PVPw5cXGxhQIO0fyxrZm167v5rs/g5g/KRHbhAyIItjbPaydIvF40aZxVNUfScbuwGcN1BN7GkigoW3OJjkT/6BGDfbtGCnpMA2gvomBdlA2LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772154733; c=relaxed/simple;
	bh=C/aiYDMvb0AqKNeV0pALIQtNxQXBzumY7lL9roVMFyE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=uW3D7MuJBN9lSlKVcboBqjJpr8lnxv7tXVue4JiN+BQITzRH+9VFiv5dQ+yXtdb+XpLwajQjg7n8uiFhK+IYiFL9WjazPL2ReViEdyajtLcnbL7uc3C6t11GFOEFDWRwUiKhUC4x9YzEAmLnf0X7Gvc/vLqwqBtxwYezzeT0ds8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EItx62Pf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EItx62Pf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772154731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uI8PuwFAEtAXTh1HRB6jnHOFl8WnCRrPfHml/Awp/B4=;
	b=EItx62Pfi7Wo+Vl/Jr4UuwQHbIBek/2jjGrq1eg0qdQBOi7L7PQHB5Yr2m45u5ZaXSXjU5
	C2Tt2uVixBYZMbzkb2bmjHw8QSigyki3QVnJsgkaHHVyW24ICD5Rfv6oUN7IhM1GV17EAN
	3G6HUivYb6uKJXi1h5XNxjNc+P48eCM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-9C9XVLxEPz2e7HpJCSLhDA-1; Thu,
 26 Feb 2026 20:12:09 -0500
X-MC-Unique: 9C9XVLxEPz2e7HpJCSLhDA-1
X-Mimecast-MFC-AGG-ID: 9C9XVLxEPz2e7HpJCSLhDA_1772154729
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E183F1956060
	for <dm-devel@lists.linux.dev>; Fri, 27 Feb 2026 01:12:08 +0000 (UTC)
Received: from vdo-builder-raeburn.permabit.com (unknown [10.0.101.17])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AFAC6180058A;
	Fri, 27 Feb 2026 01:12:08 +0000 (UTC)
Received: by vdo-builder-raeburn.permabit.com (Postfix, from userid 1065)
	id 2D36D25690; Thu, 26 Feb 2026 20:12:08 -0500 (EST)
From: Ken Raeburn <raeburn@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Ken Raeburn <raeburn@redhat.com>
Subject: [PATCH 0/3] dm vdo: update struct allocation and add flexible-array annotations
Date: Thu, 26 Feb 2026 20:12:05 -0500
Message-ID: <cover.1772153845.git.raeburn@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gzYFmZ2tHf1LBZcmwopHxRyoIgk1LaAPEwnWtsQ0IQI_1772154729
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

These patches update VDO's structure management to better align with
other kernel behavior: using overflow.h macros when computing
allocation sizes, and adding __counted_by annotations to structures
where appropriate.

Ken Raeburn (3):
  dm vdo: update vdo_allocate_extended to take a field name, no types
  dm vdo: remove redundant TYPE argument from vdo_allocate macro
  dm vdo: add __counted_by attribute to a number of structures

 drivers/md/dm-vdo/action-manager.c            |  2 +-
 drivers/md/dm-vdo/block-map.c                 | 32 +++-----
 drivers/md/dm-vdo/block-map.h                 |  2 +-
 drivers/md/dm-vdo/data-vio.c                  |  3 +-
 drivers/md/dm-vdo/dedupe.c                    |  8 +-
 drivers/md/dm-vdo/dm-vdo-target.c             | 12 ++-
 drivers/md/dm-vdo/encodings.c                 |  2 +-
 drivers/md/dm-vdo/flush.c                     |  4 +-
 drivers/md/dm-vdo/funnel-queue.c              |  2 +-
 drivers/md/dm-vdo/funnel-workqueue.c          |  8 +-
 drivers/md/dm-vdo/indexer/chapter-index.c     |  2 +-
 drivers/md/dm-vdo/indexer/config.c            |  2 +-
 drivers/md/dm-vdo/indexer/delta-index.c       | 13 ++--
 .../md/dm-vdo/indexer/funnel-requestqueue.c   |  2 +-
 drivers/md/dm-vdo/indexer/geometry.c          |  2 +-
 drivers/md/dm-vdo/indexer/index-layout.c      | 25 +++----
 drivers/md/dm-vdo/indexer/index-page-map.c    |  8 +-
 drivers/md/dm-vdo/indexer/index-session.c     |  2 +-
 drivers/md/dm-vdo/indexer/index.c             | 14 ++--
 drivers/md/dm-vdo/indexer/index.h             |  2 +-
 drivers/md/dm-vdo/indexer/io-factory.c        |  6 +-
 drivers/md/dm-vdo/indexer/open-chapter.c      |  4 +-
 drivers/md/dm-vdo/indexer/open-chapter.h      |  2 +-
 drivers/md/dm-vdo/indexer/radix-sort.c        |  3 +-
 drivers/md/dm-vdo/indexer/sparse-cache.c      | 10 +--
 drivers/md/dm-vdo/indexer/volume-index.c      | 10 +--
 drivers/md/dm-vdo/indexer/volume.c            | 22 +++---
 drivers/md/dm-vdo/int-map.c                   |  5 +-
 drivers/md/dm-vdo/io-submitter.c              |  3 +-
 drivers/md/dm-vdo/logical-zone.c              |  3 +-
 drivers/md/dm-vdo/logical-zone.h              |  2 +-
 drivers/md/dm-vdo/memory-alloc.c              |  8 +-
 drivers/md/dm-vdo/memory-alloc.h              | 74 +++----------------
 drivers/md/dm-vdo/message-stats.c             |  2 +-
 drivers/md/dm-vdo/packer.c                    |  9 +--
 drivers/md/dm-vdo/physical-zone.c             |  8 +-
 drivers/md/dm-vdo/priority-table.c            |  3 +-
 drivers/md/dm-vdo/recovery-journal.c          | 23 +++---
 drivers/md/dm-vdo/repair.c                    | 17 ++---
 drivers/md/dm-vdo/slab-depot.c                | 37 ++++------
 drivers/md/dm-vdo/slab-depot.h                |  2 +-
 drivers/md/dm-vdo/thread-utils.c              |  2 +-
 drivers/md/dm-vdo/vdo.c                       | 32 ++++----
 drivers/md/dm-vdo/vio.c                       | 12 ++-
 44 files changed, 162 insertions(+), 284 deletions(-)

-- 
2.53.0

