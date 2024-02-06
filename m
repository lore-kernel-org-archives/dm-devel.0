Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F2E56759
	for <dm-devel@lists.linux.dev>; Tue,  6 Feb 2024 02:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707185068; cv=none; b=JH7kBGJT6I68f2tDT0c8ckRIbdUgbKVi7w0R5WADrdbZ9z/ygDf3mcMJnN9LnOZCWhGju51usrf0IXC9eqOsL4Il6G94hYn9KFIigQ4sUIANgL829FWlpqB+yCeaJfZg7Yi8wUyQ7RymI7RGEo16u1mEDOD6+H/058+mLV3eE8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707185068; c=relaxed/simple;
	bh=D8G4e/qamumA0Swl5fzRIhwb9YmkPK7hz26m0IUmKVU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AYY5Ys44fRatCNOFp2mIzyeomuJsHZr8CzYZIvNBa5vqCPTRp5QH2sNp+vsQXwNxP7YB3N/w0tteB3E17rM7MvVWX9KkaQt+QpaGbAcon8k2hV88Obied/lJMCnam4WWjdW4haULC3q/QApaYQE1qolp4fyPSaEUAosVQhGmmO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e4M5O4Cr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e4M5O4Cr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707185064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mVumkDpqvlOEtQ/tiJ+W3/jTWab5TO5gq5l8MmDJoFI=;
	b=e4M5O4CrQZf1oxP7wNTtyzKHKUo4oX7T02ESdWNPvXBnCxhDaEOHyjn9leuChs54UjDxgb
	49ww2xm/tQdqUGFDAN0QDIu+lUx0i+8itFjEBbQ1Ays89VTUQ+w/4zHm1LVhTOIwtQvx+4
	RclTlgSpaVSU4uXbOb4dskVtGFS2Ojc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-j_0_1NggMliRu1E16U0n0w-1; Mon, 05 Feb 2024 21:04:22 -0500
X-MC-Unique: j_0_1NggMliRu1E16U0n0w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9797E106D020
	for <dm-devel@lists.linux.dev>; Tue,  6 Feb 2024 02:04:22 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 91F2B40C9444;
	Tue,  6 Feb 2024 02:04:22 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 89A6A569F6; Mon,  5 Feb 2024 21:04:22 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/7] dm vdo: fix sparse warnings
Date: Mon,  5 Feb 2024 21:04:15 -0500
Message-ID: <cover.1707184413.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Fix warnings from sparse.

Mike Snitzer (6):
  dm vdo: fix sparse warnings about missing statics
  dm vdo: fix sparse 'warning: Using plain integer as NULL pointer'
  dm vdo: fix various blk_opf_t sparse warnings
  dm vdo data-vio: silence sparse warnings about locking context
    imbalances
  dm vdo dedupe: silence sparse warnings about locking context
    imbalances
  dm vdo recovery-journal: fix sparse 'mixed bitwiseness' warning

Susan LeGendre-McGhee (1):
  dm vdo: move encoding constants to encodings.h

 drivers/md/dm-vdo/Makefile           |  1 -
 drivers/md/dm-vdo/block-map.c        |  4 +--
 drivers/md/dm-vdo/constants.c        | 15 -----------
 drivers/md/dm-vdo/constants.h        | 12 +++------
 drivers/md/dm-vdo/data-vio.c         | 39 ++++++++++++++++------------
 drivers/md/dm-vdo/dedupe.c           |  2 ++
 drivers/md/dm-vdo/encodings.c        |  2 +-
 drivers/md/dm-vdo/encodings.h        |  6 +++++
 drivers/md/dm-vdo/index.c            |  8 +++---
 drivers/md/dm-vdo/io-submitter.c     |  2 +-
 drivers/md/dm-vdo/io-submitter.h     |  4 +--
 drivers/md/dm-vdo/recovery-journal.c |  4 +--
 drivers/md/dm-vdo/vdo.c              |  3 ++-
 drivers/md/dm-vdo/vio.c              |  4 +--
 drivers/md/dm-vdo/vio.h              |  4 +--
 15 files changed, 52 insertions(+), 58 deletions(-)
 delete mode 100644 drivers/md/dm-vdo/constants.c

-- 
2.42.0

