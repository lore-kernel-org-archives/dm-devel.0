From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2 12/12] multipathd: change failed get_uid
	handling
Date: Tue, 19 Mar 2019 12:20:25 -0500
Message-ID: <20190319172025.GJ13295@octiron.msp.redhat.com>
References: <1552086725-18476-1-git-send-email-bmarzins@redhat.com>
	<1552086725-18476-13-git-send-email-bmarzins@redhat.com>
	<2dca5572b832888c9494e102ccebf14dce320155.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2dca5572b832888c9494e102ccebf14dce320155.camel@suse.com>
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

On Fri, Mar 15, 2019 at 12:50:14PM +0100, Martin Wilck wrote:
> On Fri, 2019-03-08 at 17:12 -0600, Benjamin Marzinski wrote:
> > Instead of ignoring failed get_uid() calls, multipathd now fails the
> > path as it originally did.
> =

> This patch reverts much of 07/12; I'd appreciate if you could merge the
> two into one, that would make the review easier.
> =

> > However, if the result of calling get_uid()
> > is a blank wwid (which is always the case when it fails), multipathd
> > now
> > tries to get the wwid in check_path() as well, using the
> > uid_fallback()
> > methods to attempt to get a valid wwid.
> > =

> > Multipathd can't use the uid_attribute methods, since pp->udev still
> > has
> > the old uevent information with the uid_attribute of the original
> > wwid.
> =

> Which is actually wrong, IMO. It means that udev's (and the kernel's)
> view of the device are now different from multipathd's, and will remain
> so unless a new change event arrives. What bad can happen if we update
> pp->udev?

The thing is, this is almost definitely udev getting it wrong. There are
many types of path failure that keep udev from getting the path
information it is supposed to have, and udev timesout can do the same.
If something like that happens, udev will simply no longer have this
information. For instanace, ID_WWN won't be set, so if pathinfo ever
checked if that path should be blacklisted before it updates the udev
device again, it would blacklist the device. I think it's reasonable to
assume that the udev information that we already have is better than no
information. =

 =

> Perhaps we should rather update pp->udev always, and set the
> wwid_changed flag if necessary. The case wwid_changed=3D=3DWWID_ZEROED
> could be treated like INIT_MISSING_UDEV (it _is_ almost the same case,
> actually), by retriggering uevents.

If the issue was caused by a udev timeout because of a uevent storm,
firing off more uevents is counterproductive.

> > This means that the uid_attribute methods would always return the
> > original wwid, even if it had changed.
> > =

> > To make the get_uid() use the fallback methods, pathinfo now sets
> > pp->retriggers to the retrigger_tries once a WWID has be successfully
> > obtained, so that it uid_fallback() doesn't need to be called
> > retrigger_tries times before trying the fallback methods.
> =

> I don't like this much, see below.
> =

> =

> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/discovery.c |  4 +++-
> >  libmultipath/structs.h   |  6 ++++++
> >  multipathd/main.c        | 36 +++++++++++++++++++++++++-----------
> >  3 files changed, 34 insertions(+), 12 deletions(-)
> > =

> > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> > index bece67c..15568ca 100644
> > --- a/libmultipath/discovery.c
> > +++ b/libmultipath/discovery.c
> > @@ -2018,8 +2018,10 @@ int pathinfo(struct path *pp, struct config
> > *conf, int mask)
> >  		}
> >  	}
> >  =

> > -	if ((mask & DI_ALL) =3D=3D DI_ALL)
> > +	if ((mask & DI_ALL) =3D=3D DI_ALL) {
> > +		pp->retriggers =3D conf->retrigger_tries;
> >  		pp->initialized =3D INIT_OK;
> > +	}
> >  	return PATHINFO_OK;
> =

> This abuse of retrigger_tries looks like a hack to me. You want
> uid_fallback() to try and get a uid, even if retrigger_tries isn't
> exhausted. So you you should check another condition besides =

> (retriggers > retriggers_tries) in uid_callback().
> =

> At the very least, this would call for comments explaining the logic
> in both pathinfo() and uid_fallback(). I think you'd also have to set =

> retriggers =3D 0 when you set initialized =3D INIT_MISSING_UDEV
> (be it only for code clarity). But I'd prefer not to use the retrigger
> counter for this different condition.

Sure.
 =

> > [...]
> > @@ -2017,10 +2017,24 @@ check_path (struct vectors * vecs, struct
> > path * pp, int ticks)
> >  	if (newstate =3D=3D PATH_REMOVED)
> >  		newstate =3D PATH_DOWN;
> >  =

> > -	if (pp->wwid_changed) {
> > -		condlog(2, "%s: path wwid has changed. Refusing to
> > use",
> > -			pp->dev);
> > -		newstate =3D PATH_DOWN;
> > +	if (pp->wwid_changed !=3D WWID_SAME) {
> > +		if (pp->wwid_changed =3D=3D WWID_ZEROED) {
> > +			char wwid[WWID_SIZE];
> > +
> > +			strcpy(wwid, pp->wwid);
> > +			get_uid(pp, newstate, NULL);
> > +			if (strncmp(wwid, pp->wwid, WWID_SIZE) =3D=3D 0)
> > +				pp->wwid_changed =3D WWID_SAME;
> > +			else {
> > +				pp->wwid_changed =3D (strlen(pp->wwid))?
> > WWID_CHANGED : WWID_ZEROED;
> > +				strcpy(pp->wwid, wwid);
> > +			}
> > +		}
> > +		if (pp->wwid_changed !=3D WWID_SAME) {
> > +			condlog(2, "%s: path wwid has changed. Refusing
> > to use",
> > +				pp->dev);
> =

> Please don't log the same condition at -v2 in every check_path()
> iteration. We log the actual change at -v0 already in
> uev_update_path().

Sure.

-Ben

> Regards
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =
