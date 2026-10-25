Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792948574;
	b=uOcmG5SB3adTvwON69BM7Nk+Vwm63NJW4+SWYT0YG9y4ftUrv/YmH3v8sH6MnUX++Xmt
	 aXaLfq7O/7ltnmy7hcIQOCTjKEbg8zi6A4xWeWMNy/E8H7/HFw/eHFmCyvmtq5kopf8Im
	 /VKchVkhm+tvO9LIx+VlDNqe/X8JgHWyn16kasEbcTMizDbp2c1cDMkRAEzFHMH6S9SpJ
	 c7gX0a2bRJEXurrM0JuN+XzYFl99IEOC25DUMYw2rHsbDB/idPn9rrtkRw4Hvh3JmlnRY
	 CwFwAMZvfb+3aRhmFR1zrv+ccKPtMid5An58np6NiMBv7yEhOUSVWR56/SFZ+LVxYuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792948574;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID;
	bh=s0xqJx4FNZZGpD4GSNg7lqsUdPl9TgZ5j+xnD9OspHY=;
	b=GmTcAaJ8rUt7Ael78elBPKGJkupjzK5ZbEyxJsmZfKRF2JIrRL+BGcScjFFhFiuN9umL
	 2e1jaP87AQSQyQ/oMqX8tWODASGr68q8A4HUvblqgoDdaY2XpzAH4YAdFRaOFuZ6lvPEp
	 bdeY69x44Y3XMvvvUrBnSmtMyrkXzX4p795ok4u8lBaeS5pFmbhnokoOIqtP1PSm8s62R
	 HPF91simLrnoaDCZKYUsBbpD8bk76m+A1XjfIudFn3SIivj8xjW4zaJZk1k6I0lo82Vju
	 ZxVBWxBJZViUIizWnhTPkCHeZPfj5jFBiGs6jJ6UGOdeMKNntJlsBkEpDFSWzC1q49g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BLob2oAB;
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C8D606A31B
	for <dm-devel@lists.linux.dev>; Sun, 25 Oct 2026 17:16:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2C8D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BLob2oAB
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-15ea896ddc8so3923793c88.0
        for <dm-devel@lists.linux.dev>; Sun, 25 Oct 2026 10:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792948573; x=1793553373; darn=lists.linux.dev;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s0xqJx4FNZZGpD4GSNg7lqsUdPl9TgZ5j+xnD9OspHY=;
        b=BLob2oABNoTAUUhDi77SrlV/KtbNYl2EZUWacBWFtbAwjvCI+/X18FWKG0d1iN1BhQ
         Ltz4WuGx9KbJxN6sdoHv4rSoXLzHeWhuTPo286080Lp9wAxtj8nD50oS9hcZKZZxi4bo
         Xn+AuPq+389y++I272/gbUzaZox8tkp5dwfeX7MreSHFStw8H2k4gHEmduaPbkh72MW4
         SfAzV9Q3OdkBKjkkMvTU/ryprSs4MxjGC2KSw0cBOpPouDMGlwxvSe3ukrLw8O7q9miG
         fF8jEZIdWgeHguw7Y3JszUDgYQeEH6r1CU16QU5v7sFcZeMCY7W6izNZWk/ZhIYJ/Vf5
         v5gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792948573; x=1793553373;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=s0xqJx4FNZZGpD4GSNg7lqsUdPl9TgZ5j+xnD9OspHY=;
        b=Q1qxiyllt38vLrtE0tkPVj5k65BxuucVNc0Syjw75iIHolmlBT7l43UXo+CrauCJse
         jBOzxcw5VKpqaIyvCc/fR2h16TANL9pcVQUD5A7Dt1vRaYTtZSKWGW0KPEIlVupY7y1u
         igeS+S0ns+flazhXj+Bt0JqiNvXRtoWqlo4qvNf0QsYx77X5OtuVXyYiljOi4usk37mF
         VHtABaYU68wHJdYwPvBDqVW/rp48mJC7tpy6TQFfO53NbOjlahZPkuM/J4I1OYwR27PA
         G4WPAjtmBSAw4JyRMHy/dwMn8nm7gHcENRhIK6/2Y9yOFkjV3g/vdtfpe0K1SUgxWkdn
         JLNA==
X-Forwarded-Encrypted: i=1; AKwUvBxiPSxyzykExNEAQ3SNVgArbENEPXGu6wjgnfeede7ReIhNxJLhSn0cnVe7rRxQ1WvKQevU0HSSag==@lists.linux.dev
X-Gm-Message-State: AFq9FYL9x6OLj2DkTr6H1aEjEG7bjYxRNbqyL1C7U9kjUvbGe4t/CMEv
	WvKbfHvuCRhHpE9E2N6aB0mnVkczkpj+YxMHvP9vcj5LzCuWkUhAEkTK
