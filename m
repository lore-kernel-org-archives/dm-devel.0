Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FC218FDC8;
	Wed,  3 Jul 2024 20:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720037374; cv=none; b=J+/vBnGvH83PcKhzYv4MuzPFKoySsO/OmCWhAU1lIW4HitUhzLPKhi/TKA6viuTDTRSGHYsiRjqdi6HgPYALNFmqD9FeSXWO+yw66ugJA6ke0VKthmdSfKu2cj9L2KRUe3gk1oYXEyNj/gjnT8RUozO+qMxrhnPwwrn8knrbfRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720037374; c=relaxed/simple;
	bh=Wnd3o8k1qpgOfPgnkTw0f/86KjmhH34TRGl5E7XRXIw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hT6vQYI3XSIslqlu2jXL91majwU9IB1f0B62CB3IWiH37m2pFfo+X4ZQyGjT550IaCsn4EUFNRioL3s2LvjpEY9c2PgJYT1uGIfbctcFy6zqGKEMH7t33vFUJs8vssnV1Xnyg+pbFWQ9Oq59ImkJgXLdEo4qp0wlpoHvdfiA4XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OHF0m6/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OHF0m6/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0497CC2BD10;
	Wed,  3 Jul 2024 20:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720037374;
	bh=Wnd3o8k1qpgOfPgnkTw0f/86KjmhH34TRGl5E7XRXIw=;
	h=From:To:Cc:Subject:Date:From;
	b=OHF0m6/gf0FO74XTNMVbkzvMC5tPZ0F9b2WrUWqcXUvT6MTfiNRScZdkD19jNerIO
	 fDzTQrIYSVKhWYX5omZ6dqwRY9Ohz9uDcvEQ+JDiL/x6lXiq3Z5dlJLnHklTGuBNWa
	 OENRbiAA5oi9U2WHEGjzVEyIwA+1GBgpWH1Nasq1vZOMHOx0tjhPjC7bkG2bw1iXSq
	 LoMOmkXUWQxrsqdLm4oaLR9NTC/oCl3a/eIIeiyYpSP5hCcWRSbe+msufoceV1FpqQ
	 bVgv6DZT/uk/xbXywPLwNmaN4WAXahJVP5CSFxEQxI0pAgbselnFsePXgEc2M1NStP
	 paztPvpMgCVaA==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Matthias Kaehlcke <mka@chromium.org>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH] dm-verity: fix dm_is_verity_target() when dm-verity is builtin
Date: Wed,  3 Jul 2024 13:08:13 -0700
Message-ID: <20240703200813.64802-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

When CONFIG_DM_VERITY=y, dm_is_verity_target() returned true for any
builtin dm target, not just dm-verity.  Fix this by checking for
verity_target instead of THIS_MODULE (which is NULL for builtin code).

Fixes: b6c1c5745ccc ("dm: Add verity helpers for LoadPin")
Cc: stable@vger.kernel.org
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-target.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 0a2399d958b7..cf659c8feb29 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1519,18 +1519,10 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	verity_dtr(ti);
 
 	return r;
 }
 
-/*
- * Check whether a DM target is a verity target.
- */
-bool dm_is_verity_target(struct dm_target *ti)
-{
-	return ti->type->module == THIS_MODULE;
-}
-
 /*
  * Get the verity mode (error behavior) of a verity target.
  *
  * Returns the verity mode of the target, or -EINVAL if 'ti' is not a verity
  * target.
@@ -1580,10 +1572,18 @@ static struct target_type verity_target = {
 	.iterate_devices = verity_iterate_devices,
 	.io_hints	= verity_io_hints,
 };
 module_dm(verity);
 
+/*
+ * Check whether a DM target is a verity target.
+ */
+bool dm_is_verity_target(struct dm_target *ti)
+{
+	return ti->type == &verity_target;
+}
+
 MODULE_AUTHOR("Mikulas Patocka <mpatocka@redhat.com>");
 MODULE_AUTHOR("Mandeep Baines <msb@chromium.org>");
 MODULE_AUTHOR("Will Drewry <wad@chromium.org>");
 MODULE_DESCRIPTION(DM_NAME " target for transparent disk integrity checking");
 MODULE_LICENSE("GPL");

base-commit: ed28fe59c042e9b5bf3b15050aa6ee67834dc852
-- 
2.45.2

