Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B50161799F;
	Sat, 16 Mar 2024 03:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710560164; cv=none; b=ObB1DOrkZ9nNnrYz1WNeoo9sA1M8Mpwov/wVqZwlfDgeLhN3u2rh9QEEsOCFRVSbsyTwU8JI9k3ReCcsQVPZoHrMfecMO58IvyfMkQ1KYHYS4lNj2dw0QIL6HCWpMZmjU2hOlD3/9ibU6gCEeYLNwBAgejOZB1dxOwxD6Joc7N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710560164; c=relaxed/simple;
	bh=BHHU7wvU0GqKpQRx06XB0p34Say4ghpWWe3Jz/hiOL0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=BnHHvEXUQhJd7V7kAjcs00OVH11q4G1oHqEwJa3OHV6T7xHdSAGkxgGFivOiD2mitC7hOhd/2cvHGB8/BGnSvJyTHl7OPA/kEi/Fr+NIvNl2qjSsGz8OkUi8kqUStbT6xsiyU1lj4uhh2ZoEF0elzh1UKKjHZxlXfFOTpE79fY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=VmhtGbNR; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="VmhtGbNR"
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id 2052920B74DE; Fri, 15 Mar 2024 20:35:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2052920B74DE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1710560154;
	bh=iM4/1054yOxiNSzxSvLQETyTfgkCu2ikMbtUNs7hwkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VmhtGbNRsuClkQXsLOQmq2aebij4g7UAnzP6RF/MHSBqS79SmvINTLXQpXi/SaRsK
	 SSAnlQYSS8ilfGWZ9SS+vZbWZIbBAiL0zBBK61qZ92to6GmzNMjvLOQWnQxz83fL4F
	 dmyI1UIlb7cQ5/mO+nuqMd5Ox11ZmsamVTDhQ23E=
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
Subject: [RFC PATCH v15 16/21] security: add security_inode_setintegrity() hook
Date: Fri, 15 Mar 2024 20:35:46 -0700
Message-Id: <1710560151-28904-17-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1710560151-28904-1-git-send-email-wufan@linux.microsoft.com>
References: <1710560151-28904-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

This patch introduces a new hook to save inode's integrity
data. For example, for fsverity enabled files, LSMs can use this hook to save
the verified fsverity builtin signature into the inode's security blob,
and LSMs can make access decisions based on the data inside the signature,
like the signer certificate.

Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

--
v1-v14:
  + Not present

v15:
  + Introduced
---
 include/linux/lsm_hook_defs.h |  3 +++
 include/linux/security.h      | 10 ++++++++++
 security/security.c           | 28 ++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 6808ae763913..c88587fc3691 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -177,6 +177,9 @@ LSM_HOOK(int, 0, inode_listsecurity, struct inode *inode, char *buffer,
 LSM_HOOK(void, LSM_RET_VOID, inode_getsecid, struct inode *inode, u32 *secid)
 LSM_HOOK(int, 0, inode_copy_up, struct dentry *src, struct cred **new)
 LSM_HOOK(int, -EOPNOTSUPP, inode_copy_up_xattr, const char *name)
+LSM_HOOK(int, 0, inode_setintegrity, struct inode *inode,
+	 enum lsm_intgr_type type, const void *value, size_t size)
+
 LSM_HOOK(int, 0, kernfs_init_security, struct kernfs_node *kn_dir,
 	 struct kernfs_node *kn)
 LSM_HOOK(int, 0, file_permission, struct file *file, int mask)
diff --git a/include/linux/security.h b/include/linux/security.h
index 60b40b523d57..0885866b261e 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -405,6 +405,9 @@ int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer
 void security_inode_getsecid(struct inode *inode, u32 *secid);
 int security_inode_copy_up(struct dentry *src, struct cred **new);
 int security_inode_copy_up_xattr(const char *name);
+int security_inode_setintegrity(struct inode *inode,
+				enum lsm_intgr_type type, const void *value,
+				size_t size);
 int security_kernfs_init_security(struct kernfs_node *kn_dir,
 				  struct kernfs_node *kn);
 int security_file_permission(struct file *file, int mask);
@@ -1021,6 +1024,13 @@ static inline int security_inode_copy_up(struct dentry *src, struct cred **new)
 	return 0;
 }
 
+static inline int security_inode_setintegrity(struct inode *inode,
+					      enum lsm_intgr_type, type,
+					      const void *value, size_t size)
+{
+	return 0;
+}
+
 static inline int security_kernfs_init_security(struct kernfs_node *kn_dir,
 						struct kernfs_node *kn)
 {
diff --git a/security/security.c b/security/security.c
index 8d88529ac904..c5d426d084ab 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2681,6 +2681,34 @@ int security_inode_copy_up_xattr(const char *name)
 }
 EXPORT_SYMBOL(security_inode_copy_up_xattr);
 
+/**
+ * security_inode_setintegrity() - Set the inode's integrity data
+ * @inode: inode
+ * @type: type of integrity, e.g. hash digest, signature, etc
+ * @value: the integrity value
+ * @size: size of the integrity value
+ *
+ * Register a verified integrity measurement of a inode with the LSM.
+ *
+ * Return: Returns 0 on success, negative values on failure.
+ */
+int security_inode_setintegrity(struct inode *inode,
+				enum lsm_intgr_type type, const void *value,
+				size_t size)
+{
+	int rc = 0;
+	struct security_hook_list *p;
+
+	hlist_for_each_entry(p, &security_hook_heads.inode_setintegrity, list) {
+		rc = p->hook.inode_setintegrity(inode, type, value, size);
+		if (rc)
+			return rc;
+	}
+
+	return LSM_RET_DEFAULT(inode_setintegrity);
+}
+EXPORT_SYMBOL(security_inode_setintegrity);
+
 /**
  * security_kernfs_init_security() - Init LSM context for a kernfs node
  * @kn_dir: parent kernfs node
-- 
2.44.0

