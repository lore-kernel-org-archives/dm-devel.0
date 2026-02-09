Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F68339872
	for <dm-devel@lists.linux.dev>; Mon,  9 Feb 2026 07:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770623670; cv=none; b=CgTC0jWvEr1nK4DD9H9BqSJf5X6sYMgLiQwKjrye+ICk17VDOfsu1aw2eVnzEkTEm/vviqps5yyTlY8+8J8J8AEa/XotQeJ6YZprNvFxq/MVAo2pdVkVox9h+7D1pD9qYyU6j73ammZDdmTxv/x+1Jml/BH7EFA2ftbFByMdASw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770623670; c=relaxed/simple;
	bh=D9Y1fgf0EinVietAcWoGZ4fkCdW0a2U0VqlQ2xETIrg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=MG9r1qSLI268OtJlNXL+2RYK4jTIsATMY8VAXQMA9jMSRS08SuA6Lbb7gz6IM9R7WYasFuUGijVEchPYcsGQ8FUbJLap3QLbmI5WVGRQ3fieTHrKmtou97UWhw7v/DEIecnXLxvtaYnQ67E4NadtGDwsQNjxWQv0HbJPy7R8Trs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RbjjHtnG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RbjjHtnG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770623669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MflDzM2IvhovWmpsE8/8sN2p0bGf8YIrk5kvvxQT7FM=;
	b=RbjjHtnGUVtFAaeoIosKrXcZlVcyvz9INdKJZETllIXqWwEd6KQvXG9Dmk9kalpeIecIQ8
	5jokVBGAsQJjuHtF50rZzlL6fcvrEeD9+v88rB9wuHdlZUiP8yfMqXumJwYUGD8Iv74YHp
	nkLM8sRP66A+dte2jALcvZqpp8IGn3k=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-262-QOBy8UE-MzGrUyE-XKkWIg-1; Mon,
 09 Feb 2026 02:54:27 -0500
X-MC-Unique: QOBy8UE-MzGrUyE-XKkWIg-1
X-Mimecast-MFC-AGG-ID: QOBy8UE-MzGrUyE-XKkWIg_1770623666
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 660DB1956050;
	Mon,  9 Feb 2026 07:54:26 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.64.240.53])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C646530001A8;
	Mon,  9 Feb 2026 07:54:22 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH 0/7] dm cache: fix passthrough mode regressions
Date: Mon,  9 Feb 2026 15:54:04 +0800
Message-ID: <20260209075411.860418-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FU43kWxtjJSfobWX6DgmMRR9fWtq0-1kLDPEjzvjSl0_1770623666
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

dm-cache's passthrough mode, introduced in kernel v3.13 commit
2ee57d587357 ("dm cache: add passthrough mode"), is a maintenance
mode that bypasses the cache, designed for scenarios where the cache
coherency is uncertain. It allows administrators to verify cache
coherency while the cached device remains operational, without having
to drop the entire cache.

In kernel v4.12, the significant dm-cache rework commit b29d4986d0da
("dm cache: significant rework to leverage dm-bio-prison-v2") caused
multiple regressions that broke passthrough mode when handling writes,
causing null-ptr-deref and coherency issues. The fixes restore
passthrough mode to full functionality.

Ming-Hung Tsai (7):
  dm cache: fix null-deref with concurrent writes in passthrough mode
  dm cache: fix write path cache coherency in passthrough mode
  dm cache: fix write hang in passthrough mode
  dm cache policy smq: fix missing locks in invalidating cache blocks
  dm cache: fix concurrent write failure in passthrough mode
  dm cache: fix dirty mapping checking in passthrough mode switching
  dm cache: prevent entering passthrough mode after unclean shutdown

 drivers/md/dm-cache-metadata.c   | 20 ++++---
 drivers/md/dm-cache-metadata.h   | 10 ++--
 drivers/md/dm-cache-policy-smq.c |  4 ++
 drivers/md/dm-cache-target.c     | 90 +++++++++++++++++++++++---------
 4 files changed, 83 insertions(+), 41 deletions(-)

-- 
2.49.0

