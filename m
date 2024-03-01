Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8B547F73
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709266439; cv=none; b=Oa2rfzpR8o9yGb6XeKEZd3vICMHp11SIiGrxme9OOpiMcXQ9e0QS+u0jzoUeYNXdeptYT5iUoW8wrPbmLu+7U6W5IzqJ3ODHEgRs0RBVTOcllptYWNj8ja1yKq6sv/4kAx422oDXgB5YXd6nZv0wlABqDSYjRqgOsRd4q5w0NDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709266439; c=relaxed/simple;
	bh=2YBaBKVowzefXc0vXZUzRawz7zU9i6iuEyfQoyj99YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OW3tGNzTwz4dpyHJ3SWBm8WqqbC0UCqKRc4tACSNhIJj4RvJ3qj9ulnxaNdsy6ov4B3cW3fDK+6to6J2vdPm25UxOvlj0vHKO/8TFHOqLztjEG4ei8AO7xOcQpGtDxRAKfZpSy8wC9XnVGHbXhxInOfUOmO24Q6tbhSMDuSipbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sad0tLK5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sad0tLK5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709266436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7OcQ891uvH24y21bX2hnb6FO6hhmUXQA3Yhpwb6kcfo=;
	b=Sad0tLK5u273YjT0rqYmSsVqaR5GpQKOZ3Bw5beg4qwvqePROVEbVIxAECyYWIP3XPxPIW
	bdlnlpvPaEaJiU0DMZxOUfgt9YYDQHq8Pfp3Lamw5xB3yeP//gMMCf8Heci8JazKVnEtEu
	PLPHOoZKlsyqvsQoECEu5xXeivUf/f8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-62-BQ9ffwFmM32JhaTroKqj3Q-1; Thu, 29 Feb 2024 23:13:53 -0500
X-MC-Unique: BQ9ffwFmM32JhaTroKqj3Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86BE9185A784;
	Fri,  1 Mar 2024 04:13:53 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 820C0400D6C9;
	Fri,  1 Mar 2024 04:13:53 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 7956DA15B2; Thu, 29 Feb 2024 23:13:53 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/5] dm vdo flush: initialize return to NULL in allocate_flush
Date: Thu, 29 Feb 2024 23:13:50 -0500
Message-ID: <02151fc9e38d9b41a7e36a23816f1b643cdeb4ad.1709265967.git.msakai@redhat.com>
In-Reply-To: <cover.1709265967.git.msakai@redhat.com>
References: <cover.1709265967.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Otherwise, error path could result in allocate_flush's subsequent
check for flush being non-NULL leading to false positive.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/flush.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/flush.c b/drivers/md/dm-vdo/flush.c
index 330b18715027..391b6203efc6 100644
--- a/drivers/md/dm-vdo/flush.c
+++ b/drivers/md/dm-vdo/flush.c
@@ -100,7 +100,7 @@ static struct vdo_flush *vdo_waiter_as_flush(struct vdo_waiter *waiter)
 
 static void *allocate_flush(gfp_t gfp_mask, void *pool_data)
 {
-	struct vdo_flush *flush;
+	struct vdo_flush *flush = NULL;
 
 	if ((gfp_mask & GFP_NOWAIT) == GFP_NOWAIT) {
 		flush = uds_allocate_memory_nowait(sizeof(struct vdo_flush), __func__);
-- 
2.42.0

