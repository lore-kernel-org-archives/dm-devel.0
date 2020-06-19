From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 2/7] multipathd: fix check_path errors with
 removed map
Date: Fri, 19 Jun 2020 13:42:47 +0000
Message-ID: <6f9284eeec0dda69e8e4dd4b2858f02d3c31fb8b.camel@suse.com>
References: <1592439867-18427-1-git-send-email-bmarzins@redhat.com>
	<1592439867-18427-3-git-send-email-bmarzins@redhat.com>
	<f09ec3b6537a7b7ac1ae26433e43846176f1dd48.camel@suse.com>
	<20200618231711.GM5894@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200618231711.GM5894@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <5932E0CA4CFE054893B045384C65A060@eurprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2020-06-18 at 18:17 -0500, Benjamin Marzinski wrote:
> On Thu, Jun 18, 2020 at 07:34:38PM +0000, Martin Wilck wrote:
> > On Wed, 2020-06-17 at 19:24 -0500, Benjamin Marzinski wrote:
> > >=20
> > >  static void
> > > @@ -2088,8 +2084,13 @@ check_path (struct vectors * vecs, struct
> > > path
> > > * pp, unsigned int ticks)
> > >  =09 * Synchronize with kernel state
> > >  =09 */
> > >  =09if (update_multipath_strings(pp->mpp, vecs->pathvec, 1)) {
> > > +=09=09struct dm_info info;
> > >  =09=09condlog(1, "%s: Could not synchronize with kernel
> > > state",
> > >  =09=09=09pp->dev);
> > > +=09=09if (pp->mpp && pp->mpp->alias &&
> > > +=09=09    do_dm_get_info(pp->mpp->alias, &info) =3D=3D 0)
> > > +=09=09=09/* multipath device missing. Likely removed */
> > > +=09=09=09return 0;
> > >  =09=09pp->dmstate =3D PSTATE_UNDEF;
> >=20
> > It would be more elegant if we could distinguish different failure
> > modes from update_multipath_strings() directly, without having to
> > call
> > do_dm_get_info() again.
>=20
> Seems reasonable. I'll take a look at that.

Yet another idea: I just discussed this with Hannes, and he pointed out
that right below this code, we have

=09/* if update_multipath_strings orphaned the path, quit early */
=09if (!pp->mpp)
=09=09return 0;

... which could have the same effect, if pp->mpp was reloaded. Probably
that doesn't happen because the pp->mpp dereference is cached in a
register, but we could simply add a READ_ONCE there.

Choose what you prefer.

Regards,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
