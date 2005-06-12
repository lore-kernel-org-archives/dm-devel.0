From: Axel Thimm <Axel.Thimm@ATrpms.net>
Subject: Re: StorageWorks failover model (was: tools target for
	SLES9 SP2 and RHEL4 U2)
Date: Sun, 12 Jun 2005 16:33:14 +0200
Message-ID: <20050612143314.GA19762@neu.nirvana>
References: <1118341002.14457.23.camel@zezette>
	<20050609191541.GO15809@agk.surrey.redhat.com>
	<1118345693.14457.30.camel@zezette>
	<20050612122138.GA16608@neu.nirvana>
	<1118579487.20754.59.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0918219655=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1118579487.20754.59.camel@zezette>
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


--===============0918219655==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 12, 2005 at 02:31:26PM +0200, christophe varoqui wrote:
> On dim, 2005-06-12 at 14:21 +0200, Axel Thimm wrote:
> > Hi,
> >=20
> > On Thu, Jun 09, 2005 at 09:34:53PM +0200, christophe varoqui wrote:
> > > On jeu, 2005-06-09 at 20:15 +0100, Alasdair G Kergon wrote:
> > > > On Thu, Jun 09, 2005 at 08:16:42PM +0200, christophe varoqui wrote:
> > > > > Should we stabilize a 0.4.5 out of the git head
> > > be aware I broke the StorageWorks failover model to satisfy the
> > > expressed need to proactively fail paths in the DM when the checkers =
see
> > > them going down.
> >=20
> > What does that mean for StorageWorks users? I'm currently setting up a
> > StorageWorks EVA3000 from scratch based on FC4 final. Will I stumble
> > into any pitfalls, or would that only affect gits users?
> >=20
> 0.4.4 should be ok. I don't know what FC packagers did though.

It's 0.4.4.2 with a couple of patches. Is that still OK?

> Also be aware you'll be best served using the failover policy for now :
> there is a 20% performance impact with multi-path per PG.

The default multipath.conf ships with path_grouping_policy multibus
(e.g. all 4 paths in one path group on a 2x active/2x failing
controller setup). I understand that doing round robin over the active
and failed paths will make performance drop.

But what about path grouping with group_by_serial (like tur did,
e.g. an active path group and a failing path group)? Is that eating
performance, too? So I should prefer a path per PG (failover)?

Thanks!
--=20
Axel.Thimm at ATrpms.net

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCrEeqQBVS1GOamfERAvAaAJ9yL/GeA0MGU5HXHzgd6JqlZfApYwCfVl0a
QXT4/sE+5R4+HryCP0CeVak=
=fSyk
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--


--===============0918219655==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0918219655==--
