From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 7/9] multipathd: allow devices to switch from
 RW to RO
Date: Thu, 13 Apr 2017 12:53:08 -0500
Message-ID: <20170413175308.GQ19236@octiron.msp.redhat.com>
References: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
	<1491545798-22183-8-git-send-email-bmarzins@redhat.com>
	<1492094385.22602.3.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1492094385.22602.3.camel@suse.com>
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

On Thu, Apr 13, 2017 at 04:39:45PM +0200, Martin Wilck wrote:
> On Fri, 2017-04-07 at 01:16 -0500, Benjamin Marzinski wrote:
> > Whenever multipathd tries to reload a device, even if it's because a
> > path switched from read/write to read-only, it tries to load the
> > device
> > read/write first, and then falls back to read-only. When device-
> > mapper
> > sees that multipath is using the same devices in the same state in
> > its
> > new table, it simply reuses the devices from the old table, instead
> > of
> > closing and re-opening them. This means that multipath can
> > successfully
> > reload the multipath device read/write, even if a path device has
> > switched to read-only.=A0=A0To deal with this, multipathd now doesn't t=
ry
> > to
> > reload a device read/write when it sees that a path device has
> > switched
> > to read-only.
> > =

> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0libmultipath/devmapper.c | 9 +++++----
> > =A0libmultipath/structs.h=A0=A0=A0| 1 +
> > =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0| 3 +++
> > =A03 files changed, 9 insertions(+), 4 deletions(-)
> > =

> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index f4ff13e..995e580 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -1017,7 +1017,10 @@ uev_update_path (struct uevent *uev, struct
> > vectors * vecs)
> > =A0			if (mpp->wait_for_udev)
> > =A0				mpp->wait_for_udev =3D 2;
> > =A0			else {
> > +				if (ro =3D=3D 1)
> > +					pp->mpp->force_readonly =3D 1;
> > =A0				retval =3D reload_map(vecs, mpp, 0,
> > 1);
> > +				pp->mpp->force_readonly =3D 0;
> =

> Why don't you leave this set to 1 until all paths have been switched to
> rw mode? AFAICS, if any uevent arrives except a switch to ro (assume
> several paths are ro and one switches back to rw), multipathd will
> reload the map r/w. Or am I overlooking something?

Once multipath has reloaded the map RO, the path devices that
device-mapper has opened for it will all be RO. So, when another uevent
comes along that causes multipathd to reload the map, the R/W reload
will fail. Since the path devices in the old table are in the wrong
state, the kernel is forced to re-open them in the correct state. This
will fail if any of them are set RO.

The problem that this is fixing is that multipath usually tries
reloading the table R/W first. This means that when a path switches from
R/W to RO, the path devices in the old table will be opened R/W. When
multipath tries to reload the table R/W, it can just reuse them, since
ther state matches.

Now, we could avoid attempting the useless R/W reload by tracking the RO
status of the paths, and only trying R/W when we don't know that a path
is RO, but then we would have to track the RO status of paths. But this
should be sufficient to make multipath devices turn RO (and stay that
way) when a path does. =


-Ben

> =

> Regards,
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
