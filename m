From: Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH 07/10] idr: Rename idr_alloc() ->
	idr_alloc_range()
Date: Wed, 7 Aug 2013 21:04:53 +0200
Message-ID: <20130807190453.GL2978@katana>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com>
	<1375897579-8202-7-git-send-email-kmo@daterainc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3466599451196502102=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1375897579-8202-7-git-send-email-kmo@daterainc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kent Overstreet <kmo@daterainc.com>
Cc: Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>, Linus Walleij <linus.walleij@linaro.org>, Paul Mackerras <paulus@samba.org>, Christoph Hellwig <hch@lst.de>, Alon Levy <alevy@redhat.com>, Davidlohr Bueso <davidlohr.bueso@hp.com>, Ohad Ben-Cohen <ohad@wizery.com>, "John W. Linville" <linville@tuxdriver.com>, Inki Dae <inki.dae@samsung.com>, Alex Williamson <alex.williamson@redhat.com>, David Teigland <teigland@redhat.com>, Joel Becker <jlbec@evilplan.org>, Tim Gardner <tim.gardner@canonical.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Seung-Woo Kim <sw0312.kim@samsung.com>, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, Guo Chao <yan@linux.vnet.ibm.com>, akpm@linux-foundation.org, Andy Grover <agrover@redhat.com>, Dmitry
List-Id: dm-devel.ids


--===============3466599451196502102==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p7S+EREVcBHk3zUG"
Content-Disposition: inline


--p7S+EREVcBHk3zUG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 07, 2013 at 10:46:16AM -0700, Kent Overstreet wrote:
> Then also add an idr_alloc() wrapper, without the start/end arguments -
> for consistency with the ida interfaces.
>=20
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>

For my taste, the motivation of the change could be described in a bit
more detail.


--p7S+EREVcBHk3zUG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSAppVAAoJEBQN5MwUoCm26uIQAId/2PeKqaXqsDETuLthraz3
dwvZ1p3zPc/6bjMcN6JktGNXo94oTw0oJjNg/sHnXNli7ttY4w74EC8XLV2fCjEm
WCC3M3LhjdnOR2+nqSVloT9rgEB5qXTLLAyVybtKL0wFhg5bKlDm+q1OPzd/SSgU
jg6ij73i0ExD+dqOZyfLfdm9J/5idRLmzFDZy4D9pBHelgPUKJZUQMKDxSQxbx96
hEffCHEdwHuEwErjWA/5oyMsNs7tSAy+9wFg3P2JlceAnZUrI7ycltpH9xLR5yld
jIpOqCYiKZYsWi7owo/xBLlV94xuq8wT3Td5uujGPhwV0pGQzmNuzDlPoAgapyhR
v0bDb/VU4hmioz4ntWMXztXAIxJtlRhQO/v61CMLvs8N45I+hjvuhtxo3xfmm+oh
dDtDCq+eY24kQUyBbJJAiLx289uvlGoK2hQYf3SkAaOWBHZE5Ce9DymmwHrzeMp7
8aTXNtR7iJvkspH8YD1AlogArJUZqx4UKJNvx3N0My8YVFt6ylXzWljkX9qKjWpB
e2teQ8gmBXLzTl1GTNgvcEQR01xMZMaDTSez7MMDfJhcNxWJwJ3YUpFObkgUjZ04
Cai5N1sq452yrxXhdb+soHT5E6H6LqZMgLwaRJSJ1xpx86k+C4aylMj1ER1iQt3Q
GZHEX5PzVgqKJmNFtqG/
=bg1e
-----END PGP SIGNATURE-----

--p7S+EREVcBHk3zUG--


--===============3466599451196502102==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3466599451196502102==--
