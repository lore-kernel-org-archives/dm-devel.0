From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 03/16] tests: add path grouping policy unit
	tests.
Date: Fri, 16 Aug 2019 16:01:58 -0500
Message-ID: <20190816210158.GI25414@octiron.msp.redhat.com>
References: <1564763622-31752-1-git-send-email-bmarzins@redhat.com>
	<1564763622-31752-4-git-send-email-bmarzins@redhat.com>
	<7840aab31dd06de729f124af98da3498e0256556.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <7840aab31dd06de729f124af98da3498e0256556.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "mkumar@redhat.com" <mkumar@redhat.com>
List-Id: dm-devel.ids

On Wed, Aug 14, 2019 at 09:22:17PM +0000, Martin Wilck wrote:
> On Fri, 2019-08-02 at 11:33 -0500, Benjamin Marzinski wrote:
> > In preparation for changing the path grouping code, add some unit
> > tests
> > to verify that it works correctly. The only test that currently fails
> > (and so it being skipped) is using MULTIBUS when mp->paths is empty.
> > All
> > the other path grouping policies free mp->paths, even if it is empty.
> > one_group() should as well. This will be fixed when the path grouping
> > code is updated.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  tests/Makefile   |   2 +-
> >  tests/pgpolicy.c | 708
> > +++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 709 insertions(+), 1 deletion(-)
> >  create mode 100644 tests/pgpolicy.c
> > 
> > +
> > +static void test_group_by_node_name_3_groups4(void **state)
> > +{
> > +	char *node_name[] = {"a","b","c","a"};
> > +	int prio[] = {3,1,3,1};
> > +	int group0[] = {2};
> > +	int group1[] = {0,3};
> > +	int group2[] = {1};
> > +	int *groups[] = {group0, group1, group2};
> > +	int group_size[] = {1,2,1};
> > +
> > +	set_priority(p4, prio, 4);
> > +	set_tgt_node_name(p4, node_name, 4);
> > +	assert_int_equal(group_by_node_name(&mp4), 0);
> > +	verify_pathgroups(&mp4, p4, groups, group_size, 3);
> > +}
> 
> Nothing wrong with your code, but this is one example where I would say
> our prio group ordering is counter-intuitive. Does it really make sense
> to order the group of two paths with prio {3, 1} *after* the group with
> just one prio 3 path?

That's kind of tricky, because with the round-robin path selector, just
having one fast path in the group might be the correct answer, while
with the dynamic path selectors, it seems like having both paths would
be better. My person issue with out path grouping is that I don't think
that what group_by_prio is what many devices want.  For many devices,
the paths are going to be grouped by something static, like what
controller the paths go to.  In that case, all the overhead of remaking
that pathgroups whenever the priority changes is a bunch of wasted
overhead. Also, it can cause situations where is multipathd notices
a priority change at the wrong moment, it will temporarily make garbage
pathgroups, with some paths using their old priority, and some using
their new priority (which multipathd hasn't noticed yet).

-Ben

> 
> Regards,
> Martin
> 
