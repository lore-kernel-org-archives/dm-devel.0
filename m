Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2839D5EE67;
	Mon, 18 Mar 2024 23:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710804524; cv=none; b=KXzMcbdJQVJ9nnNyPsc9S5MXGN+ckkVGD7lOeNWRpbAKZTL0Av7lqPK4jNvSTzSYdeQghIgi3iPPY3epz6mSlpIAScdYM16lJMlfQlPJg3ZlIdj+r2Vw9ycu3M7ohI9jFMhZdZ0srEP4KlYU12p4v/gOn8cSE4TlcHLYTFBs1b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710804524; c=relaxed/simple;
	bh=eVEoY51q9btaJgAkxCKuGeCwQ9aF75kL6H4u9Tpct4A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UZAgHkWnnMYtRYG9Y7AyDnask/TubuOVz8EGxG1bJPuVeMH/3Su5UPM5Iarrt0lPKEq7lMCOaB7YSLKTDcx5OiufXTJDBCm6Tm/bfYh5LHMQj79CZzTb/EmvqH7vuVUWYVelCq2wZh1QpeTeYgUp5q4f7aJbvbpmVfrLuuAnAU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DzNCy7B7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DzNCy7B7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEFCC433F1;
	Mon, 18 Mar 2024 23:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710804523;
	bh=eVEoY51q9btaJgAkxCKuGeCwQ9aF75kL6H4u9Tpct4A=;
	h=From:To:Cc:Subject:Date:From;
	b=DzNCy7B7/pzAUf1iyXhb4mGrj4V3oXlR+sw6S/fF8kNMuYtGBSAXygGVabT1HNgx/
	 /W+EiEcYChwmS9ONzD/9zAaPcwLTfm0Z6WdsGZNyGhiLdywIB7JwRdzhHVvraQEVLQ
	 ggI4PYCSzWbSQ8BZpzKmMKhoyDGhNlvFe0bXJtz8SctlNaQOtqRXWGpCVPSX6EiUbG
	 InYbhZ9BYd2f2FCPV7Q4OcKtW45m/1TSYKZBqP671n05F/kNRbaNRFDZa0kz61HAdF
	 J3ru+UaV6juOswps3Mv85ARIpUN4Wk29y5/ZhIAbz2P+4n1gQyETflamuWdQjLpqgm
	 lXh4MFqY3Pycg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-verity, dm-crypt: align "struct bvec_iter" correctly" has been added to the 5.10-stable tree
Date: Mon, 18 Mar 2024 19:28:41 -0400
Message-ID: <20240318232841.2275532-1-sashal@kernel.org>
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

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-verity-dm-crypt-align-struct-bvec_iter-correctly.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 0c7560792b0b22d4ba1f8d36963820feb9bfceb5
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
index 5edcdcee91c23..5deda6c6fa2e7 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -48,11 +48,11 @@
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
index 78d1e51195ada..f61c89c79cf5b 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -74,11 +74,11 @@ struct dm_verity_io {
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
