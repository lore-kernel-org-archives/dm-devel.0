Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A93738F96
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 21:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710971053; cv=none; b=jgFQXI6rk4E9wjpXOwJr17uljk7mNe5YXewAupoCjpUWRfBUz8/wyPklLKSR0DkKuBEKYHQ0g3CVXVTzD/1oKucL4LKBxckvxhkAPesyUJ/hzDKl2ASu4Cltt2fQF3qvOTWbRNAqs//U4KU8xPxnJxjorW+vKoy4Bz2ju5AtZlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710971053; c=relaxed/simple;
	bh=m0UCNnGYqNebeeEFF3ycIZF35/P07SraTS8ARwge2RA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LZ9LkI+lkHURy817J+PrahWutYdoSocH3vCFTCjZ8OCDZ2mM8zA8MnLrqxSPifPfQQPV5KaMWn6Sk+6+Q3WkbdbymHsTP72+fXkZa1YNMNADwyHGEY3YtfKd6bVGcLftC7D6XBGaFDzlYybh5TtMguBxADnEqAb5vxrf5d9Va1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M6xROcce; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M6xROcce"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710971047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SG//ausP8E5IBx07HvqahXwcbmfLT0pa6Fxml3/1hxw=;
	b=M6xROcceqJiktDMpFtdctU1B1ZN5hhL/iN2BE1x7CVFBWLud9oZfnAhDvCSg37555D2Lyt
	XQvwHaRbPdr7lo8VLJ+p7ifIwKI220SrUSNXrnHKtCN3Ys5rxjC/2ORhz7Jlt0/KR8Pdxv
	wNIbqI/900qhi7ODZy5Uo00xt24V2E0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-357--eJ3oWt7OVqjklOVLnxZng-1; Wed,
 20 Mar 2024 17:44:06 -0400
X-MC-Unique: -eJ3oWt7OVqjklOVLnxZng-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07A7C3811F22
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 21:44:06 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 013C91C060D0;
	Wed, 20 Mar 2024 21:44:06 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id ED94EA3B86; Wed, 20 Mar 2024 17:44:05 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: use kernel byteswapping routines instead of GCC ones
Date: Wed, 20 Mar 2024 17:44:05 -0400
Message-ID: <fe10f7bf2332c868deb88bb59967fa1880b1b34f.1710970229.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Ken Raeburn <raeburn@redhat.com>

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/murmurhash3.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-vdo/murmurhash3.c b/drivers/md/dm-vdo/murmurhash3.c
index 00c9b9c05001..124026cb676a 100644
--- a/drivers/md/dm-vdo/murmurhash3.c
+++ b/drivers/md/dm-vdo/murmurhash3.c
@@ -8,6 +8,8 @@
 
 #include "murmurhash3.h"
 
+#include <asm/byteorder.h>
+
 static inline u64 rotl64(u64 x, s8 r)
 {
 	return (x << r) | (x >> (64 - r));
@@ -16,24 +18,12 @@ static inline u64 rotl64(u64 x, s8 r)
 #define ROTL64(x, y) rotl64(x, y)
 static __always_inline u64 getblock64(const u64 *p, int i)
 {
-#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
-	return p[i];
-#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
-	return __builtin_bswap64(p[i]);
-#else
-#error "can't figure out byte order"
-#endif
+	return le64_to_cpup(&p[i]);
 }
 
 static __always_inline void putblock64(u64 *p, int i, u64 value)
 {
-#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
-	p[i] = value;
-#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
-	p[i] = __builtin_bswap64(value);
-#else
-#error "can't figure out byte order"
-#endif
+	p[i] = cpu_to_le64(value);
 }
 
 /* Finalization mix - force all bits of a hash block to avalanche */
-- 
2.42.0

