From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 1/2] libmultipath: don't reject maps with
 undefined prio
Date: Wed, 28 Mar 2018 14:09:27 -0500
Message-ID: <20180328190927.GC3103@octiron.msp.redhat.com>
References: <20180321093419.9295-1-mwilck@suse.com>
	<20180322235225.GE3103@octiron.msp.redhat.com>
	<1521801022.13100.41.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1521801022.13100.41.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Mar 23, 2018 at 11:30:22AM +0100, Martin Wilck wrote:
> On Do, 2018-03-22 at 18:52 -0500, Benjamin Marzinski wrote:
> > On Wed, Mar 21, 2018 at 10:34:18AM +0100, Martin Wilck wrote:
> > > libmultipath's prio routines can deal with pp->priority =3D=3D
> > > PRIO_UNDEF
> > > just fine. PRIO_UNDEF is just a very low priority. So there's
> > > no reason to reject setting up a multipath map because paths have
> > > undefined priority.
> > > =

> > =

> > The problem with this is that presumably, if there is a prioritizer
> > set,
> > then the paths aren't supposed to be in the same pathgroup.  If this
> > is
> > the case and you end up setting all the paths to the same pathgroup
> > because the prioritizer is wrong, you will likely have a bad
> > experience.
> =

> Sure. This is obviously an unfortunate corner-case. The good news is
> that it happens very rarely. The default setting for prio is "const",
> which can't fail, so (disregarding FAILED paths) this can happen only
> for hardware that claims to support ALUA (or some other algorithm) but
> actually doesn't (or fails ALUA repeatedly). There's one concrete
> example of such hardware (certain variants of IBM IPR) that has
> motivated this patch.
> =

> The rationale for my patch is that multipath-tools currently behave
> inconsistently. Prio calls are allowed to fail. If prio detection works
> initially, but fails later for whatever reason (e.g. ALUA calls
> failing), multipathd handles that "gracefully" by assigning such paths
> PRIO_UNDEF =3D=3D -1. This "works fine" (your concerns apply) even if the
> prio call fails for every path of the map.
> =

> Likewise, even maps for which get_prio() always fails for every path
> can be set up manually, using "multipathd add map $WWID". The only case
> where multipath/multipathd refuse to set up this kind of map is
> coalesce_paths(), i.e. autodetection. We have an additional,
> undocumented "blacklist" criterion here - maps that fail get_prio, even
> if just for a single path, won't be set up automatically. That doesn't
> make a lot of sense to me.

I suppose I can't think of a case where this would cause things to go
badly, if everything is configured correctly. =


> =

> > Either you will frequently be writing to a non-optimized path (which
> > can
> > auto-trespass and become an optimized one in some arrays, causing
> > horrible ping-ponging), or some of your paths will just always keep
> > getting restored and then failed, since they require a manual
> > trespass
> > to be actually usable, but ghost paths are treated as usable by the
> > kernel.
> > =

> > If you just set the priortizer for this device to const (or whatever
> > make sense if the device isn't alua) and have detect_prio enabled,
> > won't
> > it correctly detect an alua prioritizer when it is supported, and
> > failback to const when not?
> =

> My first idea was similar, but no, AFAICS that doesn't happen. Once you
> change pp->prio, it remains "const" until the next reconfigure(), which
> may mean "never". Therefore my patch (v2) doesn't touch pp->prio. If
> the failure is temporary, pp->priority will eventually be re-calculated =

> correctly (note that get_prio() is always called by pathinfo() if =

> pp->priority =3D=3D PRIO_UNDEF). If the failure is permanent, pp->priority
> stays at "const -1", and that's ok.

Maybe I'm being thick-headed here, but I still don't understand what's
wrong with setting the prioritizer to const for this problematic array.
If the array really does support ALUA, then it will be configured with
ALUA, and you don't ever want it to change. If it doesn't, then the prio
will remain const, and again, you don't want it to change.  Are you
worried that there might be a temporary ALUA failure, setting the array
to const, when it should be configured as ALUA.  In that case, it seems
like we're try to deal with a pathological failure on a pathological
array, which doesn't seem that useful.

At any rate, since I don't see how this could break well behaved
devices configured correctly.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> It would be possible to create a complex solution with multiple
> prioritizers and fallback algorithms, but IMHO that would be
> overengineered for a rare and rather pathological case like this.
> =

> Regards,
> Martin
> =

> > =

> > -Ben
> > =

> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  libmultipath/configure.c | 5 -----
> > >  1 file changed, 5 deletions(-)
> > > =

> > > diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> > > index fa6e21cb31af..bb3d8771592d 100644
> > > --- a/libmultipath/configure.c
> > > +++ b/libmultipath/configure.c
> > > @@ -993,9 +993,6 @@ int coalesce_paths (struct vectors * vecs,
> > > vector newmp, char * refwwid,
> > >  			continue;
> > >  		}
> > >  =

> > > -		if (pp1->priority =3D=3D PRIO_UNDEF)
> > > -			mpp->action =3D ACT_REJECT;
> > > -
> > >  		if (!mpp->paths) {
> > >  			condlog(0, "%s: skip coalesce (no paths)",
> > > mpp->alias);
> > >  			remove_map(mpp, vecs, 0);
> > > @@ -1021,8 +1018,6 @@ int coalesce_paths (struct vectors * vecs,
> > > vector newmp, char * refwwid,
> > >  					mpp->size);
> > >  				mpp->action =3D ACT_REJECT;
> > >  			}
> > > -			if (pp2->priority =3D=3D PRIO_UNDEF)
> > > -				mpp->action =3D ACT_REJECT;
> > >  		}
> > >  		verify_paths(mpp, vecs);
> > >  =

> > > -- =

> > > 2.16.1
> > =

> > =

> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
