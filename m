From: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH RESEND v2 11/18] fs: Ensure the mounter of a filesystem
 is privileged towards its inodes
Date: Mon, 28 Mar 2016 11:59:36 -0500
Message-ID: <20160328165936.GC137406@ubuntu-hedt>
References: <1451930639-94331-1-git-send-email-seth.forshee@canonical.com>
 <1451930639-94331-12-git-send-email-seth.forshee@canonical.com>
 <20160303170201.GA30224@ubuntu-hedt>
 <87twkl50g5.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87twkl50g5.fsf@x220.int.ebiederm.org>
Sender: linux-bcache-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
List-Id: dm-devel.ids

On Fri, Mar 04, 2016 at 04:43:06PM -0600, Eric W. Biederman wrote:
> In general this is only an issue if uids and gids on the filesystem
> do not map into the user namespace.
> 
> Therefore the general fix is to limit the logic of checking for
> capabilities in s_user_ns if we are dealing with INVALID_UID and
> INVALID_GID.  For proc and kernfs that should never be the case
> so the problem becomes a non-issue.
> 
> Further I would look at limiting that relaxation to just
> inode_change_ok. 

Finally got around to implementing this today; is the patch below what
you had in mind?

> So that we can easily wrap that check per filesystem
> and deny the relaxation for proc and kernfs.  proc and kernfs already
> have wrappers for .setattr so denying changes when !uid_vaid and
> !gid_valid would be a trivial addition, and ensure calamity does
> not ensure.

I'm confused about this part though. As you say above, proc and kernfs
will never have inodes with invalid ids, so it's not an issue. Do you
just mean this to be extra insurance against problems?

Thanks,
Seth

---

diff --git a/fs/attr.c b/fs/attr.c
index 3cfaaac4a18e..f2bcd3f7dfbb 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -16,6 +16,31 @@
 #include <linux/evm.h>
 #include <linux/ima.h>
 
+static bool chown_ok(const struct inode *inode, kuid_t uid)
+{
+	if (uid_eq(current_fsuid(), inode->i_uid) && uid_eq(uid, inode->i_uid))
+		return true;
+	if (capable_wrt_inode_uidgid(inode, CAP_CHOWN))
+		return true;
+	if (!uid_valid(inode->i_uid) &&
+	    ns_capable(inode->i_sb->s_user_ns, CAP_CHOWN))
+		return true;
+	return false;
+}
+
+static bool chgrp_ok(const struct inode *inode, kgid_t gid)
+{
+	if (uid_eq(current_fsuid(), inode->i_uid) &&
+	    (in_group_p(gid) || gid_eq(gid, inode->i_gid)))
+		return true;
+	if (capable_wrt_inode_uidgid(inode, CAP_CHOWN))
+		return true;
+	if (!gid_valid(inode->i_gid) &&
+	    ns_capable(inode->i_sb->s_user_ns, CAP_CHOWN))
+		return true;
+	return false;
+}
+
 /**
  * inode_change_ok - check if attribute changes to an inode are allowed
  * @inode:	inode to check
@@ -58,17 +83,11 @@ int inode_change_ok(const struct inode *inode, struct iattr *attr)
 		return 0;
 
 	/* Make sure a caller can chown. */
-	if ((ia_valid & ATTR_UID) &&
-	    (!uid_eq(current_fsuid(), inode->i_uid) ||
-	     !uid_eq(attr->ia_uid, inode->i_uid)) &&
-	    !capable_wrt_inode_uidgid(inode, CAP_CHOWN))
+	if ((ia_valid & ATTR_UID) && !chown_ok(inode, attr->ia_uid))
 		return -EPERM;
 
 	/* Make sure caller can chgrp. */
-	if ((ia_valid & ATTR_GID) &&
-	    (!uid_eq(current_fsuid(), inode->i_uid) ||
-	    (!in_group_p(attr->ia_gid) && !gid_eq(attr->ia_gid, inode->i_gid))) &&
-	    !capable_wrt_inode_uidgid(inode, CAP_CHOWN))
+	if ((ia_valid & ATTR_GID) && !chgrp_ok(inode, attr->ia_gid))
 		return -EPERM;
 
 	/* Make sure a caller can chmod. */
