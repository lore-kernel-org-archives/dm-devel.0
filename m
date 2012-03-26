From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm thin: fix pool target flags that control discard
Date: Mon, 26 Mar 2012 11:33:41 -0400
Message-ID: <20120326153341.GA4022@redhat.com>
References: <20120316152156.GA8836@ubuntu>
	<1331911358-8848-1-git-send-email-ejt@redhat.com>
	<1331911358-8848-11-git-send-email-ejt@redhat.com>
	<20120323123747.GB16214@agk-dp.fab.redhat.com>
	<20120323215502.GB11054@redhat.com> <20120326141520.GA24249@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120326141520.GA24249@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Mon, Mar 26 2012 at 10:15am -0400,
Joe Thornber <thornber@redhat.com> wrote:

> On Fri, Mar 23, 2012 at 05:55:02PM -0400, Mike Snitzer wrote:
> > On Fri, Mar 23 2012 at  8:37am -0400,
> > Alasdair G Kergon <agk@redhat.com> wrote:
> > 
> > > On Fri, Mar 16, 2012 at 03:22:34PM +0000, Joe Thornber wrote:
> > > > +      'ignore_discard': disable discard support
> > > > +      'no_discard_passdown': don't pass discards down to the underlying data device
> > > 
> > > If someone reloads the pool target changing either of these options, how do connected
> > > thin targets pick up the change?  If they don't pick it up automatically, how do you
> > > determine whether they did or didn't pick it up - is that internal state not
> > > exposed to userspace yet?
> > 
> > Here are various fixes for dm_thin-add-pool-target-flags-to-control-discard.patch
> > 
> > o wire up 'discard_passdown' so that it does control whether or not the
> >   discard is passed to the pool's underlying data device
> 
> This already works, see test_{enable,disable}_passdown() tests here:
> 
>   https://github.com/jthornber/thinp-test-suite/blob/master/discard_tests.rb
> 
> You've got to remember that there are 2 different interacting targets:
> 
>  i) discard enabled in the 'thin' target will cause mappings to be removed from the btree.
> 
>  ii) discard enabled in the 'pool' device will cause discards to be passed down.
> 
> The following logic is in the pool_ctr:
> 
>         if (pf.discard_enabled && pf.discard_passdown) {
>                 ti->discards_supported = 1;
>                 ti->num_discard_requests = 1;
>         }

We reasoned through this already, your code did work.  But for the
benefit of others this is why it worked:

thin will process_discard() via bio being deferring in thin_bio_map() --
provided pf.discard_enabled.  Then thin will pass the discard on to the
pool device regardless of pf.discard_passdown.  dm-core will then drop
the discard because ti->num_discard_requests is 0; but that results in
-EOPNOTSUPP.

Thing is, we don't want to return -EOPNOTSUPP if passdown was disabled.
So I think my change is an improvement (because process_prepared_discard
will now properly bio_endio(m->bio, 0) the discard).

> > o disallow disabling discards if a pool was already configured with
> >   discards enabled (the default)
> >   - justification is inlined in the code
> >   - required pool_ctr knowing whether pool was created or not; so added
> >     'created' flag to __pool_find()
> 
> ack, this needs fixing.

We've discussed that it is easier to just disallow changing discard
configuration.  And that there was a bug in my early return.  So you'll
be sending a follow-up fixup patch.

> > o if 'discard_passdown' is enabled (the default) verify that the pool's
> >   data device supports discards; if not warn and disable discard_passdown
> 
> Why?  Do other targets do this?  (no)

The thin target is the first target to use ti->discards_supported.
Setting that will cause dm_table_supports_discards to skip checking if
the target's underlying device(s) natively support discards.

So passdown needs to only be allowed if the underlying data device
supports discard -- otherwise we'll get a bunch of failed discards from
the SCSI layer, etc.

> > o the pool device's discard support should _not_ be limited by whether
> >   'discard_passdown' is enabled or not.
> 
> Yes it should.

Yeah, like I said above your approach works (except for the
-EOPNOTSUPP).  I just happen to prefer dm-thin taking a more active role
by short-circuting the discard_passdown directly.
