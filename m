From: Ignat Korchagin <ignat@cloudflare.com>
Subject: Re: [dm-devel] [PATCH v2] dm crypt: add flags to optionally bypass
 dm-crypt workqueues
Date: Mon, 6 Jul 2020 18:54:53 +0100
Message-ID: <CALrw=nHpp0Z-KQg9s=GsWK5+GgmHNWcK7J3drrCTn+kMQUPBTw@mail.gmail.com>
References: <20200626210302.1813-1-ignat@cloudflare.com> <3f7ba9df-de18-d641-2568-49ac2bc3719e@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3f7ba9df-de18-d641-2568-49ac2bc3719e@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bob Liu <bob.liu@oracle.com>
Cc: agk@redhat.com, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, dm-crypt@saout.de, linux-kernel <linux-kernel@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Herbert Xu <herbert@gondor.apana.org.au>, kernel-team <kernel-team@cloudflare.com>, Eric Biggers <ebiggers@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Mon, Jul 6, 2020 at 3:28 PM Bob Liu <bob.liu@oracle.com> wrote:
>
> Hi Ignat,
>
> On 6/27/20 5:03 AM, Ignat Korchagin wrote:
> > This is a follow up from [1]. Consider the following script:
> >
> > sudo modprobe brd rd_nr=1 rd_size=4194304
> >
>
> Did you test null_blk device? I didn't get result as expected using null_blk.

I've modified the script in the patch description to use a null_blk
device instead of /dev/ram0, but I created the block device with
queue_mode=0. My results are as follows:

reading from /dev/nullb0
   READ: bw=527MiB/s (552MB/s), 527MiB/s-527MiB/s (552MB/s-552MB/s),
io=92.6GiB (99.4GB), run=180000-180000msec
reading from /dev/mapper/eram0
   READ: bw=112MiB/s (117MB/s), 112MiB/s-112MiB/s (117MB/s-117MB/s),
io=19.7GiB (21.1GB), run=180001-180001msec
reading from /dev/mapper/eram0-inline-read
   READ: bw=288MiB/s (302MB/s), 288MiB/s-288MiB/s (302MB/s-302MB/s),
io=50.6GiB (54.3GB), run=180000-180000msec
reading from /dev/mapper/eram0-inline-write
   READ: bw=123MiB/s (129MB/s), 123MiB/s-123MiB/s (129MB/s-129MB/s),
io=21.6GiB (23.1GB), run=180000-180000msec
writing to /dev/nullb0
  WRITE: bw=510MiB/s (535MB/s), 510MiB/s-510MiB/s (535MB/s-535MB/s),
io=89.7GiB (96.3GB), run=180001-180001msec
writing to /dev/mapper/eram0
  WRITE: bw=45.9MiB/s (48.1MB/s), 45.9MiB/s-45.9MiB/s
(48.1MB/s-48.1MB/s), io=8264MiB (8666MB), run=180001-180001msec
writing to /dev/mapper/eram0-inline-read
  WRITE: bw=42.5MiB/s (44.6MB/s), 42.5MiB/s-42.5MiB/s
(44.6MB/s-44.6MB/s), io=7658MiB (8030MB), run=180001-180001msec
writing to /dev/mapper/eram0-inline-write
  WRITE: bw=259MiB/s (272MB/s), 259MiB/s-259MiB/s (272MB/s-272MB/s),
io=45.6GiB (48.0GB), run=180000-180000msec

Still see the same improvement. Can you retry your test with a
queue_mode=0 null_blk device?

Thanks,
Ignat

