From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH RESEND v2 11/18] fs: Ensure the mounter of a
	filesystem is privileged towards its inodes
Date: Mon,  4 Jan 2016 12:03:50 -0600
Message-ID: <1451930639-94331-12-git-send-email-seth.forshee@canonical.com>
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
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

The mounter of a filesystem should be privileged towards the
inodes of that filesystem. Extend the checks in
inode_owner_or_capable() and capable_wrt_inode_uidgid() to
permit access by users priviliged in the user namespace of the
inode's superblock.

Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 fs/inode.c          |  3 +++
 kernel/capability.c | 13 +++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 1be5f9003eb3..01c036fe1950 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1962,6 +1962,9 @@ bool inode_owner_or_capable(const struct inode *inode)
 	ns = current_user_ns();
 	if (ns_capable(ns, CAP_FOWNER) && kuid_has_mapping(ns, inode->i_uid))
 		return true;
+
+	if (ns_capable(inode->i_sb->s_user_ns, CAP_FOWNER))
+		return true;
 	return false;
 }
 EXPORT_SYMBOL(inode_owner_or_capable);
diff --git a/kernel/capability.c b/kernel/capability.c
index 45432b54d5c6..5137a38a5670 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -437,13 +437,18 @@ EXPORT_SYMBOL(file_ns_capable);
  *
  * Return true if the current task has the given capability targeted at
  * its own user namespace and that the given inode's uid and gid are
- * mapped into the current user namespace.
+ * mapped into the current user namespace, or if the current task has
+ * the capability towards the user namespace of the inode's superblock.
  */
 bool capable_wrt_inode_uidgid(const struct inode *inode, int cap)
 {
-	struct user_namespace *ns = current_user_ns();
+	struct user_namespace *ns;
 
-	return ns_capable(ns, cap) && kuid_has_mapping(ns, inode->i_uid) &&
-		kgid_has_mapping(ns, inode->i_gid);
+	ns = current_user_ns();
+	if (ns_capable(ns, cap) && kuid_has_mapping(ns, inode->i_uid) &&
+	    kgid_has_mapping(ns, inode->i_gid))
+		return true;
+
+	return ns_capable(inode->i_sb->s_user_ns, cap);
 }
 EXPORT_SYMBOL(capable_wrt_inode_uidgid);
-- 
1.9.1


------------------------------------------------------------------------------
