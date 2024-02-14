Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1195B10A25
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 04:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707886638; cv=none; b=Jj3e3RVyUFjb4QG52+m60t+xOpLaCkIqwgqMHTZvapLTaslQFH2KaWpWFsv8SdvL0ZN74ObA7iIYVdwvO13B9kAsf7J2zird4/M+gQ2isp5sFPLxKpP+EnYYKLr5iMiJFWGRKsdxmCYyaP5Y4oaFq9anTIgZ6wjnX/jG1RoP+ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707886638; c=relaxed/simple;
	bh=pg8Bz0yDPkl6R2dzLMaDrrSyntfAepb8tRodSdGwJkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NWORb4ZGtv+l/5Feu4he08wiWvBZs+yQ9edfUsadQ+pOXqaAn0LiIGpMRYfWrJFkJke96ys+Elrks0okJV/mR0ri35VoHx+v1MF8vDguSqM5EYPIcwRlrMiUePqNixHRoyLpZKDfx8DQLryCM6H69CZwSO1XxwqsxvNHvF29SLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hJBbyjlN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hJBbyjlN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707886636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=33b4azcn8b9Gnle4JqiJnLIarqSZvacvjtrq3+1hGv4=;
	b=hJBbyjlNDcCF89gdj4aiwO1ox0oAJsjcVTFT4vUffolSHsA59vTc02b4DjabRNPOVhTiIm
	HVoqGzVYI4azwA+71FGHGRwk/72R933KdRI0xPEoiDRAE5IlmmYveZqGrORjIuqflHIaLB
	TAyukPLIuLROzUoJMN7n5FbGx5jkjsU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-ilBXa8DvOUOEa13yHa4guw-1; Tue, 13 Feb 2024 23:57:12 -0500
X-MC-Unique: ilBXa8DvOUOEa13yHa4guw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54EE6811E79;
	Wed, 14 Feb 2024 04:57:12 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4CC0B8077;
	Wed, 14 Feb 2024 04:57:12 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 44924576BA; Tue, 13 Feb 2024 23:57:12 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/5] dm vdo string-utils: remove unnecessary includes
Date: Tue, 13 Feb 2024 23:57:08 -0500
Message-ID: <109dd73bdcfe1e01643add49d21b0023ff5415e5.1707886374.git.msakai@redhat.com>
In-Reply-To: <cover.1707886374.git.msakai@redhat.com>
References: <cover.1707886374.git.msakai@redhat.com>
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
 drivers/md/dm-vdo/string-utils.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/md/dm-vdo/string-utils.c b/drivers/md/dm-vdo/string-utils.c
index a584b37bb70c..6cdf018cdaf0 100644
--- a/drivers/md/dm-vdo/string-utils.c
+++ b/drivers/md/dm-vdo/string-utils.c
@@ -5,12 +5,6 @@
 
 #include "string-utils.h"
 
-#include "errors.h"
-#include "logger.h"
-#include "memory-alloc.h"
-#include "permassert.h"
-#include "uds.h"
-
 char *uds_append_to_buffer(char *buffer, char *buf_end, const char *fmt, ...)
 {
 	va_list args;
-- 
2.42.0