X-Gm-Gg: AYBFou0Pch0VP1Tl2oOkN4z4B7dEDXPnXXqMTy+onASjXLxF+qiHdE6LUeby0GqWEPz
	uq9qA/fxYVsJNEIUzFhLkAX29E0XAdi4PwboIjaeaSl2D0zgWCxFKpTHbrSFWvVBSh0MyXOYB2I
	1rQB0gv2Cv9HyiZpR0q5D695WtAdDsWP6TZINyT3r5aE+HSe0NVgoEUKFVLOsAqc3tStrFYak7t
	QTqa1MYGKgrYRlLVAPXYxH7EeHJZJzKytxgA/viKxF9IUx7Fv9iwbl67y8oq6yfToJIIojQUGQy
	VgcJP3Z9NFORb5RXApMMwHLPsdk09wAtjiD1gin+roBB/eYOF0Sx9ii5JBssXNK4OVmusbzyRig
	ttCozoNtlX2qf/ceumAdkxLXsUH07KqXbkKaUnrqM0TBaLuSLKyizIVP09SZrjBBG5zicc/RA79
	smmzT+JhEDO9d2ozqva24BUjX6MdkChZUEhHhIX27KFmKQbG765TXglg/7kEpQsVPCP7aJo4T4r
	TNiudaZXvZ7cifKEiGqQQ1VEI+H4jQW+NHy3GsXZU2vifydZLFycpcQN2mu7g==
X-Received: by 2002:a05:7022:7f14:b0:150:c9c5:1ce4 with SMTP id a92af1059eb24-19928f1541dmr6475921c88.6.1792948572672;
        Sun, 25 Oct 2026 10:16:12 -0700 (PDT)
Received: from [192.168.45.62] ([218.48.198.193])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19886f790e4sm17125652c88.0.2026.10.25.10.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 10:16:12 -0700 (PDT)
From: "Baek Kyu, Kim" <pocj8ur4in@gmail.com>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: [PATCH] dm-stats: Avoid cumulative rounding in time conversion
Date: Mon, 26 Oct 2026 02:16:09 +0900
Message-ID: <179294856968.68681.9038736644973708510.c14-dm-stats@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

dm_jiffies_to_msec64() converts a 22-bit chunk to milliseconds, rounds
it up, then multiplies that rounded value by the number of chunks. At
HZ=300, the chunk length is not an integral number of milliseconds, so
the rounding error grows with the accumulated time. For 4,194,305
jiffies, a stats print reports 13,981,018 ms instead of 13,981,017 ms.

Divide the full jiffies value by HZ and convert the remainder to
milliseconds once. This gives a single rounding of the total while
avoiding an overflowing multiplication of the full input. Preserve the
precise timestamp path, which already returns nanoseconds unchanged.

Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
---
Tested under ARM64 QEMU/KVM with HZ=300 through the DM stats ioctl
path on a zero target, using injected time values. At 4,194,305
jiffies, the baseline printed 13,981,018 ms in all six time fields and
the patched kernel printed 13,981,017 ms. Precise timestamps and
stats_print_clear also passed.

 drivers/md/dm-stats.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index beabbe3b39f3..9ec568d120a4 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -9,6 +9,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/math64.h>
 #include <linux/device-mapper.h>
 
 #include "dm-core.h"
@@ -831,23 +832,15 @@ static int dm_stats_clear(struct dm_stats *stats, int id)
  */
 static unsigned long long dm_jiffies_to_msec64(struct dm_stat *s, unsigned long long j)
 {
-	unsigned long long result;
-	unsigned int mult;
+	u64 result;
+	u32 remainder;
 
 	if (s->stat_flags & STAT_PRECISE_TIMESTAMPS)
 		return j;
 
-	result = 0;
-	if (j)
-		result = jiffies_to_msecs(j & 0x3fffff);
-	if (j >= 1 << 22) {
-		mult = jiffies_to_msecs(1 << 22);
-		result += (unsigned long long)mult * ((j >> 22) & 0x3fffff);
-	}
-	if (j >= 1ULL << 44)
-		result += (unsigned long long)mult * (unsigned long long)(1 << 22) * (j >> 44);
-
-	return result;
+	result = div_u64_rem(j, HZ, &remainder);
+	return result * MSEC_PER_SEC +
+		DIV_ROUND_UP_ULL((u64)remainder * MSEC_PER_SEC, HZ);
 }
 
 static int dm_stats_print(struct dm_stats *stats, int id,
