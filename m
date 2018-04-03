From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 1/2] libmultipath: hwhandler auto-detection
	for ALUA
Date: Tue, 3 Apr 2018 16:29:58 -0500
Message-ID: <20180403212958.GH3103@octiron.msp.redhat.com>
References: <20180327215053.3631-1-mwilck@suse.com>
	<20180327215053.3631-2-mwilck@suse.com>
	<20180403203132.GF3103@octiron.msp.redhat.com>
	<1522788809.3801.109.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1522788809.3801.109.camel@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

On Tue, Apr 03, 2018 at 10:53:29PM +0200, Martin Wilck wrote:
> On Tue, 2018-04-03 at 15:31 -0500, Benjamin Marzinski wrote:
> > On Tue, Mar 27, 2018 at 11:50:52PM +0200, Martin Wilck wrote:
> > > If the hardware handler isn't explicitly set, infer ALUA support
> > > from the pp->tpgs attribute. Likewise, if ALUA is selected, but
> > > not supported by the hardware, fall back to no hardware handler.
> > =

> > Weren't you worried before about temporary ALUA failures? If you had
> > a
> > temporary failure while configuring a device that you explicitly set
> > to
> > be ALUA, then this would cause the device to be misconfigured? =

> =

> I believe that if TGPS is 0, the device will never be able to support
> ALUA. The kernel also looks at the TPGS bits and won't try ALUA if they
> are unset. Once the device is configured and actual ALUA RTPG/STPG
> calls are performed, they may fail for a variety of temporary reasons -
> I wanted to avoid resetting the prio algorithm to "const" for such
> cases. That's my understanding, correct me if I'm wrong.

Devices that were not correctly supporing ALUA returned > 0 for
get_target_port_group_support, so detect_alua actually does all the work
necessary to verify that it can get a priority. Without doing this,
multiple deviecs that didn't support ALUA were being detected as
supporting ALUA.

> =

> > If the
> > hardware handler isn't set, inferring ALUA is fine. But what is the
> > case
> > where we want to say that a device that is explicitly set to ALUA
> > shouldn't actually be ALUA?  It seem like if there is some
> > uncertaintly,
> > we should just not set the hardware handler, and allow multipath to
> > infer it via the pp->tpgs value.
> > =

> > I'm not strongly against this patch. I just don't see the value in
> > overriding an explicit configuration, if we believe that temporary
> > failures are possible.
> =

> That would be fine if we didn't have any explicit "hardware_handler
> alua" settings in the hardcoded hwtable any more, or at least if we're =

> positive that those devices where we have "hardware_handler alua"
> really support it.
> =

> We can also adopt the philosophy of "detect_prio" and "detect_checker",
> add an additional config file option "detect_hwhandler", and look at
> tpgs only if the latter it set (which would be the default). Like
> detect_prio, users could then enforce their config file settings with
> "detect_hwhandler no".
> =

> I was hoping we could find a simpler approach, without yet another
> rarely-used config option.
> =

> Btw, at SUSE we solved our problem with the controller at hand by
> simply removing "hardware_handler alua" and "prio alua" from the IBM
> IPR entry. If the scsi_dh_alua module is loaded early (default on
> SUSE), this results in ALUA hwhandler and sysfs prio being used for IPR
> controllers that do support ALUA, and no hwhandler / const prio =3D
> PRIO_UNDEF for those that don't. I'm not sure if that simple solution
> suits upstream, because upstream doesn't enforce early loading of
> device handler modules.

By using retain_attached_hwhandler at all, we are implicitly requiring
the scsi_dh_alua module to be loaded before devices with indeterminate
configurations are discovered for them to work correctly. right? For
instance, commit 715c48d93dd00930534ce6a55d0e3705466df5d6 did this for
netapp devices, and that was in 2013. I don't see how this is different.

-Ben

> Regards,
> Martin
> =

> =

> > =

> > -Ben
> > =

> > > =

> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  libmultipath/propsel.c | 19 +++++++++++++++++--
> > >  1 file changed, 17 insertions(+), 2 deletions(-)
> > > =

> > > diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> > > index 93974a482336..dc24450eb775 100644
> > > --- a/libmultipath/propsel.c
> > > +++ b/libmultipath/propsel.c
> > > @@ -43,10 +43,13 @@ do {						=

> > > 			\
> > >  		goto out;						=

> > > \
> > >  	}								=

> > > \
> > >  } while(0)
> > > +
> > > +static char default_origin[] =3D "(setting: multipath internal)";
> > > +
> > >  #define do_default(dest, value)					=

> > > 	\
> > >  do {								=

> > > 	\
> > >  	dest =3D value;						=

> > > 	\
> > > -	origin =3D "(setting: multipath internal)";			=

> > > \
> > > +	origin =3D default_origin;					=

> > > \
> > >  } while(0)
> > >  =

> > >  #define mp_set_mpe(var)						=

> > > 	\
> > > @@ -373,16 +376,20 @@ static int get_dh_state(struct path *pp, char
> > > *value, size_t value_len)
> > >  =

> > >  int select_hwhandler(struct config *conf, struct multipath *mp)
> > >  {
> > > -	char *origin;
> > > +	const char *origin;
> > >  	struct path *pp;
> > >  	/* dh_state is no longer than "detached" */
> > >  	char handler[12];
> > > +	static char alua_name[] =3D "1 alua";
> > > +	static const char tpgs_origin[]=3D "(setting: autodetected
> > > from TPGS)";
> > >  	char *dh_state;
> > >  	int i;
> > > +	bool all_tpgs =3D true;
> > >  =

> > >  	dh_state =3D &handler[2];
> > >  	if (mp->retain_hwhandler !=3D RETAIN_HWHANDLER_OFF) {
> > >  		vector_foreach_slot(mp->paths, pp, i) {
> > > +			all_tpgs =3D all_tpgs && (pp->tpgs > 0);
> > >  			if (get_dh_state(pp, dh_state,
> > > sizeof(handler) - 2) > 0
> > >  			    && strcmp(dh_state, "detached")) {
> > >  				memcpy(handler, "1 ", 2);
> > > @@ -397,6 +404,14 @@ int select_hwhandler(struct config *conf,
> > > struct multipath *mp)
> > >  	mp_set_conf(hwhandler);
> > >  	mp_set_default(hwhandler, DEFAULT_HWHANDLER);
> > >  out:
> > > +	if (all_tpgs && !strcmp(mp->hwhandler, DEFAULT_HWHANDLER)
> > > &&
> > > +		origin =3D=3D default_origin) {
> > > +		mp->hwhandler =3D alua_name;
> > > +		origin =3D tpgs_origin;
> > > +	} else if (!all_tpgs && !strcmp(mp->hwhandler, alua_name))
> > > {
> > > +		mp->hwhandler =3D DEFAULT_HWHANDLER;
> > > +		origin =3D tpgs_origin;
> > > +	}
> > >  	mp->hwhandler =3D STRDUP(mp->hwhandler);
> > >  	condlog(3, "%s: hardware_handler =3D \"%s\" %s", mp->alias,
> > > mp->hwhandler,
> > >  		origin);
> > > -- =

> > > 2.16.1
> > =

> > =

> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
