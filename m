Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8C96FDE
	for <dm-devel@lists.linux.dev>; Sat, 11 Nov 2023 04:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N55Pji5/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699677050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q4yhU04vpjnU33lo8oVlkUBraK4J7ZGWLAvJ1ibrpDk=;
	b=N55Pji5/xQtT2AlTGcxyIdnztcHuuK3jl+OQ06B6adCIIs8U9cLhQCnNlHLFyrSq6EY/NJ
	44UFCiFH/VoDRTTDuUw8q3TUvvdW0P20uil1Y3SSQ61lHax1klihIKxuitI07Z9VvW5qvi
	5em6ty5SLpqRPQ63kpdCyOddSEACLZs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-KDrI2sqxN36ji8yaw7aPfg-1; Fri, 10 Nov 2023 23:30:46 -0500
X-MC-Unique: KDrI2sqxN36ji8yaw7aPfg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88BE9101A53B;
	Sat, 11 Nov 2023 04:30:46 +0000 (UTC)
Received: from pbitcolo-build-10.permabit.com (pbitcolo-build-10.permabit.lab.eng.bos.redhat.com [10.19.117.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7E79C492BE7;
	Sat, 11 Nov 2023 04:30:46 +0000 (UTC)
Received: by pbitcolo-build-10.permabit.com (Postfix, from userid 1138)
	id 3509B3003D; Fri, 10 Nov 2023 23:30:46 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 8/8] dm vdo memory-alloc: mark branch unlikely() in uds_allocate_memory()
Date: Fri, 10 Nov 2023 23:30:44 -0500
Message-Id: <1627ae51fd2896d5d24748456f1a2e10ad299e8f.1699675570.git.msakai@redhat.com>
In-Reply-To: <ccd28d21aede15fc56f1ff25b3582ddad5260883.1699675570.git.msakai@redhat.com>
References: <ccd28d21aede15fc56f1ff25b3582ddad5260883.1699675570.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

From: Mike Snitzer <snitzer@kernel.org>

Remove temporary 'duration' variable. And cleanup coding style nit.

Reviewed-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/memory-alloc.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-vdo/memory-alloc.c b/drivers/md/dm-vdo/memory-alloc.c
index 136a19db33be..e9464d4a1e64 100644
--- a/drivers/md/dm-vdo/memory-alloc.c
+++ b/drivers/md/dm-vdo/memory-alloc.c
@@ -286,13 +286,9 @@ int uds_allocate_memory(size_t size, size_t align, const char *what, void *ptr)
 	if (allocations_restricted)
 		memalloc_noio_restore(noio_flags);
 
-	if (p == NULL) {
-		unsigned int duration = jiffies_to_msecs(jiffies - start_time);
-
+	if (unlikely(p == NULL)) {
 		uds_log_error("Could not allocate %zu bytes for %s in %u msecs",
-			      size,
-			      what,
-			      duration);
+			      size, what, jiffies_to_msecs(jiffies - start_time));
 		return -ENOMEM;
 	}
 
-- 
2.40.0

