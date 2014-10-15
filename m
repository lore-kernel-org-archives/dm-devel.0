From: NeilBrown <neilb@suse.de>
Subject: Re: dm raid: ensure metadata IO matches device block
	size.
Date: Wed, 15 Oct 2014 14:40:03 +1100
Message-ID: <20141015144003.7b17752d@notabene.brown>
References: <20141015121907.265b3aed@notabene.brown>
	<20141015025550.GC19683@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6676171219343443388=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141015025550.GC19683@redhat.com>
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

--===============6676171219343443388==
Content-Type: multipart/signed; micalg=pgp-sha1;
	boundary="Sig_/y/eWtf0inCIEDOfDrV=OmH6";
	protocol="application/pgp-signature"

--Sig_/y/eWtf0inCIEDOfDrV=OmH6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Oct 2014 22:55:50 -0400 Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Oct 14 2014 at  9:19pm -0400,
> NeilBrown <neilb@suse.de> wrote:
>=20
> >=20
> > dm_raid_superblock is 512.
> > Reading or writing this on a 512-byte sector works fine.
> > On a 4096-byte sector device, this fails.
> >=20
> > If we round up rdev->sb_size to match the block size of
> > the device, all IO will work correctly.
> >=20
> > Reported-by: "Liuhua Wang" <lwang@suse.com>
> > Signed-off-by: NeilBrown <neilb@suse.de>
> >=20
> > ---
> > this issue has been discussed already a bit. See email thread
> >  Subject: Re: [dm-devel] [PATCH] fix mirror device creation with lvcrea=
te failed
> > I think this is the best fix.  It handles boths read and writes, and (I=
 think)
> > at the best level.
> >=20
> > Thanks,
> > NeilBrown
> >=20
> >=20
> > diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> > index 4880b69e2e9e..31bdd73bc368 100644
> > --- a/drivers/md/dm-raid.c
> > +++ b/drivers/md/dm-raid.c
> > @@ -858,7 +858,8 @@ static int super_load(struct md_rdev *rdev, struct =
md_rdev *refdev)
> >  	uint64_t events_sb, events_refsb;
> > =20
> >  	rdev->sb_start =3D 0;
> > -	rdev->sb_size =3D sizeof(*sb);
> > +	rdev->sb_size =3D roundup(sizeof(*sb),
> > +				bdev_logical_block_size(rdev->meta_bdev));
> > =20
> >  	ret =3D read_disk_sb(rdev, rdev->sb_size);
> >  	if (ret)
>=20
> Wouldn't it be better to use bdev_physical_block_size()?
>=20
> Even on a 4K device that emulates 512b logical sectors it is better to
> use the physical block size (4K).


_logical_ is the smallest value for which the IO actually works.
And the goal of the change is to make it work.

I don't object to using _physical_, but it isn't clear to me how I would
justify that as "correct".

A big question in my mind is: how much space does LVM reserve in this device
for the metadata?  It seems reasonable to assume that it reserves at least
1 logical block.  If the API guarantees that at least one physical block is
reserved, then that would justify using _physical_.

A quick look at the code shows that the bitmap superblock is placed 4K after
the start of the metadata.
So the code should probably fail if the rounded-up sb_size exceeds 4K.
Mind you, that would exceed PAGE_SIZE too which would cause other problems.

Maybe use _physical_ unless that exceeds 4K, then try _logical_, then fail =
if
even that > 4K ??

Thanks,
NeilBrown

--Sig_/y/eWtf0inCIEDOfDrV=OmH6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVD3slDnsnt1WYoG5AQIjJw/+IV8LSscyT/Y0+defH2WWD83u9oZ0yyDI
3RLimsxtC8WUofvVvYajWkEvtw2w8ll9jnYPltWT5mDpMoJ28zvDhAiudQWOWra4
XOX1AeXbfAlR6L1kxfmX8jELG5qIXUia2chWBS6Y41dWewlocjH4NUrRjJTSXZmL
ssLQ3K7w1K9RSSAtAtNRNFQ64r8uiXMGFrXbBfhQ+quNCQIFKDh9tJKG4cTkWof9
yRzoDTHFeDeE3DYCxRPpoBibm5K/hIBfkhoIZJrXqHWwFLwhYtvUhrth4kObLarl
k7KFbjITheycYvLf6g4i33oXrFE6kxcyx2mp+VKreFlbDCwAvRxsl94N8khOBepa
P0Yp/JVxF2DnJmwrGBHBzGveYayM9zhaw3Qe3ax1LL/xI8WGm61myTo9Vs+OdQRH
vtdh8Mhja5n9VKn3Ccq/t0NC5uL7O8BdtZRC/Acf+HAWJa4Qc3ScIbkslszEWMH+
gxbt4+VMA2x857+SBhip+NmI1ybVh6Ti+V/lpITYf6MhmLYQzK8NABH8ODytmcAq
aBXIrsNZV/A+akmAzDrNrMxPetggfz2FRjuz21LRvfXPrnbVn5dw3DqcbmBQpJgp
8ZV2UL6diFYPteTciIgzlVTA85KHTOC3koNUHWLg8+EfzCzEArmx9RjOtBDeluoS
SEnvjrA8fhs=
=wtKe
-----END PGP SIGNATURE-----

--Sig_/y/eWtf0inCIEDOfDrV=OmH6--


--===============6676171219343443388==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6676171219343443388==--
