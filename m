Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F53ABA3F
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 03:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706324492; cv=none; b=Zko3ncwDy5vKaByVfe+4wQ5XEVWBZxu9oEcwCVQNhaU1uwji2D2AP4PaBdXcmmJ6Gd/x+sFIMXLUZ+3B7sUfgThVZtSKBfiG2gsyEbei3m1btNmYU1f9/eL88fD1gwvghs5WIk4NZDLTzRa34Vvt1fY9EoTzpz01pANEYI93VtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706324492; c=relaxed/simple;
	bh=zQv96gB0DnOzqd0A8XFhYZKxIiJZNveDpluP7+QyDIs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lZYKPIdUKPcAQWlWBLoc2EGSS6M8b4ZtUB4C5k4+bEc28J4sZCG6WSMU1c5fkvJAukhpSLqgOUfOC0s+LFUoQj8NRTTIskO50waf9ca0/pN/yEckBpZhHPgIjMUmZzy0w+G0PEb9KKty+0ALVwlQXLKWtvjl5Grhnhf5NipMIto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dWBTRcl2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dWBTRcl2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706324489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JrzvNJKrQxIQQLm8kq/ijnE6Y426+0Mtr1iHhtlwhFM=;
	b=dWBTRcl2iKBbrr5wFDAn3pp2SAsLkhbbaBzBxydY4tWocnOHYN61Sw5DDX827/P2sBwY4K
	TiCeJUZpn+T9u4Z5HJfQO0lochPyMmKJ6EQ/od+tsoSXjtSQT0DZkmrORrnr7zRCzUw9Jx
	MQ785jaTnnO9F5ECy0KX8hMTerk6GU0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-4Af6G9iRPBa-YDLrxXwEFQ-1; Fri, 26 Jan 2024 22:01:27 -0500
X-MC-Unique: 4Af6G9iRPBa-YDLrxXwEFQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8457D827D87
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 03:01:27 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7FE8F2A79;
	Sat, 27 Jan 2024 03:01:27 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 78C65560E0; Fri, 26 Jan 2024 22:01:27 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/3] dm vdo: fix various formatting nits
Date: Fri, 26 Jan 2024 22:01:24 -0500
Message-ID: <cover.1706324127.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Mike Snitzer (3):
  dm vdo slab-depot: fix various small nits
  dm vdo dedupe: fix various small nits
  dm vdo index: fix various small nits

 drivers/md/dm-vdo/dedupe.c         |  9 ++++-----
 drivers/md/dm-vdo/index-layout.c   | 10 +++++-----
 drivers/md/dm-vdo/index-page-map.c |  3 +--
 drivers/md/dm-vdo/index-session.c  | 12 ++++++++----
 drivers/md/dm-vdo/index.c          |  3 +--
 drivers/md/dm-vdo/slab-depot.c     | 19 +++++++++----------
 6 files changed, 28 insertions(+), 28 deletions(-)

-- 
2.42.0

