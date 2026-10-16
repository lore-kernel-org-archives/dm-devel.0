Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7146756E071;
	Fri, 16 Oct 2026 17:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792171647; cv=none; b=NySs77SDDG9JhOm2B2vVnIM7htmUaR9VHLGxcE3DcvngRCPMHmpNNgURgVqqL3j6dc+xGMFGYFp7VQMuRm+Oj1AUAIF7YRWGRU8cEq6WzWjMa34d3n4PghBpCr3KEoh2X11sD9cxXwI2jhebiQyMTYo63FYHs/CnzoFLyPVtvrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792171647; c=relaxed/simple;
	bh=xHT4iyHU3iD+QiYXvDfa1L8fnlmENyxUZPnqZE9B+/k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K3iu6Ok3GpuC1xravq0iT7VDsxzJ+FChwoYeqG+CK0KVoaOw6rnjRiwY3d8xt3Y95KULAItOGDXSWv2I4+SYjjWUxA7d93Sjme7gRlf0o0//RnQP4S7h1smWz6/QLLHPFJ3GCZ/iGs/aLd9ql3az7Hn1xtDsTiyTM1f/GJskUY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ru+zAgBu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ru+zAgBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0941F000C4;
	Fri, 16 Oct 2026 17:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792171645;
	bh=2zYmRmp+9XT91UAWVG01vKLLsUgZ6Cms6wCmE7/viXE=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=Ru+zAgBuxrnxY2/AF4+fPLiy0rTsHhs9PjZwGmqLLtDlq6Fi7cqwRedmtm0HO4TFP
	 LzKvArIaTL+eJeAVfGal1TCR7O4zUZe2BM8DoIlQ+LY35OHfyDSO4z8+4cUgu/HpBP
	 CeWSwMjYL6mcMJHcJ/u9JLSjepGStYuQLHCJGekBhxI9JN8uK8qp8wJMfsyVDRgHeB
	 HBf7pfb0YibdJ3uod8cXgirBT/goOaSuDmb9TxzkSjDxc23+hSbAzgGU6uQV9YBesU
	 E3dnn5o9lYLQNmUiyqq3LwBDWuiRpwSeqbwWDz2PqcKl6nnc4ePBaTj81woZYigJTN
	 EUwn7XZIJvpxQ==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	ebiggers@kernel.org
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-verity: provide dma_alignment limit in io_hints" has been added to the 6.6-stable tree
Date: Fri, 16 Oct 2026 13:27:23 -0400
Message-ID: <20261016172723.4009633-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Reply-To: stable@vger.kernel.org
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

    dm-verity: provide dma_alignment limit in io_hints

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-verity-provide-dma_alignment-limit-in-io_hints.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit a730677767bdac568f6e3438068b076cc3019a7e
Author: Eric Biggers <ebiggers@kernel.org>
Date:   Tue Jul 2 16:39:51 2024 +0200

    dm-verity: provide dma_alignment limit in io_hints
    
    [ Upstream commit 09d1430896e38933470045408d7a350dac7d841b ]
    
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
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Stable-dep-of: 1071d560afb4 ("dm-stripe: fix a possible integer overflow")
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 7e877c6adb2ea..bfd0e80bb9f3a 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -997,6 +997,14 @@ static void verity_io_hints(struct dm_target *ti, struct queue_limits *limits)
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
