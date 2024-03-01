Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACED04642B
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267194; cv=none; b=hMDTB0KnxMNKSWqqNmQY1kpR/GLqHmxwrB4v7S03eIYCTI2/1jtrsK9kUoyqH8unos4UVk4F1fr1ifgt/f2JEt0bBaKxmRBq5wHx23sRC/X/X4JASqmjXB0YWQe2eaa4+aFd3OxAajgA8rCcor8t8LE7KARoaXhlzkq6hixztKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267194; c=relaxed/simple;
	bh=UpJEdaJfk3VusO/aIg6FuETf7yr8c+KqlS+MZ5cAbzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pSVb4a3HxIAMqjH0MqME7o+UOLqi6+c+LhXKWREUMUTXKCgw72bGWTy48wGG5p5VdcT7ZjCYD+6kIZLWXlCT8B7f689OcqRMMBLDA0K8KzUwj+zasM7k5DwWxwBFs5wBioxXxXVQW4c7dHho7R5rvCzv8zrwlOFGKejzsJeNJyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YKPyNCrR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YKPyNCrR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WF51N8rH/YEY9adeK3o5MwE1bi6cY+GO435vZTWAvQ0=;
	b=YKPyNCrRIDlhQBx7RzNXCfb2ZAclJChUXfxGlU+Y5LbGTnWnWP9yxb7lRdXYdsuMqomi1/
	BVRZUD7w9xlUewNiw/B2nqkIKePcNt8ZnSJ/X0tHeeetGZiWrV333vJSs5dfRlpYq0NRXZ
	ALdJ5S/7eOhbjhAcv8gFe7UmXC5nByY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-557-dfBoLNLvPnuQfSEC6aK3xQ-1; Thu,
 29 Feb 2024 23:26:30 -0500
X-MC-Unique: dfBoLNLvPnuQfSEC6aK3xQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1604A3C0ED57;
	Fri,  1 Mar 2024 04:26:30 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0D4592166B33;
	Fri,  1 Mar 2024 04:26:29 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id D204CA15CF; Thu, 29 Feb 2024 23:26:29 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 03/11] dm vdo: Modify mismatched function name
Date: Thu, 29 Feb 2024 23:26:21 -0500
Message-ID: <380c24cb4518a72b310ecf4901eef368b6f753e4.1709266694.git.msakai@redhat.com>
In-Reply-To: <cover.1709266694.git.msakai@redhat.com>
References: <cover.1709266694.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

No functional modification involved.

src/c++/vdo/base/physical-zone.c:268: warning: expecting prototype for vdo_free_pbn_lock_pool(). Prototype was for free_pbn_lock_pool() instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/physical-zone.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/physical-zone.c b/drivers/md/dm-vdo/physical-zone.c
index 3bcf6f1ba77f..a9380966b56f 100644
--- a/drivers/md/dm-vdo/physical-zone.c
+++ b/drivers/md/dm-vdo/physical-zone.c
@@ -258,7 +258,7 @@ static int make_pbn_lock_pool(size_t capacity, struct pbn_lock_pool **pool_ptr)
 }
 
 /**
- * vdo_free_pbn_lock_pool() - Free a PBN lock pool.
+ * free_pbn_lock_pool() - Free a PBN lock pool.
  * @pool: The lock pool to free.
  *
  * This also frees all the PBN locks it allocated, so the caller must ensure that all locks have
-- 
2.42.0

