From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 4/6] libmultipath: fix suspended devs from
 failed reloads
Date: Wed, 17 May 2017 11:25:46 -0500
Message-ID: <20170517162546.GP22856@octiron.msp.redhat.com>
References: <1494349025-6561-1-git-send-email-bmarzins@redhat.com>
	<1494349025-6561-5-git-send-email-bmarzins@redhat.com>
	<1494534412.6093.36.camel@suse.com>
	<20170516173350.GN22856@octiron.msp.redhat.com>
	<1494961000.4700.15.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1494961000.4700.15.camel@suse.com>
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

On Tue, May 16, 2017 at 08:56:40PM +0200, Martin Wilck wrote:
> On Tue, 2017-05-16 at 12:33 -0500, Benjamin Marzinski wrote:
> > On Thu, May 11, 2017 at 10:26:52PM +0200, Martin Wilck wrote:
> > > On Tue, 2017-05-09 at 11:57 -0500, Benjamin Marzinski wrote:
> > > > When multipath reloads a device, it can either fail while loading
> > > > the
> > > > new table or while resuming the device. If it fails while
> > > > resuming
> > > > the
> > > > device, the device can get stuck in the suspended state.=A0=A0To fix
> > > > this,
> > > > multipath needs to resume the device again so that it can
> > > > continue
> > > > using
> > > > the old table.
> > > > =

> > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > > ---
> > > > =A0libmultipath/devmapper.c | 19 ++++++++++++++++++-
> > > > =A0libmultipath/devmapper.h |=A0=A01 +
> > > > =A02 files changed, 19 insertions(+), 1 deletion(-)
> > > > =

> > > > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > > > index 2c4a13a..69b634b 100644
> > > > --- a/libmultipath/devmapper.c
> > > > +++ b/libmultipath/devmapper.c
> > > > @@ -396,7 +396,13 @@ int dm_addmap_reload(struct multipath *mpp,
> > > > char
> > > > *params, int flush)
> > > > =A0	if (r)
> > > > =A0		r =3D dm_simplecmd(DM_DEVICE_RESUME, mpp->alias,
> > > > !flush,
> > > > =A0				=A01, udev_flags, 0);
> > > > -	return r;
> > > > +	if (r)
> > > > +		return r;
> > > > +
> > > > +	if (dm_is_suspended(mpp->alias))
> > > > +		dm_simplecmd(DM_DEVICE_RESUME, mpp->alias,
> > > > !flush,
> > > > 1,
> > > > +			=A0=A0=A0=A0=A0udev_flags, 0);
> > > > +	return 0;
> > > > =A0}
> > > =

> > > Why would the second DM_DEVICE_RESUME call succeed if the first one
> > > failed?
> > =

> > Because if the first resume fails, device-mapper rolls back to the
> > original table.
> =

> Ah. I didn't know that, and I'm likely to forget it again. Would you
> mind adding a short comment at that point in the code? =


Sure.

-Ben

> =

> Otherwise, ACK.
> =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
