From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH 17/19] fuse: Support fuse filesystems outside
	of init_user_ns
Date: Wed,  2 Dec 2015 09:40:17 -0600
Message-ID: <1449070821-73820-18-git-send-email-seth.forshee@canonical.com>
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
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

Update fuse to translate uids and gids to/from the user namspace
of the process servicing requests on /dev/fuse. Any ids which do
not map into the namespace will result in errors. inodes will
also be marked bad when unmappable ids are received from the
userspace fuse process.

Currently no use cases are known for letting the userspace fuse
daemon switch namespaces after opening /dev/fuse. Given this
fact, and in order to keep the implementation as simple as
possible and ease security auditing, the user namespace from
which /dev/fuse is opened is used for all id translations. This
is required to be the same namespace as s_user_ns to maintain
behavior consistent with other filesystems which can be mounted
in user namespaces.

For cuse the namespace used for the connection is also simply
current_user_ns() at the time /dev/cuse is opened.

Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 fs/fuse/cuse.c   |  3 +-
 fs/fuse/dev.c    | 13 +++++----
 fs/fuse/dir.c    | 81 ++++++++++++++++++++++++++++++++++-------------------
 fs/fuse/fuse_i.h | 14 ++++++----
 fs/fuse/inode.c  | 85 ++++++++++++++++++++++++++++++++++++++++++--------------
 5 files changed, 136 insertions(+), 60 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index eae2c11268bc..a10aca57bfe4 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -48,6 +48,7 @@
 #include <linux/stat.h>
 #include <linux/module.h>
 #include <linux/uio.h>
+#include <linux/user_namespace.h>
 
 #include "fuse_i.h"
 
@@ -498,7 +499,7 @@ static int cuse_channel_open(struct inode *inode, struct file *file)
 	if (!cc)
 		return -ENOMEM;
 
