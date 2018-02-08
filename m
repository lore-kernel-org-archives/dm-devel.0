From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 3/7] multipathd: remove coalesce_paths from
	ev_add_map
Date: Thu, 8 Feb 2018 12:00:43 -0600
Message-ID: <20180208180043.GR14513@octiron.msp.redhat.com>
References: <1518043787-7066-1-git-send-email-bmarzins@redhat.com>
	<1518043787-7066-4-git-send-email-bmarzins@redhat.com>
	<1518081038.15245.47.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1518081038.15245.47.camel@suse.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 08, 2018 at 10:10:38AM +0100, Martin Wilck wrote:
> Hi Ben,
> =

> On Wed, 2018-02-07 at 16:49 -0600, Benjamin Marzinski wrote:
> > If ev_add_map is called for a multipath device that doesn't exist in
> > device-mapper, it will call coalesce_paths to add it.  This doesn't
> > work
> > and hasn't for years. It doesn't add the map to the mpvec, or start
> > up
> > waiters, or do any of the necessary things that do get done when you
> > call ev_add_map for a map that does exist in device mapper.
> > =

> > Fortunately, there are only two things that call ev_add_map.
> > uev_add_map
> > makes sure that the device does exist in device-mapper before calling
> > ev_add_map, and cli_add_map creates the device first and then calls
> > ev_add_map, if the device doesn't exist.
> > =

> > So, there is no reason for coalesce_paths to be in ev_add_map. This
> > removes it.
> =

> Basically ACK, but see below.
> =

> I'd recommend to add a comment that ev_add_map() expects the map to be
> set up already, and that callers need to take care of that.

Sure.
 =

> > =

> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  multipathd/main.c | 41 +++++++++--------------------------------
> >  1 file changed, 9 insertions(+), 32 deletions(-)
> > =

> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 27cf234..cf76241 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -415,15 +415,11 @@ uev_add_map (struct uevent * uev, struct
> > vectors * vecs)
> >  int
> >  ev_add_map (char * dev, char * alias, struct vectors * vecs)
> >  {
> > -	char * refwwid;
> >  	struct multipath * mpp;
> > -	int map_present;
> > -	int r =3D 1, delayed_reconfig, reassign_maps;
> > +	int delayed_reconfig, reassign_maps;
> >  	struct config *conf;
> >  =

> > -	map_present =3D dm_map_present(alias);
> > -
> > -	if (map_present && !dm_is_mpath(alias)) {
> > +	if (!dm_is_mpath(alias)) {
> >  		condlog(4, "%s: not a multipath map", alias);
> >  		return 0;
> >  	}
> > @@ -468,33 +464,14 @@ ev_add_map (char * dev, char * alias, struct
> > vectors * vecs)
> >  	/*
> >  	 * now we can register the map
> >  	 */
> > -	if (map_present) {
> > -		if ((mpp =3D add_map_without_path(vecs, alias))) {
> > -			sync_map_state(mpp);
> > -			condlog(2, "%s: devmap %s registered",
> > alias, dev);
> > -			return 0;
> > -		} else {
> > -			condlog(2, "%s: uev_add_map failed", dev);
> > -			return 1;
> > -		}
> > -	}
> > -	r =3D get_refwwid(CMD_NONE, dev, DEV_DEVMAP, vecs->pathvec,
> > &refwwid);
> > -
> > -	if (refwwid) {
> > -		r =3D coalesce_paths(vecs, NULL, refwwid,
> > FORCE_RELOAD_NONE,
> > -				   CMD_NONE);
> > -		dm_lib_release();
> > +	if ((mpp =3D add_map_without_path(vecs, alias))) {
> > +		sync_map_state(mpp);
> > +		condlog(2, "%s: devmap %s registered", alias, dev);
> > +		return 0;
> =

> This is unrelated to your patch, but add_map_without_path() calls
> setup_map() and domap() without checking whether that's necessary.
> That seems to be an odd thing to do when an uevent for existing map is
> received. We should be adjusting multipathd's internal data structures
> with the data from the kernel, not vice versa.

I'm not convinced that this is correct. First, as soon as another path
is added or removed, or multipathd is reconfigured, we will reset the
device to the way that multipathd thinks it should be. Second multipathd
might really know better how to set up a device right away. For
instance, multipath may not know about some paths because they
currently are down, but multipathd will know that they belong to the
device and adopt them in setup_map(). =

 =

> While working on this, we may want to fix that, too.
> =

> > +	} else {
> > +		condlog(2, "%s: uev_add_map failed", dev);
> > +		return 1;
> >  	}
> =

> While you're at it, please fix this log message ("uev_add_map").

Sure.
 =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
