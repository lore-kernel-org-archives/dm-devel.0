Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057421A6824
	for <dm-devel@lists.linux.dev>; Sun, 28 Jun 2026 15:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782659530; cv=none; b=rs+mVsYiKA7YKtk8pjibikfIbTaJ8aO4rWpUXsqr64Zc4CHjJwlEDMEswESsy7S5AE+pA9wT9xv9jpeUPFPvTSSN2ScnQNKcObvmQ0znGrROfN+w4dl/T+R8s/Or6vHHkPBE1/Ankl4j8EHd2+/iDjvK144oeURQngb0noP7yw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782659530; c=relaxed/simple;
	bh=DPrJiuhZ2KvpIwvRDGA2vWUoMG3uH2LbJqAs5WJW3rw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mpW/zi71I+gJVzB8XZJN+eiNM7QGfYG5wXWDFM1ozj21+Pymg4vBC/bj1IkIdQEn49ru0+qHlHRa3oQ2eHhrPZgZ67sx8fslf4R7Q6cABIav36Ber2AnK0EV8Wm1luWVjcqoAIWwmhm3p61sgXBkgp6Q4t3IrJwvds4w1qD4JE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=doBpXg6J; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="doBpXg6J"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-9159951f05aso333594285a.0
        for <dm-devel@lists.linux.dev>; Sun, 28 Jun 2026 08:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1782659527; x=1783264327; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lv0fW+wQn41e4tFDheX0OpKWimqloBhZtw7itNudSzM=;
        b=doBpXg6JbqBcZ36rCus0YHT4LIU92vzAqtBlyrY2dUfpTxS0dzTDb3+ieqLWBtw70z
         UaoMrOz1SCPxzL5CenAbUuVgmMFMoiZCV7Sq1jNgWR/2n+UY8EbhHcOL/P+83fjlyseD
         KGrDdRM/bY0XNPKeXId1FORUeFUmqxbfGvAvlzQTAqKlP3Ns55PKZ1HX0rYVsk1whdBF
         WzegoZpQJJQ3IWj7BgidQQnb865pTbPQwTrgJtfzWKjHQb84y/fPImugnle9B7jnqfaX
         JWC7CDYZtFkKWTB1pieGiuy4Vkhb9lcRsWNkcsSR9zp+o+IagVkdu+yYw3j0ZSWrR0I0
         ZYZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782659527; x=1783264327;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lv0fW+wQn41e4tFDheX0OpKWimqloBhZtw7itNudSzM=;
        b=MfX4vAICsOSP4fyIRlejPV+YE3Ke53GKUtkJDxpFyNmYw8mkGsCDA4GTU1BCJaw9Na
         ECkGRyl4cNzMWEjRLpjcJUbylpFsMRbfh+EJdDFzjsg7vprky26nBRv2miuRqhKagbit
         WMf7j/hK0piwNntsIssjkamteZZYjgLnPOKgDLWGpPHlDhp+TDOl136heigwPdsEoZjD
         rZ1EtEZKoYmL6SzHw2fqaHat2ujEMHtKWf9lx2BPjJJTGc78WO31TrwGANMSaXQLmVpT
         ltNUD/xYf2XIF/SzQyIOUfunxFMM5cR978eI7xUvMWtd7NJawcyWh3nWJnNP20qmWrCN
         Fwzg==
X-Forwarded-Encrypted: i=1; AFNElJ9YsatArSLaB5q2jN7oraNpaFWZIF61IGhXv6rME3A8Zj+ILH3hRGG89kkxquIrhwedryXndF+Nmg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyA49KmBKYKCHwEs2F5bKg9tpWYgRezeQQBHeHvfH7O19g7evb6
	K+f7Saj1s8dSqspMzqSDS5DP6Lf0zkIFAbeVzZvbNubiBgX95JkhqvFVYVgDAQjpy04=