-	fuse_conn_init(&cc->fc);
+	fuse_conn_init(&cc->fc, current_user_ns());
 
 	fud = fuse_dev_alloc(&cc->fc);
 	if (!fud) {
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index a4f6f30d6d86..11b4cb0a0e2f 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -127,8 +127,8 @@ static void __fuse_put_request(struct fuse_req *req)
 
 static void fuse_req_init_context(struct fuse_conn *fc, struct fuse_req *req)
 {
-	req->in.h.uid = from_kuid_munged(&init_user_ns, current_fsuid());
-	req->in.h.gid = from_kgid_munged(&init_user_ns, current_fsgid());
+	req->in.h.uid = from_kuid(fc->user_ns, current_fsuid());
+	req->in.h.gid = from_kgid(fc->user_ns, current_fsgid());
 	req->in.h.pid = pid_nr_ns(task_pid(current), fc->pid_ns);
 }
 
@@ -186,7 +186,8 @@ static struct fuse_req *__fuse_get_req(struct fuse_conn *fc, unsigned npages,
 	__set_bit(FR_WAITING, &req->flags);
 	if (for_background)
 		__set_bit(FR_BACKGROUND, &req->flags);
-	if (req->in.h.pid == 0) {
+	if (req->in.h.pid == 0 || req->in.h.uid == (uid_t)-1 ||
+	    req->in.h.gid == (gid_t)-1) {
 		fuse_put_request(fc, req);
 		return ERR_PTR(-EOVERFLOW);
 	}
@@ -1248,7 +1249,8 @@ static ssize_t fuse_dev_do_read(struct fuse_dev *fud, struct file *file,
 	struct fuse_in *in;
 	unsigned reqsize;
 
-	if (task_active_pid_ns(current) != fc->pid_ns)
+	if (task_active_pid_ns(current) != fc->pid_ns ||
+	    current_user_ns() != fc->user_ns)
 		return -EIO;
 
  restart:
@@ -1880,7 +1882,8 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	struct fuse_req *req;
 	struct fuse_out_header oh;
 
-	if (task_active_pid_ns(current) != fc->pid_ns)
+	if (task_active_pid_ns(current) != fc->pid_ns ||
+	    current_user_ns() != fc->user_ns)
 		return -EIO;
 
 	if (nbytes < sizeof(struct fuse_out_header))
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 5e2e08712d3b..f67f4dd86b36 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -243,9 +243,12 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 		if (ret || (outarg.attr.mode ^ inode->i_mode) & S_IFMT)
 			goto invalid;
 
-		fuse_change_attributes(inode, &outarg.attr,
-				       entry_attr_timeout(&outarg),
-				       attr_version);
+		ret = fuse_change_attributes(inode, &outarg.attr,
+					     entry_attr_timeout(&outarg),
+					     attr_version);
+		if (ret)
+			goto invalid;
+
 		fuse_change_entry_timeout(entry, &outarg);
 	} else if (inode) {
 		fi = get_fuse_inode(inode);
@@ -319,8 +322,9 @@ int fuse_lookup_name(struct super_block *sb, u64 nodeid, struct qstr *name,
 	*inode = fuse_iget(sb, outarg->nodeid, outarg->generation,
 			   &outarg->attr, entry_attr_timeout(outarg),
 			   attr_version);
-	err = -ENOMEM;
-	if (!*inode) {
+	if (IS_ERR(*inode)) {
+		err = PTR_ERR(*inode);
+		*inode = NULL;
 		fuse_queue_forget(fc, forget, outarg->nodeid, 1);
 		goto out;
 	}
@@ -441,11 +445,11 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	ff->open_flags = outopen.open_flags;
 	inode = fuse_iget(dir->i_sb, outentry.nodeid, outentry.generation,
 			  &outentry.attr, entry_attr_timeout(&outentry), 0);
-	if (!inode) {
+	if (IS_ERR(inode)) {
 		flags &= ~(O_CREAT | O_EXCL | O_TRUNC);
 		fuse_sync_release(ff, flags);
 		fuse_queue_forget(fc, forget, outentry.nodeid, 1);
-		err = -ENOMEM;
+		err = PTR_ERR(inode);
 		goto out_err;
 	}
 	kfree(forget);
@@ -547,9 +551,9 @@ static int create_new_entry(struct fuse_conn *fc, struct fuse_args *args,
 
 	inode = fuse_iget(dir->i_sb, outarg.nodeid, outarg.generation,
 			  &outarg.attr, entry_attr_timeout(&outarg), 0);
-	if (!inode) {
+	if (IS_ERR(inode)) {
 		fuse_queue_forget(fc, forget, outarg.nodeid, 1);
-		return -ENOMEM;
+		return PTR_ERR(inode);
 	}
 	kfree(forget);
 
@@ -841,8 +845,8 @@ static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
 	stat->ino = attr->ino;
 	stat->mode = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
 	stat->nlink = attr->nlink;
-	stat->uid = make_kuid(&init_user_ns, attr->uid);
-	stat->gid = make_kgid(&init_user_ns, attr->gid);
+	stat->uid = inode->i_uid;
+	stat->gid = inode->i_gid;
 	stat->rdev = inode->i_rdev;
 	stat->atime.tv_sec = attr->atime;
 	stat->atime.tv_nsec = attr->atimensec;
@@ -896,10 +900,10 @@ static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
 			make_bad_inode(inode);
 			err = -EIO;
 		} else {
-			fuse_change_attributes(inode, &outarg.attr,
-					       attr_timeout(&outarg),
-					       attr_version);
-			if (stat)
+			err = fuse_change_attributes(inode, &outarg.attr,
+						     attr_timeout(&outarg),
+						     attr_version);
+			if (!err && stat)
 				fuse_fillattr(inode, &outarg.attr, stat);
 		}
 	}
@@ -1221,9 +1225,11 @@ static int fuse_direntplus_link(struct file *file,
 			fi->nlookup++;
 			spin_unlock(&fc->lock);
 
-			fuse_change_attributes(inode, &o->attr,
-					       entry_attr_timeout(o),
-					       attr_version);
+			err = fuse_change_attributes(inode, &o->attr,
+						     entry_attr_timeout(o),
+						     attr_version);
+			if (err)
+				goto out;
 
 			/*
 			 * The other branch to 'found' comes via fuse_iget()
@@ -1241,8 +1247,10 @@ static int fuse_direntplus_link(struct file *file,
 
 	inode = fuse_iget(dir->i_sb, o->nodeid, o->generation,
 			  &o->attr, entry_attr_timeout(o), attr_version);
-	if (!inode)
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
 		goto out;
+	}
 
 	alias = d_splice_alias(inode, dentry);
 	err = PTR_ERR(alias);
@@ -1455,17 +1463,25 @@ static bool update_mtime(unsigned ivalid, bool trust_local_mtime)
 	return true;
 }
 
-static void iattr_to_fattr(struct iattr *iattr, struct fuse_setattr_in *arg,
-			   bool trust_local_cmtime)
+static int iattr_to_fattr(struct fuse_conn *fc, struct iattr *iattr,
+			   struct fuse_setattr_in *arg, bool trust_local_cmtime)
 {
 	unsigned ivalid = iattr->ia_valid;
 
 	if (ivalid & ATTR_MODE)
 		arg->valid |= FATTR_MODE,   arg->mode = iattr->ia_mode;
-	if (ivalid & ATTR_UID)
-		arg->valid |= FATTR_UID,    arg->uid = from_kuid(&init_user_ns, iattr->ia_uid);
-	if (ivalid & ATTR_GID)
-		arg->valid |= FATTR_GID,    arg->gid = from_kgid(&init_user_ns, iattr->ia_gid);
+	if (ivalid & ATTR_UID) {
+		arg->uid = from_kuid(fc->user_ns, iattr->ia_uid);
+		if (arg->uid == (uid_t)-1)
+			return -EINVAL;
+		arg->valid |= FATTR_UID;
+	}
+	if (ivalid & ATTR_GID) {
+		arg->gid = from_kgid(fc->user_ns, iattr->ia_gid);
+		if (arg->gid == (gid_t)-1)
+			return -EINVAL;
+		arg->valid |= FATTR_GID;
+	}
 	if (ivalid & ATTR_SIZE)
 		arg->valid |= FATTR_SIZE,   arg->size = iattr->ia_size;
 	if (ivalid & ATTR_ATIME) {
@@ -1487,6 +1503,8 @@ static void iattr_to_fattr(struct iattr *iattr, struct fuse_setattr_in *arg,
 		arg->ctime = iattr->ia_ctime.tv_sec;
 		arg->ctimensec = iattr->ia_ctime.tv_nsec;
 	}
+
+	return 0;
 }
 
 /*
@@ -1625,7 +1643,9 @@ int fuse_do_setattr(struct inode *inode, struct iattr *attr,
 
 	memset(&inarg, 0, sizeof(inarg));
 	memset(&outarg, 0, sizeof(outarg));
-	iattr_to_fattr(attr, &inarg, trust_local_cmtime);
+	err = iattr_to_fattr(fc, attr, &inarg, trust_local_cmtime);
+	if (err)
+		goto error;
 	if (file) {
 		struct fuse_file *ff = file->private_data;
 		inarg.valid |= FATTR_FH;
@@ -1660,8 +1680,13 @@ int fuse_do_setattr(struct inode *inode, struct iattr *attr,
 		/* FIXME: clear I_DIRTY_SYNC? */
 	}
 
-	fuse_change_attributes_common(inode, &outarg.attr,
-				      attr_timeout(&outarg));
+	err = fuse_change_attributes_common(inode, &outarg.attr,
+				            attr_timeout(&outarg));
+	if (err) {
+		spin_unlock(&fc->lock);
+		goto error;
+	}
+
 	oldsize = inode->i_size;
 	/* see the comment in fuse_change_attributes() */
 	if (!is_wb || is_truncate || !S_ISREG(inode->i_mode))
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 143b595197b6..98c669ccfe7f 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -23,6 +23,7 @@
 #include <linux/poll.h>
 #include <linux/workqueue.h>
 #include <linux/pid_namespace.h>
+#include <linux/user_namespace.h>
 
 /** Max number of pages that can be used in a single read request */
 #define FUSE_MAX_PAGES_PER_REQ 32
@@ -460,6 +461,9 @@ struct fuse_conn {
 	/** The pid namespace for this mount */
 	struct pid_namespace *pid_ns;
 
+	/** The user namespace for this mount */
+	struct user_namespace *user_ns;
+
 	/** The fuse mount flags for this mount */
 	unsigned flags;
 
@@ -761,11 +765,11 @@ void fuse_init_symlink(struct inode *inode);
 /**
  * Change attributes of an inode
  */
-void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
-			    u64 attr_valid, u64 attr_version);
+int fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
+			   u64 attr_valid, u64 attr_version);
 
-void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
-				   u64 attr_valid);
+int fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
+				  u64 attr_valid);
 
 /**
  * Initialize the client device
@@ -855,7 +859,7 @@ struct fuse_conn *fuse_conn_get(struct fuse_conn *fc);
 /**
  * Initialize fuse_conn
  */
-void fuse_conn_init(struct fuse_conn *fc);
+void fuse_conn_init(struct fuse_conn *fc, struct user_namespace *user_ns);
 
 /**
  * Release reference to fuse_conn
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 2f31874ea9db..ea61a7639a8e 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -155,11 +155,22 @@ static ino_t fuse_squash_ino(u64 ino64)
 	return ino;
 }
 
-void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
-				   u64 attr_valid)
+int fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
+				  u64 attr_valid)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
+	kuid_t uid;
+	kgid_t gid;
+
+	uid = make_kuid(fc->user_ns, attr->uid);
+	gid = make_kgid(fc->user_ns, attr->gid);
+	if (!uid_valid(uid) || !gid_valid(gid)) {
+		make_bad_inode(inode);
+		return -EIO;
+	}
+	inode->i_uid = uid;
+	inode->i_gid = gid;
 
 	fi->attr_version = ++fc->attr_version;
 	fi->i_time = attr_valid;
@@ -167,8 +178,6 @@ void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
 	inode->i_ino     = fuse_squash_ino(attr->ino);
 	inode->i_mode    = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
 	set_nlink(inode, attr->nlink);
-	inode->i_uid     = make_kuid(&init_user_ns, attr->uid);
-	inode->i_gid     = make_kgid(&init_user_ns, attr->gid);
 	inode->i_blocks  = attr->blocks;
 	inode->i_atime.tv_sec   = attr->atime;
 	inode->i_atime.tv_nsec  = attr->atimensec;
@@ -195,26 +204,32 @@ void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
 		inode->i_mode &= ~S_ISVTX;
 
 	fi->orig_ino = attr->ino;
+	return 0;
 }
 
-void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
-			    u64 attr_valid, u64 attr_version)
+int fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
+			   u64 attr_valid, u64 attr_version)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	bool is_wb = fc->writeback_cache;
 	loff_t oldsize;
 	struct timespec old_mtime;
+	int err;
 
 	spin_lock(&fc->lock);
 	if ((attr_version != 0 && fi->attr_version > attr_version) ||
 	    test_bit(FUSE_I_SIZE_UNSTABLE, &fi->state)) {
 		spin_unlock(&fc->lock);
-		return;
+		return 0;
 	}
 
 	old_mtime = inode->i_mtime;
-	fuse_change_attributes_common(inode, attr, attr_valid);
+	err = fuse_change_attributes_common(inode, attr, attr_valid);
+	if (err) {
+		spin_unlock(&fc->lock);
+		return err;
+	}
 
 	oldsize = inode->i_size;
 	/*
@@ -249,6 +264,8 @@ void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
 		if (inval)
 			invalidate_inode_pages2(inode->i_mapping);
 	}
+
+	return 0;
 }
 
 static void fuse_init_inode(struct inode *inode, struct fuse_attr *attr)
@@ -302,7 +319,7 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
  retry:
 	inode = iget5_locked(sb, nodeid, fuse_inode_eq, fuse_inode_set, &nodeid);
 	if (!inode)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	if ((inode->i_state & I_NEW)) {
 		inode->i_flags |= S_NOATIME;
@@ -318,11 +335,23 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 		goto retry;
 	}
 
+	/*
+	 * Must do this before incrementing nlookup, as the caller will
+	 * send a forget for the node if this function fails.
+	 */
+	if (fuse_change_attributes(inode, attr, attr_valid, attr_version)) {
+		/*
+		 * inode_make_bad() already called by
+		 * fuse_change_attributes()
+		 */
+		iput(inode);
+		return ERR_PTR(-EIO);
+	}
+
 	fi = get_fuse_inode(inode);
 	spin_lock(&fc->lock);
 	fi->nlookup++;
 	spin_unlock(&fc->lock);
-	fuse_change_attributes(inode, attr, attr_valid, attr_version);
 
 	return inode;
 }
@@ -467,12 +496,15 @@ static int fuse_match_uint(substring_t *s, unsigned int *res)
 	return err;
 }
 
-static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
+static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev,
+			  struct user_namespace *user_ns)
 {
 	char *p;
 	memset(d, 0, sizeof(struct fuse_mount_data));
 	d->max_read = ~0;
 	d->blksize = FUSE_DEFAULT_BLKSIZE;
+	d->user_id = make_kuid(user_ns, 0);
+	d->group_id = make_kgid(user_ns, 0);
 
 	while ((p = strsep(&opt, ",")) != NULL) {
 		int token;
@@ -503,7 +535,7 @@ static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
 		case OPT_USER_ID:
 			if (fuse_match_uint(&args[0], &uv))
 				return 0;
-			d->user_id = make_kuid(current_user_ns(), uv);
+			d->user_id = make_kuid(user_ns, uv);
 			if (!uid_valid(d->user_id))
 				return 0;
 			d->user_id_present = 1;
@@ -512,7 +544,7 @@ static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
 		case OPT_GROUP_ID:
 			if (fuse_match_uint(&args[0], &uv))
 				return 0;
-			d->group_id = make_kgid(current_user_ns(), uv);
+			d->group_id = make_kgid(user_ns, uv);
 			if (!gid_valid(d->group_id))
 				return 0;
 			d->group_id_present = 1;
@@ -555,8 +587,10 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
 	struct super_block *sb = root->d_sb;
 	struct fuse_conn *fc = get_fuse_conn_super(sb);
 
-	seq_printf(m, ",user_id=%u", from_kuid_munged(&init_user_ns, fc->user_id));
-	seq_printf(m, ",group_id=%u", from_kgid_munged(&init_user_ns, fc->group_id));
+	seq_printf(m, ",user_id=%u",
+		   from_kuid_munged(fc->user_ns, fc->user_id));
+	seq_printf(m, ",group_id=%u",
+		   from_kgid_munged(fc->user_ns, fc->group_id));
 	if (fc->flags & FUSE_DEFAULT_PERMISSIONS)
 		seq_puts(m, ",default_permissions");
 	if (fc->flags & FUSE_ALLOW_OTHER)
@@ -587,7 +621,7 @@ static void fuse_pqueue_init(struct fuse_pqueue *fpq)
 	fpq->connected = 1;
 }
 
-void fuse_conn_init(struct fuse_conn *fc)
+void fuse_conn_init(struct fuse_conn *fc, struct user_namespace *user_ns)
 {
 	memset(fc, 0, sizeof(*fc));
 	spin_lock_init(&fc->lock);
@@ -611,6 +645,7 @@ void fuse_conn_init(struct fuse_conn *fc)
 	fc->attr_version = 1;
 	get_random_bytes(&fc->scramble_key, sizeof(fc->scramble_key));
 	fc->pid_ns = get_pid_ns(task_active_pid_ns(current));
+	fc->user_ns = get_user_ns(user_ns);
 }
 EXPORT_SYMBOL_GPL(fuse_conn_init);
 
@@ -620,6 +655,7 @@ void fuse_conn_put(struct fuse_conn *fc)
 		if (fc->destroy_req)
 			fuse_request_free(fc->destroy_req);
 		put_pid_ns(fc->pid_ns);
+		put_user_ns(fc->user_ns);
 		fc->release(fc);
 	}
 }
