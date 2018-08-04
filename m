From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: LVM snapshot broke between 4.14 and 4.16
Date: Sat, 4 Aug 2018 17:48:12 -0400
Message-ID: <20180804214812.GA11320@redhat.com>
References: <b2bbd8ec-ac5b-fa8a-d3f7-8615d87f73c3@redhat.com>
 <CA+55aFwWZX=CXmWDTkDGb36kf12XmTehmQjbiMPCqCRG2hi9kw@mail.gmail.com>
 <20180803185431.GB3258@redhat.com>
 <CA+55aFwDEY7B6OMh5xL2wc8BRj1KkzBHggNowAjbsWfma6H5Zg@mail.gmail.com>
 <20180803193037.GA4581@redhat.com>
 <20180804052033.GA4461@thunk.org>
 <102c2d75-f768-a649-52c3-bac6f0ca738d@redhat.com>
 <20180804162205.GB4461@thunk.org>
 <20180804181845.GA10499@redhat.com>
 <20180804193753.GC4461@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180804193753.GC4461@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Zdenek Kabelac <zkabelac@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>, wgh@torlan.ru
List-Id: dm-devel.ids

On Sat, Aug 04 2018 at  3:37pm -0400,
Theodore Y. Ts'o <tytso@mit.edu> wrote:

> On Sat, Aug 04, 2018 at 02:18:47PM -0400, Mike Snitzer wrote:
> > > Fair enough.  I don't think I would consider that makes dm-snapshot a
> > > "steaming pile".  For me, protection against data loss is Job One.
> > 
> > What's your point Ted?  Do you have _any_ intention of actually using
> > anything DM or is this just a way for you to continue to snipe at it?
> 
> My point is that putting down dm-snapshot by calling it a "steaming
> pile" because it can't perform well on workloads that weren't a
> requirement when it was first designed is neither accurate nor fair.

As a person who has written a fair amount of dm-snapshot code I'm free
to have my opinion.  It is slow.  Period.

If it works for you, great.  But it isn't adequate for most modern
usecases I'm aware of.

> And steering users away from it by badmouthing to a technology which
> ever so often, requires enterprise support to recover, is something
> that *I* at least would classify as "marginal".

dm-snapshot is slow, as such I will badmouth it because dm-thinp is a
much more capable replacement.  I have to maintain both, so I'm free to
steer people according to my experience.

> Maybe it's just that file system developers have higher standards.  I
> know that Dave Chinner at LSF/MM commented that using some of the
> things he has been developing for XFS subvolume support might be
> interesting precisely because it could provide some of the facilities
> currently provided by thin provisioning (perhaps not all of them; I'm
> not sure how well his virtual block remapping layer would handle
> hundreds of snapshots) but with file system tools which have a lot
> more seasoning and where people have spent a lot of effort on data
> recovery tools.

Even new XFS features will have bugs.  Just because XFS's fsck is
historically robust, oversights and bugs happen when new features are
added.  And AFAIK future XFS would be looking to leverage DM thinp via
its producer/consumer model.  But this is going off on a tangent now.

> In any case, I do use DM quite a lot.  I use LVM2 and dm-snapshot (and
> it's been working just *fine* for my use cases).  I've wanted to use
> dm-thin, but have been put off by it being labeled as experimental and
> by some of the comments about how robust its recovery tools are.

The Documentation was stale.  I personally don't reference it so the
need to update it got overlooked.

> If there was documentation about how an advanced user/developer could
> use low level tools to do manual repair of a thin pool when the
> automated procedures didn't work, without having to pay $$$ to some
> company for "enterprise support", I'd be a lot more willing to give it
> a try.

We could certainly improve out documentation for the use of thin_check
and thin_repair.  I know lvm2 has seen improvements to allow the metdata
voulme to be activated in standalone mode (activate the metadata volume
without the thin-pool or thin devices ontop) so that the thin_check and
thin_repair tools can be used on it.  I'd imagine you aren't aware of
the lvm2 package's lvmthin manpage?  See: man lvmthin
It'd likely be one of the documentation locations to see improvements.
I'll talk with others about where we can improve docs, the manpages for
thin_check and thin_repair are _very_ sparse.  Anyway, room for
improvement for sure.

But demonizing "enterprise support" like you don't provide that to your
stake holders is bizarre.  I again was candid and forthcoming about what
drives/catches the need for thin_check and thin_repair fixes and
improvements: it just so happens that "enterprise" deployments make use
of DM-thinp and have exposed the need for support more than community
users.  I'm not saying I, or other DM thinp oriented developers,
wouldn't provided the same type of support if a community user like
yourself hit a problem.  It is just that enterprise users are the
prontlines of advanced usage and scale.  Deploying hundreds of Gluster
servers with every brick layered ontop of DM thinp historically exposed
issues.  Those issues get fixed and benefit everyone.

This discussion, and my need to explain how "enterprise support" drives
innovation, is so.. weird.

> Sorry, I just care a *lot* about data robustness.

You aren't alone.

> > Maybe read your email from earlier today before repeating yourself:
> > https://lkml.org/lkml/2018/8/4/366
> 
> Apologies.  I'm currently staying at an Assisted Living facility
> keeping an eye on my Dad this week, and the internet at the senior
> living center has been.... marginal.  As a result I've been reading my
> e-mail in batches, and so I hadn't seen the e-mail you had posted
> earlier before I had sent my reply.

Best wishes.  I've been dealing with stresses in my personal life
myself.  Might explain why we've had the awkwardness in this thread.

Mike
