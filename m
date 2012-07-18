From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v2] DM RAID: Add support for MD RAID10
Date: Wed, 18 Jul 2012 11:11:46 +1000
Message-ID: <20120718111146.336c3228@notabene.brown>
References: <1342057001.22214.6.camel@f16>
	<20120712163207.222b4bcc@notabene.brown>
	<544F2898-B9C7-42CD-A0FD-F1DE35C5E628@redhat.com>
	<20120717123404.3516b943@notabene.brown>
	<3A8FC300-59E8-48CA-81DF-CCCF780BFE0C@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EqkI3+vgHGQ=19C+oTGAwtg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3A8FC300-59E8-48CA-81DF-CCCF780BFE0C@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

--Sig_/EqkI3+vgHGQ=19C+oTGAwtg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Jul 2012 11:15:56 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Jul 16, 2012, at 9:34 PM, NeilBrown wrote:
>=20
> >>>>=20
> >>>> @@ -536,9 +605,25 @@ static int parse_raid_params(struct raid
> >>>> 	if (dm_set_target_max_io_len(rs->ti, max_io_len))
> >>>> 		return -EINVAL;
> >>>>=20
> >>>> -	if ((rs->raid_type->level > 1) &&
> >>>> -	    sector_div(sectors_per_dev, (rs->md.raid_disks - rs->raid_type=
->parity_devs))) {
> >>>> +	if (rs->raid_type->level =3D=3D 10) {
> >>>> +		/* (Len * Stripes) / Mirrors */
> >>>> +		sectors_per_dev *=3D rs->md.raid_disks;
> >>>> +		if (sector_div(sectors_per_dev, raid10_copies)) {
> >>>> +			rs->ti->error =3D "Target length not divisible by number of data=
 devices";
> >>>> +			return -EINVAL;
> >>>> +		}
> >>>=20
> >>> I'm not entirely sure what you are trying to do here, but I don't thi=
nk it
> >>> works.
> >>>=20
> >>> At the very least you would need to convert the "sectors_per_dev" num=
ber to a
> >>> 'chunks_per_dev' before multiplying by raid_disks and dividing by cop=
ies.
> >>>=20
> >>> But even that isn't necessary.  If you have a 3-device near=3D2 array=
 with an
> >>> odd number of chunks per device, that will still work.  The last chun=
k won't
> >>> be mirrored, so won't be used.
> >>> Until a couple of weeks ago a recovery of the last device would trigg=
er an
> >>> error when we try to recover that last chunk, but that is fixed now.
> >>>=20
> >>> So if you want to impose this limitation (and there is some merit in =
making
> >>> sure people don't confuse themselves), I suggest it get imposed in the
> >>> user-space tools which create the RAID10.
> >>=20
> >> I have seen what you do in calc_sectors(), I suppose I could bring tha=
t in.  However, I'm simply trying to find the value that will be preliminar=
ily assigned to mddev->dev_sectors.  It is an enforced (perhaps unnecessary=
) constraint that the array length be divisible by the number of data devic=
es.  I'm not accounting for chunk boundaries - I leave that to userspace to=
 configure and MD to catch.
> >=20
> > In that case I suggest you keep it out of dmraid.
> >=20
> > It might make sense to check that the resulting array size matches what
> > user-space said to expect - or is at-least-as-big-as.  However I don't =
see
> > much point in other size changes there.
>=20
> I'm not changing any sizes.  I'm finding a value for mddev->dev_sectors (=
what should I set it to if not the above?), which is the size of each devic=
e as computed from the total array size.  If the value can't be computed ev=
enly, then an error is given.  I'm not sure what you are suggesting my alte=
rnative is when you say, "keep it out of dm-raid"...  I think this is the l=
east I can do in dm-raid.

Sorry, I mean 'checks', not 'changes'.

I was confused a bit by the code.  It might be clearer to have

   sectors_per_dev =3D ti->len * rs->md.raid_disks;
   remainder =3D sector_div(sectors_per_dev, raid10_copies);

In almost all cases raid10_copies will be 2 and ti->len will be a multiple =
of
8 (as we don't support chunk sizes less than 4K), so remainder will be 0.
However this doesn't really prove anything.  It is still entirely possible
that the resulting 'sectors_per_dev' will not result in a RAID10 which has
the full ti->len sectors required.
So your test is not sufficient.

Also your calculation is incorrect as it doesn't allow for the possibility =
of
unused space in the array.
A 3-drive 2-copy RAID10 with an odd number of chunks will not use the last
chunk on the last device. In that case the above calculation will result in
a sectors_per_dev that it too small.

I think your sectors_per_dev calculation should round up to a whole number =
of
chunks.

   sectors_per_dev =3D DIV_ROUND_UP_SECTOR_T(ti->len * rs->md.raid_disks,
                                           raid10_copies);
   sectors_per_dev =3D round_up(sectors_per_dev, rs->md.chunk_sectors);

And then after calling md_run(), you should check that
 pers->size(mddev, 0, 0) =3D=3D ti->len
and abort if not.

Note that getting the sectors_per_dev right is really really important for
RAID10-far.  For other layouts and levels a smaller sectors_per_dev will ju=
st
result in less data being available.
For raid10-far, sectors_per_dev is included in the layout calculations so
changing it will change the location of data and could result in corruption.

NeilBrown

--Sig_/EqkI3+vgHGQ=19C+oTGAwtg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAYNUjnsnt1WYoG5AQJU0xAAo6LDO63+TtcRO4+kRA/m0uwmm0ajAO9p
Y5IftvE0TnUWMZzp1ziU2SBnm9ewdyYNPhyrnMN4c1/YC2TSIqEj/eGW45ekDzPa
AkJnr0nElGrRkqqmGmp/4OsFecUayMk7T4sxyNtKIeKKymnevzhBom/lugqEUp4h
PTpMFPvcByunicU7s1Q6N6I6cwQpt4cwDyE0ePH2CLERTtEaPi4jRdrIt/unVFx+
yXUd2n+nZrTCdwQZdJJUOQkOFvH1b1aHKSxtKSVOCgc7p01RTGwmVuvs2Xo9UmX2
FmHcJeqHjJc47nwnJrk6lgahfVEW9mCqDDjFQwRLINPkS0XQ/J4zJO6p/oHDgT2f
AXofROrl2jpkXoNdImSmqsfJJe/WsFTqX2XHK9IBfXpPitm4cLd/WA2twJqqjX+7
yQi9I4jiqZ19uwgXmVdvGj3wsqylwzNChSm9lmebAiejhu2r2ujdHGTTsu1j7zSq
jdyiikVrQ01V+R5SweQyscTJI6jdmV4Y2gCpeSwsqRvFUDbFHX5t4mkgqB4Xayyh
LbtZKXcyUPQWNjuYsKHqufd1N1JheMzP6AKkBxYZRx7wzIFVj4VY6nv5w+nF6p3I
T60eonltBoLv1eNZ04QHwjL2/3pbmnxsitvX8WazO87+qDHtpfjRz5IRSQTisG0h
phA/efF1AVM=
=pn7h
-----END PGP SIGNATURE-----

--Sig_/EqkI3+vgHGQ=19C+oTGAwtg--
