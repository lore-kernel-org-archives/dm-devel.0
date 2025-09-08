Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572EB30AD18
	for <dm-devel@lists.linux.dev>; Mon,  8 Sep 2025 13:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757339533; cv=none; b=pRQHrqeXXf5/Xn4017f6bhxwSgih4u++xTSGQOVJT0kI4D5ycodcAUXZmY52hu1HDkb20Hk5PrLPoD+puFKVeyJ82WK/4f54Vw5By/F6WBkmacolbE5wvXX3wwRRWyBc15m/ffwKHFgqHkRCuuTpTPJMBYblgQDAPOOqZoO/mis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757339533; c=relaxed/simple;
	bh=7vQMrG3w+/ONZvnaswLXh/NwGS01wQPjH8aEjfUx3tk=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=ak2E7bOlaLb0kCWli7zHn14WoQJCOOf819Ar6fy+ixTuTbBCN9OXsUVNp7Vn7PWgz8zPTFnCCWSNHjiNuloaIEKouN+80PPbds43x2wBOjAzVal5213Em8d0JHe8SOJyrbvjtWAklN4ZB9AWd0Sn238X0jVJ1YkOuMjpa5C+SJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dggcHk3e; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dggcHk3e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757339530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=bNMfXlZG/m9jcr0HyDv6EZiBhuATxYKPs0DVcBqFS7Y=;
	b=dggcHk3e67XUg0nwS+jxqlYqDZf0pEJllkjEE5Exqf6jYUXPDvzi0F5+Wk6sHxqHqeHYyd
	CNKN57ep5x0Ad1xeWn0bSiLIV76ccJgWa/1Ss1jKmC6AY/KvaAthNXhCQuzkl9sZcrqxkV
	ZM5NxVKl5Hs5aif4Ef+SzojSfNL9Xo8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-102-1FhPTE3XONKCm0Ts_OkhMg-1; Mon,
 08 Sep 2025 09:52:08 -0400
X-MC-Unique: 1FhPTE3XONKCm0Ts_OkhMg-1
X-Mimecast-MFC-AGG-ID: 1FhPTE3XONKCm0Ts_OkhMg_1757339527
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 362CB1955F56;
	Mon,  8 Sep 2025 13:52:07 +0000 (UTC)
Received: from [10.44.32.12] (unknown [10.44.32.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C43DF1800451;
	Mon,  8 Sep 2025 13:52:04 +0000 (UTC)
Date: Mon, 8 Sep 2025 15:52:02 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
cc: dm-devel@lists.linux.dev, Ivan Abramov <i.abramov@mt-integration.ru>, 
    lvc-project@linuxtesting.org
Subject: [PATCH] dm-integrity: limit MAX_TAG_SIZE to 255
Message-ID: <c761218f-5e4c-edbe-6cce-17868b142092@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NixRLg_fVO57T8ITzc4R7HY20PFnc0hA2zCURC-mstA_1757339527
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

MAX_TAG_SIZE was 0x1a8 and it may be truncated in the "bi->metadata_size
= ic->tag_size" assignment. We need to limit it to 255.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2025-09-08 15:33:20.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2025-09-08 15:46:20.000000000 +0200
@@ -133,7 +133,7 @@ struct journal_sector {
 	commit_id_t commit_id;
 };
 
-#define MAX_TAG_SIZE			(JOURNAL_SECTOR_DATA - JOURNAL_MAC_PER_SECTOR - offsetof(struct journal_entry, last_bytes[MAX_SECTORS_PER_BLOCK]))
+#define MAX_TAG_SIZE			255
 
 #define METADATA_PADDING_SECTORS	8
 

