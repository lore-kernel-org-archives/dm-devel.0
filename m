From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v3 19/19] libmultipath: Fixup updating paths
Date: Fri, 5 Oct 2018 15:32:21 -0500
Message-ID: <20181005203221.GG3172@octiron.msp.redhat.com>
References: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
	<1537571127-10143-20-git-send-email-bmarzins@redhat.com>
	<1ec6d9dbdab329d9125ee380790933b7dfab804a.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1ec6d9dbdab329d9125ee380790933b7dfab804a.camel@suse.com>
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

On Tue, Oct 02, 2018 at 12:30:51AM +0200, Martin Wilck wrote:
> On Fri, 2018-09-21 at 18:05 -0500, Benjamin Marzinski wrote:
> > Commit 582c56cc broke some code paths in uev_update_path. First, it
> > changed the handling of paths that were not fully initialized.
> > uev_update_path was simply setting the wwids for all of these paths.
> > Instead, it should ignore the ones that had not requested a new
> > uevent.
> > These paths are likely down, and are already getting handled by
> > check_path, after it verifies that they have become active. Also,
> > setting the wwid doesn't update all of the other information that
> > may have been missed when the path was initially added.
> > =

> > Also, it wasn't possible for pp->wwid_changed to transition back to
> > zero, unless the path's wwid was empty, in which case there was no
> > reason to worry about the wwid change in the first place, since the
> > path
> > hadn't been fully initialized yet. So, even if a path's wwid changed
> > and
> > then changed back to the original value, the path still could not be
> > used.
> > =

> > This patch fixes these issues, and also moves the check for paths
> > that
> > have requested a new uevent up in the functions. These paths will get
> > fully reinitialized anyway, so there is no reason to do all the other
> > work first.
> > =

> > Fixes: 582c56cc ("libmultipath: uev_update_path: always warn if WWID
> > changed")
> > =

> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> =

> Thanks for fixing this. Looking at the cleaned-up logic after this
> patch, I believe that we should hard-code "disable_changed_wwids" to 1.
> It's crazy to realize that a path WWID has changed and simply go on as
> if nothing had happened. We shouldn't allow this configuration any
> more.

I'm fine with defaulting disable_changed_wwids to 1.

-Ben

> =

> Reviewed-by: Martin Wilck <mwilck@suse.com>
> =

> > ---
> >  multipathd/main.c | 24 ++++++++++++++----------
> >  1 file changed, 14 insertions(+), 10 deletions(-)
> > =

> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 61ca455..d6d122a 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -1207,6 +1207,15 @@ uev_update_path (struct uevent *uev, struct
> > vectors * vecs)
> >  		struct multipath *mpp =3D pp->mpp;
> >  		char wwid[WWID_SIZE];
> >  =

> > +		if (pp->initialized =3D=3D INIT_REQUESTED_UDEV) {
> > +			needs_reinit =3D 1;
> > +			goto out;
> > +		}
> > +		/* Don't deal with other types of failed initialization
> > +		 * now. check_path will handle it */
> > +		if (!strlen(pp->wwid))
> > +			goto out;
> > +
> >  		strcpy(wwid, pp->wwid);
> >  		get_uid(pp, pp->state, uev->udev);
> >  =

> > @@ -1215,9 +1224,8 @@ uev_update_path (struct uevent *uev, struct
> > vectors * vecs)
> >  				uev->kernel, wwid, pp->wwid,
> >  				(disable_changed_wwids ? "disallowing"
> > :
> >  				 "continuing"));
> > -			if (disable_changed_wwids &&
> > -			    (strlen(wwid) || pp->wwid_changed)) {
> > -				strcpy(pp->wwid, wwid);
> > +			strcpy(pp->wwid, wwid);
> > +			if (disable_changed_wwids) {
> >  				if (!pp->wwid_changed) {
> >  					pp->wwid_changed =3D 1;
> >  					pp->tick =3D 1;
> > @@ -1225,11 +1233,9 @@ uev_update_path (struct uevent *uev, struct
> > vectors * vecs)
> >  						dm_fail_path(pp->mpp-
> > >alias, pp->dev_t);
> >  				}
> >  				goto out;
> > -			} else if (!disable_changed_wwids)
> > -				strcpy(pp->wwid, wwid);
> > -			else
> > -				pp->wwid_changed =3D 0;
> > +			}
> >  		} else {
> > +			pp->wwid_changed =3D 0;
> >  			udev_device_unref(pp->udev);
> >  			pp->udev =3D udev_device_ref(uev->udev);
> >  			conf =3D get_multipath_config();
> > @@ -1240,9 +1246,7 @@ uev_update_path (struct uevent *uev, struct
> > vectors * vecs)
> >  			pthread_cleanup_pop(1);
> >  		}
> >  =

> > -		if (pp->initialized =3D=3D INIT_REQUESTED_UDEV)
> > -			needs_reinit =3D 1;
> > -		else if (mpp && ro >=3D 0) {
> > +		if (mpp && ro >=3D 0) {
> >  			condlog(2, "%s: update path write_protect to
> > '%d' (uevent)", uev->kernel, ro);
> >  =

> >  			if (mpp->wait_for_udev)
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =
