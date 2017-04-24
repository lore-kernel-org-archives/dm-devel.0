From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] dm verity: deferred hash checking for
 restart/logging mode
Date: Mon, 24 Apr 2017 10:05:03 +0200
Message-ID: <76b0b4ab-f811-7c8e-c88c-1210a0e67119@gmail.com>
References: <1493019260-43938-1-git-send-email-bongkyu.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1493019260-43938-1-git-send-email-bongkyu.kim@lge.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bongkyu Kim <bongkyu.kim@lge.com>, agk@redhat.com, snitzer@redhat.com
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Sami Tolvanen <samitolvanen@google.com>, shli@kernel.org
List-Id: dm-devel.ids

On 04/24/2017 09:34 AM, Bongkyu Kim wrote:
> This patch introduces deferred hash checking for dm-verity.
> In case of restart and logging mode, I/O return first and hash checking is
> deferred. It can improve dm-verity's performance greatly.
> 
> This is my testing on qualcomm snapdragon 821 platform with UFS 2.0.
> dd if=/dev/block/dm-0 of=/dev/null bs=1024 count=1000000
> - vanilla: 238.14 MB/s
> - patched: 331.52 MB/s (+39.2%)
> 
> fio --rw=randread --size=64M --bs=4k --filename=/dev/block/dm-0 --name=job1
>     --name=job2 --name=job3 --name=job4
> - vanilla: 325.21 MB/s
> - patched: 356.42 MB/s (+9.6%)
> 
> One major concoren is security risk.
> If data is tampered, this data will not return -EIO, and can be transferred
> to user process. But, device will be rebooted after hash verification.

Isn't one of the goal of integrity checking to PREVENT that userspace
accesses tampered data?

What happens if that corrupted part is malware that just send one packet
with confidential data in time window before it restarts?

Now I am not sure what is the Google Chromebook/Android threat model here.
If we accept patches that allows non-verified data to be returned to userspace,
dmverity just becomes way how to detect flaky hw, I cannot imagine it is acceptable
in "verified boot" chain.

Could someone from dm-verity authors comment this?
(I added Sami and Will to cc but not sure if there is anyone else)?

Milan

