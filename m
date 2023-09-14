Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF915EEAA65
	for <dm-devel@archiver.kernel.org>; Thu, 14 Sep 2023 19:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694719027;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7xYg1qzitNKQonNTY9fie00jgiQgA4g0eRYGlnkCkIc=;
	b=UO3Ym0wNTd4xDm+0z309wFgfFv5/AOmrNWwwrn7dsblXQXUQj89yQuoTTrtLmXzFrCF87T
	o5aeAjuNGYrdkl2W21H+pEFJP2RI+kPE0ISk/9kKSTj8U/sIDm6oWJMyC37H7hTHuhH2fm
	ucz+AcUzaGp8DqGvBucLx4OopyD2GzY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-tqy9luQOMkuP8e3hZYMDYw-1; Thu, 14 Sep 2023 15:17:05 -0400
X-MC-Unique: tqy9luQOMkuP8e3hZYMDYw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5BA3A857A9C;
	Thu, 14 Sep 2023 19:17:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7590221B2413;
	Thu, 14 Sep 2023 19:17:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0BC7A19465B7;
	Thu, 14 Sep 2023 19:16:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8A5E91946588
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Sep 2023 19:16:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 742A02026D76; Thu, 14 Sep 2023 19:16:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B7EE2026D4B
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:16:44 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BC3B88B7A6
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:16:44 +0000 (UTC)
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com
 [209.85.222.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-247-CTjLHlHxM06rIY5n0efeew-1; Thu, 14 Sep 2023 15:16:42 -0400
X-MC-Unique: CTjLHlHxM06rIY5n0efeew-1
Received: by mail-qk1-f173.google.com with SMTP id
 af79cd13be357-76de9c23e5cso86235185a.3
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 12:16:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694719002; x=1695323802;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=C+vnaY2MjKWlN0amihbEfPx7PpH86f9n1riz2S2dS4Y=;
 b=IhmpdjaBqeQ0+GWrGYGLCvYNt5hdf4a0makrVLjV4zF97xKwPMWBLGyXR8UdtdWbpv
 2ONQ5uf9Ts2O7ONdw8VWKZ1kD6pKzc81wpLJPLJ030RVBeffP0jwsMm4bmSxuYexBm61
 N1nYwqN/iyMlBO3qZtP2odKo6+c5Jv30HbMs0Ia2EQzy9QENWKiGHMooYo3BlY8yKoJI
 WsWd0qCdGMiwTjnFnAFs9fdTJvAAhVX1Pi1HUgHdYbpyRYFx+eJAoXkVraEvck8XehCG
 DzjLp5jZM7nn3xp7obl+PXFbBL82Ec8n7n5bJGfFM5QLkVLa3tAqxroRKXFRll3YQrGC
 tgIA==
X-Gm-Message-State: AOJu0YyCibMHcjI00YHOLSNLvrqnzWErnZSgB6nN5FBJiuXX5UspGCGO
 Ud1wEAUfX1YOzD/S+RzHamiVUctGfu0y81hCob6IwtKvXuNZmgJamGzWC1uld54FMIGKxJvHonX
 gwKulzTHMrXS5URwcykjGUZ20RuifqZIoXFQT9jo87e9O0y1MdB4rNYL2dF597416euVGIYjh
X-Google-Smtp-Source: AGHT+IE/x0KbhZN6gcCabo7m0SryVqO1pdGCMYJvsfBMoX6cc7ecWIDRgnq+w6gz2Q83msBhvgC2yA==
X-Received: by 2002:a05:620a:5590:b0:76e:f73d:5fd3 with SMTP id
 vq16-20020a05620a559000b0076ef73d5fd3mr4611493qkn.72.1694719001765; 
 Thu, 14 Sep 2023 12:16:41 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 p9-20020a05620a132900b0077241440be8sm682610qkj.7.2023.09.14.12.16.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Sep 2023 12:16:40 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Thu, 14 Sep 2023 15:15:58 -0400
Message-Id: <20230914191635.39805-3-snitzer@kernel.org>
In-Reply-To: <20230914191635.39805-1-snitzer@kernel.org>
References: <20230914191635.39805-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v3 02/39] dm vdo: add the MurmurHash3 fast
 hashing algorithm
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Matthew Sakai <msakai@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Matthew Sakai <msakai@redhat.com>

MurmurHash3 is a fast, non-cryptographic, 128-bit hash. It was
originally written by Austin Appleby and placed in the public
domain. This version has been modified to produce the same result on
both big endian and little endian processors, making it suitable for
use in portable persistent data.

Co-developed-by: J. corwin Coburn <corwin@hurlbutnet.net>
Signed-off-by: J. corwin Coburn <corwin@hurlbutnet.net>
Co-developed-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Co-developed-by: John Wiele <jwiele@redhat.com>
Signed-off-by: John Wiele <jwiele@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
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

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

