Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB6933A71A;
	Fri,  6 Feb 2026 05:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354115; cv=none; b=jVXrj05J3VzlxzSKGzp5jokXmLpSrTDCYCIqyELtDwZ/FFVroeIcePqVy9HoN0Id4ZnLJSt9OcCflKP8FgM2MgVllj5KLHxba8zMFCyUT7YBbbKLXPpzGPr0cgyBWHPFd58e5pHajopMaNr8OjApOFhFeyIUVV7jh1PuMVR9P6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354115; c=relaxed/simple;
	bh=MVzAcLB7GStHyBxjs1SgTFNmn9t0HihbC+rOJgEnDzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZKefwtk7tUXaluvyvCId5+OZ7VKtFM/EP+IP0DxcOmg3mrCJasJDD4PtnN8ojVH3c/thdDqXxpNBkVRLJZsaH2cslw9SZDxfLxgX0HK0YFETSLek6W15NyIlbwb+I/tc8FSI4KUyKETuwihKQp89Sl6cUH8B70GsspHLk9Z0TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X0/uH2QL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X0/uH2QL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF1FC16AAE;
	Fri,  6 Feb 2026 05:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354115;
	bh=MVzAcLB7GStHyBxjs1SgTFNmn9t0HihbC+rOJgEnDzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0/uH2QLOOYifiwOF7/a3Itcopw3MvkDDyb+kYRQtknzFAxTX+Gt7GlfyXY/KFhv3
	 ZFGcX+62lumdJ6hYe9WgZveTGEqHhkcpO5CoZBp+Kdtm0jQqv5jTUWL9yMv4BQ7yPq
	 fgamEUMheszzdBjS7D09xExjkmipLOYe+w6hAkKcsDE4WdTj0FHVpM7GDRx0GfKY6b
	 VRt2WvEL/HyvVQuY7pIjb0lSBIbOeOVQB34HbJn8oOSe6+UG+IfI13/kz8oAIAriJt
	 mO+JOmmRTVEV73j5rHQkxliB5PArcpei31pCfE7SDh29l+XG+vGZdcN+zWT2MF04+n
	 v7GqHonTgirIQ==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 04/22] dm-verity-fec: fix the size of dm_verity_fec_io::erasures
Date: Thu,  5 Feb 2026 20:59:23 -0800
Message-ID: <20260206045942.52965-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206045942.52965-1-ebiggers@kernel.org>
References: <20260206045942.52965-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At most 25 entries in dm_verity_fec_io::erasures are used: the maximum
number of FEC roots plus one.  Therefore, set the array size
accordingly.  This reduces the size of dm_verity_fec_io by 912 bytes.

Note: a later commit introduces a constant DM_VERITY_FEC_MAX_ROOTS,
which allows the size to be more clearly expressed as
DM_VERITY_FEC_MAX_ROOTS + 1.  This commit just fixes the size first.

Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index 35d28d9f8a9b0..32ca2bfee1db7 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -45,11 +45,12 @@ struct dm_verity_fec {
 };
 
 /* per-bio data */
 struct dm_verity_fec_io {
 	struct rs_control *rs;	/* Reed-Solomon state */
-	int erasures[DM_VERITY_FEC_MAX_RSN];	/* erasures for decode_rs8 */
+	/* erasures for decode_rs8 */
+	int erasures[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN + 1];
 	u8 *output;		/* buffer for corrected output */
 	unsigned int level;		/* recursion level */
 	unsigned int nbufs;		/* number of buffers allocated */
 	/*
 	 * Buffers for deinterleaving RS blocks.  Each buffer has space for
-- 
2.52.0

