Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795739947;
	b=KRAWf3GkF9VLQIekexEgelxd20ADcmno2q2/lI6GrL+iNL85fc6Oc6FWRZ6IAopXfEQM
	 8bVrBVSYp7VCJM9TSblk6qJSOpxrgHJhT3d/oWa6tALZ4kAyLm1Npll4TyaplOGWSTLoa
	 /GjRJPMXCweu/pwXRWyopDiE4FZvX3HFVwY9WMCI5J2wWRNlqLUpmCNn8RYjXdGp6FjJM
	 KYyLH0MQMdhnoghfQXY5kpBGyqvcw0DpmJ5LTpfdgFB3WNHleMbFu/xFNIylHGHurPeW6
	 TPDOaqZcRwqqV+untX4bF8yX4Fjqo1/9Uz87QT7bgmIvmZjvF6mSY0YcAK2meLKGyoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795739947;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OvwsNYV9K/LXXZpGZnFqU4JXKALJmJzA8uLyf3/RYp8=;
	b=41DMhRBVpFqKEBWLPzI3Qzf1AXYPku0MrQlM1j70H5HFpsM5pnBeBRJzDmVSksXvQPRi
	 99zWWiP3h7KljFUsUf3CejRwV0boKz2HuIYDJa3xi2kd5KPrVnJSLmGX6wEBuQxJ3uZf9
	 RvoRBnV1HN0r7SgFmj/AfQ8Oby1bINXg8eM1ncxNTaEIusFVKrEiepcDwuZWLVJFaZqlI
	 zJLJmVLlyzguQYRm7UF2mmkGxB9ai0Bm7eVCTvpSGGAFLK6oLGZQoOeBwJDjq2mztD8ya
	 Hg2M6k6w47Dda7LUiVGTIjnomJDBH5NGFRWOo1PflW/FTCOPTUyip8z6mYeSI6QZWIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HnyogqOl;
	arc=none smtp.remote-ip=209.85.219.53
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7C0606A321
	for <dm-devel@lists.linux.dev>; Fri, 27 Nov 2026 00:39:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF7C0606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HnyogqOl
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-921276742e3so69129706d6.2
        for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 16:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795739946; x=1796344746; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OvwsNYV9K/LXXZpGZnFqU4JXKALJmJzA8uLyf3/RYp8=;
        b=HnyogqOl2q4bxLD7dRt3fDcBAZMYsil6om2X5SgNKg0N/kEGrq+QtEYPzVcF1Ifw2p
         fCAJO499iG46Yd3ypuMB5tGvPEO1Vs4UT6ObEURoi0vjgffP2v4k+A0NSs4Nhz5jutSL
         JYUgmReFP9d2O8MMcyIg8uX3/L0FK3YKVV5mfBEVriySkQl4FgbvGbuSnO7f8NePKxgf
         gSVix8KuKHoiLOY2Mhs0s3B1MVqVtltHOJeaB6H2qsqxS/kGhvPf9lWjEC4SxorYsdEb
         jmBvZ0pBWiNh1dgXUbtj019MC3/fhBahsD2Ur8gDbcgs9oWVK9riGMqKlhQrlOq809Ny
         DSeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795739946; x=1796344746;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OvwsNYV9K/LXXZpGZnFqU4JXKALJmJzA8uLyf3/RYp8=;
        b=0FE35GH5BTiSBg8AtyLAmJb0ykCdCcK+c+j3molX12hQzgOj9soIw8iW5HIbLy46Yq
         3oQ1VnfC6XGLPR3FlTzV05DnT5uuNyFjHuFEfoo4Y8eHiXF06UyWN1n6ZufcbDqk1amv
         CPuBBy6h8AKtRlUYHOLGF7u77eR7OYtEuLgagiFuxpNp1xaDjorSBr95XZ6Q9UjtUzCE
         mwDa020Yd8TJv9KpED7QFxlhVSrupk87rN2KAm9T7EofCEHyppOzvySE4fshwRKb18p5
         /2F+wNmch62O61NVjoy1cuA11o3ngfvpLyuNf+t/zDAaB4BZvCrDEa74P1bBKRQS6UOm
         eYFg==
