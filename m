From: Gris Ge <fge@redhat.com>
Subject: Re: [PATCH 2/3] multipath-tools: libdmmp: Improve
 timeout mechanism
Date: Mon, 28 Aug 2017 20:58:48 +0800
Message-ID: <20170828125848.GA15058@redhat.com>
References: <20170816123409.16535-1-fge@redhat.com>
	<20170816123409.16535-2-fge@redhat.com>
	<1503005396.7232.11.camel@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1686288372161014797=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1503005396.7232.11.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============1686288372161014797==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 17, 2017 at 11:29:56PM +0200, Martin Wilck wrote:
> On Wed, 2017-08-16 at 20:34 +0800, Gris Ge wrote:
> > Issue:
> >     libdmmp return error of timeout before user requested timeout was
> >     met.
>
> Maybe I'm missing something here, but if you just retry the timed-out
> command, isn't it likely that you'll hit the uxsock_timeout again and
> again?
>
> Best,
> Martin
Hi Martin,

You will get timeout again after `uxsock_timeout` seconds if the
daemon/multipathd haven't finish its work on dm tables and invoking path
checker. But eventually, you will the requested data.

--=20
Gris Ge

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8f1XsqXpyNthgIbGbM3lj+QeKP8FAlmkE4QACgkQbM3lj+Qe
KP9DhxAAgaMhACNJveRUwvMSMurH1Ie/I/SBqLvUfqnbZe+eHKAW0KNOZW6xgd11
CD6UqiYj73iT7vxGgF6ulWLxnNJLR5JExYj5uUkSukDPCHju9oGxGSqab8TXZzdD
BpFzMw/ZMyG+zfw/Y8L4shEVcS7e6gQHtIlcvCKvId+wgEltgP++JdJuIDqRWio8
zyNrcVgA3Nu5e8R0IDLPuL6jRsicG0WSYCVi7NZ9dFNavVbjxCFY72rP0CI2wHOo
13L3Cez/Hp6FKuBq+uFzvRFcUq96PzdcZ22QnESR9QUM7NMhmmJea7ETzwbWapgX
fODTMFoYgmZX9IS9zTV8bXJnxKuIqb+CD58RnnRY3JQhqvXq3TAZ8j3qCpwqTrv+
j5DeYNjj+UheEcJewOLFPnNDv1QZSOa6TU2hvZLrV3s/tcNd8toMyN4K1mm5rOVi
nRAZsaFVzHB4VACUjjH5GRQ4zGii8DxLYXf8Wegq0j7V/VKp6MZ3Zy9qwLtMIslG
j8zND0bNOFu16D91354v88GBY+Ku7EUyTkdjAYC4QVE8YpQ+lyccemwje9acG9sf
b+w3bBpiaNHACOQS5uTUevzqQrHyGwmvsouJoKMrDsaS+1Yo266OFUFXnHP4BVGS
VLmlR3dU89nS7b0F9L29sIUORSFo6KEhwdl+4ODBD8LxxrjUmy8=
=AWKO
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--


--===============1686288372161014797==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1686288372161014797==--
