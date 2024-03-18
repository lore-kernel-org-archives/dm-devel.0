Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8885F841;
	Mon, 18 Mar 2024 23:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710804612; cv=none; b=VXNj9NefY7s5VUZuD/pVSqD4+JChncmvjqHjM4HpYtlgRFCCUlPX6zDsVcA9bYFH2vFTf0kRE3pbE3/v+ZGf+Wr9K3rd+NyTvd4eJFRbDWYFeY3Wr6FLOdFVJB1BStZ4UI99bPHwZ7SFRpPumfmtmeTRCn+lgYspFX2xpFUbANI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710804612; c=relaxed/simple;
	bh=AMYGSce8qrAtr4jy9sIVSISx/4x7n8AvCtVGoBjLw8M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WpBrV3OmtEX2aT8ZzkYd/6ocghGl3sHTM2q4iQ3di2xMCkXTqJd3sjHNIN34j+y7SwxjZdlYGOAJFpjJoSqXwtJ378TWNH7diO0gW6eSFKI+CfE16gUKGRpbQJW03PJoOcUI/cDiaOjY+9cA6+5wBBJtbnPy9LEMggM8L/pPK6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s4pqleSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s4pqleSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83799C433F1;
	Mon, 18 Mar 2024 23:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710804612;
	bh=AMYGSce8qrAtr4jy9sIVSISx/4x7n8AvCtVGoBjLw8M=;
	h=From:To:Cc:Subject:Date:From;
	b=s4pqleSnNw3hNjm7HQj/5cdUO9dk//gV5IBQ72rAx19/x6Z0BSgCaFacLgGuD6fdb
	 3uHsiFkkPsmHrf2vpKw7B4GDhqJmwZK84pNTeEFRArvEtWf2i3Whd/bNxV3GWDdslb
	 N1c1Wg5hQDW+Y07GAKFX+CWIS3kTfdgcATHuSSycryYfLWQ40euW3rm2aBlWh77QZ2
	 OWpXZy4tguvo/2Qlp/awoicmxdvzKCRK/27H7+V6DMLGor/zUC/85r2CwMQ9cbtfYe
	 yADJw8jM9zZOWe1g8QsF6AIXoftGE1vy8nOksy+V2yYS5TJzWDuDj1lctDRGaCLP6Q
	 AVh1Kwx/wIIkw==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-verity, dm-crypt: align "struct bvec_iter" correctly" has been added to the 4.19-stable tree
Date: Mon, 18 Mar 2024 19:30:09 -0400
Message-ID: <20240318233010.2282632-1-sashal@kernel.org>
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

to the 4.19-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-verity-dm-crypt-align-struct-bvec_iter-correctly.patch
and it can be found in the queue-4.19 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit c048b053cf419f832c332a213fe4c3438cf2f192
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
index 569904f73994a..95ed46930a90e 100644
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
index 6e65ec0e627a6..04ef89e318564 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -72,11 +72,11 @@ struct dm_verity_io {
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
