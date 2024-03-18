Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AEE5B690;
	Mon, 18 Mar 2024 23:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710802994; cv=none; b=qgrPyzt8/jrlciS3OpNSF2DBbwsC5sZvRgLCctvN+/InGDLvwTcOlChjqXafiCwBKd6t6iLC11Pn4yolpazVc7Y5x/CpQGAu/Vfk6XBkhhbZRrJq/rPEsmOF8dNZNjG3L6eIjI03wWseHKGOx0XiOnhPBw/PtqY3rH52XpK2eZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710802994; c=relaxed/simple;
	bh=JjeQNM3N4FIlQYug99YL1wXe05XtJU5QDnkGhmoC63c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u+k8xPJzqFMYjK1/HEXsiGUOV8ou/lCvbzh4ZvviImHLINwFSvH+QYbe6MNMt8PTt52BsMt2AROreFQfMAoNUW7DS4xwwrCKkCOZWHEiEtl3Sha9sViXswkAPi37MY8LsSFPb/2Fhw4FvHBPmpYp7C4cngIjTCXF/IO+X9fX974=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jwdvkd6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jwdvkd6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE04C433F1;
	Mon, 18 Mar 2024 23:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710802994;
	bh=JjeQNM3N4FIlQYug99YL1wXe05XtJU5QDnkGhmoC63c=;
	h=From:To:Cc:Subject:Date:From;
	b=jwdvkd6iDQVdCixF/tQVL0RWyg0kqJyD8P83xMmk3peD1Ds/zXGzx7qDWw5fRlNga
	 Q0ML3n6XNBs/tEkQK4HNN+GKNuGKs5NF56+cUx5hTair7ne2rKsRw2rrWicETt70JR
	 pEOPn7VPKvPsParl4hucWDypr8Bxsm7aOC0Ie0usxSy99qAK3YaVPmz04zm69pL7VU
	 3T92ELArUELweenrZUj/YBny9pQFsd3Ip5GmO+7vswlJhKzgM1enYV95JaQZ7qdCNj
	 a/b4TwjXFQQYhgUdDdkdV4KnJR+xy7q/vRlexL9bet/hEnH8IpMN7QKYgLI7VCfRV4
	 9KIN3qT9n3YMA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-verity, dm-crypt: align "struct bvec_iter" correctly" has been added to the 6.6-stable tree
Date: Mon, 18 Mar 2024 19:03:12 -0400
Message-ID: <20240318230312.2164309-1-sashal@kernel.org>
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

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-verity-dm-crypt-align-struct-bvec_iter-correctly.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 833fa53b7154fc172b264066368ad7c527b225a0
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
index 5a296db23feb3..aa6bb5b4704ba 100644
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
