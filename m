From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 66/74] libmultipath: update_pathvec_from_dm:
 handle pp->mpp mismatch
Date: Wed, 05 Aug 2020 21:44:40 +0200
Message-ID: <b74c9d674b40d6efe889fadfd005758e79dc4d8d.camel@suse.com>
References: <20200709105145.9211-1-mwilck@suse.com>
	<20200709105145.9211-14-mwilck@suse.com>
	<20200719051200.GX11089@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200719051200.GX11089@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, 2020-07-19 at 00:12 -0500, Benjamin Marzinski wrote:
> On Thu, Jul 09, 2020 at 12:51:37PM +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > Treat this like a WWID mismatch.
> > 
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  libmultipath/structs_vec.c | 37 +++++++++++++++++++++++-----------
> > ---
> >  1 file changed, 23 insertions(+), 14 deletions(-)
> > 
> > diff --git a/libmultipath/structs_vec.c
> > b/libmultipath/structs_vec.c
> > index 5dd37d5..8651b98 100644
> > --- a/libmultipath/structs_vec.c
> > +++ b/libmultipath/structs_vec.c
> > 
> > [...]
> > +		bad_path:
> > +			/*
> > +			 * This path exists, but in the wrong map.
> > +			 * We can't reload the map from here.
> > +			 * Instead, treat this path like "missing
> > udev".
> > +			 * check_path() will trigger an uevent and
> > reset pp->tick.
> > +			 */
> > +			must_reload = true;
> > +			pp->mpp = NULL;
> > +			dm_fail_path(mpp->alias, pp->dev_t);
> > +			vector_del_slot(pgp->paths, j--);
> > +			pp->initialized = INIT_MISSING_UDEV;
> > +			pp->tick = 1;
> 
> Is there a reason not to call orphan_path() to clean up things like
> any
> open fd, until we figure out what to do with the path.

Thanks for the suggestion. It makes sense for the 2nd "bad_path"
condition but not for the first. I'll treat the two cases differently.

Regards
Martin
