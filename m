Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330FD341064;
	Fri, 19 Dec 2025 19:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766172742; cv=none; b=UV1ZIXHI/iSw83EeAlLpv84grU6/BK/x6YlrGOqQK2HMd3gGANXykD+SVG8iHmyt/mU6pFIQX0KyJz5iAghK+QPbzxRBYwE87F4qtR9bk8WmwB1TvqvJg2VuNieS/IMvC4MwyS+LS06r5cC+1oZS9jftG5nKoQmtArIit2GuYJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766172742; c=relaxed/simple;
	bh=kPsjF/dWVSwkT2udSNrV5NqQ02RSAP3NxDsJkhrY2dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eabb1VR/X8Nss2kkYzdfbfASiNOdZgdir3Uq2z37WoUJOnvBSb4lfk1KyzyUKqBt3vKLb6av/cWvHSIaHSdJC29L8JvLPJd6vGffp2IjHStMJ09QeKnPgivClwPctLUdSKtKkx/VkUFYuJsOzqtFOO+ceviLk8MnwzaUErA0ww4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u0d8OXTt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u0d8OXTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C66EC19424;
	Fri, 19 Dec 2025 19:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766172741;
	bh=kPsjF/dWVSwkT2udSNrV5NqQ02RSAP3NxDsJkhrY2dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0d8OXTt98x3oFhlQdvgtS4yGRc4dYBs1MHEzlEQHQpKMmHzpjDXQboePMBH1knyd
	 S3LNeTIUzr3FOjizkKTItKlZw6x91QZGZ3BB4XNdyKK+T+jGcYtFrVKBHiB+Rl9tPT
	 yQd9yzoNBRUTD9IgDZGgvfTQ254ROWxrkyjawQR2f+bnuOrRqOotlkThPGEd10Sm2W
	 ykcFUV9OXO6jVF0p4/1m8/dD36GXdfbM7NRBOTVEyh0o75fdFY/7i/s3GdBU99uKf8
	 Sf81srdEiMQpI8cNqVo1uH/FVIAWsNAYvZuytLMKN4nrapv+a2T0mDB8jK+pLweged
	 MGMu3YCu6+THg==
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
Subject: [PATCH v2 4/7] dm-verity: remove unnecessary ifdef around verity_fec_decode()
Date: Fri, 19 Dec 2025 11:29:06 -0800
Message-ID: <20251219192909.385494-5-ebiggers@kernel.org>
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

Since verity_fec_decode() has a !CONFIG_DM_VERITY_FEC stub, it can just
be called unconditionally, similar to the other calls in the same file.

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-target.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index c9f5602a42c6..777a0ebe8536 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -433,15 +433,13 @@ static int verity_handle_data_hash_mismatch(struct dm_verity *v,
 	if (verity_recheck(v, io, want_digest, blkno, data) == 0) {
 		if (v->validated_blocks)
 			set_bit(blkno, v->validated_blocks);
 		return 0;
 	}
-#if defined(CONFIG_DM_VERITY_FEC)
 	if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA, want_digest,
 			      blkno, data) == 0)
 		return 0;
-#endif
 	if (bio->bi_status)
 		return -EIO; /* Error correction failed; Just return error */
 
 	if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA, blkno)) {
 		io->had_mismatch = true;
-- 
2.52.0

