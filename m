From: Gris Ge <fge@redhat.com>
Subject: Re: [PATCH v4 1/1] add display of map information in
 JSON format
Date: Thu, 19 May 2016 21:50:32 +0800
Message-ID: <20160519135032.GA969@redhat.com>
References: <1463592394-18974-1-git-send-email-tgill@redhat.com>
	<1463592394-18974-2-git-send-email-tgill@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6817012856808095143=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1463592394-18974-2-git-send-email-tgill@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Todd Gill <tgill@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============6817012856808095143==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 18, 2016 at 01:26:34PM -0400, Todd Gill wrote:
>=20
> v4:
>=20
> removed space in major_version and minor_version keys.
Hi Todd,

Few things:
    * Please provide path group id from 'pgindex' of struct path.

    * Replace key name 'host adapter' with 'host_adapter'.

    * Remove output properties as many as you can, only expose
      those with clear user case and good definition.
      For API, it's easy to add but hard to remove or change.
      For example: IMHO, we don't need to expose
      hcil, next_check, size, serial right now,

    * Performance concern. I am getting bad performance(25 seconds
      while previous 'raw format' way only take 1.5 seconds) on 10k
      disks. I am still investigating which part slow things down.

Thank you.
Best regards.

--=20
Gris Ge

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXPcSoAAoJEGzN5Y/kHij/atkP/3qC6/BJEu2Z//xdbbcpVKGZ
bt4RKvb+9TQSeYq/MtkDA7Id02MQSraEdVB+vsYqWzqiLRBQeWScd18kEf5ncX5J
4GDfo9qxjVI7aPuoxOiPWQcA4+smhiCTWl/oALb1V172TQaVO2xgcrVfeGNn72za
zcSLpcXeeePGLCX2S06m4+77z/2tOj6WC2luugfBAOYVIRbBamXELlp+gwjQOoej
199HYU/W1MSHQ5VAqnWw4w8I+rSPlSpZBDIctSm2ErLNyqWkLJD9Fx66iUIUXPWq
Elxq0uJbc6/ae36A9L74A0EzCcJ6jsj/m9Ig9X+gO6F3dhXFFG2mCnWJH+RN5Zoz
7Uy/OvGEJl0q0vENf7KXy6jxvDWaPFreVQjanbcDxaTReTa/6Qz8zOBTWdaSbVcc
GaxTAUkiHEHGgefxguu5KYIcH6y/3yhfwS1rI1u07GB80fHMf1vDaXoxLWK0ISHp
BLC1Xmjvi72qVMUeWcQK95b9Zh8fLqoW/ebfhJcoG6mBMMIDRPnoxCJCK/EUB+0/
/dmPFN++jILcAibDRFz+JmpcZ0zVcSrB+NUX5sqXbwZ7zNpKkP6gTUW7Svlvogu6
qpA2ZCY1s02ZJZj+T0Ea8gu5MorkkrVC0ErwyBJedkkS9Fp32nTWShgGl/WxcbHM
n5JvDSTof0fDJB1lWx4H
=kvpX
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--


--===============6817012856808095143==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6817012856808095143==--
