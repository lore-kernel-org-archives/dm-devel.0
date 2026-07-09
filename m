Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AB23C09FF
	for <dm-devel@lists.linux.dev>; Thu,  9 Jul 2026 19:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783625718; cv=none; b=O9joiebLeIqeg9AWMSnm9EItoth+ujvnUBKntUCO2NEOu6DCbWgpQ2hBnLDcdmLTl9HQQtEHGaIoC3qj0JbMWQWlyTUj1qyxu53JUoVgyn9VZI8/0ivOGwPjNVDs2BbNQ9siTpPt+3hC70s2aprYZxc7a6zNSsKI/FowkeI87nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783625718; c=relaxed/simple;
	bh=HK7ElQYWAbu963RzwBz5IyvqrstPxZxHQJhJXhSRZlc=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=DlA/N0F1QJtdgkCI8oOB02cbyM/P2L/A9KpN57goOimiYSHHC7xgFC0GcZTtIfeehvN5xL8/vGGiQgS27zHcIsGJbSP8Ae/QSinkbze15po8uJ0jT9C0U5jszWUZVTJPYPzG3HYv5bx6lI58FKfPylM54MUzCh3xo1/65GXMXLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=isTNt+8f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="isTNt+8f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783625714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=OaGKIThY+ZN1284HwQ4AnUWTKefiVURK3E+IqdDDY7c=;
	b=isTNt+8fGEKXQmt3eWcX1s0mo6afZmsaRShgTIJf5Y4rKcPANEH6AzNqBKwXSlX+2Zj9PC
	aof2IN103kpgiC0YNFw23/5pvrkUpJG9Dzry/8iFk0MFP2LStZHsxsYvwkeDLHt5F8P5g7
	cwi40rkoBi2e+1y4DEXBJVUylwBGSnI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-91-yR9eCiy1PBONs6ZOA0T5pg-1; Thu,
 09 Jul 2026 15:35:11 -0400
X-MC-Unique: yR9eCiy1PBONs6ZOA0T5pg-1
X-Mimecast-MFC-AGG-ID: yR9eCiy1PBONs6ZOA0T5pg_1783625710
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 275F21956065;
	Thu,  9 Jul 2026 19:35:10 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C60EF195608A;
	Thu,  9 Jul 2026 19:35:08 +0000 (UTC)
Date: Thu, 9 Jul 2026 21:35:06 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-verity: fix a possible NULL pointer dereference
Message-ID: <39fd94b9-53ba-75c8-ba39-d67c66989d88@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FX6llr2mJzzSn3cjSiytv6nFhVJNcP-riNQGCESIQmE_1783625710
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Fix a possible NULL pointer dereference dm_verity_loadpin_is_bdev_trusted
if the device has no table.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Fixes: b6c1c5745ccc ("dm: Add verity helpers for LoadPin")
Cc: stable@vger.kernel.org

---
 drivers/md/dm-verity-loadpin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-verity-loadpin.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-loadpin.c	2023-09-05 14:45:58.000000000 +0200
+++ linux-2.6/drivers/md/dm-verity-loadpin.c	2026-07-01 13:24:12.000000000 +0200
@@ -70,7 +70,7 @@ bool dm_verity_loadpin_is_bdev_trusted(s
 
 	table = dm_get_live_table(md, &srcu_idx);
 
-	if (table->num_targets != 1)
+	if (!table || table->num_targets != 1)
 		goto out;
 
 	ti = dm_table_get_target(table, 0);

