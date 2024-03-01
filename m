Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8803E50279
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267201; cv=none; b=ahogvLDbg2tiUaj3lVbhImsDnbBaT1Ec+iBSMFTMRajE6Z7VXybqEBpIQP7eBJTUYvnpJvOlCphBeNWL2+4rthcuGz7/RYhwKK9Yg1DOOSHcrYlcoIHtcQImrA6RvHfkzdlhPq2bpDM9lwRReB48TipLCadNiWzJv7tDv7cfT6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267201; c=relaxed/simple;
	bh=kXeWTO9kl8V45zBW8h8LVitlA8bnuDKp85yiLAOUXV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IyMT+LzuklP8cNWri01GIWboQyNBkVzcFgIIdBQiBCLYWqpsaN7/ov1AsyeTmbdPhWHennf38XLxT3BM46c1959H+WHWcSodTOA0Wb4ddtlPWCE3yg797cmk1zaAExWsHuRBgDPnQdWa897cx3giwv4qbmBrwI6j1Mv5PLzBpRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KoqIVyfh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KoqIVyfh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OaAo6W6KRzKQfawWJPTLa2iK841UotbrwdOxJNY5s0Y=;
	b=KoqIVyfhVPo8Ycpg/s8IdHey1I51w2KZx9tch3z4XB6qnjwMacYvVQYQeJiUGQPBiMNB3m
	Zs13Ieeb4Wyr5jDeO1y5WmYGekyyRcTUcVPvhix2rDZHMt7WKVR21jEXQVKFyHnRx1QCKK
	HDeYSQbaS5kjXsjg3gt7E49aMIbp1pE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-VVBYmoNgMDyiGdYEC2TZCg-1; Thu, 29 Feb 2024 23:26:31 -0500
X-MC-Unique: VVBYmoNgMDyiGdYEC2TZCg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1663A832BCE
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:26:30 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 119DC10793;
	Fri,  1 Mar 2024 04:26:30 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 054EBA15DF; Thu, 29 Feb 2024 23:26:30 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 11/11] dm vdo: remove outdated pointer_map reference
Date: Thu, 29 Feb 2024 23:26:29 -0500
Message-ID: <cc2dbdc9254cf4ff4efe1dc50cf7c132069fbe6e.1709266694.git.msakai@redhat.com>
In-Reply-To: <cover.1709266694.git.msakai@redhat.com>
References: <cover.1709266694.git.msakai@redhat.com>
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

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/vdo.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index c161dffeb91a..d16404588881 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -67,10 +67,7 @@ struct sync_completion {
 	struct completion completion;
 };
 
-/*
- * We don't expect this set to ever get really large, so a linked list is adequate. We can use a
- * pointer_map if we need to later.
- */
+/* A linked list is adequate for the small number of entries we expect. */
 struct device_registry {
 	struct list_head links;
 	/* TODO: Convert to rcu per kernel recommendation. */
-- 
2.42.0

