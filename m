Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D1A17109F;
	Tue, 30 Apr 2024 12:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481503; cv=none; b=q8Hr+/HJ7hmqj+Hu/QVvk+d8b9u7rHkhFFoJQup9xB5gplCKkiJmnK51fupS904kebUdIwcPW5Zi2O9WI0s1T0VrGrlnhvc/CaSvkTI/YZ9kbpIvwCJ1XQv0LxobkRJmqd1svJ5gH/NpB2IRBwsVYH6ixMvnW8981GfHChTrCII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481503; c=relaxed/simple;
	bh=ra5cLPnbdrCAEFvfPA09kUSW6ZiM7XRDEYo3QaLJJXM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nptF9DBclomqdFzxMzyToVFckxCx/mLUKPppo/g/bxqkTLdU+JjPKG361DdhVguApy9PBockbJVIUYPqJ5hT29qsfEJ36D9hRjGu6zPR13Q5bMXk8wjBzgDUKcOe6r1BBTFnFRa7TakTqBwSv3nRSSBADsWG/SS2y47dVqX/0zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nhQTR5HM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nhQTR5HM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69B1C4AF19;
	Tue, 30 Apr 2024 12:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714481502;
	bh=ra5cLPnbdrCAEFvfPA09kUSW6ZiM7XRDEYo3QaLJJXM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=nhQTR5HMxUhKdzK+QywpN1kip96bGArGhV1P8nslAdmcGrB7xCdeS4K8P/MhJXURX
	 qL9KaATlqn+iLirfUYmXI9jf3A/5VDrvZ4P/0KVjyPk5kFgBty1ou5UHe/L8Fkyuiq
	 /cS4k+/6xjucGZm/p8Ky6WrhGvdVFUoSy1MTiAZpvv+EOCOELEvcaeZ1i1Lk0wKduf
	 MMvW6A8vWEjcTPOoOdlMw4hqnbMOukApXHCR+evJ/Ew9LxcN4a3cV+CYt0cKp0Os9U
	 BrWeWghK/i6J5G4KSG1G+GBk8qRYFGEtlBWQO9IAnvfZ1osf9v73xTtWVWBFGJjz2d
	 /Bwx/ypVDq0sg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 08/13] block: Fix flush request sector restore
Date: Tue, 30 Apr 2024 21:51:26 +0900
Message-ID: <20240430125131.668482-9-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430125131.668482-1-dlemoal@kernel.org>
References: <20240430125131.668482-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make sure that a request bio is not NULL before trying to restore the
request start sector.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Fixes: 6f8fd758de63 ("block: Restore sector of flush requests")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-flush.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 2f58ae018464..c17cf8ed8113 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -130,7 +130,8 @@ static void blk_flush_restore_request(struct request *rq)
 	 * original @rq->bio.  Restore it.
 	 */
 	rq->bio = rq->biotail;
-	rq->__sector = rq->bio->bi_iter.bi_sector;
+	if (rq->bio)
+		rq->__sector = rq->bio->bi_iter.bi_sector;
 
 	/* make @rq a normal request */
 	rq->rq_flags &= ~RQF_FLUSH_SEQ;
-- 
2.44.0

