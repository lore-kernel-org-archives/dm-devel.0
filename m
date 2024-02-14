Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D43F1DDD7
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 23:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707953118; cv=none; b=Gtbn1VckJxmqRW1d1ozflzQueywpi74E3kgCME5f9LXG6rHCNKwNby9ADu5UakZLt2hHyFh5xOxzd0JKxh+FBKOf5CRdpPl2ZJnbwN5hUy6ZTIVPuJwJfqM31kywHHLTNR06pZVu+jSp5aJtJKDgsCUY2rPFuO+F1O2QmNvSEiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707953118; c=relaxed/simple;
	bh=/M17cnyzNbJEpRdGeE5inOPt0KphNXNy92Du0tP8eJA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jJ3M6Czd5WucUBeIjDsfz0WS6TNLjrbJ5xHwRi+nt19/2OlN9CKc8XiA7p5uIi30M8h4P9lLMLthcYLZWuAgUwU5dhN4atM20RY8FkqMaHzHj/IyHTfxv8RUWl9jBIFDT4tNwPzSKMuLGniUxuVx/CsmJC9YLsXsI+BI+DDlE9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UDXf4svx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UDXf4svx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707953115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cVMOCbqNt4fmm4zUeiMbmzoxz07b3Y9JYwNZP/Vk1EE=;
	b=UDXf4svxc/6RRso+6Q/9kw9QQPAjzovfvUUR7+fNu++6qGpab3OW0pGEJgqhmZIxG2yxxW
	f9twXEwNzuv5a1MKSukyS3ZxHjFVAzUCuJZw2TWhDL95cIZMcgKFPJRyVcsOCZGFM//wCC
	nfNrVUZeiuOzkNgWbQOgLQzGcN/cTJ0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-PjXNumMIPvmsFCs7kqy7iA-1; Wed, 14 Feb 2024 18:25:14 -0500
X-MC-Unique: PjXNumMIPvmsFCs7kqy7iA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57B7B101FA0B
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 23:25:14 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 52B58492BFA;
	Wed, 14 Feb 2024 23:25:14 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 4959057EBF; Wed, 14 Feb 2024 18:25:14 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/2] dm vdo logger: standardize logging
Date: Wed, 14 Feb 2024 18:25:12 -0500
Message-ID: <cover.1707952829.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Mike Snitzer (2):
  dm vdo logger: switch UDS_LOG_NOTICE to be alias for UDS_LOG_INFO
  dm vdo logger: update logging to start with "device-mapper: vdo"

 drivers/md/dm-vdo/index-session.c |  2 +-
 drivers/md/dm-vdo/logger.c        | 12 +++++-------
 drivers/md/dm-vdo/logger.h        | 13 +++----------
 3 files changed, 9 insertions(+), 18 deletions(-)

-- 
2.42.0

