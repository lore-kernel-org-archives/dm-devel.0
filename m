Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35FC338599;
	Fri,  6 Feb 2026 05:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354115; cv=none; b=sWe2gpIftWLYUHkjItdrQgOYqUSeogrXY4dy/I8/vxX82ICZipm+Kly8WAqlz3Cb6bzx0t7ckOJF8uN/Wufbw3ognrFwLHZI8ksOVFsf4WLGXXLVlJUznwD4z3BV0sElOuNs/r0nN5AbAeupmJ6LY1py6JTt27XMpp6AH+4VNCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354115; c=relaxed/simple;
	bh=5d5HjKM+DeqQTaH+goXutkoNBKAF0dufO9VZmmDqK+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnblK1KFAfWFg5h2vp4FpWs9HO/uFZ71dY8VtJwugEmxQu14Clafm9mKsxyKAts8lrgXxaCtC3rCiXcN3SV/tYzA9nv6Y9tmbdMCL9MFKfHW1Lb/pRgd7tPmfAgzov+6ev1/vP2GoNId5cJVTqrcKQO5KoMwg9f456ZTQ9wEJkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t9TDjzNp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t9TDjzNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5A4C19422;
	Fri,  6 Feb 2026 05:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354114;
	bh=5d5HjKM+DeqQTaH+goXutkoNBKAF0dufO9VZmmDqK+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9TDjzNplqNANTMSyynLoOfJfnx+vQlgXycvKw7GSvZTq4MdaCb/LarTpiNoD+hpC
	 YKHI3ABqtf/QRud2LG99rIFYP7AsLp3mbC60HSaE6auUEUjjIpwrw40DZa1nRFSmpr
	 ptTkLhxp8MedWfKryI/7pSN62L9GVmUMluhOLZuyDt5wnClkKmveHE4/xySk992ffU
	 i/5e6CxkHYleXtbFXv4v8Q2/B85ec8YwaHgBlUfvJi7jDJc37nKlR9OInmgl2MZPui
	 j2KlFOB4MSz9kYbofNGFptatuCBIqodoV1h3HNq6vAMBWpciTw+Jek08CW8MQBr8vo
	 6vYj8fjvZ7zdw==
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
Subject: [PATCH 02/22] dm-verity-fec: correctly reject too-small hash devices
Date: Thu,  5 Feb 2026 20:59:21 -0800
Message-ID: <20260206045942.52965-3-ebiggers@kernel.org>
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

Fix verity_fec_ctr() to reject too-small hash devices by correctly
taking hash_start into account.

Note that this is necessary because dm-verity doesn't call
dm_bufio_set_sector_offset() on the hash device's bufio client
(v->bufio).  Thus, dm_bufio_get_device_size(v->bufio) returns a size
relative to 0 rather than hash_start.  An alternative fix would be to
call dm_bufio_set_sector_offset() on v->bufio, but then all the code
that reads from the hash device would have to be adjusted accordingly.

Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 5c276d0fc20c0..9f06bd66bae31 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -686,11 +686,12 @@ int verity_fec_ctr(struct dm_verity *v)
 	/*
 	 * Metadata is accessed through the hash device, so we require
 	 * it to be large enough.
 	 */
 	f->hash_blocks = f->blocks - v->data_blocks;
-	if (dm_bufio_get_device_size(v->bufio) < f->hash_blocks) {
+	if (dm_bufio_get_device_size(v->bufio) <
+	    v->hash_start + f->hash_blocks) {
 		ti->error = "Hash device is too small for "
 			DM_VERITY_OPT_FEC_BLOCKS;
 		return -E2BIG;
 	}
 
-- 
2.52.0

