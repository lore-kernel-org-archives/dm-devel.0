From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 14/19] fs: Permit FIBMAP for users with CAP_SYS_RAWIO in
 s_user_ns
Date: Fri, 4 Dec 2015 14:07:36 -0600
Message-ID: <20151204200736.GJ3624@mail.hallyn.com>
References: <1449070821-73820-1-git-send-email-seth.forshee@canonical.com>
 <1449070821-73820-15-git-send-email-seth.forshee@canonical.com>
 <20151204191143.GE3624@mail.hallyn.com>
 <20151204200528.GC18359@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151204200528.GC18359@thunk.org>
Sender: owner-linux-security-module@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, "Serge E. Hallyn" <serge@hallyn.com>, Seth Forshee <seth.forshee@canonical.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
List-Id: dm-devel.ids

Heh, I was looking over http://www.gossamer-threads.com/lists/linux/kernel/103611
a little while ago :)  The same question was asked 16 years ago.  Apparently
the answer then was that it was easier than fixing the code.

Quoting Theodore Ts'o (tytso@mit.edu):
> The fact that we need CAP_SYS_RAIO for FIBMAP is pretty silly, given
> that FIEMAP does not require privileges --- and in fact the preferred
> interface.  Why not just simply drop the requirement for privileges
> for FIBMAP?
> 
> (Seth, Serge, this isn't a real objection to your patch; but the fact
> that FIBMAP requires root has always been a bit silly, and this would
> be a great opportunity to simplify things a bit.)
> 
> 						- Ted
> 						
> 
> On Fri, Dec 04, 2015 at 01:11:43PM -0600, Serge E. Hallyn wrote:
> > Quoting Seth Forshee (seth.forshee@canonical.com):
> > > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> > 
> > Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> > 
> > > ---
> > >  fs/ioctl.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/ioctl.c b/fs/ioctl.c
> > > index 5d01d2638ca5..45c371bed7ee 100644
> > > --- a/fs/ioctl.c
> > > +++ b/fs/ioctl.c
> > > @@ -55,7 +55,7 @@ static int ioctl_fibmap(struct file *filp, int __user *p)
> > >  	/* do we support this mess? */
> > >  	if (!mapping->a_ops->bmap)
> > >  		return -EINVAL;
> > > -	if (!capable(CAP_SYS_RAWIO))
> > > +	if (!ns_capable(filp->f_inode->i_sb->s_user_ns, CAP_SYS_RAWIO))
> > >  		return -EPERM;
> > >  	res = get_user(block, p);
> > >  	if (res)
> > > -- 
> > > 1.9.1
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
