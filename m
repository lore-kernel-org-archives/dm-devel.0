From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 14/19] fs: Permit FIBMAP for users with CAP_SYS_RAWIO in
 s_user_ns
Date: Fri, 4 Dec 2015 18:11:52 -0500
Message-ID: <20151204231152.GE18359@thunk.org>
References: <1449070821-73820-1-git-send-email-seth.forshee@canonical.com>
 <1449070821-73820-15-git-send-email-seth.forshee@canonical.com>
 <20151204191143.GE3624@mail.hallyn.com>
 <20151204200528.GC18359@thunk.org>
 <20151204200736.GJ3624@mail.hallyn.com>
 <20151204204532.GG147214@ubuntu-hedt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151204204532.GG147214@ubuntu-hedt>
Sender: linux-bcache-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
List-Id: dm-devel.ids

On Fri, Dec 04, 2015 at 02:45:32PM -0600, Seth Forshee wrote:
> On Fri, Dec 04, 2015 at 02:07:36PM -0600, Serge E. Hallyn wrote:
> > Heh, I was looking over http://www.gossamer-threads.com/lists/linux/kernel/103611
> > a little while ago :)  The same question was asked 16 years ago.  Apparently
> > the answer then was that it was easier than fixing the code.
> 
> So it seems then that either it still isn't safe and so unprivileged
> users shouldn't be allowed to do it at all, or else it's safe and we
> should drop the requirement completely. I can't say which is right,
> unfortunately.

It may not have been safe 16 years agoo, but giving invalid arguments
to FIBMAP is safe for ext4 and ext2.  This is the sort of thing that
tools like trinity should and does test for, so I think it should be
fine to remove the root check for FIBMAP.

							- Ted