X-Forwarded-Encrypted: i=1; AL+hErFtoLiFu2qV1KpPC+7HTCzMwl0z82ruVVDFC7G5KO0wXDeAtghiObHBBz2BXqnfGElZVF2eXdZ7ag==@lists.linux.dev
X-Gm-Message-State: APuU4Z8fsCOzFDGb+lSoFt112EFF40NQtXxipbeX/7fdfhXYJWBy90mK
	T4NHefabPZIOAXiQgu8/24/7sWclMeTcqYemT4LMWDPBcl1vt2L8VKpf
X-Gm-Gg: AZFdTZeBDAMNUOleadJ+rJ3VO74O+cxl95DJ3R7IMAwFNkpdbB0TFxsg7KfPCilG51k
	PK1iPb0l6hV7ysnRe6R4ALKvsz+MiY4NtbnYn6mQeMmiK1CAiEnJ6sP7wepR4lOILUcef4m+Nkl
	py9NNksFF0h05ZBU2Sg6OAKnkrwYg2xaNCB1fwAbM8tHUTSoU9Q5Ev8vDDOCLITYYhFJXZ1YJvv
	01DM1rfYdQMZHyYA85oMK+uhWF+Gcux0zn/k0rI2/N24/JBoplwCkkQc0OeYhsroEM89YRpo23G
	RVVeRU4JlvfTOYpQD+53lIsjQc2jcf3uVICXA4E4O7AuB30FwK3+EzmlBUBlhJw6kMMESzdJ5pW
	iv2Ey+0IfZKMPyL8OH+WNCVoA0yahX19pPUv0SRsyTnGF/fbrPelg1y3cQJ7L8VW1+H18zEyuTK
	xr/Gc8WEtD8RhLvjr1bHzBO+DnZPcg2cABTsT/sr7pwsf17BF56bz1lS5q+z6iT6CHvpQ8x0C8b
	FHqpH1bIuunVCOpDNUQUYlFrKcvzKuf25wqCjTV3sveo0m3QrUAS01gl8ZUDMXLGeYVba8fjDYH
	usKOmdk+Wy4xBEz2Nn19bzpQm3aVCr75o+YzrdgYy+3X5OQa8PYHEq5/e9Z5mq7P1p9R/vLPRJW
	5Ld1W+/623qi0oeu5BZ3h1zUjNA==
X-Received: by 2002:a05:6214:3bc9:b0:921:89a9:d5c4 with SMTP id 6a1803df08f44-92189a9d8cdmr68634676d6.11.1795739945651;
        Thu, 26 Nov 2026 16:39:05 -0800 (PST)
Received: from localhost ([138.197.109.108])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92134a058aasm200373866d6.33.2026.11.26.16.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 16:39:05 -0800 (PST)
From: Nikolai Dokutovich <ndokutovich@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH] fs: tolerate an unfrozen superblock in the block-layer thaw
Date: Fri, 27 Nov 2026 03:39:02 +0300
Message-ID: <20261127003902.48-1-ndokutovich@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The in-tree selftest tools/testing/selftests/filesystems/freeze fails in
shared_bdev.unmounted_sharer on v7.4-rc1 and v7.4-rc3.

DM suspend locks filesystems by default, so lock_fs() calls bdev_freeze(),
which freezes the superblock through fs_bdev_freeze() -> fs_super_freeze()
with FREEZE_HOLDER_USERSPACE.  A userspace FITHAW thaws that same credit.
On resume bdev_thaw() calls fs_bdev_thaw() -> fs_super_thaw(); the
superblock is already thawed, thaw_super() returns -EINVAL, and
fs_bdev_thaw() propagates the error when a single superblock uses the
device.  bdev_thaw() drops bd_fsfreeze_count only on success, so the count
stays elevated and every later mount that registers a superblock on the
device fails in super_dev_add() with -EBUSY.

The same condition is already tolerated when more than one superblock
uses the device.  Tolerate it for the single-superblock case too.

