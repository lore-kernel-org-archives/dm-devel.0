Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49854341642;
	Fri, 19 Dec 2025 19:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766172742; cv=none; b=ue028QPhOZBNfrpoZpcHXeLlzPTQN+jBW1T7v/ncF0ikTOnqzoeQ1SnaOm1G/0Guow27Z3hTXI0Mwp3fv46DVxg45YdEpiz7HpFB+G5gflnkQE2i9yRu+ObGpyn8XHbCnQFnPeqdNZMjbt526zMeRNwIpCefl9OWAMKBRJbSSOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766172742; c=relaxed/simple;
	bh=p+4sMTAzKSmcINpoG41dphGOVe1Sj+e0jZ75a+8LR8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GASKAdrtXjxhYZPWBps6eUWZHYHbTc2Y24gmSCZiwvJP1OakllW/lTNkxvn6rqe7COTrQ3ja7B5x7NkQsU7+35Z9eHcnbWKgiEN7yTWeitZiYMHUDa+3VnRgZ5qQkTRR4GoSEDLHdUdSFd5L45iPKO7FSZgIjAl2GZgB/oTpjhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wu7vyLL1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wu7vyLL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04A2C16AAE;
	Fri, 19 Dec 2025 19:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766172742;
	bh=p+4sMTAzKSmcINpoG41dphGOVe1Sj+e0jZ75a+8LR8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wu7vyLL14yN82+kA2G9PWzbQXpvUT0KI0h8iB7PJwO903B8fQohJh93Z2FJaVLP+7
	 fz6DkKtVygD1D0tJPVe7yHB8IolZ2qYJMlVyfl0ZZbaOoKMl/Ts93h8g0n9MpNEY9u
	 4j9hjhzGs9W5re7tW3EqePk3CWNT/B9mM/Y7oOr1BH5QrpLA/rq2fthrG9hNInVcTP
	 ozQetw4E65v3LTe+Ozm876OM7xmJ/t14GR+n6a31gDYlwKfK1rGlD1T2aJBVmtSlF0
	 GZw2+TuOgj8kDOZX558Vme6PlsT1EH6ss6zNqoMMuh6UBehZLIbIfEekwUFBjaKnxT
	 usf4AHWkdUHfw==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Eran Messeri <eranm@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 5/7] dm-verity: make verity_fec_is_enabled() an inline function
Date: Fri, 19 Dec 2025 11:29:07 -0800
Message-ID: <20251219192909.385494-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219192909.385494-1-ebiggers@kernel.org>
References: <20251219192909.385494-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

verity_fec_is_enabled() is very short and is called in quite a few
places, so make it an inline function.

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 8 --------
 drivers/md/dm-verity-fec.h | 6 +++++-
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 6d0b5b4b2699..ef9970b889aa 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -20,18 +20,10 @@
 static inline unsigned int fec_max_nbufs(struct dm_verity *v)
 {
 	return 1 << (v->data_dev_block_bits - DM_VERITY_FEC_BUF_RS_BITS);
 }
 
-/*
- * If error correction has been configured, returns true.
- */
-bool verity_fec_is_enabled(struct dm_verity *v)
-{
-	return v->fec && v->fec->dev;
-}
-
 /*
  * Return an interleaved offset for a byte in RS block.
  */
 static inline u64 fec_interleave(struct dm_verity *v, u64 offset)
 {
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index 571097438311..35d28d9f8a9b 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -64,11 +64,15 @@ struct dm_verity_fec_io {
 #ifdef CONFIG_DM_VERITY_FEC
 
 /* each feature parameter requires a value */
 #define DM_VERITY_OPTS_FEC	8
 
-extern bool verity_fec_is_enabled(struct dm_verity *v);
+/* Returns true if forward error correction is enabled. */
+static inline bool verity_fec_is_enabled(struct dm_verity *v)
+{
+	return v->fec && v->fec->dev;
+}
 
 extern int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 			     enum verity_block_type type, const u8 *want_digest,
 			     sector_t block, u8 *dest);
 
-- 
2.52.0

