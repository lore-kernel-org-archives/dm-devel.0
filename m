Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2B61A9F94;
	Sun, 11 Jan 2026 20:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768163182; cv=none; b=j6DqkNCcf9Xy8jAqo2cpLsgdeeqSIjZs4fzD9co/hEh18Z5KQIRihdPUbJl2Na61iwvheOSJQAOlsGeMOsu0JaFAovH5rK8FxRiTFgvnVnj2iU6n7z4demb9N+aWu3XqM/s2WBXbQezVfxYtd95usOisKtjf6e68RJoM7DS6ItA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768163182; c=relaxed/simple;
	bh=X+SjMJUlmZkFYOrsXtUZWDAHw5+jWSi2aXx6p0DkDSY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FbckmxyXC4vr5z/5lsFpxmUF4qadafLCvQ8XX6T4gfeSyEW9OY+U8jnEjPn0hHO++SnCLQQW2DPKb4Dt7apPEOBUo3MURemxqjouNZbDb+M28gyKQnNN05/b1pywT6iT8+Ov5zeWW7DxR8cw10KMT153V4/YygKjqvRW3a3Rn2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p/EaIH73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p/EaIH73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E11AC4CEF7;
	Sun, 11 Jan 2026 20:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768163182;
	bh=X+SjMJUlmZkFYOrsXtUZWDAHw5+jWSi2aXx6p0DkDSY=;
	h=From:To:Cc:Subject:Date:From;
	b=p/EaIH73/mHMqPrnFHCTKSh3Bswo3EVsqwAKh1ubVmDFeFhBuy+7kmHV9Vv4sDime
	 9OI+HGRhC+fA7c0M5CqTh9T6Qd09S7VuR3WVy796pRzQNZZr39FxSBOunmUBJWmIih
	 QuCTG08Lf+cr904zarxRlbOoC1qjHTwenG0QcbzxlBwRuHdEOOes9AD2P+2Lr7vhNf
	 M6OJQKw4733n5V30aUWpowNI4Kfh/GkOvASXa3DwJcUnj/FHimSSlyNlFu7wZl2a7U
	 L+51t5fW/49xca8LGps1fwIy5GUt9cHgu9zDaUDDOIVfjJX4HlZRrdKOuyWyrxOunc
	 KG4rapwHJDhuA==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] dm-verity: consolidate the BH and normal work structs
Date: Sun, 11 Jan 2026 12:25:30 -0800
Message-ID: <20260111202530.52665-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since each dm_verity_io is never on both the BH and normal workqueues at
the same time, there's no need for two different work_structs.  Replace
the 'bh_work' and 'work' fields with just 'work'.

Note: this is correct even though it means 'work' may be reused while
verity_bh_work() is running.  The workqueue API allows work functions to
reuse or free their work_struct, and many workqueue users rely on that.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-target.c | 8 ++++----
 drivers/md/dm-verity.h        | 1 -
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 777a0ebe8536..8f262ae04064 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -649,11 +649,11 @@ static void verity_work(struct work_struct *w)
 	verity_finish_io(io, errno_to_blk_status(verity_verify_io(io)));
 }
 
 static void verity_bh_work(struct work_struct *w)
 {
-	struct dm_verity_io *io = container_of(w, struct dm_verity_io, bh_work);
+	struct dm_verity_io *io = container_of(w, struct dm_verity_io, work);
 	int err;
 
 	io->in_bh = true;
 	err = verity_verify_io(io);
 	if (err == -EAGAIN || err == -ENOMEM) {
@@ -688,14 +688,14 @@ static void verity_end_io(struct bio *bio)
 	}
 
 	if (static_branch_unlikely(&use_bh_wq_enabled) && io->v->use_bh_wq &&
 		verity_use_bh(bytes, ioprio)) {
 		if (in_hardirq() || irqs_disabled()) {
-			INIT_WORK(&io->bh_work, verity_bh_work);
-			queue_work(system_bh_wq, &io->bh_work);
+			INIT_WORK(&io->work, verity_bh_work);
+			queue_work(system_bh_wq, &io->work);
 		} else {
-			verity_bh_work(&io->bh_work);
+			verity_bh_work(&io->work);
 		}
 	} else {
 		INIT_WORK(&io->work, verity_work);
 		queue_work(io->v->verify_wq, &io->work);
 	}
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 4ad7ce3dae0a..d6bfabb27113 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -107,11 +107,10 @@ struct dm_verity_io {
 #ifdef CONFIG_DM_VERITY_FEC
 	struct dm_verity_fec_io *fec_io;
 #endif
 
 	struct work_struct work;
-	struct work_struct bh_work;
 
 	u8 tmp_digest[HASH_MAX_DIGESTSIZE];
 
 	/*
 	 * This is the queue of data blocks that are pending verification.  When

base-commit: 8fbb8fe75d4cf92eaa7b21828ec39c1bf79a262f
-- 
2.52.0

