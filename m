Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061E5481A3
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267194; cv=none; b=R2sfmuPTMOwvDH9NxJp7xZAdcX5fPxtkmAKGGFq1tHXsNyW5VbO2dsiZ0MixBiEqQ/DoCVVhsTISpxfL6ZelzTLInpJ2ITGCWVqeG/RUSQqDwPI4ksnQSCSL2m32PycE9TBQhvnDSvDoc6OXdPWZ0Ltk0l9TMC2g3uBTOvoiecQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267194; c=relaxed/simple;
	bh=NtlM49eOQQaP81fngprRo4fb8GLBWo1oB+5m3stOY3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=okm3afsDPsKfmyOA3VtqnpFfCdlNAtYo6uI5r6KSqXmCotYAQGbGI4fxoUzKiQVUa7/xq6Djjk95ITdzYXzovRHIPvH2zCENpgBSME/FNDdIHHLJ8NAijaP0w5ezJ1Ec8gYNCW3u7TprA+KP6zFrekREUY9XXqkzxhC/If5MobI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WzMFnWXu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WzMFnWXu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ga/LcAKvnWP6xfyB4vnhcZ8+HaUteQZPJfWL4cp46Ec=;
	b=WzMFnWXuxlLk8ZV8CSAXGEmprvGr7oSqgFgoCyRXfkfdZwHj3bY2+XvgB1kif7aux0VHvD
	3Gpe65zr7BuT/0gj+TTUEnUOEZ3OW/egPXVu7CY5nHup4D3IGoRfdyG0zyaB1KaalCH15y
	JPBbZuDIOxuQY1I4WfRHH+7X2WQm8Pk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-557-J9uS6Ms5NsOfE8Y2k-SjuQ-1; Thu,
 29 Feb 2024 23:26:30 -0500
X-MC-Unique: J9uS6Ms5NsOfE8Y2k-SjuQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17F1D3C0ED64;
	Fri,  1 Mar 2024 04:26:30 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 10EFF2166B5D;
	Fri,  1 Mar 2024 04:26:30 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id E63D2A15D7; Thu, 29 Feb 2024 23:26:29 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 07/11] dm vdo dedupe: Modify mismatched function name
Date: Thu, 29 Feb 2024 23:26:25 -0500
Message-ID: <c5d9b5c360604b212650f2bf1fd1443233da4e2e.1709266694.git.msakai@redhat.com>
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

src/c++/vdo/base/dedupe.c:2792: warning: expecting prototype for vdo_dump_hash_zone(). Prototype was for dump_hash_zone() instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/dedupe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 9468d7fad443..c8018c5799bd 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -2839,7 +2839,7 @@ static const char *index_state_to_string(struct hash_zones *zones,
 }
 
 /**
- * vdo_dump_hash_zone() - Dump information about a hash zone to the log for debugging.
+ * dump_hash_zone() - Dump information about a hash zone to the log for debugging.
  * @zone: The zone to dump.
  */
 static void dump_hash_zone(const struct hash_zone *zone)
-- 
2.42.0

