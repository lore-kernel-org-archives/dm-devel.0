From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH v5 08/12] block: Introduce new bio_split()
Date: Mon, 13 Aug 2012 14:55:11 -0700
Message-ID: <20120813215511.GE9541@google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-9-git-send-email-koverstreet@google.com>
 <20120808225839.GG6983@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120808225839.GG6983@dhcp-172-17-108-109.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
List-Id: dm-devel.ids

On Wed, Aug 08, 2012 at 03:58:39PM -0700, Tejun Heo wrote:
> On Mon, Aug 06, 2012 at 03:08:37PM -0700, Kent Overstreet wrote:
> > + *
> > + * BIG FAT WARNING:
> > + *
> > + * If you're calling this from under generic_make_request() (i.e.
> > + * current->bio_list != NULL), you should mask out __GFP_WAIT and punt to
> > + * workqueue if the allocation fails. Otherwise, your code will probably
> > + * deadlock.
> 
> If the condition is detectable, WARN_ON_ONCE() please.

I know I said I liked this idea, but I changed my mind.

Sticking a WARN_ON_ONCE() there is saying that passing __GFP_WAIT from
under generic_make_request() is always wrong - it might as well be a
BUG_ON() except warn is better for the user.

If that's true, then an assertion is completely wrong because we can
just do the right thing instead - mask out __GFP_WAIT if
current->bio_list != NULL and document that it can fail in that
situation.

Which is what my original code did.

The alternative is accepting that there are situations where it is
technically possible to pass __GFP_WAIT from under
generic_make_request() without deadlocking and allow it, but my position
is still that that is far too subtle to expect that it'll be gotten
right (especially considering the ways that the code is wrong today
wrt deadlocks).

But honestly this is turning into bikeshedding. The current bio
splitting and merge_bvec_fn stuff is crap, and there are worse potential
deadlocks/bugs in the existing code than what we're arguing over here.
