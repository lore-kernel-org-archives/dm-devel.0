From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt: remove per-cpu structure
Date: Sat, 22 Feb 2014 09:25:27 -0500
Message-ID: <20140222142526.GA12207@redhat.com>
References: <alpine.LRH.2.02.1402201758190.28312@file01.intranet.prod.int.rdu2.redhat.com>
	<20140220235935.GA32743@redhat.com>
	<alpine.LRH.2.02.1402201907120.29698@file01.intranet.prod.int.rdu2.redhat.com>
	<20140221023240.GA338@redhat.com>
	<alpine.LRH.2.02.1402210238470.5846@file01.intranet.prod.int.rdu2.redhat.com>
	<53087BD3.1000900@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <53087BD3.1000900@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Lisa Du <chunlingdu1@gmail.com>, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Sat, Feb 22 2014 at  5:28am -0500,
Milan Broz <gmazyland@gmail.com> wrote:

> On 02/21/2014 08:41 AM, Mikulas Patocka wrote:
> >>>> Hi Mikulas,
> >>>>
> >>>> Obviously avoiding crashes is more important than performance.
> 
> Yes, but please keep these changes in linux-next for a while
> before submitting this for stable or you will fix one rare bug and
> slow down all existing users (with possible another fix to fix later)...
> 
> I know that taking cpu offline becomes more used these days
> but still the performance is critical attribute for dmcrypt.
> 
> (And IIRC this cpu work relocation problem is there for years.)

Unfortunately, we cannot leave the code in its current state.  Sure it
has been this way for years but taking cpus offline is _much_ more
common.

As I said here:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=fba2d94c5e0f3d848792981977b1f62ce96377ac

This change may undermine performance improvements intended by commit
c0297721 ("dm crypt: scale to multiple cpus").  But correctness is more
important than performance.  The use of per-cpu structures may be
revisited later (by using cpu hot-plug notifiers to make them safe).

> >>>> But are we losing performance by switching away from using percpu?  Do
> >>>> we care?  I'd like to see the header to speak to the potential for
> >>>> slowdown (if there is any).
> >>>
> >>> There is one more allocation per request than before. I don't know how 
> >>> much does it cost.
> 
> Could you please try it on some test machine in lab? I think Red Hat has
> enough usable machines for such tests.
> 
> >> OK, any reason you didn't fix this up by using cpu hotplug hooks like
> >> Tejun suggested?  Too complicated?
> > 
> > Yes, it would complicate the code. The patch that removes percpu pointers 
> > shortens the file, using cpu hot-plug hooks would make it bigger.
> 
> Since we prefer source file size to correct solution?

Right, that was my thought too.  Definitely not a good enough
justification.  But a proper fix with cpu hot-plug notifier is more
involved for sure.  It will take time.

Do you have time to look at fixing this issue?

> That said, dmcrypt becomes already too big. I already thought about separating
> some things (keeping the core functionality in one place), e.g. IV generators
> implementation is something what could be logically separated.
> (Is it worth to do it?)
> 
> >>> We could also modify the code to use per_bio_data to save one allocation.
> >>
> >> OK, sounds like a good win.  Can you write a separate followup patch
> >> that makes use of per_bio_data?
> > 
> > I will try it.
> 
> If you have some performance numbers, post it as well please.
> (I would not be surprised that removing percpu struct is sometimes even better
> for performance but this is just wild guess.)
> 
> And if you have better solution to dmcrypt parallel performance, post it too
> but with real hw (with and without crypto acceleration) speed up numbers please. ;-)

Mikulas does have an alternative approach that should be revisited ASAP
given that it also fixes this cpu hotplug issue:
http://people.redhat.com/mpatocka/patches/kernel/dm-crypt-paralelizace/current/series.html

context/timeline:
http://www.redhat.com/archives/dm-devel/2011-October/msg00127.html
http://www.redhat.com/archives/dm-devel/2012-March/msg00181.html
http://www.redhat.com/archives/dm-devel/2013-March/msg00103.html

Christoph pointed out there is precendence for sorting:
http://www.redhat.com/archives/dm-devel/2013-March/msg00104.html

Even though you actively resisted it:
http://www.redhat.com/archives/dm-devel/2013-March/msg00107.html

Progress on improving dm-crypt is long overdue, I'd like to see Mikulas
rebase/repost/retest his dm-crypt parallelization patchset for 3.15 or
3.16.

Mike
