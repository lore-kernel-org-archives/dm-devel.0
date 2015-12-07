From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH v2 15/18] fuse: Add support for pid namespaces
Date: Mon,  7 Dec 2015 15:21:24 -0600
Message-ID: <1449523289-144238-16-git-send-email-seth.forshee@canonical.com>
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
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

If the userspace process servicing fuse requests is running in
a pid namespace then pids passed via the fuse fd need to be
translated relative to that namespace. Capture the pid namespace
in use when the filesystem is mounted and use this for pid
translation.

Since no use case currently exists for changing namespaces all
translations are done relative to the pid namespace in use when
/dev/fuse is opened. Mounting or /dev/fuse IO from another
namespace will return errors.

Requests from processes whose pid cannot be translated into the
target namespace are not permitted, except for requests
allocated via fuse_get_req_nofail_nopages. For no-fail requests
in.h.pid will be 0 if the pid translation fails.

File locking changes based on previous work done by Eric
Biederman.

Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>
---
 fs/fuse/dev.c    | 19 +++++++++++++++----
 fs/fuse/file.c   | 22 +++++++++++++++++-----
 fs/fuse/fuse_i.h |  4 ++++
 fs/fuse/inode.c  |  3 +++
 4 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index ebb5e37455a0..a4f6f30d6d86 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -19,6 +19,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/swap.h>
 #include <linux/splice.h>
+#include <linux/sched.h>
 
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 MODULE_ALIAS("devname:fuse");
@@ -124,11 +125,11 @@ static void __fuse_put_request(struct fuse_req *req)
 	atomic_dec(&req->count);
 }
 
-static void fuse_req_init_context(struct fuse_req *req)
+static void fuse_req_init_context(struct fuse_conn *fc, struct fuse_req *req)
 {
 	req->in.h.uid = from_kuid_munged(&init_user_ns, current_fsuid());
 	req->in.h.gid = from_kgid_munged(&init_user_ns, current_fsgid());
-	req->in.h.pid = current->pid;
+	req->in.h.pid = pid_nr_ns(task_pid(current), fc->pid_ns);
 }
 
 void fuse_set_initialized(struct fuse_conn *fc)
@@ -181,10 +182,14 @@ static struct fuse_req *__fuse_get_req(struct fuse_conn *fc, unsigned npages,
 		goto out;
 	}
 
-	fuse_req_init_context(req);
+	fuse_req_init_context(fc, req);
 	__set_bit(FR_WAITING, &req->flags);
 	if (for_background)
 		__set_bit(FR_BACKGROUND, &req->flags);
+	if (req->in.h.pid == 0) {
+		fuse_put_request(fc, req);
+		return ERR_PTR(-EOVERFLOW);
+	}
 
 	return req;
 
