From: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Tue, 17 Nov 2015 13:16:06 -0600
Message-ID: <20151117191606.GC108807@ubuntu-hedt>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
 <20151117170556.GV22011@ZenIV.linux.org.uk>
 <20151117172551.GA108807@ubuntu-hedt>
 <20151117175506.GW22011@ZenIV.linux.org.uk>
 <564B79B1.3040207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <564B79B1.3040207@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

On Tue, Nov 17, 2015 at 02:02:09PM -0500, Austin S Hemmelgarn wrote:
> On 2015-11-17 12:55, Al Viro wrote:
> >On Tue, Nov 17, 2015 at 11:25:51AM -0600, Seth Forshee wrote:
> >
> >>Shortly after that I plan to follow with support for ext4. I've been
> >>fuzzing ext4 for a while now and it has held up well, and I'm currently
> >>working on hand-crafted attacks. Ted has commented privately (to others,
> >>not to me personally) that he will fix bugs for such attacks, though I
> >>haven't seen any public comments to that effect.
> >
> >_Static_ attacks, or change-image-under-mounted-fs attacks?
> To properly protect against attacks on mounted filesystems, we'd
> need some new concept of a userspace immutable file (that is, one
> where nobody can write to it except the kernel, and only the kernel
> can change it between regular access and this new state), and then
> have the kernel set an image (or block device) to this state when a
> filesystem is mounted from it (this introduces all kinds of other
> issues too however, for example stuff that allows an online fsck on
> the device will stop working, as will many un-deletion tools).

Yeah, Serge and I were just tossing that idea around on irc. If we can
make that work then it's probably the best solution.

From a naive perspective it seems like all we really have to do is make
the block device inode immutable to userspace when it is mounted. And
the parent block device if it's a partition, which might be a bit
troublesome. We'd have to ensure that writes couldn't happen via any fds
already open when the device was mounted too.

We'd need some cooperation from the loop driver too I suppose, to make
sure the file backing the loop device is also immutable.
