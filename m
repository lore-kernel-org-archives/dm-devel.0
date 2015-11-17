From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Tue, 17 Nov 2015 19:30:12 +0000
Message-ID: <20151117193012.GX22011@ZenIV.linux.org.uk>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
 <20151117170556.GV22011@ZenIV.linux.org.uk>
 <20151117172551.GA108807@ubuntu-hedt>
 <20151117175506.GW22011@ZenIV.linux.org.uk>
 <564B79B1.3040207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <564B79B1.3040207@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Seth Forshee <seth.forshee@canonical.com>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

On Tue, Nov 17, 2015 at 02:02:09PM -0500, Austin S Hemmelgarn wrote:

> >_Static_ attacks, or change-image-under-mounted-fs attacks?
> To properly protect against attacks on mounted filesystems, we'd
> need some new concept of a userspace immutable file (that is, one
> where nobody can write to it except the kernel, and only the kernel
> can change it between regular access and this new state), and then
> have the kernel set an image (or block device) to this state when a
> filesystem is mounted from it (this introduces all kinds of other
> issues too however, for example stuff that allows an online fsck on
> the device will stop working, as will many un-deletion tools).
> 
> The only other option would be to force the FS to cache all metadata
> in memory, and validate between the cache and what's on disk on
> every access, which is not realistic for any real world system.

Doctor, it hurt when I do it...

IOW, the other option is to refuse attempting this insanity.  Fuse probably
can be handled, but being able to mount (with kernel-space drivera) an
arbitrary ext4 image is equivalent to being able to do anything and it's
going to stay that way for the forseeable future.  You are talking about
a large pile of code that deals with rather convoluted data structure,
had not been written with validation in mind *and* keeps being developed.
What's more, that code runs with maximal priveleges there are.

This is absolutely insane, no matter how much LSM snake oil you slatter on
the whole thing.  All of a sudden you are exposing a huge attack surface
in the place where it would hurt most and as the consolation we are offered
basically "Ted is willing to fix holes when they are found".

I know that security community tends to be less than sane, but this really
takes the damn cake.

Al, still not quite able to believe this is not a badly mistimed AFD posting...
