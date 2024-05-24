Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38DAC12FB29;
	Fri, 24 May 2024 20:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716583624; cv=none; b=ISYU4LG3/ZbNJa5uAt3I4TRrvAttvXjQ2r4HBl3Ljurq184XVE6eW0vBDG5yY5ETjsmoQDmeiu8AMyYAKd8TYsy1tPMdlUgVhR9Dmu8djEXhgTY8FQZSFqrbfQgb544OeCBuvh9srIK7OBwX0UBP8Z31D0PBBRD/0ljwRQvil1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716583624; c=relaxed/simple;
	bh=AhH2IqJvdgM9pOq0Cqn3h3nREs4VRy8ntYk/eAa9cO0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=tiJMGyNlAtpBD3OLswnppR71t1v2rR2DL/uMi8ogI36JsazwUdzHIeZkeb+Af8LlGXvEc7ZZZ1W1zyhLAx9UfaAA6zzFqjy378n5Aaky+TsG6glLMmD4z51ojrFt5wTUy/mAuQR5XLaQXldAYjVgEXV0rjUP6tgPnZuhWLsLz7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=KTqFoZvo; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="KTqFoZvo"
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id E0D5920BE590; Fri, 24 May 2024 13:46:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E0D5920BE590
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1716583611;
	bh=vBOMBcwQCO6k4hxnAcXoCQRNIv6CgwhcPskZVNgjbOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTqFoZvo0a8F1mIbNlvZnAmq/0C5EuRRTxz6HPZOGPEcwLZVFFhUs2qrWyAW/GZXQ
	 vFR9GqQs+yvXNVyDgAFVWyruhUs0mOGgyEm/CCT2SEf2fZ/eOEHPFP67+JRPLJ/T+e
	 sqEnIkRhXZbZFcN788bkK8H+ddylfZtndHv7Yg5U=
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
	mpatocka@redhat.com,
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
Subject: [PATCH v19 14/20] security: add security_inode_setintegrity() hook
Date: Fri, 24 May 2024 13:46:43 -0700
Message-Id: <1716583609-21790-15-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1716583609-21790-1-git-send-email-wufan@linux.microsoft.com>
References: <1716583609-21790-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

This patch introduces a new hook to save inode's integrity
data. For example, for fsverity enabled files, LSMs can use this hook to
save the verified fsverity builtin signature into the inode's security
blob, and LSMs can make access decisions based on the data inside
the signature, like the signer certificate.

Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

--
v1-v14:
  + Not present

v15:
  + Introduced

v16:
  + Switch to call_int_hook()

v17:
  + Fix a typo

v18:
  + No changes

v19:
  + Refactor hook declaration
---
 include/linux/lsm_hook_defs.h |  2 ++
 include/linux/security.h      | 10 ++++++++++
 security/security.c           | 20 ++++++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 4f9b43a87ba5..46293ca34091 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -178,6 +178,8 @@ LSM_HOOK(void, LSM_RET_VOID, inode_getsecid, struct inode *inode, u32 *secid)
 LSM_HOOK(int, 0, inode_copy_up, struct dentry *src, struct cred **new)
 LSM_HOOK(int, -EOPNOTSUPP, inode_copy_up_xattr, struct dentry *src,
 	 const char *name)
+LSM_HOOK(int, 0, inode_setintegrity, const struct inode *inode,
+	 enum lsm_integrity_type type, const void *value, size_t size)
 LSM_HOOK(int, 0, kernfs_init_security, struct kernfs_node *kn_dir,
 	 struct kernfs_node *kn)
 LSM_HOOK(int, 0, file_permission, struct file *file, int mask)
diff --git a/include/linux/security.h b/include/linux/security.h
index 09c80326518f..ab489fb02f06 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -410,6 +410,9 @@ int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer
 void security_inode_getsecid(struct inode *inode, u32 *secid);
 int security_inode_copy_up(struct dentry *src, struct cred **new);
 int security_inode_copy_up_xattr(struct dentry *src, const char *name);
+int security_inode_setintegrity(const struct inode *inode,
+				enum lsm_integrity_type type, const void *value,
+				size_t size);
 int security_kernfs_init_security(struct kernfs_node *kn_dir,
 				  struct kernfs_node *kn);
 int security_file_permission(struct file *file, int mask);
@@ -1026,6 +1029,13 @@ static inline int security_inode_copy_up(struct dentry *src, struct cred **new)
 	return 0;
 }
 
+static inline int security_inode_setintegrity(const struct inode *inode,
+					      enum lsm_integrity_type type,
+					      const void *value, size_t size)
+{
+	return 0;
+}
+
 static inline int security_kernfs_init_security(struct kernfs_node *kn_dir,
 						struct kernfs_node *kn)
 {
diff --git a/security/security.c b/security/security.c
index 743652e5e893..f4c7a13c6009 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2682,6 +2682,26 @@ int security_inode_copy_up_xattr(struct dentry *src, const char *name)
 }
 EXPORT_SYMBOL(security_inode_copy_up_xattr);
 
+/**
+ * security_inode_setintegrity() - Set the inode's integrity data
+ * @inode: inode
+ * @type: type of integrity, e.g. hash digest, signature, etc
+ * @value: the integrity value
+ * @size: size of the integrity value
+ *
+ * Register a verified integrity measurement of a inode with LSMs.
+ * LSMs should free the previously saved data if @value is NULL.
+ *
+ * Return: Returns 0 on success, negative values on failure.
+ */
+int security_inode_setintegrity(const struct inode *inode,
+				enum lsm_integrity_type type, const void *value,
+				size_t size)
+{
+	return call_int_hook(inode_setintegrity, inode, type, value, size);
+}
+EXPORT_SYMBOL(security_inode_setintegrity);
+
 /**
  * security_kernfs_init_security() - Init LSM context for a kernfs node
  * @kn_dir: parent kernfs node
-- 
2.44.0