Add FREEZE_SKIP_UNFROZEN, set only by fs_super_thaw(), the holder thaw of
fs_bdev_thaw().  thaw_super_locked() returns success instead of -EINVAL
when the superblock is SB_UNFROZEN and the flag is set; a partially
frozen superblock, a superblock frozen by a different holder, and a
filesystem thaw error still fail, so the block-device reference is
released only when the holder thaw succeeds.

Filesystems with a custom ->thaw_super (gfs2) are not changed.

Block-layer freezes remain marked FREEZE_HOLDER_USERSPACE, so a userspace
FITHAW can still consume a device-manager freeze credit.  Marking them
FREEZE_HOLDER_KERNEL was considered but would change FITHAW behaviour
during a suspend.

Verified with the in-tree selftest: 5/6 before, 6/6 after.

Fixes: ea4e4cc26301 ("block: allow making a block device unfreezable")
Signed-off-by: Nikolai Dokutovich <ndokutovich@gmail.com>
---
 fs/super.c                     | 11 +++++++++--
 include/linux/fs/super_types.h |  2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index c5a0658f7aaf..5d850736c8d9 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1457,7 +1457,8 @@ static int fs_super_thaw(struct super_block *sb)
 	if (sb->s_op->thaw_super)
 		return sb->s_op->thaw_super(sb,
 				FREEZE_MAY_NEST | FREEZE_HOLDER_USERSPACE, NULL);
-	return thaw_super(sb, FREEZE_MAY_NEST | FREEZE_HOLDER_USERSPACE, NULL);
+	return thaw_super(sb, FREEZE_MAY_NEST | FREEZE_HOLDER_USERSPACE |
+			       FREEZE_SKIP_UNFROZEN, NULL);
 }
 
 static void fs_bdev_mark_dead(struct block_device *bdev, bool surprise)
@@ -2025,7 +2026,8 @@ static int wait_for_partially_frozen(struct super_block *sb)
 }
 
 #define FREEZE_HOLDERS (FREEZE_HOLDER_KERNEL | FREEZE_HOLDER_USERSPACE)
-#define FREEZE_FLAGS (FREEZE_HOLDERS | FREEZE_MAY_NEST | FREEZE_EXCL)
+#define FREEZE_FLAGS (FREEZE_HOLDERS | FREEZE_MAY_NEST | FREEZE_EXCL | \
+		      FREEZE_SKIP_UNFROZEN)
 
 static inline int freeze_inc(struct super_block *sb, enum freeze_holder who)
 {
@@ -2296,6 +2298,11 @@ static int thaw_super_locked(struct super_block *sb, enum freeze_holder who,
 {
 	int error = -EINVAL;
 
+	if (sb->s_writers.frozen == SB_UNFROZEN) {
+		if (who & FREEZE_SKIP_UNFROZEN)
+			error = 0;
+		goto out_unlock;
+	}
 	if (sb->s_writers.frozen != SB_FREEZE_COMPLETE)
 		goto out_unlock;
 
diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
index 6ce105fe8359..434cdc338360 100644
--- a/include/linux/fs/super_types.h
+++ b/include/linux/fs/super_types.h
@@ -64,6 +64,7 @@ struct sb_writers {
  * @FREEZE_HOLDER_USERSPACE: userspace wants to freeze or thaw filesystem
  * @FREEZE_MAY_NEST: whether nesting freeze and thaw requests is allowed
  * @FREEZE_EXCL: a freeze that can only be undone by the owner
+ * @FREEZE_SKIP_UNFROZEN: tolerate thawing a superblock that is not frozen
  *
  * Indicate who the owner of the freeze or thaw request is and whether
  * the freeze needs to be exclusive or can nest.
@@ -78,6 +79,7 @@ enum freeze_holder {
 	FREEZE_HOLDER_USERSPACE	= (1U << 1),
 	FREEZE_MAY_NEST		= (1U << 2),
 	FREEZE_EXCL		= (1U << 3),
+	FREEZE_SKIP_UNFROZEN	= (1U << 4),
 };
 
 struct super_operations {
-- 
2.43.0

