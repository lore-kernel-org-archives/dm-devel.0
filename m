Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF02339B56;
	Tue, 16 Dec 2025 23:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765926421; cv=none; b=u3FJFVrxterxat91P36GPCr28WzXoCpyuJLr1Z4U1bpbdk/6dJanVes6SAPFb9a350c44g8bFrOuk8KlZp0BROcY1aTmbmcJyRFnxpO+Hnt2TPWwI8ybC4MypbIDIlVxp5W7FJZt4rfDeCf1s2Sehaj3i0DHX+uz9FA0wq4jsUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765926421; c=relaxed/simple;
	bh=4rOCzxv5aNWtsKAqZ0yqbsxZ5bMrwQ43Lj+0r+Efthc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrjV/PFheSL5Dhi08H8eurvP4TVeA0QxPpgQWiOerva8Am7RjKBkqbO75Bm3g+nx0l6iQ0AYKW/w1csjfVYKKlTwOI6N5sbG0Rf6MCxUNtO2FABDHb17jEDajwU1j/uxf+EpEExQvjFLLNPrjCt3uVnk0RDs6atLKLDU6GoGWTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LtDXepCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LtDXepCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929C5C19425;
	Tue, 16 Dec 2025 23:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765926420;
	bh=4rOCzxv5aNWtsKAqZ0yqbsxZ5bMrwQ43Lj+0r+Efthc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LtDXepCgFHTv1AqdX7AUyKdYf4YD5fc6pHUhRn0Kca6zEnHYH1jZM0/C/ZclMTH+I
	 uQ4f6XD9RC80CbU+rQdKf/C+HRNNiRj8Bo5AP4LUbnS7zlONMVhXMON3u5rvVG4tUZ
	 0K8W94WT49xndr2Ri1QROMVLslr6TPpN7TC+efTmWjcUqZICPm3iKlzPXbnjLWtlLO
	 XGCXtYwgz1IdmKvyXhCOXVe9//G5Smc/Fd/A0xy3Xy7eOVel1c/5UujJodwiEZx99T
	 XM9el85ejXImTZ5tGdknrz3qtEEUSKJjlsvXOeXtdM9kf1w6XYVOemJB1XBgknzoAY
	 zqdMklCGc2yXA==
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
Subject: [PATCH 5/7] dm-verity: make verity_fec_is_enabled() an inline function
Date: Tue, 16 Dec 2025 15:06:12 -0800
Message-ID: <20251216230614.51779-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216230614.51779-1-ebiggers@kernel.org>
References: <20251216230614.51779-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

verity_fec_is_enabled() is very short and is called in quite a few
places, so make it an inline function.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 8 --------
 drivers/md/dm-verity-fec.h | 6 +++++-
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 7574e65c32ae..9bf93280cf33 100644
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
index 84f8299673ff..a002cb5c96c5 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -65,11 +65,15 @@ struct dm_verity_fec_io {
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

