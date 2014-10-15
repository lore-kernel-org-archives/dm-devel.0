From: NeilBrown <neilb@suse.de>
Subject: Re: dm raid: ensure metadata IO matches device block
	size.
Date: Thu, 16 Oct 2014 08:00:54 +1100
Message-ID: <20141016080054.7c906901@notabene.brown>
References: <20141015121907.265b3aed@notabene.brown>
	<20141015025550.GC19683@redhat.com>
	<20141015144003.7b17752d@notabene.brown>
	<20141015131307.GA23955@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6740393720643150998=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141015131307.GA23955@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Liuhua Wang <lwang@suse.com>, Heinz Mauelshagen <heinzm@redhat.com>, device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

--===============6740393720643150998==
Content-Type: multipart/signed; micalg=pgp-sha1;
	boundary="Sig_/blM+WpfTofmPP_E3I_uahXN";
	protocol="application/pgp-signature"

--Sig_/blM+WpfTofmPP_E3I_uahXN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Oct 2014 09:13:08 -0400 Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Oct 14 2014 at 11:40pm -0400,
> NeilBrown <neilb@suse.de> wrote:
>=20
> > On Tue, 14 Oct 2014 22:55:50 -0400 Mike Snitzer <snitzer@redhat.com> wr=
ote:
> >=20
> > > On Tue, Oct 14 2014 at  9:19pm -0400,
> > > NeilBrown <neilb@suse.de> wrote:
> > >=20
> > > >=20
> > > > dm_raid_superblock is 512.
> > > > Reading or writing this on a 512-byte sector works fine.
> > > > On a 4096-byte sector device, this fails.
> > > >=20
> > > > If we round up rdev->sb_size to match the block size of
> > > > the device, all IO will work correctly.
> > > >=20
> > > > Reported-by: "Liuhua Wang" <lwang@suse.com>
> > > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > >=20
> > > > ---
> > > > this issue has been discussed already a bit. See email thread
> > > >  Subject: Re: [dm-devel] [PATCH] fix mirror device creation with lv=
create failed
> > > > I think this is the best fix.  It handles boths read and writes, an=
d (I think)
> > > > at the best level.
> > > >=20
> > > > Thanks,
> > > > NeilBrown
> > > >=20
> > > >=20
> > > > diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> > > > index 4880b69e2e9e..31bdd73bc368 100644
> > > > --- a/drivers/md/dm-raid.c
> > > > +++ b/drivers/md/dm-raid.c
> > > > @@ -858,7 +858,8 @@ static int super_load(struct md_rdev *rdev, str=
uct md_rdev *refdev)
> > > >  	uint64_t events_sb, events_refsb;
> > > > =20
> > > >  	rdev->sb_start =3D 0;
> > > > -	rdev->sb_size =3D sizeof(*sb);
> > > > +	rdev->sb_size =3D roundup(sizeof(*sb),
> > > > +				bdev_logical_block_size(rdev->meta_bdev));
> > > > =20
> > > >  	ret =3D read_disk_sb(rdev, rdev->sb_size);
> > > >  	if (ret)
> > >=20
> > > Wouldn't it be better to use bdev_physical_block_size()?
> > >=20
> > > Even on a 4K device that emulates 512b logical sectors it is better to
> > > use the physical block size (4K).
> >=20
> >=20
> > _logical_ is the smallest value for which the IO actually works.
> > And the goal of the change is to make it work.
> >=20
> > I don't object to using _physical_, but it isn't clear to me how I would
> > justify that as "correct".
> >=20
> > A big question in my mind is: how much space does LVM reserve in this d=
evice
> > for the metadata?  It seems reasonable to assume that it reserves at le=
ast
> > 1 logical block.  If the API guarantees that at least one physical bloc=
k is
> > reserved, then that would justify using _physical_.
>=20
> I'll have to check with Jon and/or Heinz on this point.
>=20
> > A quick look at the code shows that the bitmap superblock is placed 4K =
after
> > the start of the metadata.
>=20
> "the code" being the MD kernel code right?  Any reason not to export a
> #define that reflects the space MD reserves and just have dm-raid use tha=
t?

No, "the code" being

	mddev->bitmap_info.offset =3D 4096 >> 9; /* Enable bitmap creation */
	rdev->mddev->bitmap_info.default_offset =3D 4096 >> 9;

in super_validate in dm-raid.c.
i.e. dm-raid specific code.
md doesn't reserve space, it just uses what it is told to.  Told either by
mdadm via the md superblock or by dm-raid.

NeilBrown

>=20
> Starting to feel like hardcoding 4K is the right thing to do given the
> current code.


--Sig_/blM+WpfTofmPP_E3I_uahXN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVD7ghjnsnt1WYoG5AQILHg/9GhgnavGHR+OBpZ6kNPL/NvavkPBo+yuQ
qEBnY52LS5L4TcHQLO0eYKbq1efIeiCWiBf2NzB/EDc6I8PgHtLNJnBh3NDYj5nY
MgYNGeD6NmRNnzwZUyg8ccU6epnjdHQ4QaIkJFoznBaQPHXkWvM2zSqhHhfVMjr1
lrAUANVXG1dKIsS86T7tqX9wp76N+lD7FwqPaMoYgN5vTxV+IsHgAvFh8S2t+SjN
mGnO6t2uZDZxKl4dJvJnC7NZ1QEuAn5totqwbl8huyFDqBWJvcYz04z9y/yl4KBf
Vh4kybj9USdtGCezTDdGaXfBE4u8ZWCSt+dS/5bvkVehhb2h3bcqAFRDD5MItbGc
EIyesN4ReaLzq6sDUgnD2flhemewad4g89Ol/jO+WAL496OUbfXjUnV/rzcN+FsI
R+of1nicUh897M0+hbuxANBxQDp7so6gOREa8H1Kstt6bJOWuTUd0r6zb9VeWtfN
fwWAh54sFG3+8XFHsvvY6akytru/PGr5468SM9xTyZ6ab0z5cBXFxTG7BUwWi+DY
oZmacz2jwVW93yNYdCwam05nXADb8vjB8foxDM4+VgU7EYioo6VYXZ4wixhxlmFM
NAf8OGK+0XwV+kYgkp9aUW8axpYzTUFZHwN0ggu0r894fDTkM8OHGo9Aoc04iw0f
5q5+6C15Z+Y=
=eJbD
-----END PGP SIGNATURE-----

--Sig_/blM+WpfTofmPP_E3I_uahXN--


--===============6740393720643150998==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6740393720643150998==--
