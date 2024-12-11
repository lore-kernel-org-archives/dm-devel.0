Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79CD1F2394
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 22:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733957991; cv=none; b=dQpxVROE8PkGiOPpSTPIgCXefiMySUlumK7sDlGmm0PbmlmoTddsW0rdgVj4jr9RdnY8T79RRf02y4Mt7A+u2TwevD+cUFHCNIa7pd/bkIxwvcnTVS0rdFHxsA0dJrUR+AEmJQSWFNlWbk1xB4dWd0iJXtR0Sbm2jD0EErP+NPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733957991; c=relaxed/simple;
	bh=cul3V3zU/4WcVV4bSyJ+Yj7yT2/s5Y9DyCezcD6CC8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+Eygy+14MwHqM7mXuJpci9cQwTy0Q8yM0xEdzfyCdUbmbN6BVUF0lknO4cUtalcz7+8IA6chrN9PT6qrL1AtVAGA8JwjCdZqiz9ZZQ8c5hEWACpLEzg/f7cegEEDKXD/ZIR1Tw+KW/N1osM6X6VX/zckeHw/efqiVvsqPMxXK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ertaQwZE; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ertaQwZE"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-aa670ffe302so760964066b.2
        for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 14:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733957988; x=1734562788; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LcJ33hYwO8mDI51qDpFqEVjbcM2lfyToCby3kpo+uNM=;
        b=ertaQwZEvRw+UZ5SlH2ALpk7sLRvi7wUeHKi1tpXhCMoAphFU7c+z7+W8Ti9oBGMn/
         QrTq8GMQBS7z89UA721IJyt5iuGJlJyoeUHv24NskQccosBcZ4HeGN7lGBhGIZw+ke6j
         Fe+ytBLnuKx2GSXEzLzIW/JguabwgotkQheaKQQSllMZ7KAjE9pJJ5Rr8kPpdlcsHJ0X
         jO7YoZfQz7uh1FajesIixNt5tqKjc01z6w8yh7xSHFgFV+QUiBSwfiaFaVILnbx/hg58
         PJP4+wBJLXkZfAYmcUq+ZNt+MRoN38ssHRYa8Zzo+kXc2ekaHlfJNyUYT4hO1MlyejWY
         Bjww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733957988; x=1734562788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LcJ33hYwO8mDI51qDpFqEVjbcM2lfyToCby3kpo+uNM=;
        b=M4HEYy5ghy9m9F6xOjps3TXgqjnLQCIlD8ztphH8N2S+SNuSr5Ys5qZ6m0Y4YvpX8M
         gIS+qvk3JWPMkq/ojXVC2qX1Gh5O95Y8HE9SmgJWnrAFPKf4aqydiJNZZDWJh/yx4zg6
         pC5wJ9ip6SknYU9CS8zt8bMRujqYcvWSbqL4sxCIv3JMb0QAu9DZmhmXmaBPLHMsfzrj
         K+vCU9+B4iDzR2zd8Id1pqNPoauQ7ND0lswEpx2Nrb3VTdwe7nTGFM8JUJienuOyn53Z
         dbgl2b+M3mpNvoi3jNyBIjvwNLRbUAcwjqIPn9VMbAUXKA7C8xfP8U5TjcjpZUy/7JaA
         Ce4w==
X-Gm-Message-State: AOJu0Yx0QGJ8zLC7461brWheiMP73zzcahKjPW0j9MLQU+S4/+HQu8Cq
	JVtICaXyqXNNM5xy7YA6Y/GSbDUFiCRXtrLAlpFHsbSvege8YwRp4ISVOo5J/Gw=
X-Gm-Gg: ASbGncuCJs0QigSjOtBSlF0YiiOA4vqJYW7167m85lzjI4n2BcyYojU6IzB7HO4o2cc
	Fh0ChiP5Iq7qDXZkl6Ynryx+sIbgwNqFKgQuobFS+dXM9VYWjM+evbYObN1Xzer5Cltsta21vzt
	D20DaBqkgEkXAaB7Fd1gVrbNHhlpNnxzJUjH9+aPbO60ojWiZXQskwyEo+6/MuqxThoDj6Kjaau
	8b8RPa7qaKzOg567bJcGN6JOVQ4osjld9Bbvx+rNQqd21zVnuJs366djGapY0qZnPNFPgaUzkpc
	4hCYXijEYqrVjhST+6BCFOsPW79hRgwMwt9rffh4
X-Google-Smtp-Source: AGHT+IG5KYcHKlpQNZzn928rcym4AkyQoztwjD7pnuQDvjx8NWMmhoB+sQ4B9hqHXusWKM0j2W/oAA==
X-Received: by 2002:a17:907:7808:b0:aa6:7c8e:8085 with SMTP id a640c23a62f3a-aa6c1b09cf5mr149811166b.15.1733957987786;
        Wed, 11 Dec 2024 14:59:47 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa667925953sm703769466b.9.2024.12.11.14.59.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 14:59:47 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 09/14] multipathd: move retry_count_tick() into existing mpvec loop
Date: Wed, 11 Dec 2024 23:59:04 +0100
Message-ID: <20241211225909.298770-10-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241211225909.298770-1-mwilck@suse.com>
References: <20241211225909.298770-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index b1f0f81..fd9ea6c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2093,21 +2093,17 @@ static bool deferred_failback_tick(struct multipath *mpp)
 }
 
 static void
-retry_count_tick(vector mpvec)
+retry_count_tick(struct multipath *mpp)
 {
-	struct multipath *mpp;
-	unsigned int i;
+	if (mpp->retry_tick <= 0)
+		return;
 
-	vector_foreach_slot (mpvec, mpp, i) {
-		if (mpp->retry_tick > 0) {
-			mpp->stat_total_queueing_time++;
-			condlog(4, "%s: Retrying.. No active path", mpp->alias);
-			if(--mpp->retry_tick == 0) {
-				mpp->stat_map_failures++;
-				dm_queue_if_no_path(mpp, 0);
-				condlog(2, "%s: Disable queueing", mpp->alias);
-			}
-		}
+	mpp->stat_total_queueing_time++;
+	condlog(4, "%s: Retrying.. No active path", mpp->alias);
+	if(--mpp->retry_tick == 0) {
+		mpp->stat_map_failures++;
+		dm_queue_if_no_path(mpp, 0);
+		condlog(2, "%s: Disable queueing", mpp->alias);
 	}
 }
 
@@ -2979,8 +2975,8 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 		 */
 		if (inconsistent)
 			mpp->sync_tick = 1;
+		retry_count_tick(mpp);
 	}
-	retry_count_tick(vecs->mpvec);
 	missing_uev_wait_tick(vecs);
 	ghost_delay_tick(vecs);
 	partial_retrigger_tick(vecs->pathvec);
-- 
2.47.0

