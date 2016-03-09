From: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH RESEND v2 15/18] fuse: Add support for pid namespaces
Date: Wed, 9 Mar 2016 08:17:41 -0600
Message-ID: <20160309141741.GB23399@ubuntu-xps13>
References: <1451930639-94331-1-git-send-email-seth.forshee@canonical.com>
 <1451930639-94331-16-git-send-email-seth.forshee@canonical.com>
 <20160309105317.GE8655@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160309105317.GE8655@tucsk>
Sender: linux-bcache-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, Miklos Szeredi <mszeredi@suse.cz>
List-Id: dm-devel.ids

On Wed, Mar 09, 2016 at 11:53:17AM +0100, Miklos Szeredi wrote:
> On Mon, Jan 04, 2016 at 12:03:54PM -0600, Seth Forshee wrote:
> > If the userspace process servicing fuse requests is running in
> > a pid namespace then pids passed via the fuse fd need to be
> > translated relative to that namespace. Capture the pid namespace
> > in use when the filesystem is mounted and use this for pid
> > translation.
> > 
> > Since no use case currently exists for changing namespaces all
> > translations are done relative to the pid namespace in use when
> > /dev/fuse is opened.
> 
> The above doesn't match what the patch does.
> 
>  - FUSE captures namespace at mount time
> 
>  - CUSE captures namespace at /dev/cuse open

Possibly an earlier version of the patch worked that way and I forgot to
update the description after it change. Anyway, I'll fix it.

> >  Mounting or /dev/fuse IO from another
> > namespace will return errors.
> > 
> > Requests from processes whose pid cannot be translated into the
> > target namespace are not permitted, except for requests
> > allocated via fuse_get_req_nofail_nopages. For no-fail requests
> > in.h.pid will be 0 if the pid translation fails.
> > 
> > File locking changes based on previous work done by Eric
> > Biederman.
> > 
> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> 
> Not sure how my SOB got on this patch, use this instead:
> 
> Acked-by: Miklos Szeredi <mszeredi@redhat.com>

My memory is that you had sent a patch as a proposed alternative to one
of my earlier patches, and I squashed the two together and added your
SOB at that point. I'll change it.

Thanks,
Seth
