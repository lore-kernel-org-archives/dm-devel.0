From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v3] block: trace completion of all bios.
Date: Mon, 27 Mar 2017 10:17:03 +1100
Message-ID: <87inmv8w7k.fsf@notabene.neil.brown.name>
References: <877f3iave6.fsf@notabene.neil.brown.name> <20170322125149.GA29606@infradead.org> <87shm4a4lt.fsf@notabene.neil.brown.name> <20170323104331.GA16903@ming.t460p> <87fui3a65o.fsf@notabene.neil.brown.name> <CACVXFVNC=-_f1jYo5bYw7X6TT8-g7UThw3zzzfrMaKVarnJvSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACVXFVNC=-_f1jYo5bYw7X6TT8-g7UThw3zzzfrMaKVarnJvSQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 24 2017, Ming Lei wrote:

> On Fri, Mar 24, 2017 at 8:07 AM, NeilBrown <neilb@suse.com> wrote:
...
>> @@ -102,6 +102,8 @@ struct bio {
>>  #define BIO_REFFED     8       /* bio has elevated ->bi_cnt */
>>  #define BIO_THROTTLED  9       /* This bio has already been subjected to
>>                                  * throttling rules. Don't do it again. =
*/
>> +#define BIO_TRACE_COMPLETION 10        /* bio_endio() should trace the =
final completion
>> +                                * of this bio. */
>
> This may not be a good idea, since the flag space is quite small(12).

which means there are 2 unused bits and I only want to use 1.  It should
fit.
I'm a bit perplexed why 4 bits a reserved for the BVEC_POOL number which
ranges from 0 to 7....

But if these bits really are a scarce resource, we should stop wasting
them.
The patch below makes bit 7 (BIO_CHAIN) available.  We could probably make
bit 8 (BIO_REFFED) available using a similar technique.
BIO_QUIET is only relevant if bi_error is non-zero and bi_error has a
limited range, so a bit in there could be used instead. In fact,
MAX_ERRNO is 4096, so bi_error could be a 'short'.  That could save 2
whole bytes ... or make 16 more flag bits available.

So I don't think you concern about a shortage of spare flag bits is valid.

Thanks,
NeilBrown

diff --git a/block/bio.c b/block/bio.c
index c1272986133e..1703786a206a 100644
=2D-- a/block/bio.c
+++ b/block/bio.c
@@ -274,7 +274,7 @@ void bio_init(struct bio *bio, struct bio_vec *table,
 	      unsigned short max_vecs)
 {
 	memset(bio, 0, sizeof(*bio));
=2D	atomic_set(&bio->__bi_remaining, 1);
+	atomic_set(&bio->__bi_remaining, 0);
 	atomic_set(&bio->__bi_cnt, 1);
=20
 	bio->bi_io_vec =3D table;
@@ -300,7 +300,7 @@ void bio_reset(struct bio *bio)
=20
 	memset(bio, 0, BIO_RESET_BYTES);
 	bio->bi_flags =3D flags;
=2D	atomic_set(&bio->__bi_remaining, 1);
+	atomic_set(&bio->__bi_remaining, 0);
 }
 EXPORT_SYMBOL(bio_reset);
=20
@@ -1794,20 +1794,15 @@ EXPORT_SYMBOL(bio_flush_dcache_pages);
 static inline bool bio_remaining_done(struct bio *bio)
 {
 	/*
=2D	 * If we're not chaining, then ->__bi_remaining is always 1 and
+	 * If we're not chaining, then ->__bi_remaining is always 0 and
 	 * we always end io on the first invocation.
 	 */
=2D	if (!bio_flagged(bio, BIO_CHAIN))
+	if (atomic_read(&bio->__bi_remaining) =3D=3D 0)
 		return true;
=20
 	BUG_ON(atomic_read(&bio->__bi_remaining) <=3D 0);
=20
=2D	if (atomic_dec_and_test(&bio->__bi_remaining)) {
=2D		bio_clear_flag(bio, BIO_CHAIN);
=2D		return true;
=2D	}
=2D
=2D	return false;
+	return atomic_dec_and_test(&bio->__bi_remaining);
 }
=20
 /**
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8e521194f6fc..d15245544111 100644
=2D-- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -664,13 +664,19 @@ static inline struct bio *bio_list_get(struct bio_lis=
t *bl)
 }
=20
 /*
=2D * Increment chain count for the bio. Make sure the CHAIN flag update
=2D * is visible before the raised count.
+ * Increment chain count for the bio.
  */
 static inline void bio_inc_remaining(struct bio *bio)
 {
=2D	bio_set_flag(bio, BIO_CHAIN);
=2D	smp_mb__before_atomic();
+	/*
+	 * Calls to bio_inc_remaining() cannot race
+	 * with the final call to bio_end_io(), and
+	 * the first call cannot race with other calls,
+	 * so if __bi_remaining appears to be zero, there
+	 * can be no race which might change it.
+	 */
+	if (atomic_read(&bio->__bi_remaining) =3D=3D 0)
+		atomic_set(&bio->__bi_remaining, 1);
 	atomic_inc(&bio->__bi_remaining);
 }
=20
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index db7a57ee0e58..2deea4501d14 100644
=2D-- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -46,6 +46,15 @@ struct bio {
 	unsigned int		bi_seg_front_size;
 	unsigned int		bi_seg_back_size;
=20
+	/* __bi_remaining records the number of completion events
+	 * (i.e. calls to bi_end_io()) that need to happen before this
+	 * bio is truly complete.
+	 * A value of '0' means that there will only ever be one completion
+	 * event, so there will be no racing and no need for an atomic operation
+	 * to detect the last event.
+	 * Any other value represents a simple count subject to atomic_inc() and
+	 * atomic_dec_and_test().
+	 */
 	atomic_t		__bi_remaining;
=20
 	bio_end_io_t		*bi_end_io;
@@ -98,7 +107,7 @@ struct bio {
 #define BIO_USER_MAPPED 4	/* contains user pages */
 #define BIO_NULL_MAPPED 5	/* contains invalid user pages */
 #define BIO_QUIET	6	/* Make BIO Quiet */
=2D#define BIO_CHAIN	7	/* chained bio, ->bi_remaining in effect */
+/* 7 unused */
 #define BIO_REFFED	8	/* bio has elevated ->bi_cnt */
 #define BIO_THROTTLED	9	/* This bio has already been subjected to
 				 * throttling rules. Don't do it again. */

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljYS/AACgkQOeye3VZi
gbnMBA//UYL0lw/q6Ie/nnOe5ROKIYdSsSdhbPrVX0EvoSlhwI0V8Mv8QceyMAv9
jgpqgHYez5o/IuUyDuRrOooeeFdz3Abf39tRPLBQ8gHNVtdihnctWG/ZtJj6rzVD
FtWYIE+dE00qr4FdNemG4OfkHc6xnkNnYmXHpMW64bAzMOMs7P92BqtqSwv7+JBz
jDjbAUzdxOhE7d5f4yRN1MoKovI+euQA+s5nth18H3CTPoh/wLa3Yze7e8wt2eDo
0bD9Ap5MQDJmbhwsYHfaKBsDe41Z2okAwFASIu75z9ZyJpxYsNoSw6m58fIZsM/p
UOPUKaTCbrmPzn2mwu66O/5T9ihPmP+cCQmWi0wDuHZtDTs1cBRjAZQ5vOKC19H7
xZHGx5aYeyKPtcT8Mhvl0J8GMueuQSWD2MckzANvY7WasDoKalAnrFidiMjoWsKO
G0uJFdU+Ba+3nSmKtEHtFAGFXZ2V/6i+ZgQn3D4sJgucm3ANfW6cBoACw1UeMCMn
7P7FpnikIi6ewdGCZHj5HiRadFLPZx7grGbSgjQ+76yAl5qulE4tCz8pBoNLL6Ry
jSIuNyJBJBp0eN/8r8L8e3qk1f5/H8z8atFwl3Tqhb9bMmzXn/hsPk1f8E60Wz/V
igajc5Kd0s15o+/1FudyOMYxzzT2T1mtU2D7zqk4wXH8Pk+bJAE=
=IOXf
-----END PGP SIGNATURE-----
--=-=-=--
