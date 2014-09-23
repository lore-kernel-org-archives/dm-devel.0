From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] dm-raid: add RAID discard support
Date: Wed, 24 Sep 2014 09:33:08 +1000
Message-ID: <20140924093308.120fe616@notabene.brown>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
	<yq18ulaszpk.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5027236980701182194=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <yq18ulaszpk.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5027236980701182194==
Content-Type: multipart/signed; micalg=pgp-sha1;
	boundary="Sig_/iZyq3UaN=r4qca1gHwhDQat";
	protocol="application/pgp-signature"

--Sig_/iZyq3UaN=r4qca1gHwhDQat
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Sep 2014 19:07:35 -0400 "Martin K. Petersen"
<martin.petersen@oracle.com> wrote:

> >>>>> "Heinz" =3D=3D heinzm  <heinzm@redhat.com> writes:
>=20
> Heinz> In case of RAID levels 4,5 and 6 we have to check for the
> Heinz> capability to zero data on discards to avoid stripe data
> Heinz> corruption.
>=20
> I'm quite concerned about relying on discard_zeroes_data since it's a
> hint and not a hard guarantee.
>=20

If it is a "hint", then why isn't it "discard_sometimes_zeroes_data"?

md/raid5 already depends on this.  If a read from a discarded region doesn't
reliably return zeros, then raid5 cannot support discard.
Should I turn of discard support in raid5?

Also, could you help my understand when such a hint-but-no-guarantee would =
be
useful?

Thanks,
NeilBrown

--Sig_/iZyq3UaN=r4qca1gHwhDQat
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCIDOznsnt1WYoG5AQLSNQ//c76Q03kNLZYqi4iHSY9hp6ryIcVqREE1
GxzC5b7F4pYW8m7JXaPpXEGhyYtaUyfcDTpOf0Xu1DkRYPuBNNUKyrjh5cqd3dhF
EFb6RKdVSW2s2Q7WClOfNHfseZlCHQykCl/ulpGybcGOBa3AKOd6AQ+SKjLI4oz+
Vevgh7GlKYltctL3RbQ+Mu+BVeJR8e/6Z+9s0D0tchRW7oc5MoEcB3eY8KnlMJqK
dx2JYLTsChfAqzOIn7h3hq/Y/7T2thGuVDjUGA5ewayEdSeAUQhpMiTA9mJBtU3I
2JWj4JLNaMILvC7BBIT+MkbXj0j53uUgIHohTKxLLJTmuDXfnxmM0qnVdZLU9zgC
gQotu9AIgikEmng1ZZPnV3k+QQAutWoLcZbALwjxdMmjBiKIh495gekphRdhGv1g
O3kOUtU9VcP4KRGXJKMKoF07X38W2koXcsMAbweDn2OJwP+57ciO92FNNqlSTQHs
CCzlIZGV6RWZjZ6p0MSIrGosB7tkjMmiUXf99zYRb1eUxCECJQ8YB3L/vFgxzkzk
tmt9pAWbnrz5hJn3ju1bayNxINXtRDhgFhtzRAFh/+ZF7v3ro+rWgNNnDHHepn7T
a53pWpAMFb57AsIIhZXHSfJC3ubUdPDYKwSf/j9BvjAa3R31l16XH4Rbe5LmljCd
Q1+Hs+fCvMU=
=tRRs
-----END PGP SIGNATURE-----

--Sig_/iZyq3UaN=r4qca1gHwhDQat--


--===============5027236980701182194==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5027236980701182194==--
