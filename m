Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793990980;
	b=zMtbrdN7u5BRbPwny6Z9nIa4WoaBpMQyedpKde8r8skkTsiNgC71JtDA3rWGU8ymmmMM
	 v5HrSBBmVSjlPK8jVsnoYQnGKIJi57wG/xa0PprUvGl13yHtxUp7j+k2pbe7M7/kGV5Im
	 PZ0iOPy6o2RtVB/eRdp4JqO5HYpFQz/yUZN+Q2ulNIOjFehJKUtlORFzDU+bZHWumC/am
	 hodGPKQNrySKdkq+vgyqAq0WUZctqOZYSxClHehuILwBWT8I2AHh4I17rRpMezF9o0dbp
	 q1xrIJJPURS1GWnHjz9nm7VZVET8nKh9Cbvx8VxkYTtx7Z0cwHIPLAREkVfBqNxRsBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793990980;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 Message-ID:MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=SxWBb2TG4gxvfFY1MsgVWY5isVqQGGQIkTLU9koqUFo=;
	b=nR8+21u8mw+g3bv5lI+RRAhIG3PsqVyJ/3Me0cxbHemVnUqkni+MEc0JUKmGGw8Z8ejn
	 pB1JOuljROlDhpz8SX8XNbha4g4fvMrb+axo2LC+/0U544O10QeVViFft49ntKQjb4muQ
	 bHNUrDIh+Srxxeq4NZ7/6J+z/6gO+a95gqMXpq+MeLfEVwgkZq39XCpmErta2xuv5F0eE
	 3QM8hB1BqHUyRR5ew+CY88eE8Ws31J3e+3h20EZ5/ZASOPbUREQmKn5UAHGAJJEStyH3Z
	 DebMRrWttmZec0gfAJHvTxqi1LOcgMfMsl9YMCoTgM8h9lnqDykN1g7eSUq2fZ5ggMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CDUEi6Vp;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B534606A326
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 18:49:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B534606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CDUEi6Vp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793990979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=SxWBb2TG4gxvfFY1MsgVWY5isVqQGGQIkTLU9koqUFo=;
	b=CDUEi6VpIWUvF0jV7vy9f40ZHxY6QZL12YWwwcE5XDzu5gJ3g8QTAq1Yh1iHOIFj0fW1QP
	toIvMUHcnhN5VZ08L0UdeJeIRRq5lErE5zs+hMCwfZ0tl6H5Lla8f0Ov51ThVpsCw6dobI
	i3sCqP8ZTb1NCoUbTM09kc13DvHg4ac=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-225-k7Jq2mocN-CQOXsJplD0nA-1; Fri,
 06 Nov 2026 13:49:37 -0500
X-MC-Unique: k7Jq2mocN-CQOXsJplD0nA-1
X-Mimecast-MFC-AGG-ID: k7Jq2mocN-CQOXsJplD0nA_1793990977
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1A3B195609D;
	Fri,  6 Nov 2026 18:49:36 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D385195608C;
	Fri,  6 Nov 2026 18:49:35 +0000 (UTC)
Date: Fri, 6 Nov 2026 19:49:33 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm persistent data: don't leak bufio buffer if find_leaf
 fails
Message-ID: <15417305-99a7-194e-5242-3bfbfa5ee602@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qiLvX6ELNItY6wJ1l0J32D9EAOyXxsUcASKhOZA2OFo_1793990977
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

If find_leaf fails, the function dm_btree_cursor_begin would return an
error, but it would keep the dm-bufio buffers held. This would result in
a memory leak and a warning when releasing the dm-bufio cache.

This commit fixes it, so that dm_btree_cursor_begin releases the buffers
on error.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 7d111c81fa29 ("dm btree: introduce cursor api")

---
 drivers/md/persistent-data/dm-btree.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/persistent-data/dm-btree.c
===================================================================
--- linux-2.6.orig/drivers/md/persistent-data/dm-btree.c
+++ linux-2.6/drivers/md/persistent-data/dm-btree.c
@@ -1582,7 +1582,13 @@ int dm_btree_cursor_begin(struct dm_btre
 	if (r)
 		return r;
 
-	return find_leaf(c);
+	r = find_leaf(c);
+	if (unlikely(r)) {
+		dm_btree_cursor_end(c);
+		return r;
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(dm_btree_cursor_begin);
 

