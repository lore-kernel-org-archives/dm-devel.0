Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC85633FE3A;
	Tue, 16 Dec 2025 23:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765926420; cv=none; b=LABhVMVb3RmgtvobMQtlspQdDTv6QtW/VpOYH8d01vVeo4VNy86o5Ff0rmwu8H2y69T8kVW+zY1c5p2TiljhusrcWt5c8mu2sWNmqzB31FJ9rpGv+p1ow2+m7CXfaaVVrzXzMGbFvyCNrSmHzTHMq5QHTXjom5UqtkxNg71FEZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765926420; c=relaxed/simple;
	bh=ii/pzsDkIuJnj07CZ5YWMIAJVOiHvCKyLJBcJQPA+KI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlXZamZswZThsX4C03jlqS7qP0YnSj/Ht3oNSp0yXXjwPa5T5UahJH6iqkpN1SnX7XvOqa0BNrJYj+iOHfzTnL/EnwUZkBSdW3hejk1isdKcOAkeABKtdcckO2Q+a0USmTQCiyHN6n7I3D/fu8oYZUFC/Hk3EXRA471JxbX2nCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tLqxWXqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tLqxWXqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD14C19422;
	Tue, 16 Dec 2025 23:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765926420;
	bh=ii/pzsDkIuJnj07CZ5YWMIAJVOiHvCKyLJBcJQPA+KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLqxWXqhhMKThx42HRHxsGpI0eDZQRAX+/wHNCrzV8iNEO75rmZboJjcAORI99kL3
	 kLvPPjlksAFHPgGEbyIQKsYJkFUeKPIv45FFOv1GzappzeehoHKjyYQXRWkTHPRekA
	 6gCTrAWcU+TIMmDJb6R56vpLblJ7EmZoALrohgGJlsI6fEB+4lfDKLgZjG7ZAZCwlr
	 eWZ8bZOOpaweCwkDGysOM68XbeT4oK1dJp1pFI1LFyb6k1A9ivxQQqoxNPzT0IlRsL
	 a6eVAnDR/B2pC5VqS2DKydGK5jpQ0iZ9AO6mDjILFMxhZUOGxHUmsB+W0ezNWUym5C
	 HYftmqxBqcrfg==
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
Subject: [PATCH 4/7] dm-verity: remove unnecessary ifdef around verity_fec_decode()
Date: Tue, 16 Dec 2025 15:06:11 -0800
Message-ID: <20251216230614.51779-5-ebiggers@kernel.org>
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

Since verity_fec_decode() has a !CONFIG_DM_VERITY_FEC stub, it can just
be called unconditionally, similar to the other calls in the same file.

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

