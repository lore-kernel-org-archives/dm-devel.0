From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v3] dm crypt: add flags to optionally bypass dm-crypt
 workqueues
Date: Wed, 8 Jul 2020 00:27:18 +0000
Message-ID: <CY4PR04MB375107B8F7E8EE29854408E1E7670@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200706173731.3734-1-ignat@cloudflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ignat Korchagin <ignat@cloudflare.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "dm-crypt@saout.de" <dm-crypt@saout.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "ebiggers@kernel.org" <ebiggers@kernel.org>, "mpatocka@redhat.com" <mpatocka@redhat.com>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>, "nobuto.murata@canonical.com" <nobuto.murata@canonical.com>, "bob.liu@oracle.com" <bob.liu@oracle.com>
List-Id: dm-devel.ids

On 2020/07/07 2:37, Ignat Korchagin wrote:=0A=
> Changes from v2:=0A=
>   * dropped nobacklog boolean - ciphers are OK to backlog requests=0A=
>   * moved some conditionals inline dropping the extra local variables=0A=
>   * renamed "noresched" -> "atomic"=0A=
> =0A=
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
>  drivers/md/dm-crypt.c | 50 ++++++++++++++++++++++++++++++++++++-------=
=0A=
>  1 file changed, 42 insertions(+), 8 deletions(-)=0A=
> =0A=
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c=0A=
> index 000ddfab5ba0..7536ecb2c95d 100644=0A=
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
>  =0A=
>  enum cipher_flags {=0A=
>  	CRYPT_MODE_INTEGRITY_AEAD,	/* Use authenticated mode for cihper */=0A=
> @@ -1523,7 +1525,7 @@ static void crypt_free_req(struct crypt_config *cc,=
 void *req, struct bio *base_=0A=
>   * Encrypt / decrypt data from one bio to another one (can be the same o=
ne)=0A=
>   */=0A=
>  static blk_status_t crypt_convert(struct crypt_config *cc,=0A=
> -			 struct convert_context *ctx)=0A=
> +			 struct convert_context *ctx, bool atomic)=0A=
>  {=0A=
>  	unsigned int tag_offset =3D 0;=0A=
>  	unsigned int sector_step =3D cc->sector_size >> SECTOR_SHIFT;=0A=
> @@ -1566,7 +1568,8 @@ static blk_status_t crypt_convert(struct crypt_conf=
ig *cc,=0A=
>  			atomic_dec(&ctx->cc_pending);=0A=
>  			ctx->cc_sector +=3D sector_step;=0A=
>  			tag_offset++;=0A=
> -			cond_resched();=0A=
> +			if (!atomic)=0A=
> +				cond_resched();=0A=
>  			continue;=0A=
>  		/*=0A=
>  		 * There was a data integrity error.=0A=
> @@ -1892,7 +1895,8 @@ static void kcryptd_crypt_write_io_submit(struct dm=
_crypt_io *io, int async)=0A=
>  =0A=
>  	clone->bi_iter.bi_sector =3D cc->start + io->sector;=0A=
>  =0A=
> -	if (likely(!async) && test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags)) {=0A=
> +	if ((likely(!async) && test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags)) ||=0A=
> +	    test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags)) {=0A=
>  		generic_make_request(clone);=0A=
>  		return;=0A=
>  	}=0A=
> @@ -1941,7 +1945,8 @@ static void kcryptd_crypt_write_convert(struct dm_c=
rypt_io *io)=0A=
>  	sector +=3D bio_sectors(clone);=0A=
>  =0A=
>  	crypt_inc_pending(io);=0A=
> -	r =3D crypt_convert(cc, &io->ctx);=0A=
> +	r =3D crypt_convert(cc, &io->ctx,=0A=
> +			  test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags));=0A=
>  	if (r)=0A=
>  		io->error =3D r;=0A=
>  	crypt_finished =3D atomic_dec_and_test(&io->ctx.cc_pending);=0A=
> @@ -1971,7 +1976,8 @@ static void kcryptd_crypt_read_convert(struct dm_cr=
ypt_io *io)=0A=
>  	crypt_convert_init(cc, &io->ctx, io->base_bio, io->base_bio,=0A=
>  			   io->sector);=0A=
>  =0A=
> -	r =3D crypt_convert(cc, &io->ctx);=0A=
> +	r =3D crypt_convert(cc, &io->ctx,=0A=
> +			  test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags));=0A=
>  	if (r)=0A=
>  		io->error =3D r;=0A=
>  =0A=
> @@ -2031,10 +2037,28 @@ static void kcryptd_crypt(struct work_struct *wor=
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
> +	if ((bio_data_dir(io->base_bio) =3D=3D READ && test_bit(DM_CRYPT_NO_REA=
D_WORKQUEUE, &cc->flags)) ||=0A=
> +	    (bio_data_dir(io->base_bio) =3D=3D WRITE && test_bit(DM_CRYPT_NO_WR=
ITE_WORKQUEUE, &cc->flags))) {=0A=
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
> +=0A=
>  	INIT_WORK(&io->work, kcryptd_crypt);=0A=
>  	queue_work(cc->crypt_queue, &io->work);=0A=
>  }=0A=
> @@ -2838,7 +2862,7 @@ static int crypt_ctr_optional(struct dm_target *ti,=
 unsigned int argc, char **ar=0A=
>  	struct crypt_config *cc =3D ti->private;=0A=
>  	struct dm_arg_set as;=0A=
>  	static const struct dm_arg _args[] =3D {=0A=
> -		{0, 6, "Invalid number of feature args"},=0A=
> +		{0, 8, "Invalid number of feature args"},=0A=
>  	};=0A=
>  	unsigned int opt_params, val;=0A=
>  	const char *opt_string, *sval;=0A=
> @@ -2868,6 +2892,10 @@ static int crypt_ctr_optional(struct dm_target *ti=
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
> @@ -3196,6 +3224,8 @@ static void crypt_status(struct dm_target *ti, stat=
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
> @@ -3208,6 +3238,10 @@ static void crypt_status(struct dm_target *ti, sta=
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
> @@ -3320,7 +3354,7 @@ static void crypt_io_hints(struct dm_target *ti, st=
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
Looks good to me. I am using this patch to rebase the SMR disk support. The=
=0A=
separation of the read and write flags simplifies that support.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
