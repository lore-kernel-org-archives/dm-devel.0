From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH RESEND v2 16/18] fuse: Support fuse
 filesystems outside of init_user_ns
Date: Wed, 9 Mar 2016 11:07:26 -0600
Message-ID: <20160309170726.GB28779@ubuntu-hedt>
References: <1451930639-94331-1-git-send-email-seth.forshee@canonical.com>
	<1451930639-94331-17-git-send-email-seth.forshee@canonical.com>
	<20160309112923.GF8655@tucsk> <20160309141840.GC23399@ubuntu-xps13>
	<CAJfpegv5JmB15yHpjYxVeOYdWWkoLMftr9-e_iS93Y_7m=t4Zw@mail.gmail.com>
	<20160309152505.GA28779@ubuntu-hedt>
	<CAJfpegv5KR_Hi-79a8oyb+R+tv9W3RYqy5pngUKSyauVNk2ScQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegv5KR_Hi-79a8oyb+R+tv9W3RYqy5pngUKSyauVNk2ScQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: dm-devel.ids

On Wed, Mar 09, 2016 at 04:51:42PM +0100, Miklos Szeredi wrote:
> On Wed, Mar 9, 2016 at 4:25 PM, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> > On Wed, Mar 09, 2016 at 03:48:22PM +0100, Miklos Szeredi wrote:
> 
> >> Can't we use current_cred()->uid/gid? Or fsuid/fsgid maybe?
> >
> > That would be a departure from the current behavior in the !allow_other
> > case for unprivileged users. Since those mounts are done by an suid
> > helper all of those ids would be root in the userns, wouldn't they?
> 
> Well, actually this is what the helper does:
> 
>     sprintf(d, "fd=%i,rootmode=%o,user_id=%u,group_id=%u",
>         fd, rootmode, getuid(), getgid());

Sorry, I was thinking of euid. So this may not be a problem.

> So it just uses the current uid/gid.  Apparently no reason to do this
> in userland, we could just as well set these in the kernel.  Except
> for possible backward compatibility problems for things not using the
> helper.
> 
> BUT if the mount is unprivileged or it's a userns mount, or anything
> previously not possible, then we are not constrained by the backward
> compatibility issues, and can go with the saner solution.
> 
> Does that not make sense?

But we generally do want backwards compatibility, and we want userspace
software to be able to expect the same behavior whether or not it's
running in a user namespaced container. Obviously we can't always have
things 100% identical, but we shouldn't break things unless we really
need to.

However it may be that this isn't actually going to break assumptions of
existing software like I had feared. My preference is still to not
change any userspace-visible behaviors since we never know what software
might have made assumptions based on those behaviors. But if you're
confident that it won't break anything I'm willing to give it a try.

> >> When we have true unprivileged mounts, the user_id/group_id options
> >> become redundant anyway and we can just use the current credentials.
> >
> > True, but we don't yet have that.
> 
> What's missing?

A user must still be privileged to mount, even if only towards their own
user and mount namespaces. Maybe that's what you meant though and I just
misunderstood.

Thanks,
Seth

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785111&iu=/4140
-- 
fuse-devel mailing list
To unsubscribe or subscribe, visit https://lists.sourceforge.net/lists/listinfo/fuse-devel
