Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24E63D3CEA
	for <dm-devel@lists.linux.dev>; Wed,  4 Mar 2026 19:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772651073; cv=none; b=hA5sSZ87i/HoHmk/2m5MDbIGc1Olj6Xflfof1CsbzwlMiiPlfFOtzWms/VVayt0GGOVWV0nlu78UqjSNKJpn/SAcOQK+olg1H8cRFRTwuaaVRCRaiEFz7ZLDGPRT17y0w/TXyaCnf8vXHF9jKhkTwpr68bNmHIVQtGU1umD0rRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772651073; c=relaxed/simple;
	bh=7fjVhH/FBtHymATnj2FKNK9LgmXiZXkSN20I63NEuY0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=UpeCJCanhmHdVNAKbacyQIKTWBbophht7fkQ8wh8M2A6avyMoyzHc12rmab6SK+VIC8BpBWcmslGU6+177Df7Jd2bzdBn8RocrGaZ1N/7j4OcnbwrMnvNrW8uOq7FQhc0p9Q0g2WKIzJW4r1T4vUf1qkeiwXzBJAn/n7Ib21/8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SB+qVS5B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SB+qVS5B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772651071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=u7S3JSUw0L6B/lSDSpa518AgIIh6Ud2RJzojY8j4acU=;
	b=SB+qVS5B+3Bs5c4TOxUF+8yrhRnRWtHeQv/By9fmXNz1j+AXx9Vlnxcqt723cYyvpTD/lf
	XJgEsbR6f8Ffc9g/nPzo2syt+Z906JWNWg0IzLGT9TuY6WSXi5MwTCRcVX8Bk1q6lpLCrx
	uPs8+Ui+LOxFCZdDMtXTYo01lDZVuxs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-454-nJzCNDAMOC263_7eoJTryw-1; Wed,
 04 Mar 2026 14:04:30 -0500
X-MC-Unique: nJzCNDAMOC263_7eoJTryw-1
X-Mimecast-MFC-AGG-ID: nJzCNDAMOC263_7eoJTryw_1772651069
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ABAB61956096;
	Wed,  4 Mar 2026 19:04:28 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.44.32.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 298AB18002A6;
	Wed,  4 Mar 2026 19:04:25 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-block@vger.kernel.org,
	drbd-dev@lists.linbit.com,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] simple bio cleanups
Date: Wed,  4 Mar 2026 20:04:05 +0100
Message-ID: <20260304190424.291743-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: JBFjm0mL13mtFymNPyV4LnaLntYF9kf2yN0Znn4Ch18_1772651069
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Jens,

here are some simple bio related cleanups.  Any thoughts?  Can those go
in via your tree?

Thanks,
Andreas

Andreas Gruenbacher (4):
  block: consecutive blk_status_t error codes
  block: get rid of blk_status_to_{errno,str} inconsistency
  bio: rename bio_chain arguments
  bio: use bio_io_error more often

 block/bio.c                   | 22 +++++++++++-----------
 block/blk-core.c              |  5 +----
 block/fops.c                  |  3 +--
 drivers/block/drbd/drbd_int.h |  3 +--
 drivers/md/bcache/bcache.h    |  3 +--
 drivers/md/bcache/request.c   |  6 ++----
 drivers/md/dm-mpath.c         |  3 +--
 drivers/md/dm-writecache.c    |  3 +--
 fs/f2fs/segment.c             |  3 +--
 include/linux/blk_types.h     |  2 +-
 10 files changed, 21 insertions(+), 32 deletions(-)

-- 
2.52.0

