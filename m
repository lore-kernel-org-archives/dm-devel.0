Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B935C33F362;
	Fri, 19 Dec 2025 19:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766172741; cv=none; b=PkgTZ2v61oE5BNwaOpVxle33rEuniylx5ygz+rMbSE1FVcCbMPnnu60fDGmJz7ptkAwALfXjSN0XFIipZ3Mp+PtMiJQvVSnPycnyeCeesFQ+k39K91hJJ62v4QL7IEEL/7r8dWVKrRIUK2CiDG2rbw+uWQ/yy6fdTHCfH4ZtHLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766172741; c=relaxed/simple;
	bh=LmmFlr953M8IRsBIKTkkWj/SBPzFpM1N2TqWgEjBuyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5OWfTOo1bPIUscsyFERUQBQnQkpf/AWW/P+3jIhANewO9g5rWNmmjQzBfYBqCQ+eZGvq4ddn1vFOOzh6+gqflIEvqZzqHmy3ZEXgFuwTvgmKYIz9WZi/2IZKnvrBgCLgjlWDqaqqEzTJer+VKyLNLbFK0NA6sUHjlS2D/I/9C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBriTbYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBriTbYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1710DC116B1;
	Fri, 19 Dec 2025 19:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766172741;
	bh=LmmFlr953M8IRsBIKTkkWj/SBPzFpM1N2TqWgEjBuyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBriTbYFn2RVJHkxR+X2WGg9z+FwYt//w8StA37cJCPaAkPf4hkiGtduptb/zfNbn
	 QsBgYMlDMtmVCKUSCk5zrTTKcqWDJoyHd/aM5HLEWVwq9F5h9cwixWzJZvrvx9A69+
	 GD3jvZT89k210B2BJlrOy5cYReFnUh8DZnRnmInZl0P+F9eIn3DAvLGVNc69r04UGA
	 jfVLigQRLAZaoGpsvtMoQDpatMtl1PkPM7rd2gPxciJOV1mFeb99yvjPkNiiw3mrOY
	 yAKmjJYr+i/lEGl09sctVrAv6hiLg9O+5s5ZyOqRSdoAUDnpShXez9bMuHwHV0fRT4
	 wwgevLXC54Ldg==
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
Subject: [PATCH v2 3/7] dm-verity: remove unnecessary condition for verity_fec_finish_io()
Date: Fri, 19 Dec 2025 11:29:05 -0800
Message-ID: <20251219192909.385494-4-ebiggers@kernel.org>
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

Make verity_finish_io() call verity_fec_finish_io() unconditionally,
instead of skipping it when 'in_bh' is true.

Although FEC can't have been done when 'in_bh' is true,
verity_fec_finish_io() is a no-op when FEC wasn't done.  An earlier
change also made verity_fec_finish_io() very lightweight when FEC wasn't
done.  So it should just be called unconditionally.

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-target.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 5c17472d7896..c9f5602a42c6 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -617,12 +617,11 @@ static void verity_finish_io(struct dm_verity_io *io, blk_status_t status)
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	bio->bi_end_io = io->orig_bi_end_io;
 	bio->bi_status = status;
 
-	if (!static_branch_unlikely(&use_bh_wq_enabled) || !io->in_bh)
-		verity_fec_finish_io(io);
+	verity_fec_finish_io(io);
 
 	if (unlikely(status != BLK_STS_OK) &&
 	    unlikely(!(bio->bi_opf & REQ_RAHEAD)) &&
 	    !io->had_mismatch &&
 	    !verity_is_system_shutting_down()) {
-- 
2.52.0

