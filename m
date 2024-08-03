Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE59B136354;
	Sat,  3 Aug 2024 06:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722665329; cv=none; b=YvGmS8PvIAUAWEJzHCW92FZspBQ7BPL2cYpfE7gNNmfyPuxabdl9S4rZ3N1kvaBwq/Od87qHUawYk78Qsqyvt0b5nxU4MMw+xeUpfLlbgEl1aVbZQ0Y1wSBMFWZF4ZBKxpW/n3LFfDDrncBfa3QVJ5Tm+kfzQS1NVbYfDX0j5dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722665329; c=relaxed/simple;
	bh=TYFX3tXul0KKXczgy1w50dZueAiwRf54i9UpybMeARg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=c/kilJap3Wmvcnk4xnE3ttdfivWOX4SDglTRaKuHT+iDNsHxFGbYGadvmxzpR1CInPUQP8xI4Ha/rd1cQ3lIjqtDFrUvIa2YYRdeSUrLUC4B0QzTMNKCI6vN2B9Xl9PNM65Uqk4IiFzqPxy7hWhmXhlCs07RrJl6ULmk+gfn5MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=debF4A37; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="debF4A37"
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id 771B720B6F2F; Fri,  2 Aug 2024 23:08:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 771B720B6F2F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1722665320;
	bh=+hm5VoEy2Oa7PLL4I2aIw8P8rfS/DX6dUUD38GHsF6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=debF4A379k0rYhgwbrLPwtEIdqZ9p5efNmmuE2exxTyi16nfdujrtW1KrA54QGJgX
	 ETj38N+ZrBa6IkmKEI/eUCeoihMoRK2kb1/F8bJG4FfN446j73IO0Dq4vGgbmZsPAW
	 jUNaPcQpWCNDZONyE7/M9a0fNcd1HVxzA2omZq6I=
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
Subject: [PATCH v20 07/20] security: add new securityfs delete function
Date: Fri,  2 Aug 2024 23:08:21 -0700
Message-Id: <1722665314-21156-8-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1722665314-21156-1-git-send-email-wufan@linux.microsoft.com>
References: <1722665314-21156-1-git-send-email-wufan@linux.microsoft.com>
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

v20:
  + No changes
---
 include/linux/security.h |  1 +
 security/inode.c         | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/security.h b/include/linux/security.h
index a4ccaf1d7bd5..50fb627503f2 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2090,6 +2090,7 @@ struct dentry *securityfs_create_symlink(const char *name,
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

