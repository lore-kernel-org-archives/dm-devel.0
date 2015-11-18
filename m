From: bfields@fieldses.org (J. Bruce Fields)
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Wed, 18 Nov 2015 13:44:08 -0500
Message-ID: <20151118184408.GA806@fieldses.org>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
 <20151117170556.GV22011@ZenIV.linux.org.uk>
 <20151117172551.GA108807@ubuntu-hedt>
 <20151117175506.GW22011@ZenIV.linux.org.uk>
 <564B79B1.3040207@gmail.com>
 <20151117193012.GX22011@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151117193012.GX22011@ZenIV.linux.org.uk>
Sender: linux-bcache-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, Seth Forshee <seth.forshee@canonical.com>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

On Tue, Nov 17, 2015 at 07:30:12PM +0000, Al Viro wrote:
> On Tue, Nov 17, 2015 at 02:02:09PM -0500, Austin S Hemmelgarn wrote:
> 
> > >_Static_ attacks, or change-image-under-mounted-fs attacks?
> > To properly protect against attacks on mounted filesystems, we'd
> > need some new concept of a userspace immutable file (that is, one
> > where nobody can write to it except the kernel, and only the kernel
> > can change it between regular access and this new state), and then
> > have the kernel set an image (or block device) to this state when a
> > filesystem is mounted from it (this introduces all kinds of other
> > issues too however, for example stuff that allows an online fsck on
> > the device will stop working, as will many un-deletion tools).
> > 
> > The only other option would be to force the FS to cache all metadata
> > in memory, and validate between the cache and what's on disk on
> > every access, which is not realistic for any real world system.
> 
> Doctor, it hurt when I do it...
> 
> IOW, the other option is to refuse attempting this insanity.  Fuse probably
> can be handled, but being able to mount (with kernel-space drivera) an
> arbitrary ext4 image is equivalent to being able to do anything and it's
> going to stay that way for the forseeable future.

What about the filesystems that desktop users commonly mount? (fat,
isofs, udf?)

--b.
