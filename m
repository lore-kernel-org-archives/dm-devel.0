Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DE15B1F4;
	Mon, 18 Mar 2024 22:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710802785; cv=none; b=Hjw40XR/q7uyWyThQRRI5BOcTTQMTfB9lVS1Jv5XHJBnbZM+aVEoKld2upQgYSj2QiiJ8B7LBE2LfvAV93yeja+CJaFdHA5+QuyzXVpDdg0NTiOvOyMw7GZ/dcx3JPYWEpa47GYsho633Jb8QLFztbPrORexDeseAXH6KO2FZeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710802785; c=relaxed/simple;
	bh=Mqgr8pSxX3ownNFBFbcCdlAeie6Gx23DTOfbsRIiT3g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lRSeDsoESWLJOqZFxTwFdwD0kK4N1JWgsK5PJkIVm8YEsPXKbc1ucvBu9KL2kSl1f0j+dGzeOSJuPhDghUhoI1Zs8FDmknXsdgQUJIz0MSaM8R9JB9HUaGpFfWgSpCoQJoJmpX2KRBRm0V5+j/a1ujTtbwQ/JaF4VYdoZO2295Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A3Y201O9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A3Y201O9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E89C433C7;
	Mon, 18 Mar 2024 22:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710802784;
	bh=Mqgr8pSxX3ownNFBFbcCdlAeie6Gx23DTOfbsRIiT3g=;
	h=From:To:Cc:Subject:Date:From;
	b=A3Y201O9yL+Q4ex8OK9z9VvyYkmG93ZyIDYuJW2/TmZiNCkz47p9KcIgo8booGzsP
	 4ZXigKCYfqARmzt/Msn4X60PWIToDv1BjObOKhrGgt5WgqLgu0dSUKq20BugR7PoSw
	 BI4E4oRb2XiSpMzezPpGifo5pwWBT8CVpt7G1csncaMUpxdve6hy8Uv/A23U7w0VLy
	 kCgDOosYb1KBQeUyY9QyHCRHFvFt5Nc4lr4YZbYmlhawVbw3JjNkmvNclB73UU5R30
	 9Z/7xsKHrE7BwHOzYBNM87XTw3IOeIlnkUFT1RuM4wdjjWrzWvN256CDpj3GaQRr+E
	 iHwth8ST0ySIQ==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-verity, dm-crypt: align "struct bvec_iter" correctly" has been added to the 6.7-stable tree
Date: Mon, 18 Mar 2024 18:59:42 -0400
Message-ID: <20240318225942.2161179-1-sashal@kernel.org>
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

to the 6.7-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-verity-dm-crypt-align-struct-bvec_iter-correctly.patch
and it can be found in the queue-6.7 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit cd786f8debe865b168e35b2ce0ae1723e3b04ba9
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
index 4ab4e8dcfd3e2..35f50193959e0 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -53,11 +53,11 @@
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
index 4620a98c99561..db93a91169d5e 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -80,12 +80,12 @@ struct dm_verity_io {
 	/* original value of bio->bi_end_io */
 	bio_end_io_t *orig_bi_end_io;
 
+	struct bvec_iter iter;
+
 	sector_t block;
 	unsigned int n_blocks;
 	bool in_tasklet;
 
-	struct bvec_iter iter;
-
 	struct work_struct work;
 
 	char *recheck_buffer;
