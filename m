From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH RESEND v2 10/18] fs: Update posix_acl support to handle user namespace mounts
Date: Mon,  4 Jan 2016 12:03:49 -0600
Message-ID: <1451930639-94331-11-git-send-email-seth.forshee@canonical.com>
References: <1451930639-94331-1-git-send-email-seth.forshee@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1451930639-94331-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, Seth Forshee <seth.forshee@canonical.com>
List-Id: dm-devel.ids

ids in on-disk ACLs should be converted to s_user_ns instead of
init_user_ns as is done now. This introduces the possibility for
id mappings to fail, and when this happens syscalls will return
EOVERFLOW.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
---
 fs/posix_acl.c                  | 67 ++++++++++++++++++++++++++---------------
 fs/xattr.c                      | 19 +++++++++---
 include/linux/posix_acl_xattr.h | 17 ++++++++---
 3 files changed, 70 insertions(+), 33 deletions(-)

diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 4adde1e2cbec..a29442eb4af8 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -595,59 +595,77 @@ EXPORT_SYMBOL_GPL(posix_acl_create);
 /*
  * Fix up the uids and gids in posix acl extended attributes in place.
  */
-static void posix_acl_fix_xattr_userns(
+static int posix_acl_fix_xattr_userns(
 	struct user_namespace *to, struct user_namespace *from,
 	void *value, size_t size)
 {
 	posix_acl_xattr_header *header = (posix_acl_xattr_header *)value;
 	posix_acl_xattr_entry *entry = (posix_acl_xattr_entry *)(header+1), *end;
 	int count;
-	kuid_t uid;
-	kgid_t gid;
+	kuid_t kuid;
+	uid_t uid;
+	kgid_t kgid;
+	gid_t gid;
 
 	if (!value)
-		return;
+		return 0;
 	if (size < sizeof(posix_acl_xattr_header))
-		return;
+		return 0;
 	if (header->a_version != cpu_to_le32(POSIX_ACL_XATTR_VERSION))
-		return;
+		return 0;
 
 	count = posix_acl_xattr_count(size);
 	if (count < 0)
-		return;
+		return 0;
 	if (count == 0)
-		return;
+		return 0;
 
 	for (end = entry + count; entry != end; entry++) {
 		switch(le16_to_cpu(entry->e_tag)) {
 		case ACL_USER:
-			uid = make_kuid(from, le32_to_cpu(entry->e_id));
-			entry->e_id = cpu_to_le32(from_kuid(to, uid));
+			kuid = make_kuid(from, le32_to_cpu(entry->e_id));
+			if (!uid_valid(kuid))
+				return -EOVERFLOW;
+			uid = from_kuid(to, kuid);
+			if (uid == (uid_t)-1)
+				return -EOVERFLOW;
+			entry->e_id = cpu_to_le32(uid);
 			break;
 		case ACL_GROUP:
-			gid = make_kgid(from, le32_to_cpu(entry->e_id));
-			entry->e_id = cpu_to_le32(from_kgid(to, gid));
+			kgid = make_kgid(from, le32_to_cpu(entry->e_id));
+			if (!gid_valid(kgid))
+				return -EOVERFLOW;
+			gid = from_kgid(to, kgid);
+			if (gid == (gid_t)-1)
+				return -EOVERFLOW;
+			entry->e_id = cpu_to_le32(gid);
 			break;
 		default:
 			break;
 		}
 	}
+
+	return 0;
 }
 
-void posix_acl_fix_xattr_from_user(void *value, size_t size)
+int
+posix_acl_fix_xattr_from_user(struct user_namespace *target_ns, void *value,
+			      size_t size)
 {
-	struct user_namespace *user_ns = current_user_ns();
-	if (user_ns == &init_user_ns)
-		return;
-	posix_acl_fix_xattr_userns(&init_user_ns, user_ns, value, size);
+	struct user_namespace *source_ns = current_user_ns();
+	if (source_ns == target_ns)
+		return 0;
+	return posix_acl_fix_xattr_userns(target_ns, source_ns, value, size);
 }
 
-void posix_acl_fix_xattr_to_user(void *value, size_t size)
+int
+posix_acl_fix_xattr_to_user(struct user_namespace *source_ns, void *value,
+			    size_t size)
 {
-	struct user_namespace *user_ns = current_user_ns();
-	if (user_ns == &init_user_ns)
-		return;
-	posix_acl_fix_xattr_userns(user_ns, &init_user_ns, value, size);
+	struct user_namespace *target_ns = current_user_ns();
+	if (target_ns == source_ns)
+		return 0;
+	return posix_acl_fix_xattr_userns(target_ns, source_ns, value, size);
 }
 
 /*
@@ -782,7 +800,7 @@ posix_acl_xattr_get(const struct xattr_handler *handler,
 	if (acl == NULL)
 		return -ENODATA;
 
-	error = posix_acl_to_xattr(&init_user_ns, acl, value, size);
+	error = posix_acl_to_xattr(dentry->d_sb->s_user_ns, acl, value, size);
 	posix_acl_release(acl);
 
 	return error;
@@ -810,7 +828,8 @@ posix_acl_xattr_set(const struct xattr_handler *handler,
 		return -EPERM;
 
 	if (value) {
-		acl = posix_acl_from_xattr(&init_user_ns, value, size);
+		acl = posix_acl_from_xattr(dentry->d_sb->s_user_ns, value,
+					   size);
 		if (IS_ERR(acl))
 			return PTR_ERR(acl);
 
diff --git a/fs/xattr.c b/fs/xattr.c
index 9b932b95d74e..1268d8d5f74b 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -351,8 +351,12 @@ setxattr(struct dentry *d, const char __user *name, const void __user *value,
 			goto out;
 		}
 		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
-		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
-			posix_acl_fix_xattr_from_user(kvalue, size);
+		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0)) {
+			error = posix_acl_fix_xattr_from_user(d->d_sb->s_user_ns,
+							      kvalue, size);
+			if (error)
+				goto out;
+		}
 	}
 
 	error = vfs_setxattr(d, kname, kvalue, size, flags);
@@ -452,9 +456,14 @@ getxattr(struct dentry *d, const char __user *name, void __user *value,
 	error = vfs_getxattr(d, kname, kvalue, size);
 	if (error > 0) {
 		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
-		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
-			posix_acl_fix_xattr_to_user(kvalue, size);
-		if (size && copy_to_user(value, kvalue, error))
+		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0)) {
+			int ret;
+			ret = posix_acl_fix_xattr_to_user(d->d_sb->s_user_ns,
+							  kvalue, size);
+			if (ret)
+				error = ret;
+		}
+		if (error > 0 && size && copy_to_user(value, kvalue, error))
 			error = -EFAULT;
 	} else if (error == -ERANGE && size >= XATTR_SIZE_MAX) {
 		/* The file system tried to returned a value bigger
diff --git a/include/linux/posix_acl_xattr.h b/include/linux/posix_acl_xattr.h
index 6f14ee295822..db63c57357b4 100644
--- a/include/linux/posix_acl_xattr.h
+++ b/include/linux/posix_acl_xattr.h
@@ -53,14 +53,23 @@ posix_acl_xattr_count(size_t size)
 }
 
 #ifdef CONFIG_FS_POSIX_ACL
-void posix_acl_fix_xattr_from_user(void *value, size_t size);
-void posix_acl_fix_xattr_to_user(void *value, size_t size);
+int posix_acl_fix_xattr_from_user(struct user_namespace *target_ns,
+				  void *value, size_t size);
+int posix_acl_fix_xattr_to_user(struct user_namespace *source_ns, void *value,
+				size_t size);
 #else
-static inline void posix_acl_fix_xattr_from_user(void *value, size_t size)
+static inline int
+posix_acl_fix_xattr_from_user(struct user_namespace *target_ns, void *value,
+			      size_t size)
 {
+	return 0;
 }
-static inline void posix_acl_fix_xattr_to_user(void *value, size_t size)
+
+static inline int
+posix_acl_fix_xattr_to_user(struct user_namespace *source_ns, void *value,
+			    size_t size)
 {
+	return 0;
 }
 #endif
 
-- 
1.9.1
