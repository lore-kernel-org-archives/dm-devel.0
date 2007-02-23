From: Piet Delaney <piet@bluelane.com>
Subject: Re: [dm-devel] [PATCH] device-mapper: Bad Block
	relocation target
Date: Thu, 22 Feb 2007 16:42:47 -0800
Message-ID: <1172191367.8709.139.camel@piet2.bluelane.com>
References: <20070210010159.835207B409F@zog.reactivated.net>
	<1172186872.8709.114.camel@piet2.bluelane.com>
	<45DE32BE.7030905@gentoo.org>
Reply-To: piet@bluelane.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1261687256=="
Return-path: <evms-devel-bounces@lists.sourceforge.net>
In-Reply-To: <45DE32BE.7030905@gentoo.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=evms-devel>
List-Post: <mailto:evms-devel@lists.sourceforge.net>
List-Help: <mailto:evms-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: evms-devel-bounces@lists.sourceforge.net
Errors-To: evms-devel-bounces@lists.sourceforge.net
To: Daniel Drake <dsd@gentoo.org>
Cc: akpm@osdl.org, device-mapper development <dm-devel@redhat.com>, Piet Delaney <piet@bluelane.com>, evms-devel@lists.sourceforge.net
List-Id: dm-devel.ids


--===============1261687256==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-2vu54lmqycE2pQspJSFZ"


--=-2vu54lmqycE2pQspJSFZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-02-22 at 19:18 -0500, Daniel Drake wrote:
> Piet Delaney wrote:
> > On Sat, 2007-02-10 at 01:01 +0000, Daniel Drake wrote:
> >=20
> > Nice patch Daniel, wondering about using it in 2.6.12.=20
>=20
> It won't compile there. You can probably find a 2.6.12-compatible=20
> version in an EVMS tarball though.

I think I found it at:

      http://dev.gentoo.org/~dsd/genpatches/patches-2.6.12-10.htm

looks like it should be in the extras patch I just downloaded:

    4305_dm-bbr.patch
    EVMS 2.5.2
    Bad block relocation support for LiveCD users

What's the LiveCD got to do with it?

So if I install it I'd be want to be sure it works. How do ya test it?

>=20
> It's also not written by me, copyright messages indicate IBM wrote it.
>=20
> I will hopefully look at the last few feedback items and send in a newer=20
> version soon for the next round of feedback.

While break-pointing around the ext3 code looking for the cause of
a hang I was thinking that many times they leave in the white space=20
as if the brackets were there.
	.					.
	.					.
	.					.
	if (panic) {				if (panic)=20
		printk("die\n");			printk("die\n");
	}
	return;                                 return;
}					}

Just leaving in the blank line seems to provide much of the
parse-ability of your current style to me and very likely=20
keeps it in the kernel coding style.

-piet

>=20
> Daniel
--=20
Piet Delaney                                    Phone: (408) 200-5256
Blue Lane Technologies                          Fax:   (408) 200-5299
10450 Bubb Rd.
Cupertino, Ca. 95014                            Email: piet@bluelane.com

--=-2vu54lmqycE2pQspJSFZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBF3jiHJICwm/rv3hoRAqM7AJ9BcNf3KBGRwktyveiaTPhc4X97hQCfYVB5
AXO+4YU2s4JIO/8Yuk3N+S8=
=dWW7
-----END PGP SIGNATURE-----

--=-2vu54lmqycE2pQspJSFZ--



--===============1261687256==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys-and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
--===============1261687256==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Evms-devel mailing list
Evms-devel@lists.sourceforge.net
To subscribe/unsubscribe, please visit:
https://lists.sourceforge.net/lists/listinfo/evms-devel

--===============1261687256==--
