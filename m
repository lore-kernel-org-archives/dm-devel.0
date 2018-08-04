From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: LVM snapshot broke between 4.14 and 4.16
Date: Sat, 4 Aug 2018 15:37:53 -0400
Message-ID: <20180804193753.GC4461@thunk.org>
References: <CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com>
	<b2bbd8ec-ac5b-fa8a-d3f7-8615d87f73c3@redhat.com>
	<CA+55aFwWZX=CXmWDTkDGb36kf12XmTehmQjbiMPCqCRG2hi9kw@mail.gmail.com>
	<20180803185431.GB3258@redhat.com>
	<CA+55aFwDEY7B6OMh5xL2wc8BRj1KkzBHggNowAjbsWfma6H5Zg@mail.gmail.com>
	<20180803193037.GA4581@redhat.com>
	<20180804052033.GA4461@thunk.org>
	<102c2d75-f768-a649-52c3-bac6f0ca738d@redhat.com>
	<20180804162205.GB4461@thunk.org>
	<20180804181845.GA10499@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180804181845.GA10499@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, wgh@torlan.ru
List-Id: dm-devel.ids

On Sat, Aug 04, 2018 at 02:18:47PM -0400, Mike Snitzer wrote:
> > Fair enough.  I don't think I would consider that makes dm-snapshot a
> > "steaming pile".  For me, protection against data loss is Job One.
> 
> What's your point Ted?  Do you have _any_ intention of actually using
> anything DM or is this just a way for you to continue to snipe at it?

My point is that putting down dm-snapshot by calling it a "steaming
pile" because it can't perform well on workloads that weren't a
requirement when it was first designed is neither accurate nor fair.
And steering users away from it by badmouthing to a technology which
ever so often, requires enterprise support to recover, is something
that *I* at least would classify as "marginal".

Maybe it's just that file system developers have higher standards.  I
know that Dave Chinner at LSF/MM commented that using some of the
things he has been developing for XFS subvolume support might be
interesting precisely because it could provide some of the facilities
currently provided by thin provisioning (perhaps not all of them; I'm
not sure how well his virtual block remapping layer would handle
hundreds of snapshots) but with file system tools which have a lot
more seasoning and where people have spent a lot of effort on data
recovery tools.

In any case, I do use DM quite a lot.  I use LVM2 and dm-snapshot (and
it's been working just *fine* for my use cases).  I've wanted to use
dm-thin, but have been put off by it being labeled as experimental and
by some of the comments about how robust its recovery tools are.  If
there was documentation about how an advanced user/developer could use
low level tools to do manual repair of a thin pool when the automated
procedures didn't work, without having to pay $$$ to some company for
"enterprise support", I'd be a lot more willing to give it a try.

Sorry, I just care a *lot* about data robustness.

> Maybe read your email from earlier today before repeating yourself:
> https://lkml.org/lkml/2018/8/4/366

Apologies.  I'm currently staying at an Assisted Living facility
keeping an eye on my Dad this week, and the internet at the senior
living center has been.... marginal.  As a result I've been reading my
e-mail in batches, and so I hadn't seen the e-mail you had posted
earlier before I had sent my reply.

					- Ted
