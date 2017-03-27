From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v3] block: trace completion of all bios.
Date: Mon, 27 Mar 2017 20:49:57 +1100
Message-ID: <87zig76oca.fsf@notabene.neil.brown.name>
References: <877f3iave6.fsf@notabene.neil.brown.name> <20170322125149.GA29606@infradead.org> <87shm4a4lt.fsf@notabene.neil.brown.name> <20170323104331.GA16903@ming.t460p> <87fui3a65o.fsf@notabene.neil.brown.name> <20170327090308.GA11757@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170327090308.GA11757@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 27 2017, Christoph Hellwig wrote:

> I don't really like the flag at all.  I'd much prefer a __bio_endio
> with a 'bool trace' flag.  Also please remove the manual tracing in
> dm.=C4=8B.  Once that is done I suspect we can also remove the
> block_bio_complete export.

Can you say why you don't like it?

I find that it neatly handles all the corner cases that I found, and
keeps the complexity local.

Were we to use a flag to __bio_endio(), we would need one to
__generic_make_request() too because we really don't want 'QUEUE' tracing
when when blk_queue_split() (and similar code) calls it.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljY4EUACgkQOeye3VZi
gbnbEw//a2MwepVhHo4YrL2rtGsgG7ZwgTS+d0DZzm/F6PhzjHM6RkBMBfbzKbyV
U95ni1J+xEf2RlNYjxfhhbRjEVbV53uFVgQg7vyFHIzN5439CNi0Fe4T8pn6hb2a
Hq6A2hsv02DXlGk3tk5TKq4iirt211F7vJoF0ZScstKEnXJkoeJjBe7dIOfQXN7b
E71YxwgI+9auiJxdnqEXPzi+z4jgiT3GPTyqCj9TggnxRtUkQsGHWL3mwqw66pIu
7G/MGXqPSLUdUBXLNIQeqVBTbGjZIO0T/d+1H5vyezfP6u/UxjBySgS17hCvDgB9
jrdGDafFXdNvVX8E8tpbEMwcFsJeX1FSNMRdwHlDDw6WQKnPQL36j330gNRxQJOM
unhWQ/G1iJsZgCGlieEbS5FMWoy56shokwX2OiJutlzY07ZwjUwR5yZOLKfvBxgd
Uh4mA06VDJPWol736pzxp4Q/7bRWjWqldgjOlH8pT0vPBhfd3IKLIlvmDTvPQLP3
htO+hHssJJVwg9Q7/uWBJB08QqpT67rc5A5UVluJwO51uEDE0GGUL7Lr1XEMs0Qv
e6xXB9fv5JYoESZQ7jBb7S43mp3Jzn9C9MjF+ShJdqzDpKhGhMIDaS94roh9dHRP
2drK9tMP6n4FfTVph7VkBfW4CTKz2loTwIdqkAxmn0tPYodaRj8=
=tE81
-----END PGP SIGNATURE-----
--=-=-=--
