Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC764D584
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709264253; cv=none; b=S9I37Er0ObDHbBZEOb+JSioP0Q4ev0Wh87+2aQBIq/DTyfuwDn5nze2Q3eAD6J6egeWkw7Znnik12jZ44CmMO9O8tA0XNFuoQ41OGdrgq6LeVuTKWYXmOMLFlBCyFco150AsIVjftcxluP4EK6ykA3paPJiSyBCV4Pf1sKfu0s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709264253; c=relaxed/simple;
	bh=svC8KsUFzeYabgVGDQ/Y4Uh52yj9FUt/5nD/0AhLXAM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KJFYkbjeuAmY6AShXPA28WepOKpaZNAap6Wu0tSxdz6jJF5AZ7GeKENYQM9RqOrKJZYPYqgeHotJYVr+QJwzQX7GH3YAAZiMHEZrnQ5Wj9ZcO4bUmdNtskunwmwVefvvtCSn6Fb5RKuZrzde+CATO1D81Pb5teabB1/STyPzPYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NlmBFTQ4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NlmBFTQ4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709264250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OZJa6Cq/rL111B7TTssFwvNHDLqlVYFgZkqpssScdfs=;
	b=NlmBFTQ4uGHEqRDfxfJ0m8mVKUivURgPbCBhec8HCn/8CaIL0OBjUhChx82dlpKoAL/K8a
	OuwhMD6hTPSTUk+VKDawiMDG93bxeynUyE/rq1jQ+Xb+BDCNLWlTR25FGab4NhAwC8OWEz
	vTs3yTRPy+53N92UYFfIADSQbkVJ6+0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-283-90XaUSMsO3eTafw24kzXcA-1; Thu,
 29 Feb 2024 22:37:25 -0500
X-MC-Unique: 90XaUSMsO3eTafw24kzXcA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F5E31C05AC9;
	Fri,  1 Mar 2024 03:37:25 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 98171492BC7;
	Fri,  1 Mar 2024 03:37:25 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 8E2A19C2BD; Thu, 29 Feb 2024 22:37:25 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo volume-index: fix an assert statement in start_restoring_volume_sub_index()
Date: Thu, 29 Feb 2024 22:37:25 -0500
Message-ID: <71a5091805b2defc74545a0e80bcb576f6bdae28.1709263751.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Use "==" instead of "=" in ASSERT() statement.

Fixes: ef074a31e88e ("dm vdo: implement the volume index")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/volume-index.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/volume-index.c b/drivers/md/dm-vdo/volume-index.c
index 8731ea1662b1..eebc19fe7d6f 100644
--- a/drivers/md/dm-vdo/volume-index.c
+++ b/drivers/md/dm-vdo/volume-index.c
@@ -834,7 +834,7 @@ static int start_restoring_volume_sub_index(struct volume_sub_index *sub_index,
 		decode_u32_le(buffer, &offset, &header.first_list);
 		decode_u32_le(buffer, &offset, &header.list_count);
 
-		result = ASSERT(offset = sizeof(buffer),
+		result = ASSERT(offset == sizeof(buffer),
 				"%zu bytes decoded of %zu expected", offset,
 				sizeof(buffer));
 		if (result != UDS_SUCCESS)
-- 
2.42.0

