Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AC922615
	for <dm-devel@lists.linux.dev>; Wed, 11 Jun 2025 01:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749604606; cv=none; b=UGyHJeZzZprNeH+QCmgY453nO9qlzXwZdgRshhhy/0eayoSoBUJaNUq0zXnf1kg9hd8dkh0A/jvAmrLHSxSA9XnPF71uBSFMASR0AqYq92osTzeFdYreDTLskL2Iche4PczdFjvqexkZ3pqZ66tu84gOFUEa72wKctA+fOb/rzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749604606; c=relaxed/simple;
	bh=OwCF8/6fv4ZP9Dq2KVssJWBGZkWZHCyKE3EUw9lo7rc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lohXvuDvgYchrITjfw4BxEB+aD3OiE6WZj8TyYkGscKv7lMk4BF44Q7YdQcWB/w7kP4nhHeAa7y4HRbkLlOSYkhiqPlzywMPQ5mGxlu/LB7e0vNbo3x7Zl/oBbRxKsEikuFVuxm3BOcClbob4GEnm/pMh3eQfJ5SNNpZfELvZmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OFBjn0IN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OFBjn0IN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB30C4CEF1;
	Wed, 11 Jun 2025 01:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749604606;
	bh=OwCF8/6fv4ZP9Dq2KVssJWBGZkWZHCyKE3EUw9lo7rc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OFBjn0INAtkDH/UMxH1GqXqb6FV2zhZA3EGEmSRC0VeERGgwZgjuSyQrBvG/heGOk
	 w9yOMvf9VD+/2aedeWeOVH1dT4UcqS4d4TJClE2LZ99FXAMKZQtfHlxJ9xoRCPzrYh
	 BZ3heHHyF6v9k3gJuPuIW4UzBORdYGFxLTahkbmwCnfmPXhAoB3PV2auFeGnQm2p5Q
	 r7YKT587HPkizhlu1kZGxZAMmz6/6OEauU0zfAXFSkAkz/gpXeCVenwEZ2rP5RcJyA
	 O7ZdcgJqScXgs0PlVKNCtBkjX3oMhg0nRVSaUa+mm7d5YUIPmhovg7KUWGaOuervfj
	 cg5HPQS89WImg==
From: Damien Le Moal <dlemoal@kernel.org>
To: dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] dm: Simplify dm_io_complete()
Date: Wed, 11 Jun 2025 10:14:57 +0900
Message-ID: <20250611011457.92309-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250611011457.92309-1-dlemoal@kernel.org>
References: <20250611011457.92309-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The local variable first_requeue is not needed since it is always equal
to dm_io_flagged(io, DM_IO_WAS_SPLIT). Call __dm_io_complete() passing
this value directly and remove first_requeue.

Also declare dm_io_complete() as inline to make sure it is inlined in
its single call site, thus avoiding the cost of a function call.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/md/dm.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f1da8fde549c..21920991ab28 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1024,10 +1024,8 @@ static void dm_wq_requeue_work(struct work_struct *work)
  *
  * 2) io->orig_bio points to new cloned bio which matches the requeued dm_io.
  */
-static void dm_io_complete(struct dm_io *io)
+static inline void dm_io_complete(struct dm_io *io)
 {
-	bool first_requeue;
-
 	/*
 	 * Only dm_io that has been split needs two stage requeue, otherwise
 	 * we may run into long bio clone chain during suspend and OOM could
@@ -1036,12 +1034,7 @@ static void dm_io_complete(struct dm_io *io)
 	 * Also flush data dm_io won't be marked as DM_IO_WAS_SPLIT, so they
 	 * also aren't handled via the first stage requeue.
 	 */
-	if (dm_io_flagged(io, DM_IO_WAS_SPLIT))
-		first_requeue = true;
-	else
-		first_requeue = false;
-
-	__dm_io_complete(io, first_requeue);
+	__dm_io_complete(io, dm_io_flagged(io, DM_IO_WAS_SPLIT));
 }
 
 /*
-- 
2.49.0

