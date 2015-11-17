From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v3 6/7] userns: Replace in_userns with current_in_userns
Date: Tue, 17 Nov 2015 10:39:09 -0600
Message-ID: <1447778351-118699-7-git-send-email-seth.forshee@canonical.com>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, Seth Forshee <seth.forshee@canonical.com>
List-Id: dm-devel.ids

All current callers of in_userns pass current_user_ns as the
first argument. Simplify by replacing in_userns with
current_in_userns which checks whether current_user_ns is in the
namespace supplied as an argument.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 fs/namespace.c                 | 2 +-
 include/linux/user_namespace.h | 6 ++----
 kernel/user_namespace.c        | 6 +++---
 security/commoncap.c           | 2 +-
 4 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 2101ce7b96ab..18fc58760aec 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3286,7 +3286,7 @@ bool mnt_may_suid(struct vfsmount *mnt)
 	 * in other namespaces.
 	 */
 	return !(mnt->mnt_flags & MNT_NOSUID) && check_mnt(real_mount(mnt)) &&
-	       in_userns(current_user_ns(), mnt->mnt_sb->s_user_ns);
+	       current_in_userns(mnt->mnt_sb->s_user_ns);
 }
 
 static struct ns_common *mntns_get(struct task_struct *task)
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index a43faa727124..9217169c64cb 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -72,8 +72,7 @@ extern ssize_t proc_projid_map_write(struct file *, const char __user *, size_t,
 extern ssize_t proc_setgroups_write(struct file *, const char __user *, size_t, loff_t *);
 extern int proc_setgroups_show(struct seq_file *m, void *v);
 extern bool userns_may_setgroups(const struct user_namespace *ns);
-extern bool in_userns(const struct user_namespace *ns,
-		      const struct user_namespace *target_ns);
+extern bool current_in_userns(const struct user_namespace *target_ns);
 #else
 
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
@@ -103,8 +102,7 @@ static inline bool userns_may_setgroups(const struct user_namespace *ns)
 	return true;
 }
 
-static inline bool in_userns(const struct user_namespace *ns,
-			     const struct user_namespace *target_ns)
+static inline bool current_in_userns(const struct user_namespace *target_ns)
 {
 	return true;
 }
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 69fbc377357b..5960edc7e644 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -949,10 +949,10 @@ bool userns_may_setgroups(const struct user_namespace *ns)
  * Returns true if @ns is the same namespace as or a descendant of
  * @target_ns.
  */
-bool in_userns(const struct user_namespace *ns,
-	       const struct user_namespace *target_ns)
+bool current_in_userns(const struct user_namespace *target_ns)
 {
-	for (; ns; ns = ns->parent) {
+	struct user_namespace *ns;
+	for (ns = current_user_ns(); ns; ns = ns->parent) {
 		if (ns == target_ns)
 			return true;
 	}
diff --git a/security/commoncap.c b/security/commoncap.c
index 6243aef5860e..2119421613f6 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -450,7 +450,7 @@ static int get_file_caps(struct linux_binprm *bprm, bool *effective, bool *has_c
 
 	if (!mnt_may_suid(bprm->file->f_path.mnt))
 		return 0;
-	if (!in_userns(current_user_ns(), bprm->file->f_path.mnt->mnt_sb->s_user_ns))
+	if (!current_in_userns(bprm->file->f_path.mnt->mnt_sb->s_user_ns))
 		return 0;
 
 	rc = get_vfs_caps_from_disk(bprm->file->f_path.dentry, &vcaps);
-- 
1.9.1
