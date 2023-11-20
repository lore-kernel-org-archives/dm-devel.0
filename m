Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE343A279
	for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 22:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XnyyyiEM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700519363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3ZtDrVArytaxpVEmVkHJKC3x1RNxwwT9N6GybdkRXxc=;
	b=XnyyyiEMErJ1iUgXxAgyNOzndivx4zJboJ2siSMQORn4TB6EiGMjQI8C8teGOUXeZP77rC
	pUYlS4YY4MROjM8cKSJ/ic0AQVTMtCviicsz7i3BL9FVxm/wXSA8GmGD88du0XdsfCYQbo
	siPVBuPYpz2gCdwTgeY/9r162YyBNZE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-5tvgCH3MOf2il6QBgPaLyA-1; Mon, 20 Nov 2023 17:29:21 -0500
X-MC-Unique: 5tvgCH3MOf2il6QBgPaLyA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16773811E7B
	for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 22:29:21 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 104661121306;
	Mon, 20 Nov 2023 22:29:21 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 06AC851CC7; Mon, 20 Nov 2023 17:29:21 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/5] dm vdo wait-queue: clean up interface
Date: Mon, 20 Nov 2023 17:29:15 -0500
Message-ID: <cover.1700516271.git.msakai@redhat.com>
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

Add proper namespace to interface and clean up some functions.

Mike Snitzer (5):
  dm vdo wait-queue: add proper namespace to interface
  dm vdo wait-queue: remove unused debug function
    vdo_waitq_get_next_waiter
  dm vdo wait-queue: optimize vdo_waitq_dequeue_matching_waiters
  dm vdo block-map: optimize enter_zone_read_only_mode
  dm vdo wait-queue: rename to vdo_waitq_dequeue_waiter

 drivers/md/dm-vdo/block-map.c        | 143 +++++++++----------
 drivers/md/dm-vdo/block-map.h        |  10 +-
 drivers/md/dm-vdo/data-vio.c         |  14 +-
 drivers/md/dm-vdo/data-vio.h         |  12 +-
 drivers/md/dm-vdo/dedupe.c           |  50 +++----
 drivers/md/dm-vdo/dump.c             |  12 +-
 drivers/md/dm-vdo/flush.c            |  32 +++--
 drivers/md/dm-vdo/flush.h            |   2 +-
 drivers/md/dm-vdo/physical-zone.c    |   4 +-
 drivers/md/dm-vdo/recovery-journal.c |  69 ++++-----
 drivers/md/dm-vdo/recovery-journal.h |  10 +-
 drivers/md/dm-vdo/slab-depot.c       |  99 ++++++-------
 drivers/md/dm-vdo/slab-depot.h       |  22 +--
 drivers/md/dm-vdo/vio.c              |  12 +-
 drivers/md/dm-vdo/vio.h              |   2 +-
 drivers/md/dm-vdo/wait-queue.c       | 200 ++++++++++++---------------
 drivers/md/dm-vdo/wait-queue.h       | 129 +++++++++--------
 17 files changed, 409 insertions(+), 413 deletions(-)

-- 
2.42.0

