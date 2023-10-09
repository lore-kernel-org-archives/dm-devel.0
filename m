Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE410CD68FE
	for <dm-devel@archiver.kernel.org>; Tue, 10 Oct 2023 07:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696921395;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xNW2T+KonFrP8XdijuLjedPrn/RE00o+jJLhtwzkrB0=;
	b=jJanJhO7+Cfz9/Uh7TmH3wcnivYm5S/iyAwGLJEKYXjVxXMFOOZft1WilIpS4u688HS7fb
	aNYHFfVUpB+/J2V7conPIgj+mldzmfyPa4z5DKOa/W0xFaejz8d+lxlIshQF2mI5yG3WNE
	okiYqIxoTTniTWKeuX1FzgcX5ZNQVlU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-3TAAqVntMkOkycvBB10N1w-1; Tue, 10 Oct 2023 03:03:12 -0400
X-MC-Unique: 3TAAqVntMkOkycvBB10N1w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B230F3C0E649;
	Tue, 10 Oct 2023 07:03:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A0A592026D37;
	Tue, 10 Oct 2023 07:03:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5075A19451CC;
	Tue, 10 Oct 2023 07:02:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 650AD19465A0
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 Oct 2023 15:14:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 546DC3C54; Mon,  9 Oct 2023 15:14:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DE3E36EF
 for <dm-devel@redhat.com>; Mon,  9 Oct 2023 15:14:51 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C48A811E88
 for <dm-devel@redhat.com>; Mon,  9 Oct 2023 15:14:51 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-Nn-N8Fm8OheD8DXoKAzN-Q-5; Mon, 09 Oct 2023 11:14:44 -0400
X-MC-Unique: Nn-N8Fm8OheD8DXoKAzN-Q-5
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="369232320"
X-IronPort-AV: E=Sophos;i="6.03,210,1694761200"; d="scan'208";a="369232320"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
 by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 09 Oct 2023 08:13:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="869288072"
X-IronPort-AV: E=Sophos;i="6.03,210,1694761200"; d="scan'208";a="869288072"
Received: from newjersey.igk.intel.com ([10.102.20.203])
 by fmsmga002.fm.intel.com with ESMTP; 09 Oct 2023 08:13:33 -0700
From: Alexander Lobakin <aleksander.lobakin@intel.com>
To: Yury Norov <yury.norov@gmail.com>
Date: Mon,  9 Oct 2023 17:10:21 +0200
Message-ID: <20231009151026.66145-10-aleksander.lobakin@intel.com>
In-Reply-To: <20231009151026.66145-1-aleksander.lobakin@intel.com>
References: <20231009151026.66145-1-aleksander.lobakin@intel.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mailman-Approved-At: Tue, 10 Oct 2023 07:02:51 +0000
Subject: [dm-devel] [PATCH 09/14] bitmap: extend bitmap_{get,
 set}_value8() to bitmap_{get, set}_bits()
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
Cc: linux-s390@vger.kernel.org, ntfs3@lists.linux.dev,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 David Ahern <dsahern@kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
 Alexander Potapenko <glider@google.com>,
 Simon Horman <simon.horman@corigine.com>, Jakub Kicinski <kuba@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Sometimes there's need to get a 8/16/...-bit piece of a bitmap at a
particular offset. Currently, there are only bitmap_{get,set}_value8()
to do that for 8 bits and that's it.
Instead of introducing a separate pair for u16 and so on, which doesn't
scale well, extend the existing functions to be able to pass the wanted
value width. Make both offset and width arbitrary, but in order to not
over complicate the current logic and keep the helpers as optimized as
the current ones, require the width to be a pow-2 value and the offset
to be a multiple of the width, while the target piece should not cross
a %BITS_PER_LONG boundary and stay within one long.
Avoid adjusting all the already existing callsites by defining oneliner
wrapper macros named after the former functions. bloat-o-meter shows
almost no difference (+1-2 bytes in a couple of places), meaning the
new helpers get optimized just nicely.

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
---
 include/linux/bitmap.h | 51 ++++++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 63e422f8ba3d..9c010a7fa331 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -6,8 +6,10 @@
 
 #include <linux/align.h>
 #include <linux/bitops.h>
+#include <linux/bug.h>
 #include <linux/find.h>
 #include <linux/limits.h>
+#include <linux/log2.h>
 #include <linux/string.h>
 #include <linux/types.h>
 
@@ -569,38 +571,59 @@ static inline void bitmap_from_u64(unsigned long *dst, u64 mask)
 }
 
 /**
- * bitmap_get_value8 - get an 8-bit value within a memory region
+ * bitmap_get_bits - get a 8/16/32/64-bit value within a memory region
  * @map: address to the bitmap memory region
- * @start: bit offset of the 8-bit value; must be a multiple of 8
+ * @start: bit offset of the value; must be a multiple of @len
+ * @len: bit width of the value; must be a power of two
  *
- * Returns the 8-bit value located at the @start bit offset within the @src
- * memory region.
+ * Return: the 8/16/32/64-bit value located at the @start bit offset within
+ * the @src memory region. Its position (@start + @len) can't cross
+ * a ``BITS_PER_LONG`` boundary.
  */
-static inline unsigned long bitmap_get_value8(const unsigned long *map,
-					      unsigned long start)
+static inline unsigned long bitmap_get_bits(const unsigned long *map,
+					    unsigned long start, size_t len)
 {
 	const size_t index = BIT_WORD(start);
 	const unsigned long offset = start % BITS_PER_LONG;
 
-	return (map[index] >> offset) & 0xFF;
+	if (WARN_ON_ONCE(!is_power_of_2(len) || offset % len ||
+			 offset + len > BITS_PER_LONG))
+		return 0;
+
+	return (map[index] >> offset) & GENMASK(len - 1, 0);
 }
 
 /**
- * bitmap_set_value8 - set an 8-bit value within a memory region
+ * bitmap_set_bits - set a 8/16/32/64-bit value within a memory region
  * @map: address to the bitmap memory region
- * @value: the 8-bit value; values wider than 8 bits may clobber bitmap
- * @start: bit offset of the 8-bit value; must be a multiple of 8
+ * @start: bit offset of the value; must be a multiple of @len
+ * @value: new value to set
+ * @len: bit width of the value; must be a power of two
+ *
+ * Replaces the 8/16/32/64-bit value located at the @start bit offset within
+ * the @src memory region with the new @value. Its position (@start + @len)
+ * can't cross a ``BITS_PER_LONG`` boundary.
  */
-static inline void bitmap_set_value8(unsigned long *map, unsigned long value,
-				     unsigned long start)
+static inline void bitmap_set_bits(unsigned long *map, unsigned long start,
+				   unsigned long value, size_t len)
 {
 	const size_t index = BIT_WORD(start);
 	const unsigned long offset = start % BITS_PER_LONG;
+	unsigned long mask = GENMASK(len - 1, 0);
 
-	map[index] &= ~(0xFFUL << offset);
-	map[index] |= value << offset;
+	if (WARN_ON_ONCE(!is_power_of_2(len) || offset % len ||
+			 offset + len > BITS_PER_LONG))
+		return;
+
+	map[index] &= ~(mask << offset);
+	map[index] |= (value & mask) << offset;
 }
 
+#define bitmap_get_value8(map, start)				\
+	bitmap_get_bits(map, start, BITS_PER_BYTE)
+#define bitmap_set_value8(map, value, start)			\
+	bitmap_set_bits(map, start, value, BITS_PER_BYTE)
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __LINUX_BITMAP_H */
-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

