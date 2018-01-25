From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] multipathd: update path's udev in
 uev_update_path
Date: Thu, 25 Jan 2018 08:22:19 -0600
Message-ID: <20180125142219.GE14513@octiron.msp.redhat.com>
References: <CEB9978CF3252343BE3C67AC9F0086A342958939@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CEB9978CF3252343BE3C67AC9F0086A342958939@H3CMLB14-EX.srv.huawei-3com.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Wuchongyun <wu.chongyun@h3c.com>
Cc: Guozhonghua <guozhonghua@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Changlimin <changlimin@h3c.com>, Martin Wilck <mwilck@suse.com>, Changwei Ge <ge.changwei@h3c.com>
List-Id: dm-devel.ids

On Wed, Jan 24, 2018 at 01:43:01AM +0000, Wuchongyun wrote:
> Hi Ben,
> Thanks for your reply. =

> The purpose to update the path's udev is that if we want to call interfac=
e sysfs_attr_set_value() to trigger uevent for this device might use the ol=
d udev_device
> If this device already received a cheng uevent and updated. If we use the=
 not update pp->udev in uev_update_path may get udev database's old value o=
r status. =

> Like we want to get the newest wwid get from udev.

In general, we don't rely on udev to give us the current value for any
sysfs attribute whose value can change, since it can change without
causing a uevent.  Instead, we call sysfs_attr_get_value() to get these
values directly from sysfs.

More importantly however, if the wwid of a device changes, then it is no
longer the same device.  Linux doesn't support changing the backing LUN
on a device that is in-use.  It can cause issues in all sorts of places,
not just in multipath.  Multipath already has an option to check if the
wwid changes, which uses the wwid from the latest uevent.  But we only
use this to disable access to the mutlipath device, until the wwid
switches back.

-Ben

> =

> On January 23, 2018 20:39PM, Benjamin Marzinski wrote:
> On Mon, Jan 22, 2018 at 11:34:15AM +0100, Martin Wilck wrote:
> > > On Sat, 2018-01-20 at 02:30 +0000, Wuchongyun wrote:
> > > > Hi Martin and Ben,
> >> > Could you help to review this patch, thanks.
> > > >
> > > > When receiving a change uevent and calling uev_update_path, current =

> > > > code not update the path's udev, if use pp->udev to query the udev =

> > > > database info will get the old data. So it should update the path's =

> > > > udev with the new udev from the new uevent in uev_update_path also.
> > > > =

> > > > Signed-off-by: Chongyun Wu <wu.chongyun@h3c.com>
> >> > ---
> > > >  multipathd/main.c |    3 +++
> > > >  1 file changed, 3 insertions(+)
> > > > =

> > > > diff --git a/multipathd/main.c b/multipathd/main.c index =

> > > > 27cf234..e7a4f4b 100644
> > > > --- a/multipathd/main.c
> > > > +++ b/multipathd/main.c
> > > > @@ -937,6 +937,9 @@ uev_update_path (struct uevent *uev, struct =

> > > > vectors * vecs)
> > > >  	if (pp) {
> > > >  		struct multipath *mpp =3D pp->mpp;
> >>  >  =

> > > > +		udev_device_unref(pp->udev);
> > > > +		pp->udev =3D udev_device_ref(uev->udev);
> > > > +
> > > >  		if (disable_changed_wwids &&
> > > >  		    (strlen(pp->wwid) || pp->wwid_changed)) {
> > > >  			char wwid[WWID_SIZE];
> > >
> >>  The general idea is correct, but I fear we need to do more.
> >>  =

> >> Basically, if relevant udev properties have changed, we need to call
> > > pathinfo() on the changed path. Getting this right is subtle, I guess.
> > > We can't simply change the path properties in the pathvec, because =

> > > there'll be locking issues, and changed path properties might affect =

> > > how the path is handled.
> =

> > We do call pathinfo to update paths in a number of places, and as long =
as we do it while holding the vecs lock, I thought that was safe. Am I miss=
ing something here?
> =

> > > The path may have gone R/O, or even have changed wwid. The safest =

> > > course of action might be to delete and re-add the path if any =

> > > important properties have changed. But blindly deleting and re-adding =

> > > would be wrong as well...
> > > =

> > > Ben has recently done work in this area, so I'll leave the verdict to =

> > > him for now.
> > > =

> > > @Ben, AFAICS this patch shows that disable_changed_wwids won't work =

> > > correctly as long as the WWID is derived from udev, which is the =

> > > default case these days. Or am I overlooking something?
> =

> > We build the "struct uevent *uev" up from the specific uevent and we ch=
eck the R/O value from that, so it will be correct based on the actual even=
t.  We also check the wwid from the udev device linked from the uev, so =

> >that is also from the actual current device state.  I don't remember off=
hand why I didn't just update the udev device for the path in uev_update_pa=
th (or even if I had a good reason for not doing so. I'm very jetlagged
> >right now). However, does your update to trigger_paths_udev_change() wor=
k correctly in this case? It doesn't use the uevent's udev device. It uses =
the path device's udev device. Does it just rely on this being the first ti=
me
> >you access DM_MULTIPATH_DEVICE_PATH, so it's not caching the old value?
> =

> AFAICS, this change won't hurt anything. But I we should probably update =
other values that are based on these attributes.
> =

> -Ben
> =

> > =

> > Martin
> > =

> > > --
> > > 1.7.9.5
> > > =

> > > Regards
> > > Chongyun
> > =

> > --
> > Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107 SUSE =

> > Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton HRB =

> > 21284 (AG N=FCrnberg)
> =
