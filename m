From: Nuno Fernandes <npf@eurotux.com>
Subject: Re: Device-mapper-multipath RDAC
Date: Tue, 25 Sep 2007 08:52:08 +0100
Message-ID: <200709250852.08464.npf@eurotux.com>
References: <200709241706.26322.npf-mlists@eurotux.com>
	<46F8A29F.6060803@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2064788140=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46F8A29F.6060803@suse.de>
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

--===============2064788140==
Content-Type: multipart/signed; boundary="nextPart51777147.xGfnCypzVn";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart51777147.xGfnCypzVn
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 25 September 2007 06:54:39 Hannes Reinecke wrote:
> Nuno Fernandes wrote:
> > hello,
> >
> > Just a question:
> >
> > With recent support for rdac hardware handler in kernel 2.6.23-rc7, what
> > configuration should be in storage DS4700? AVT (Automatic Volume
> > transfer) turned on or off?
>
> Off. AVT is the acronym for 'Automated Volume Transfer', ie the array tri=
es
> to transfer the volumes from one controller to the other automatically.
>
> > When it's turned on, luns keep on jumping from controller to controller=
=2E.
>
> Indeed. That's to be expected.
>
> As a rule:
>
> - With rdac hardware handler: AVT off
I'm in the process of testing avt in the kernel.

> - Without hardware handler: AVT on
With this situation i don't have any point of failure but the lun keeps on=
=20
jumping (because of the alive path check of multipathd) and the performance=
=20
is awfull.

Best regards
Nuno Fernandes

>
> Cheers,
>
> Hannes



--nextPart51777147.xGfnCypzVn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBG+L4obJtoPy2XRQkRAi8wAJ0U7rziNGvq0+plasAuTkBghpPE/wCePRvo
pq1iTL43tW01rNLuGryCPcY=
=KJHM
-----END PGP SIGNATURE-----

--nextPart51777147.xGfnCypzVn--


--===============2064788140==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2064788140==--
