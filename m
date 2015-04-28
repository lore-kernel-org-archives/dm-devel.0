From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 07/10] block: kill merge_bvec_fn() completely
Date: Wed, 29 Apr 2015 08:09:19 +1000
Message-ID: <20150429080919.342fddfd@notabene.brown>
References: <1430203717-13307-1-git-send-email-mlin@kernel.org>
	<1430203717-13307-8-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/1hOXNlv0I_n25BYxBJ9Vcng"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430203717-13307-8-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dongsu.park@profitbricks.com>, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Yehuda Sadeh <yehuda@inktank.com>, Sage Weil <sage@inktank.com>, Alex Elder <elder@kernel.org>, ceph-devel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

--Sig_/1hOXNlv0I_n25BYxBJ9Vcng
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Apr 2015 23:48:34 -0700 Ming Lin <mlin@kernel.org> wrote:

> From: Kent Overstreet <kent.overstreet@gmail.com>
>=20
> As generic_make_request() is now able to handle arbitrarily sized bios,
> it's no longer necessary for each individual block driver to define its
> own ->merge_bvec_fn() callback. Remove every invocation completely.

This patch it just a little premature I think.

md/raid5 still assumes read requests will mostly fit within a single chunk
(which merge_bvec_fn encourages) so they can be serviced without using the
stripe-cache.
You've just broken that assumption.

I think 'chunk_aligned_read' needs to get a loop using bio_split, a bit like
raid0, first.

Thanks,
NeilBrown

--Sig_/1hOXNlv0I_n25BYxBJ9Vcng
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUAFDznsnt1WYoG5AQKzlA//RLbb7rnxiJ1OpNg/IHGyCg5GyokjhBK7
N25OUZnKyz8BbWgstR4i+I3YVBw1kxpHNh1e3nadOt04qmiXtI4K35HXIHkzpMCg
4DTPGvwi8Q2uYDQa2cHFFRgxnXvrCuNIH8BJQFYp7I+9tgHD7jUYY/roU/HvQlMC
6AMYwz4Z9JK6rIxPFfq5YsH4AW6W7Ut4EnTPMKVXfFXQDnfLdboRzSxt1EwVRRF0
dH5/ZChqMabNTYhB6HAnalsxpSauknxsNom3nuMxxEml7JUY9RUq6T8kS+H/c32m
5ctIZurQO8lXlb+YPoHFxtiTNalQshkW9DJILORDWyqOOiN64X4eLmfaOBKai8nV
COW/9OaFb5re3yr9cdigMylfrj7hPOS/kuccAs2V0mjyWLIIrJBdIOMH8xrnVW0g
pextCfa0jwhoJ1/1W8Ovur64T+qFENtDGT+9QJfiIKrCTuIworhr9RCycNVdJM9O
rY19PaUwnDRBZ0U2i5gQvOg4uKy2+AJp4WFxiZLRNSVhwaZ2S9Kr1o5QADEk9NfR
2vYBdU69YlhO6vGLAnRgzdqKlA6+NCCva4vkFxQvNm61d8YP8asWdrEGYnqdoXYt
5H2WB+s7olvMgyGqV8ks79wUU4K4InCkx7J5/AW9JxlJ40rHNPdn7/5FT/zjSedZ
Nlmw51dDQqg=
=yECD
-----END PGP SIGNATURE-----

--Sig_/1hOXNlv0I_n25BYxBJ9Vcng--
