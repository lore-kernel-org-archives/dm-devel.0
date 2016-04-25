From: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH v3 14/21] fs: Allow superblock owner to change ownership
 of inodes with unmappable ids
Date: Mon, 25 Apr 2016 15:54:51 -0500
Message-ID: <20160425205451.GA22516@ubuntu-hedt>
References: <1461339521-123191-1-git-send-email-seth.forshee@canonical.com>
 <1461339521-123191-15-git-send-email-seth.forshee@canonical.com>
 <20160425203047.GA29927@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160425203047.GA29927@mail.hallyn.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, cgroups@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Apr 25, 2016 at 03:30:47PM -0500, Serge E. Hallyn wrote:
> Quoting Seth Forshee (seth.forshee@canonical.com):
> > In a userns mount some on-disk inodes may have ids which do not
> > map into s_user_ns, in which case the in-kernel inodes are owned
> > by invalid users. The superblock owner should be able to change
> > attributes of these inodes but cannot. However it is unsafe to
> > grant the superblock owner privileged access to all inodes in the
> > superblock since proc, sysfs, etc. use DAC to protect files which
> > may not belong to s_user_ns. The problem is restricted to only
> > inodes where the owner or group is an invalid user.
> > 
> > We can work around this by allowing users with CAP_CHOWN in
> > s_user_ns to change an invalid owner or group id, so long as the
> > other id is either invalid or mappable in s_user_ns. After
> > changing ownership the user will be privileged towards the inode
> > and thus able to change other attributes.
> > 
> > As an precaution, checks for invalid ids are added to the proc
> > and kernfs setattr interfaces. These filesystems are not expected
> > to have inodes with invalid ids, but if it does happen any
> > setattr operations will return -EPERM.
> > 
> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> 
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> 
> bug a request below,
> 
> > ---
> >  fs/attr.c             | 47 +++++++++++++++++++++++++++++++++++++++--------
> >  fs/kernfs/inode.c     |  2 ++
> >  fs/proc/base.c        |  2 ++
> >  fs/proc/generic.c     |  3 +++
> >  fs/proc/proc_sysctl.c |  2 ++
> >  5 files changed, 48 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/attr.c b/fs/attr.c
> > index 3cfaaac4a18e..a8b0931654a5 100644
> > --- a/fs/attr.c
> > +++ b/fs/attr.c
> > @@ -16,6 +16,43 @@
> >  #include <linux/evm.h>
> >  #include <linux/ima.h>
> >  
> > +static bool chown_ok(const struct inode *inode, kuid_t uid)
> > +{
> > +	struct user_namespace *user_ns;
> > +
> > +	if (uid_eq(current_fsuid(), inode->i_uid) && uid_eq(uid, inode->i_uid))
> > +		return true;
> > +	if (capable_wrt_inode_uidgid(inode, CAP_CHOWN))
> > +		return true;
> > +
> > +	user_ns = inode->i_sb->s_user_ns;
> > +	if (!uid_valid(inode->i_uid) &&
> > +	    (!gid_valid(inode->i_gid) || kgid_has_mapping(user_ns, inode->i_gid)) &&
> 
> This confused me to no end :)  Perhaps a "is_unmapped_valid_gid()" helper
> would make it clearer what this is meant to do?  Or else maybe a comment
> above chown_ok(), explaining that
> 
> 1. for a blockdev, the uid is converted at inode read so that it is
> either mapped or invalid
> 2. for sysfs / etc, uid can be valid but not mapped into the userns

Even with a helper a comment is probably helpful to explain why. I'll do
that first, then see if a helper would make things any clearer.
Honestly, I had to think about the helper name you proposed for a minute
before it made sense even though I already understood the code ;-)
