Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 545D6126F1B;
	Fri, 24 May 2024 20:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716583621; cv=none; b=jOJWpY3Fz3Z9Kq3lyUGnFq6VEp5aF1dMQ03cZFxxrSJss8SD7yN0rof07QQ3/Xfg93+wzOJ4Qmf53lpsCqJpfk3UhqE1FV0uxA5GehqwzpVg/SqyeKEp7Yvqq7YQprc7tIo9hTX0QT4ve8mDMQWckOTOalLMXLVRRrLkWo6+gwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716583621; c=relaxed/simple;
	bh=Fq2eXBoN98brwkcsI7+VX7V5LDkdyUiDlKmFeSXJxHg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=aMhFJRc1Jbf4bTBznrW44At5wV3X01vFDk/scXWpry7O6tU91Z2+ipvPEq17FGbJrqDkQOa9siqvsjXPsbz7qAnOTFWffyU9gRKDojdI8nz9vO1Gk4udo5v6N9koHLK3dooKD2rEkdAHCyfF1Ema1IsxL9Cwf8G1AYuS4vj4ACU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=NVZ8ISJH; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="NVZ8ISJH"
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id 81ED820BE54C; Fri, 24 May 2024 13:46:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 81ED820BE54C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1716583611;
	bh=BKTC+ztxrA33DsPI8gbEqQW08WCtPJmpEALZqk2t/Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVZ8ISJHH5IWHAeXypq3pRnkrCMqqs9oLmv0aIaGNCi/zi4Dklx1AuPkNgZy1Zuzx
	 4Y8poyWpBfsB+aBzzgFVEm2pEV6rPYZoXBfvjxAuM4JfyFJCJZLTFQ8EfhlvR3MwAI
	 WMyjFMI2I6DuBJmDUvSKqHrspA5G8+nJxsvpQ3/s=
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
Subject: [PATCH v19 07/20] security: add new securityfs delete function
Date: Fri, 24 May 2024 13:46:36 -0700
Message-Id: <1716583609-21790-8-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1716583609-21790-1-git-send-email-wufan@linux.microsoft.com>
References: <1716583609-21790-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

When deleting a directory in the security file system, the existing
securityfs_remove requires the directory to be empty, otherwise
it will do nothing. This leads to a potential risk that the security
file system might be in an unclean state when the intended deletion
did not happen.

This commit introduces a new function securityfs_recursive_remove
to recursively delete a directory without leaving an unclean state.

Co-developed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

---
v1-v8:
  + Not present

v9:
  + Introduced

v10:
  + No changes

v11:
  + Fix code style issues

v12:
  + No changes

v13:
  + No changes

v14:
  + No changes

v15:
  + No changes

v16:
  + No changes

v17:
  + No changes

v18:
  + No changes

v19:
  + No changes
---
 include/linux/security.h |  1 +
 security/inode.c         | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/security.h b/include/linux/security.h
index 2caa4c9b81ff..78a763eff4eb 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2089,6 +2089,7 @@ struct dentry *securityfs_create_symlink(const char *name,
 					 const char *target,
 					 const struct inode_operations *iops);
 extern void securityfs_remove(struct dentry *dentry);
+extern void securityfs_recursive_remove(struct dentry *dentry);
 
 #else /* CONFIG_SECURITYFS */
 
diff --git a/security/inode.c b/security/inode.c
index 9e7cde913667..f21847badb7d 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -313,6 +313,31 @@ void securityfs_remove(struct dentry *dentry)
 }
 EXPORT_SYMBOL_GPL(securityfs_remove);
 
+static void remove_one(struct dentry *victim)
+{
+	simple_release_fs(&mount, &mount_count);
+}
+
+/**
+ * securityfs_recursive_remove - recursively removes a file or directory
+ *
+ * @dentry: a pointer to a the dentry of the file or directory to be removed.
+ *
+ * This function recursively removes a file or directory in securityfs that was
+ * previously created with a call to another securityfs function (like
+ * securityfs_create_file() or variants thereof.)
+ */
+void securityfs_recursive_remove(struct dentry *dentry)
+{
+	if (IS_ERR_OR_NULL(dentry))
+		return;
+
+	simple_pin_fs(&fs_type, &mount, &mount_count);
+	simple_recursive_removal(dentry, remove_one);
+	simple_release_fs(&mount, &mount_count);
+}
+EXPORT_SYMBOL_GPL(securityfs_recursive_remove);
+
 #ifdef CONFIG_SECURITY
 static struct dentry *lsm_dentry;
 static ssize_t lsm_read(struct file *filp, char __user *buf, size_t count,
-- 
2.44.0

