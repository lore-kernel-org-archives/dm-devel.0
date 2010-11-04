From: Diego Elio =?ISO-8859-1?Q?Petten=F2?= <flameeyes@gmail.com>
Subject: multipath-tools comments and licensing status?
Date: Thu, 04 Nov 2010 12:52:46 +0100
Message-ID: <1288871566.4517.149.camel@yamato.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1836579999533248280=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============1836579999533248280==
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature";
	boundary="=-VnushPc7LYRP3fv9e0Pe"


--=-VnushPc7LYRP3fv9e0Pe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I've been looking at multipath-tools as I was suggested to look at
kpartx to mount partitioned disk images. It doesn't install in my Gentoo
because of two problems: buffer overflows reported by _FORTIFY_SOURCE
and --as-needed failures. Both are trivial to fix but there are other
problems.

a) buildsystem

While it's trivial to fix the build, I wonder if it wouldn't make more
sense to simply rewrite it with classical autotools, I can do that quite
easily, and it would have better results on the long run most likely,
especially for distributions.

b) general code string handling

There are two sure buffer overflows in datacore.c and hds.c when setting
vendor, as it'll be trying to write the null termination outside of te
buffer; it's trivial to fix, but actually the vendor array is only
filled in for hds.c to log it out (why not printing the expression
directly?) and not used at all in datacore.c; the same is true of the
other buffers.

In configure.c (and other files) WWID_LEN is improperly handled because
the various arrays don't consider NULL-termination, and in particular at
configure.c:173 the strncat() is using the totally wrong size and will
almost certainly always overflow if hit.

c) licensing.

This seems to be the most serious problem here: it doesn't seem like
there is a clear license on the software! There is a COPYING file with
LGPL 2 (not 2.1, but the Library version itself), most of the files
don't seem to declare a license at all, hbs.c declares itself to be GPL
(but not v2), while datacore.c declares itself as GPLv2. In Gentoo, the
package is listed as having GPL-2 license.

I'll be honest, I don't have any particular interest in fixing all of
this myself; I can send you the two patches for the issue above, not
particularly caring for the licensing situation. If you sort out the
licensing situation I can take care of rebuilding the build system
during free time. But if this is intended for production use somebody
should really review the code, professionally.

Sorry if it sounds harsh, I'm just not one for sugar-coating quick code
reviews.

--=20
Diego Elio Petten=C3=B2 =E2=80=94 =E2=80=9CFlameeyes=E2=80=9D
http://blog.flameeyes.eu/

If you found a .asc file in this mail and know not what it is,
it's a GnuPG digital signature: http://www.gnupg.org/


--=-VnushPc7LYRP3fv9e0Pe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQEcBAABCAAGBQJM0p6LAAoJEBqCrVe7WSRD8WIH/AhzVxBuBnZsVKuZMitJAEos
3TZC4AMwHl3DfvykkR7wMArcXI5ZFMrf0YI6lQZu3CCICh/LWzeJqWjOaATuY5Mj
Hx1Xu7Fi1Whh5SRQwGHmA/v+EkF9oN7G0k9aNunI3LsfUmCnIXWa0E90k5abRGZw
HZqkPgZNPthVF06J+KVZFA1i343QrCBTKyRdl5SeHWsJ5Vj2peuc7DzMKfERH1Lm
CCghwyjiBMVaaZ1EhAJLtH1P6ceXyL874NegymPUQC51I0h0J6EyXTRaLBfVbrtM
0RISuZP0+WbIMpoX/1Nc6eji624hLza2LHYtBIqvLGXK/2PDpw0PgNvYENXKPWA=
=Ov25
-----END PGP SIGNATURE-----

--=-VnushPc7LYRP3fv9e0Pe--


--===============1836579999533248280==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1836579999533248280==--
