Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B82B5C905;
	Mon, 18 Mar 2024 23:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710803290; cv=none; b=khdVvAb8KVLhFk9cufmBzAtPUJ2s4W52Wv5RCzvdfp1FhtsJzoGDXZrGgGjyp/DW07/pCmuB31H86IFBN4ggmGl61GC00ANhbcB+duyruFSwn7/5AVchASH2FNirYsi+tod2IKfn8AqVzRnT6mO1BvtHuToJ7LAW3zBWvZPgP2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710803290; c=relaxed/simple;
	bh=2ewOyn5dZU1HDmAVZTbNTT7rZWhBnjCYK4K3HaiO5A0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lJ3k8sQwoP2iMouZT364soRzuM7/ZrqWWNNcmrA36vmimlY40CYiecvBvG3teWIEuYp3JJGdDGKQl9Y9km7wac0FOxOJQG0ayokCUjeT4CaJ3BQsRuS2C4TriLJhEtskdtsBfoWSFdViGuoDq5PSQcqRdMWu1JKQ559a+s/JMYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SEWaPoeF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SEWaPoeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233F8C433C7;
	Mon, 18 Mar 2024 23:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710803287;
	bh=2ewOyn5dZU1HDmAVZTbNTT7rZWhBnjCYK4K3HaiO5A0=;
	h=From:To:Cc:Subject:Date:From;
	b=SEWaPoeFP4c++f/ny0rnqEZ0dGrga+4/DtzFA+aexPBabeGT8lc9NhN1gb2/abo6h
	 XEGBUL18nYXcMycrZ+bu3kiP9C9WxRvwxAqwjKfEJGmh/IWY0SfOlR9HKb9M4ll6Dd
	 y6YpeEtYSfT/wgQtUXSz9vVKtQ51tPh+gAxoCNqS+qq1Th2Y8BviGYurGBP+ZTvus6
	 DDOocBLFYxssW/YdlYKKs2YawAcn1l4ktubXMnqNWNe3fOoBZ/SrGJu0y/91U4H4VD
	 4dXrovIXImEfdP9K5sobYlKB1RQ/0XeH1chfV8bti4LFDdMzuLYyF5s3on84pW/YUQ
	 XuNaYEesVkp8g==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-verity, dm-crypt: align "struct bvec_iter" correctly" has been added to the 5.15-stable tree
Date: Mon, 18 Mar 2024 19:08:05 -0400
Message-ID: <20240318230805.2184877-1-sashal@kernel.org>
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

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-verity-dm-crypt-align-struct-bvec_iter-correctly.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 7089a433a187c2234ed43f0001780d009b151036
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
index 5904af05f6057..a3db76dcdb3ec 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -49,11 +49,11 @@
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
