From: NeilBrown <neilb@suse.de>
Subject: Re: [dm-devel] [PATCH 0/3] md raid: enhancements to support the
 device mapper dm-raid target
Date: Mon, 23 Feb 2015 12:07:18 +1100
Message-ID: <20150223120718.03806a87@notabene.brown>
References: <1423853282-6218-1-git-send-email-heinzm@redhat.com>
	<20150218130328.3ce5ab53@notabene.brown>
	<54E47C88.1080203@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/CbA/WQip1Il9Eue_qHdIy9f"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54E47C88.1080203@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "jbras >> Brassow Jonathan" <jbrassow@redhat.com>, linux RAID <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

--Sig_/CbA/WQip1Il9Eue_qHdIy9f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Feb 2015 12:50:32 +0100 Heinz Mauelshagen <heinzm@redhat.com>
wrote:

> On 02/18/2015 03:03 AM, NeilBrown wrote:
> > On Fri, 13 Feb 2015 19:47:59 +0100 heinzm@redhat.com wrote:
> >
> >> From: Heinz Mauelshagen <heinzm@redhat.com>
> >>
> >> I'm enhancing the device mapper raid target (dm-raid) to take
> >> advantage of so far unused md raid kernel funtionality:
> >> takeover, reshape, resize, addition and removal of devices to/from rai=
d sets.
> >>
> >> This series of patches remove constraints doing so.
> >>
> >>
> >> Patch #1:
> >> add 2 API functions to allow dm-raid to access the raid takeover
> >> and resize functionality (namely md_takeover() and md_resize());
> >> reshape APIs are not needed in lieu of the existing personalilty ones
> >>
> >> Patch #2:
> >> because device mapper core manages a request queue per mapped device
> >> utilizing the md make_request API to pass on bios via the dm-raid targ=
et,
> >> no md instance underneath it needs to manage a request queue of its ow=
n.
> >> Thus dm-raid can't use the md raid0 personality as is, because the lat=
ter
> >> accesses the request queue unconditionally in 3 places via mddev->queue
> >> which this patch addresses.
> >>
> >> Patch #3:
> >> when dm-raid processes a down takeover to raid0, it needs to destroy
> >> any existing bitmap, because raid0 does not require one. The patch
> >> exports the bitmap_destroy() API to allow dm-raid to remove bitmaps.
> >>
> >>
> >> Heinz Mauelshagen (3):
> >>    md core:   add 2 API functions for takeover and resize to support d=
m-raid
> >>    md raid0:  access mddev->queue (request queue member) conditionally
> >>               because it is not set when accessed from dm-raid
> >>    md bitmap: export bitmap_destroy() to support dm-raid down takover =
to raid0
> >>
> >>   drivers/md/bitmap.c |  1 +
> >>   drivers/md/md.c     | 39 ++++++++++++++++++++++++++++++---------
> >>   drivers/md/md.h     |  3 +++
> >>   drivers/md/raid0.c  | 48 +++++++++++++++++++++++++++----------------=
-----
> >>   4 files changed, 61 insertions(+), 30 deletions(-)
> >>
> > Hi Heinz,
> >   I don't object to these patches if you will find the exported functio=
nality
> >   useful, but I am a little surprised by them.
>=20
> Hi Neil,
>=20
> I find them useful to allow for atomic takeover using the already given=20
> md raid
> code rather than duplicating ACID takeover in dm-raid/lvm. If I'd not=20
> use md for this,
> I'd have to keep copies of the given md superblocks and restore them in c=
ase
> the assembly of the array failed and superblocks have been updated.

This argument doesn't make much sense to me.

There is no reason that the assembling the array in a new configuration wou=
ld
fail, except possible malloc error or similar which would make putting it
back into the original configuration fail as well.

There is no need to synchronise updating the metadata with a take-over.
In every case, the "Before" and "After" configurations are functionally
identical.
A 2-drive RAID1 behaves identically to a 2-drive RAID5, for example.
So it doesn't really matter whether or not the metadata match how the kernel
is configured.  Once you start a reshape (e.g. 2-drive RAID5 to 3-drive
RAID5) or add a spare, then you need the metadata to be correct, but that is
just a sequencing issue:

- start: metadata says "raid1".
- suspend array, reconfigure as RAID5 with 2 drives, resume.
- if everything went well, update metadata to "raid5".
- now update metadata to "0 block of progress into reshape from 2-drives to
  3-drives".
