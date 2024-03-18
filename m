Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F2B5F569;
	Mon, 18 Mar 2024 23:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710804572; cv=none; b=RAwIi4+orG2uyoRXItjd8UUuSdGqlt61qnjLGL6lMwuPFBRl94VwJTVlyK/225axQzyqwWNf8X+hksxLZ8Qrnsk4AelKgaaE2rgjfDQ0J8bGY5JGzWgoNKVvNB6P6HcvF814T5HhFT2h8i6CyiEuOwzcMMNmdP9tVxdoKRISSJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710804572; c=relaxed/simple;
	bh=eJo8m7mQlVONOTUoFgaikCXUw6lbXcGEaFqTi4Oj6b0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kvk2epKYvy20hhP5BgckrYfGxLPyksv33ZR4ykpra8j8ghgtflANqhVsIfeYb9BUm5v1N4W7IEbL2iyyxp9PPmbFA+e1kkN+2+luRM8BSjJE68z9zFKA0bL8lnbEI9DEQQDwiEeygAUhlo6Jo7UwlJGFT5r7oEEy5EzRAwL60Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ucGIOJXU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ucGIOJXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B77AC433F1;
	Mon, 18 Mar 2024 23:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710804572;
	bh=eJo8m7mQlVONOTUoFgaikCXUw6lbXcGEaFqTi4Oj6b0=;
	h=From:To:Cc:Subject:Date:From;
	b=ucGIOJXUaPumawD93XddhhXYUscTAMBe1slcM7Xa4Km2UXHl5rVYG0GX0zlH9b8Zf
	 AzrrooN/+wuOkgMeRaU0x34K5/6OHIPKjGIFkCYObpN7K2orWL7xJdQQeeAzqQbEXI
	 QFRC27ZrLWLP1Nvf6O/rcheYB2Tw65sjSoz5FVA5XM9pKwil2+E8QkNFk66a9gY+4y
	 LZErQ39FC42wOGmJKOx5HiBFHrjgthp9ExGeNEssXk+wk3ZAk/zVw5719y/6aEt85R
	 WdHf1hOZo4ZA/Ip/MK70+1WaTGAZMV5ggC+OIr72FMNPWKVbI6qQYHT42hPgf/7em8
	 nl2qKFsDuvVGA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-verity, dm-crypt: align "struct bvec_iter" correctly" has been added to the 5.4-stable tree
Date: Mon, 18 Mar 2024 19:29:29 -0400
Message-ID: <20240318232930.2279887-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    dm-verity, dm-crypt: align "struct bvec_iter" correctly

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-verity-dm-crypt-align-struct-bvec_iter-correctly.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 51de750d029a1fe516b67d3bc7c0fb63a9962b47
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Tue Feb 20 19:11:51 2024 +0100

    dm-verity, dm-crypt: align "struct bvec_iter" correctly
    
    [ Upstream commit 787f1b2800464aa277236a66eb3c279535edd460 ]
    
    "struct bvec_iter" is defined with the __packed attribute, so it is
    aligned on a single byte. On X86 (and on other architectures that support
    unaligned addresses in hardware), "struct bvec_iter" is accessed using the
    8-byte and 4-byte memory instructions, however these instructions are less
    efficient if they operate on unaligned addresses.
    
    (on RISC machines that don't have unaligned access in hardware, GCC
    generates byte-by-byte accesses that are very inefficient - see [1])
    
    This commit reorders the entries in "struct dm_verity_io" and "struct
    convert_context", so that "struct bvec_iter" is aligned on 8 bytes.
    
    [1] https://lore.kernel.org/all/ZcLuWUNRZadJr0tQ@fedora/T/
    
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 6b4fb4e7506f8..6866aa2aade3b 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -46,11 +46,11 @@
 struct convert_context {
 	struct completion restart;
 	struct bio *bio_in;
-	struct bio *bio_out;
 	struct bvec_iter iter_in;
+	struct bio *bio_out;
 	struct bvec_iter iter_out;
-	u64 cc_sector;
 	atomic_t cc_pending;
+	u64 cc_sector;
 	union {
 		struct skcipher_request *req;
 		struct aead_request *req_aead;
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 74ad36b6dbf53..fee7c7a81ce4e 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -73,11 +73,11 @@ struct dm_verity_io {
 	/* original value of bio->bi_end_io */
 	bio_end_io_t *orig_bi_end_io;
 
+	struct bvec_iter iter;
+
 	sector_t block;
 	unsigned n_blocks;
 
-	struct bvec_iter iter;
-
 	struct work_struct work;
 
 	/*
