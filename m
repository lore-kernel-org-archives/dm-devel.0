Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D7646439
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709265911; cv=none; b=KSTC7KiNx9PAiWtylwOz40nHEZJl7fWSDWc0Fy1Vjvy2VC7TEU83mdXZ9bMUrhiaTyM4z+5FCRK8eUfsdu6IhcJ+5/sn6LdFB1D6WLsmlMjy2zXTB3NGz3MHLAvXNorLWvEXFOeXEZg0O8XmSVg3z0QV+v115N2oaQe6w/K6FwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709265911; c=relaxed/simple;
	bh=iSMiNEmCJXPLUMfufjULmrqPxSd3wneNmOLeQlm7vK8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sx01gtZEMsfzSuwRl79Qea182Ql4OH8qb6Bj6H+NKWAQEzUeIFoiDYHHZd/ifnhc1QbbjNn+V/2UcpiJXAuS8NTL+G/jdlPxQNKm0qRVAWmgKkWz5UbmhRm1FvSOaThFES8UYmSRrKHJO3f7TsNSBZDQgnqai4Q+wp1qIWs4/Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dafRhHW0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dafRhHW0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709265906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zlM9ayYoFeXPHEuJeeEo5921t7GLmD0bNT/Kd5C/a7M=;
	b=dafRhHW0BeuvWDPrco5N2X6salngblk93getMnDwy+A5eptTEBF0H9Bat5KkCl31ZfAIQO
	2P4T5qc0tGbd9Llac3RssGxgYkk8rlElThKr3EulUOw2UR3ayZWjPaoTwuP1r6ihquzX9q
	WljoaRqtk7nrTJdXB+3GXuRVUuBRNw0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-570-6xLgPj1sPniVu4ap0x0XHA-1; Thu,
 29 Feb 2024 23:05:04 -0500
X-MC-Unique: 6xLgPj1sPniVu4ap0x0XHA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 689053812593;
	Fri,  1 Mar 2024 04:05:04 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 638FD8CED;
	Fri,  1 Mar 2024 04:05:04 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 5979CA15AB; Thu, 29 Feb 2024 23:05:04 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo memory-alloc: simplify allocations_allowed()
Date: Thu, 29 Feb 2024 23:05:04 -0500
Message-ID: <283c9cd21b553d5da30770c382230ceb9e2d27c5.1709265835.git.msakai@redhat.com>
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

From: Mike Snitzer <snitzer@kernel.org>

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/memory-alloc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-vdo/memory-alloc.c b/drivers/md/dm-vdo/memory-alloc.c
index 5cd387f9294e..db085c1124be 100644
--- a/drivers/md/dm-vdo/memory-alloc.c
+++ b/drivers/md/dm-vdo/memory-alloc.c
@@ -20,11 +20,9 @@
  */
 static struct thread_registry allocating_threads;
 
-static bool allocations_allowed(void)
+static inline bool allocations_allowed(void)
 {
-	const bool *pointer = vdo_lookup_thread(&allocating_threads);
-
-	return (pointer != NULL) ? *pointer : false;
+	return vdo_lookup_thread(&allocating_threads) != NULL;
 }
 
 /*
-- 
2.42.0

