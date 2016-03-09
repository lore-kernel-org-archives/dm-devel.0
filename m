From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH RESEND v2 16/18] fuse: Support fuse filesystems outside of init_user_ns
Date: Wed, 9 Mar 2016 16:51:42 +0100
Message-ID: <CAJfpegv5KR_Hi-79a8oyb+R+tv9W3RYqy5pngUKSyauVNk2ScQ@mail.gmail.com>
References: <1451930639-94331-1-git-send-email-seth.forshee@canonical.com>
	<1451930639-94331-17-git-send-email-seth.forshee@canonical.com>
	<20160309112923.GF8655@tucsk>
	<20160309141840.GC23399@ubuntu-xps13>
	<CAJfpegv5JmB15yHpjYxVeOYdWWkoLMftr9-e_iS93Y_7m=t4Zw@mail.gmail.com>
	<20160309152505.GA28779@ubuntu-hedt>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20160309152505.GA28779@ubuntu-hedt>
Sender: owner-linux-security-module@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, fuse-devel <fuse-devel@lists.sourceforge.net>, LSM <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov
List-Id: dm-devel.ids

On Wed, Mar 9, 2016 at 4:25 PM, Seth Forshee <seth.forshee@canonical.com> wrote:
> On Wed, Mar 09, 2016 at 03:48:22PM +0100, Miklos Szeredi wrote:

>> Can't we use current_cred()->uid/gid? Or fsuid/fsgid maybe?
>
> That would be a departure from the current behavior in the !allow_other
> case for unprivileged users. Since those mounts are done by an suid
> helper all of those ids would be root in the userns, wouldn't they?

Well, actually this is what the helper does:

    sprintf(d, "fd=%i,rootmode=%o,user_id=%u,group_id=%u",
        fd, rootmode, getuid(), getgid());

So it just uses the current uid/gid.  Apparently no reason to do this
in userland, we could just as well set these in the kernel.  Except
for possible backward compatibility problems for things not using the
helper.

BUT if the mount is unprivileged or it's a userns mount, or anything
previously not possible, then we are not constrained by the backward
compatibility issues, and can go with the saner solution.

Does that not make sense?

>> When we have true unprivileged mounts, the user_id/group_id options
>> become redundant anyway and we can just use the current credentials.
>
> True, but we don't yet have that.

What's missing?

Thanks,
Miklos
