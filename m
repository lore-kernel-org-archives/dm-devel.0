From: Ben Collins <ben.c@servergy.com>
Subject: Re: [PATCH v2] dm crypt: fix deadlock when algo returns
	-EBUSY
Date: Fri, 10 Apr 2015 11:12:40 -0400
Message-ID: <88C5DE20-FA1B-4F37-B54C-F7388AA41023@servergy.com>
References: <1428077387-2292-1-git-send-email-ben.c@servergy.com>
	<20150407155501.GA29040@redhat.com>
	<20150407162842.GA54137@redhat.com>
	<BA6189A5-1C3D-4A43-B494-D6FEC7200E7D@servergy.com>
	<20150410151113.GA16795@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: multipart/mixed; boundary="===============3371426391350474215=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150410151113.GA16795@redhat.com>
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids


--===============3371426391350474215==
Content-Type: multipart/signed;
	boundary="Apple-Mail=_11D624F3-A26D-450D-BE07-43F066F3C0B7";
	protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_11D624F3-A26D-450D-BE07-43F066F3C0B7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Apr 10, 2015, at 11:11 AM, Mike Snitzer <snitzer@redhat.com> wrote:
>=20
> On Tue, Apr 07 2015 at  1:10pm -0400,
> Ben Collins <ben.c@servergy.com> wrote:
>=20
>>=20
>>> On Apr 7, 2015, at 11:28 AM, Mike Snitzer <snitzer@redhat.com> =
wrote:
>>>=20
>>> On Tue, Apr 07 2015 at 11:55P -0400,
>>> Mike Snitzer <snitzer@redhat.com> wrote:
>>>=20
>>>> It looks like you're _always_ using the completion regardless of =
whether
>>>> crypt_convert() will be waiting (e.g. even if error is 0).
>>>>=20
>>>> I can see this "working" but it seems less than ideal.  Would it be
>>>> better to record the need to use the completion in ctx and then
>>>> conditionally call complete()?
>>>=20
>>> Actually, how about using !completion_done() before calling =
complete()?
>>> If you think this would be OK, any chance you could re-test with =
this?
>>=20
>> I'll be able to test it before Friday (out of town). Thanks
>=20
> Hi Ben,
>=20
> I'm still waiting for test feedback from you on v2.  Fairly certain
> you'll have the same results but I'd like to be certain before pushing
> this upstream.

I'll have a response within a couple hours...

=E2=80=94=E2=80=94
Ben Collins
Cyphre Champion
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94
Principal Architect
Servergy, Inc.

--Apple-Mail=_11D624F3-A26D-450D-BE07-43F066F3C0B7
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJVJ+hpAAoJEF1aV8ckKyLP4skQAKm+bpAv99vKcgDv/xlKpK99
LPtX3ErTxgGsod2vWmBXuLxj8eAF5N7YmhCwx9F4diyhRAV+F4/YpybXUEBq6CAa
HSnAL4s+O1+AWOI4SJxMzeqn7HTUXhlQLdfQ8xKDPmAiaUmRlrOlEGKTINSVwB/+
HT7weknCc0jBTFuFNonmek3WQHIrPu7nJNZye7oy+ywqkxqFKG2+pBos+dmL2Txq
f4eghbBa6yuxyXPcrjahP8hI7BiVuk0Ibw9skAgN3jKXBT1D5MWBEsPxhRZ3UvDO
A7rYyRc5Uj7UShSbooXMtpeWdFLEJcS5wUiy3OelR5RvFrCbqhkhXUtgg6YEgOfm
pW4hdimYIMbSS/AFYuHtNWgm2nkkM1Dy3Q4NyeZfpvvlitqzr5Yl4OkiK8TqxcF5
7AEUg2M68TJaPFU9lkYyWy+5hXpy7tU+KgIxEQsR4+zKpoGEDlVljjZBkMjJ9fVI
XgZWkgMm/DHNYJUBZQCMBL/7WgS3ghBGX87pQkpxQklW2bv/URNuzWA3qpKTziNA
jLccbidt74cy2Km5Z2NWaUaENaL2q8msY5Ectni+50rP1T6sgnSxDf8/y/D5cIey
gAMmO7QVofSARDmHAajVN31tb+pQADp3KsW5vqISZotI/XOHuvD1FCOdYb0SO2KI
Z3uUVzKH5nNMAJf9d0x7
=Dspd
-----END PGP SIGNATURE-----

--Apple-Mail=_11D624F3-A26D-450D-BE07-43F066F3C0B7--


--===============3371426391350474215==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3371426391350474215==--
