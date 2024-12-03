Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C372315E5B8
	for <dm-devel@lists.linux.dev>; Tue,  3 Dec 2024 17:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733248157; cv=none; b=WuEfdXof9mt1lIVOdw+EVE3A3ApOkLyouWzpff2mQ4QnTCWw48B61/lKQ9Y8n2v6l37qpR0BoM42kbTxXoi7xg4iVU9Gr/cvKO+NdAY/Doe2VaJ4ME+o8EcpXv+KOxO51fUqw/PaLIPCC/ozss2Da9pmbGzPKAkQHA0LxqDqPDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733248157; c=relaxed/simple;
	bh=pnqZh8KhbzXOe03iO+I7zAzieNyrd8HjHjLkoZQkAwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=b3CSn8zY8elLhXT+BrOk9DRSaJOr/lCiOaHxW7GPqdjJtDPkdCvqU3bp6NmIzQxfCykXaamC5+RsaSnJPsn6US4KinTAxZi1K0XUtx9AHy3KB7V/K4CKyV0kItycGjoqnP8SJdql1afkEq/ZZ5V0au5aGZzr3fI+Etk2Txp2trI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i5v3oFMc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i5v3oFMc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733248152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WilombPjhCFfMtjBeUjA8yg0oZFVL0V/uUAxjGEBSR4=;
	b=i5v3oFMc2WfyStwewASqb3kaXTpWPeSc2MLGl5Xwqr7vpx2X7DvXUFTh8xLkkeh+r9OrHi
	mCyRo9MLsjcB8mtzWA2Z4So1V826das3KXlm9cqW8LvVBb40PwUWZfOSSHc2qm84GPORhS
	Orba3a5XQYmqaPunRHjwN460S29asho=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-7-NE8Bi7ZOM5Ci_OH-tOhzbA-1; Tue,
 03 Dec 2024 12:49:11 -0500
X-MC-Unique: NE8Bi7ZOM5Ci_OH-tOhzbA-1
X-Mimecast-MFC-AGG-ID: NE8Bi7ZOM5Ci_OH-tOhzbA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D98AE1954AF2;
	Tue,  3 Dec 2024 17:49:10 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.67.24.41])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7161A30000DF;
	Tue,  3 Dec 2024 17:49:07 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH 2/3] dm array: fix unreleased btree blocks on closing a faulty array cursor
Date: Wed,  4 Dec 2024 01:48:57 +0800
Message-ID: <20241203174857.1259403-1-mtsai@redhat.com>
In-Reply-To: <20241203173756.1257967-1-mtsai@redhat.com>
References: <20241203173756.1257967-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QYd7fv2BXVq_j9mDNr_lEgi7Tzm3FME-dgklhc1BOHA_1733248151
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

The cached block pointer in dm_array_cursor might be NULL if it reaches
an unreadable array block, or the array is empty. Therefore,
dm_array_cursor_end() should call dm_btree_cursor_end() unconditionally,
to prevent leaving unreleased btree blocks.

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Fixes: fdd1315aa5f0 ("dm array: introduce cursor api")
---
 drivers/md/persistent-data/dm-array.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index c46a374f7459..1c3af717ee4f 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -961,10 +961,10 @@ EXPORT_SYMBOL_GPL(dm_array_cursor_begin);
 
 void dm_array_cursor_end(struct dm_array_cursor *c)
 {
-	if (c->block) {
+	if (c->block)
 		unlock_ablock(c->info, c->block);
-		dm_btree_cursor_end(&c->cursor);
-	}
+
+	dm_btree_cursor_end(&c->cursor);
 }
 EXPORT_SYMBOL_GPL(dm_array_cursor_end);
 
-- 
2.47.0

