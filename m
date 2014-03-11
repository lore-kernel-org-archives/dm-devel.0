From: Ritesh Raj Sarraf <rrs@debian.org>
Subject: Re: [PATCH] Don't exit() from library
Date: Tue, 11 Mar 2014 20:22:28 +0530
Message-ID: <531F232C.1010405@debian.org>
References: <1394518211-8245-1-git-send-email-rrs@debian.org>
	<531ECD1A.8050807@acm.org>
Reply-To: rrs@debian.org, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0793979781165599500=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <531ECD1A.8050807@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>, device-mapper development <dm-devel@redhat.com>, christophe.varoqui@opensvc.com
List-Id: dm-devel.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============0793979781165599500==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature";
	boundary="fREhIsS34MDfpPT5Dg2HHgc7cHQNMIek0"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fREhIsS34MDfpPT5Dg2HHgc7cHQNMIek0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/11/2014 02:15 PM, Bart Van Assche wrote:
> Hello Ritesh,
>
> Maybe there is something I'm not aware of, but is there any reason why
> the pthread_attr_destroy() call occurs twice in this patch instead of
> invoking it before the "if (rc) {" statement ? From the
> pthread_attr_destroy() man page: "Destroying a thread  attributes objec=
t
> has no effect on threads that were created using that object".
Yup!! You're right. I won't have access to the dev box today. Can you
please follow it up ?

--=20
Ritesh Raj Sarraf | http://people.debian.org/~rrs
Debian - The Universal Operating System



--fREhIsS34MDfpPT5Dg2HHgc7cHQNMIek0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTHyMsAAoJEKY6WKPy4XVpmcwP/j//0B2/XOzQpUJ6vwUPog6T
emRJKqCqSpHGhe/DuOGQlMShNlCbtKLgWGDr0lO0dXW+IPd/PotZp+YEk0MAKfr8
DsEqaX/6OyANJV/OrLqYO77EK7zge3/SBGdLsnxPrugS1fMMhnClr8nfIFYEe0VP
zG3xuouY6VtZQSJUfF186HIpTaedcX5/oHrVKbg3uZmpj+094n3uOXAP6g0+4V5c
n/07eIcMnVvqq8FWYjrX+wpvkCFnB90m+SpwGldkIBcc6DnC47t/7hxvF5m6tShk
6fe7DNPcQ/d9XyPcoL7jcfX607HL5ef1NGQPm3rr3nj8b2gfdq19ElQNM3X2rDN4
nxMTJWnhTrY92bIEdO87MNeHU3vANMhbj2N9EtZE4sO5Z1TDA6qsSl6+uNLDhoo+
kRsPc2UqUUR3H/789NSvlPJlKbylEpMtEDJncON/UzDBO58JQAhzgZodlATCnux0
jyEiggH1bv1uX2k5lbuXoBdrD7gXDQShNpqHJeQA1dwnBydy4tTnkvCDweD2mezy
bVuw8o0HQm6+80oK2nfMxrKONUngg9AW2Sob1WEdw5pqjDDDDKN+EnjjOXNV6Wpk
2r/QZoaY8pv1zhGhC0U2nLza6ysOGkJe0SaPMCKwCcNCKvrPSEpMEUtQ6p5kn3yr
tJHWn8g1/hKKCFrKSoUA
=JF1H
-----END PGP SIGNATURE-----

--fREhIsS34MDfpPT5Dg2HHgc7cHQNMIek0--


--===============0793979781165599500==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0793979781165599500==--
