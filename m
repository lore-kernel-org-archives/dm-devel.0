From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] dm-raid: add RAID discard support
Date: Thu, 2 Oct 2014 09:15:03 +1000
Message-ID: <20141002091503.26582977@notabene.brown>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
	<yq18ulaszpk.fsf@sermon.lab.mkp.net>
	<20140924093308.120fe616@notabene.brown>
	<yq1zjdpsqry.fsf@sermon.lab.mkp.net>
	<7C39EB56-623A-4318-A558-258ABA32FF12@redhat.com>
	<20140924142157.33475baa@notabene.brown>
	<5422A4C4.4020707@redhat.com>
	<20141001125625.1e0d356a@notabene.brown>
	<CANvN+emfkxbsvmVGr6OL1cTy+jB5t7nHhzB5Ak_6oRH24ojOxw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0546597598493461699=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CANvN+emfkxbsvmVGr6OL1cTy+jB5t7nHhzB5Ak_6oRH24ojOxw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

--===============0546597598493461699==
Content-Type: multipart/signed; micalg=pgp-sha1;
	boundary="Sig_/4pY3zGL/XB8EtJQRkqnqLCE";
	protocol="application/pgp-signature"

--Sig_/4pY3zGL/XB8EtJQRkqnqLCE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Oct 2014 20:00:45 +0400 Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
wrote:

> On Wed, Oct 1, 2014 at 6:56 AM, NeilBrown <neilb@suse.de> wrote:
> > On Wed, 24 Sep 2014 13:02:28 +0200 Heinz Mauelshagen <heinzm@redhat.com>
> > wrote:
> >
> >>
> >> Martin,
> >>
> >> thanks for the good explanation of the state of the discard union.
> >> Do you have an ETA for the 'zeroout, deallocate' ... support you menti=
oned?
> >>
> >> I was planning to have a followup patch for dm-raid supporting a dm-ra=
id
> >> table
> >> line argument to prohibit discard passdown.
> >>
> >> In lieu of the fuzzy field situation wrt SSD fw and discard_zeroes_data
> >> support
> >> related to RAID4/5/6, we need that in upstream together with the initi=
al
> >> patch.
> >>
> >> That 'no_discard_passdown' table line can be added to dm-raid RAID4/5/6
> >> table
> >> lines to avoid possible data corruption but can be avoided on RAID1/10
> >> table lines,
> >> because the latter are not suffering from any  discard_zeroes_data fla=
w.
> >>
> >>
> >> Neil,
> >>
> >> are you going to disable discards in RAID4/5/6 shortly
> >> or rather go with your bitmap solution?
> >
> > Can I just close my eyes and hope it goes away?
> >
> > The idea of a bitmap of uninitialised areas is not a short-term solutio=
n.
> > But I'm not really keen on simply disabling discard for RAID4/5/6 eithe=
r. It
> > would  mean that people with good sensible hardware wouldn't be able to=
 use
> > it properly.
> >
> > I would really rather that discard_zeroes_data were only set on devices=
 where
> > it was actually true.  Then it wouldn't be my problem any more.
> >
> > Maybe I could do a loud warning
> >   "Not enabling DISCARD on RAID5 because we cannot trust committees.
> >    Set "md_mod.willing_to_risk_discard=3DY" if your devices reads disca=
rded
> >    sectors as zeros"
> >
> > and add an appropriate module parameter......
> >
> > While we are on the topic, maybe I should write down my thoughts about =
the
> > bitmap thing in case someone wants to contribute.
> >
> >   There are 3 states that a 'region' can be in:
> >     1- known to be in-sync
> >     2- possibly not in sync, but it should  be
> >     3- probably not in sync, contains no valuable data.
> >
> >  A read from '3' should return zeroes.
> >  A write to '3' should change the region to be '2'.  It could either
> >     write zeros before allowing the write to start, or it could just st=
art
> >     a normal resync.
> >
> >  Here is a question:  if a region has been discarded, are we guaranteed=
 that
> >  reads are at least stable.  i.e. if I read twice will I definitely get=
 the
> >  same value?
>=20
> Not sure with other specs, but an NVMe-compliant SSD that supports
> discard (Dataset Management command with Deallocate attribute, in NVMe
> parlance) is, per spec, required to be deterministic when deallocated
> range is subsequently read. That's what the spec (1.1) says:
>=20
> The value read from a deallocated LBA shall be deterministic;
> specifically, the value returned by subsequent reads of that LBA shall
> be the same until a write occurs to that LBA. The values read from a
> deallocated LBA and its metadata (excluding protection information)
> shall be all zeros, all ones, or the last data written to the
> associated LBA and its metadata. The values read from an unwritten or
> deallocated LBA=E2=80=99s protection information field shall be all ones
> (indicating the protection information shall not be checked).
>=20

That's good to know - thanks.

NeilBrown


--Sig_/4pY3zGL/XB8EtJQRkqnqLCE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCyK9znsnt1WYoG5AQI/wxAAkKwN0HmZ/ZvI8MzZuU4F7EnYzk/OL/hQ
Ow78tl5OpNNQeWjjWOeNw3rO8SjD1rXwdrDBSW+5Q864Otx5awkOO9lHbXN8slyy
aLthYXNXxEfBwTfugoBoWsuhamdnGVRYzBJPtw27d8m43WZSZsRcoT39cYgy/RxE
I+yQWiCjTIhcPGr97rhNoE57rPULXxIbFEIycCZb1v79TeUJfJj3ghN5Z8bWh1zW
Mn6Ic6vi/tIDsHthNudUbsPNE6vZAiLBbjdM21VUCELpYrkOyOov6VkC0uiWp9pv
PwD7Hi+eiLAaR73C/9XRTViFSX6zrPCQDEB68o8DiPrz24V7hGAXpbEgrRZaJkdi
2lxHOyco/8qNZSUKa7+Lbdm79ePPNphn4B1XQg3eHSaCcPNUkJJZkyHIqg0jgdtR
Av6C5Q3AobeWYO5Gyz1HmWyqEe7znH/s+ksuyF2FKZW9JnDFWvLebahQfMrESSOB
aHYzOjZf86nLUdxSbflgDJ2zK2vUFHOHIUlJHgCXLu22SRIMJOqkdM9A5+ptC45S
nSy/68h9xhJI2Ctotfy5YqDbKfAe3nUO/fa3r186qZ1Dvulz94H+P9GvqOePFB2h
/qIHiP8uT2k7oX35iditCmvPlV2J+t4qEORmClh65UmnnlrIon/puECkd3dfvCBm
XodfCRLG2tA=
=N0tk
-----END PGP SIGNATURE-----

--Sig_/4pY3zGL/XB8EtJQRkqnqLCE--


--===============0546597598493461699==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0546597598493461699==--
