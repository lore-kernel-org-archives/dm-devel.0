From: Thomas Deutschmann <whissi@gentoo.org>
Subject: Re: [PATCH] multipath-tools: Makefile: Respect standard
 toolchain related envvars
Date: Tue, 12 Dec 2017 17:09:00 +0100
Message-ID: <b6780fff-ecc4-2b7a-bfcb-51bbf6b654a1@gentoo.org>
References: <20171129232311.95483-1-whissi@gentoo.org>
	<1513092491.3704.2.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7429790758183062671=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1513092491.3704.2.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============7429790758183062671==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature";
	boundary="28wPUhcAVmL7waxpCj3bBcEEDxPfok4xv"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--28wPUhcAVmL7waxpCj3bBcEEDxPfok4xv
Content-Type: multipart/mixed; boundary="81G4vCS65gU8TjO6UunVVPrpDW7veoq79";
	protected-headers="v1"
From: Thomas Deutschmann <whissi@gentoo.org>
To: Bart Van Assche <Bart.VanAssche@wdc.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Message-ID: <b6780fff-ecc4-2b7a-bfcb-51bbf6b654a1@gentoo.org>
Subject: Re: [dm-devel] [PATCH] multipath-tools: Makefile: Respect standard
	toolchain related envvars
References: <20171129232311.95483-1-whissi@gentoo.org>
	<1513092491.3704.2.camel@wdc.com>
In-Reply-To: <1513092491.3704.2.camel@wdc.com>

--81G4vCS65gU8TjO6UunVVPrpDW7veoq79
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Bart,

On 2017-12-12 16:28, Bart Van Assche wrote:
> I agree that we need a way to specify additional compilation flags. How=
ever, is
> OPTFLAGS really a standard? Aren't most developers used to set CFLAGS t=
o specify
> additional compilation flags?

When I created the patch I searched in the source code of other projects
after "OPTFLAGS" usage and came to the conclusion that this isn't a
standard.

However, my patch shouldn't break any existing use cases.

So my understanding was that "OPTFLAGS" is used like the default set of
flags in case the user hasn't set any flags on its own. However, the
project may still need to add a special flag which should be set everywhe=
re.

That's why I created the patch the way I did:

1) User can provide own CFLAGS in which case the default set of flags
(OPTFLAGS) aren't used.

2) We now extend set CFLAGS by adding our additional flags (-DRUN_DIR..)
we want to be set everywhere.


Your patch will do the same but require downstream to unset/negate
default flags. I don't really care if we pick your patch or my patch.


--=20
Regards,
Thomas Deutschmann / Gentoo Linux Developer
C4DD 695F A713 8F24 2AA1 5638 5849 7EE5 1D5D 74A5


--81G4vCS65gU8TjO6UunVVPrpDW7veoq79--

--28wPUhcAVmL7waxpCj3bBcEEDxPfok4xv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQKTBAEBCgB9FiEEM8WEgsQCKS0uPFwGlwn5DDyW/8gFAlov/x9fFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldDMz
QzU4NDgyQzQwMjI5MkQyRTNDNUMwNjk3MDlGOTBDM0M5NkZGQzgACgkQlwn5DDyW
/8iT0BAAsEDn30oojgrNnMSi2hDCDkKXJXV/hKl9UpixdUrQjoMgECnRAwlOstTL
BIa7/Gf0fWT603kpRsInnmEqD3tFH7sfR3dbTk7/J1b0FLXHa8Tg1zS2F038EfeC
hJrsx6IpoDXSRQ/diQUa0PAQ0gigfvNdWUHVRHus+oL/kq3kc42hrojTu3TxGBD6
jWeY1pD7zyChIwAquGReMg3x2JQcuKymlfjRWasfXJAY47I0JJNgX97b9al/rSD2
CdzULuGbprh5XDXIUa40vxkvF/6S2w1mOULfin4orsFc4hsBRbm//7Rg4alGhrUv
wd1QAgoxh3ejrglqIhaM7TRoUCZ5C+5vA4wmHKa2eslc5Hv9HbHE0ZoIY1ZeAs2a
tnYaidnJ8PEBe6ltXbBZBfg8N6ZtONUwsewTJczmbPCEnuVOOszvcOf9rZrQOHK2
Dowb/MK+ufQRVKsSKwf81Jjwme+pkENTHXY1bNDQQh1OcRjwykl3j26WNslTIWnX
DvhbJkMJOl5oPf6UUuUPLT6LWbdeDAstPPO9JrJCZt4XMC6ZBncr01dSMbi+QP2K
sk2X5fem7Egmx3O7mnt5+NajXRRVYfJW4uMKX/2IUfGlrjTp+pwp/sjSAFlH3J50
XNfpDW2MYxP2Fb04nI9882IvY0SNeYIHvwi5UHadM62XVJFPU0M=
=ZMfR
-----END PGP SIGNATURE-----

--28wPUhcAVmL7waxpCj3bBcEEDxPfok4xv--


--===============7429790758183062671==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7429790758183062671==--