- now start the reshape, which will further update the metadata as it
  proceeds.

There really are no atomicity requirements, only sequencing.


>=20
> >
> >   I would expect that dm-raid wouldn't ask md to 'takeover' from one le=
vel to
> >   another, but instead would
> >     - suspend the dm device
> >     - dismantle the array using the old level
> >     - assemble the array using the new level
> >     - resume the dm device
>=20
> That scenario is on my TODO, because it is for instance paritcularly=20
> useful to
> convert a "striped" array (or a "raid0" array without metadata for that=20
> purpose)
> directly into a raid6_n_6 one (i.e. dedicated xor and syndrome devices)
> thus avoding any interim levels.
> In these cases, I'd only need to drop the metadata devs allocations if
> the array does not start up properly and restart the previous mapping.
>=20

Given that you plan to do this, I really think the dm and LVM code would be
simpler if all reconfigurations use this same approach.

>=20
> >
> >   The reason md needs 'takeover' is because it doesn't have the same
> >   device/target separation that dm does.
>=20
> Correct.
> Nonetheless, I found accessing md's takeover functionality still useful
> for the atomic updates to be simpler in dm/lvm.
>=20
> >
> >   I was particularly surprised that you wanted to use md/raid0.c  It is=
 no
> >   better than dm/dm-stripe.c and managing two different stripe engines =
under
> >   LVM doesn't see like a good idea.
>=20
> I actually see differences in performance which I have not explained yet.
>=20
> In some cases, dm-stripe performs better, in others md raid0 does for=20
> the same mappings
> and load; exact same mappings are possible, because I've got patches to=20
> lvconvert back
> and forth between "striped" and "raid0", hence accesing exactly the same=
=20
> physical extents.

That is surprising.  I would be great if we could characterise  what sort of
workloads work better with one or the other...


>=20
> So supporting "raid0" in dm-raid is senseful for 3 reasons:
> - replace dm-stripe with md raid0
> - atomic md takeover from "raid0" -> "raid5"
> - potential performance implications
>=20
> >
> >   Is there some reason that I have missed which makes it easier to use
> >   'takeover' rather than suspend/resume?
>=20
> Use md takover for atomic updates as mentioned above.
>=20
> You don't have issues with md_resize() which I use to shrink existing=20
> arrays?
>=20

I have exactly the same issue with md_resize() as with md_takeover(), and f=
or
the same reasons.

How about we wait until you do implement the
 suspend/dismantle/reassemble/resume
approach, and see if you still want md_resize/md_takeover after that?

Thanks,
NeilBrown


--Sig_/CbA/WQip1Il9Eue_qHdIy9f
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOp9Rjnsnt1WYoG5AQKeNA/7B+hgvGENUNadiAO/UeqiA3YexQqGaP6U
1GMsUTm73gGKxgc0umi+BEYwXXRHWLWnNtJzMAdazkAhxNK16x3XI6zFzzpv1wRZ
voMh0WlUpCJFQeWLa7+UAfrBNyDkvMAUvrZwj8PnPlKeFFwJG3QsPgquWNPv/5tS
04eUGMItxmJJmu4xLSnsHHVG8+TnO65g1Ra5R+PROeE+tLwBh/RGbhP6oNWpFhxA
3rmpjt9AJj5HYFeNKcciOr9vE198F6pKYqTp4f77VfNpH+1BygjqfTegLiYoOJC0
W8drFgRyoyMuulusr864Uoo+k+WutNcVhhh70ZwzBSd6rke9L6gSOW8s7/fmoVAV
HNp+GZ80kWeUsCGW9iioowfqeSHq/3asixar2PCLJA/DZIVfETbXMulT7SxEEDNW
WqBWyhKtehDX8OGBeMCSlTBYhk2QCJfahtMZkNKdiVmLc8su2r4pEmVNYOuZSHMR
81rJhZv4VOmLxr7+u9oB4XwKeOyHFx7ezkLRQNXYzJyu8i25eEg7SyYDWBwKp6jb
TEkMcT3nDFYg1KMSWZplzEcgIxlQXYl5Vj+iulWCaTLIlk8rswDSKGEJn2fSUFCz
LFjL0c+yMING8oexuqyrwjoF2KHu0RGlU+0Kf6D2gZxbqaSmulJWSGvEj85XeZp+
KWv8+xG6EOY=
=bxLb
-----END PGP SIGNATURE-----

--Sig_/CbA/WQip1Il9Eue_qHdIy9f--
