From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH v2 07/18] fs: Check for invalid i_uid in
	may_follow_link()
Date: Mon,  7 Dec 2015 15:21:16 -0600
Message-ID: <1449523289-144238-8-git-send-email-seth.forshee@canonical.com>
References: <1449523289-144238-1-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1449523289-144238-1-git-send-email-seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

Filesystem uids which don't map into a user namespace may result
in inode->i_uid being INVALID_UID. A symlink and its parent
could have different owners in the filesystem can both get
mapped to INVALID_UID, which may result in following a symlink
when this would not have otherwise been permitted when protected
symlinks are enabled.

Add a new helper function, uid_valid_eq(), and use this to
validate that the ids in may_follow_link() are both equal and
valid. Also add an equivalent helper for gids, which is
currently unused.

Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 fs/namei.c             |  2 +-
 include/linux/uidgid.h | 10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 288e8a74bf88..4ccafd391697 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -902,7 +902,7 @@ static inline int may_follow_link(struct nameidata *nd)
 		return 0;
 
 	/* Allowed if parent directory and link owner match. */
-	if (uid_eq(parent->i_uid, inode->i_uid))
+	if (uid_valid_eq(parent->i_uid, inode->i_uid))
 		return 0;
 
 	if (nd->flags & LOOKUP_RCU)
diff --git a/include/linux/uidgid.h b/include/linux/uidgid.h
index 03835522dfcb..e09529fe2668 100644
--- a/include/linux/uidgid.h
+++ b/include/linux/uidgid.h
@@ -117,6 +117,16 @@ static inline bool gid_valid(kgid_t gid)
 	return __kgid_val(gid) != (gid_t) -1;
 }
 
+static inline bool uid_valid_eq(kuid_t left, kuid_t right)
+{
+	return uid_eq(left, right) && uid_valid(left);
+}
+
+static inline bool gid_valid_eq(kgid_t left, kgid_t right)
+{
+	return gid_eq(left, right) && gid_valid(left);
+}
+
 #ifdef CONFIG_USER_NS
 
 extern kuid_t make_kuid(struct user_namespace *from, uid_t uid);
-- 
1.9.1


------------------------------------------------------------------------------
Go from Idea to Many App Stores Faster with Intel(R) XDK
Give your users amazing mobile app experiences with Intel(R) XDK.
Use one codebase in this all-in-one HTML5 development environment.
Design, debug & build mobile apps & 2D/3D high-impact games for multiple OSs.
http://pubads.g.doubleclick.net/gampad/clk?id=254741911&iu=/4140
