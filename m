Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B13134BD
	for <dm-devel@lists.linux.dev>; Mon, 25 Mar 2024 19:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711394573; cv=none; b=pGZXTxdlcAOxhpwWY5RxLJ3tyZkbfCM+2HEjs9stVgGFbBm3NqI4JJIXl9iXSWQxnJIL2qABfRa8lLgmf6LI0BM04w7EeEfkCBml1J1soim0c9jfRWHO0HkMXKc7oQaMhESujcO/kP4cCUhoX3DvPmdA61cEt5qBEmHzCQJ+V0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711394573; c=relaxed/simple;
	bh=QEGPMvU94zvDZMuMo3NFOeLXk0kaLt+/oGZaRp345sE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=k3+hP6NpOvXjKsFFhXABUzK9NdFgqKYlhdLyyInUa8QQlhBqteAzZTUEji/qRtgD+O6nLbw9kJ6l1VZsQdxcuRBY8VbsvQNF/BqR6WBdmX15O64YpBctoWqgKFH9j1lNHBP1pmiLHbrNyXW/EL3oFAEz5ixKZnzCqIrMelKWTDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i1Pyz81y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i1Pyz81y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711394569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GwTKzikMwwSQgq5ofugmCeqyMpXxX+aMj9Med6odK5w=;
	b=i1Pyz81yic/8U31mX7oaDvJeTP2QE49T5B4Lq5ZYGqHEGeh8f1eH9CA9hqdqh9REkBnCk1
	gzs60t+liXBJSi2zVBA88FTfYSJAZ+DUceKjvb3rQj1D9YvlkuSAFEZIsCeopXSdgUIUyu
	RFHLaYZAbHg7v5FK04yNhMI3d3cVwbo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-2-O2Lkd8nFM2mhLyiOzMOhkA-1; Mon,
 25 Mar 2024 15:22:46 -0400
X-MC-Unique: O2Lkd8nFM2mhLyiOzMOhkA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38766380671B
	for <dm-devel@lists.linux.dev>; Mon, 25 Mar 2024 19:22:46 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E29CB1121306;
	Mon, 25 Mar 2024 19:22:45 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id DA61BA4009; Mon, 25 Mar 2024 15:22:45 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH v2] dm vdo: use kernel byteswapping routines instead of GCC ones
Date: Mon, 25 Mar 2024 15:22:45 -0400
Message-ID: <b2243269ab0f37b1cabe5b5422841e6b50d73de1.1711394475.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Ken Raeburn <raeburn@redhat.com>

Also open-code the calls.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/murmurhash3.c | 33 ++++++++-------------------------
 1 file changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/md/dm-vdo/murmurhash3.c b/drivers/md/dm-vdo/murmurhash3.c
index 00c9b9c05001..01d2743444ec 100644
--- a/drivers/md/dm-vdo/murmurhash3.c
+++ b/drivers/md/dm-vdo/murmurhash3.c
@@ -8,33 +8,14 @@
 
 #include "murmurhash3.h"
 
+#include <asm/unaligned.h>
+
 static inline u64 rotl64(u64 x, s8 r)
 {
 	return (x << r) | (x >> (64 - r));
 }
 
 #define ROTL64(x, y) rotl64(x, y)
-static __always_inline u64 getblock64(const u64 *p, int i)
-{
-#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
-	return p[i];
-#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
-	return __builtin_bswap64(p[i]);
-#else
-#error "can't figure out byte order"
-#endif
-}
-
-static __always_inline void putblock64(u64 *p, int i, u64 value)
-{
-#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
-	p[i] = value;
-#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
-	p[i] = __builtin_bswap64(value);
-#else
-#error "can't figure out byte order"
-#endif
-}
 
 /* Finalization mix - force all bits of a hash block to avalanche */
 
@@ -60,6 +41,8 @@ void murmurhash3_128(const void *key, const int len, const u32 seed, void *out)
 	const u64 c1 = 0x87c37b91114253d5LLU;
 	const u64 c2 = 0x4cf5ad432745937fLLU;
 
+	u64 *hash_out = out;
+
 	/* body */
 
 	const u64 *blocks = (const u64 *)(data);
@@ -67,8 +50,8 @@ void murmurhash3_128(const void *key, const int len, const u32 seed, void *out)
 	int i;
 
 	for (i = 0; i < nblocks; i++) {
-		u64 k1 = getblock64(blocks, i * 2 + 0);
-		u64 k2 = getblock64(blocks, i * 2 + 1);
+		u64 k1 = get_unaligned_le64(&blocks[i * 2]);
+		u64 k2 = get_unaligned_le64(&blocks[i * 2 + 1]);
 
 		k1 *= c1;
 		k1 = ROTL64(k1, 31);
@@ -170,6 +153,6 @@ void murmurhash3_128(const void *key, const int len, const u32 seed, void *out)
 	h1 += h2;
 	h2 += h1;
 
-	putblock64((u64 *)out, 0, h1);
-	putblock64((u64 *)out, 1, h2);
+	put_unaligned_le64(h1, &hash_out[0]);
+	put_unaligned_le64(h2, &hash_out[1]);
 }
-- 
2.42.0

