From: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH RESEND v2 16/18] fuse: Support fuse filesystems outside
 of init_user_ns
Date: Fri, 25 Mar 2016 15:31:48 -0500
Message-ID: <20160325203148.GA4055@ubuntu-xps13>
References: <1451930639-94331-1-git-send-email-seth.forshee@canonical.com>
 <1451930639-94331-17-git-send-email-seth.forshee@canonical.com>
 <20160309112923.GF8655@tucsk>
 <20160309141840.GC23399@ubuntu-xps13>
 <CAJfpegv5JmB15yHpjYxVeOYdWWkoLMftr9-e_iS93Y_7m=t4Zw@mail.gmail.com>
 <20160309152505.GA28779@ubuntu-hedt>
 <CAJfpegv5KR_Hi-79a8oyb+R+tv9W3RYqy5pngUKSyauVNk2ScQ@mail.gmail.com>
 <20160309170726.GB28779@ubuntu-hedt>
 <CAJfpegvTuR-LZAVxeJAmojs=gcrM-t5dd-QyZM-bOYMYLRL6Dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegvTuR-LZAVxeJAmojs=gcrM-t5dd-QyZM-bOYMYLRL6Dg@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, fuse-devel <fuse-devel@lists.sourceforge.net>, LSM <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov
List-Id: dm-devel.ids

On Mon, Mar 14, 2016 at 09:58:43PM +0100, Miklos Szeredi wrote:
> On Wed, Mar 9, 2016 at 6:07 PM, Seth Forshee <seth.forshee@canonical.com> wrote:
> > On Wed, Mar 09, 2016 at 04:51:42PM +0100, Miklos Szeredi wrote:
> >> On Wed, Mar 9, 2016 at 4:25 PM, Seth Forshee <seth.forshee@canonical.com> wrote:
> >> > On Wed, Mar 09, 2016 at 03:48:22PM +0100, Miklos Szeredi wrote:
> >>
> >> >> Can't we use current_cred()->uid/gid? Or fsuid/fsgid maybe?
> >> >
> >> > That would be a departure from the current behavior in the !allow_other
> >> > case for unprivileged users. Since those mounts are done by an suid
> >> > helper all of those ids would be root in the userns, wouldn't they?
> >>
> >> Well, actually this is what the helper does:
> >>
> >>     sprintf(d, "fd=%i,rootmode=%o,user_id=%u,group_id=%u",
> >>         fd, rootmode, getuid(), getgid());
> >
> > Sorry, I was thinking of euid. So this may not be a problem.
> >
> >> So it just uses the current uid/gid.  Apparently no reason to do this
> >> in userland, we could just as well set these in the kernel.  Except
> >> for possible backward compatibility problems for things not using the
> >> helper.
> >>
> >> BUT if the mount is unprivileged or it's a userns mount, or anything
> >> previously not possible, then we are not constrained by the backward
> >> compatibility issues, and can go with the saner solution.
> >>
> >> Does that not make sense?
> >
> > But we generally do want backwards compatibility, and we want userspace
> > software to be able to expect the same behavior whether or not it's
> > running in a user namespaced container. Obviously we can't always have
> > things 100% identical, but we shouldn't break things unless we really
> > need to.
> >
> > However it may be that this isn't actually going to break assumptions of
> > existing software like I had feared. My preference is still to not
> > change any userspace-visible behaviors since we never know what software
> > might have made assumptions based on those behaviors. But if you're
> > confident that it won't break anything I'm willing to give it a try.
> 
> I'm quite confident it won't make a difference.

I was just about to go make these changes and discovered that the
user_id and group_id options are already mandatory, due to this check at
the bottom of parse_fuse_opt():

        if (!d->fd_present || !d->rootmode_present ||
            !d->user_id_present || !d->group_id_present)
                return 0;

So I'll simply drop those two lines which supply default values for
these options.

Thanks,
Seth
