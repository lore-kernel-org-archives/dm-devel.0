From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/2] md/raid0: Introduce new array state
	'broken' for raid0
Date: Wed, 31 Jul 2019 10:28:41 +1000
Message-ID: <87ftmnkpxi.fsf@notabene.neil.brown.name>
References: <20190729203135.12934-1-gpiccoli@canonical.com>
	<20190729203135.12934-2-gpiccoli@canonical.com>
	<d730c417-a328-3df3-1e31-32b6df48b6ad@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2372846459033689565=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d730c417-a328-3df3-1e31-32b6df48b6ad@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bob Liu <bob.liu@oracle.com>, "Guilherme G. Piccoli" <gpiccoli@canonical.com>, linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org, jay.vosburgh@canonical.com, songliubraving@fb.com, dm-devel@redhat.com, Neil F Brown <nfbrown@suse.com>
List-Id: dm-devel.ids

--===============2372846459033689565==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 30 2019, Bob Liu wrote:
>
>
> Curious why only raid0 has this issue?=20

Actually, it isn't only raid0.  'linear' has the same issue.
Probably the fix for raid0 should be applied to linear too.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl1A4LoACgkQOeye3VZi
gbn0wRAAuH9h2Qxza5xLzWsV8tlEajzIAXMeAxp4Q+IY9Na0AgXSZPtyyE5lv2TR
wcQhQPFc+rDV+GF2rWoDOkhLKhJENtiTUoGH8ZrhU4C9hW5NRjDx80DruXKwBRll
G5OxcVY9kCDAOPtJnQHw6YjUwvWCiuoYnGqwBqoilnprsH13gPs1YFgaX+wvAj3P
ReAYsTxXQnPOQScQLJQlyis6s+unhCb8++viZmEVSnjK7i+W4i16p2xKyZTWXmXe
FZ+rsOiSll2aaYaBHIGH4oIW7wTNFeOt0z9hJ+Ce0aoQDynccbrNgtoKvkS7NN2O
k8Ci9sGX/GAmUmMD1pZgbJaRaPzMmY61gtVh25hKBMXSe9BTn+B1X9dYm44wQdP0
+hI0lSo4aP0v+aH2KByTg8e2VOOKEgtxJbeqDybgkxjGAiKW8Q82PnCt7jPmAbth
MCFuLsRp/jBClDvvvQUAYTa5rX4rASKzdFs9bQ3O7xG78SUoBBm9qyXu2HjAbYWO
BBXKWLqOXkjol1m5NWJMvY8XIvIhl8SDZNy4kzFdbuSD7eXIWBrp+RXFo7aMdRv9
krY0LAjQKYrzB7TmK7JJmI3rvGnSzBi4pQrJNc6NjOTyaCYF2qg/4LexXa27fNXj
lmWELXJmHvz4WHPJvjhPY5FAO2NjeNNDGpb5AJy4eDhyuF7hfH8=
=ErRK
-----END PGP SIGNATURE-----
--=-=-=--


--===============2372846459033689565==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2372846459033689565==--
