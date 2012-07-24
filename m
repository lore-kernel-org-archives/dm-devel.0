From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v4] DM RAID: Add support for MD RAID10
Date: Tue, 24 Jul 2012 11:29:54 +1000
Message-ID: <20120724112954.595d8f5c@notabene.brown>
References: <1343072962.20599.2.camel@f16>
	<20120724082611.41a275d2@notabene.brown>
	<9EC0A670-52AB-4623-A9E7-997AA4930791@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/95_vtEbMZI_kj.COMLXYzph"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9EC0A670-52AB-4623-A9E7-997AA4930791@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

--Sig_/95_vtEbMZI_kj.COMLXYzph
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Jul 2012 20:18:03 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Jul 23, 2012, at 5:26 PM, NeilBrown wrote:
>=20
> > On Mon, 23 Jul 2012 14:49:22 -0500 Jonathan Brassow <jbrassow@redhat.co=
m>
>=20
> </snip>
>=20
> >=20
> >>=20
> >> br@@ -436,6 +475,7 @@ static int parse_raid_params(struct raid
> >> 				if (rebuild_cnt > rs->raid_type->parity_devs)
> >> 					rs->ti->error =3D "Too many rebuild devices specified for given R=
AID type";
> >> 				break;
> >> +			case 10:
> >> 			default:
> >> 				DMERR("The rebuild parameter is not supported for %s", rs->raid_ty=
pe->name);
> >> 				rs->ti->error =3D "Rebuild not supported for this RAID type";
> >=20
> > This hunk doesn't apply for me, or against 3.5.  Is there some patch I'm
> > missing.
> > I do vaguely recall you changing this to a switch statement I think, bu=
t I
> > still have an if statement here.
> > If I'm missing a patch - could you resend it please?
>=20
> My fault.  I sent these two patches to dm-devel and failed to CC linux-ra=
id or you.
>=20
> https://www.redhat.com/archives/dm-devel/2012-July/msg00041.html
> https://www.redhat.com/archives/dm-devel/2012-July/msg00042.html

Maybe that is where I saw it before - I thought I had.

>=20
> Agk hasn't pushed these two yet and we should probably wait for that to h=
appen.  The above two patches are necessary for this patch, but are depende=
nt upon other patches that agk has staged at the moment.  The timing is not=
 working out well, and we'll have to wait.

I can do "waiting" (as long as you can help with the waking up when the time
comes).


>=20
> >>> @@ -536,8 +585,30 @@ static int parse_raid_params(struct raid
> >> 	if (dm_set_target_max_io_len(rs->ti, max_io_len))
> >> 		return -EINVAL;
> >>=20
> >> -	if ((rs->raid_type->level > 1) &&
> >> -	    sector_div(sectors_per_dev, (rs->md.raid_disks - rs->raid_type->=
parity_devs))) {
> >> +	if (rs->raid_type->level =3D=3D 10) {
> >> +		if (raid10_copies > rs->md.raid_disks) {
> >> +			rs->ti->error =3D "Not enough devices to satisfy specification";
> >> +			return -EINVAL;
> >> +		}
> >> +
> >> +		/* (Len * #mirrors) / #devices */
> >> +		sectors_per_dev =3D rs->ti->len * raid10_copies;
> >> +		if (sector_div(sectors_per_dev, rs->md.raid_disks)) {
> >> +			rs->ti->error =3D "Target length not evenly divisible by number of=
 stripes";
> >> +			return -EINVAL;
> >> +		}
> >=20
> > This test is still completely pointless, and putting an extra test for =
chunk
> > alignment after it doesn't make it any less pointless.=20
> > And putting an important division inside the condition of an if(), hide=
s it a
> > bit more than I like.
> > But it probably isn't worth arguing about it any more so once I can get=
 a
> > patch to apply I'll take it.
>=20
> I'll pull the division out of the conditional so that it's a little more =
visible.  Once agk has pushed the aforementioned patches, I'll repost this =
patch with that change as 'v5'.
>=20
> I don't want to belabor the issue - especially since you are kind enough =
to be accommodating, but I don't know how I can get by without calculating =
and setting 'mddev->dev_sectors'.  MD can't get that information from anywh=
ere else (when setting up RAID through DM).  The main point is to compute s=
ectors_per_dev, but secondarily I am checking for other conditions - like n=
ot aligning on chunk boundaries or not being evenly divisible.  Failure to =
set sectors_per_dev - or set it correctly - results in an ill-sized array (=
mddev->array_sectors).  The per device value is not passed in via DM table =
either - it must be computed.  So, I don't understand why it is pointless.

The division is certainly needed.  Getting the correct "sectors_per_dev" is
obviously required.
It is the testing of the remainder that is pointless.  A non-zero remainder
is not necessarily bad, a zero remainder is not a guarantee that everything
is good.
The test that ti->len =3D=3D rs->md.array_sectors (which you included, than=
ks) is
the important test and it makes all the other tests on sizes redundant.

Thanks,
NeilBrown


--Sig_/95_vtEbMZI_kj.COMLXYzph
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUA36kjnsnt1WYoG5AQL+6RAArAxzvFWYDpMl5PKjkFeV2rDPciaTB8F6
39G16Vm+GDOTdaykpu6x+IEOsxLGtL1Q7S1piLMEK10U9hF9a9M+ru0Z4vqibX3v
MOsfxrSfbJmycWX+qkJstq/vJjizKlji6Gnz+TW096V5vXaS1x6xTz4fORckJIhc
/fQXMt9YeP4eUDHuryu5A2Rv7TzC67xnzgmNTgRVkF8vBDvl1BQhA6dmAekbYtuf
f58oQmsg3cb7TTf5/HbBSWMN5rRdrU7F8XkO4vf1gouEXx3JXbZn3tGZv3o6NthX
R7X6K81hhrgjKWfNS/eY8o7u4ju1PXZrHuoNUwg8y9UgYBjpSsubtOMQsjZ537uX
WX1HuJ0P60AKMe8Byru5myogtpGPfSjqhTiCsFmozxlpbJW5Z/wnn2lXkYGPT5F9
qDImdo0ovQ8ZVDTdqP7wrL9fJ94PbwsWmeYIoqQFrxjSAOC7RgtKVCve4YUlK+aL
ja+oox6ADNdT9BaN6LQwivjgVpUXS6dkZI8ouFkhCDW/V0W74966y303b+FbzRm0
t2kxQ65o6zsh04TKHRJE2w910EuIZgtBtEqEqmwo/BAjknPeb1Vbny9/txz1rNeo
v3B9QHrsRm6Syx/9hyykwVUSCupX4qxiRFzL/mQBHBdU1QoolxfzuIs/u6G+xKmA
vAYCQBe5p40=
=AtuZ
-----END PGP SIGNATURE-----

--Sig_/95_vtEbMZI_kj.COMLXYzph--
