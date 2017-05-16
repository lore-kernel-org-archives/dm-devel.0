From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 4/6] libmultipath: fix suspended devs from
 failed reloads
Date: Tue, 16 May 2017 12:33:50 -0500
Message-ID: <20170516173350.GN22856@octiron.msp.redhat.com>
References: <1494349025-6561-1-git-send-email-bmarzins@redhat.com>
	<1494349025-6561-5-git-send-email-bmarzins@redhat.com>
	<1494534412.6093.36.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1494534412.6093.36.camel@suse.com>
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

On Thu, May 11, 2017 at 10:26:52PM +0200, Martin Wilck wrote:
> On Tue, 2017-05-09 at 11:57 -0500, Benjamin Marzinski wrote:
> > When multipath reloads a device, it can either fail while loading the
> > new table or while resuming the device. If it fails while resuming
> > the
> > device, the device can get stuck in the suspended state.=A0=A0To fix
> > this,
> > multipath needs to resume the device again so that it can continue
> > using
> > the old table.
> > =

> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0libmultipath/devmapper.c | 19 ++++++++++++++++++-
> > =A0libmultipath/devmapper.h |=A0=A01 +
> > =A02 files changed, 19 insertions(+), 1 deletion(-)
> > =

> > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > index 2c4a13a..69b634b 100644
> > --- a/libmultipath/devmapper.c
> > +++ b/libmultipath/devmapper.c
> > @@ -396,7 +396,13 @@ int dm_addmap_reload(struct multipath *mpp, char
> > *params, int flush)
> > =A0	if (r)
> > =A0		r =3D dm_simplecmd(DM_DEVICE_RESUME, mpp->alias,
> > !flush,
> > =A0				=A01, udev_flags, 0);
> > -	return r;
> > +	if (r)
> > +		return r;
> > +
> > +	if (dm_is_suspended(mpp->alias))
> > +		dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, !flush,
> > 1,
> > +			=A0=A0=A0=A0=A0udev_flags, 0);
> > +	return 0;
> > =A0}
> =

> Why would the second DM_DEVICE_RESUME call succeed if the first one
> failed?

Because if the first resume fails, device-mapper rolls back to the
original table.

The specific way that someone found this was by running a

multipathd resize

when only some of the paths had been rescaned and noticed the new,
larger, size. Since the first path had changed size (that's all the
multipath looks at to find the new size) the multipath device tried to
reload larger. However, when it tried to resume with the larger size, it
failed since some of the devices were too small.  The second resume lets
it try again with the original table.

Of course, that isn't the only way that this could fail, and it's nice
to be able to gracefully continue using the old table instead of just
being suspended.

-Ben

> =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
