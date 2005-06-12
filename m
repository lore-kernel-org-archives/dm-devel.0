From: Axel Thimm <Axel.Thimm@ATrpms.net>
Subject: StorageWorks failover model (was: tools target for SLES9
	SP2 and RHEL4 U2)
Date: Sun, 12 Jun 2005 14:21:38 +0200
Message-ID: <20050612122138.GA16608@neu.nirvana>
References: <1118341002.14457.23.camel@zezette>
	<20050609191541.GO15809@agk.surrey.redhat.com>
	<1118345693.14457.30.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1625580816=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1118345693.14457.30.camel@zezette>
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
List-Id: dm-devel.ids


--===============1625580816==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jun 09, 2005 at 09:34:53PM +0200, christophe varoqui wrote:
> On jeu, 2005-06-09 at 20:15 +0100, Alasdair G Kergon wrote:
> > On Thu, Jun 09, 2005 at 08:16:42PM +0200, christophe varoqui wrote:
> > > Should we stabilize a 0.4.5 out of the git head
> be aware I broke the StorageWorks failover model to satisfy the
> expressed need to proactively fail paths in the DM when the checkers see
> them going down.

What does that mean for StorageWorks users? I'm currently setting up a
StorageWorks EVA3000 from scratch based on FC4 final. Will I stumble
into any pitfalls, or would that only affect gits users?

Thanks!

> StorageWorks hardware relied on the daemon to keep the paths in failover
> path groups to be in active state. That is no longer the case, now that
> we keep the DM path state in sync with checker states.
>=20
> I guess to correct way to get back to a working model is to implement
> the DM path activation in a hardware handler. Dave Olien and Mike
> Christie have worked on such a handler. It needs debuging and testing.
>=20
> Regards,

--=20
Axel.Thimm at ATrpms.net

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCrCiHQBVS1GOamfERAgBUAJ4u7oYTRZgJ+rNqd/+/9OkhMXxNIwCgkAJx
kBhZo1oMXP85B4SKUtuhyyQ=
=vXOL
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--


--===============1625580816==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1625580816==--
