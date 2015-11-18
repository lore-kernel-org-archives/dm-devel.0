From: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Wed, 18 Nov 2015 08:30:22 -0600
Message-ID: <20151118143022.GC134139@ubuntu-hedt>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
 <20151117170556.GV22011@ZenIV.linux.org.uk>
 <20151117172551.GA108807@ubuntu-hedt>
 <20151117175506.GW22011@ZenIV.linux.org.uk>
 <564B79B1.3040207@gmail.com>
 <20151117193012.GX22011@ZenIV.linux.org.uk>
 <564B9074.5030305@gmail.com>
 <20151117210542.GY22011@ZenIV.linux.org.uk>
 <20151117220125.GF108807@ubuntu-hedt>
 <564C733D.7010601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <564C733D.7010601@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

On Wed, Nov 18, 2015 at 07:46:53AM -0500, Austin S Hemmelgarn wrote:
> On 2015-11-17 17:01, Seth Forshee wrote:
> >On Tue, Nov 17, 2015 at 09:05:42PM +0000, Al Viro wrote:
> >>On Tue, Nov 17, 2015 at 03:39:16PM -0500, Austin S Hemmelgarn wrote:
> >>
> >>>>This is absolutely insane, no matter how much LSM snake oil you slatter on
> >>>>the whole thing.  All of a sudden you are exposing a huge attack surface
> >>>>in the place where it would hurt most and as the consolation we are offered
> >>>>basically "Ted is willing to fix holes when they are found".
> >
> >None of the LSM changes are intended to protect against attacks from
> >these sorts of attacks at all, so that's irrelevant.
> >
> >As I said before, I'm also working to find holes up front. That plus a
> >commitment from the maintainer seems like a good start at least. What
> >bar would you set for a given filesystem to be considered "safe enough"?
> >
> >>>For the context of static image attacks, anything that's foun
> >>>_needs_ to be fixed regardless, and unless you can find some way to
> >>>actually prevent attacks on mounted filesystems that doesn't involve
> >>>a complete re-write of the filesystem drivers, then there's not much
> >>>we can do about it.  Yes, unprivileged mounts expose an attack
> >>>surface, but so does userspace access to the network stack, and so
> >>>do a lot of other features that are considered essential in a modern
> >>>general purpose operating system.
> >>
> >>"X is exposes an attack surface.  Y exposes a diferent attack surface.
> >>Y is considered important.  Therefore X is important enough to implement it"
> >>
> >>Right...
> >
> >That isn't the argument he made. I would summarize the argument as,
> >"Saying that X exposes an attack surface isn't by itself enough to
> >reject X, otherwise we wouldn't expose anything (such as example Y)."
> It's good to see someone understood my meaning...
> >
> >You believe that the attack surface is too large, and that's
> >understandable. Is it your opinion that this is a fundamental problem
> >for an in-kernel filesystem driver, i.e. that we can never be confident
> >enough in an in-kernel filesystem parser to allow untrusted data? If
> >not, what would it take to establish a level of confidence that you
> >would be comfortable with?
> While I can't speak for Al's opinion on this, I would like to point
> out my earlier comment:
> > It's unfeasible from a practical standpoint to expect filesystems
> to > assume that stuff they write might change under them due to
> malicious > intent of a third party.

So maybe the first requirement is that the user cannot modify the
backing store directly while the device is mounted.

> We can't protect against everything, not without making the system
> completely unusable for general purpose computing.  There is always
> some degree of trust involved in usage of a computer, the OS has to
> trust that the hardware works correctly, the administrator has to
> trust the OS to behave correctly, and the users have to trust the
> administrator.  The administrator also needs to have at least some
> trust in the users, otherwise he shouldn't be allowing them to use
> the system.
> 
> Perhaps we should have an option that can only be enabled on
> creation of the userns that would allow it to use regular kernel
> mounts, and without that option we default to only allowing FUSE and
> a couple of virtual filesystems (like /proc and devtmpfs).

I've considered the idea of something more global like a sysctl, or a
per-filesystem knob in sysfs. I guess a per-container knob is another
option, I'm not sure what interface we use to expose it though.
