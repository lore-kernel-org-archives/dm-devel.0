Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7001356765
	for <dm-devel@lists.linux.dev>; Tue,  6 Feb 2024 02:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707185067; cv=none; b=O7kD7Qp6COYllNkIxRbu+JfwaersVcd3u81aJszeFNmoJak5pxfLg1eP38GcRM5emzL8ztf97Cw+ng2flwV29+uop0I/1BfTPBkqv27gZHj+0fVed52dw05nHb7Fx2aI5qP6lg40kDDCciqvMtsjGqs3H8RvWXC0UCciW72xd1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707185067; c=relaxed/simple;
	bh=kaLt7Xjw5pOeaAn32AUOavZUw1BiWLUToNB19RR9+Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FS6fAFU3NKPwdvio9eyU0GahbDeE7XfhAeWT7GwkbrMw+gvuh9IotJ2ZkN4QGZJ1GR5GATIPdIC9b0p6HFs23/qcy5UiWjtCDdF6wQtlHiCFt3r+cY5+upAWJgxlBQk6k3caKEvAs1S2B86TusoCL/VI5yO/w6IRPX1jX9N+Zi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CN0mBD+V; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CN0mBD+V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707185064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sRAaR/4uefbevI7lF7wpXRy1a6wT1HiIk/2urx412w0=;
	b=CN0mBD+V6SlVQmpW1i8v21ATkibqEb19ii02C3Rzv/kor/riJv4XTf0TCcN6svV/nKNe79
	pTceS37JqdvDjzC08zLbHo9SU2Otk7Pse9cGDlsQGbGf3h7Yk7X6o+S1bTDMSz9KXYx+qB
	xfvrEGmIFSlSoiFalgb1elI2k5Ri3WA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-73-HYbpI2QjM3ehCAkTeYpeLQ-1; Mon,
 05 Feb 2024 21:04:23 -0500
X-MC-Unique: HYbpI2QjM3ehCAkTeYpeLQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD6C21C09825;
	Tue,  6 Feb 2024 02:04:22 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A5FABC15E61;
	Tue,  6 Feb 2024 02:04:22 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id A386F56A00; Mon,  5 Feb 2024 21:04:22 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 5/7] dm vdo dedupe: silence sparse warnings about locking context imbalances
Date: Mon,  5 Feb 2024 21:04:20 -0500
Message-ID: <8cb7d0b05fa3b51d9923a05d1aeb213f28ba5eeb.1707184413.git.msakai@redhat.com>
In-Reply-To: <cover.1707184413.git.msakai@redhat.com>
References: <cover.1707184413.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Annotate both open_index() and close_index() with
__must_hold(&zones->lock) to silence these sparse warnings:
 warning: context imbalance in 'close_index' - unexpected unlock
 warning: context imbalance in 'open_index' - unexpected unlock

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/dedupe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 8533f1669a01..4b00135511dd 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -2092,6 +2092,7 @@ static void finish_uds_queue(void *ptr __always_unused)
 }
 
 static void close_index(struct hash_zones *zones)
+	__must_hold(&zones->lock)
 {
 	int result;
 
@@ -2113,6 +2114,7 @@ static void close_index(struct hash_zones *zones)
 }
 
 static void open_index(struct hash_zones *zones)
+	__must_hold(&zones->lock)
 {
 	/* ASSERTION: We enter in IS_CLOSED state. */
 	int result;
-- 
2.42.0

