Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB12207E12
	for <dm-devel@lists.linux.dev>; Thu,  5 Dec 2024 11:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733398976; cv=none; b=XBpNIvMdL28FJ2DKJyFRzvgyBDzmbCTdgOO3RiOPlHS3aSY4UX/NFlwRyg4UUVAEcp27kV/cmmn9aYVO1p3USfFwaFoAng9FuV0iEpXkxwaPpTorznRJQnFwc5TXnDSd6TT3F3GnVos58YlvM2mjOb+EZF2+5VRhICUiJL0YjXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733398976; c=relaxed/simple;
	bh=xHuJ2Z2bSmCo0Hm1iTg1LQEKiRWGqlQk4PzkWmtuxYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=oWKlb4iqpsk/rzkP/d0ZBmUWabW6+n6Aopow3bwKm+6p4zxnBRw1/zYCeNfyGT2ihLF94TyoOrlHmOFaAPChycSITcM1ZyOMuaLAVyWUUGEUfm2wE/8e0OvmnEVIE3WiYnqt0Ati232Ak+5SBl9ZVwgFPQX69qP3s9/JA8AtAds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X06cNDfC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X06cNDfC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733398974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Te8ZvVw+O5gq4halpcCzze57tU3DuBnleFTWqguRczw=;
	b=X06cNDfCoZZQtLrEwV8KnK6LlK6k6n0n4oB+MGAnOUIMhi7cP+y7SnBhC7S0ZQK/hI45lW
	j15eOWuJB+zMa0WA3J5sIkx4QmGmEZIG2h7WLsAqDNvmyemAy3k4HCCC7td+lHVheYnmgc
	yTRa1IUEcFuD9bSU67IIAD2eRXaB3DA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-427-2nmQ7ydEO_61CuwQZFidyQ-1; Thu,
 05 Dec 2024 06:42:22 -0500
X-MC-Unique: 2nmQ7ydEO_61CuwQZFidyQ-1
X-Mimecast-MFC-AGG-ID: 2nmQ7ydEO_61CuwQZFidyQ
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 987F91955F43;
	Thu,  5 Dec 2024 11:42:21 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.67.24.108])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4607D1956094;
	Thu,  5 Dec 2024 11:42:17 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH v2 1/3] dm array: fix releasing a faulty array block twice in dm_array_cursor_end
Date: Thu,  5 Dec 2024 19:41:51 +0800
Message-ID: <20241205114153.1496986-2-mtsai@redhat.com>
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
X-Mimecast-MFC-PROC-ID: H3am9WRaS2APCSc0CKDjl41BRYhyDads6rYky7Ct31g_1733398941
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When dm_bm_read_lock() fails due to locking or checksum errors, it
releases the faulty block implicitly while leaving an invalid output
pointer behind. The caller of dm_bm_read_lock() should not operate on
this invalid dm_block pointer, or it will lead to undefined result.
For example, the dm_array_cursor incorrectly caches the invalid pointer
on reading a faulty array block, causing a double release in
dm_array_cursor_end(), then hitting the BUG_ON in dm-bufio cache_put().

Reproduce steps:

1. initialize a cache device

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
dmsetup create corig --table "0 524288 linear /dev/sdc $262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1
dmsetup create cache --table "0 524288 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"

2. wipe the second array block offline

dmsteup remove cache cmeta cdata corig
mapping_root=$(dd if=/dev/sdc bs=1c count=8 skip=192 \
2>/dev/null | hexdump -e '1/8 "%u\n"')
ablock=$(dd if=/dev/sdc bs=1c count=8 skip=$((4096*mapping_root+2056)) \
2>/dev/null | hexdump -e '1/8 "%u\n"')
dd if=/dev/zero of=/dev/sdc bs=4k count=1 seek=$ablock

3. try reopen the cache device

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
dmsetup create corig --table "0 524288 linear /dev/sdc $262144"
dmsetup create cache --table "0 524288 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"

Kernel logs:

(snip)
device-mapper: array: array_block_check failed: blocknr 0 != wanted 10
device-mapper: block manager: array validator check failed for block 10
device-mapper: array: get_ablock failed
device-mapper: cache metadata: dm_array_cursor_next for mapping failed
------------[ cut here ]------------
kernel BUG at drivers/md/dm-bufio.c:638!

Fix by setting the cached block pointer to NULL on errors.

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Fixes: fdd1315aa5f0 ("dm array: introduce cursor api")
---
 drivers/md/persistent-data/dm-array.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index 157c9bd2fed7..4866ff56125f 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -917,23 +917,27 @@ static int load_ablock(struct dm_array_cursor *c)
 	if (c->block)
 		unlock_ablock(c->info, c->block);
 
-	c->block = NULL;
-	c->ab = NULL;
 	c->index = 0;
 
 	r = dm_btree_cursor_get_value(&c->cursor, &key, &value_le);
 	if (r) {
 		DMERR("dm_btree_cursor_get_value failed");
-		dm_btree_cursor_end(&c->cursor);
+		goto out;
 
 	} else {
 		r = get_ablock(c->info, le64_to_cpu(value_le), &c->block, &c->ab);
 		if (r) {
 			DMERR("get_ablock failed");
-			dm_btree_cursor_end(&c->cursor);
+			goto out;
 		}
 	}
 
+	return 0;
+
+out:
+	dm_btree_cursor_end(&c->cursor);
+	c->block = NULL;
+	c->ab = NULL;
 	return r;
 }
 
-- 
2.47.0