> After rebooting, device will work with EIO mode.
> In my opinion, this is enough for gurantee integrity by each power cycles.
> 
> Signed-off-by: Bongkyu Kim <bongkyu.kim@lge.com>
> ---
>  drivers/md/dm-verity-target.c | 58 ++++++++++++++++++++++++++++++++++++++++---
>  drivers/md/dm.c               | 17 +++++++++++--
>  drivers/md/dm.h               |  4 +++
>  3 files changed, 73 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 7335d8a..37c4d9c 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -16,6 +16,7 @@
>  
>  #include "dm-verity.h"
>  #include "dm-verity-fec.h"
> +#include "dm.h"
>  
>  #include <linux/module.h>
>  #include <linux/reboot.h>
> @@ -62,6 +63,9 @@ struct buffer_aux {
>  	int hash_verified;
>  };
>  
> +static void verity_submit_prefetch(struct dm_verity *v,
> +		struct dm_verity_io *io);
> +
>  /*
>   * Initialize struct buffer_aux for a freshly created buffer.
>   */
> @@ -462,12 +466,35 @@ static void verity_finish_io(struct dm_verity_io *io, int error)
>  	struct dm_verity *v = io->v;
>  	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
>  
> -	bio->bi_end_io = io->orig_bi_end_io;
> -	bio->bi_error = error;
> +	if (v->mode == DM_VERITY_MODE_EIO) {
> +		bio->bi_end_io = io->orig_bi_end_io;
> +		bio->bi_error = error;
> +	}
>  
>  	verity_fec_finish_io(io);
>  
> -	bio_endio(bio);
> +	if (v->mode == DM_VERITY_MODE_EIO) {
> +		bio_endio(bio);
> +	} else {
> +		struct dm_target_io *tio = container_of(bio,
> +				struct dm_target_io, clone);
> +		struct dm_io *dmio = tio->io;
> +		struct bio *ori_bio = dm_io_get_bio(dmio);
> +		struct bio_vec *bv;
> +		int i;
> +
> +		bio_put(bio);
> +		free_io(dm_io_get_md(dmio), dmio);
> +
> +		bio_for_each_segment_all(bv, ori_bio, i) {
> +			struct page *page = bv->bv_page;
> +
> +			put_page(page);
> +		}
> +
> +		bio_put(ori_bio);
> +
> +	}
>  }
>  
>  static void verity_work(struct work_struct *w)
> @@ -486,6 +513,28 @@ static void verity_end_io(struct bio *bio)
>  		return;
>  	}
>  
> +	if (io->v->mode != DM_VERITY_MODE_EIO) {
> +		struct dm_target_io *tio = container_of(bio,
> +				struct dm_target_io, clone);
> +		struct bio *ori_bio = dm_io_get_bio(tio->io);
> +		struct bio_vec *bv;
> +		int i;
> +
> +		bio_for_each_segment_all(bv, ori_bio, i) {
> +			struct page *page = bv->bv_page;
> +
> +			get_page(page);
> +		}
> +
> +		bio_get(ori_bio);
> +		bio_get(bio);
> +
> +		bio->bi_end_io = io->orig_bi_end_io;
> +		bio_endio(bio);
> +
> +		verity_submit_prefetch(io->v, io);
> +	}
> +
>  	INIT_WORK(&io->work, verity_work);
>  	queue_work(io->v->verify_wq, &io->work);
>  }
> @@ -586,7 +635,8 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
>  
>  	verity_fec_init_io(io);
>  
> -	verity_submit_prefetch(v, io);
> +	if (v->mode == DM_VERITY_MODE_EIO)
> +		verity_submit_prefetch(v, io);
>  
>  	generic_make_request(bio);
>  
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 8bf3977..9eca0a0 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -164,6 +164,18 @@ static unsigned dm_get_numa_node(void)
>  					 DM_NUMA_NODE, num_online_nodes() - 1);
>  }
>  
> +struct bio *dm_io_get_bio(struct dm_io *io)
> +{
> +	return io->bio;
> +}
> +EXPORT_SYMBOL(dm_io_get_bio);
> +
> +struct mapped_device *dm_io_get_md(struct dm_io *io)
> +{
> +	return io->md;
> +}
> +EXPORT_SYMBOL(dm_io_get_md);
> +
>  static int __init local_init(void)
>  {
>  	int r = -ENOMEM;
> @@ -489,7 +501,7 @@ static struct dm_io *alloc_io(struct mapped_device *md)
>  	return mempool_alloc(md->io_pool, GFP_NOIO);
>  }
>  
> -static void free_io(struct mapped_device *md, struct dm_io *io)
> +void free_io(struct mapped_device *md, struct dm_io *io)
>  {
>  	mempool_free(io, md->io_pool);
>  }
> @@ -796,7 +808,8 @@ static void dec_pending(struct dm_io *io, int error)
>  		io_error = io->error;
>  		bio = io->bio;
>  		end_io_acct(io);
> -		free_io(md, io);
> +		if (atomic_read(&bio->__bi_cnt) <= 1)
> +			free_io(md, io);
>  
>  		if (io_error == DM_ENDIO_REQUEUE)
>  			return;
> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> index f298b01..b026178 100644
> --- a/drivers/md/dm.h
> +++ b/drivers/md/dm.h
> @@ -213,4 +213,8 @@ void dm_free_md_mempools(struct dm_md_mempools *pools);
>   */
>  unsigned dm_get_reserved_bio_based_ios(void);
>  
> +struct bio *dm_io_get_bio(struct dm_io *io);
> +struct mapped_device *dm_io_get_md(struct dm_io *io);
> +void free_io(struct mapped_device *md, struct dm_io *io);
> +
>  #endif
> 
