Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C51550271
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267200; cv=none; b=lFQjgU90rjxwWg7V4/HdIvOo2iiwAnRqZY89LPaOzF95ubrF9vrR0bPIqbc2Roq/ocdBd8sAezzDyA6h3QIhqZankEujc6n4hYpMjFH35Lkl9XPIZzpy4tLnA51h3JhjNwyMQ4L7AsuRd7QZxTShHbUOkbEDEGeJbA91I5f3GlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267200; c=relaxed/simple;
	bh=4eRwPqkKswj4+hdupjfu2MVC3eRbTTuLB3y4/m8hdMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xvq4y/ldQWmZpX2i+9ig3VJPWgBQpWGHlF0H/4y5EzNdgqvntJdCmf2qu9/K5hSqR0UqrPNaW81KY61Aci/wry9wK0fALUIVe6WT1p3Y9dSzq5VfP+zQaIKpiYOK1dG/Y0sgOCNJci+FTwSvis9e055tblTOW296HNylGAoeghs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h6HXB1cd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h6HXB1cd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zw3HT7peDBkQGEUtAI7s+3KPRVlcIXBvJaulPzPGKmE=;
	b=h6HXB1cd4Fx4KJ/hSBAbAGws4gskSmDLO17+W/LC28TP2iF96KPQuNuieYgc911us/QmD5
	YHomUW8xUGYv+aIkci42sq4hIlvhteao5AgkKsA+JenNpd2CW8ZGgcv02DFUeUXu8UsTGH
	4lUGSojoT16Zd/fxDcLvN4NN1LL8AaA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-teipEVkbP0OpvNJW8-es4Q-1; Thu, 29 Feb 2024 23:26:31 -0500
X-MC-Unique: teipEVkbP0OpvNJW8-es4Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1748C85A58C;
	Fri,  1 Mar 2024 04:26:30 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1125AAC16;
	Fri,  1 Mar 2024 04:26:30 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id EB108A15D9; Thu, 29 Feb 2024 23:26:29 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 08/11] dm vdo: Modify mismatched function name
Date: Thu, 29 Feb 2024 23:26:26 -0500
Message-ID: <48d8767a2fd9a3577fa26e809dd52cf96d96eb48.1709266694.git.msakai@redhat.com>
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

src/c++/vdo/base/admin-state.c:310: warning: expecting prototype for vdo_drain_operation(). Prototype was for assert_vdo_drain_operation() instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/admin-state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/admin-state.c b/drivers/md/dm-vdo/admin-state.c
index 94533a802edb..1423f4cebb8a 100644
--- a/drivers/md/dm-vdo/admin-state.c
+++ b/drivers/md/dm-vdo/admin-state.c
@@ -300,7 +300,7 @@ static bool check_code(bool valid, const struct admin_state_code *code, const ch
 }
 
 /**
- * vdo_drain_operation() - Check that an operation is a drain.
+ * assert_vdo_drain_operation() - Check that an operation is a drain.
  * @waiter The completion to finish with an error if the operation is not a drain.
  *
  * Return: true if the specified operation is a drain.
-- 
2.42.0

