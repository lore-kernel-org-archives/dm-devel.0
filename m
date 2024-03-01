Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A535025C
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267937; cv=none; b=DvS56GjY0Y8fi9C13+AAcXgwdn7xTAVz4BBQTO1gwJENlP3E7EVfkTWoDxIi4MWlkZ96UWmE3lYbA/YWJMSiiSKHyfu/1Ab93Vypi2Xk0n/VYn35ot79tiblD+N505yx7/hIC0fFoKNCttHspTyDO94rWxx96d2ml971g/bG8Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267937; c=relaxed/simple;
	bh=SkwX0y8I9i7XRYA7ok0DsZjKBCcBLI68xIpNSFEJyb8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WGL6TwuY/HSXGkXHkc/6kD32mu3VOQ+WbCOhg7uweOHJFA3veeulfnUsQ6EhSH4x84gb+P0xdF3ze+0w1amInx3XvbhTtiQQNOR/6Q5ropR7i7NzX23gh3hOYB1bZ4O3Xaen4SB5ZmtEZJ6xNxmLoizC5NMAEkkzo3jIVnAgzgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M3W4Mglc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M3W4Mglc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=K/h2A404gchBjLML104bkwOuX/6JtmoOSM8nRrIY4bo=;
	b=M3W4MglcZmE7/H8ZM5hZfUBS5rDxx+/5biULJa/2dmvjCUMLDUyvbsifDSKeHbr9K7V84n
	j36xYo/XJgGq3t7aIYWNre4eNpNTuQ5kgaBk+zetwGMqynPVCQwvA2hll+hDUSwKTS5ijD
	1LtZJTs57XPIW7eTzKQJuY5LdY5dW+g=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-687-MmiEVSG0NX6sDV2aRJrS0g-1; Thu,
 29 Feb 2024 23:38:53 -0500
X-MC-Unique: MmiEVSG0NX6sDV2aRJrS0g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B75841C05AF8
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B289C8CED;
	Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id A96FDA1618; Thu, 29 Feb 2024 23:38:53 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 00/10] dm vdo: standardize on VDO_SUCCESS
Date: Thu, 29 Feb 2024 23:38:43 -0500
Message-ID: <cover.1709267597.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Clean up code to consistently return and check for appropriate
return values, usually VDO_SUCCESS.

Matthew Sakai (2):
  dm vdo errors: remove unused error codes
  dm vdo indexer: update ASSERT and ASSERT_LOG_ONLY usage

Mike Snitzer (8):
  dm vdo memory-alloc: return VDO_SUCCESS on success
  dm vdo: check for VDO_SUCCESS return value from memory-alloc functions
  dm vdo int-map: return VDO_SUCCESS on success
  dm vdo thread-utils: return VDO_SUCCESS on vdo_create_thread success
  dm-vdo funnel-workqueue: return VDO_SUCCESS from
    make_simple_work_queue
  dm vdo permassert: audit all of ASSERT to test for VDO_SUCCESS
  dm vdo encodings: update some stale comments
  dm vdo target: eliminate inappropriate uses of UDS_SUCCESS

 drivers/md/dm-vdo/action-manager.c            |   8 +-
 drivers/md/dm-vdo/block-map.c                 | 128 +++++++-------
 drivers/md/dm-vdo/completion.c                |  10 +-
 drivers/md/dm-vdo/completion.h                |   6 +-
 drivers/md/dm-vdo/data-vio.c                  | 110 ++++++------
 drivers/md/dm-vdo/data-vio.h                  |  68 ++++----
 drivers/md/dm-vdo/dedupe.c                    | 165 +++++++++---------
 drivers/md/dm-vdo/dm-vdo-target.c             |  70 ++++----
 drivers/md/dm-vdo/encodings.c                 | 162 +++++++++--------
 drivers/md/dm-vdo/errors.c                    |   9 +-
 drivers/md/dm-vdo/errors.h                    |  13 +-
 drivers/md/dm-vdo/flush.c                     |  22 +--
 drivers/md/dm-vdo/funnel-queue.c              |   2 +-
 drivers/md/dm-vdo/funnel-workqueue.c          |  30 ++--
 drivers/md/dm-vdo/indexer/chapter-index.c     |  18 +-
 drivers/md/dm-vdo/indexer/config.c            |  18 +-
 drivers/md/dm-vdo/indexer/delta-index.c       | 100 +++++------
 .../md/dm-vdo/indexer/funnel-requestqueue.c   |   4 +-
 drivers/md/dm-vdo/indexer/geometry.c          |   2 +-
 drivers/md/dm-vdo/indexer/index-layout.c      |  23 +--
 drivers/md/dm-vdo/indexer/index-page-map.c    |   8 +-
 drivers/md/dm-vdo/indexer/index-session.c     |  14 +-
 drivers/md/dm-vdo/indexer/index.c             |  18 +-
 drivers/md/dm-vdo/indexer/io-factory.c        |   6 +-
 drivers/md/dm-vdo/indexer/open-chapter.c      |   4 +-
 drivers/md/dm-vdo/indexer/radix-sort.c        |   2 +-
 drivers/md/dm-vdo/indexer/sparse-cache.c      |   8 +-
 drivers/md/dm-vdo/indexer/volume-index.c      |  38 ++--
 drivers/md/dm-vdo/indexer/volume.c            |  48 ++---
 drivers/md/dm-vdo/int-map.c                   |  38 ++--
 drivers/md/dm-vdo/io-submitter.c              |  12 +-
 drivers/md/dm-vdo/logical-zone.c              |  22 +--
 drivers/md/dm-vdo/memory-alloc.c              |  36 ++--
 drivers/md/dm-vdo/memory-alloc.h              |   8 +-
 drivers/md/dm-vdo/message-stats.c             |   2 +-
 drivers/md/dm-vdo/packer.c                    |  12 +-
 drivers/md/dm-vdo/permassert.c                |   2 +-
 drivers/md/dm-vdo/permassert.h                |  15 +-
 drivers/md/dm-vdo/physical-zone.c             |  48 ++---
 drivers/md/dm-vdo/priority-table.c            |   4 +-
 drivers/md/dm-vdo/recovery-journal.c          |  60 +++----
 drivers/md/dm-vdo/repair.c                    |  12 +-
 drivers/md/dm-vdo/slab-depot.c                | 118 ++++++-------
 drivers/md/dm-vdo/status-codes.c              |  10 --
 drivers/md/dm-vdo/status-codes.h              |  32 +---
 drivers/md/dm-vdo/thread-registry.c           |   4 +-
 drivers/md/dm-vdo/thread-utils.c              |   4 +-
 drivers/md/dm-vdo/uds-sysfs.c                 |   2 +-
 drivers/md/dm-vdo/vdo.c                       |  34 ++--
 drivers/md/dm-vdo/vio.c                       |  40 ++---
 drivers/md/dm-vdo/vio.h                       |   8 +-
 51 files changed, 794 insertions(+), 843 deletions(-)

-- 
2.42.0

