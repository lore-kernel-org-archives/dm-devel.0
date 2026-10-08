Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99243E9C3C
	for <dm-devel@lists.linux.dev>; Thu,  8 Oct 2026 20:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791491300; cv=none; b=YQNDegmBLYc+pVJsxqsMYa5X2ZQNsiYsQAIcILteoG3nzhXfF0KqKfo32zk/JFiYYYDqxHc3AYg+RMi4v10vL+UTdqFScrswqP5pvRbgNPjCxOxyTeE7ZO+il0eu7KCbb9Jh8Yqvoq2a4PGpwz+3hmYS31qnyFOXBR4ONGN36EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791491300; c=relaxed/simple;
	bh=uxQ3NwmH0lZz5q1YfzZDGrDNn1WNnYtHTzxmoMd3Uu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=mir9ObembRdTPnCrJQGRHfCJybitRLkpde8UKSWU0k1lT/EnYkvqyBEQ/WejZgYfuCBKqPaVb72qyOlRXeRVGMKmTfyc/x9BALkbFCMWQnEgaqLRxMFM7pXZe71uunqPVg76DKC7/AHmbxgO5/s2cktou2L4CJBwt9CN5yd1oa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DX56Dxah; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DX56Dxah"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791491298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=++LipES7asPRf7eNmQPSyxR9bUyQVnOY23CbNQ/LAWE=;
	b=DX56Dxah5zMVl9oEiljw3pGTugUXzgU5eshtyeZHkeUjIzfap6ufT5V1pkOGPQAet4dYoZ
	8+fcvQo1jf7IvjX6L0diYuSBlVj5m4uYpSREp//d7Xh2SloYMXXgPATHXFAPLmDB9N/VMh
	sGmZ3MOBreNobza2KSqH2GgaDuJjzSc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633-ZZz63LRTMjaH1lQyzRmKLw-1; Thu,
 08 Oct 2026 16:28:15 -0400
X-MC-Unique: ZZz63LRTMjaH1lQyzRmKLw-1
X-Mimecast-MFC-AGG-ID: ZZz63LRTMjaH1lQyzRmKLw_1791491294
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 916361954223;
	Thu,  8 Oct 2026 20:28:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 28CB85BC;
	Thu,  8 Oct 2026 20:28:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 698KSC301976823
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 8 Oct 2026 16:28:13 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 698KSCnZ1976822;
	Thu, 8 Oct 2026 16:28:12 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 1/3] dm-mpath: streamline setup work in the HST path selector
Date: Thu,  8 Oct 2026 16:28:07 -0400
Message-ID: <20261008202809.1976567-2-bmarzins@redhat.com>
In-Reply-To: <20261008202809.1976567-1-bmarzins@redhat.com>
References: <20261008202809.1976567-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Y2jCM2hGkDlnzdl7joCNA5tHFjJPdDbUDzgMTK28oGg_1791491294
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

fixed_power() is convoluted and does unnecessary work here, since
hst_set_weights() calculates x^n for n = [1,64]. x^1 is x, and x^(n) is
just x * x^(n-1), so all these values can be trivially computed from the
previous value.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-ps-historical-service-time.c | 49 +++-------------------
 1 file changed, 6 insertions(+), 43 deletions(-)

diff --git a/drivers/md/dm-ps-historical-service-time.c b/drivers/md/dm-ps-historical-service-time.c
index c4755112287a..e6324424d23a 100644
--- a/drivers/md/dm-ps-historical-service-time.c
+++ b/drivers/md/dm-ps-historical-service-time.c
@@ -36,6 +36,7 @@
 #define HST_FIXED_SHIFT 10  /* 10 bits of decimal precision */
 #define HST_FIXED_MAX (ULLONG_MAX >> HST_FIXED_SHIFT)
 #define HST_FIXED_1 (1 << HST_FIXED_SHIFT)
+#define HST_FIXED_POINT_5 (1 << (HST_FIXED_SHIFT - 1))
 #define HST_FIXED_95 972
 #define HST_MAX_INFLIGHT HST_FIXED_1
 #define HST_BUCKET_SHIFT 24 /* Buckets are ~ 16ms */
@@ -66,46 +67,6 @@ struct path_info {
 	u64 outstanding;
 };
 
-/**
- * fixed_power - compute: x^n, in O(log n) time
- *
- * @x:         base of the power
- * @frac_bits: fractional bits of @x
- * @n:         power to raise @x to.
- *
- * By exploiting the relation between the definition of the natural power
- * function: x^n := x*x*...*x (x multiplied by itself for n times), and
- * the binary encoding of numbers used by computers: n := \Sum n_i * 2^i,
- * (where: n_i \elem {0, 1}, the binary vector representing n),
- * we find: x^n := x^(\Sum n_i * 2^i) := \Prod x^(n_i * 2^i), which is
- * of course trivially computable in O(log_2 n), the length of our binary
- * vector.
- *
- * (see: kernel/sched/loadavg.c)
- */
-static u64 fixed_power(u64 x, unsigned int frac_bits, unsigned int n)
-{
-	unsigned long result = 1UL << frac_bits;
-
-	if (n) {
-		for (;;) {
-			if (n & 1) {
-				result *= x;
-				result += 1UL << (frac_bits - 1);
-				result >>= frac_bits;
-			}
-			n >>= 1;
-			if (!n)
-				break;
-			x *= x;
-			x += 1UL << (frac_bits - 1);
-			x >>= frac_bits;
-		}
-	}
-
-	return result;
-}
-
 /*
  * Calculate the next value of an exponential moving average
  * a_1 = a_0 * e + a * (1 - e)
@@ -123,7 +84,7 @@ static u64 fixed_ema(u64 last, u64 next, u64 weight)
 {
 	last *= weight;
 	last += next * (HST_FIXED_1 - weight);
-	last += 1ULL << (HST_FIXED_SHIFT - 1);
+	last += HST_FIXED_POINT_5;
 	return last >> HST_FIXED_SHIFT;
 }
 
@@ -167,8 +128,10 @@ static void hst_set_weights(struct path_selector *ps, unsigned int base)
 	if (base >= HST_FIXED_1)
 		return;
 
-	for (i = 0; i < HST_WEIGHT_COUNT - 1; i++)
-		s->weights[i] = fixed_power(base, HST_FIXED_SHIFT, i + 1);
+	s->weights[0] = base;
+	for (i = 1; i < HST_WEIGHT_COUNT - 1; i++)
+		s->weights[i] = (base * s->weights[i - 1] +
+				 HST_FIXED_POINT_5) >> HST_FIXED_SHIFT;
 	s->weights[HST_WEIGHT_COUNT - 1] = 0;
 }
 
-- 
2.53.0

