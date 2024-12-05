Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16510207679
	for <dm-devel@lists.linux.dev>; Thu,  5 Dec 2024 11:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733398957; cv=none; b=mhy7d1ZfayKvWgNgItDpXRnWPZfI2UcKRSha6/uN0yrNWBCrdO4SJR7liWor92CvZu+U8X48pYSrbHu9VgohhOoYokNMK+dYWqa0bmhBaEcsjGKqKzypBeTsW+88oYKufbWGiBPy40VBvl4/ax5bvMIpUYT0WxjjQ+uIKUtfWWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733398957; c=relaxed/simple;
	bh=9YQV1bQCQYzAGUdFZxokDRnSEPlTbnREMfLTjjseGRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=ndNIMjF2iA1d4ka6yGUtlSRUxFyI/ydj4S9CmcwUUdyqs5ffmFmyM0VXuDN+31h3O5cYGMfK83Vd9UBnsuOSpAxZv4GUWaembtRXWnJhqYYHrydz2Q9qve1pNABDQfhe9CeVzHmQbu2TAcGkry+Y53wccYl225vFsLCrqBdqBQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J9m6moOm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J9m6moOm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733398955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QNO9FLqIWDf0zA96q7mv5X6+N9pVBjpV9hgiijEuMr8=;
	b=J9m6moOmsp/F+pzpAqg+GQV4mnLK+PH0dSWgiP2R8D15qmfFAHk1rYnIsPLCFi3c/1r9J2
	oY8TkcEEn57D2nM+fpJ/p7Hju8tvUY1aFvpwHLOpp6rW0N7rMaGODcEj+VuQHAcr0MjsoL
	l2G/FZprLrqqP+wmZDHi64n3ojUi8l8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-601-vYJ359NvMLyb_jSYUvDglQ-1; Thu,
 05 Dec 2024 06:42:30 -0500
X-MC-Unique: vYJ359NvMLyb_jSYUvDglQ-1
X-Mimecast-MFC-AGG-ID: vYJ359NvMLyb_jSYUvDglQ
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B658819560BC;
	Thu,  5 Dec 2024 11:42:29 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.67.24.108])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A7A51956094;
	Thu,  5 Dec 2024 11:42:25 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH v2 2/3] dm array: fix unreleased btree blocks on closing a faulty array cursor
Date: Thu,  5 Dec 2024 19:41:52 +0800
Message-ID: <20241205114153.1496986-3-mtsai@redhat.com>
In-Reply-To: <20241205114153.1496986-1-mtsai@redhat.com>
References: <20241205114153.1496986-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bhBqamwDh28x9HP93K_nGKEePfbtcL6uNPh2n_waPbM_1733398949
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
index 4866ff56125f..0850dfdffc8c 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -960,10 +960,10 @@ EXPORT_SYMBOL_GPL(dm_array_cursor_begin);
 
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

