Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A66178367;
	Wed,  3 Jul 2024 19:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720033354; cv=none; b=Lla3riHaN+KpdK9064tHtQRBshO6xOmFDA22E6FLmiJU6S3IdwbKKfq2yg23T1R5eTa34GCwsbfLDIHDgU5zIttkh9XfGPJwiJaPuPu2K0tgquIMoDOX740xjYp0avlTxQwaKGrihccNHn6Ls4Y5GRWEgKV3GpHQ6MLx1yogvok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720033354; c=relaxed/simple;
	bh=71g2nqc6FxOk/YKMFvTXoevyN3+HuT2J8B/us81Ujck=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iv7vL2XBC3L0bIOk7uQChv2nkBOxppgz2XUjzbxOxNEVjC9ShIVKJaUeYUZzcH0t9wZ+Z0tekXoQsNNupPH2AVnpKT6dXZYJh37hmQf93RB5NFFe0ljKawGPFPqqc0f7XcYNy3P6c9FPftWlkg/9mviZsUr5BTf7M4uLfsZyGXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQoLYDjc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQoLYDjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C256FC2BD10;
	Wed,  3 Jul 2024 19:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720033354;
	bh=71g2nqc6FxOk/YKMFvTXoevyN3+HuT2J8B/us81Ujck=;
	h=From:To:Cc:Subject:Date:From;
	b=XQoLYDjcQ2TtN25XS4Ipa0DRq52rIW9iJ75Ux5oqdj1gS8/BK2EffIqsXs1P8tDrM
	 riuygMI4RCB6LBq2FaCd8Q0dD5SXkqrYev/sVbxrJWzHAwu+wpGiAPDEdAd5yi25+y
	 FWXNT0wz9JnF0euwY+0yP3oZUW3Xeut6HqyJB4pG/SbuZlPyqAWYNV0bbKqTdfLjnJ
	 XJy21QbGt7EVyIytH3aYvk3u6Vu7S2QWJzoFN9hqXNtxoa8uERRlk+CJb2FJ+R64pB
	 KDHMO2phYJ/JTGktOZ7FmjqR0RuubrPdUWJ9Y/8iJSjCX81IzebutlVMnfYOy0blO3
	 EXlKvMiY7TuVA==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2] dm-verity: provide dma_alignment limit in io_hints
Date: Wed,  3 Jul 2024 12:01:41 -0700
Message-ID: <20240703190141.5943-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Since Linux v6.1, some filesystems support submitting direct I/O that is
aligned to only dma_alignment instead of the logical_block_size
alignment that was required before.  I/O that is not aligned to the
logical_block_size is difficult to handle in device-mapper targets that
do cryptographic processing of data, as it makes the units of data that
are hashed or encrypted possibly be split across pages, creating rarely
used and rarely tested edge cases.

As such, dm-crypt and dm-integrity have already opted out of this by
setting dma_alignment to 'logical_block_size - 1'.

Although dm-verity does have code that handles these cases (or at least
is intended to do so), supporting direct I/O with such a low amount of
alignment is not really useful on dm-verity devices.  So, opt dm-verity
out of it too so that it's not necessary to handle these edge cases.

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

v2: Added a comment, as requested by Christoph.

    Resending as a standalone patch since the series was already applied
    to linux-dm/for-next.
    
 drivers/md/dm-verity-target.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index bb5da66da4c1..90a13548028a 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1013,10 +1013,18 @@ static void verity_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 	if (limits->physical_block_size < 1 << v->data_dev_block_bits)
 		limits->physical_block_size = 1 << v->data_dev_block_bits;
 
 	blk_limits_io_min(limits, limits->logical_block_size);
+
+	/*
+	 * Similar to what dm-crypt does, opt dm-verity out of support for
+	 * direct I/O that is aligned to less than the traditional direct I/O
+	 * alignment requirement of logical_block_size.  This prevents dm-verity
+	 * data blocks from crossing pages, eliminating various edge cases.
+	 */
+	limits->dma_alignment = limits->logical_block_size - 1;
 }
 
 static void verity_dtr(struct dm_target *ti)
 {
 	struct dm_verity *v = ti->private;

base-commit: 22a40d14b572deb80c0648557f4bd502d7e83826
-- 
2.45.2

