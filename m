Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195DD175A5
	for <dm-devel@lists.linux.dev>; Sat, 22 Mar 2025 01:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742606798; cv=none; b=QRRajJ3Pgwg54ghvCqdC2rRDMSdhGUIY6yddXO+FY4MpRyQW6j9i6zhL7+OID6M2VFWfFa3oUSYesjlFgrZeJrvdou1x5PwezfCkQFUAg6V4UTFiiyp56TYb3nhyC2t/Dm+utNW725u0BbnUz9IpMlK4d10IjlB5XPIGyoBZTfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742606798; c=relaxed/simple;
	bh=0racscnRCfh/AdjoiQFYdmgOMu33A7CkgRtpZ4LuZDI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k5SH9LDBgWvZCHZbjFMu4PAuuuIIJyEQi+MZjNJlGwP92+Qh1GqwDb/u87lYzFqnTxVKu5gzPK7si9QMHxHgO+fUw//UfK1f1ioh/CDGMpsHAFSgBaWuOXqhko+gQy/JraGWUPOdKR9ypVF3wACMd01GRVqbYWPApCtBvZE17X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZZx42P6b; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZZx42P6b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742606796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=26uniy9Au7w7dcoMJII49KTj/ZCNXT0EQn7UPP0JFng=;
	b=ZZx42P6bFVcrx0vHY4fJDSmmc1zZjqE01YK4B+XPtA+wTRg3oh9gC4rHv3DhIwwq/gs7zb
	QBAq8jn5dwIJsrHQw7Aqqc//SUFU8VmbrxmiDIB1wr1/yhu6uyfP8XzjVyvHi0lrkKeYfc
	6lGBDorR7hM7uUBsvuAvy/7tq6CtBcs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-ph2a7LA5M9iCwqbSm9jWGQ-1; Fri,
 21 Mar 2025 21:26:32 -0400
X-MC-Unique: ph2a7LA5M9iCwqbSm9jWGQ-1
X-Mimecast-MFC-AGG-ID: ph2a7LA5M9iCwqbSm9jWGQ_1742606790
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 18FE7180035C;
	Sat, 22 Mar 2025 01:26:30 +0000 (UTC)
Received: from localhost (unknown [10.72.120.2])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EA5B830001A1;
	Sat, 22 Mar 2025 01:26:27 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Jooyung Han <jooyung@google.com>,
	Mike Snitzer <snitzer@kernel.org>,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 0/5] loop: improve loop aio perf by IOCB_NOWAIT
Date: Sat, 22 Mar 2025 09:26:09 +0800
Message-ID: <20250322012617.354222-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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

V3:
	- add reviewed-by tag
	- rename variable & improve commit log & comment on 5/5(Christoph)

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

 drivers/block/loop.c | 227 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 181 insertions(+), 46 deletions(-)

-- 
2.47.0

