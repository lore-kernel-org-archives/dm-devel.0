From: Ben Collins <ben.c@servergy.com>
Subject: Re: [PATCH v2] dm crypt: fix deadlock when algo returns
	-EBUSY
Date: Fri, 10 Apr 2015 13:56:46 -0400
Message-ID: <CCE29825-C051-4612-86DD-1CA7A5CF095F@servergy.com>
References: <1428077387-2292-1-git-send-email-ben.c@servergy.com>
	<20150407155501.GA29040@redhat.com>
	<20150407162842.GA54137@redhat.com>
	<BA6189A5-1C3D-4A43-B494-D6FEC7200E7D@servergy.com>
	<20150410151113.GA16795@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: multipart/mixed; boundary="===============3535868728584442280=="
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


--===============3535868728584442280==
Content-Type: multipart/signed;
	boundary="Apple-Mail=_A80E2E9A-9A19-4D2B-9B76-F47D893B2AED";
	protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_A80E2E9A-9A19-4D2B-9B76-F47D893B2AED
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

As expected, this patch works as well as what I had originally done.
Thanks for reviewing it.

=E2=80=94=E2=80=94
Ben Collins
Cyphre Champion
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94
Principal Architect
Servergy, Inc.
469-919-5634 (O)

--Apple-Mail=_A80E2E9A-9A19-4D2B-9B76-F47D893B2AED
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJVKA7eAAoJEF1aV8ckKyLP7XQP/AseGEBSDu7FUypMiNltO5W0
TfhTERP0s84r9ShP9WfJ1t2zdP4iX5d9oYEOVp/ELmwVzk+yb4aEM1zwdF6Z3Bfj
3QNqmupien0qjVaCblaxTww3BYpPZIIgKtlHV4Zgz3QsNsKLKSA+58gySdgQesDw
eb1TQOUQHJgAE3+EMGnrQ4H7L3ZclrpvE4B3vsqKb+oTDrdQJyF1YH58SDO6n+GH
pJfmMP5mOgBpOEKG68raciW8fgy8UFrIK44ZIYEyeMbYU7mKpAYWLM+EWnLltHV4
o19spkWaIB41exAxIw4f1q8Pn2zS5y7u4P5hUezeBJQ5K4/dyD7/ThELsxqAAA3V
TZR027akUYQVXYt4CNKuI4/HxpC/WYQjxWvA0X9WoNXwKBUwxAVPOM+pY6KDd8tD
UaM1uhq0ReLo7oDwCWq5RDS+G84Z0Irb9JDrVsenJ4/UpyltBohv3GioxiRSf4UM
WbwkDLmqElQq4kFa97srxQikFf5qybyMrq9rQDSoIpV9IJDkxuEQtAauHgAOwOWE
5viJqa+FXFEJQxwUY8j2w/m9Sd6sRXinlEJ7WLdOVsBQEIaoZi+Lsf5CoF5vbG+W
FVV4Enqcq5Xgp7HKzkI/SbpLqfBqfqxRPKNfCCftsqqbVAeMRg6A7p/BAIcZNgVG
pM/IcEZ4WIe3gck9MA3C
=M5hD
-----END PGP SIGNATURE-----

--Apple-Mail=_A80E2E9A-9A19-4D2B-9B76-F47D893B2AED--


--===============3535868728584442280==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3535868728584442280==--
