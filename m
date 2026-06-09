Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6914190462
	for <dm-devel@lists.linux.dev>; Tue,  9 Jun 2026 00:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780964367; cv=none; b=dd4zEfJD+AOnHLaULCUasBMIF+rfVRQ1Q34UXC8SKDu3BVB1EMyV/pH0gXts4U2nEVzHOaV34Z3/OiWsrRtc/1f+Fxb673J0ZI22IIYMKpgGqKf/46+dT4GOO3wYdzr0VfxNFQXXpcKCUHKMwaWT3U3XVZ9ImWNAoam2Tszrilo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780964367; c=relaxed/simple;
	bh=mXQbBvo654TM4m3UX4MHn7iGaCl9M3vBTw2qQwHYH68=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bSFU6lsCXYSs7o1N4ZXG6mvIpVEqK74DtX1xXIudM9IHqTkTGdXfRzlz9CMuxGnTs50nVt2goGVTgmWbKFa1l2t1Ynx6STrlUvKgHRJRRUJmg709r+YMd7QctWHTcKOYkZEEr8TjN4cZU1ZSkIzXHmWXpd8a73njMjhyNsSlmNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=fQEUA4cu; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="fQEUA4cu"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8ccedaf0b54so32463316d6.0
        for <dm-devel@lists.linux.dev>; Mon, 08 Jun 2026 17:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780964365; x=1781569165; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n1EPWlXdy7BhwKjRFar7Xgsm9j9G9U3iAGy+jDcMt44=;
        b=fQEUA4cuj4pSuaQw1J6ZIWXgQ6HRU6tFdSh62gr6m0zNwfUVNXCqhAKWlydME7GIUz
         WbnMp1JULwpe+vdQRlGaHj4bPXvtZexrv7a8VvdHoa0IlFMBCbl+tksRlvPhCQYtqXqP
         BCDHXb5p4wi2Pgzh6vB7oFF6vontdUeXe+s/7pspISEiWqmzLUp1jVC1lSHvY83MgiSC
         NG1gCkP/yxNfn5o2uodiSxkI/4kmhrx/5YYo6Hlj+YWi2i+/VPJ7k7wDl2pqE/azG5xm
         +0fOSSQwT2bAZcSfc1ekQ2KYiDfpoYqeGY3KaFNtSaC7j2+UIiRrYnmtJrIPRX2Aox/k
         FxHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780964365; x=1781569165;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n1EPWlXdy7BhwKjRFar7Xgsm9j9G9U3iAGy+jDcMt44=;
        b=YqCfzkYG9uIW3gxlyHpRHHpA4YMHsBtOh0oKPDsHIy5EuNem+dtAgbsz3KgYFJGqC2
         0RfrZfIq7r2LDGR1H0BgSOISKAtc3qroBek9MvqvTQmZFEr/aw6Y91tyhxs9D6OPqYeD
         EeoyBAZ3/lDBwAALfZ3cT3WJWtMuNYGCZufvgY1XvoY/2OUvo7Cs6capPI3RI7CYTpc3
         IBjEIO4rMRa7bUvZUlV++VXO9zn+uMRzWFRCdIdg02lBY5tu2EusEWGYkT6SjR6K/ReO
         9Mmvl6478ejyT0qx5rIx4hcKozx7cdBykGmTpvZu48GHyusqVHE95+H1sJoHNjIEKpxA
         NVnw==
X-Forwarded-Encrypted: i=1; AFNElJ/gfLYPQRMnaWgYhart0e35XHqcyVd/TeN+f2Hk6jazRhYTDXXfpBTSwZCe5hX9dx/r+b18ns58jA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzCIbj+BsitkVqVXC+yRFfZK+PcyGONygsnvQNWaYh68l1NOwfF
	v+x/s9RjJ30+qvoqLLZhAHDwDLMfWJg/izPg2r/ToEokfYZsFHDfPCJMwLrzpdJ+d28=
X-Gm-Gg: Acq92OHvcOa682qGv0F40CAMKCQcRnJyiLDOcXhnqaps/Tlpcgc/ITGRfEnQLaLW4OV
	LE9d/4c/6Fr4cDQXmkSuPgDBylTXtEItRCA4VMySFN9+zI5Nla94QNZdYcUNAQW69iJ9IMBr7jK
	mWyXMpCN3RDTJLmAIPEQfJyRnWjcD/VLhzB7IFWh+kV+h37qn7g5ooKPQr/Ce+LV8pTPO4zfu0G
	DeSgQETRdK8/r9bVCLQwwt+IIDjNRXePpN3IeDvKSbH82US3E1azBc5kDcIFUWu8Lz8xJvCOsMi
	l/h+FoKfVXivtwBKJdFwkBD/Q/4qHApvB9tH0x37BMParpaaN0GG0xUUfW+HbJ+ztyWrxmsic9v
	jCdOJyLN5ixGALg+vrEnTaM69X4jSe9MOIhjcCi/rYDwpVmqrjAL7mG8MdoIncYH5g4vEY+LQMw
	TlZaJKvM8udY9bbNy/QjbdMn5XXvrAq5B1NbZZ8A==
X-Received: by 2002:a0c:e01b:0:b0:8ce:a40d:9b76 with SMTP id 6a1803df08f44-8cee611f947mr238663826d6.23.1780964364715;
        Mon, 08 Jun 2026 17:19:24 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-8ceccda0611sm184145716d6.1.2026.06.08.17.19.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 17:19:23 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dm cache: reject oversized invalidate_cblocks values
Date: Tue,  9 Jun 2026 00:16:37 +0000
Message-ID: <20260609001636.1235504.7288d2831f6d.dm-cache-invalidate-cblock-truncation@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

invalidate_cblocks parses the cache block number into an unsigned long
long, but then stores it in a narrower cblock_t.  Values that do not fit
in the target type are silently truncated before the cache block is
invalidated.

That can make a request for one cache block invalidate a different
block.  It also makes the userspace-visible control file accept input
that cannot be represented by the mapping it is about to update.

Reject cache block numbers that do not round-trip through cblock_t
before using them.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
 drivers/md/dm-cache-target.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 097315a9bf0f..5f1a019a9a8d 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -3330,6 +3330,9 @@ static int parse_cblock_range(struct cache *cache, const char *str,
 	r = sscanf(str, "%llu-%llu%c", &b, &e, &dummy);
 
 	if (r == 2) {
+		if (b > U32_MAX || e > U32_MAX)
+			return -EINVAL;
+
 		result->begin = to_cblock(b);
 		result->end = to_cblock(e);
 		return 0;
@@ -3341,8 +3344,11 @@ static int parse_cblock_range(struct cache *cache, const char *str,
 	r = sscanf(str, "%llu%c", &b, &dummy);
 
 	if (r == 1) {
+		if (b > U32_MAX || b == U32_MAX)
+			return -EINVAL;
+
 		result->begin = to_cblock(b);
-		result->end = to_cblock(from_cblock(result->begin) + 1u);
+		result->end = to_cblock(b + 1);
 		return 0;
 	}
 
-- 
2.43.0

