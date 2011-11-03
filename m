From: NeilBrown <neilb@suse.de>
Subject: Re: HPA unlock during partition scan of RAID components
Date: Fri, 4 Nov 2011 07:46:52 +1100
Message-ID: <20111104074652.7b5eacb3@notabene.brown>
References: <74AAB12B538EC94087A0D16AFDFC24F4045674@IRSMSX102.ger.corp.intel.com>
	<20111103153835.GF4417@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2091950374472390511=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111103153835.GF4417@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: dm-devel@redhat.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, "Hawrylewicz Czarnowski,
	Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: dm-devel.ids

--===============2091950374472390511==
Content-Type: multipart/signed; micalg=PGP-SHA1;
	boundary="Sig_/tOJLmjSUYDVg+9q4Y53DsVe";
	protocol="application/pgp-signature"

--Sig_/tOJLmjSUYDVg+9q4Y53DsVe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 3 Nov 2011 08:54:16 -0700 Tejun Heo <tj@kernel.org> wrote:

> Hello,
>=20
> (cc'ing dm-devel)
>=20
> On Thu, Nov 03, 2011 at 01:02:37AM +0000, Hawrylewicz Czarnowski, Przemys=
law wrote:
> > Recently we have encountered a problem with unlocking of HPA on disks b=
elonging to RAID array.
> > The scenario in the simplest form is as follows:
> > * take HPA resized drives
> > * use SW Raid solution with metadata located at the end of disk (eg. md=
 v1.0, IMSM)
> > * create raid0/10/5 using whole devices (eg. /dev/sda) (raid size must =
extend capacity of single device; raid1 is not the case here)=20
> > * create any partition with size exceeding HPA limit of single component
> >=20
> > According to the code of rescan_partitions(), if disk has capacity limi=
t enabled (HPA) and boundary of partition extends beyond that limit, it is =
bypassed/unlocked (regardless of libata.ignore_hpa state).
> > As for single block device it is proper action - for raid using whole b=
lock device it is not. The partition table despite the fact it is read from=
 single disk belongs to raid array. Values in RAID context are set properly=
. But from the point of view of single device - they are not.
> > Problem is that in general rescan_partition() has no knowledge of any r=
aid array using that block device. Moreover, that raid is not assembled yet.
> > And the result: as HPA limit is unlocked and metadata on this device in=
 not recognizable anymore - in worst case raid is not assembled or failed.
> >=20
> > The simplest resolution is to conditionally forbid HPA unlocking (eg. e=
xtending ignore_hpa parameter) but I suppose a better and more 'intelligent=
' solution can be found.
>=20
> This has come up a couple times and I think the proper solution is to
> always unlock HPA and expose both sizes - locked and unlocked and let
> dm, md or whatever do whatever is approriate.  Block or driver layer
> doesn't have any way to determine which one is the right bet - it
> simply doesn't have enough information.  I tried to bounce this idea
> off people who whould actually be using this (dm/md) but haven't heard
> back yet.
>=20
> Thanks.
>=20

What exactly do you mean by "expose both sizes" ??
A new ioctl - BLKGETHPASIZE64 ??

That might work, but I think it would be good if there were also an ioctl
BLKHBALOCK which changed BLKGETSIZE64 to match BLKGETHPASIZE64.
Then some user-space tools could examine the device with a full understandi=
ng
of md, dm, dmraid, partitions, filesystems etc etc and make a reasonably
informed decision.  And then put that decision into effect.

??

NeilBrown

--Sig_/tOJLmjSUYDVg+9q4Y53DsVe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrL9vDnsnt1WYoG5AQJzKw/+IKC8sr2OQnKpiv/X9txZh/80qtmRLzNH
pihCiiRVVUTZFivfDwduoCWtyQbEslV5Rw6iZxbDrb1mrBJOB/FWxAJHj5H120o5
1EXufADLfEweJ03NxGgUZPMWe7iTQA//AlU0920sz5TrNYEMoL1NZLzjjXECqN/G
at1fWDAN49SMolEkGWpWOmx+Z0AaaThDVRB36UQ032T8P6bTiinh6I/YF0hHTa5Z
VYngA6gbPfhMzZWweYwNiyD3W7zcH4/JDnEGDRLL6C6ph5hNkiRcvCCQLwjHRTWS
nt8I4qNaoMlgq4mp0g6XQfG7HOoQs0civjdQoEJrsptELfbA7URYIaoW82Rfx3AM
ZHmULbnFpNSlZN1CkhVEu5fQkf5DeIArM4/lqJSvu1lE3Fh+hHouYIjYfUVAWCrv
cYB3M/+6u0SbELVqfOeU4k+MK0pXynN4k11Uxj9qlFL2gcCyeFVfKK8tmNC+dg9r
QRT8W9C2/RsHQWhmZHkHOClujFDPxRoPxtGx0N4mme/HLxPzoVxuPL6xVCani2hD
vcfBbbiyjyItoSv4qix1UmA1a6YYT9QSaE5TimjXvDCsMWMiM78BML6bykDyN4w8
Kq/2Q77boiXnAJhZedkuulr5ok7BEUaTVH3S1g1awyXESCuyehCD83BoGOwajnbd
+CO4Qdh+i/w=
=dJ7t
-----END PGP SIGNATURE-----

--Sig_/tOJLmjSUYDVg+9q4Y53DsVe--


--===============2091950374472390511==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2091950374472390511==--
