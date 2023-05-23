Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 775B0C7EE29
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 21:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684878359;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LrvIudlj872DJzQZe24mFB9vQx+M+ZcCl1TdJy9cIlY=;
	b=EstXlWJCuR1KvCErqSa874A2FEes9nZRf6CZ45ku9u2AlryRYvSH28bOJk9oGW+pgl26ea
	Z1aeVERi3bJRMjBnuFs8GSXKR2x4QwQFo6iCNVyLYO2Cy9nb8toPL5pJr/jUYQgmi195XJ
	gDputUHs/MN8eOeZ0SJO0ZY8uPiLNVs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-kcMAgm29OWyrzGzTEc41wA-1; Tue, 23 May 2023 17:45:57 -0400
X-MC-Unique: kcMAgm29OWyrzGzTEc41wA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE588101AA44;
	Tue, 23 May 2023 21:45:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 96535200B401;
	Tue, 23 May 2023 21:45:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 63DA919465B1;
	Tue, 23 May 2023 21:45:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D9E8119465B6
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 21:45:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B75B120296C8; Tue, 23 May 2023 21:45:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AF12720296C6
 for <dm-devel@redhat.com>; Tue, 23 May 2023 21:45:50 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EFAC811E85
 for <dm-devel@redhat.com>; Tue, 23 May 2023 21:45:50 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-mxzc0eDUMcmUnqBrUd0ApQ-1; Tue, 23 May 2023 17:45:49 -0400
X-MC-Unique: mxzc0eDUMcmUnqBrUd0ApQ-1
Received: by mail-qv1-f69.google.com with SMTP id
 6a1803df08f44-6238c63845aso835666d6.3
 for <dm-devel@redhat.com>; Tue, 23 May 2023 14:45:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684878348; x=1687470348;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=/W7OJHL92lUHH48ytLmCoCkEDFoG/94300gJczLQVak=;
 b=hU7/R3wsitkCQdr+xrrtR8i1Pf6sN7uJOKTJnW8KPK/qOfEks5AdTajmoCjj7j/aRD
 J4vq/12bK7G7z069M46k8SwJS1zhpnxLE1NQe26W7u+xDkacj9S+34uJfwkXgdD/v73D
 A7Dmtt90rfot9kxBuyRm70u/SzVJsiVbocxv0exaa0RFo5AoQwkVeqOkvsfsT+86Xx12
 UqDg4qSTfpY0ywTuHyZWSeSmAESVomk47lM0fgSk/+YKK9AiuMljDMAWznrnMw9uG/ge
 UWe/3iZFndEcw0xCJgKJVclpLh3aGFrjqrpV7lwR11JYMDUsWT/SgNauvlccpmhpUyJ1
 Q3HA==
X-Gm-Message-State: AC+VfDzwhWCZ2lrd1bvVESa6D7otcc1YLX+7kQFv2MAif7DBVeLaIpJq
 Syl4UfAWhmoHfVqSN03PcyePep1nY9Z/+JFd55NfHKeR9MVZaweB9yJ4dQgVzn4ZXqAJC2cShKf
 MbGAxSmJjfUOelJg0nNYMpHr6kNy9WRegvPgQFngO4gMuZhGyuvFS8D/aOHImvKoHH/0SUPrb
X-Received: by 2002:a05:620a:19a9:b0:75b:399a:2224 with SMTP id
 bm41-20020a05620a19a900b0075b399a2224mr382105qkb.28.1684878348563; 
 Tue, 23 May 2023 14:45:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7tSLnpI38iij/VIHdRocpFfh0uKyRu4A+7fXW3Uf50SJh0f0oYgkpWEO1cvW4Nn5vLUnCR+w==
X-Received: by 2002:a05:620a:19a9:b0:75b:399a:2224 with SMTP id
 bm41-20020a05620a19a900b0075b399a2224mr382083qkb.28.1684878348218; 
 Tue, 23 May 2023 14:45:48 -0700 (PDT)
Received: from bf36-1.. (173-166-2-198-newengland.hfc.comcastbusiness.net.
 [173.166.2.198]) by smtp.gmail.com with ESMTPSA id
 s24-20020ae9f718000000b0074fafbea974sm2821592qkg.2.2023.05.23.14.45.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 May 2023 14:45:47 -0700 (PDT)
From: "J. corwin Coburn" <corwin@redhat.com>
To: dm-devel@redhat.com,
	linux-block@vger.kernel.org
Date: Tue, 23 May 2023 17:45:02 -0400
Message-Id: <20230523214539.226387-3-corwin@redhat.com>
In-Reply-To: <20230523214539.226387-1-corwin@redhat.com>
References: <20230523214539.226387-1-corwin@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v2 02/39] Add the MurmurHash3 fast hashing
 algorithm.
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
Cc: vdo-devel@redhat.com, "J. corwin Coburn" <corwin@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

MurmurHash3 is a fast, non-cryptographic, 128-bit hash. It was originally
written by Austin Appleby and placed in the public domain. This version has
been modified to produce the same result on both big endian and little
endian processors, making it suitable for use in portable persistent data.

Signed-off-by: J. corwin Coburn <corwin@redhat.com>
---
 drivers/md/dm-vdo/murmurhash3.c | 175 ++++++++++++++++++++++++++++++++
 drivers/md/dm-vdo/murmurhash3.h |  15 +++
 2 files changed, 190 insertions(+)
 create mode 100644 drivers/md/dm-vdo/murmurhash3.c
 create mode 100644 drivers/md/dm-vdo/murmurhash3.h

diff --git a/drivers/md/dm-vdo/murmurhash3.c b/drivers/md/dm-vdo/murmurhash3.c
new file mode 100644
index 00000000000..c68d0d15390
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
index 00000000000..d84711ddb65
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
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

