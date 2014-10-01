From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] dm-raid: add RAID discard support
Date: Thu, 2 Oct 2014 09:18:56 +1000
Message-ID: <20141002091856.255eb50f@notabene.brown>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
	<yq18ulaszpk.fsf@sermon.lab.mkp.net>
	<20140924093308.120fe616@notabene.brown>
	<yq1zjdpsqry.fsf@sermon.lab.mkp.net>
	<7C39EB56-623A-4318-A558-258ABA32FF12@redhat.com>
	<20140924142157.33475baa@notabene.brown>
	<5422A4C4.4020707@redhat.com>
	<20141001125625.1e0d356a@notabene.brown>
	<1D933D29-689C-407F-98BB-3092F99BDBD1@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0267841818860368949=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1D933D29-689C-407F-98BB-3092F99BDBD1@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

--===============0267841818860368949==
Content-Type: multipart/signed; micalg=pgp-sha1;
	boundary="Sig_/cPYMNnSeoodw28pXRQ2U3r5";
	protocol="application/pgp-signature"

--Sig_/cPYMNnSeoodw28pXRQ2U3r5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Oct 2014 13:57:24 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Sep 30, 2014, at 9:56 PM, NeilBrown wrote:
>=20
> > So that is probably what I would do:
> >  - new version for bitmap which has 2 bits per region and encodes 3 sta=
tes
> >  - bitmap granularity matches chunk size (by default)
> >  - decouple region size of bitmap from region size for internal 'dirty'
> >    accounting
> >  - write to a 'state 3' region sets it to 'state 2' and kicks off resync
> >  - 'discard' sets state to '3'.
>=20
> There are scenarios where we do not trust the bitmap and perform exhausti=
ve searches (scrubbing).  When we do this, we assume that the bitmap has be=
en correctly handled, but the data has been corrupted somehow.  When we scr=
ub, we now could presumably use the bitmap to avoid those regions that have=
 been discarded.  However, are there problems to be considered when the cor=
ruption is the other way around - i.e. when the bitmap/superblock are corru=
pted instead of the data area?  Do we consider problems like this unlikely =
because of the frequency of superblock writes?  (The bitrot that I am famil=
iar with usually happens in areas that are not touched very often - especia=
lly if they exist near areas that /are/ touched very often.)
>=20
>  brassow

Good question....

I suspect the frequent writes that you mention would reduce the chance of
bitrot - and would make it quickly disappear if it did happen.

Maybe we could compare bitmaps across all devices as the array is assembled
and take some action if there are differences(??).

NeilBrown

--Sig_/cPYMNnSeoodw28pXRQ2U3r5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCyL4Dnsnt1WYoG5AQJ0yg/+JxgiqKjGu06Y5PGmchZvsaHhUojHubDW
dR68B8M1vcXkyVqPnvyn1JIPgyr9o+T/6lRn7kRMqIHeaZ/pPuz2dpXNWthqibg2
PknQWjJ7Aa5p3NCfHXs8Y42bHaHrDTh97/S68m8zewBeGkiUij0G47OTv47iklzJ
LX2NkkSiPM2JzCyc61IiAfZ9HySicIFYFZ6f98QVoRYSI6j2xzyA8MRM1cfjA596
FLxq0tyFyhVRg/htUYbAnauI68n7w3bXe6bxicAnVMkv4waHY1dQH7ZMcVW1CwTs
4xDfYjfvkS5V+SReAqGViOjkgdtynimRt7ENWkascABnz0fXqnUzjMbbCSQUTZQG
8sPyJy7G0CWCffPGFZNvgt0dQ0L/jF6OHhywtb2VeYWPU7EBKwe2F5jPlQcn3RUo
NW4KbEk5FE7zkiOugr/7qEuveZIrAAEC9/QtHtUh2iCDYmCyDMoRLOfYh7hh2oD8
OCzK13CbY5rVQW7hOEI92oWTApsqKIVwNzt1aliykub0jweu1U+WQEINBI2f7uzR
kPXK64ulWFlWDsddCInnyaag2vGQc2Ngx1qUBXaGepwTUMfWblFhmHSVKHIVkLrj
uVsqrHk82szdSBFWDHPgKJpj/bkRnA7mrlDgtzXHw0V0Nw+3Hosf45QxeRG6T8Ms
glXkOr/PsaM=
=bxSk
-----END PGP SIGNATURE-----

--Sig_/cPYMNnSeoodw28pXRQ2U3r5--


--===============0267841818860368949==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0267841818860368949==--
