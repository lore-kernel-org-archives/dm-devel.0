Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621DD33EAEC;
	Fri,  6 Feb 2026 05:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354119; cv=none; b=MO23/PqAwQJvD6FLBwINVJ3JHsLlwnDsUe4Jp9nt0cw8XpGYa8iOWkWN2JgEUQewVFrFZQLhoxJrbnmaQ4T0HfjkX5v3wC6n2/QDK5pK4C/Yx1TbzZZbTdXKJUtU2nTUjyMM6SZ7lWYHbrRxnG7wQQYvJd++o9dTPXPzTHvg4LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354119; c=relaxed/simple;
	bh=T8lDA28MsVDIauTKzWNfgbQTTKQ8fipu5tFuLLG1PfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuWp2BiyDlK6sH2IeQy/kYI96nsDPvYOEwl1g9kIktE5UcLCPuxrDy7iQ29Yj40UPaBvGXjBG0/T4xAGhtNiKLsYJeyUA4dX1VGRG7lv8aG7fU0AD1ebUW24yZvj1qS4UkrLcA0maSU5opKhe/fixCB7fPiPbK0hxzZ6u+OQNNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HCf0+Tek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HCf0+Tek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083FDC16AAE;
	Fri,  6 Feb 2026 05:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354119;
	bh=T8lDA28MsVDIauTKzWNfgbQTTKQ8fipu5tFuLLG1PfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCf0+TekljTvqknjH4W8S32Whq3PB1cgeaKjwDoF1HRvREV76MU06e48YV36jehxr
	 1FDBlNoqpnt4GBlsuBx5leXjZPOjZOIcL7ELPloC7oAsRlhV0m5ue4ZnLDEgjJu/oe
	 QnHbXbQoZFJSYv/How+eLTYjWhwTJ97l8qlsKFdhIqcvXmKPO6h1wWhaRNFQugmDhx
	 qHHm4f/B8GG3DibM9wMwmoCBE6LNemmbP7sRUz+L9e+CGg6MedmxrAMejc6prfo2nU
	 PaXE6j1SiZdUQY8x346MA6DczNn/foyohZ5fNveFoaIjEMs+EuSxcDy19BQjE99L07
	 xZNzH/ERgG9SA==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 13/22] dm-verity-fec: simplify computation of rsb
Date: Thu,  5 Feb 2026 20:59:32 -0800
Message-ID: <20260206045942.52965-14-ebiggers@kernel.org>
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

To compute 'rsb', verity_fec_decode() divides 'offset' by
'v->fec->region_blocks << v->data_dev_block_bits', then subtracts the
quotient times that divisor.  That's simply the long way to do a modulo
operation, i.e. a - b * floor(a / b) instead of just a % b.  Use
div64_u64_rem() to get the remainder more concisely.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 28b47497c3d3f..63eeef26a3999 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -375,11 +375,11 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 		      enum verity_block_type type, const u8 *want_digest,
 		      sector_t block, u8 *dest)
 {
 	int r;
 	struct dm_verity_fec_io *fio;
-	u64 offset, res, rsb;
+	u64 offset, rsb;
 
 	if (!verity_fec_is_enabled(v))
 		return -EOPNOTSUPP;
 
 	fio = io->fec_io;
@@ -403,17 +403,17 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 	 * and each code is interleaved over k blocks to make it less likely
 	 * that bursty corruption will leave us in unrecoverable state.
 	 */
 
 	offset = block << v->data_dev_block_bits;
-	res = div64_u64(offset, v->fec->region_blocks << v->data_dev_block_bits);
 
 	/*
 	 * The base RS block we can feed to the interleaver to find out all
 	 * blocks required for decoding.
 	 */
-	rsb = offset - res * (v->fec->region_blocks << v->data_dev_block_bits);
+	div64_u64_rem(offset, v->fec->region_blocks << v->data_dev_block_bits,
+		      &rsb);
 
 	/*
 	 * Locating erasures is slow, so attempt to recover the block without
 	 * them first. Do a second attempt with erasures if the corruption is
 	 * bad enough.
-- 
2.52.0

