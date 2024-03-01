Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B753FE54
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267562; cv=none; b=XrdwltEC/G1cxhinXWZgFzXw5bai+NHJ7XS/PObpU3h3iWtryG+9673+wsvr4/fpVB1WJHOieQqNVsuWwATLUbHd79kiNzr+9aRsJrA0IZLXYiiWPSecaiZngnuMPO9odEcq12Ogjelp9uqbHqda/0QnYz9SqwfhSFlwsSgGapE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267562; c=relaxed/simple;
	bh=6ILc2c25vULGPwZecToK+MNpKGOYX0ksg4bf2mJBfDM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bcolvPRNOUU+0O8YlZjKKCkzwopdP6WHhwwTY1GKDph7s6GiACYPc9jUBPboxojX8JJcjNt5ewXMsNyntFF4eZpfFUzBQLDktpAART12CBD7DJf/aJS096I0ejFkERvR/7yfSStrPjHZBxQMe09heoSAfFgYx0KqYauC7taflmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ANkIxD3M; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ANkIxD3M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rK7ysy+nGQs5zJrogXy1nTa+NAK34n1Bxa5fMwzc5oE=;
	b=ANkIxD3M0TX7e9cwW2bBNjDhCwv8x/4rA8TWIL7EViufMzfX4H3nXdqEzuiU9uFqkv1ZDc
	L3idsFMD4oTYEJyeVLT3ZZQtUCx3y9iVRH+tiW9UB2pWclZSiNF/FFn8ekA0hNd9YiEVTm
	o80hr4rSRkdTXK7O+UUX4dk0xjuVIQ8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-XXpM5pSRMvyzPnkINlmm7Q-1; Thu, 29 Feb 2024 23:32:38 -0500
X-MC-Unique: XXpM5pSRMvyzPnkINlmm7Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 714C283B8EB
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:32:38 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6AC851C060AF;
	Fri,  1 Mar 2024 04:32:38 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 61C37A15ED; Thu, 29 Feb 2024 23:32:38 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/2] dm vdo memory-alloc: rename functions
Date: Thu, 29 Feb 2024 23:32:36 -0500
Message-ID: <cover.1709267399.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Mike Snitzer (2):
  dm vdo memory-alloc: change from uds_ to vdo_ namespace
  dm vdo memory-alloc: rename vdo_do_allocation to __vdo_do_allocation

 drivers/md/dm-vdo/action-manager.c            |  2 +-
 drivers/md/dm-vdo/admin-state.c               |  2 +-
 drivers/md/dm-vdo/block-map.c                 | 60 ++++++------
 drivers/md/dm-vdo/data-vio.c                  | 24 ++---
 drivers/md/dm-vdo/dedupe.c                    | 34 +++----
 drivers/md/dm-vdo/dm-vdo-target.c             | 56 +++++------
 drivers/md/dm-vdo/dump.c                      |  2 +-
 drivers/md/dm-vdo/encodings.c                 |  4 +-
 drivers/md/dm-vdo/flush.c                     | 12 +--
 drivers/md/dm-vdo/funnel-queue.c              |  4 +-
 drivers/md/dm-vdo/funnel-workqueue.c          | 30 +++---
 drivers/md/dm-vdo/indexer/chapter-index.c     |  6 +-
 drivers/md/dm-vdo/indexer/config.c            |  4 +-
 drivers/md/dm-vdo/indexer/delta-index.c       | 20 ++--
 .../md/dm-vdo/indexer/funnel-requestqueue.c   |  4 +-
 drivers/md/dm-vdo/indexer/geometry.c          |  4 +-
 drivers/md/dm-vdo/indexer/index-layout.c      | 58 ++++++------
 drivers/md/dm-vdo/indexer/index-page-map.c    | 20 ++--
 drivers/md/dm-vdo/indexer/index-session.c     |  6 +-
 drivers/md/dm-vdo/indexer/index.c             | 26 +++---
 drivers/md/dm-vdo/indexer/io-factory.c        | 14 +--
 drivers/md/dm-vdo/indexer/open-chapter.c      |  8 +-
 drivers/md/dm-vdo/indexer/radix-sort.c        |  4 +-
 drivers/md/dm-vdo/indexer/sparse-cache.c      | 22 ++---
 drivers/md/dm-vdo/indexer/volume-index.c      | 16 ++--
 drivers/md/dm-vdo/indexer/volume.c            | 36 ++++----
 drivers/md/dm-vdo/int-map.c                   | 14 +--
 drivers/md/dm-vdo/io-submitter.c              | 10 +-
 drivers/md/dm-vdo/logical-zone.c              |  8 +-
 drivers/md/dm-vdo/memory-alloc.c              | 38 ++++----
 drivers/md/dm-vdo/memory-alloc.h              | 74 +++++++--------
 drivers/md/dm-vdo/message-stats.c             |  4 +-
 drivers/md/dm-vdo/packer.c                    | 14 +--
 drivers/md/dm-vdo/physical-zone.c             | 16 ++--
 drivers/md/dm-vdo/pool-sysfs.c                |  2 +-
 drivers/md/dm-vdo/priority-table.c            |  4 +-
 drivers/md/dm-vdo/recovery-journal.c          | 36 ++++----
 drivers/md/dm-vdo/repair.c                    | 24 ++---
 drivers/md/dm-vdo/slab-depot.c                | 80 ++++++++--------
 drivers/md/dm-vdo/slab-depot.h                |  2 +-
 drivers/md/dm-vdo/thread-utils.c              | 10 +-
 drivers/md/dm-vdo/uds-sysfs.c                 |  4 +-
 drivers/md/dm-vdo/vdo.c                       | 92 +++++++++----------
 drivers/md/dm-vdo/vio.c                       | 20 ++--
 44 files changed, 464 insertions(+), 466 deletions(-)

-- 
2.42.0

