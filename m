Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88ACF31326F;
	Wed, 29 Jul 2026 05:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785302503; cv=none; b=mbEQmsFn3HIs+AY5PQgMy4qgT/aoXtvLYmvOxc2rN2qGXxGYye+APl0nTlYkZyFrNWvvt7tRKxAIRLXuDpePxbFoGIKtcHhUjxbiESj8JC/P+g2ozgADMFh8XY3gomB4fQS3SZwEhNa/rzqC9UZhs0EOzcEQEj6XqfAYmgD8wo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785302503; c=relaxed/simple;
	bh=Y2/1SvhbCn4Z2DO5JqKA8o7VYxi4VzVwua96y+H9SSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pb/8/+XZnyM45BTWTdTfO2ol+Oa4j3Ni6nr2ASnSXKPfqWqVvUJg9vevHdtGTgnB3yyaEbQz51hMpHDmZhxI1DYdTGIKxdMt6ciSMgRnMRrUoowSZDmnRoNHqmTdy3ZCQWSvnd+7+9Rj9NtrCUvzhjM4k7c1VeWR9Em81RrogOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OFIXX39U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OFIXX39U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425811F00A3D;
	Wed, 29 Jul 2026 05:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785302502;
	bh=vFA2ctGShjkd2EkQRFAccBU+PiBQO3If8BuRTz4gMik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OFIXX39U1eIcYx6KeA71pX+WAm2IBy59HPJjLIQd1CNqtzHmL7Nh6lqsS1ZhBi5RI
	 c0yA7WbSzp6SGF6fTdFfRNFGNmac9YjsnLO4nQbx6+qpsb9akZNpGQDBPUskVHPx0Z
	 QhSnPRmeZF7h+uJ1y0C7QrncuSN7bV5s234U1SDhqcH4HUwUGGmbb4X+GzUf3zG97c
	 1FfiZ2kBJrh1kuxumL51/rrr2VSjSKwmh8f77xRE30zZrU+U/9DEg2KfvAc9EL7Asx
	 D7iG5C0dSBIADHFjVwam9CwiuXtgmR6bXCGpX3GIiVoRaES7YasNna6nJtCdExcG+V
	 NOFNORmpj+2dQ==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: dm-devel@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 1/4] dm-verity-fec: fix the size of dm_verity_fec_io::erasures
Date: Tue, 28 Jul 2026 22:19:06 -0700
Message-ID: <20260729051909.62106-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729051909.62106-1-ebiggers@kernel.org>
References: <20260729051909.62106-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit a7fca324d7d90f7b139d4d32747c83a629fdb446 upstream.

At most 25 entries in dm_verity_fec_io::erasures are used: the maximum
number of FEC roots plus one.  Therefore, set the array size
accordingly.  This reduces the size of dm_verity_fec_io by 912 bytes.

Note: a later commit introduces a constant DM_VERITY_FEC_MAX_ROOTS,
which allows the size to be more clearly expressed as
DM_VERITY_FEC_MAX_ROOTS + 1.  This commit just fixes the size first.

Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-verity-fec.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index ec37e607cb3f0..90a0af3f35d31 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -50,7 +50,8 @@ struct dm_verity_fec {
 /* per-bio data */
 struct dm_verity_fec_io {
 	struct rs_control *rs;	/* Reed-Solomon state */
-	int erasures[DM_VERITY_FEC_MAX_RSN];	/* erasures for decode_rs8 */
+	/* erasures for decode_rs8 */
+	int erasures[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN + 1];
 	u8 *bufs[DM_VERITY_FEC_BUF_MAX];	/* bufs for deinterleaving */
 	unsigned int nbufs;		/* number of buffers allocated */
 	u8 *output;		/* buffer for corrected output */
-- 
2.55.0

