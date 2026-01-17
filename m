Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A740114A91;
	Sat, 17 Jan 2026 03:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768619014; cv=none; b=mCBJqMMrA0t1gjgPB8/dp6OZoiLTdnvF7myjjXoAhMIx9qgRTd8Utg+rxjwUJl2UBaZxRNTiImWVx3VrT87+p9vFG2yi5nBOXfeemdKoUgQCxT6KAQhLA21GBMAhs06O0gLDpUlEZDNtfGj4uEdH/Ywa44bAA0lj2tyefSWPfKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768619014; c=relaxed/simple;
	bh=5a1WgP/Qg2izGvJGBk/tBOl6Nj20ZHzFu58PWB8StLA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=at19hV6QNN4/Nf4AR5ZGIpuaF3EMWlvjKG/UrVXvywMA1uC5B0jC5nVIdaN/Tv6nhhYT0jF261b0wUQBTySMZYWVCq2IWXnUi8JubYtTzjLedYs6BO8dde8Rn0IRrt9efyocNZESdXy7Iw6TUFzY8XBGJnq3MnUyDCEVL3bIxFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pydZAKNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pydZAKNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58E1C116C6;
	Sat, 17 Jan 2026 03:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768619014;
	bh=5a1WgP/Qg2izGvJGBk/tBOl6Nj20ZHzFu58PWB8StLA=;
	h=From:To:Cc:Subject:Date:From;
	b=pydZAKNPweCLWsmd3hbrw+9IBGSZWK/Z0P5xULc4PJApowrT4MYjx820A+lw6DcK0
	 eAqmuG4OdrYPMmzWzLXC/+GzU9HxBtlpTGoDOqCa46lDMYCM0wGrKeAsCUuRSbB/e0
	 PqhG8e+Lz3KowIBmyRJGOriahaMlcGslGjFs68lcEwpNtODgAdpNBM/I83wrFt9KAf
	 PfIpoCEOr9NWuP7qZYpIVB9evVXPM4xYSUD/P9MP09o+L6eeVKuDaJAlQzUO+4BRjy
	 usRonrCu7oQEW0b9nYs3VwIGGD7L1utMadBoXxZrEzcx8Z+7ZYnUDEpsg1ursdBFN3
	 dQMB5s5g7U9Tg==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] dm: fix excessive blk-crypto operations for invalid keys
Date: Fri, 16 Jan 2026 19:02:36 -0800
Message-ID: <20260117030236.96871-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm_exec_wrappedkey_op() passes through the derive_sw_secret, import_key,
generate_key, and prepare_key blk-crypto operations to an underlying
device.

Currently, it calls the operation on every underlying device until one
returns success.

This logic is flawed when the operation is expected to fail, such as an
invalid key being passed to derive_sw_secret.  That can happen if
userspace passes an invalid key to the FS_IOC_ADD_ENCRYPTION_KEY ioctl.

When that happens on a device-mapper device that consists of many
dm-linear targets, a lot of unnecessary key unwrapping requests get sent
to the underlying key wrapping hardware.

Fix this by considering the first device only.  As already documented in
the comment, it was already checked that all underlying devices support
wrapped keys, so this should be fine.

Fixes: e93912786e50 ("dm: pass through operations on wrapped inline crypto keys")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-table.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 0522cd700e0e..4b70872725d0 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1235,13 +1235,10 @@ static int dm_wrappedkey_op_callback(struct dm_target *ti, struct dm_dev *dev,
 	struct block_device *bdev = dev->bdev;
 	struct blk_crypto_profile *profile =
 		bdev_get_queue(bdev)->crypto_profile;
 	int err = -EOPNOTSUPP;
 
-	if (!args->err)
-		return 0;
-
 	switch (args->op) {
 	case DERIVE_SW_SECRET:
 		err = blk_crypto_derive_sw_secret(
 					bdev,
 					args->derive_sw_secret.eph_key,
@@ -1264,13 +1261,11 @@ static int dm_wrappedkey_op_callback(struct dm_target *ti, struct dm_dev *dev,
 					     args->prepare_key.lt_key_size,
 					     args->prepare_key.eph_key);
 		break;
 	}
 	args->err = err;
-
-	/* Try another device in case this fails. */
-	return 0;
+	return 1; /* No need to continue the iteration. */
 }
 
 static int dm_exec_wrappedkey_op(struct blk_crypto_profile *profile,
 				 struct dm_wrappedkey_op_args *args)
 {
@@ -1292,18 +1287,17 @@ static int dm_exec_wrappedkey_op(struct blk_crypto_profile *profile,
 	 * implementations of wrapped inline crypto keys on a single system.
 	 * It was already checked earlier that support for wrapped keys was
 	 * declared on all underlying devices.  Thus, all the underlying devices
 	 * should support all wrapped key operations and they should behave
 	 * identically, i.e. work with the same keys.  So, just executing the
-	 * operation on the first device on which it works suffices for now.
+	 * operation on the first device suffices for now.
 	 */
 	for (i = 0; i < t->num_targets; i++) {
 		ti = dm_table_get_target(t, i);
 		if (!ti->type->iterate_devices)
 			continue;
-		ti->type->iterate_devices(ti, dm_wrappedkey_op_callback, args);
-		if (!args->err)
+		if (ti->type->iterate_devices(ti, dm_wrappedkey_op_callback, args) != 0)
 			break;
 	}
 out:
 	dm_put_live_table(md, srcu_idx);
 	return args->err;

base-commit: fb8a6c18fb9a6561f7a15b58b272442b77a242dd
-- 
2.52.0

