From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 15/19] capabilities: Allow privileged user in s_user_ns to set file caps
Date: Wed,  2 Dec 2015 09:40:15 -0600
Message-ID: <1449070821-73820-16-git-send-email-seth.forshee@canonical.com>
References: <1449070821-73820-1-git-send-email-seth.forshee@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449070821-73820-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, Seth Forshee <seth.forshee@canonical.com>
List-Id: dm-devel.ids

A privileged user in a super block's s_user_ns is privileged
towards that file system and thus should be allowed to set file
capabilities. The file capabilities will not be trusted outside
of s_user_ns, so an unprivileged user cannot use this to gain
privileges in a user namespace where they are not already
privileged.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 security/commoncap.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 2119421613f6..d6c80c19c449 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -653,15 +653,17 @@ int cap_bprm_secureexec(struct linux_binprm *bprm)
 int cap_inode_setxattr(struct dentry *dentry, const char *name,
 		       const void *value, size_t size, int flags)
 {
+	struct user_namespace *user_ns = dentry->d_sb->s_user_ns;
+
 	if (!strcmp(name, XATTR_NAME_CAPS)) {
-		if (!capable(CAP_SETFCAP))
+		if (!ns_capable(user_ns, CAP_SETFCAP))
 			return -EPERM;
 		return 0;
 	}
 
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
-	    !capable(CAP_SYS_ADMIN))
+	    !ns_capable(user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 	return 0;
 }
@@ -679,15 +681,17 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
  */
 int cap_inode_removexattr(struct dentry *dentry, const char *name)
 {
+	struct user_namespace *user_ns = dentry->d_sb->s_user_ns;
+
 	if (!strcmp(name, XATTR_NAME_CAPS)) {
-		if (!capable(CAP_SETFCAP))
+		if (!ns_capable(user_ns, CAP_SETFCAP))
 			return -EPERM;
 		return 0;
 	}
 
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
-	    !capable(CAP_SYS_ADMIN))
+	    !ns_capable(user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 	return 0;
 }
-- 
1.9.1
