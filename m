Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE26F13CFA6;
	Tue,  2 Jul 2024 06:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902984; cv=none; b=c1ymau7dW4NogV2jXxAhykxVszi+2MQJBK1guSpCqjocaiFsm7vNsjv8m44xMbIiyt3lgTM9QVq3BFs+6yCgV2H+7oBJhhQYNlLCXRyCirWxwV59eIgR8vs3Hwm3+icjyml4xLzciuZyKMPUakU8RfH/f/qnqKShGaXKJs891vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902984; c=relaxed/simple;
	bh=L8QaQlnQZqDSbKGcaArdBOq7kSV7Mtdn6A22XnKLLFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChTxQv+kREKALwmCbw2F10eNHFYESiReYeCrN5ywETb78inTC0cAbyulLIbDnRMY+FA9wgPy8ishVeLx99abFWUwM2Vp6hywxhhYGkQ76Isc6UscCkktQfbNrNSuHri3aau6FYiNROql1tcNaGNcL9vHc5V82ZUDPtUYA3pqEQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZczIbiZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZczIbiZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346D1C4AF18;
	Tue,  2 Jul 2024 06:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719902984;
	bh=L8QaQlnQZqDSbKGcaArdBOq7kSV7Mtdn6A22XnKLLFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZczIbiZ3WLYKxTNcPX4NCvFBEFNuXaAdnwd2AWr87Lpu1tQUylQmupUJj3Gywi/5o
	 K556XJfPZhP4bCrMBex70eiOReEhMFrzVu9NTZQfLl11MRQzPgwx4p9q3SaDY6zm6d
	 +80c5tZZ0KK9XlABR2+y+UpYm+I4eGNm5ICBoEqXiyzD7LOSk140QpEeZUCUzjAiZh
	 WlQ24bUVNI94SCPh5Kt8cyceB6eCqPY4L2EzYepJX6KNCowwxGuWv1VNKyKyGjxD1I
	 WJd2nur3qnOi1KaRnvb+OcIPJMtibEDiqpAJ04qIe5MN+Be32/71/7oDmeU1cdB9KZ
	 q5jg+l3AsxS5A==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 4/7] dm-verity: provide dma_alignment limit in io_hints
Date: Mon,  1 Jul 2024 23:48:32 -0700
Message-ID: <20240702064835.120541-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702064835.120541-1-ebiggers@kernel.org>
References: <20240702064835.120541-1-ebiggers@kernel.org>
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
 drivers/md/dm-verity-target.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 4ef814a7faf4..c6a0e3280e39 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1021,10 +1021,12 @@ static void verity_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 	if (limits->physical_block_size < 1 << v->data_dev_block_bits)
 		limits->physical_block_size = 1 << v->data_dev_block_bits;
 
 	blk_limits_io_min(limits, limits->logical_block_size);
+
+	limits->dma_alignment = limits->logical_block_size - 1;
 }
 
 static void verity_dtr(struct dm_target *ti)
 {
 	struct dm_verity *v = ti->private;
-- 
2.45.2

