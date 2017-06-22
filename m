From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v3 11/11] libmultipath: don't [un]set
 queue_if_no_path after domap
Date: Thu, 22 Jun 2017 14:21:29 -0500
Message-ID: <20170622192129.GP2940@octiron.msp.redhat.com>
References: <20170621150630.25773-1-mwilck@suse.com>
	<20170621150630.25773-12-mwilck@suse.com>
	<fb72a1ed-58c6-fa6d-9411-8c03ce9541b7@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <fb72a1ed-58c6-fa6d-9411-8c03ce9541b7@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

On Thu, Jun 22, 2017 at 08:23:44AM +0200, Hannes Reinecke wrote:
> On 06/21/2017 05:06 PM, Martin Wilck wrote:
> > We set the queue_if_no_path feature in assemble_map() already,
> > no need to set it here again.
> > =

> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  libmultipath/configure.c | 15 ---------------
> >  1 file changed, 15 deletions(-)
> > =

> > diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> > index 55dbb261..39912f05 100644
> > --- a/libmultipath/configure.c
> > +++ b/libmultipath/configure.c
> > @@ -1097,21 +1097,6 @@ int coalesce_paths (struct vectors * vecs, vecto=
r newmp, char * refwwid,
> >  				remove_feature(&mpp->features,
> >  					       "queue_if_no_path");
> >  		}
> > -		else if (mpp->no_path_retry !=3D NO_PATH_RETRY_UNDEF) {
> > -			if (mpp->no_path_retry =3D=3D NO_PATH_RETRY_FAIL) {
> > -				condlog(3, "%s: unset queue_if_no_path feature",
> > -					mpp->alias);
> > -				if (!dm_queue_if_no_path(mpp->alias, 0))
> > -					remove_feature(&mpp->features,
> > -						       "queue_if_no_path");
> > -			} else {
> > -				condlog(3, "%s: set queue_if_no_path feature",
> > -					mpp->alias);
> > -				if (!dm_queue_if_no_path(mpp->alias, 1))
> > -					add_feature(&mpp->features,
> > -						    "queue_if_no_path");
> > -			}
> > -		}
> >  =

> >  		if (!is_daemon && mpp->action !=3D ACT_NOTHING) {
> >  			conf =3D get_multipath_config();
> > =

> Watch out.
> 'queue_if_no_path' is set _temporarily_ while 'no_path_retry' is active,
> and removed afterwards.
> So there might be valid reasons why it's set here.
> Have you checked?

IIRC, we used to always set queue_if_no_path before reloading the map,
and then call setup_multipath() afterwards, which would call
set_no_path_retry() to set it to the actual correct value. If we are
correctly setting the feature line when we reload the map, that's a
better solution. Obviously, we can't strip set_no_path_retry() out of
__setup_multipath() since we rely on that to deal with deal with going
into recovery mode. However, without some more thought and code reading,
I'm not sure if we do still need the calls to dm_queue_if_no_path()
there for some other reason anymore.  At any rate, they won't hurt
anything, except for causing a redundant call to device-mapper.

Also, if we're yanking these dm_queue_if_no_path() calls from
coalesce_paths, I don't see why we need them in reload_map(), where they
also seem redundant if we just correctly set the features argument when
we reloaded the table.

ACK, but I wouldn't mind seeing the calls pulled from reload_map as
well.

-Ben

> =

> Cheers,
> =

> Hannes
> -- =

> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)
