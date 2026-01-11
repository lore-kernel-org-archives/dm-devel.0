Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1641EBFF7;
	Sun, 11 Jan 2026 20:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768163303; cv=none; b=avnk/S4MC9b/2/AkCHCK+u6H6pYegrq9tR1EFQdWLUOSxlvsKS4Y82EaWLyPnM/5egrEJQETHu17/BQns7E+3MMW7iDHv+XND9m9T64Ztjr1o5ShHeIXrBpcwbz/Bw2xqC0w+wr1Wct4EGrLV3j0j6XDENlQd8q5qIe3hbpL3QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768163303; c=relaxed/simple;
	bh=TN6/Fi+/LHAZnqn1ObgCz5s4lskfWtVPjMWKBjxWbXA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QlNKnZqOQmpDOkKYhO89utZnX34PyWgsfPzrqYufUArrlVR1qbxK6WxXgUC4mp5RGjOm291JCeWaFLeOrA/+d3QWpjrvlf1P9se5dUCmAX3RTOu0uuitIC6HxzFf0BNWfTFtGc5pkkM+W6XgBI1Bn1nwsSsiKzsFhK1eecwDzAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f98vSvvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f98vSvvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95EFC4CEF7;
	Sun, 11 Jan 2026 20:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768163302;
	bh=TN6/Fi+/LHAZnqn1ObgCz5s4lskfWtVPjMWKBjxWbXA=;
	h=From:To:Cc:Subject:Date:From;
	b=f98vSvvU78Wxu55+VrWDT25eUlffgfkmhbylaOHxTtQW4f0igAhGleBvuR2xPUaL3
	 urCDQFysOVZ/lXyomDp7dQDf9Drxf4w4utbvuoV7n/tPVUCZlHFygEpC0V1rfWuO1z
	 q0OPCncXUyk8uyMQW5sYpS0t62gTZBQ+bRbRrmJuYVj4NHbWpIg+za3H54opHe6SKi
	 hmOs+DOyveLQvo6Rcz5SCesUcrhDIj8vqYSmeUP2pENmMDFoJMfQDLoEKDk72KDgE9
	 kGpwKYhApPrcJAQSVWL63PnKZnsMIrXTAciSlGuaIpLvKeGeiR/4d8DuJtLApnyHRc
	 r/MBXijbJ1U7g==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] dm-verity: switch to bio_advance_iter_single()
Date: Sun, 11 Jan 2026 12:27:49 -0800
Message-ID: <20260111202750.52992-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-verity doesn't support data blocks that span pages, and it sets
dma_alignment accordingly.  As such, instead of using
bio_advance_iter(), it can use the more lightweight function
bio_advance_iter_single() to get the same result.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 777a0ebe8536..4b86f7faffd0 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -526,11 +526,11 @@ static int verity_verify_io(struct dm_verity_io *io)
 		iter = &iter_copy;
 	} else
 		iter = &io->iter;
 
 	for (b = 0; b < io->n_blocks;
-	     b++, bio_advance_iter(bio, iter, block_size)) {
+	     b++, bio_advance_iter_single(bio, iter, block_size)) {
 		sector_t blkno = io->block + b;
 		struct pending_block *block;
 		bool is_zero;
 		struct bio_vec bv;
 		void *data;

base-commit: 8fbb8fe75d4cf92eaa7b21828ec39c1bf79a262f
-- 
2.52.0

