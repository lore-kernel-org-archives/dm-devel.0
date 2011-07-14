From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm table: simplify discard support processing
Date: Thu, 14 Jul 2011 12:11:23 -0400
Message-ID: <20110714161122.GC12049@redhat.com>
References: <20110714143037.GA12049@redhat.com> <4E1F0EB3.9010004@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4E1F0EB3.9010004@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jul 14 2011 at 11:43am -0400,
Milan Broz <mbroz@redhat.com> wrote:

> On 07/14/2011 04:30 PM, Mike Snitzer wrote:
> > Remove 'discards_supported' from the dm_table structure.  The same
> > information can be easily discovered from the table's target(s) in
> > dm_table_supports_discards().
> > 
> > Also DMWARN if a target sets 'discards_supported' override but forgets
> > to set 'num_discard_requests'.
> 
> Why not BUG_ON? It is bug in code on static attribute, isn't? :-)

Because we don't _need_ to BUG the system over programmer error for
how that target implements discards (given discard support is basically
optional, sometimes nice to have, increasingly nice to have in future).

> > @@ -1426,6 +1422,9 @@ bool dm_table_supports_discards(struct dm_table *t)
> >  	while (i < dm_table_get_num_targets(t)) {
> >  		ti = dm_table_get_target(t, i++);
> >  
> > +		if (!ti->num_discard_requests)
> > +			return 0;
> > +		
> 
> >  		if (ti->discards_supported)
> >  			return 1;
> 
> What if next target has ti->num_discard_requests = 0 here?
> Shouldn't it loop through the all targets always?

Yes it should, but I'm not sure if we are on the same page as to why.

Background:
If a table has a target with discards_supported=1 then the final DM
device's queue must export the ability to handle discards.  But only
targets with num_discard_requests>0 will actually have discards past to
them.

ti->discards_supported is used for targets like thinp.  Even if the the
thinp pool's underlying data device doesn't support discards the 'thin'
and 'thin-pool' targets do.

So back to the original question: yes, we need to look at all targets to
make sure that one of them doesn't have discards_supported set.

I'll fix this up and send v2.

Thanks,
Mike
