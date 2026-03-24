Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6C837B010
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 18:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774375617; cv=none; b=i6OjuLDsafpWhCI2YSCRydZAIjzvHM/IWQvyekq954ZE1WA9QJ/ShRWAIkDWuGeBCAZZB3yc4pw7VjBlb03aXuxAW2HBEVmM+Jx6eBRAmSAN453dzugeyBOe8gej5V4sTnmND97+fP23qGpiRDlAjdpmzr4RPsVRB+5NhAS8dsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774375617; c=relaxed/simple;
	bh=g6R0iMiQVuzPvJz6ko4pxZ1wI6hI5omXehlECe0dcJY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=lsOn4/d5q3SR5P2qlvGkvh0l0jeovYVgdACVsVFdlauXvoAgHOT5aY85NklcVKJy7On9jXL9GvpATicAZE61b7aQboz/tIgdAKV8YbhFj0eL7mKJtOFqmSSXauEXq54MyXjHrtd1jzAthaBAr/cs8mme5nZpn5MThzL7MADB3OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aHqgp6wt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aHqgp6wt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774375615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jo4o7jTLx9IS+usTyxyFKoKT05fGdtkIdJle4NtIavU=;
	b=aHqgp6wt2bGD5OKTL1sXOAt7DlcpxI/PgrkrerxX2d8EWWDS83qtSET37QfW4yNvALyZcu
	kj6hfYeS+Icn/TMEP+dD42nqmns1lffflCRfj6qd0Pe94Gj82Z5oQsgvaNRkVIXte3rJbu
	q0YNQj2XfYcvGeGGz7awtN0a6SWoavw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-346-LYB0-RLoNZCrnCVb_7QXdg-1; Tue,
 24 Mar 2026 14:06:53 -0400
X-MC-Unique: LYB0-RLoNZCrnCVb_7QXdg-1
X-Mimecast-MFC-AGG-ID: LYB0-RLoNZCrnCVb_7QXdg_1774375613
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F5471800365
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 18:06:53 +0000 (UTC)
Received: from vdo-builder-bjohnston.permabit.com (unknown [10.0.101.86])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C94741955D71;
	Tue, 24 Mar 2026 18:06:52 +0000 (UTC)
Received: by vdo-builder-bjohnston.permabit.com (Postfix, from userid 1142)
	id 4E47B1D636; Tue, 24 Mar 2026 14:06:52 -0400 (EDT)
From: Bruce Johnston <bjohnsto@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Bruce Johnston <bjohnsto@redhat.com>
Subject: [PATCH 0/9] dm vdo: add in-kernel vdoformat support
Date: Tue, 24 Mar 2026 14:06:43 -0400
Message-ID: <20260324180652.69439-1-bjohnsto@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: a7J81Z8xhV_ZOaBfoOZeXymcv27kWk1sn69kJqeGZGk_1774375613
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This series adds support for formatting a VDO volume directly from the
kernel module, eliminating the need for the userspace vdoformat tool.

When a VDO target is loaded and the geometry block (block 0) is entirely
zeroed, the device is treated as unformatted. The module then computes
and writes the geometry block, super block, and clears the regions used
by the UDS index, block map, and recovery journal.

The series is structured as follows:

Patches 1-2 add initialization helpers for the geometry block and super
block, computing the on-disk layout for each.

Patch 3 extends the dm table line with three new optional parameters
(indexMemory, indexSparse, slabSize) needed to configure formatting,
and bumps the target version to 9.2.0.

Patch 4 adds upfront validation for the logical size parameter.

Patches 5-6 introduce the geometry block encoding function and a
vdo_geometry_block structure that mirrors the existing super block
infrastructure.

Patch 7 adds a synchronous metadata I/O helper for use during early
initialization before work queues are available.

Patch 8 adds the core formatting logic: if the geometry block is zeroed,
vdo_format() is called to initialize the volume geometry and super block.

Patch 9 adds the disk write phases to the pre-load state machine,
saving the super block, geometry block, and clearing the index/block
map/recovery journal regions during pre-resume.

Bruce Johnston (9):
  dm vdo: add geometry block initialization to encodings.c
  dm vdo: add super block initialization to encodings.c
  dm vdo: add formatting parameters to table line
  dm vdo: add upfront validation for logical size
  dm vdo: add geometry block encoding
  dm vdo: add geometry block structure
  dm vdo: add synchronous metadata I/O submission helper
  dm vdo: add formatting logic and initialization
  dm vdo: save the formatted metadata to disk

 drivers/md/dm-vdo/constants.h            |  13 +-
 drivers/md/dm-vdo/dm-vdo-target.c        | 139 ++++++++++-
 drivers/md/dm-vdo/encodings.c            | 219 +++++++++++++++-
 drivers/md/dm-vdo/encodings.h            |  17 ++
 drivers/md/dm-vdo/indexer/index-layout.c |  26 ++
 drivers/md/dm-vdo/indexer/indexer.h      |   4 +
 drivers/md/dm-vdo/io-submitter.c         |  27 ++
 drivers/md/dm-vdo/io-submitter.h         |   4 +
 drivers/md/dm-vdo/status-codes.c         |   2 +
 drivers/md/dm-vdo/types.h                |   3 +
 drivers/md/dm-vdo/vdo.c                  | 305 ++++++++++++++++-------
 drivers/md/dm-vdo/vdo.h                  |  19 ++
 12 files changed, 677 insertions(+), 101 deletions(-)

-- 
2.52.0

