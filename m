From: rgammans@computer-surgery.co.uk
Subject: Re: dm-snapshot scalability - chained delta snapshots
	approach
Date: Wed, 27 Sep 2006 11:40:35 +0100
Message-ID: <20060927104035.GA4939@computer-surgery.co.uk>
References: <44DA246B020000B60000BD22@lucius.provo.novell.com>
	<44DB5BDD020000B60000BD96@lucius.provo.novell.com>
	<44DB5C21.F25D.00B6.0@novell.com> <451A5915.F25D.00B6.0@novell.com>
	<20060927091700.GA6314@X40.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1476770544=="
Return-path: <dm-devel-bounces@redhat.com>
Resent-Message-ID: <20060927120650.GA6294@computer-surgery.co.uk>
Resent-To: dm-devel@redhat.com
In-Reply-To: <20060927091700.GA6314@X40.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jblunck@suse.de, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--===============1476770544==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 27, 2006 at 11:17:00AM +0200, Jan Blunck wrote:
> We discussed some of the ideas about snapshots here at the dm summit. The
> general ideas are as follows:
>=20
> - one exception store per origin device that is shared by all snapshots
> - don't keep the complete exception tables in memory all the time
> - limit kcopyd outstanding requests
[snip]
> target. The throughput issues should be addressed by only writing to one
> exception store. The memory issues should be addressed by the changes to =
the

I have a need fro a 'snapshot' type dm mode which has this
characterstic. Eg, it leavse to origin device completely untouch by any
changes.=20

I was thinking that I'd have to code it myself from scratch as I could
see any simple way of reuse the existing dm-snap code - especially since
in my case the origin device will always be a physical volume (ie hda).

However if I can make use of a new dm-exception-store and possibly
even contribute to it this would be better.

I was considering some sort of B or B+ -tree type arrangement as then
we can use the buffer-cache (I'm assuming something similiar still
exists after the bh -> bio rewrite but I 'm a lttle behind) to store
the commonly referenced exceptions, which should keep the memory
required by the tables down at times of high memory pressure.

> There are still ongoing discussions about the snapshot target. It would be
> nice if you have additional thoughts about this proposal. I guess it is
> similar to one of your prototypes.

Is this where those discussion are taking place if I want to help=20
and particpate?

TTFN
--=20
Roger. 	                        Home| http://www.sandman.uklinux.net/
Master of Peng Shui.      (Ancient oriental art of Penguin Arranging)
Work|Independent Sys Consultant | http://www.computer-surgery.co.uk/
 New key Fpr: 1227 ABB1 7545 77A7 6816  2D18 4EBC AA9B 8EE3 1DD3

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFFGlUjTryqm47jHdMRApBHAJ9voZWk87cDQBKVuZGl07jWmuyfhQCdGAxR
/spXQrWnM2bh8wDQs2QcZ8U=
=tFqG
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--


--===============1476770544==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1476770544==--
