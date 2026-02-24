Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A326207A20
	for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 02:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771898934; cv=none; b=YR0KBY3WF0qjAcfZxazb4vM6qVaqL3968UR3cYsgQf9XQ7gJkljVn3MEve+f3moKM6YXjF2eANnrCFPFTDuNnmccvmrEuy2cT8pScOyzbJPtz91GhnPUj3W7DZUUbJtU8jm9EWYrfWRtI6t58YssAJ080rA3hl3D5866ur16OiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771898934; c=relaxed/simple;
	bh=fpyH3KrYUqrtPxkqU6mbawp4rTIFvJuJVlL9C2+M4dI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=ef0Vd+8AoWYRrpwBDGbmrHVN1BJNfsqU5vYXeVW/iJXn5vsuF3f20Ysy+dir7UoZzQlvyAhBuftMYR/bP6ar+8O5KW4qabo8baXrYdyJ2nqPxjPPk0qVUf7sS1JBbUjh+Bs/qXRiqodUHAfaOE95vxKOMSWHTe3MbSCDFTAZYEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PbSVqQu2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PbSVqQu2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771898932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bGGYzRJC1iIAZ8JDKbLdxkcDROS0i8K2z4FsAzZOP04=;
	b=PbSVqQu2BbS03RiW/Kids49vcrbPassYQyDqT2zwNRuvC+fzoibocp6uW+PWlN2iRDdYhF
	gcdvNT+lA4i6aOecOegwHtPEO4Q7rnXQcFDE3oiseYsT9dyGi2Ny8e6WyB5zs+7S1GjYFP
	8TQPyR3M4Ej81HxeUGgp+yY3ISyf4aE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-582-JlpzfsdJMEWeoMycrjVxDQ-1; Mon,
 23 Feb 2026 21:08:50 -0500
X-MC-Unique: JlpzfsdJMEWeoMycrjVxDQ-1
X-Mimecast-MFC-AGG-ID: JlpzfsdJMEWeoMycrjVxDQ_1771898929
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A76C1956050
	for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 02:08:49 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 33D883003D91;
	Tue, 24 Feb 2026 02:08:49 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 810D5129C83; Mon, 23 Feb 2026 21:08:48 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH v2 0/2] dm vdo: additional metadata validation
Date: Mon, 23 Feb 2026 21:08:46 -0500
Message-ID: <cover.1771898188.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zAG37iP4lE838f9YY-W7uEGvKIcVAE2djc5dpYYGdT8_1771898929
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

We identified a few places where dm-vdo uses a value from
storage without sanity-checking that its value makes sense.
Adding additional checks can prevent additional metadata
corruption in the unusual cases where these values get
corrupted.

Changes from v1:
1/2 Fixed the upper bound check to handle MAX_ZONES correctly.
1/2 Added a lower bound check for the region count.

Matthew Sakai (2):
  dm vdo indexer: validate saved region and zone counts
  dm vdo slab-depot: validate old zone count on load

 drivers/md/dm-vdo/indexer/index-layout.c | 9 ++++++++-
 drivers/md/dm-vdo/slab-depot.c           | 4 ++++
 2 files changed, 12 insertions(+), 1 deletion(-)

-- 
2.48.1

