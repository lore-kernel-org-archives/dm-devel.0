Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBEF3D989
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 21:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f0uX4cKu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698356499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ca6xIkPR5eSAWr1Yll5Pz3QDzCIGAfoTyVKQb+o03tk=;
	b=f0uX4cKueWNFAfpdwBz2IW6Y7GlEZANCnLZ2DuMj6kfYiNofRXsJRT3O98XhRWzyWfzfGM
	7a5htIPxNiVSQsNzKN2kSUquVWmfFK58D9308MTTHcgpEHhlAOFxEWaU+AWTRkiZiaOWJW
	hB1UgApgOUIzXbvA/bYFsQu+9y1bA7s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-o8ZyKFt5Mi2Kg8xySFue2w-1; Thu, 26 Oct 2023 17:41:37 -0400
X-MC-Unique: o8ZyKFt5Mi2Kg8xySFue2w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EBA280F921;
	Thu, 26 Oct 2023 21:41:37 +0000 (UTC)
Received: from pbitcolo-build-10.permabit.com (pbitcolo-build-10.permabit.lab.eng.bos.redhat.com [10.19.117.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7002A2949;
	Thu, 26 Oct 2023 21:41:37 +0000 (UTC)
Received: by pbitcolo-build-10.permabit.com (Postfix, from userid 1138)
	id EEE8F3003D; Thu, 26 Oct 2023 17:41:36 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH v4 02/39] dm vdo: add the MurmurHash3 fast hashing algorithm
Date: Thu, 26 Oct 2023 17:40:59 -0400
Message-Id: <20231026214136.1067410-3-msakai@redhat.com>
In-Reply-To: <20231026214136.1067410-1-msakai@redhat.com>
References: <20231026214136.1067410-1-msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

MurmurHash3 is a fast, non-cryptographic, 128-bit hash. It was originally
written by Austin Appleby and placed in the public domain. This version has
been modified to produce the same result on both big endian and little
endian processors, making it suitable for use in portable persistent data.

Co-developed-by: J. corwin Coburn <corwin@hurlbutnet.net>
Signed-off-by: J. corwin Coburn <corwin@hurlbutnet.net>
Co-developed-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Co-developed-by: John Wiele <jwiele@redhat.com>
Signed-off-by: John Wiele <jwiele@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/murmurhash3.c | 175 ++++++++++++++++++++++++++++++++
 drivers/md/dm-vdo/murmurhash3.h |  15 +++
 2 files changed, 190 insertions(+)
 create mode 100644 drivers/md/dm-vdo/murmurhash3.c
 create mode 100644 drivers/md/dm-vdo/murmurhash3.h

diff --git a/drivers/md/dm-vdo/murmurhash3.c b/drivers/md/dm-vdo/murmurhash3.c
new file mode 100644
index 000000000000..c68d0d153904
--- /dev/null
+++ b/drivers/md/dm-vdo/murmurhash3.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: LGPL-2.1+
+/*
+ * MurmurHash3 was written by Austin Appleby, and is placed in the public
+ * domain. The author hereby disclaims copyright to this source code.
+ *
+ * Adapted by John Wiele (jwiele@redhat.com).
+ */
+
+#include "murmurhash3.h"
+
+static inline u64 rotl64(u64 x, s8 r)
+{
+	return (x << r) | (x >> (64 - r));
+}
+
+#define ROTL64(x, y) rotl64(x, y)
+static __always_inline u64 getblock64(const u64 *p, int i)
+{
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	return p[i];
+#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+	return __builtin_bswap64(p[i]);
+#else
+#error "can't figure out byte order"
+#endif
+}
+
+static __always_inline void putblock64(u64 *p, int i, u64 value)
+{
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	p[i] = value;
+#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+	p[i] = __builtin_bswap64(value);
+#else
+#error "can't figure out byte order"
+#endif
+}
+
+/* Finalization mix - force all bits of a hash block to avalanche */
+
+static __always_inline u64 fmix64(u64 k)
+{
+	k ^= k >> 33;
+	k *= 0xff51afd7ed558ccdLLU;
+	k ^= k >> 33;
+	k *= 0xc4ceb9fe1a85ec53LLU;
+	k ^= k >> 33;
+
+	return k;
+}
+
+void murmurhash3_128(const void *key, const int len, const u32 seed, void *out)
+{
+	const u8 *data = (const u8 *)key;
+	const int nblocks = len / 16;
+
+	u64 h1 = seed;
+	u64 h2 = seed;
+
+	const u64 c1 = 0x87c37b91114253d5LLU;
+	const u64 c2 = 0x4cf5ad432745937fLLU;
+
+	/* body */
+
+	const u64 *blocks = (const u64 *)(data);
+
+	int i;
+
+	for (i = 0; i < nblocks; i++) {
+		u64 k1 = getblock64(blocks, i * 2 + 0);
+		u64 k2 = getblock64(blocks, i * 2 + 1);
+
+		k1 *= c1;
+		k1 = ROTL64(k1, 31);
+		k1 *= c2;
+		h1 ^= k1;
+
+		h1 = ROTL64(h1, 27);
+		h1 += h2;
+		h1 = h1 * 5 + 0x52dce729;
+
+		k2 *= c2;
+		k2 = ROTL64(k2, 33);
+		k2 *= c1;
+		h2 ^= k2;
+
+		h2 = ROTL64(h2, 31);
+		h2 += h1;
+		h2 = h2 * 5 + 0x38495ab5;
+	}
+
+	/* tail */
+
+	{
+		const u8 *tail = (const u8 *)(data + nblocks * 16);
+
+		u64 k1 = 0;
+		u64 k2 = 0;
+
+		switch (len & 15) {
+		case 15:
+			k2 ^= ((u64)tail[14]) << 48;
+			fallthrough;
+		case 14:
+			k2 ^= ((u64)tail[13]) << 40;
+			fallthrough;
+		case 13:
+			k2 ^= ((u64)tail[12]) << 32;
+			fallthrough;
+		case 12:
+			k2 ^= ((u64)tail[11]) << 24;
+			fallthrough;
+		case 11:
+			k2 ^= ((u64)tail[10]) << 16;
+			fallthrough;
+		case 10:
+			k2 ^= ((u64)tail[9]) << 8;
+			fallthrough;
+		case 9:
+			k2 ^= ((u64)tail[8]) << 0;
+			k2 *= c2;
+			k2 = ROTL64(k2, 33);
+			k2 *= c1;
+			h2 ^= k2;
+			fallthrough;
+
+		case 8:
+			k1 ^= ((u64)tail[7]) << 56;
+			fallthrough;
+		case 7:
+			k1 ^= ((u64)tail[6]) << 48;
+			fallthrough;
+		case 6:
+			k1 ^= ((u64)tail[5]) << 40;
+			fallthrough;
+		case 5:
+			k1 ^= ((u64)tail[4]) << 32;
+			fallthrough;
+		case 4:
+			k1 ^= ((u64)tail[3]) << 24;
+			fallthrough;
+		case 3:
+			k1 ^= ((u64)tail[2]) << 16;
+			fallthrough;
+		case 2:
+			k1 ^= ((u64)tail[1]) << 8;
+			fallthrough;
+		case 1:
+			k1 ^= ((u64)tail[0]) << 0;
+			k1 *= c1;
+			k1 = ROTL64(k1, 31);
+			k1 *= c2;
+			h1 ^= k1;
+			break;
+		default:
+			break;
+		};
+	}
+	/* finalization */
+
+	h1 ^= len;
+	h2 ^= len;
+
+	h1 += h2;
+	h2 += h1;
+
+	h1 = fmix64(h1);
+	h2 = fmix64(h2);
+
+	h1 += h2;
+	h2 += h1;
+
+	putblock64((u64 *)out, 0, h1);
+	putblock64((u64 *)out, 1, h2);
+}
diff --git a/drivers/md/dm-vdo/murmurhash3.h b/drivers/md/dm-vdo/murmurhash3.h
new file mode 100644
index 000000000000..d84711ddb659
--- /dev/null
+++ b/drivers/md/dm-vdo/murmurhash3.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: LGPL-2.1+ */
+/*
+ * MurmurHash3 was written by Austin Appleby, and is placed in the public
+ * domain. The author hereby disclaims copyright to this source code.
+ */
+
+#ifndef _MURMURHASH3_H_
+#define _MURMURHASH3_H_
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+void murmurhash3_128(const void *key, int len, u32 seed, void *out);
+
+#endif /* _MURMURHASH3_H_ */
-- 
2.40.0

