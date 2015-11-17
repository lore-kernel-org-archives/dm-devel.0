From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 1/4] dm verity: clean up duplicate hashing code
Date: Tue, 17 Nov 2015 14:32:38 -0800
Message-ID: <CAGXu5j+WdxytSy0ncg_ntXoKEFGJCrEMb76Tt41TfiqYHLUkvQ@mail.gmail.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
	<1446688954-29589-2-git-send-email-samitolvanen@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446688954-29589-2-git-send-email-samitolvanen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids

On Wed, Nov 4, 2015 at 6:02 PM, Sami Tolvanen <samitolvanen@google.com> wrote:
> Handle dm-verity salting in one place to simplify the code.
>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Thanks for cleaning this up!

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/md/dm-verity.c | 262 +++++++++++++++++++++++++++----------------------
>  1 file changed, 147 insertions(+), 115 deletions(-)
>
> diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
> index edc624b..487cb66 100644
> --- a/drivers/md/dm-verity.c
> +++ b/drivers/md/dm-verity.c
> @@ -173,6 +173,84 @@ static sector_t verity_position_at_level(struct dm_verity *v, sector_t block,
>         return block >> (level * v->hash_per_block_bits);
>  }
>
> +/*
> + * Wrapper for crypto_shash_init, which handles verity salting.
> + */
> +static int verity_hash_init(struct dm_verity *v, struct shash_desc *desc)
> +{
> +       int r;
> +
> +       desc->tfm = v->tfm;
> +       desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> +
> +       r = crypto_shash_init(desc);
> +
> +       if (unlikely(r < 0)) {
> +               DMERR("crypto_shash_init failed: %d", r);
> +               return r;
> +       }
> +
> +       if (likely(v->version >= 1)) {
> +               r = crypto_shash_update(desc, v->salt, v->salt_size);
> +
> +               if (unlikely(r < 0)) {
> +                       DMERR("crypto_shash_update failed: %d", r);
> +                       return r;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +static int verity_hash_update(struct dm_verity *v, struct shash_desc *desc,
> +                             const u8 *data, size_t len)
> +{
> +       int r = crypto_shash_update(desc, data, len);
> +
> +       if (unlikely(r < 0))
> +               DMERR("crypto_shash_update failed: %d", r);
> +
> +       return r;
> +}
> +
> +static int verity_hash_final(struct dm_verity *v, struct shash_desc *desc,
> +                            u8 *digest)
> +{
> +       int r;
> +
> +       if (unlikely(!v->version)) {
> +               r = crypto_shash_update(desc, v->salt, v->salt_size);
> +
> +               if (r < 0) {
> +                       DMERR("crypto_shash_update failed: %d", r);
> +                       return r;
> +               }
> +       }
> +
> +       r = crypto_shash_final(desc, digest);
> +
> +       if (unlikely(r < 0))
> +               DMERR("crypto_shash_final failed: %d", r);
> +
> +       return r;
> +}
> +
> +static int verity_hash(struct dm_verity *v, struct shash_desc *desc,
> +                      const u8 *data, size_t len, u8 *digest)
> +{
> +       int r;
> +
> +       r = verity_hash_init(v, desc);
> +       if (unlikely(r < 0))
> +               return r;
> +
> +       r = verity_hash_update(v, desc, data, len);
> +       if (unlikely(r < 0))
> +               return r;
> +
> +       return verity_hash_final(v, desc, digest);
> +}
> +
>  static void verity_hash_at_level(struct dm_verity *v, sector_t block, int level,
>                                  sector_t *hash_block, unsigned *offset)
>  {
> @@ -253,10 +331,10 @@ out:
>   * If "skip_unverified" is false, unverified buffer is hashed and verified
>   * against current value of io_want_digest(v, io).
>   */
> -static int verity_verify_level(struct dm_verity_io *io, sector_t block,
> -                              int level, bool skip_unverified)
> +static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
> +                              sector_t block, int level, bool skip_unverified,
> +                              u8 *want_digest)
>  {
> -       struct dm_verity *v = io->v;
>         struct dm_buffer *buf;
>         struct buffer_aux *aux;
>         u8 *data;
> @@ -273,75 +351,72 @@ static int verity_verify_level(struct dm_verity_io *io, sector_t block,
>         aux = dm_bufio_get_aux_data(buf);
>
>         if (!aux->hash_verified) {
> -               struct shash_desc *desc;
> -               u8 *result;
> -
>                 if (skip_unverified) {
>                         r = 1;
>                         goto release_ret_r;
>                 }
>
> -               desc = io_hash_desc(v, io);
> -               desc->tfm = v->tfm;
> -               desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> -               r = crypto_shash_init(desc);
> -               if (r < 0) {
> -                       DMERR("crypto_shash_init failed: %d", r);
> +               r = verity_hash(v, io_hash_desc(v, io),
> +                               data, 1 << v->hash_dev_block_bits,
> +                               io_real_digest(v, io));
> +               if (unlikely(r < 0))
>                         goto release_ret_r;
> -               }
> -
> -               if (likely(v->version >= 1)) {
> -                       r = crypto_shash_update(desc, v->salt, v->salt_size);
> -                       if (r < 0) {
> -                               DMERR("crypto_shash_update failed: %d", r);
> -                               goto release_ret_r;
> -                       }
> -               }
>
> -               r = crypto_shash_update(desc, data, 1 << v->hash_dev_block_bits);
> -               if (r < 0) {
> -                       DMERR("crypto_shash_update failed: %d", r);
> -                       goto release_ret_r;
> -               }
> -
> -               if (!v->version) {
> -                       r = crypto_shash_update(desc, v->salt, v->salt_size);
> -                       if (r < 0) {
> -                               DMERR("crypto_shash_update failed: %d", r);
> -                               goto release_ret_r;
> -                       }
> -               }
> -
> -               result = io_real_digest(v, io);
> -               r = crypto_shash_final(desc, result);
> -               if (r < 0) {
> -                       DMERR("crypto_shash_final failed: %d", r);
> +               if (likely(memcmp(io_real_digest(v, io), want_digest,
> +                                 v->digest_size) == 0))
> +                       aux->hash_verified = 1;
> +               else if (verity_handle_err(v,
> +                                          DM_VERITY_BLOCK_TYPE_METADATA,
> +                                          hash_block)) {
> +                       r = -EIO;
>                         goto release_ret_r;
>                 }
> -               if (unlikely(memcmp(result, io_want_digest(v, io), v->digest_size))) {
> -                       if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_METADATA,
> -                                             hash_block)) {
> -                               r = -EIO;
> -                               goto release_ret_r;
> -                       }
> -               } else
> -                       aux->hash_verified = 1;
>         }
>
>         data += offset;
> -
> -       memcpy(io_want_digest(v, io), data, v->digest_size);
> -
> -       dm_bufio_release(buf);
> -       return 0;
> +       memcpy(want_digest, data, v->digest_size);
> +       r = 0;
>
>  release_ret_r:
>         dm_bufio_release(buf);
> -
>         return r;
>  }
>
>  /*
> + * Find a hash for a given block, write it to digest and verify the integrity
> + * of the hash tree if necessary.
> + */
> +static int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
> +                                sector_t block, u8 *digest)
> +{
> +       int i;
> +       int r;
> +
> +       if (likely(v->levels)) {
> +               /*
> +                * First, we try to get the requested hash for
> +                * the current block. If the hash block itself is
> +                * verified, zero is returned. If it isn't, this
> +                * function returns 1 and we fall back to whole
> +                * chain verification.
> +                */
> +               r = verity_verify_level(v, io, block, 0, true, digest);
> +               if (likely(r <= 0))
> +                       return r;
> +       }
> +
> +       memcpy(digest, v->root_digest, v->digest_size);
> +
> +       for (i = v->levels - 1; i >= 0; i--) {
> +               r = verity_verify_level(v, io, block, i, false, digest);
> +               if (unlikely(r))
> +                       return r;
> +       }
> +
> +       return 0;
> +}
> +
> +/*
>   * Verify one "dm_verity_io" structure.
>   */
>  static int verity_verify_io(struct dm_verity_io *io)
> @@ -350,54 +425,21 @@ static int verity_verify_io(struct dm_verity_io *io)
>         struct bio *bio = dm_bio_from_per_bio_data(io,
>                                                    v->ti->per_bio_data_size);
>         unsigned b;
> -       int i;
>
>         for (b = 0; b < io->n_blocks; b++) {
> -               struct shash_desc *desc;
> -               u8 *result;
>                 int r;
>                 unsigned todo;
> +               struct shash_desc *desc = io_hash_desc(v, io);
>
> -               if (likely(v->levels)) {
> -                       /*
> -                        * First, we try to get the requested hash for
> -                        * the current block. If the hash block itself is
> -                        * verified, zero is returned. If it isn't, this
> -                        * function returns 0 and we fall back to whole
> -                        * chain verification.
> -                        */
> -                       int r = verity_verify_level(io, io->block + b, 0, true);
> -                       if (likely(!r))
> -                               goto test_block_hash;
> -                       if (r < 0)
> -                               return r;
> -               }
> -
> -               memcpy(io_want_digest(v, io), v->root_digest, v->digest_size);
> -
> -               for (i = v->levels - 1; i >= 0; i--) {
> -                       int r = verity_verify_level(io, io->block + b, i, false);
> -                       if (unlikely(r))
> -                               return r;
> -               }
> +               r = verity_hash_for_block(v, io, io->block + b,
> +                                         io_want_digest(v, io));
> +               if (unlikely(r < 0))
> +                       return r;
>
> -test_block_hash:
> -               desc = io_hash_desc(v, io);
> -               desc->tfm = v->tfm;
> -               desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> -               r = crypto_shash_init(desc);
> -               if (r < 0) {
> -                       DMERR("crypto_shash_init failed: %d", r);
> +               r = verity_hash_init(v, desc);
> +               if (unlikely(r < 0))
>                         return r;
> -               }
>
> -               if (likely(v->version >= 1)) {
> -                       r = crypto_shash_update(desc, v->salt, v->salt_size);
> -                       if (r < 0) {
> -                               DMERR("crypto_shash_update failed: %d", r);
> -                               return r;
> -                       }
> -               }
>                 todo = 1 << v->data_dev_block_bits;
>                 do {
>                         u8 *page;
> @@ -408,37 +450,27 @@ test_block_hash:
>                         len = bv.bv_len;
>                         if (likely(len >= todo))
>                                 len = todo;
> -                       r = crypto_shash_update(desc, page + bv.bv_offset, len);
> +                       r = verity_hash_update(v, desc,  page + bv.bv_offset,
> +                                              len);
>                         kunmap_atomic(page);
>
> -                       if (r < 0) {
> -                               DMERR("crypto_shash_update failed: %d", r);
> +                       if (unlikely(r < 0))
>                                 return r;
> -                       }
>
>                         bio_advance_iter(bio, &io->iter, len);
>                         todo -= len;
>                 } while (todo);
>
> -               if (!v->version) {
> -                       r = crypto_shash_update(desc, v->salt, v->salt_size);
> -                       if (r < 0) {
> -                               DMERR("crypto_shash_update failed: %d", r);
> -                               return r;
> -                       }
> -               }
> -
> -               result = io_real_digest(v, io);
> -               r = crypto_shash_final(desc, result);
> -               if (r < 0) {
> -                       DMERR("crypto_shash_final failed: %d", r);
> +               r = verity_hash_final(v, desc, io_real_digest(v, io));
> +               if (unlikely(r < 0))
>                         return r;
> -               }
> -               if (unlikely(memcmp(result, io_want_digest(v, io), v->digest_size))) {
> -                       if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
> -                                             io->block + b))
> -                               return -EIO;
> -               }
> +
> +               if (likely(memcmp(io_real_digest(v, io),
> +                               io_want_digest(v, io), v->digest_size) == 0))
> +                       continue;
> +               else if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
> +                               io->block + b))
> +                       return -EIO;
>         }
>
>         return 0;
> --
> 2.6.0.rc2.230.g3dd15c0
>



-- 
Kees Cook
Chrome OS Security
