Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918982B9D6
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267194; cv=none; b=L+BXglyI2NvcbiqLpCoSvTaevJz0SY8U6rgtRK1FQ0QH8Xlo50Cd42uJedtJZGZ8LTqnzYD80UfHMhY22x1tT7UKAIzjDEsiERTlUMH5njtCmTkMzeR/PNH0KADyBtY6INfM4FcHwDVXKNavRZR06yNEm1a2nBXNNVQ92RB7juw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267194; c=relaxed/simple;
	bh=z+yUqq2Scl0eyHHe7drnorGYUHyI6cTx1UzabltLTUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h6/zOvIrusuiXvCV9jdz8BVzL4i1Gp/QeYwhw48qd19eDaoawaFVKqFrwZe+ie1jrzLL/vTq76RiXsv0/QL4/wzx0Sk7d40lteTgA2z6X4uMK4rUYV3QIHi0uLr/hdidYvqCPQWuobRGB5rqOYGXC91ZdUeND+zisfaD1Wg/2ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SZodH5/m; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SZodH5/m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z+ZEx7DvIZTufWG0rGf55AKY8P2K+Rp6hi1bF4S37/Q=;
	b=SZodH5/mumNqhf2GwucM9eeHDFGm71lcVTPv05sgZ4njRpYtUGDnm9OuC+aXQ1Wc9Kn2FD
	nxAL2Z60GVEB7Micmz1+8gpVlNM0UV8I5fwxip/Ft7KIaKpJEmiYLnsJqHnKlFE3zTOdHY
	8x1Noln7MkAQywPK1vgQbIbhz258eNY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-fYP0EcTMMy6iYzsQzVkwsA-1; Thu, 29 Feb 2024 23:26:30 -0500
X-MC-Unique: fYP0EcTMMy6iYzsQzVkwsA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12A3085A58B;
	Fri,  1 Mar 2024 04:26:30 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0D303AC11;
	Fri,  1 Mar 2024 04:26:29 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id D6C75A15D1; Thu, 29 Feb 2024 23:26:29 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 04/11] dm vdo: Modify mismatched function name
Date: Thu, 29 Feb 2024 23:26:22 -0500
Message-ID: <12b629369d07e907ca5b73bb1ee049f12ee4d3e6.1709266694.git.msakai@redhat.com>
In-Reply-To: <cover.1709266694.git.msakai@redhat.com>
References: <cover.1709266694.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

No functional modification involved.

src/c++/vdo/base/logical-zone.c:303: warning: expecting prototype for void attempt_generation_complete_notification()(). Prototype was for attempt_generation_complete_notification() instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/logical-zone.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-vdo/logical-zone.c b/drivers/md/dm-vdo/logical-zone.c
index cfbf1701ca84..e11f9c859349 100644
--- a/drivers/md/dm-vdo/logical-zone.c
+++ b/drivers/md/dm-vdo/logical-zone.c
@@ -295,8 +295,8 @@ static void notify_flusher(struct vdo_completion *completion)
 }
 
 /**
- * void attempt_generation_complete_notification() - Notify the flusher if some generation no
- *                                                   longer has active VIOs.
+ * attempt_generation_complete_notification() - Notify the flusher if some generation no
+ *                                              longer has active VIOs.
  * @completion: The zone completion.
  */
 static void attempt_generation_complete_notification(struct vdo_completion *completion)
-- 
2.42.0

