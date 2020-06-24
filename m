From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [dm-devel] [RFC PATCH 1/1] Add DM_CRYPT_FORCE_INLINE flag to
 dm-crypt target
Date: Wed, 24 Jun 2020 05:12:40 +0000
Message-ID: <CY4PR04MB375140A86968BAEA71C8EDDFE7950@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200619164132.1648-1-ignat@cloudflare.com>
 <20200619164132.1648-2-ignat@cloudflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ignat Korchagin <ignat@cloudflare.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "dm-crypt@saout.de" <dm-crypt@saout.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>
List-Id: dm-devel.ids

On 2020/06/22 17:47, Ignat Korchagin wrote:=0A=
> Sometimes extra thread offloading imposed by dm-crypt hurts IO latency. T=
his is=0A=
> especially visible on busy systems with many processes/threads. Moreover,=
 most=0A=
> Crypto API implementaions are async, that is they offload crypto operatio=
ns on=0A=
> their own, so this dm-crypt offloading is excessive.=0A=
> =0A=
> This adds a new flag, which directs dm-crypt not to offload crypto operat=
ions=0A=
> and process everything inline. For cases, where crypto operations cannot =
happen=0A=
> inline (hard interrupt context, for example the read path of the NVME dri=
ver),=0A=
> we offload the work to a tasklet rather than a workqueue.=0A=
> =0A=
> Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>=0A=
> ---=0A=
>  drivers/md/dm-crypt.c | 55 +++++++++++++++++++++++++++++++++----------=
=0A=
>  1 file changed, 43 insertions(+), 12 deletions(-)=0A=
> =0A=
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c=0A=
> index 000ddfab5ba0..5a9bac4fdffb 100644=0A=
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
> @@ -127,7 +128,7 @@ struct iv_elephant_private {=0A=
>   * and encrypts / decrypts at the same time.=0A=
>   */=0A=
>  enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,=0A=
> -	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD };=0A=
> +	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD, DM_CRYPT_FORCE_INLINE =3D =
(sizeof(unsigned long) * 8 - 1) };=0A=
=0A=
I do not see why a special value needs to be defined for DM_CRYPT_FORCE_INL=
INE.=0A=
It is clear from the number of members in the enum that we have far less th=
an 32=0A=
flags. Also, it may be good to add DM_CRYPT_FORCE_INLINE as a new line to a=
void=0A=
the long-ish line.=0A=
=0A=
>  =0A=
>  enum cipher_flags {=0A=
>  	CRYPT_MODE_INTEGRITY_AEAD,	/* Use authenticated mode for cihper */=0A=
> @@ -1458,13 +1459,18 @@ static void crypt_alloc_req_skcipher(struct crypt=
_config *cc,=0A=
>  =0A=
>  	skcipher_request_set_tfm(ctx->r.req, cc->cipher_tfm.tfms[key_index]);=
=0A=
>  =0A=
> -	/*=0A=
> -	 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs=0A=
> -	 * requests if driver request queue is full.=0A=
> -	 */=0A=
> -	skcipher_request_set_callback(ctx->r.req,=0A=
> -	    CRYPTO_TFM_REQ_MAY_BACKLOG,=0A=
> -	    kcryptd_async_done, dmreq_of_req(cc, ctx->r.req));=0A=
> +	if (test_bit(DM_CRYPT_FORCE_INLINE, &cc->flags))=0A=
> +		/* make sure we zero important fields of the request */=0A=
> +		skcipher_request_set_callback(ctx->r.req,=0A=
> +	        0, NULL, NULL);=0A=
=0A=
May be add a return here to avoid the need for else ?=0A=
=0A=
> +	else=0A=
> +		/*=0A=
> +		 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs=0A=
> +		 * requests if driver request queue is full.=0A=
> +		 */=0A=
> +		skcipher_request_set_callback(ctx->r.req,=0A=
> +	        CRYPTO_TFM_REQ_MAY_BACKLOG,=0A=
> +	        kcryptd_async_done, dmreq_of_req(cc, ctx->r.req));=0A=
>  }=0A=
>  =0A=
>  static void crypt_alloc_req_aead(struct crypt_config *cc,=0A=
> @@ -1566,7 +1572,8 @@ static blk_status_t crypt_convert(struct crypt_conf=
ig *cc,=0A=
>  			atomic_dec(&ctx->cc_pending);=0A=
>  			ctx->cc_sector +=3D sector_step;=0A=
>  			tag_offset++;=0A=
> -			cond_resched();=0A=
> +			if (!test_bit(DM_CRYPT_FORCE_INLINE, &cc->flags))=0A=
> +				cond_resched();=0A=
>  			continue;=0A=
>  		/*=0A=
>  		 * There was a data integrity error.=0A=
> @@ -1892,6 +1899,11 @@ static void kcryptd_crypt_write_io_submit(struct d=
m_crypt_io *io, int async)=0A=
>  =0A=
>  	clone->bi_iter.bi_sector =3D cc->start + io->sector;=0A=
>  =0A=
> +	if (test_bit(DM_CRYPT_FORCE_INLINE, &cc->flags)) {=0A=
> +		generic_make_request(clone);=0A=
> +		return;=0A=
> +	}=0A=
> +=0A=
>  	if (likely(!async) && test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags)) {=0A=
=0A=
A little inline helper such as kcryptd_crypt_write_io_inline(io, async) wou=
ld=0A=
simplify things here: the conditions leading to an inline write will be gat=
hered=0A=
together and can be explained. And for SMR, since we also need an IO type b=
ased=0A=
selection, we can extent the helper without needing another change here.=0A=
=0A=
>  		generic_make_request(clone);=0A=
>  		return;=0A=
> @@ -2031,12 +2043,26 @@ static void kcryptd_crypt(struct work_struct *wor=
k)=0A=
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
>  =0A=
> -	INIT_WORK(&io->work, kcryptd_crypt);=0A=
> -	queue_work(cc->crypt_queue, &io->work);=0A=
> +	if (test_bit(DM_CRYPT_FORCE_INLINE, &cc->flags)) {=0A=
> +		if (in_irq()) {=0A=
> +			/* Crypto API will fail hard in hard IRQ context */=0A=
> +			tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io-=
>work);=0A=
> +			tasklet_schedule(&io->tasklet);=0A=
> +		} else=0A=
> +			kcryptd_crypt(&io->work);=0A=
=0A=
Same as above: return here to avoid the else ?=0A=
=0A=
> +	} else {=0A=
> +		INIT_WORK(&io->work, kcryptd_crypt);=0A=
> +		queue_work(cc->crypt_queue, &io->work);=0A=
> +	}=0A=
>  }=0A=
>  =0A=
>  static void crypt_free_tfms_aead(struct crypt_config *cc)=0A=
> @@ -2838,7 +2864,7 @@ static int crypt_ctr_optional(struct dm_target *ti,=
 unsigned int argc, char **ar=0A=
>  	struct crypt_config *cc =3D ti->private;=0A=
>  	struct dm_arg_set as;=0A=
>  	static const struct dm_arg _args[] =3D {=0A=
> -		{0, 6, "Invalid number of feature args"},=0A=
> +		{0, 7, "Invalid number of feature args"},=0A=
>  	};=0A=
>  	unsigned int opt_params, val;=0A=
>  	const char *opt_string, *sval;=0A=
> @@ -2868,6 +2894,8 @@ static int crypt_ctr_optional(struct dm_target *ti,=
 unsigned int argc, char **ar=0A=
>  =0A=
>  		else if (!strcasecmp(opt_string, "submit_from_crypt_cpus"))=0A=
>  			set_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);=0A=
> +		else if (!strcasecmp(opt_string, "force_inline"))=0A=
> +			set_bit(DM_CRYPT_FORCE_INLINE, &cc->flags);=0A=
>  		else if (sscanf(opt_string, "integrity:%u:", &val) =3D=3D 1) {=0A=
>  			if (val =3D=3D 0 || val > MAX_TAG_SIZE) {=0A=
>  				ti->error =3D "Invalid integrity arguments";=0A=
> @@ -3196,6 +3224,7 @@ static void crypt_status(struct dm_target *ti, stat=
us_type_t type,=0A=
>  		num_feature_args +=3D !!ti->num_discard_bios;=0A=
>  		num_feature_args +=3D test_bit(DM_CRYPT_SAME_CPU, &cc->flags);=0A=
>  		num_feature_args +=3D test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);=0A=
> +		num_feature_args +=3D test_bit(DM_CRYPT_FORCE_INLINE, &cc->flags);=0A=
>  		num_feature_args +=3D cc->sector_size !=3D (1 << SECTOR_SHIFT);=0A=
>  		num_feature_args +=3D test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_fla=
gs);=0A=
>  		if (cc->on_disk_tag_size)=0A=
> @@ -3208,6 +3237,8 @@ static void crypt_status(struct dm_target *ti, stat=
us_type_t type,=0A=
>  				DMEMIT(" same_cpu_crypt");=0A=
>  			if (test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags))=0A=
>  				DMEMIT(" submit_from_crypt_cpus");=0A=
> +			if (test_bit(DM_CRYPT_FORCE_INLINE, &cc->flags))=0A=
> +				DMEMIT(" force_inline");=0A=
>  			if (cc->on_disk_tag_size)=0A=
>  				DMEMIT(" integrity:%u:%s", cc->on_disk_tag_size, cc->cipher_auth);=
=0A=
>  			if (cc->sector_size !=3D (1 << SECTOR_SHIFT))=0A=
> =0A=
=0A=
Apart from the above few comments, this all looks OK to me (and tested).=0A=
One question though: do you have patches for cryptsetup user land tools to =
allow=0A=
controlling the specification of the inline flag on device open ?=0A=
=0A=
It turns out that the most difficult part of the SMR support is patching=0A=
cryptsetup. Not much work needed for plain use, but formats such as Luks do=
 not=0A=
write super block and metadata sequentially, which causes problems with dri=
ves=0A=
that do not have conventional zones at LBA 0...=0A=
But this is my problem to solve :)=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