> 1.
> # fio --filename=/dev/nullb0 --readwrite=readwrite --bs=4k --direct=1 --loops    =1000000 --name=plain
> Run status group 0 (all jobs):
>   READ: bw=390MiB/s (409MB/s), 390MiB/s-390MiB/s (409MB/s-409MB/s), io=10.6GiB (11.3GB), run=27744-27744msec
>   WRITE: bw=390MiB/s (409MB/s), 390MiB/s-390MiB/s (409MB/s-409MB/s), io=10.6GiB (11.3GB), run=27744-27744msec
>
> 2.
> Create enctrypted-ram0 based on null_blk(without this patch):
> # cryptsetup open --header crypthdr.img /dev/nullb0 encrypted-ram0
> # fio --filename=/dev/mapper/encrypted-ram0 --readwrite=readwrite --bs=4k --direct=1 --loops=1000000 --name=crypt
> Run status group 0 (all jobs):
>   READ: bw=180MiB/s (188MB/s), 180MiB/s-180MiB/s (188MB/s-188MB/s), io=4534MiB (4754MB), run=25246-25246msec
>   WRITE: bw=179MiB/s (188MB/s), 179MiB/s-179MiB/s (188MB/s-188MB/s), io=4528MiB (4748MB), run=25246-25246msec
>
> 3.
> Create enctrypted-ram0 based on null_blk(with this patch):
> # cryptsetup open --header crypthdr.img /dev/nullb0 encrypted-ram0
> # fio --filename=/dev/mapper/encrypted-ram0 --readwrite=readwrite --bs=4k  --direct=1 --loops=1000000 --name=crypt.patched
> Run status group 0 (all jobs):
>   READ: bw=149MiB/s (156MB/s), 149MiB/s-149MiB/s (156MB/s-156MB/s), io=4128MiB (4329MB), run=27753-27753msec
>   WRITE: bw=149MiB/s (156MB/s), 149MiB/s-149MiB/s (156MB/s-156MB/s), io=4124MiB (4324MB), run=27753-27753msec
>
> Looks like the result is worse after this patch, or I may miss something..
>
> Regards,
> Bob
>
>
> > echo '0 8388608 crypt capi:ecb(cipher_null) - 0 /dev/ram0 0' | \
> > sudo dmsetup create eram0
> >
> > echo '0 8388608 crypt capi:ecb(cipher_null) - 0 /dev/ram0 0 1 no_write_workqueue' | \
> > sudo dmsetup create eram0-inline-write
> >
> > echo '0 8388608 crypt capi:ecb(cipher_null) - 0 /dev/ram0 0 1 no_read_workqueue' | \
> > sudo dmsetup create eram0-inline-read
> >
> > devices="/dev/ram0 /dev/mapper/eram0 /dev/mapper/eram0-inline-read "
> > devices+="/dev/mapper/eram0-inline-write"
> >
> > for dev in $devices; do
> >   echo "reading from $dev"
> >   sudo fio --filename=$dev --readwrite=read --bs=4k --direct=1 \
> >   --loops=1000000 --runtime=3m --name=plain | grep READ
> > done
> >
> > for dev in $devices; do
> >   echo "writing to $dev"
> >   sudo fio --filename=$dev --readwrite=write --bs=4k --direct=1 \
> >   --loops=1000000 --runtime=3m --name=plain | grep WRITE
> > done
> >
> > This script creates a ramdisk (to eliminate hardware bias in the benchmark) and
> > three dm-crypt instances on top. All dm-crypt instances use the NULL cipher
> > to eliminate potentially expensive crypto bias (the NULL cipher just uses memcpy
> > for "encyption"). The first instance is the current dm-crypt implementation from
> > 5.8-rc2, the two others have new optional flags enabled, which bypass kcryptd
> > workqueues for reads and writes respectively and write sorting for writes. On
> > my VM (Debian in VirtualBox with 4 cores on 2.8 GHz Quad-Core Intel Core i7) I
> > get the following output (formatted for better readability):
> >
> > reading from /dev/ram0
> >    READ: bw=508MiB/s (533MB/s), 508MiB/s-508MiB/s (533MB/s-533MB/s), io=89.3GiB (95.9GB), run=180000-180000msec
> >
> > reading from /dev/mapper/eram0
> >    READ: bw=80.6MiB/s (84.5MB/s), 80.6MiB/s-80.6MiB/s (84.5MB/s-84.5MB/s), io=14.2GiB (15.2GB), run=180000-180000msec
> >
> > reading from /dev/mapper/eram0-inline-read
> >    READ: bw=295MiB/s (309MB/s), 295MiB/s-295MiB/s (309MB/s-309MB/s), io=51.8GiB (55.6GB), run=180000-180000msec
> >
> > reading from /dev/mapper/eram0-inline-write
> >    READ: bw=114MiB/s (120MB/s), 114MiB/s-114MiB/s (120MB/s-120MB/s), io=20.1GiB (21.5GB), run=180000-180000msec
> >
> > writing to /dev/ram0
> >   WRITE: bw=516MiB/s (541MB/s), 516MiB/s-516MiB/s (541MB/s-541MB/s), io=90.7GiB (97.4GB), run=180001-180001msec
> >
> > writing to /dev/mapper/eram0
> >   WRITE: bw=40.4MiB/s (42.4MB/s), 40.4MiB/s-40.4MiB/s (42.4MB/s-42.4MB/s), io=7271MiB (7624MB), run=180001-180001msec
> >
> > writing to /dev/mapper/eram0-inline-read
> >   WRITE: bw=38.9MiB/s (40.8MB/s), 38.9MiB/s-38.9MiB/s (40.8MB/s-40.8MB/s), io=7000MiB (7340MB), run=180001-180001msec
> >
> > writing to /dev/mapper/eram0-inline-write
> >   WRITE: bw=277MiB/s (290MB/s), 277MiB/s-277MiB/s (290MB/s-290MB/s), io=48.6GiB (52.2GB), run=180000-180000msec
> >
> > Current dm-crypt implementation creates a significant IO performance overhead
> > (at least on small IO block sizes) for both latency and throughput. We suspect
> > offloading IO request processing into workqueues and async threads is more
> > harmful these days with the modern fast storage. I also did some digging into
> > the dm-crypt git history and much of this async processing is not needed
> > anymore, because the reasons it was added are mostly gone from the kernel. More
> > details can be found in [2] (see "Git archeology" section).
> >
> > This change adds no_(read|write)_workqueue flags separately for read and write
> > BIOs, which direct dm-crypt not to offload crypto operations into kcryptd
> > workqueues and process everything inline. In addition, writes are not buffered
> > to be sorted in the dm-crypt red-black tree, but dispatched immediately. For
> > cases, where crypto operations cannot happen inline (hard interrupt context,
> > for example the read path of some NVME drivers), we offload the work to a
> > tasklet rather than a workqueue.
> >
> > These flags ensure inline BIO processing in the dm-crypt module only. It is
> > worth noting that some Crypto API implementations may offload encryption into
> > their own workqueues, which are independent of the dm-crypt and its
> > configuration. However upon enabling no_(read|write)_workqueue flags dm-crypt
> > will instruct Crypto API not to backlog crypto requests.
> >
> > [1]: https://www.spinics.net/lists/dm-crypt/msg07516.html
> > [2]: https://blog.cloudflare.com/speeding-up-linux-disk-encryption/
> >
> > Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
> > ---
> >  drivers/md/dm-crypt.c | 68 +++++++++++++++++++++++++++++++++----------
> >  1 file changed, 52 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> > index 000ddfab5ba0..6924eb49b1df 100644
> > --- a/drivers/md/dm-crypt.c
> > +++ b/drivers/md/dm-crypt.c
> > @@ -69,6 +69,7 @@ struct dm_crypt_io {
> >       u8 *integrity_metadata;
> >       bool integrity_metadata_from_pool;
> >       struct work_struct work;
> > +     struct tasklet_struct tasklet;
> >
> >       struct convert_context ctx;
> >
> > @@ -127,7 +128,8 @@ struct iv_elephant_private {
> >   * and encrypts / decrypts at the same time.
> >   */
> >  enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,
> > -          DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD };
> > +          DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD,
> > +          DM_CRYPT_NO_READ_WORKQUEUE, DM_CRYPT_NO_WRITE_WORKQUEUE };
> >
> >  enum cipher_flags {
> >       CRYPT_MODE_INTEGRITY_AEAD,      /* Use authenticated mode for cihper */
> > @@ -1449,7 +1451,7 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
> >                              int error);
> >
> >  static void crypt_alloc_req_skcipher(struct crypt_config *cc,
> > -                                  struct convert_context *ctx)
> > +                                  struct convert_context *ctx, bool nobacklog)
> >  {
> >       unsigned key_index = ctx->cc_sector & (cc->tfms_count - 1);
> >
> > @@ -1463,12 +1465,12 @@ static void crypt_alloc_req_skcipher(struct crypt_config *cc,
> >        * requests if driver request queue is full.
> >        */
> >       skcipher_request_set_callback(ctx->r.req,
> > -         CRYPTO_TFM_REQ_MAY_BACKLOG,
> > +         nobacklog ? 0 : CRYPTO_TFM_REQ_MAY_BACKLOG,
> >           kcryptd_async_done, dmreq_of_req(cc, ctx->r.req));
> >  }
> >
> >  static void crypt_alloc_req_aead(struct crypt_config *cc,
> > -                              struct convert_context *ctx)
> > +                              struct convert_context *ctx, bool nobacklog)
> >  {
> >       if (!ctx->r.req_aead)
> >               ctx->r.req_aead = mempool_alloc(&cc->req_pool, GFP_NOIO);
> > @@ -1480,17 +1482,17 @@ static void crypt_alloc_req_aead(struct crypt_config *cc,
> >        * requests if driver request queue is full.
> >        */
> >       aead_request_set_callback(ctx->r.req_aead,
> > -         CRYPTO_TFM_REQ_MAY_BACKLOG,
> > +         nobacklog ? 0 : CRYPTO_TFM_REQ_MAY_BACKLOG,
> >           kcryptd_async_done, dmreq_of_req(cc, ctx->r.req_aead));
> >  }
> >
> >  static void crypt_alloc_req(struct crypt_config *cc,
> > -                         struct convert_context *ctx)
> > +                         struct convert_context *ctx, bool nobacklog)
> >  {
> >       if (crypt_integrity_aead(cc))
> > -             crypt_alloc_req_aead(cc, ctx);
> > +             crypt_alloc_req_aead(cc, ctx, nobacklog);
> >       else
> > -             crypt_alloc_req_skcipher(cc, ctx);
> > +             crypt_alloc_req_skcipher(cc, ctx, nobacklog);
> >  }
> >
> >  static void crypt_free_req_skcipher(struct crypt_config *cc,
> > @@ -1523,7 +1525,7 @@ static void crypt_free_req(struct crypt_config *cc, void *req, struct bio *base_
> >   * Encrypt / decrypt data from one bio to another one (can be the same one)
> >   */
> >  static blk_status_t crypt_convert(struct crypt_config *cc,
> > -                      struct convert_context *ctx)
> > +                      struct convert_context *ctx, bool noresched)
> >  {
> >       unsigned int tag_offset = 0;
> >       unsigned int sector_step = cc->sector_size >> SECTOR_SHIFT;
> > @@ -1533,7 +1535,7 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
> >
> >       while (ctx->iter_in.bi_size && ctx->iter_out.bi_size) {
> >
> > -             crypt_alloc_req(cc, ctx);
> > +             crypt_alloc_req(cc, ctx, noresched);
> >               atomic_inc(&ctx->cc_pending);
> >
> >               if (crypt_integrity_aead(cc))
> > @@ -1566,7 +1568,8 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
> >                       atomic_dec(&ctx->cc_pending);
> >                       ctx->cc_sector += sector_step;
> >                       tag_offset++;
> > -                     cond_resched();
> > +                     if (!noresched)
> > +                             cond_resched();
> >                       continue;
> >               /*
> >                * There was a data integrity error.
> > @@ -1879,6 +1882,9 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
> >       unsigned long flags;
> >       sector_t sector;
> >       struct rb_node **rbp, *parent;
> > +     bool nosort =
> > +                     (likely(!async) && test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags)) ||
> > +                     test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags);
> >
> >       if (unlikely(io->error)) {
> >               crypt_free_buffer_pages(cc, clone);
> > @@ -1892,7 +1898,7 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
> >
> >       clone->bi_iter.bi_sector = cc->start + io->sector;
> >
> > -     if (likely(!async) && test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags)) {
> > +     if (nosort) {
> >               generic_make_request(clone);
> >               return;
> >       }
> > @@ -1941,7 +1947,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
> >       sector += bio_sectors(clone);
> >
> >       crypt_inc_pending(io);
> > -     r = crypt_convert(cc, &io->ctx);
> > +     r = crypt_convert(cc, &io->ctx, test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags));
> >       if (r)
> >               io->error = r;
> >       crypt_finished = atomic_dec_and_test(&io->ctx.cc_pending);
> > @@ -1971,7 +1977,7 @@ static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
> >       crypt_convert_init(cc, &io->ctx, io->base_bio, io->base_bio,
> >                          io->sector);
> >
> > -     r = crypt_convert(cc, &io->ctx);
> > +     r = crypt_convert(cc, &io->ctx, test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags));
> >       if (r)
> >               io->error = r;
> >
> > @@ -2031,9 +2037,29 @@ static void kcryptd_crypt(struct work_struct *work)
> >               kcryptd_crypt_write_convert(io);
> >  }
> >
> > +static void kcryptd_crypt_tasklet(unsigned long work)
> > +{
> > +     kcryptd_crypt((struct work_struct *)work);
> > +}
> > +
> >  static void kcryptd_queue_crypt(struct dm_crypt_io *io)
> >  {
> >       struct crypt_config *cc = io->cc;
> > +     bool noworkqueue =
> > +                     (bio_data_dir(io->base_bio) == READ && test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags)) ||
> > +                     (bio_data_dir(io->base_bio) == WRITE && test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags));
> > +
> > +     if (noworkqueue) {
> > +             if (in_irq()) {
> > +                     /* Crypto API's "skcipher_walk_first() refuses to work in hard IRQ context */
> > +                     tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
> > +                     tasklet_schedule(&io->tasklet);
> > +                     return;
> > +             }
> > +
> > +             kcryptd_crypt(&io->work);
> > +             return;
> > +     }
> >
> >       INIT_WORK(&io->work, kcryptd_crypt);
> >       queue_work(cc->crypt_queue, &io->work);
> > @@ -2838,7 +2864,7 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
> >       struct crypt_config *cc = ti->private;
> >       struct dm_arg_set as;
> >       static const struct dm_arg _args[] = {
> > -             {0, 6, "Invalid number of feature args"},
> > +             {0, 8, "Invalid number of feature args"},
> >       };
> >       unsigned int opt_params, val;
> >       const char *opt_string, *sval;
> > @@ -2868,6 +2894,10 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
> >
> >               else if (!strcasecmp(opt_string, "submit_from_crypt_cpus"))
> >                       set_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);
> > +             else if (!strcasecmp(opt_string, "no_read_workqueue"))
> > +                     set_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags);
> > +             else if (!strcasecmp(opt_string, "no_write_workqueue"))
> > +                     set_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags);
> >               else if (sscanf(opt_string, "integrity:%u:", &val) == 1) {
> >                       if (val == 0 || val > MAX_TAG_SIZE) {
> >                               ti->error = "Invalid integrity arguments";
> > @@ -3196,6 +3226,8 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
> >               num_feature_args += !!ti->num_discard_bios;
> >               num_feature_args += test_bit(DM_CRYPT_SAME_CPU, &cc->flags);
> >               num_feature_args += test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);
> > +             num_feature_args += test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags);
> > +             num_feature_args += test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags);
> >               num_feature_args += cc->sector_size != (1 << SECTOR_SHIFT);
> >               num_feature_args += test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags);
> >               if (cc->on_disk_tag_size)
> > @@ -3208,6 +3240,10 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
> >                               DMEMIT(" same_cpu_crypt");
> >                       if (test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags))
> >                               DMEMIT(" submit_from_crypt_cpus");
> > +                     if (test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags))
> > +                             DMEMIT(" no_read_workqueue");
> > +                     if (test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))
> > +                             DMEMIT(" no_write_workqueue");
> >                       if (cc->on_disk_tag_size)
> >                               DMEMIT(" integrity:%u:%s", cc->on_disk_tag_size, cc->cipher_auth);
> >                       if (cc->sector_size != (1 << SECTOR_SHIFT))
> > @@ -3320,7 +3356,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
> >
> >  static struct target_type crypt_target = {
> >       .name   = "crypt",
> > -     .version = {1, 21, 0},
> > +     .version = {1, 22, 0},
> >       .module = THIS_MODULE,
> >       .ctr    = crypt_ctr,
> >       .dtr    = crypt_dtr,
> >
>