X-Gm-Gg: AfdE7ck28JxoHRwLyVHspVToAcw0eF1qz8jXdNmepgP2wFo1AuIZXTlNsL2ghuvh5ac
	GnmoPVD2Ahib2K3IQoTxndsbi7gtn8AnsIpHQ5IdSLa7BuOrvD14i2nGiuNjHFArsk5BV97p9H3
	uLd2vJM84wHg3tDH/vEEpAHbV7r3TOrsKIukObDn37ETX/IXFfRtsVhGDlkOHqHpTEK38YFruAW
	BnmHTmgH1HLqkVbFpUvWotvJSeASHT6GEF50tcqLTSIrK82+gPIEYsrwoUtfkqMjLNO6j/gQBCp
	TnKeEkpDEkRwRrx9VXBx5DlOsx0He/OchFzf7CeIGYdWUaQ1KalMNVWdVhbhRr9MSDiHKPdQY4q
	Ken/euO8YPFSR3b4uU2STxPN/XbKPSi8DxHHw9EONmfpAwHNeO+jjf+JtDfWOW+pgwwbj4RJAwq
	xf9GB2cFlDTuxWNkiX
X-Received: by 2002:a05:620a:2592:b0:920:eb4b:602 with SMTP id af79cd13be357-9293c5fcccamr2005907585a.31.1782659526659;
        Sun, 28 Jun 2026 08:12:06 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-926004ac1b8sm1748617185a.36.2026.06.28.08.12.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jun 2026 08:12:04 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dm cache: parse invalidate_cblocks with kstrtoull()
Date: Sun, 28 Jun 2026 15:11:55 +0000
Message-ID: <20260628151139.75447.cf67e9b6b484.dm-cache-invalidate-cblock-truncation@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

invalidate_cblocks parses cache block numbers with sscanf() and then
stores them in the narrower dm_cblock_t type.  Values larger than the
cblock representation are truncated before invalidation, so a request
for one cache block can invalidate a different block.

Checking the parsed value after sscanf() is not sufficient because
sscanf() does not reliably reject values beyond U64_MAX before storing
into the destination.  Such inputs can still be converted to a wrapped
u64 value and then pass a later range check.

Parse each single value or range endpoint with kstrtoull() instead, and
reject values that do not fit in dm_cblock_t before converting them to
cblock values.  The existing range validation continues to reject empty
or out-of-cache ranges, including the single-value U32_MAX case whose
exclusive end wraps to zero.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
 drivers/md/dm-cache-target.c | 48 +++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 097315a9bf0f..35c1eea48116 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -16,6 +16,7 @@
 #include <linux/dm-kcopyd.h>
 #include <linux/jiffies.h>
 #include <linux/init.h>
+#include <linux/kstrtox.h>
 #include <linux/mempool.h>
 #include <linux/module.h>
 #include <linux/rwsem.h>
@@ -3311,6 +3312,26 @@ struct cblock_range {
 	dm_cblock_t end;
 };
 
+static int parse_cblock(const char *str, size_t len, uint64_t *result)
+{
+	char *buf;
+	int r;
+
+	if (!len)
+		return -EINVAL;
+
+	buf = kstrndup(str, len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	r = kstrtoull(buf, 10, result);
+	kfree(buf);
+	if (r)
+		return r;
+
+	return *result > U32_MAX ? -EINVAL : 0;
+}
+
 /*
  * A cache block range can take two forms:
  *
@@ -3320,32 +3341,35 @@ struct cblock_range {
 static int parse_cblock_range(struct cache *cache, const char *str,
 			      struct cblock_range *result)
 {
-	char dummy;
+	const char *dash = strchr(str, '-');
 	uint64_t b, e;
 	int r;
 
-	/*
-	 * Try and parse form (ii) first.
-	 */
-	r = sscanf(str, "%llu-%llu%c", &b, &e, &dummy);
+	if (dash) {
+		r = parse_cblock(str, dash - str, &b);
+		if (r)
+			goto bad;
+
+		r = parse_cblock(dash + 1, strlen(dash + 1), &e);
+		if (r)
+			goto bad;
 
-	if (r == 2) {
 		result->begin = to_cblock(b);
 		result->end = to_cblock(e);
 		return 0;
 	}
 
-	/*
-	 * That didn't work, try form (i).
-	 */
-	r = sscanf(str, "%llu%c", &b, &dummy);
-
-	if (r == 1) {
+	r = parse_cblock(str, strlen(str), &b);
+	if (!r) {
 		result->begin = to_cblock(b);
 		result->end = to_cblock(from_cblock(result->begin) + 1u);
 		return 0;
 	}
 
+bad:
+	if (r == -ENOMEM)
+		return r;
+
 	DMERR("%s: invalid cblock range '%s'", cache_device_name(cache), str);
 	return -EINVAL;
 }
-- 
2.43.0

