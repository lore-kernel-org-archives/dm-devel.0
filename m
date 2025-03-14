Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E0D4400
	for <dm-devel@lists.linux.dev>; Fri, 14 Mar 2025 02:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741918326; cv=none; b=BapG8nmSb+9fpbztpK+rbFyd/FzeQLYF5BlhWYsNLp3eCGNiosYkoFA5ql2pfq/8PxV9NA26+UznVr6M2Jea+PoVjPnL9Aw9ns/J6UoXlCcEu9gjR4K6G5acmrIiG+E8QhUOyo9sakIVJ8rP3v9CmpSNhm8krvDc2LaEH3eFdL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741918326; c=relaxed/simple;
	bh=PWpgWNW+Ld9RZuzWY219jgPzLfeqM5oBRbdXqX99PHY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QXlGiABVUhuuH3n3qHJQLEZskiiZqt+9PZlxsMjSQug600JMjn3IKeOSAUags+4ECvSwvhDwCC0Bp47WQU4lgJQARKlpiT56UhnAv5p73heEmsKIJG6jLiqpsph7KBoj/bNq/5MphLzJcB7mYcvHUBNYLdPSpTKSSdJRlobkxIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mw8NgXmp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mw8NgXmp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741918323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PUizuZf0ertvXPmeFjRMphAvNi2mHGRdpdwN+nvt02Q=;
	b=Mw8NgXmp5d+l5eHng849Mdxiswad2b+xZ3Cqbgfyz1I14Cv+YqDwMK1nYSlegUgpnA2edN
	8lfiGhQUSWZcs99Q8mOwReGS1ASNuexsPwiRTTfxGnM53n2I8sCFX4fuMu/xXq6P5ukjsc
	kJBvFXXNmtzrbtKURiykQXI8gPMD6Po=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-64-fufJjSHuPlqZLbIoexkPlg-1; Thu,
 13 Mar 2025 22:11:59 -0400
X-MC-Unique: fufJjSHuPlqZLbIoexkPlg-1
X-Mimecast-MFC-AGG-ID: fufJjSHuPlqZLbIoexkPlg_1741918318
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 11D67195609E;
	Fri, 14 Mar 2025 02:11:58 +0000 (UTC)
Received: from localhost (unknown [10.72.120.27])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3425A1801747;
	Fri, 14 Mar 2025 02:11:55 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Jooyung Han <jooyung@google.com>,
	Mike Snitzer <snitzer@kernel.org>,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 0/5] loop: improve loop aio perf by IOCB_NOWAIT
Date: Fri, 14 Mar 2025 10:11:40 +0800
Message-ID: <20250314021148.3081954-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hello Jens,

This patchset improves loop aio perf by using IOCB_NOWAIT for avoiding to queue aio
command to workqueue context, meantime refactor lo_rw_aio() a bit.

In my test VM, loop disk perf becomes very close to perf of the backing block
device(nvme/mq virtio-scsi).

And Mikulas verified that this way can improve 12jobs sequential rw io by
~5X, and basically solve the reported problem together with loop MQ change.

https://lore.kernel.org/linux-block/a8e5c76a-231f-07d1-a394-847de930f638@redhat.com/

The loop MQ change will be posted as standalone patch, because it needs
losetup change.


Thanks,
Ming

V2:
	- patch style fix & cleanup (Christoph)
	- fix randwrite perf regression on sparse backing file
	- drop MQ change

Ming Lei (5):
  loop: simplify do_req_filebacked()
  loop: cleanup lo_rw_aio()
  loop: move command blkcg/memcg initialization into loop_queue_work
  loop: try to handle loop aio command via NOWAIT IO first
  loop: add hint for handling aio via IOCB_NOWAIT

 drivers/block/loop.c | 232 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 186 insertions(+), 46 deletions(-)

-- 
2.47.0

