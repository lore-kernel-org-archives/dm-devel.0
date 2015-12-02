From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH 06/19] Smack: Handle labels consistently in
	untrusted mounts
Date: Wed,  2 Dec 2015 09:40:06 -0600
Message-ID: <1449070821-73820-7-git-send-email-seth.forshee@canonical.com>
References: <1449070821-73820-1-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1449070821-73820-1-git-send-email-seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

The SMACK64, SMACK64EXEC, and SMACK64MMAP labels are all handled
differently in untrusted mounts. This is confusing and
potentically problematic. Change this to handle them all the same
way that SMACK64 is currently handled; that is, read the label
from disk and check it at use time. For SMACK64 and SMACK64MMAP
access is denied if the label does not match smk_root. To be
consistent with suid, a SMACK64EXEC label which does not match
smk_root will still allow execution of the file but will not run
with the label supplied in the xattr.

Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Acked-by: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
---
 security/smack/smack_lsm.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 16cac04214e2..0e555f64ded0 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -921,6 +921,7 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
 	struct inode *inode = file_inode(bprm->file);
 	struct task_smack *bsp = bprm->cred->security;
 	struct inode_smack *isp;
+	struct superblock_smack *sbsp;
 	int rc;
 
 	if (bprm->cred_prepared)
@@ -930,6 +931,11 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
 	if (isp->smk_task == NULL || isp->smk_task == bsp->smk_task)
 		return 0;
 
+	sbsp = inode->i_sb->s_security;
+	if ((sbsp->smk_flags & SMK_SB_UNTRUSTED) &&
+	    isp->smk_task != sbsp->smk_root)
+		return 0;
+
 	if (bprm->unsafe & (LSM_UNSAFE_PTRACE | LSM_UNSAFE_PTRACE_CAP)) {
 		struct task_struct *tracer;
 		rc = 0;
@@ -1733,6 +1739,7 @@ static int smack_mmap_file(struct file *file,
 	struct task_smack *tsp;
 	struct smack_known *okp;
 	struct inode_smack *isp;
+	struct superblock_smack *sbsp;
 	int may;
 	int mmay;
 	int tmay;
@@ -1744,6 +1751,10 @@ static int smack_mmap_file(struct file *file,
 	isp = file_inode(file)->i_security;
 	if (isp->smk_mmap == NULL)
 		return 0;
+	sbsp = file_inode(file)->i_sb->s_security;
+	if (sbsp->smk_flags & SMK_SB_UNTRUSTED &&
+	    isp->smk_mmap != sbsp->smk_root)
+		return -EACCES;
 	mkp = isp->smk_mmap;
 
 	tsp = current_security();
@@ -3532,16 +3543,14 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 			if (rc >= 0)
 				transflag = SMK_INODE_TRANSMUTE;
 		}
-		if (!(sbsp->smk_flags & SMK_SB_UNTRUSTED)) {
-			/*
-			 * Don't let the exec or mmap label be "*" or "@".
-			 */
-			skp = smk_fetch(XATTR_NAME_SMACKEXEC, inode, dp);
-			if (IS_ERR(skp) || skp == &smack_known_star ||
-			    skp == &smack_known_web)
-				skp = NULL;
-			isp->smk_task = skp;
-		}
+		/*
+		 * Don't let the exec or mmap label be "*" or "@".
+		 */
+		skp = smk_fetch(XATTR_NAME_SMACKEXEC, inode, dp);
+		if (IS_ERR(skp) || skp == &smack_known_star ||
+		    skp == &smack_known_web)
+			skp = NULL;
+		isp->smk_task = skp;
 
 		skp = smk_fetch(XATTR_NAME_SMACKMMAP, inode, dp);
 		if (IS_ERR(skp) || skp == &smack_known_star ||
-- 
1.9.1


------------------------------------------------------------------------------
Go from Idea to Many App Stores Faster with Intel(R) XDK
Give your users amazing mobile app experiences with Intel(R) XDK.
Use one codebase in this all-in-one HTML5 development environment.
Design, debug & build mobile apps & 2D/3D high-impact games for multiple OSs.
http://pubads.g.doubleclick.net/gampad/clk?id=254741911&iu=/4140
