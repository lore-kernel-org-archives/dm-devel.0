From: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH 17/19] fuse: Support fuse filesystems outside of
 init_user_ns
Date: Fri, 4 Dec 2015 15:57:07 -0600
Message-ID: <20151204215707.GA5699@mail.hallyn.com>
References: <1449070821-73820-1-git-send-email-seth.forshee@canonical.com>
 <1449070821-73820-18-git-send-email-seth.forshee@canonical.com>
 <20151204200355.GH3624@mail.hallyn.com>
 <20151204204122.GE147214@ubuntu-hedt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151204204122.GE147214@ubuntu-hedt>
Sender: linux-bcache-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
List-Id: dm-devel.ids

On Fri, Dec 04, 2015 at 02:41:22PM -0600, Seth Forshee wrote:
> On Fri, Dec 04, 2015 at 02:03:55PM -0600, Serge E. Hallyn wrote:
> > Quoting Seth Forshee (seth.forshee@canonical.com):
> > > Update fuse to translate uids and gids to/from the user namspace
> > > of the process servicing requests on /dev/fuse. Any ids which do
> > > not map into the namespace will result in errors. inodes will
> > > also be marked bad when unmappable ids are received from the
> > > userspace fuse process.
> > > 
> > > Currently no use cases are known for letting the userspace fuse
> > > daemon switch namespaces after opening /dev/fuse. Given this
> > > fact, and in order to keep the implementation as simple as
> > > possible and ease security auditing, the user namespace from
> > > which /dev/fuse is opened is used for all id translations. This
> > > is required to be the same namespace as s_user_ns to maintain
> > > behavior consistent with other filesystems which can be mounted
> > > in user namespaces.
> > > 
> > > For cuse the namespace used for the connection is also simply
> > > current_user_ns() at the time /dev/cuse is opened.
> > > 
> > > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> > > ---
> > >  fs/fuse/cuse.c   |  3 +-
> > >  fs/fuse/dev.c    | 13 +++++----
> > >  fs/fuse/dir.c    | 81 ++++++++++++++++++++++++++++++++++-------------------
> > >  fs/fuse/fuse_i.h | 14 ++++++----
> > >  fs/fuse/inode.c  | 85 ++++++++++++++++++++++++++++++++++++++++++--------------
> > >  5 files changed, 136 insertions(+), 60 deletions(-)
> > > 
> > > diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
> > > index eae2c11268bc..a10aca57bfe4 100644
> > > --- a/fs/fuse/cuse.c
> > > +++ b/fs/fuse/cuse.c
> > > @@ -48,6 +48,7 @@
> > >  #include <linux/stat.h>
> > >  #include <linux/module.h>
> > >  #include <linux/uio.h>
> > > +#include <linux/user_namespace.h>
> > >  
> > >  #include "fuse_i.h"
> > >  
> > > @@ -498,7 +499,7 @@ static int cuse_channel_open(struct inode *inode, struct file *file)
> > >  	if (!cc)
> > >  		return -ENOMEM;
> > >  
> > > -	fuse_conn_init(&cc->fc);
> > > +	fuse_conn_init(&cc->fc, current_user_ns());
> > >  
> > >  	fud = fuse_dev_alloc(&cc->fc);
> > >  	if (!fud) {
> > > diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> > > index a4f6f30d6d86..11b4cb0a0e2f 100644
> > > --- a/fs/fuse/dev.c
> > > +++ b/fs/fuse/dev.c
> > > @@ -127,8 +127,8 @@ static void __fuse_put_request(struct fuse_req *req)
> > >  
> > >  static void fuse_req_init_context(struct fuse_conn *fc, struct fuse_req *req)
> > >  {
> > > -	req->in.h.uid = from_kuid_munged(&init_user_ns, current_fsuid());
> > > -	req->in.h.gid = from_kgid_munged(&init_user_ns, current_fsgid());
> > > +	req->in.h.uid = from_kuid(fc->user_ns, current_fsuid());
> > > +	req->in.h.gid = from_kgid(fc->user_ns, current_fsgid());
> > >  	req->in.h.pid = pid_nr_ns(task_pid(current), fc->pid_ns);
> > >  }
> > >  
> > > @@ -186,7 +186,8 @@ static struct fuse_req *__fuse_get_req(struct fuse_conn *fc, unsigned npages,
> > >  	__set_bit(FR_WAITING, &req->flags);
> > >  	if (for_background)
> > >  		__set_bit(FR_BACKGROUND, &req->flags);
> > > -	if (req->in.h.pid == 0) {
> > > +	if (req->in.h.pid == 0 || req->in.h.uid == (uid_t)-1 ||
> > > +	    req->in.h.gid == (gid_t)-1) {
> > >  		fuse_put_request(fc, req);
> > >  		return ERR_PTR(-EOVERFLOW);
> > >  	}
> > > @@ -1248,7 +1249,8 @@ static ssize_t fuse_dev_do_read(struct fuse_dev *fud, struct file *file,
> > >  	struct fuse_in *in;
> > >  	unsigned reqsize;
> > >  
> > > -	if (task_active_pid_ns(current) != fc->pid_ns)
> > > +	if (task_active_pid_ns(current) != fc->pid_ns ||
> > > +	    current_user_ns() != fc->user_ns)
> > 
> > Do you think this should be using current_in_user_ns(fc->user_ns) ?
> > 
> > Opening a file, forking (maybe unsharing) then acting on the file is
> > pretty standard fare which this would break.
> > 
> > (same for pidns, i guess, as well as for write below)
> 
> I'd rather leave it as is. It might be okay, but even if current_user_ns
> is a child of fc->user_ns it could end up seeing ids that aren't valid
> for it's namespaces, and that might cause issues for filesystems which
> aren't expecting it.
> 
> But if you have a use case for a process in a child namespace servicing
> requests for a mount, I'd be willing to reconsider.

I'm pretty sure we'll get such uses, i.e. opening a file, unsharing userns,
and not mapping in any userids, to sandbox the program.  But we can address
it when it happens, I think.

(sorry I need to re-read before acking the whole patch)
