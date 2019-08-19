From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 03/16] tests: add path grouping policy unit
	tests.
Date: Mon, 19 Aug 2019 09:34:56 +0000
Message-ID: <bfff8ddfdde38982d9d8588f068fb089764a58f0.camel@suse.com>
References: <1564763622-31752-1-git-send-email-bmarzins@redhat.com>
	<1564763622-31752-4-git-send-email-bmarzins@redhat.com>
	<7840aab31dd06de729f124af98da3498e0256556.camel@suse.com>
	<20190816210158.GI25414@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190816210158.GI25414@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <F7E749A13AF4A44389B92B82BF4C4FD9@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "mkumar@redhat.com" <mkumar@redhat.com>
List-Id: dm-devel.ids

On Fri, 2019-08-16 at 16:01 -0500, Benjamin Marzinski wrote:
> On Wed, Aug 14, 2019 at 09:22:17PM +0000, Martin Wilck wrote:
> > On Fri, 2019-08-02 at 11:33 -0500, Benjamin Marzinski wrote:
> > > In preparation for changing the path grouping code, add some unit
> > > tests
> > > to verify that it works correctly. The only test that currently
> > > fails
> > > (and so it being skipped) is using MULTIBUS when mp->paths is
> > > empty.
> > > All
> > > the other path grouping policies free mp->paths, even if it is
> > > empty.
> > > one_group() should as well. This will be fixed when the path
> > > grouping
> > > code is updated.
> > > 
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > >  tests/Makefile   |   2 +-
> > >  tests/pgpolicy.c | 708
> > > +++++++++++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 709 insertions(+), 1 deletion(-)
> > >  create mode 100644 tests/pgpolicy.c
> > > 
> > > +
> > > +static void test_group_by_node_name_3_groups4(void **state)
> > > +{
> > > +	char *node_name[] = {"a","b","c","a"};
> > > +	int prio[] = {3,1,3,1};
> > > +	int group0[] = {2};
> > > +	int group1[] = {0,3};
> > > +	int group2[] = {1};
> > > +	int *groups[] = {group0, group1, group2};
> > > +	int group_size[] = {1,2,1};
> > > +
> > > +	set_priority(p4, prio, 4);
> > > +	set_tgt_node_name(p4, node_name, 4);
> > > +	assert_int_equal(group_by_node_name(&mp4), 0);
> > > +	verify_pathgroups(&mp4, p4, groups, group_size, 3);
> > > +}
> > 
> > Nothing wrong with your code, but this is one example where I would
> > say
> > our prio group ordering is counter-intuitive. Does it really make
> > sense
> > to order the group of two paths with prio {3, 1} *after* the group
> > with
> > just one prio 3 path?
> 
> That's kind of tricky, because with the round-robin path selector,
> just
> having one fast path in the group might be the correct answer, while
> with the dynamic path selectors, it seems like having both paths
> would
> be better.

FTR, the semantics were changed from summing to averaging almost
exactly 10 years ago:

91270ef "Use Average path priority value for path switching"

At the time, the patch author's rationale (blessed by Hannes' approval)
was that a group of 1 x prio=8 should not have higher precedence than a
group of 2 x 3 (details in 
https://dm-devel.redhat.narkive.com/dmvqjPHA/rdac-priority-checker-changing-priorities). 
While in the specific case the argument was valid, I doubt that it
applies in all situations.

>  My person issue with out path grouping is that I don't think
> that what group_by_prio is what many devices want.  For many devices,
> the paths are going to be grouped by something static, like what
> controller the paths go to.

True. In most situation that I have seen, "group_by_prio" is basically
a way to express storage states such as ALUA "optimized" vs. "non-
optimized" and "preferred". For a while I've been pondering to use
these states for grouping directly rather than the priorities derived
from them. So far I haven't come down to it.

Regards,
Martin


>   In that case, all the overhead of remaking
> that pathgroups whenever the priority changes is a bunch of wasted
> overhead. Also, it can cause situations where is multipathd notices
> a priority change at the wrong moment, it will temporarily make
> garbage
> pathgroups, with some paths using their old priority, and some using
> their new priority (which multipathd hasn't noticed yet).



> 
> -Ben
> 
> > Regards,
> > Martin
> > 
