Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ABBC8F6B;
	Sat, 16 Mar 2024 03:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710560160; cv=none; b=TjBnhdv8P0JpBLz53uDx/YbHgcZqWtrhlUz/YMkfvGI9aRcl29Mr9Oll802VZnmeejdCJDQdqn8rrgbUaz1zaBNgODewSgnpnw1PbSayja2F8b0+XX0w5Px6YQgAtgE6s3hBH6rwgU9KCZSAxy85jvaKdyRbc2un64AracZ0PS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710560160; c=relaxed/simple;
	bh=S/LH7AxyfK2fyOusOR2YRktF/5mKHe/1aFVmYHWd2o4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=mhi4ZRSkRGJOeo7bQenwZaJ3D8W66AmFImO1pmNqcJCvMnJGtQQpSPJONb2tMar5Fw5M7Ql4WX6Eu9LQRZgwBj0BiH4ZrjPcPSv1nYURMT4nINzLd++HeeSzwjU0izhaEv+/fKNaRc8g7iUVoDziPqkU2nYIm/A3LR08sOdH9l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=rusoHeoy; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="rusoHeoy"
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id DC1CD20B74D7; Fri, 15 Mar 2024 20:35:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DC1CD20B74D7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1710560153;
	bh=v4lY4mSJnrtZv0A6Uq6/sTuYoGyoZIJN7egWmAQun+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rusoHeoy9abWEvfXakxtms4v6DUlN+mJyWjE+AdBnyZkcB3xcvlGcb0fUfoE39Swn
	 7BMAH8f13yGQXi1s3yZ6Sdx+dUn7uEXm9qdxF9EmtBM5DaZiIUPJ+vCryUF4c7Fz4+
	 vlQhGylZN0WoLzscY4uKJkC7XnYSyYxewULX6NWs=
From: Fan Wu <wufan@linux.microsoft.com>
To: corbet@lwn.net,
	zohar@linux.ibm.com,
	jmorris@namei.org,
	serge@hallyn.com,
	tytso@mit.edu,
	ebiggers@kernel.org,
	axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	eparis@redhat.com,
	paul@paul-moore.com
Cc: linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	audit@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fan Wu <wufan@linux.microsoft.com>
Subject: [RFC PATCH v15 12/21] security: add security_bdev_setintegrity() hook
Date: Fri, 15 Mar 2024 20:35:42 -0700
Message-Id: <1710560151-28904-13-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1710560151-28904-1-git-send-email-wufan@linux.microsoft.com>
References: <1710560151-28904-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

This patch introduces a new hook to save block device's integrity
data. For example, for dm-verity, LSMs can use this hook to save
the roothash signature of a dm-verity into the security blob,
and LSMs can make access decisions based on the data inside
the signature, like the signer certificate.

Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

--
v1-v14:
  + Not present

v15:
  + Introduced
---
 include/linux/lsm_hook_defs.h |  2 ++
 include/linux/security.h      | 14 ++++++++++++++
 security/security.c           | 28 ++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index c335404470dc..6808ae763913 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -455,4 +455,6 @@ LSM_HOOK(void, LSM_RET_VOID, initramfs_populated, void)
 
 LSM_HOOK(int, 0, bdev_alloc_security, struct block_device *bdev)
 LSM_HOOK(void, LSM_RET_VOID, bdev_free_security, struct block_device *bdev)
+LSM_HOOK(int, 0, bdev_setintegrity, struct block_device *bdev,
+	 enum lsm_intgr_type type, const void *value, size_t size)
 
diff --git a/include/linux/security.h b/include/linux/security.h
index 9965b5c50df4..eaff8868766a 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -83,6 +83,10 @@ enum lsm_event {
 	LSM_POLICY_CHANGE,
 };
 
+enum lsm_intgr_type {
+	__LSM_INTGR_MAX
+};
+
 /*
  * These are reasons that can be passed to the security_locked_down()
  * LSM hook. Lockdown reasons that protect kernel integrity (ie, the
@@ -511,6 +515,9 @@ int lsm_fill_user_ctx(struct lsm_ctx __user *uctx, u32 *uctx_len,
 		      void *val, size_t val_len, u64 id, u64 flags);
 int security_bdev_alloc(struct block_device *bdev);
 void security_bdev_free(struct block_device *bdev);
+int security_bdev_setintegrity(struct block_device *bdev,
+			       enum lsm_intgr_type type, const void *value,
+			       size_t size);
 #else /* CONFIG_SECURITY */
 
 static inline int call_blocking_lsm_notifier(enum lsm_event event, void *data)
@@ -1495,6 +1502,13 @@ static inline void security_bdev_free(struct block_device *bdev)
 {
 }
 
+static inline int security_bdev_setintegrity(struct block_device *bdev,
+					     enum lsm_intgr_type, type,
+					     const void *value, size_t size)
+{
+	return 0;
+}
+
 #endif	/* CONFIG_SECURITY */
 
 #if defined(CONFIG_SECURITY) && defined(CONFIG_WATCH_QUEUE)
diff --git a/security/security.c b/security/security.c
index 4274bbee40d0..8d88529ac904 100644
--- a/security/security.c
+++ b/security/security.c
@@ -5637,6 +5637,34 @@ void security_bdev_free(struct block_device *bdev)
 }
 EXPORT_SYMBOL(security_bdev_free);
 
+/**
+ * security_bdev_setintegrity() - Set the bdev's integrity data
+ * @bdev: block device
+ * @type: type of integrity, e.g. hash digest, signature, etc
+ * @value: the integrity value
+ * @size: size of the integrity value
+ *
+ * Register a verified integrity measurement of a bdev with the LSM.
+ *
+ * Return: Returns 0 on success, negative values on failure.
+ */
+int security_bdev_setintegrity(struct block_device *bdev,
+			       enum lsm_intgr_type type, const void *value,
+			       size_t size)
+{
+	int rc = 0;
+	struct security_hook_list *p;
+
+	hlist_for_each_entry(p, &security_hook_heads.bdev_setintegrity, list) {
+		rc = p->hook.bdev_setintegrity(bdev, type, value, size);
+		if (rc)
+			return rc;
+	}
+
+	return LSM_RET_DEFAULT(bdev_setintegrity);
+}
+EXPORT_SYMBOL(security_bdev_setintegrity);
+
 #ifdef CONFIG_PERF_EVENTS
 /**
  * security_perf_event_open() - Check if a perf event open is allowed
-- 
2.44.0

