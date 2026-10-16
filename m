Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FEB195B1A;
	Fri, 16 Oct 2026 17:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792171229; cv=none; b=P9wdueyiU9Ujo19wnk4ELMLYjS0SiK1iB6dKoCxQIvWnrg6wPVdBBzO5tIYYVNnylPWSVB1pP5j+SqCHu29m/XECiBqK7fMcoAhXp2NSS/fe5k/BvRGFfj76Juk1vLIjqN67y6iVdtB3vwNqUMNiSfWytlXKfyTGymmoiKo8Bt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792171229; c=relaxed/simple;
	bh=R8GsbrkysZNAyaKhqc60djA2ZE/pwdjuufzdo8xO4rE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W6nqn63nbhdWz5qG2hiVzOKYvMft5S8IM2tVfBsQ5kG9fqu5A0zLwwaaZ68Gy67/ptMSCiAPV1PRFXgqVQjLk7vJhZdx7IK++o4ebLG1fzA5+Ii4EixYc4EetD6K0tw4sjmOH5b9uBieTU+YR7Afla9lzRKAm8s3KZ/vKrByVfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lUetEhb3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lUetEhb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADFB1F000C4;
	Fri, 16 Oct 2026 17:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792171227;
	bh=EOiZPV/bfyfBLrfe1xRvHOq0XMIC6igyuquONsX4cMg=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=lUetEhb3tGzGDU7xmG5C5HDLspwaHsdPag4yaDC0giZNLYwM0Dy9MVInnt8P8YHsf
	 6Id8nO1u4Rf0BD/xyNR2g7KQJcc7CjwrDs1KXBZAinokVDhvnFYd3cX/KPT7bsJWxk
	 BU6jzj16jtD32fYfliWZyv1evd96WIFdHgCdqhC41/xwxbOiYcU6gZAEO5mfb8Seu0
	 0RLFdjqWyJ4WSnCiTR9qmIpHJuykpBd3a8nQrfdAIZu04791UKdz5R/MQFwZWUWkQK
	 cMyqLP4bPkOEeWbUJfF7IHxPQgPTZM6pynNwCHfYQ+EPJYZUNYaZp81Qq4kGOz5wFK
	 tEHpnwIlkGw+w==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	ben@cressey.dev
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-integrity: fix buffer overflow with keyed discard" has been added to the 6.12-stable tree
Date: Fri, 16 Oct 2026 13:20:26 -0400
Message-ID: <20261016172026.3993737-1-sashal@kernel.org>
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

    dm-integrity: fix buffer overflow with keyed discard

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-integrity-fix-buffer-overflow-with-keyed-discard.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit c5b48bc3fbf4f6a8b1c26f32dca0bd9cf27ae5bc
Author: Ben Cressey <ben@cressey.dev>
Date:   Thu Aug 20 21:44:57 2026 +0000

    dm-integrity: fix buffer overflow with keyed discard
    
    [ Upstream commit 59e6f919d77d72ec79cbf171256f2f7819737580 ]
    
    Since commit 68c5c42567bc ("dm-integrity: replace forgeable discard
    filler with a keyed sector marker"), integrity_metadata computes a
    checksum for every discarded block into the "checksums" buffer.
    integrity_sector_checksum always writes the whole digest. So if the tag
    size is smaller than the digest size, the checksum of the last block
    that fits into the buffer is written past the end of it. For example,
    with hmac(sha256) and tag size 16, a 4MiB discard writes 16 bytes past
    the kmalloc'ed page.
    
    Fix this by subtracting extra_space from the buffer size when computing
    max_blocks, like we do for writes.
    
    Fixes: 68c5c42567bc ("dm-integrity: replace forgeable discard filler with a keyed sector marker")
    Reviewed-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
    Signed-off-by: Ben Cressey <ben@cressey.dev>
    Assisted-by: Claude:unspecified
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 513c6d5fd74e1..b1313077de7ab 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1857,7 +1857,7 @@ static void integrity_metadata(struct work_struct *w)
 		if (unlikely(dio->op == REQ_OP_DISCARD)) {
 			unsigned int bi_size = dio->bio_details.bi_iter.bi_size;
 			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
-			unsigned int max_blocks = max_size / ic->tag_size;
+			unsigned int max_blocks = (max_size - extra_space) / ic->tag_size;
 			sector_t sector = dio->range.logical_sector;
 
 			if (!ic->discard_keyed)
