From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2] dm crypt: add flags to optionally bypass dm-crypt
 workqueues
Date: Tue, 30 Jun 2020 02:51:17 +0000
Message-ID: <CY4PR04MB375127DC313F70875CAAC841E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200626210302.1813-1-ignat@cloudflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ignat Korchagin <ignat@cloudflare.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "dm-crypt@saout.de" <dm-crypt@saout.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "ebiggers@kernel.org" <ebiggers@kernel.org>, "mpatocka@redhat.com" <mpatocka@redhat.com>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>
List-Id: dm-devel.ids

On 2020/06/27 6:03, Ignat Korchagin wrote:=0A=
> This is a follow up from [1]. Consider the following script:=0A=
> =0A=
> sudo modprobe brd rd_nr=3D1 rd_size=3D4194304=0A=
> =0A=
> echo '0 8388608 crypt capi:ecb(cipher_null) - 0 /dev/ram0 0' | \=0A=
> sudo dmsetup create eram0=0A=
> =0A=
> echo '0 8388608 crypt capi:ecb(cipher_null) - 0 /dev/ram0 0 1 no_write_wo=
rkqueue' | \=0A=
> sudo dmsetup create eram0-inline-write=0A=
> =0A=
> echo '0 8388608 crypt capi:ecb(cipher_null) - 0 /dev/ram0 0 1 no_read_wor=
kqueue' | \=0A=
> sudo dmsetup create eram0-inline-read=0A=
> =0A=
> devices=3D"/dev/ram0 /dev/mapper/eram0 /dev/mapper/eram0-inline-read "=0A=
> devices+=3D"/dev/mapper/eram0-inline-write"=0A=
> =0A=
> for dev in $devices; do=0A=
>   echo "reading from $dev"=0A=
>   sudo fio --filename=3D$dev --readwrite=3Dread --bs=3D4k --direct=3D1 \=
=0A=
>   --loops=3D1000000 --runtime=3D3m --name=3Dplain | grep READ=0A=
> done=0A=
> =0A=
> for dev in $devices; do=0A=
>   echo "writing to $dev"=0A=
>   sudo fio --filename=3D$dev --readwrite=3Dwrite --bs=3D4k --direct=3D1 \=
=0A=
>   --loops=3D1000000 --runtime=3D3m --name=3Dplain | grep WRITE=0A=
> done=0A=
> =0A=
> This script creates a ramdisk (to eliminate hardware bias in the benchmar=
k) and=0A=
> three dm-crypt instances on top. All dm-crypt instances use the NULL ciph=
er=0A=
> to eliminate potentially expensive crypto bias (the NULL cipher just uses=
 memcpy=0A=
> for "encyption"). The first instance is the current dm-crypt implementati=
on from=0A=
> 5.8-rc2, the two others have new optional flags enabled, which bypass kcr=
yptd=0A=
> workqueues for reads and writes respectively and write sorting for writes=
. On=0A=
> my VM (Debian in VirtualBox with 4 cores on 2.8 GHz Quad-Core Intel Core =
i7) I=0A=
> get the following output (formatted for better readability):=0A=
> =0A=
> reading from /dev/ram0=0A=
>    READ: bw=3D508MiB/s (533MB/s), 508MiB/s-508MiB/s (533MB/s-533MB/s), io=
=3D89.3GiB (95.9GB), run=3D180000-180000msec=0A=
> =0A=
> reading from /dev/mapper/eram0=0A=
>    READ: bw=3D80.6MiB/s (84.5MB/s), 80.6MiB/s-80.6MiB/s (84.5MB/s-84.5MB/=
s), io=3D14.2GiB (15.2GB), run=3D180000-180000msec=0A=
> =0A=
> reading from /dev/mapper/eram0-inline-read=0A=
>    READ: bw=3D295MiB/s (309MB/s), 295MiB/s-295MiB/s (309MB/s-309MB/s), io=
=3D51.8GiB (55.6GB), run=3D180000-180000msec=0A=
> =0A=
> reading from /dev/mapper/eram0-inline-write=0A=
>    READ: bw=3D114MiB/s (120MB/s), 114MiB/s-114MiB/s (120MB/s-120MB/s), io=
=3D20.1GiB (21.5GB), run=3D180000-180000msec=0A=
> =0A=
> writing to /dev/ram0=0A=
>   WRITE: bw=3D516MiB/s (541MB/s), 516MiB/s-516MiB/s (541MB/s-541MB/s), io=
=3D90.7GiB (97.4GB), run=3D180001-180001msec=0A=
> =0A=
> writing to /dev/mapper/eram0=0A=
>   WRITE: bw=3D40.4MiB/s (42.4MB/s), 40.4MiB/s-40.4MiB/s (42.4MB/s-42.4MB/=
s), io=3D7271MiB (7624MB), run=3D180001-180001msec=0A=
> =0A=
> writing to /dev/mapper/eram0-inline-read=0A=
>   WRITE: bw=3D38.9MiB/s (40.8MB/s), 38.9MiB/s-38.9MiB/s (40.8MB/s-40.8MB/=
s), io=3D7000MiB (7340MB), run=3D180001-180001msec=0A=
> =0A=
> writing to /dev/mapper/eram0-inline-write=0A=
>   WRITE: bw=3D277MiB/s (290MB/s), 277MiB/s-277MiB/s (290MB/s-290MB/s), io=
=3D48.6GiB (52.2GB), run=3D180000-180000msec=0A=
> =0A=
> Current dm-crypt implementation creates a significant IO performance over=
head=0A=
> (at least on small IO block sizes) for both latency and throughput. We su=
spect=0A=
> offloading IO request processing into workqueues and async threads is mor=
e=0A=
> harmful these days with the modern fast storage. I also did some digging =
into=0A=
> the dm-crypt git history and much of this async processing is not needed=
=0A=
> anymore, because the reasons it was added are mostly gone from the kernel=
. More=0A=
> details can be found in [2] (see "Git archeology" section).=0A=
> =0A=
> This change adds no_(read|write)_workqueue flags separately for read and =
write=0A=
> BIOs, which direct dm-crypt not to offload crypto operations into kcryptd=
=0A=
> workqueues and process everything inline. In addition, writes are not buf=
fered=0A=
> to be sorted in the dm-crypt red-black tree, but dispatched immediately. =
For=0A=
> cases, where crypto operations cannot happen inline (hard interrupt conte=
xt,=0A=
> for example the read path of some NVME drivers), we offload the work to a=
=0A=
> tasklet rather than a workqueue.=0A=
> =0A=
> These flags ensure inline BIO processing in the dm-crypt module only. It =
is=0A=
> worth noting that some Crypto API implementations may offload encryption =
into=0A=
> their own workqueues, which are independent of the dm-crypt and its=0A=
> configuration. However upon enabling no_(read|write)_workqueue flags dm-c=
rypt=0A=
> will instruct Crypto API not to backlog crypto requests.=0A=
> =0A=
> [1]: https://www.spinics.net/lists/dm-crypt/msg07516.html=0A=
> [2]: https://blog.cloudflare.com/speeding-up-linux-disk-encryption/=0A=
> =0A=
> Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>=0A=
> ---=0A=
>  drivers/md/dm-crypt.c | 68 +++++++++++++++++++++++++++++++++----------=
=0A=
>  1 file changed, 52 insertions(+), 16 deletions(-)=0A=
> =0A=
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c=0A=
> index 000ddfab5ba0..6924eb49b1df 100644=0A=
> --- a/drivers/md/dm-crypt.c=0A=
> +++ b/drivers/md/dm-crypt.c=0A=
> @@ -69,6 +69,7 @@ struct dm_crypt_io {=0A=
>  	u8 *integrity_metadata;=0A=
>  	bool integrity_metadata_from_pool;=0A=
>  	struct work_struct work;=0A=
> +	struct tasklet_struct tasklet;=0A=
>  =0A=
>  	struct convert_context ctx;=0A=
>  =0A=
> @@ -127,7 +128,8 @@ struct iv_elephant_private {=0A=
>   * and encrypts / decrypts at the same time.=0A=
>   */=0A=
>  enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,=0A=
> -	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD };=0A=
> +	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD,=0A=
> +	     DM_CRYPT_NO_READ_WORKQUEUE, DM_CRYPT_NO_WRITE_WORKQUEUE };=0A=
=0A=
I liked the "INLINE" naming. What about DM_CRYPT_READ_INLINE and=0A=
DM_CRYPT_WRITE_INLINE ? Shorter too :)=0A=
=0A=
But from the changes below, it looks like your change is now less about bei=
ng=0A=
purely inline or synchronous but about bypassing the workqueue.=0A=
Is this correct ?=0A=
=0A=
>  =0A=
>  enum cipher_flags {=0A=
>  	CRYPT_MODE_INTEGRITY_AEAD,	/* Use authenticated mode for cihper */=0A=
> @@ -1449,7 +1451,7 @@ static void kcryptd_async_done(struct crypto_async_=
request *async_req,=0A=
>  			       int error);=0A=
>  =0A=
>  static void crypt_alloc_req_skcipher(struct crypt_config *cc,=0A=
> -				     struct convert_context *ctx)=0A=
> +				     struct convert_context *ctx, bool nobacklog)=0A=
>  {=0A=
>  	unsigned key_index =3D ctx->cc_sector & (cc->tfms_count - 1);=0A=
>  =0A=
> @@ -1463,12 +1465,12 @@ static void crypt_alloc_req_skcipher(struct crypt=
_config *cc,=0A=
>  	 * requests if driver request queue is full.=0A=
>  	 */=0A=
>  	skcipher_request_set_callback(ctx->r.req,=0A=
> -	    CRYPTO_TFM_REQ_MAY_BACKLOG,=0A=
> +	    nobacklog ? 0 : CRYPTO_TFM_REQ_MAY_BACKLOG,=0A=
>  	    kcryptd_async_done, dmreq_of_req(cc, ctx->r.req));=0A=
=0A=
Will not specifying CRYPTO_TFM_REQ_MAY_BACKLOG always cause the crypto API =
to=0A=
return -EBUSY ? From the comment above the skcipher_request_set_callback(),=
 it=0A=
seems that this will be the case only if the skcipher diver queue is full. =
So in=0A=
other word, keeping the kcryptd_async_done() callback and executing the skc=
ipher=0A=
request through crypt_convert() and crypt_convert_block_skcipher() may stil=
l end=0A=
up being an asynchronous operation. Can you confirm this and is it what you=
=0A=
intended to implement ?=0A=
=0A=
From my understanding of the crypto API, and from what Eric commented, a tr=
uly=0A=
synchronous/inline execution of the skcypher needs a call like:=0A=
=0A=
crypto_wait_req(crypto_skcipher_encrypt(req), &wait);=0A=
=0A=
For SMR use case were we must absolutely preserve the write requests order,=
 the=0A=
above change will probably be needed. Will check again.=0A=
=0A=
>  }=0A=
>  =0A=
>  static void crypt_alloc_req_aead(struct crypt_config *cc,=0A=
> -				 struct convert_context *ctx)=0A=
> +				 struct convert_context *ctx, bool nobacklog)=0A=
>  {=0A=
>  	if (!ctx->r.req_aead)=0A=
>  		ctx->r.req_aead =3D mempool_alloc(&cc->req_pool, GFP_NOIO);=0A=
> @@ -1480,17 +1482,17 @@ static void crypt_alloc_req_aead(struct crypt_con=
fig *cc,=0A=
>  	 * requests if driver request queue is full.=0A=
>  	 */=0A=
>  	aead_request_set_callback(ctx->r.req_aead,=0A=
> -	    CRYPTO_TFM_REQ_MAY_BACKLOG,=0A=
> +	    nobacklog ? 0 : CRYPTO_TFM_REQ_MAY_BACKLOG,=0A=
>  	    kcryptd_async_done, dmreq_of_req(cc, ctx->r.req_aead));=0A=
>  }=0A=
>  =0A=
>  static void crypt_alloc_req(struct crypt_config *cc,=0A=
> -			    struct convert_context *ctx)=0A=
> +			    struct convert_context *ctx, bool nobacklog)=0A=
>  {=0A=
>  	if (crypt_integrity_aead(cc))=0A=
> -		crypt_alloc_req_aead(cc, ctx);=0A=
> +		crypt_alloc_req_aead(cc, ctx, nobacklog);=0A=
>  	else=0A=
> -		crypt_alloc_req_skcipher(cc, ctx);=0A=
> +		crypt_alloc_req_skcipher(cc, ctx, nobacklog);=0A=
>  }=0A=
>  =0A=
>  static void crypt_free_req_skcipher(struct crypt_config *cc,=0A=
> @@ -1523,7 +1525,7 @@ static void crypt_free_req(struct crypt_config *cc,=
 void *req, struct bio *base_=0A=
>   * Encrypt / decrypt data from one bio to another one (can be the same o=
ne)=0A=
>   */=0A=
>  static blk_status_t crypt_convert(struct crypt_config *cc,=0A=
> -			 struct convert_context *ctx)=0A=
> +			 struct convert_context *ctx, bool noresched)=0A=
=0A=
"noresched" is named after what will happen, not after the reason for it. S=
o to=0A=
clarify, why not rename this as "convert_inline" or "do_inline" ?=0A=
=0A=
>  {=0A=
>  	unsigned int tag_offset =3D 0;=0A=
>  	unsigned int sector_step =3D cc->sector_size >> SECTOR_SHIFT;=0A=
> @@ -1533,7 +1535,7 @@ static blk_status_t crypt_convert(struct crypt_conf=
ig *cc,=0A=
>  =0A=
>  	while (ctx->iter_in.bi_size && ctx->iter_out.bi_size) {=0A=
>  =0A=
> -		crypt_alloc_req(cc, ctx);=0A=
> +		crypt_alloc_req(cc, ctx, noresched);=0A=
>  		atomic_inc(&ctx->cc_pending);=0A=
>  =0A=
>  		if (crypt_integrity_aead(cc))=0A=
> @@ -1566,7 +1568,8 @@ static blk_status_t crypt_convert(struct crypt_conf=
ig *cc,=0A=
>  			atomic_dec(&ctx->cc_pending);=0A=
>  			ctx->cc_sector +=3D sector_step;=0A=
>  			tag_offset++;=0A=
> -			cond_resched();=0A=
> +			if (!noresched)=0A=
> +				cond_resched();=0A=
>  			continue;=0A=
>  		/*=0A=
>  		 * There was a data integrity error.=0A=
> @@ -1879,6 +1882,9 @@ static void kcryptd_crypt_write_io_submit(struct dm=
_crypt_io *io, int async)=0A=
>  	unsigned long flags;=0A=
>  	sector_t sector;=0A=
>  	struct rb_node **rbp, *parent;=0A=
> +	bool nosort =3D=0A=
> +			(likely(!async) && test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags)) ||=0A=
> +			test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags);=0A=
=0A=
"nosort" is a little obscure as a name. Why not just "do_inline" ? In any c=
ase,=0A=
since this bool is used only in the if below, you could just write the cond=
ition=0A=
directly there.=0A=
=0A=
>  =0A=
>  	if (unlikely(io->error)) {=0A=
>  		crypt_free_buffer_pages(cc, clone);=0A=
> @@ -1892,7 +1898,7 @@ static void kcryptd_crypt_write_io_submit(struct dm=
_crypt_io *io, int async)=0A=
>  =0A=
>  	clone->bi_iter.bi_sector =3D cc->start + io->sector;=0A=
>  =0A=
> -	if (likely(!async) && test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags)) {=0A=
> +	if (nosort) {=0A=
>  		generic_make_request(clone);=0A=
>  		return;=0A=
>  	}=0A=
> @@ -1941,7 +1947,7 @@ static void kcryptd_crypt_write_convert(struct dm_c=
rypt_io *io)=0A=
>  	sector +=3D bio_sectors(clone);=0A=
>  =0A=
>  	crypt_inc_pending(io);=0A=
> -	r =3D crypt_convert(cc, &io->ctx);=0A=
> +	r =3D crypt_convert(cc, &io->ctx, test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE,=
 &cc->flags));=0A=
>  	if (r)=0A=
>  		io->error =3D r;=0A=
>  	crypt_finished =3D atomic_dec_and_test(&io->ctx.cc_pending);=0A=
> @@ -1971,7 +1977,7 @@ static void kcryptd_crypt_read_convert(struct dm_cr=
ypt_io *io)=0A=
>  	crypt_convert_init(cc, &io->ctx, io->base_bio, io->base_bio,=0A=
>  			   io->sector);=0A=
>  =0A=
> -	r =3D crypt_convert(cc, &io->ctx);=0A=
> +	r =3D crypt_convert(cc, &io->ctx, test_bit(DM_CRYPT_NO_READ_WORKQUEUE, =
&cc->flags));=0A=
>  	if (r)=0A=
>  		io->error =3D r;=0A=
>  =0A=
> @@ -2031,9 +2037,29 @@ static void kcryptd_crypt(struct work_struct *work=
)=0A=
>  		kcryptd_crypt_write_convert(io);=0A=
>  }=0A=
>  =0A=
> +static void kcryptd_crypt_tasklet(unsigned long work)=0A=
> +{=0A=
> +	kcryptd_crypt((struct work_struct *)work);=0A=
> +}=0A=
> +=0A=
>  static void kcryptd_queue_crypt(struct dm_crypt_io *io)=0A=
>  {=0A=
>  	struct crypt_config *cc =3D io->cc;=0A=
> +	bool noworkqueue =3D=0A=
> +			(bio_data_dir(io->base_bio) =3D=3D READ && test_bit(DM_CRYPT_NO_READ_=
WORKQUEUE, &cc->flags)) ||=0A=
> +			(bio_data_dir(io->base_bio) =3D=3D WRITE && test_bit(DM_CRYPT_NO_WRIT=
E_WORKQUEUE, &cc->flags));=0A=
=0A=
Since this variable is used only in the if statement bleow, why not used th=
e=0A=
condition directly in that statement ?=0A=
=0A=
> +=0A=
> +	if (noworkqueue) {=0A=
> +		if (in_irq()) {=0A=
> +			/* Crypto API's "skcipher_walk_first() refuses to work in hard IRQ co=
ntext */=0A=
> +			tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io-=
>work);=0A=
> +			tasklet_schedule(&io->tasklet);=0A=
> +			return;=0A=
> +		}=0A=
> +=0A=
> +		kcryptd_crypt(&io->work);=0A=
> +		return;=0A=
> +	}=0A=
>  =0A=
>  	INIT_WORK(&io->work, kcryptd_crypt);=0A=
>  	queue_work(cc->crypt_queue, &io->work);=0A=
> @@ -2838,7 +2864,7 @@ static int crypt_ctr_optional(struct dm_target *ti,=
 unsigned int argc, char **ar=0A=
>  	struct crypt_config *cc =3D ti->private;=0A=
>  	struct dm_arg_set as;=0A=
>  	static const struct dm_arg _args[] =3D {=0A=
> -		{0, 6, "Invalid number of feature args"},=0A=
> +		{0, 8, "Invalid number of feature args"},=0A=
>  	};=0A=
>  	unsigned int opt_params, val;=0A=
>  	const char *opt_string, *sval;=0A=
> @@ -2868,6 +2894,10 @@ static int crypt_ctr_optional(struct dm_target *ti=
, unsigned int argc, char **ar=0A=
>  =0A=
>  		else if (!strcasecmp(opt_string, "submit_from_crypt_cpus"))=0A=
>  			set_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);=0A=
> +		else if (!strcasecmp(opt_string, "no_read_workqueue"))=0A=
> +			set_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags);=0A=
> +		else if (!strcasecmp(opt_string, "no_write_workqueue"))=0A=
> +			set_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags);=0A=
>  		else if (sscanf(opt_string, "integrity:%u:", &val) =3D=3D 1) {=0A=
>  			if (val =3D=3D 0 || val > MAX_TAG_SIZE) {=0A=
>  				ti->error =3D "Invalid integrity arguments";=0A=
> @@ -3196,6 +3226,8 @@ static void crypt_status(struct dm_target *ti, stat=
us_type_t type,=0A=
>  		num_feature_args +=3D !!ti->num_discard_bios;=0A=
>  		num_feature_args +=3D test_bit(DM_CRYPT_SAME_CPU, &cc->flags);=0A=
>  		num_feature_args +=3D test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);=0A=
> +		num_feature_args +=3D test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags)=
;=0A=
> +		num_feature_args +=3D test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags=
);=0A=
>  		num_feature_args +=3D cc->sector_size !=3D (1 << SECTOR_SHIFT);=0A=
>  		num_feature_args +=3D test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_fla=
gs);=0A=
>  		if (cc->on_disk_tag_size)=0A=
> @@ -3208,6 +3240,10 @@ static void crypt_status(struct dm_target *ti, sta=
tus_type_t type,=0A=
>  				DMEMIT(" same_cpu_crypt");=0A=
>  			if (test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags))=0A=
>  				DMEMIT(" submit_from_crypt_cpus");=0A=
> +			if (test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags))=0A=
> +				DMEMIT(" no_read_workqueue");=0A=
> +			if (test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))=0A=
> +				DMEMIT(" no_write_workqueue");=0A=
>  			if (cc->on_disk_tag_size)=0A=
>  				DMEMIT(" integrity:%u:%s", cc->on_disk_tag_size, cc->cipher_auth);=
=0A=
>  			if (cc->sector_size !=3D (1 << SECTOR_SHIFT))=0A=
> @@ -3320,7 +3356,7 @@ static void crypt_io_hints(struct dm_target *ti, st=
ruct queue_limits *limits)=0A=
>  =0A=
>  static struct target_type crypt_target =3D {=0A=
>  	.name   =3D "crypt",=0A=
> -	.version =3D {1, 21, 0},=0A=
> +	.version =3D {1, 22, 0},=0A=
>  	.module =3D THIS_MODULE,=0A=
>  	.ctr    =3D crypt_ctr,=0A=
>  	.dtr    =3D crypt_dtr,=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
