Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7114A3AE1AD;
	Wed, 29 Jul 2026 05:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785302504; cv=none; b=sMekhSOL5oMJLcNYZX2dGosEdYKNWBWPMXlUVcwMy7AdN58Ene5WD12Qn9QsZBvkszN4Jk1iL3rxW/NmQkNsEspLQ7jvoYFg8QU4bPU5+4/reiT1PdeChO6D9ZuqleCP4UHQ1CzBCCkwjP9b3Oj6Yxe/zDtWDm85wYLDjQzY+LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785302504; c=relaxed/simple;
	bh=ikp/yQ8IiCT588KPYkjI+Qd7TEwFlaGTdiT7y/tPT78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZWDr1i8VUXKax6cpKluVkhxhTE23eSmePyIfHSqAnQhbyxaivDa7Ef3udDAvybjMOMZ1dlBl0n82cG67t+t9xjvIDAj2Eq3a7QpMh2qW+t/zE2twYdkQvbSfr1kRTNd0siOKtiOGvJYP38myHnnr3bINSytbgVsqPR7/Uaf/pdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DdXsm2Od; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DdXsm2Od"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B341F00AC4;
	Wed, 29 Jul 2026 05:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785302503;
	bh=kRrALytui+fONkhzpW90EwYfZcStPV3xIyo0XugwQhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DdXsm2OdZTaH5CMDUAAxYu/4Dqgq1VF7h48KR17xDLjPpdRkBFuY4tdzDeheZUSzf
	 k0QAdBF2p4iGwndmwUJ8ticDwaxnFYtz3vZP+hLy36ZaEmzT2WMOV4P0xRTFRMuUa0
	 H1Lfwif/MPFuHwSu4jEHC1qnyGMpabq3xjf0GL5B6FojtUMQi65kzxKxHAg+hulTGK
	 Q+4daIZaJ1qpGxbmR8G2YvLWlG90J8iECsmFrRFYAffcQKQNS1CSBMq/gRA9Uij445
	 pkKYuDj6yQdi+3JsW3hgOMn1ogXLD3H2wMPo0EvE/agrj9e6fGdYI+0+vRJure0dGY
	 aXqSKK6iZVR+A==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: dm-devel@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 4/4] dm-verity: fix buffer overflow in FEC calculation
Date: Tue, 28 Jul 2026 22:19:09 -0700
Message-ID: <20260729051909.62106-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729051909.62106-1-ebiggers@kernel.org>
References: <20260729051909.62106-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mikulas Patocka <mpatocka@redhat.com>

commit 31d6e6c0ba8d5a7bd59660035a089307100c5e8e upstream.

There's a buffer overflow in dm-verity-fec:

if (neras && *neras <= v->fec->roots)
	fio->erasures[(*neras)++] = i;

This allows *neras to reach roots + 1 (the post-increment pushes it past
roots). This value is then passed as no_eras to decode_rs8(). Inside the
RS decoder (lib/reed_solomon/decode_rs.c:113-121), the erasure locator
polynomial loop writes lambda[j] where j can reach nroots + 1 — one
element past the end of lambda[] (which is sized nroots + 1, valid
indices 0..nroots). The out-of-bounds write lands on syn[0], corrupting
the syndrome buffer.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Cc: stable@vger.kernel.org
Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 4 ++--
 drivers/md/dm-verity-fec.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index cebcc8fd25d70..d1e4fbc5a21d9 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -250,7 +250,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 				     (unsigned long long)block, PTR_ERR(bbuf));
 
 			/* assume the block is corrupted */
-			if (neras && *neras <= v->fec->roots)
+			if (neras && *neras < v->fec->roots)
 				fio->erasures[(*neras)++] = i;
 
 			continue;
@@ -268,7 +268,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			 * skip if we have already found the theoretical
 			 * maximum number (i.e. fec->roots) of erasures
 			 */
-			if (neras && *neras <= v->fec->roots &&
+			if (neras && *neras < v->fec->roots &&
 			    fec_is_erasure(v, io, want_digest, bbuf))
 				fio->erasures[(*neras)++] = i;
 		}
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index b3460103e0e10..8552b5d3c9152 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -50,7 +50,7 @@ struct dm_verity_fec {
 /* per-bio data */
 struct dm_verity_fec_io {
 	struct rs_control *rs;	/* Reed-Solomon state */
-	int erasures[DM_VERITY_FEC_MAX_ROOTS + 1]; /* erasures for decode_rs8 */
+	int erasures[DM_VERITY_FEC_MAX_ROOTS]; /* erasures for decode_rs8 */
 	u8 *bufs[DM_VERITY_FEC_BUF_MAX];	/* bufs for deinterleaving */
 	unsigned int nbufs;		/* number of buffers allocated */
 	u8 *output;		/* buffer for corrected output */
-- 
2.55.0

