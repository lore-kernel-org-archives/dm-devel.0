From: =?ISO-8859-1?Q?=C9tienne?= BERSAC <etienne.bersac@nonstop.fr>
Subject: Re: dm-cache caching network volume
Date: Thu, 20 Jun 2013 11:31:27 +0200
Message-ID: <1371720687.30405.5.camel@expiron>
References: <mailman.51.1371657606.18923.dm-devel@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5172534590809672899=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <mailman.51.1371657606.18923.dm-devel@redhat.com>
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


--===============5172534590809672899==
Content-Type: multipart/signed; micalg="pgp-sha1";
	protocol="application/pgp-signature";
	boundary="=-abnb1+PTcwJ2xMu/xV4u"


--=-abnb1+PTcwJ2xMu/xV4u
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Thanks for the reply :-)

I actually uses write-back. Here are the tables :

----8<----
cache_cacher: 0 1024 linear 254:32 2097152
cache_origin: 0 2048 linear 8:0 0
cache: 0 2048 cache 253:3 253:4 253:2 512 1 writeback default 4 sequential_=
threshold 2147483648 random_threshold 4
cache_metadata: 0 2097152 linear 254:32 0
---->8----

8:0 is /dev/sda, the iSCSI target.
254:32 is /dev/vdc, a virtio volume accessing a LV on a SSD.

The thing is : the cache status properlay state that new blocks in cache
are filled, they are even marked as dirty. Which suggest they are not in
the backing device. But actually, it blocks when iSCSI detects the
network failure.

Can dm-cache handle writes without querying the backing device until it
needs demotion ?

Regards,
--=20
=C3=89tienne BERSAC <etienne.bersac@nonstop.fr>
NON STOP Systems

--=-abnb1+PTcwJ2xMu/xV4u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRwsvvAAoJEF5WQ9pdAIwZkgoIALTb0C2RARwn5QrDPkGpocBy
uO11Y3lQoEi/NV0/ATStJh1x5JjRq7Pc6eB8acBJ6w4kTv5xzh7A8rv1Et5BmXyv
Sxlv2+nev7uploZTLM8T+TExQDBBs+b/Kxt7zbI9XAh/G+qVLAkbm3WXNRH9b4Wa
5sWvCYLaZTrLFPGQ6HU7L0SrS/KOtU+h4L3LMe7xxYpHbusvX6DqDdl29VuidIAJ
1hCEZl6GM/kJwDgfRT1GJV2TwIA17OBkbveizt53Z8Z8TUckHPzi8htEY8uInhJv
3JWAbYV5Cip6t2lF/vG2q1YawiBUP5ZkRNLQ1bsG6wPgvLYgXxSoW405bv1hAfQ=
=3eOq
-----END PGP SIGNATURE-----

--=-abnb1+PTcwJ2xMu/xV4u--


--===============5172534590809672899==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5172534590809672899==--
