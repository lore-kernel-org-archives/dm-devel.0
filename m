Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7271A2863
	for <dm-devel@lists.linux.dev>; Tue, 10 Sep 2024 17:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725990808; cv=none; b=T/7KLzDjMQ6ZAOlCvi3r4pPi/19Kj2G+q9Pj3uebkANVd4hColdMWKmN9S62t5welUtcPN4VkzBGFqTtYe8JP4rPbAXD+oeWp9ybiSMY1X/RIjkHm0JbpEx6jnyx+E+knSKnucyNPnBflOKV2Q96izR1XKV/Mie84E31x02XawE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725990808; c=relaxed/simple;
	bh=6kVRmhcY27IMIshVdo37fwIRS0zn2TwOQy3S3U3AcmA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TSYjDBy7SmkxaxmhzgsdZd8afsiasfp15cnHSYpi+FMSugFB/IhV3/mvYVp+V9LUvzeWTFZZE/0AUhjpj3euFetIp/HauQISBOapX2yy1zly0Ag7DmumqbeNUf1FfnHU9pE/qARTNqTeYNXhVvJC5KqRDgF7BZuftLZbTnbdKJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ngi5wxSz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ngi5wxSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A43C4CEC3;
	Tue, 10 Sep 2024 17:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725990808;
	bh=6kVRmhcY27IMIshVdo37fwIRS0zn2TwOQy3S3U3AcmA=;
	h=From:To:Cc:Subject:Date:From;
	b=Ngi5wxSzrDVWfEwrkOfd3XgqYgIkzz58esXHoBOLG4LmKySUQGyNxpiO37Xy/7o5g
	 8GizjqGKJq5fnWU+cN6bS2xbB8bSt9lJyBTcnU8S1Nrgfvy710bO2IfPxjBVLj8VCY
	 5EnuVvlLFfaZD+jaJ6trwIy1sewF3icD4kXuBXoayTF37v+56y7W5SxUtnpyksJyKi
	 5zsPCgXGHNOU7YrqlRBHI7I1MLz98h7BnIcfoTQN6VoTipIQwOQq1syc421poc0p6u
	 +SkuIKxWgrcB4PmCxsWJwE+tRTG1wyVfXDoeFwOvX5EjJhekqgZsOXAhAnb2RKa1Jf
	 X4v14sCuy0B0w==
From: Eric Biggers <ebiggers@kernel.org>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Cc: kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] dm-integrity: check mac_size against HASH_MAX_DIGESTSIZE in sb_mac()
Date: Tue, 10 Sep 2024 10:52:59 -0700
Message-ID: <20240910175259.28620-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

sb_mac() verifies that the superblock + MAC don't exceed 512 bytes.
Because the superblock is currently 64 bytes, this really verifies
mac_size <= 448.  This confuses smatch into thinking that mac_size may
be as large as 448, which is inconsistent with the later code that
assumes the MAC fits in a buffer of size HASH_MAX_DIGESTSIZE (64).

In fact mac_size <= HASH_MAX_DIGESTSIZE is guaranteed by the crypto API,
as that is the whole point of HASH_MAX_DIGESTSIZE.  But, let's be
defensive and explicitly check for this.  This suppresses the false
positive smatch warning.  It does not fix an actual bug.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202409061401.44rtN1bh-lkp@intel.com/
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-integrity.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 51e6964c13054..3b9738787c855 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -489,11 +489,12 @@ static int sb_mac(struct dm_integrity_c *ic, bool wr)
 	int r;
 	unsigned int mac_size = crypto_shash_digestsize(ic->journal_mac);
 	__u8 *sb = (__u8 *)ic->sb;
 	__u8 *mac = sb + (1 << SECTOR_SHIFT) - mac_size;
 
-	if (sizeof(struct superblock) + mac_size > 1 << SECTOR_SHIFT) {
+	if (sizeof(struct superblock) + mac_size > 1 << SECTOR_SHIFT ||
+	    mac_size > HASH_MAX_DIGESTSIZE) {
 		dm_integrity_io_error(ic, "digest is too long", -EINVAL);
 		return -EINVAL;
 	}
 
 	desc->tfm = ic->journal_mac;

base-commit: 8d8d276ba2fb5f9ac4984f5c10ae60858090babc
-- 
2.46.0

