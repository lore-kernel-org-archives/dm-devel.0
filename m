From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Q about dm-verity per bio data
Date: Tue, 10 Jul 2018 12:29:46 -0400
Message-ID: <20180710162946.GA55629@redhat.com>
References: <000701d4184d$bd1cb2b0$37561810$@foss.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <000701d4184d$bd1cb2b0$37561810$@foss.arm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: yael.chemla@foss.arm.com
Cc: dm-devel@redhat.com, Yael Chemla <Yael.Chemla@arm.com>, 'Milan Broz' <gmazyland@gmail.com>
List-Id: dm-devel.ids

On Tue, Jul 10 2018 at  8:58am -0400,
yael.chemla@foss.arm.com <yael.chemla@foss.arm.com> wrote:

> Hi Mike and Milan,
> I'd like to consult with you, 
> I'm trying to rewrite a patch I submitted few month ago according to comments I got, 
> Eric Bigger asked my to adopt the method used in dm-crypt for dynamic allocations.
> ([dm-devel] [PATCH 2/2] md: dm-verity: allow parallel processing of bio blocks)
> 
> I saw you rewrite lately in verity_ctr (dm-verity-target.c) the alignment and the calculation of ti->per_io_data_size, and also did similar modification at crypt_ctr,  in dm-crypt.c
> And I suspect it's the source of my problem.
> 
> In my new patch edition as a preparation for parallelization of requests I've added new structure (dm_verity_request ) to the end of dm-verity "per bio data" area.
> And enlarged accordingly the size of per_io_data_size
> 
> I keep getting kernel panic such as " bad PC value" or cpu salls.
> I guess there's something related to alignment that is missing
> 
> Here my code (it's not the complete patch I intend to submit) but it demonstrate my modification and triggers the mentioned panics:
> 
> Please let me know if you see any issues with alignment or per_io_data_size  size calculation that is missing.
> Thank you,
> Yael
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 0cb81c7ed2bb..8d6fbe1a1ae2 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -359,6 +359,7 @@ static void verity_for_io_block(struct dm_verity *v, struct dm_verity_io *io,
>          * until you consider the typical block size is 4,096B.
>          * Going through this loops twice should be very rare.
>          */
>         sg_set_page(&sg[*nents], bv.bv_page, len, bv.bv_offset);
> 
>         bio_advance_iter(bio, iter, len);

This hunk doesn't have any change.. and in general when I attempt to
apply the patch I get:

patching file drivers/md/dm-verity-target.c
patch: **** malformed patch at line 33: @@ -447,6 +448,10 @@ static int verity_verify_io(struct dm_verity_io *io)

> @@ -447,6 +448,10 @@ static int verity_verify_io(struct dm_verity_io *io)
>                 unsigned int total_len = 0;
>                 sector_t cur_block = io->block + b;
>                 struct ahash_request *req = verity_io_hash_req(v, io);
> +               struct dm_verity_request *vreq = verity_io_req(io);
> +
> +               vreq->sg = sg;
> +               vreq->cur_block = cur_block;
> 
>                 if (v->validated_blocks &&
>                     likely(test_bit(cur_block, v->validated_blocks))) {
> @@ -641,6 +646,7 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
>         bio->bi_end_io = verity_end_io;
>         bio->bi_private = io;
>         io->iter = bio->bi_iter;
> +       io->vreq = (struct dm_verity_request *)((struct dm_verity_fec_io *)verity_io_digest_end(v, io) + 1);
> 
>         verity_fec_init_io(io);
> 

The above looks very wrong, 2 issues I'm seeing:

1)
your new 'struct dm_verity_request' follows the 'want_digest' in 'struct
dm_verity_io' right?

So why are you then advancing from 'want_digest' by 'struct
dm_verity_fec_io' to point to (struct dm_verity_request *)!?

'struct dm_verity_fec_io' would still follow all the per-bio-data
associated with 'struct dm_verity_io'.

And doesn't dm-verity-fec.c:fec_io() need updating so that it skips over
your 'struct dm_verity_io'?

You need to introduce new helpers, something like this:

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 684af08d0747..f3922421d58d 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -28,7 +28,7 @@ bool verity_fec_is_enabled(struct dm_verity *v)
  */
 static inline struct dm_verity_fec_io *fec_io(struct dm_verity_io *io)
 {
-	return (struct dm_verity_fec_io *) verity_io_digest_end(io->v, io);
+	return (struct dm_verity_fec_io *) verity_io_end(io);
 }
 
 /*
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 3441c10b840c..937d580adf0b 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -115,6 +115,17 @@ static inline u8 *verity_io_digest_end(struct dm_verity *v,
 	return verity_io_want_digest(v, io) + v->digest_size;
 }
 
+static inline struct dm_verity_request *verity_io_req(struct dm_verity_io *io)
+{
+	return (struct dm_verity_request *) verity_io_digest_end(io->v, io);
+}
+
+static inline void *verity_io_end(struct dm_verity_io *io)
+{
+	struct dm_verity_request *io_req = verity_io_req(io);
+	return io_req + 1;
+}
+
 extern int verity_for_bv_block(struct dm_verity *v, struct dm_verity_io *io,
 			       struct bvec_iter *iter,
 			       int (*process)(struct dm_verity *v,

2)
There is no need to add 'struct dm_verity_request *vreq;' to 'struct
dm_verity_io':

> diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
> index 3441c10b840c..6ccf6f215fe3 100644
> --- a/drivers/md/dm-verity.h
> +++ b/drivers/md/dm-verity.h
> @@ -78,19 +78,31 @@ struct dm_verity_io {
>         struct bvec_iter iter;
> 
>         struct work_struct work;
> -
> +       struct dm_verity_request *vreq;
>         /*
>          * Three variably-size fields follow this struct:
>          *
>          * u8 hash_req[v->ahash_reqsize];
>          * u8 real_digest[v->digest_size];
>          * u8 want_digest[v->digest_size];
> -        *
> +        * struct dm_verity_request
>          * To access them use: verity_io_hash_req(), verity_io_real_digest()
>          * and verity_io_want_digest().
>          */
>  };

Just access it using the correct verity_io_req().
