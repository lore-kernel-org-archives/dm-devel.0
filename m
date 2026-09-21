Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D2F5187D2;
	Mon, 21 Sep 2026 22:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790028344; cv=none; b=ZteYjS67aoi0tLZNqDn3LRAoCfQuFeliHAhBVJr9kleIzYqyj+E7K5+Y/rtlIUwyG6t6ZUMUxuAumUeMjGZjuaticJ/8HDcTzzKtN8NvgH9Mp/u8EyHiP02WMhF6BHenhzPhgXZNAFxODcnT91x18drP2W1LgcX6zJwVcLbXBRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790028344; c=relaxed/simple;
	bh=H0ZqOMWSDrSccw+WfcFj+jn2IiHcjZc2dnNV1PVUHVM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SiTNBrNvSZIJWQnDS8Jd5azXhz5H/Ju8hFSoJJLtD8+QDM6kj+bBQRLiwU6YyWrXX2OlJ68GSN4LX+YJQmHDQ24DPZX68THd3DeXHie42nkS/Y9bqztJm8xmOk6IeiVPPT9FiOwS0NF/ogAzrePpJXYtgzJZdum96FNY5veYnu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EjBZDdQP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EjBZDdQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAAD1F00893;
	Mon, 21 Sep 2026 22:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790028342;
	bh=3GVRA9fC7yflZcNedTsXzEJcwATM8ADzIRFA48lzCe4=;
	h=From:To:Cc:Subject:Date;
	b=EjBZDdQP2d1uF6tFup2JoEFLPCrmW0zS0zENwrX7uw3nIktU+WicZTx/KjttytBel
	 IjCxMM4CnAb6QecI7hRnRUWpPFVYgDm8ZOxkBYERzPbJDZQXRVdnfq6NTasP8IIuQM
	 0symAsvTAqWnZlgHVQZXYuDZsdne6MODmoD9zbZNvwExdZF6/WdocVPs+LHmyE4gB6
	 CfcD9qGw3IZlh/j9l+sTwwu9H4zbg3KtwZ4Ibvz3z/14vf31LOSoMS8lsqA3Srdx7L
	 gHbNnLE9z4E3Ifj5/EuRpxfboB/qa8i5+1jMXKtQwJ8Feiui59/Ccg2680GplaTzvt
	 BSNxLKx+BwSGA==
From: Fan Wu <wufan@kernel.org>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	snitzer@kernel.org,
	agk@redhat.com,
	bmarzins@redhat.com,
	paul@paul-moore.com,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dm-verity: clear LSM integrity state on suspend
Date: Mon, 21 Sep 2026 15:05:16 -0700
Message-ID: <20260921220516.121589-1-wufan@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-verity publishes its root hash and signature state to LSMs in
verity_preresume(). LSMs such as IPE store this information in the block
device's security blob and use it to authorize access to files.

The original LSM integration relied on DM_TARGET_IMMUTABLE to prevent
verity from being replaced by a different target type. However, DM allows
tables containing a DM_TARGET_WILDCARD target to replace immutable
targets. The block device can then retain the old integrity state even
though its data is no longer verified by dm-verity.

Clear the published root hash and signature state in verity_postsuspend()
so that the block device does not retain stale dm-verity attributes after
the verity target is replaced.

Fixes: a6af7bc3d72f ("dm-verity: expose root hash digest and signature data to LSMs")
Assisted-by: gpt-6-astra
Signed-off-by: Fan Wu <wufan@kernel.org>
---
 drivers/md/dm-verity-target.c | 39 ++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index cb105ccc47ec..6d589867623c 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -825,13 +825,6 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_SUBMITTED;
 }
 
-static void verity_postsuspend(struct dm_target *ti)
-{
-	struct dm_verity *v = ti->private;
-	flush_workqueue(v->verify_wq);
-	dm_bufio_client_reset(v->bufio);
-}
-
 /*
  * Status: V (valid) or C (corruption found)
  */
@@ -1733,6 +1726,11 @@ static int verity_security_set_signature(struct block_device *bdev,
 					  v->sig_size);
 }
 
+static void verity_security_clear_signature(struct block_device *bdev)
+{
+	security_bdev_setintegrity(bdev, LSM_INT_DMVERITY_SIG_VALID, NULL, 0);
+}
+
 #else
 
 static inline int verity_security_set_signature(struct block_device *bdev,
@@ -1741,6 +1739,10 @@ static inline int verity_security_set_signature(struct block_device *bdev,
 	return 0;
 }
 
+static inline void verity_security_clear_signature(struct block_device *bdev)
+{
+}
+
 #endif /* CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG */
 
 /*
@@ -1779,8 +1781,31 @@ static int verity_preresume(struct dm_target *ti)
 	return r;
 }
 
+static void verity_security_clear_integrity(struct dm_target *ti)
+{
+	struct block_device *bdev = dm_disk(dm_table_get_md(ti->table))->part0;
+
+	security_bdev_setintegrity(bdev, LSM_INT_DMVERITY_ROOTHASH, NULL, 0);
+	verity_security_clear_signature(bdev);
+}
+
+#else
+
+static inline void verity_security_clear_integrity(struct dm_target *ti)
+{
+}
+
 #endif /* CONFIG_SECURITY */
 
+static void verity_postsuspend(struct dm_target *ti)
+{
+	struct dm_verity *v = ti->private;
+
+	flush_workqueue(v->verify_wq);
+	dm_bufio_client_reset(v->bufio);
+	verity_security_clear_integrity(ti);
+}
+
 static struct target_type verity_target = {
 	.name		= "verity",
 /* Note: the LSMs depend on the singleton and immutable features */

base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
2.55.0

