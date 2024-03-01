Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B5247F6F
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709266438; cv=none; b=iAMv+L73riFeQnkt95a4l0fNxPK73XmUWSS74jshFLvNeo6T9dwwkAajWJHSy6H3QzMCClkd3blxmvn2LUP+V96X1/+IM/Igbk0/0Yg203SXkrrg7PWBz+u3fiXoq7hfTZqnS1RugEvyjbax+CHp3jn2ZYA8WAe5DlGWIFxjsTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709266438; c=relaxed/simple;
	bh=iZxcdJTsF88iYTxuDHlbBu/prhBy2ByBEspwqUa48Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Cg9dTl73ybCEeEBQyAVRxHk5J7rVKTNGehbex/sQrRLFO1Ojj0xqKpnobu9U2mDa8FKnPuT/cOxC9JMzzGsUcKm0F37mVtefxLCm2cIgc3w7vGiIcO9mBQWf1WR7cBlvQ/3AyGZphxeHSFRHS5ypRPoKbby+EruBzWMq4C0ugCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H32pBfCO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H32pBfCO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709266435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Xs9Gqdt+YDjSbiG11ipdx6KBSCAMMguSKyeMbDGF27w=;
	b=H32pBfCOQBLXW2ImZA6LzBf05cyh40qDrNjWWySQ6zoViqL6HeD6avVjYdjZg+pDzCtj0C
	kWrwYm6DK4xj8rYmGqLcgaJ3LPS5oXZ1RWHT+IConzqCTpEdFpfKMtj8/kG9XWYklA1sev
	lbUKInLPeMcLJ23w5zCHFPVBLad0+CY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-271-CBPmOhzVOuWzaMw7GbyQ2w-1; Thu,
 29 Feb 2024 23:13:53 -0500
X-MC-Unique: CBPmOhzVOuWzaMw7GbyQ2w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D7933C100B0
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:13:53 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 78E6B400D284;
	Fri,  1 Mar 2024 04:13:53 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 6F4F0A15AE; Thu, 29 Feb 2024 23:13:53 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/5] dm vdo: fix various minor issues
Date: Thu, 29 Feb 2024 23:13:48 -0500
Message-ID: <cover.1709265967.git.msakai@redhat.com>
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

Fix several issues reported by upstream contributors.

Chung Chung (1):
  dm vdo: clean up scnprintf usage

Dan Carpenter (1):
  dm vdo slab-depot: delete unnecessary check in allocate_components

Mike Snitzer (3):
  dm vdo flush: initialize return to NULL in allocate_flush
  dm vdo indexer-volume: fix missing mutex_lock in process_entry
  dm vdo: include <asm/current.h> to resolve current being undeclared

 drivers/md/dm-vdo/flush.c           |   2 +-
 drivers/md/dm-vdo/logger.c          |   1 +
 drivers/md/dm-vdo/message-stats.c   | 818 ++++++++--------------------
 drivers/md/dm-vdo/slab-depot.c      |   3 -
 drivers/md/dm-vdo/thread-registry.c |   1 +
 drivers/md/dm-vdo/thread-utils.c    |   1 +
 drivers/md/dm-vdo/volume.c          |   2 +-
 7 files changed, 244 insertions(+), 584 deletions(-)

-- 
2.42.0

