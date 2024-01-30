Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD7B2CCD5
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 00:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706575911; cv=none; b=mYLK2S0Bqzh2JN66hVDx3VuABRuQcYaEUrmfwORaV1EugXCoU7dS5oLWTTtBSChVtHn8zj+fxaAM9GRn0T2TU+e/PjVbJS6qvOBWsJy5MUctBiXW92G1cJ4rSQFnqbQrDLI7snJk35ueRIiznadDL+X41j3Y8MtdbJVpqpy/rDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706575911; c=relaxed/simple;
	bh=IRR8207SwebMSkvjPzKa7bmWcE1m6PvKo8Ol8gO41D0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=j1xwN9ZFHu3RvbQ7HPLTng+IxlqgjjpK2pgdrHNT8ZkETix2hRin/8Hcb8mqV9JzKPLiW4sZswEhqByOFcvonVXVZLF9Uj7EvlIGB8bv1n3+tCsFq0UAS4uGzWE2Cb2hX3uIOt4pGPrqGgU5eX+QnRDVxhCHwoyoGkUedPUl32Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ua97cYR1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ua97cYR1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706575909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ueVCqo196F3P+1x0RYmA0xSfy7/z2Ysazx6sGFI4Yuo=;
	b=Ua97cYR1zJxmTOrU0hN9yNhxksw7MrLCTUf1T958cqz1HPl4JE7Ss6tV5yxIwyhegFs+ZA
	eR3bdluemaf//aEhNyljTsbGiCbDTvmX3fiYkbIFP0iZFjYVXOkESrM7kOYUd58q+0Qbg9
	8HDcoccEZe0/sOMuJLZmcM1qo3C74ao=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-90-BDn3OEvhNi-_09wG4D-m4g-1; Mon, 29 Jan 2024 19:51:47 -0500
X-MC-Unique: BDn3OEvhNi-_09wG4D-m4g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CAFF837228
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 00:51:47 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 17929112131D;
	Tue, 30 Jan 2024 00:51:47 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 0BABA56370; Mon, 29 Jan 2024 19:51:47 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/2] dm vdo: rename strutuures for clarity
Date: Mon, 29 Jan 2024 19:51:44 -0500
Message-ID: <cover.1706575731.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Mike Snitzer (2):
  dm vdo: rename struct geometry to index_geometry
  dm vdo: rename struct configuration to uds_configuration

 drivers/md/dm-vdo/chapter-index.c  | 14 ++++----
 drivers/md/dm-vdo/chapter-index.h  | 10 +++---
 drivers/md/dm-vdo/config.c         | 38 ++++++++++----------
 drivers/md/dm-vdo/config.h         | 16 ++++-----
 drivers/md/dm-vdo/geometry.c       | 57 +++++++++++++++---------------
 drivers/md/dm-vdo/geometry.h       | 40 +++++++++++----------
 drivers/md/dm-vdo/hash-utils.h     |  4 +--
 drivers/md/dm-vdo/index-layout.c   | 18 +++++-----
 drivers/md/dm-vdo/index-layout.h   |  2 +-
 drivers/md/dm-vdo/index-page-map.c |  6 ++--
 drivers/md/dm-vdo/index-page-map.h |  6 ++--
 drivers/md/dm-vdo/index-session.c  |  2 +-
 drivers/md/dm-vdo/index.c          | 14 ++++----
 drivers/md/dm-vdo/index.h          |  2 +-
 drivers/md/dm-vdo/open-chapter.c   |  4 +--
 drivers/md/dm-vdo/open-chapter.h   |  4 +--
 drivers/md/dm-vdo/sparse-cache.c   |  8 ++---
 drivers/md/dm-vdo/sparse-cache.h   |  2 +-
 drivers/md/dm-vdo/volume-index.c   | 30 ++++++++--------
 drivers/md/dm-vdo/volume-index.h   |  4 +--
 drivers/md/dm-vdo/volume.c         | 40 ++++++++++-----------
 drivers/md/dm-vdo/volume.h         |  4 +--
 22 files changed, 163 insertions(+), 162 deletions(-)

-- 
2.42.0

