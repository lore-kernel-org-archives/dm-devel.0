From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] dm-raid: add RAID discard support
Date: Wed, 1 Oct 2014 12:56:25 +1000
Message-ID: <20141001125625.1e0d356a@notabene.brown>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
	<yq18ulaszpk.fsf@sermon.lab.mkp.net>
	<20140924093308.120fe616@notabene.brown>
	<yq1zjdpsqry.fsf@sermon.lab.mkp.net>
	<7C39EB56-623A-4318-A558-258ABA32FF12@redhat.com>
	<20140924142157.33475baa@notabene.brown>
	<5422A4C4.4020707@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7024451978183875838=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5422A4C4.4020707@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

--===============7024451978183875838==
Content-Type: multipart/signed; micalg=pgp-sha1;
	boundary="Sig_/rLtMrHBmvoWfQHcTKqBWz8n";
	protocol="application/pgp-signature"

--Sig_/rLtMrHBmvoWfQHcTKqBWz8n
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Sep 2014 13:02:28 +0200 Heinz Mauelshagen <heinzm@redhat.com>
wrote:

>=20
> Martin,
>=20
> thanks for the good explanation of the state of the discard union.
> Do you have an ETA for the 'zeroout, deallocate' ... support you mentione=
d?
>=20
> I was planning to have a followup patch for dm-raid supporting a dm-raid=
=20
> table
> line argument to prohibit discard passdown.
>=20
> In lieu of the fuzzy field situation wrt SSD fw and discard_zeroes_data=20
> support
> related to RAID4/5/6, we need that in upstream together with the initial=
=20
> patch.
>=20
> That 'no_discard_passdown' table line can be added to dm-raid RAID4/5/6=20
> table
> lines to avoid possible data corruption but can be avoided on RAID1/10=20
> table lines,
> because the latter are not suffering from any  discard_zeroes_data flaw.
>=20
>=20
> Neil,
>=20
> are you going to disable discards in RAID4/5/6 shortly
> or rather go with your bitmap solution?

Can I just close my eyes and hope it goes away?

The idea of a bitmap of uninitialised areas is not a short-term solution.
But I'm not really keen on simply disabling discard for RAID4/5/6 either. It
would  mean that people with good sensible hardware wouldn't be able to use
it properly.

I would really rather that discard_zeroes_data were only set on devices whe=
re
it was actually true.  Then it wouldn't be my problem any more.

Maybe I could do a loud warning
  "Not enabling DISCARD on RAID5 because we cannot trust committees.
   Set "md_mod.willing_to_risk_discard=3DY" if your devices reads discarded
   sectors as zeros"

and add an appropriate module parameter......

While we are on the topic, maybe I should write down my thoughts about the
bitmap thing in case someone wants to contribute.

  There are 3 states that a 'region' can be in:
    1- known to be in-sync
    2- possibly not in sync, but it should  be
    3- probably not in sync, contains no valuable data.

 A read from '3' should return zeroes.
 A write to '3' should change the region to be '2'.  It could either
    write zeros before allowing the write to start, or it could just start
    a normal resync.

 Here is a question:  if a region has been discarded, are we guaranteed that
 reads are at least stable.  i.e. if I read twice will I definitely get the
 same value?

 It would be simplest to store all the states in the one bitmap. i.e. have a
 new version of the current bitmap (which distinguishes between '1' and '2')
 which allows the 3rd state.  Probably just 2 bits per region, though we co=
uld
 squeeze state for 20 regions into 32 bits if we really wanted :-)

 Then we set the bitmap to all '3's when it is created and set regions to
 '3' when discarding.

 One problem with this approach is that it forces the same region size.
 Regions for the current bitmap can conveniently be 10s of Megabytes.  For
 state '3', we ideally want one region per stripe.
 For 4TB drives with a 512K chunk size (and smaller is not uncommon) that is
 8 million regions which is a megabyte of bits.

 I guess that isn't all that much.  One problem with small regions for the
 1/2 distinction is that we end up updating the bitmap more often, but
 that could be avoided by setting multiple bits at one.
 i.e. keep the internal counters with a larger granularity, and when a
 counter (of outstanding writes) becomes non-zero, set quite a few bits in
 the bitmap.

 So that is probably what I would do:
  - new version for bitmap which has 2 bits per region and encodes 3 states
  - bitmap granularity matches chunk size (by default)
  - decouple region size of bitmap from region size for internal 'dirty'
    accounting
  - write to a 'state 3' region sets it to 'state 2' and kicks off resync
  - 'discard' sets state to '3'.

NeilBrown

--Sig_/rLtMrHBmvoWfQHcTKqBWz8n
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCttWjnsnt1WYoG5AQJQYA//YgXvxpaMi7IwS/TfZZ4fRwLCO64WFLhF
hpSOZqPzw6Bf126E9Ywc9h54bFV7hsTMyuLubc9/tYH3fm3yBhPdLrYdS7eQCbIW
ecd4Yniu6gsiwg8gdHrWOXCAv+YYExf5DE71ZHTOeQomJ7TzfcMx0YyXPNGC7XTQ
yC3waeBsBfPfVt9P138BdtjaV/hi9jamZHv9VIIomOvuGoS/sfev0r2mREEUTgKP
9wLN/fw3ACN1hPHhRS6YuK1ag/yWkb1n+whL+7vPhNjbYKe8xtBKNbOa5rjyR4Pl
GC7B8VMyuHf5AsMG4E1/6EDbPMjs15RvGNFCH9nJyohoWImcGqrm60eqi2/zQWVb
S/3wM6f9omjAuMoRFhHfQRhk8fl+MCIS+PHoOL6ijP3ZNp1h7DK0A9eA1yojqAs5
YgKYU2QvklnUBjXwle5JnSJIL8oQiCgZiO4w/i4mOwk3TGq917KN0eNrNgGoFgpK
86ADI127UF4EOPDoiBTUhbG1eAF4FiAuoIHjrUCcuhgRNPGpqZWbU1ox1mxrZ0j8
x2wWy0YCz0xZqeMrLqIWwZKAfFoBpTqavC6hvMwVobOjqsOZZO+orKwhNSI3vClp
T+oqswxyuIPcv0S/TDcln7+Q7E09t6odOPL2+pjcoy1UIlYkJ5fSOU4bMt/NtHrd
86ZUtfSV1kk=
=DGJA
-----END PGP SIGNATURE-----

--Sig_/rLtMrHBmvoWfQHcTKqBWz8n--


--===============7024451978183875838==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7024451978183875838==--
