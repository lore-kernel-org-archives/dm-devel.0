From: Piet Delaney <piet@bluelane.com>
Subject: Re: Re: Data corruption with
	raid5/dm-crypt/lvm/reiserfs on 2.6.19.2
Date: Thu, 22 Feb 2007 15:43:13 -0800
Message-ID: <1172187794.8709.124.camel@piet2.bluelane.com>
References: <d00698fb0701181211l480966e5o6f10db9300d4c8aa@mail.gmail.com>
	<20070122115652.1f7862e1.akpm@osdl.org>
	<1169502141.17211.7.camel@leto.intern.saout.de>
Reply-To: piet@bluelane.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0769487124=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1169502141.17211.7.camel@leto.intern.saout.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Andrew Morton <akpm@osdl.org>, noah <noah123@gmail.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


--===============0769487124==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-6ukiMLQuj8Ha4W3hf3LX"


--=-6ukiMLQuj8Ha4W3hf3LX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-01-22 at 22:42 +0100, Christophe Saout wrote:
> Am Montag, den 22.01.2007, 11:56 -0800 schrieb Andrew Morton:
>=20
> > There has been a long history of similar problems when raid and dm-cryp=
t
> > are used together.  I thought a couple of months ago that we were hot o=
n
> > the trail of a fix, but I don't think we ever got there.  Perhaps
> > Christophe can comment?
>=20
> No, I think it's exactly this bug. Three month ago someone came up with
> a very reliable test case and I managed to nail down the bug.
>=20
> Readaheads that were aborted by the raid5 code (or some layer below)
> were signalled using a cleared BIO_UPTODATE bit, but no error code, and
> were missed as aborted by dm-crypt (all other layers apparently set the
> error code in this case, so this only happened with raid5) which could
> mess up the buffer cache.
>=20
> Anyway, it then turned out this bug was already "accidentally" fixed in
> 2.6.19 by RedHat in order to play nicely with make_request changes (the
> stuff to reduce stack usage with stacked block device layers), that's
> why you probably missed that it got fixed. The fix for pre-2.6.19
> kernels went into some 2.6.16.x and 2.6.18.6.

Hi Chris:

I've been trying Andrew's suggestion of doing fault injections,
currently just kmalloc() and mempool_alloc(), and just got a hang
on 2.6.12 that I'm poking around on with kgdb. I'm using dm-crypt
on a SCSI raid-1 (mirrored) root partition. I'm using your patch=20
that fixes the raid5 problem just to play it safe.

So far it looks like processes are waiting to be woken up by
the buffer cache once reads have completed.=20

-piet

>=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
--=20
Piet Delaney                                    Phone: (408) 200-5256
Blue Lane Technologies                          Fax:   (408) 200-5299
10450 Bubb Rd.
Cupertino, Ca. 95014                            Email: piet@bluelane.com

--=-6ukiMLQuj8Ha4W3hf3LX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBF3iqRJICwm/rv3hoRApczAJ9/NeOS+Lzf36Tay/S8/kiRga7ZfACfUmo4
yoPTqZCsjBLkGUMQ7lrRYb0=
=O7U1
-----END PGP SIGNATURE-----

--=-6ukiMLQuj8Ha4W3hf3LX--


--===============0769487124==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0769487124==--
