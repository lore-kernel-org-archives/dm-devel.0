From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 2/5] fs: Treat foreign mounts as nosuid
Date: Wed, 30 Sep 2015 15:15:11 -0500
Message-ID: <1443644116-41366-3-git-send-email-seth.forshee@canonical.com>
References: <1443644116-41366-1-git-send-email-seth.forshee@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443644116-41366-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
List-Id: dm-devel.ids

From: Andy Lutomirski <luto@amacapital.net>

If a process gets access to a mount from a different user
namespace, that process should not be able to take advantage of
setuid files or selinux entrypoints from that filesystem.  Prevent
this by treating mounts from other mount namespaces and those not
owned by current_user_ns() or an ancestor as nosuid.

This will make it safer to allow more complex filesystems to be
mounted in non-root user namespaces.

This does not remove the need for MNT_LOCK_NOSUID.  The setuid,
setgid, and file capability bits can no longer be abused if code in
a user namespace were to clear nosuid on an untrusted filesystem,
but this patch, by itself, is insufficient to protect the system
from abuse of files that, when execed, would increase MAC privilege.

As a more concrete explanation, any task that can manipulate a
vfsmount associated with a given user namespace already has
capabilities in that namespace and all of its descendents.  If they
can cause a malicious setuid, setgid, or file-caps executable to
appear in that mount, then that executable will only allow them to
elevate privileges in exactly the set of namespaces in which they
are already privileges.

On the other hand, if they can cause a malicious executable to
appear with a dangerous MAC label, running it could change the
caller's security context in a way that should not have been
possible, even inside the namespace in which the task is confined.

As a hardening measure, this would have made CVE-2014-5207 much
more difficult to exploit.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 fs/exec.c                |  2 +-
 fs/namespace.c           | 13 +++++++++++++
 include/linux/mount.h    |  1 +
 security/commoncap.c     |  2 +-
 security/selinux/hooks.c |  2 +-
 5 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index b06623a9347f..ea7311d72cc3 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1295,7 +1295,7 @@ static void bprm_fill_uid(struct linux_binprm *bprm)
 	bprm->cred->euid = current_euid();
 	bprm->cred->egid = current_egid();
 
-	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
+	if (!mnt_may_suid(bprm->file->f_path.mnt))
 		return;
 
 	if (task_no_new_privs(current))
diff --git a/fs/namespace.c b/fs/namespace.c
index da70f7c4ece1..2101ce7b96ab 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3276,6 +3276,19 @@ found:
 	return visible;
 }
 
+bool mnt_may_suid(struct vfsmount *mnt)
+{
+	/*
+	 * Foreign mounts (accessed via fchdir or through /proc
+	 * symlinks) are always treated as if they are nosuid.  This
+	 * prevents namespaces from trusting potentially unsafe
+	 * suid/sgid bits, file caps, or security labels that originate
+	 * in other namespaces.
+	 */
+	return !(mnt->mnt_flags & MNT_NOSUID) && check_mnt(real_mount(mnt)) &&
+	       in_userns(current_user_ns(), mnt->mnt_sb->s_user_ns);
+}
+
 static struct ns_common *mntns_get(struct task_struct *task)
 {
 	struct ns_common *ns = NULL;
diff --git a/include/linux/mount.h b/include/linux/mount.h
index f822c3c11377..54a594d49733 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -81,6 +81,7 @@ extern void mntput(struct vfsmount *mnt);
 extern struct vfsmount *mntget(struct vfsmount *mnt);
 extern struct vfsmount *mnt_clone_internal(struct path *path);
 extern int __mnt_is_readonly(struct vfsmount *mnt);
+extern bool mnt_may_suid(struct vfsmount *mnt);
 
 struct path;
 extern struct vfsmount *clone_private_mount(struct path *path);
diff --git a/security/commoncap.c b/security/commoncap.c
index 400aa224b491..6243aef5860e 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -448,7 +448,7 @@ static int get_file_caps(struct linux_binprm *bprm, bool *effective, bool *has_c
 	if (!file_caps_enabled)
 		return 0;
 
-	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
+	if (!mnt_may_suid(bprm->file->f_path.mnt))
 		return 0;
 	if (!in_userns(current_user_ns(), bprm->file->f_path.mnt->mnt_sb->s_user_ns))
 		return 0;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e4369d86e588..de05207eb665 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2171,7 +2171,7 @@ static int check_nnp_nosuid(const struct linux_binprm *bprm,
 			    const struct task_security_struct *new_tsec)
 {
 	int nnp = (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS);
-	int nosuid = (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID);
+	int nosuid = !mnt_may_suid(bprm->file->f_path.mnt);
 	int rc;
 
 	if (!nnp && !nosuid)
-- 
1.9.1
