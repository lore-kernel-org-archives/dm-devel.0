From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] block: trace completion of all bios.
Date: Thu, 23 Mar 2017 17:26:11 +1100
Message-ID: <87var0a4qk.fsf@notabene.neil.brown.name>
References: <877f3iave6.fsf@notabene.neil.brown.name>
	<20170322125149.GA29606@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1667146616160257262=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170322125149.GA29606@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

--===============1667146616160257262==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 22 2017, Christoph Hellwig wrote:

> On Wed, Mar 22, 2017 at 01:38:09PM +1100, NeilBrown wrote:
>>=20
>> Currently only dm and md/raid5 bios trigger trace_block_bio_complete().
>> Now that we have bio_chain(), it is not possible, in general, for a
>> driver to know when the bio is really complete.  Only bio_endio()
>> knows that.
>>=20
>> So move the trace_block_bio_complete() call to bio_endio().
>
> This will cause duplicate events for request based drivers.  You'll
> need to have a bio_endio_notrace or similar without that the request
> completion path can call.

Ah... I hadn't noticed that the request completion was the same event
type as the bio completion...  Thanks.  Also after being processed by the
request handler, bi_sector and bi_size have changed so the trace
messsage would be wrong.

I've sorted that out and will repost.

Thanks,
NeilBrown



--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljTaoQACgkQOeye3VZi
gblMPA/7BDkJyI0XRhX6kgMqQPNr6oxAJ62va6k00/yqP5YPlKMdC6LqoOcRT8op
07g4LKOrWS6AvY+mJCLq0YlF3OYeVWsBEZBogk5RxwIEi7nD4S7ywrcCcW7OEtX0
TkUXfxoSdmJFZrNsDFRpgSYOw9XHzkTLe/ibXrJ0oQ/vZHfKjmRgZaUEkR1LUZ/S
hhElbZcC3GF+NusaCkRjej9j2DCkCMjYax8P7XxrTlGqmbUz0T1AwD1mZw4+nBWL
IpzlJMPsdBPweEvIcn+hze0aowP6WBL1XY37R/sJF0sRdo3+8+RMOzM9eN4Dhvvh
9CYctSfx/Pbx+TeCFv2gzKhr+LzBnkq1uvzFHZGfPDMEiOa23dRamxYnchhoIeSj
mGsCEN4YaP2kwtpqNzYC0pzQGoRwJVT3H4jYXkKqOgXImyWaj9llqM2IqPqR5P/1
lU7Ur/D8pnRNW9ANbp6k4q/fMDshXYW0SO4y5MCau2m6f5HjbCYXyZXmKQsNlywa
q+0NYhwEjJL+1z6HcMLUUfEXVnMsGgypvXPyrfX5u0RwFu/QFvjK7XYdkyQVBmvu
LAc66v88jyuOJ5/RWBcEXrfRFAHHhZSaw/Oy3Y+gO9XqsRgZklpzUpkynajhJn3F
qnIqd0FKfA5FxYEsO+mwai/frio9TQoT/pzLfsRii/iZ1Y4V6J8=
=Ztr2
-----END PGP SIGNATURE-----
--=-=-=--


--===============1667146616160257262==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1667146616160257262==--
