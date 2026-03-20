Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7404936C9C8;
	Fri, 20 Mar 2026 21:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774041334; cv=none; b=c/Ae618pPa086P2pInQLSePsh9VpbWoI8rtdmpkbdgy0nRj3iGEffQVyZHNn73ezZQUD0kgl9kdzSNXvF76o8e7L88UUatXcs4x/NwbqifA/FmEIwDTJ1OEaeI4WvVUjZoqTsPe1uEVaw19qyFwYhGy3LSUs81AR8raZnQ/sAOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774041334; c=relaxed/simple;
	bh=BCBrbv783ReTPLj99pWb3rDmr3T4jrMHlqBO79FXKaE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XXKikK6hUdirxqPpqDm92i4ssTx3Z0STEO15imYH4FEWM4Ll5YOtkAgmSnrXbxO3kwdEJ0BBc+remXASwC4mbLGgRY2FSmvjkqz7T1R80gkhn7qAdG8wgGmI5PbA7ZTQDZmRa3Kmi5m3qXMR3MxJ2rqNPO69vsMTc6n3dT+L+QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Glb6GbQw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Glb6GbQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8832C2BC87;
	Fri, 20 Mar 2026 21:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774041334;
	bh=BCBrbv783ReTPLj99pWb3rDmr3T4jrMHlqBO79FXKaE=;
	h=From:To:Cc:Subject:Date:From;
	b=Glb6GbQwp93Ub7kBPA4kMN3/ipc09VbVN7cOjhTOwxRyEgmvNeH4s9qninPgJZyIQ
	 Fri9WIOPAQqWZ1cuz0+oHmktd4FFotd9J+NDNQO3lJ8Y0mYmSG50uo7OAElIky34oH
	 ESkOkWTj8CNsA4qeuUo8Bxsxk/OQbYkt1Z4JzeQBROERcL4hr6Xzxz/8FIJ10wQyVc
	 BODQXsL7HelSEmnEn3+tGD3qNMTnej42jSeImeJaXYi6YxKKqUcZoarZq7LKBi+dSR
	 iFj3cDMglG/T/6ZkvRwj+XUhWhwcpoAfKM4lwrd7NsU17GNFj4KprJep0WIGf/pgO4
	 NLmAqqTLVM/HA==
From: Eric Biggers <ebiggers@kernel.org>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] dm-verity-fec: warn even when there were no errors
Date: Fri, 20 Mar 2026 14:15:08 -0700
Message-ID: <20260320211508.26287-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently FEC logs a warning message if at least one error was
corrected, or an error message if there were uncorrectable errors.
However, it doesn't log anything if there were no errors.

"No errors" is actually unexpected, though, considering that dm-verity
calls verity_fec_decode() only when a block's digest doesn't match.

If there were to ever be a bug where verity_fec_decode() is called on
blocks with the correct digest, then there would be no indication in the
log that FEC is running and degrading performance.

Therefore, let's log the warning message even when there were no errors.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index fb71e83e6404..85ad9dc210ff 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -131,11 +131,11 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	dm_bufio_release(buf);
 
 	if (r < 0 && neras)
 		DMERR_LIMIT("%s: FEC %llu: failed to correct: %d",
 			    v->data_dev->name, target_block, r);
-	else if (r == 0 && corrected > 0)
+	else if (r == 0)
 		DMWARN_LIMIT("%s: FEC %llu: corrected %d errors",
 			     v->data_dev->name, target_block, corrected);
 
 	return r;
 }

base-commit: 23e6e57a93bcabe86d5f0eab1df0c44706ab18f3
-- 
2.53.0

