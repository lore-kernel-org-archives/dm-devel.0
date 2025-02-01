Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F9A130E58
	for <dm-devel@lists.linux.dev>; Sat,  1 Feb 2025 02:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738376292; cv=none; b=eAhWS79LyqrpaU2ny/MdmhgAhet9N550qqJ8zm0oRVOp2ECGLf8E0sXa2Qy17rOsn+sGxhOM0qLeEzZV1b/7lCdM8DHVz3KwoXppXme8Tk3Om54nllAm6o50zuw986WBuREW3bqt6hiNJVR9ka4WjJB3KVBT9/G7d6gMi8zgtJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738376292; c=relaxed/simple;
	bh=JQ6ZHjnorc04wPmIWurgpX68SXWzY9DQyTOXnSceyiY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=pqfM8b94nYRdPDfhc8npRPBJvBYcvCbIORtFStxWTXz6gXup3W/TLGPG4YVZCaGBB2JdEuxMP6u5NkbU4KNOdb8i0khmVhZw0YTWOdHrYdSqkyS5EC4bwNMgJkxH/Kl1I51ABSI59ur2pPySXDgvST6iOlwQZTbkDDrUFK81dBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BmLBMFa7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BmLBMFa7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738376289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VojSsWkdLtmhk3Y0Do12GvXg1JZfIZfWnSqIIpjoDmw=;
	b=BmLBMFa7AEHUqRNrfAq6/cpwFF43WVN2Xr08cRW3we8i5CqBQ/t3n2UcGS4I6GUJ5tMCWT
	zn7td/X+7lEgSBr63HBnDyiqfq69QCgacvtOq5Xhsealvadq9VMAf2O16aX/eUKoWbt0u9
	qVMuyStjc40pXTczkgktPrUwsdbzsyg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-641-wwPUR_-CM9aYmOxIQA5isg-1; Fri,
 31 Jan 2025 21:18:08 -0500
X-MC-Unique: wwPUR_-CM9aYmOxIQA5isg-1
X-Mimecast-MFC-AGG-ID: wwPUR_-CM9aYmOxIQA5isg
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 49BEE19560A1
	for <dm-devel@lists.linux.dev>; Sat,  1 Feb 2025 02:18:07 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 244F018009A4;
	Sat,  1 Feb 2025 02:18:07 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 6F4E65F29C; Fri, 31 Jan 2025 21:18:06 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/4] dm vdo: reduce reference count load time
Date: Fri, 31 Jan 2025 21:18:02 -0500
Message-ID: <cover.1738375023.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gUMprRxHKI9bNKaqS8RIssaLQ1l2qJypS-Xny8jiHaU_1738376287
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

A vdo device loads all reference count values at startup, reading
entire spans of up to a few MB at a time. Use a small number of large
vios instead of a big flurry of 4kB vios to read this data more
efficiently.

On our test systems (KVM virtual machines with 6 Intel Icelake cores
and 16 GB RAM, simulating ~34 TB of physical storage through some
device-mapper hackery), using the larger vios cuts the vdo startup
time by 15-30%. Installations with smaller or very fast storage may
see less benefit.

Ken Raeburn (4):
  dm vdo vio-pool: add a pool pointer to pooled_vio
  dm vdo vio-pool: support pools with multiple data blocks per vio
  dm vdo vio-pool: allow variable-sized metadata vios
  dm vdo slab-depot: read refcount blocks in large chunks at load time

 drivers/md/dm-vdo/block-map.c    | 11 ++---
 drivers/md/dm-vdo/io-submitter.c |  6 ++-
 drivers/md/dm-vdo/io-submitter.h | 18 +++++--
 drivers/md/dm-vdo/slab-depot.c   | 80 ++++++++++++++++++++++----------
 drivers/md/dm-vdo/slab-depot.h   | 13 +++++-
 drivers/md/dm-vdo/types.h        |  3 ++
 drivers/md/dm-vdo/vio.c          | 54 ++++++++++++---------
 drivers/md/dm-vdo/vio.h          | 13 ++++--
 8 files changed, 136 insertions(+), 62 deletions(-)

-- 
2.45.2