@@ -274,7 +279,7 @@ struct fuse_req *fuse_get_req_nofail_nopages(struct fuse_conn *fc,
 	if (!req)
 		req = get_reserved_req(fc, file);
 
-	fuse_req_init_context(req);
+	fuse_req_init_context(fc, req);
 	__set_bit(FR_WAITING, &req->flags);
 	__clear_bit(FR_BACKGROUND, &req->flags);
 	return req;
@@ -1243,6 +1248,9 @@ static ssize_t fuse_dev_do_read(struct fuse_dev *fud, struct file *file,
 	struct fuse_in *in;
 	unsigned reqsize;
 
+	if (task_active_pid_ns(current) != fc->pid_ns)
+		return -EIO;
+
  restart:
 	spin_lock(&fiq->waitq.lock);
 	err = -EAGAIN;
@@ -1872,6 +1880,9 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	struct fuse_req *req;
 	struct fuse_out_header oh;
 
+	if (task_active_pid_ns(current) != fc->pid_ns)
+		return -EIO;
+
 	if (nbytes < sizeof(struct fuse_out_header))
 		return -EINVAL;
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index e0faf8f2c868..a6c7484c94ee 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2061,7 +2061,8 @@ static int fuse_direct_mmap(struct file *file, struct vm_area_struct *vma)
 	return generic_file_mmap(file, vma);
 }
 
-static int convert_fuse_file_lock(const struct fuse_file_lock *ffl,
+static int convert_fuse_file_lock(struct fuse_conn *fc,
+				  const struct fuse_file_lock *ffl,
 				  struct file_lock *fl)
 {
 	switch (ffl->type) {
@@ -2076,7 +2077,14 @@ static int convert_fuse_file_lock(const struct fuse_file_lock *ffl,
 
 		fl->fl_start = ffl->start;
 		fl->fl_end = ffl->end;
-		fl->fl_pid = ffl->pid;
+
+		/*
+		 * Convert pid into the caller's pid namespace. If the pid
+		 * does not map into the namespace fl_pid will get set to 0.
+		 */
+		rcu_read_lock();
+		fl->fl_pid = pid_vnr(find_pid_ns(ffl->pid, fc->pid_ns));
+		rcu_read_unlock();
 		break;
 
 	default:
@@ -2125,7 +2133,7 @@ static int fuse_getlk(struct file *file, struct file_lock *fl)
 	args.out.args[0].value = &outarg;
 	err = fuse_simple_request(fc, &args);
 	if (!err)
-		err = convert_fuse_file_lock(&outarg.lk, fl);
+		err = convert_fuse_file_lock(fc, &outarg.lk, fl);
 
 	return err;
 }
@@ -2137,7 +2145,8 @@ static int fuse_setlk(struct file *file, struct file_lock *fl, int flock)
 	FUSE_ARGS(args);
 	struct fuse_lk_in inarg;
 	int opcode = (fl->fl_flags & FL_SLEEP) ? FUSE_SETLKW : FUSE_SETLK;
-	pid_t pid = fl->fl_type != F_UNLCK ? current->tgid : 0;
+	struct pid *pid = fl->fl_type != F_UNLCK ? task_tgid(current) : NULL;
+	pid_t pid_nr = pid_nr_ns(pid, fc->pid_ns);
 	int err;
 
 	if (fl->fl_lmops && fl->fl_lmops->lm_grant) {
@@ -2149,7 +2158,10 @@ static int fuse_setlk(struct file *file, struct file_lock *fl, int flock)
 	if (fl->fl_flags & FL_CLOSE)
 		return 0;
 
-	fuse_lk_fill(&args, file, fl, opcode, pid, flock, &inarg);
+	if (pid && pid_nr == 0)
+		return -EOVERFLOW;
+
+	fuse_lk_fill(&args, file, fl, opcode, pid_nr, flock, &inarg);
 	err = fuse_simple_request(fc, &args);
 
 	/* locking is restartable */
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 405113101db8..143b595197b6 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -22,6 +22,7 @@
 #include <linux/rbtree.h>
 #include <linux/poll.h>
 #include <linux/workqueue.h>
+#include <linux/pid_namespace.h>
 
 /** Max number of pages that can be used in a single read request */
 #define FUSE_MAX_PAGES_PER_REQ 32
@@ -456,6 +457,9 @@ struct fuse_conn {
 	/** The group id for this mount */
 	kgid_t group_id;
 
+	/** The pid namespace for this mount */
+	struct pid_namespace *pid_ns;
+
 	/** The fuse mount flags for this mount */
 	unsigned flags;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 2913db2a5b99..2f31874ea9db 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -20,6 +20,7 @@
 #include <linux/random.h>
 #include <linux/sched.h>
 #include <linux/exportfs.h>
+#include <linux/pid_namespace.h>
 
 MODULE_AUTHOR("Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>");
 MODULE_DESCRIPTION("Filesystem in Userspace");
@@ -609,6 +610,7 @@ void fuse_conn_init(struct fuse_conn *fc)
 	fc->connected = 1;
 	fc->attr_version = 1;
 	get_random_bytes(&fc->scramble_key, sizeof(fc->scramble_key));
+	fc->pid_ns = get_pid_ns(task_active_pid_ns(current));
 }
 EXPORT_SYMBOL_GPL(fuse_conn_init);
 
@@ -617,6 +619,7 @@ void fuse_conn_put(struct fuse_conn *fc)
 	if (atomic_dec_and_test(&fc->count)) {
 		if (fc->destroy_req)
 			fuse_request_free(fc->destroy_req);
+		put_pid_ns(fc->pid_ns);
 		fc->release(fc);
 	}
 }
-- 
1.9.1


------------------------------------------------------------------------------
Go from Idea to Many App Stores Faster with Intel(R) XDK
Give your users amazing mobile app experiences with Intel(R) XDK.
Use one codebase in this all-in-one HTML5 development environment.
Design, debug & build mobile apps & 2D/3D high-impact games for multiple OSs.
http://pubads.g.doubleclick.net/gampad/clk?id=254741911&iu=/4140
