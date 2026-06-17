Received: from speicherleck.de (speicherleck.de [173.249.60.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D102DFF04
	for <dm-devel@lists.linux.dev>; Wed, 17 Jun 2026 14:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.249.60.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781707355; cv=none; b=C7WZrNJ8QdlrHXzIxFk1pMg1MYy0bk8HLl2YyV/9OkJ9fGl/xtt59I8VKDyTPxMa1dWY45dlFFxVrI8K0YPa2OHexP3Sy/YcB7zo3VVeYf53XzmeNRcB0JboFNAGKHFkrbu9qcUpE3WRIcSJdElTjg50xcKQHgfCzPQ93qdR/bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781707355; c=relaxed/simple;
	bh=hT1IgceYjV154Tk6g/szWgxEAQG9O7pMC++LnV1fmXg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=u3yA/021MRdKP2rOGMd5kmuvBhPk6zej7hfaF5xWgF+hRgaVAhJ9OLPP5tWRkU7ytGsM0JDXWGI8i+mWQY+Fz+JsxOynsfIxhi23P9thEWhAtpQJtOR+OG4VDbyDgHgRjYH7GJut4c4iM00KNkIS3yVlhmL0qzIOb0/5MkEKEGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=speicherleck.de; spf=pass smtp.mailfrom=speicherleck.de; dkim=pass (2048-bit key) header.d=speicherleck.de header.i=@speicherleck.de header.b=hZbfOsiN; arc=none smtp.client-ip=173.249.60.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=speicherleck.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=speicherleck.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=speicherleck.de header.i=@speicherleck.de header.b="hZbfOsiN"
Received: from quasitopos (agdapad.quasicoherent.io [62.171.174.139])
	by speicherleck.de (Postfix) with ESMTPSA id 7DA2125E84EF;
	Wed, 17 Jun 2026 16:33:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=speicherleck.de;
	s=201902; t=1781706822;
	bh=hT1IgceYjV154Tk6g/szWgxEAQG9O7pMC++LnV1fmXg=;
	h=Date:From:To:Cc:Subject:From;
	b=hZbfOsiNKciW/I9Q/6NeCeBigJ/xf90xq/hFzzyiM3g/hTST/BHCRj5ytBAbcPzwd
	 Hf01ZBDx4pa2tfeZYv/TRD57ENAGc7y4+GSZAsAm/LydmPfv3y2ZO0uyGDTriMrnoM
	 Aw7WCh+/Se61o8+XGOb0cpT2YY+w+OcqwmJYdDleVBMMEeI/EMKDhRiXf9znAlxEva
	 Qu9L8WJ2ABS7NCK4RWvNS8SYQPG+aPNzUmf2+JEn0Kami8jMEFGNZy2GvwQr3Nt9kT
	 fgrSnG7KdEiBk/66ysyYKfcinwpgvRpXO/nzDRLIqJW0kvRrrBhhub/RwaabdkdW6t
	 N8QWf9zCUMhVA==
Date: Wed, 17 Jun 2026 16:33:42 +0200
From: Ingo Blechschmidt <iblech@speicherleck.de>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH] dm: avoid leaking the caller's thread keyring via the table
 device file
Message-ID: <ajKwRtP8izwRsMmv@quasitopos>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Registered-Linux-user: 232173 http://counter.li.org/

The refactoring in commit a28d893eb327 ("md: port block device access to file")
accidentally causes the caller's thread keyring to be kept alive long
beyond the caller's lifetime.

As a result, "cryptsetup luksSuspend" silently fails to wipe the
LUKS volume key from memory.

In detail: "cryptsetup luksOpen" uses its supposedly ephemeral thread
keyring to pass the volume key to the kernel. dm-crypt's
crypt_set_keyring_key() copies the key material into its own
crypt_config structure and then drops its own reference to the key in
the keyring with key_put().

With this fix, restoring pre-v6.9 behavior, the copy in the thread
keyring is then promptly garbage collected, such that exactly one copy
of the volume key remains. This single copy is correctly wiped from
memory on "cryptsetup luksSuspend".

Without this fix, the thread keyring and the volume key in it remains.
This second copy is only freed on "luksClose". "luksSuspend" neither
knows about this copy nor has any way to remove it, so the key remains
recoverable from RAM after a suspend that is documented to have wiped it.

This fix should not introduce new security problems, as the code is
anyway gated by CAP_SYS_ADMIN. The device-mapper core, not the calling
task, is the legitimate owner of this long-lived file.

Fixes: a28d893eb327 ("md: port block device access to file")
Closes: https://gitlab.com/cryptsetup/cryptsetup/-/work_items/993
Link: https://www.speicherleck.de/iblech/cryptsetup-luksSuspend-issue-reproduction/
Signed-off-by: Ingo Blechschmidt <iblech@speicherleck.de>
Cc: stable@vger.kernel.org
---
This is only my second kernel patch; I don't have a complete grasp of
the potential long-range interactions: This changes the credentials used
to open the backing device for *all* table devices, not just dm-crypt's.
I roughly followed the similar pattern in drivers/block/nbd.c, where
scoped_with_kernel_creds is used for dealing with the socket. Please
exercise extra caution. Happy to revise.

 drivers/md/dm.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7287bed6eb64..d413bfaf3527 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -735,7 +735,16 @@ static struct table_device *open_table_device(struct mapped_device *md,
 		return ERR_PTR(-ENOMEM);
 	refcount_set(&td->count, 1);
 
-	bdev_file = bdev_file_open_by_dev(dev, mode, _dm_claim_ptr, NULL);
+	/*
+	 * Open the backing device with kernel rather than caller
+	 * credentials. Otherwise the caller's credentials would be
+	 * pinned in bdev_file->f_cred until the table device is closed.
+	 * That would keep the caller's thread keyring alive long beyond the
+	 * lifetime of the caller, breaking userspace expectation (e.g.
+	 * cryptsetup(8) leaking the LUKS volume key).
+	 */
+	scoped_with_kernel_creds()
+		bdev_file = bdev_file_open_by_dev(dev, mode, _dm_claim_ptr, NULL);
 	if (IS_ERR(bdev_file)) {
 		r = PTR_ERR(bdev_file);
 		goto out_free_td;
-- 
2.43.0