@@ -635,12 +671,15 @@ EXPORT_SYMBOL_GPL(fuse_conn_get);
 static struct inode *fuse_get_root_inode(struct super_block *sb, unsigned mode)
 {
 	struct fuse_attr attr;
+	struct inode *inode;
+
 	memset(&attr, 0, sizeof(attr));
 
 	attr.mode = mode;
 	attr.ino = FUSE_ROOT_ID;
 	attr.nlink = 1;
-	return fuse_iget(sb, 1, 0, &attr, 0, 0);
+	inode = fuse_iget(sb, 1, 0, &attr, 0, 0);
+	return IS_ERR(inode) ? NULL : inode;
 }
 
 struct fuse_inode_handle {
@@ -1046,7 +1085,7 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_flags &= ~(MS_NOSEC | MS_I_VERSION);
 
-	if (!parse_fuse_opt(data, &d, is_bdev))
+	if (!parse_fuse_opt(data, &d, is_bdev, sb->s_user_ns))
 		goto err;
 
 	if (is_bdev) {
@@ -1070,8 +1109,12 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 	if (!file)
 		goto err;
 
-	if ((file->f_op != &fuse_dev_operations) ||
-	    (file->f_cred->user_ns != &init_user_ns))
+	/*
+	 * Require mount to happen from the same user namespace which
+	 * opened /dev/fuse to prevent potential attacks.
+	 */
+	if (file->f_op != &fuse_dev_operations ||
+	    file->f_cred->user_ns != sb->s_user_ns)
 		goto err_fput;
 
 	fc = kmalloc(sizeof(*fc), GFP_KERNEL);
@@ -1079,7 +1122,7 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 	if (!fc)
 		goto err_fput;
 
-	fuse_conn_init(fc);
+	fuse_conn_init(fc, sb->s_user_ns);
 	fc->release = fuse_free_conn;
 
 	fud = fuse_dev_alloc(fc);
-- 
1.9.1


------------------------------------------------------------------------------
Go from Idea to Many App Stores Faster with Intel(R) XDK
Give your users amazing mobile app experiences with Intel(R) XDK.
Use one codebase in this all-in-one HTML5 development environment.
Design, debug & build mobile apps & 2D/3D high-impact games for multiple OSs.
http://pubads.g.doubleclick.net/gampad/clk?id=254741911&iu=/4140
