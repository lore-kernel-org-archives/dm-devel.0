From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH 14/19] fs: Permit FIBMAP for users with
 CAP_SYS_RAWIO in s_user_ns
Date: Fri, 4 Dec 2015 14:45:32 -0600
Message-ID: <20151204204532.GG147214@ubuntu-hedt>
References: <1449070821-73820-1-git-send-email-seth.forshee@canonical.com>
	<1449070821-73820-15-git-send-email-seth.forshee@canonical.com>
	<20151204191143.GE3624@mail.hallyn.com>
	<20151204200528.GC18359@thunk.org>
	<20151204200736.GJ3624@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151204200736.GJ3624-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: dm-devel.ids

On Fri, Dec 04, 2015 at 02:07:36PM -0600, Serge E. Hallyn wrote:
> Heh, I was looking over http://www.gossamer-threads.com/lists/linux/kernel/103611
> a little while ago :)  The same question was asked 16 years ago.  Apparently
> the answer then was that it was easier than fixing the code.

So it seems then that either it still isn't safe and so unprivileged
users shouldn't be allowed to do it at all, or else it's safe and we
should drop the requirement completely. I can't say which is right,
unfortunately.

> 
> Quoting Theodore Ts'o (tytso-3s7WtUTddSA@public.gmane.org):
> > The fact that we need CAP_SYS_RAIO for FIBMAP is pretty silly, given
> > that FIEMAP does not require privileges --- and in fact the preferred
> > interface.  Why not just simply drop the requirement for privileges
> > for FIBMAP?
> > 
> > (Seth, Serge, this isn't a real objection to your patch; but the fact
> > that FIBMAP requires root has always been a bit silly, and this would
> > be a great opportunity to simplify things a bit.)
> > 
> > 						- Ted
> > 						
> > 
> > On Fri, Dec 04, 2015 at 01:11:43PM -0600, Serge E. Hallyn wrote:
> > > Quoting Seth Forshee (seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org):
> > > > Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> > > 
> > > Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> > > 
> > > > ---
> > > >  fs/ioctl.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/ioctl.c b/fs/ioctl.c
> > > > index 5d01d2638ca5..45c371bed7ee 100644
> > > > --- a/fs/ioctl.c
> > > > +++ b/fs/ioctl.c
> > > > @@ -55,7 +55,7 @@ static int ioctl_fibmap(struct file *filp, int __user *p)
> > > >  	/* do we support this mess? */
> > > >  	if (!mapping->a_ops->bmap)
> > > >  		return -EINVAL;
> > > > -	if (!capable(CAP_SYS_RAWIO))
> > > > +	if (!ns_capable(filp->f_inode->i_sb->s_user_ns, CAP_SYS_RAWIO))
> > > >  		return -EPERM;
> > > >  	res = get_user(block, p);
> > > >  	if (res)
> > > > -- 
> > > > 1.9.1
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > Please read the FAQ at  http://www.tux.org/lkml/
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html

------------------------------------------------------------------------------
Go from Idea to Many App Stores Faster with Intel(R) XDK
Give your users amazing mobile app experiences with Intel(R) XDK.
Use one codebase in this all-in-one HTML5 development environment.
Design, debug & build mobile apps & 2D/3D high-impact games for multiple OSs.
http://pubads.g.doubleclick.net/gampad/clk?id=254741911&iu=/4140
