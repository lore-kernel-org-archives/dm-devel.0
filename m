From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH RESEND v2 05/18] userns: Replace in_userns with
	current_in_userns
Date: Mon,  4 Jan 2016 12:03:44 -0600
Message-ID: <1451930639-94331-6-git-send-email-seth.forshee@canonical.com>
References: <1451930639-94331-1-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1451930639-94331-1-git-send-email-seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

All current callers of in_userns pass current_user_ns as the
first argument. Simplify by replacing in_userns with
current_in_userns which checks whether current_user_ns is in the
namespace supplied as an argument.

Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Acked-by: James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
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


------------------------------------------------------------------------------
