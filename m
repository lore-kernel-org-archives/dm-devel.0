From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] DM RAID:  Add support for MD RAID10 personality
Date: Wed, 4 Jul 2012 15:15:37 +1000
Message-ID: <20120704151537.7c91076d@notabene.brown>
References: <1340712231.19015.42.camel@f16>
	<20120704112159.36cdb42a@notabene.brown>
	<262AC9F3-56D9-48A8-8A03-32D6B81D4689@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pgtg6HX4uJUCfePRz62U/8r"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <262AC9F3-56D9-48A8-8A03-32D6B81D4689@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

--Sig_/pgtg6HX4uJUCfePRz62U/8r
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Jul 2012 22:20:29 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Jul 3, 2012, at 8:21 PM, NeilBrown wrote:
>=20
> > On Tue, 26 Jun 2012 07:03:51 -0500 Jonathan Brassow <jbrassow@redhat.co=
m>
> > wrote:
> >=20
> >> dm raid: add md raid10 support
> >>=20
> >> Support the MD RAID10 personality through dm-raid.c
> >>=20
> >> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
> >>=20
> >> Index: linux-upstream/drivers/md/dm-raid.c
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> --- linux-upstream.orig/drivers/md/dm-raid.c
> >> +++ linux-upstream/drivers/md/dm-raid.c
> >> @@ -11,6 +11,7 @@
> >> #include "md.h"
> >> #include "raid1.h"
> >> #include "raid5.h"
> >> +#include "raid10.h"
> >> #include "bitmap.h"
> >>=20
> >> #include <linux/device-mapper.h>
> >> @@ -52,7 +53,11 @@ struct raid_dev {
> >> #define DMPF_MAX_RECOVERY_RATE 0x20
> >> #define DMPF_MAX_WRITE_BEHIND  0x40
> >> #define DMPF_STRIPE_CACHE      0x80
> >> -#define DMPF_REGION_SIZE       0X100
> >> +#define DMPF_REGION_SIZE       0x100
> >> +#define DMPF_RAID10_NEAR_COPIES 0x200
> >> +#define DMPF_RAID10_FAR_COPIES  0x400
> >> +#define DMPF_RAID10_FAR_OFFSET  0x800
> >> +
> >> struct raid_set {
> >> 	struct dm_target *ti;
> >>=20
> >> @@ -66,6 +71,15 @@ struct raid_set {
> >> 	struct raid_dev dev[0];
> >> };
> >>=20
> >> +/* near_copies in first byte */
> >> +/* far_copies in second byte */
> >> +/* far_offset in 17th bit */
> >> +#define ALGORITHM_RAID10(near_copies, far_copies, far_offset) \
> >> +	((near_copies & 0xFF) | ((far_copies & 0xFF) << 8) | ((!!far_offset)=
 << 16))
> >> +#define RAID10_NC(layout) (layout & 0xFF)
> >> +#define RAID10_FC(layout) ((layout >> 8) & 0xFF)
> >> +#define RAID10_FO(layout) (layout & 0x10000)
> >> +
> >> /* Supported raid types and properties. */
> >> static struct raid_type {
> >> 	const char *name;		/* RAID algorithm. */
> >> @@ -76,6 +90,8 @@ static struct raid_type {
> >> 	const unsigned algorithm;	/* RAID algorithm. */
> >> } raid_types[] =3D {
> >> 	{"raid1",    "RAID1 (mirroring)",               0, 2, 1, 0 /* NONE */=
},
> >> +	{"raid10",   "RAID10 (striped mirrors)",        0, 2, 10, -1 /* Vari=
es */},
> >> +	{"raid1e",   "RAID1E (Enhanced RAID1)",         0, 2, 10, -1 /* Vari=
es */},
> >> 	{"raid4",    "RAID4 (dedicated parity disk)",	1, 2, 5, ALGORITHM_PARI=
TY_0},
> >> 	{"raid5_la", "RAID5 (left asymmetric)",		1, 2, 5, ALGORITHM_LEFT_ASYM=
METRIC},
> >> 	{"raid5_ra", "RAID5 (right asymmetric)",	1, 2, 5, ALGORITHM_RIGHT_ASY=
MMETRIC},
> >> @@ -339,10 +355,17 @@ static int validate_region_size(struct r
> >>  *    [max_write_behind <sectors>]	See '-write-behind=3D' (man mdadm)
> >>  *    [stripe_cache <sectors>]		Stripe cache size for higher RAIDs
> >>  *    [region_size <sectors>]           Defines granularity of bitmap
> >> + *
> >> + * RAID10-only options:
> >> + *    [raid10_near_copies   <# copies>] Near copies. (Default: 2)
> >> + *    [raid10_far_copies    <# copies>] Far copies.  (Default: 1)
> >> + *    [raid10_far_offset    <0/1>]      Offset is device size(0) or s=
tripe(1).
> >=20
> > Can I suggest that you don't do it like this?  i.e. don't copy the
> > mistakes I made :-)
> >=20
> > I don't think there is any value in supporting multiple near and far co=
pies.
> > There are two dimensions of the layout:
> > - number of copies.  Defaults to 2
> > - location of the copies:  near, far, offset
> >=20
> > Some day I could implement an alternate version of 'far' or 'offset' wh=
ich
> > improves redundancy slightly.
> > Instead of=20
> >   A B C D
> >   ...
> >   D A B C
> >=20
> > it would be
> >=20
> >   A B C D=20
> >   ....
> >   B A D C
> >=20
> > i.e. treat the devices as pair and swap the device for the second copy.
> > This doesn't generalise to an odd number of devices, but increases the =
number
> > of pairs of devices that can concurrently fail without losing date.
> > (for 4 devices, there are 6 pairs.  With current 'far' mode there are o=
nly 2
> > pair of devices that can concurrently fail (0,2 and 1,3).  With the pro=
posed
> > far mode there are 4 (0,2 0,3 1,2, 1,3).
> >=20
> > Adding this with your current proposal would be messy.
> > Adding it with the two dimensions I suggest would simply involve adding
> > another 'location' - 'farswap' or 'far2' or something.
> >=20
> > I note you didn't make 'dm-raid1e' a module alias.  Was that deliberate?
>=20
> The missed module alias was an oversight, thanks for catching that.  (Sim=
ilar - as you can see from this patch - to the oversight I had when introdu=
cing raid1. :)  I have gone back and forth on whether to include the altern=
ate "raid1e" or not.  There are different RAID1E algorithms, as described i=
n the kernel doc.  Perhaps there should also be aliases similar to raid5 an=
d raid6 - like raid1e_as (i.e. RAID1E - Adjacent Stripe), etc.  However, th=
ere are several combinations that don't have a real name.  Any thoughts?  I=
 would be just fine leaving "raid1e" out as I would leaving it in.  These d=
ays, RAID10 is really a subset of RAID1E - perhaps I should be considering =
taking "raid10" out.  ;)

I don't really have much of an opinion here - as long as the scheme chosen =
is
coherent and extensible I'm happy.

I probably wouldn't have chosen to attach the layout to the "raid5" (e.g.
raid5_la), but I don't object.  The info has to go somewhere and it will
always be a smallish set of choices.
I probably would suggest not supporting both "raid10" and "raid1e" as that
could lead to confusion.  I can see good reasons for choosing either though.

>=20
> I like your suggestion of changing the parameter names.  I've found the o=
riginal names somewhat confusing.  ('far_offset' seems to imply to me that =
the copy would not be the very next stripe, but _offset_ somehow - it seems=
 to have the reverse meaning to me.  I think this comes from the fact that =
it acts as a modifier to 'far_copy'.)  I toyed with a couple different ways=
 of doing this but figured it was best to just go along.  Anyway, what you =
are suggesting seems to be:
> 	raid10_copies <number> (Default: 2)
> 	raid10_layout <string> (Default: "near"/"adjacent")
> Where <string> could be "near", "far", "offset" and "some-future-thing". =
 That seems nice to me and seems to clear up some of the confusion caused b=
y "far_offset" seeming to be a modifier to "far_copies".

Yes, that is what I'm suggesting.

>=20
> Let me know what you think about the above, and I'll get v2 ready.
>=20
>  brassow
>=20
> P.S.  While it doesn't affect this singular patch, I see people posting t=
heir set of patches as a reply to the summary '0 of' patch.  This keeps thi=
ngs together better, and I'll assume this is the way I should post from now=
 on.

There is probably some tool that does that.  It might help a little bit so =
if
you find it easy, then do it.  But if it is at all a burden, don't bother.

Thanks,
NeilBrown

--Sig_/pgtg6HX4uJUCfePRz62U/8r
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/PReTnsnt1WYoG5AQLnnxAAl9m+FYCax7HwZD85FthAg8PrClGKYZJ6
MI/qck1tIWJaiLcirjsUpdh5BDY0SQhQyewknt0OH+7JOHsR6kJIfY7pnBHL+UTB
cKPeECbU4r8fie03Ed8NyudHC08UQcDo9nYImg/VPg8Lm+R6pTRIvnrG116q8nPl
K4u2EQi3f/P5/a1x4LOvw8YdrjdzcJxvNhcuynP0A52TIhScsvnluBkpGFXBELXc
ZEIFmw2NYg8FZTbQBfFADHhbgJuBxugA9vjRW2+02IRc2yJw7iIy/HrGkovEz7hw
iUl2gSjMdeIGYO48uEg2Z0HQg1Zai64a5eSCfyGE4CdsXaiLPikpYOCVQwzbGjbo
LdOxEw3LKC4aQI3cx7SEcf4QF5/0E12DejBSAZHltD+q5RsdsC8XpEVJT/ILZ6U5
G90SdPXms51bFcpwouFCo/p7RZHcrB5YBBTKc7MwDXXT5A5OytYlYoaOcrgKy6S/
sNAn5n02Lzad8GBqDtFmE6InsZEr5e4pV6tIUp43SnRMa9V5fARzgUqyHBrqYlwW
HWWVllwcFVa7EllwG55dd3B+tX1148Ov+U0adItHo14btFg8VofJzIPR1P+bEo5i
AU+u0vzdpg10xwkFln5/xO1KacUH9zcDiAmFhWB4ufFzgYZ44bLNp78vDvyRDE+n
npTmdTdIqQg=
=2R3s
-----END PGP SIGNATURE-----

--Sig_/pgtg6HX4uJUCfePRz62U/8r--
