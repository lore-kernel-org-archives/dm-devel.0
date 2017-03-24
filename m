From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2] block: trace completion of all bios.
Date: Fri, 24 Mar 2017 11:06:09 +1100
Message-ID: <87k27fa68e.fsf@notabene.neil.brown.name>
References: <877f3iave6.fsf@notabene.neil.brown.name> <20170322125149.GA29606@infradead.org> <87shm4a4lt.fsf@notabene.neil.brown.name> <20170323104331.GA16903@ming.t460p>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170323104331.GA16903@ming.t460p>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 23 2017, Ming Lei wrote:

> On Thu, Mar 23, 2017 at 05:29:02PM +1100, NeilBrown wrote:
>>=20
>>  /**
>> + * bio_endio_notrace - end I/O on a bio without tracing
>> + * @bio:	bio
>> + *
>> + * Description:
>> + *   bio_endio_notrace() will end I/O on the whole bio.
>> + *   bio_endio_notrace() should only be call if a completion trace
>> + *   event is not needed.  This can be the case if a request-level
>> + *   completion event has already been generated, if the bio is
>> + *   being completed early, before it was even queued.
>> + *
>> + **/
>> +void bio_endio_notrace(struct bio *bio)
>> +{
>> +again:
...
>> +
>> +	if (bio->bi_bdev)
>> +		trace_block_bio_complete(bdev_get_queue(bio->bi_bdev),
>> +					 bio, bio->bi_error);
>
> The notrace version still traces?

Ugh.  Thanks :-(

>
>> +	if (bio->bi_end_io)
>> +		bio->bi_end_io(bio);
>> +}
>> +EXPORT_SYMBOL(bio_endio_notrace);
>
> It isn't a good idea to duplicate bio_endio here, and any change on
> bio_endio() may be needed for this _notrace version too in future.

I uhmed and arhhed about that.  The function is so small....
But I've had a change of heart.  I don't think that having separate
bio_endio() and bio_endio_notrace() is such a good idea. It is too easy
to use the wrong one.  It is much better to make it automatically do the
right thing.
So following is a new patch - more thoroughly tested - which handles
more cases, and doesn't need any follow-up changes for filesystems.

Thanks,
Neilbrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljUYvIACgkQOeye3VZi
gblyJBAAu8Hh9BDcRzO+9NYJotP3FCrP9T03t5Z6tzFfEtZMqnOsz+NiOKLWDG7g
EpkVsAStPiSVmj60BZuiipu8I4n7U3dozYEh+pOVqXYBtxo/+QbaQiEnL+8FAKyj
u/RqM+O9j6Q7K/Jn9GsTnm5hSaXY0jUz7JZsXWKTLikQ7jtQtvEjixERybd08nmM
T680zmJyKYleP9uliJblbaXeEL064CEANhZOJtAxfls8onHVpk+eLFH8MfQQ6Ivv
KBHUOe1h/3DYhppHOaZqACvDy/rDq+3OsXvXHCJPpWyGfSkCePovpWU5UWyQwhnY
fEy9rEC9kScSBnvjVtWLF0WFwhLf3tAzVDsw9woDojoK8l+gclyQyfWC9ncL0jiU
Udq0RawVQA1sYGKj0JyNfE6Txq0TX17wDqH0JI4pNsTJJUorMNrYNTzgxa4MoioY
29IvMNy3ykb9WmIf497G3LNN7Fy9tLir0YiZNAP3L8kp48pNVPtRa0K62mpd/VZe
TTmdBZEW4SDZ0BkoNypWeC8j3rZ8cgLm0L7z9ce1MzFawie2JZ8au1go0HXTvTFR
PY89lsylfvC9q2B4gnz8a11hCgYo0AyXqvFg3wrPP9BZOeTLGOaIuJONwk8aR3nq
Vc5NNqXTub0YPPFpHaFt6kPJpgDKQEOKJ3Ra9+aA/6mSGqbJq0g=
=m5EF
-----END PGP SIGNATURE-----
--=-=-=--
