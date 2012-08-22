From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH v6 01/13] block: Generalized bio pool freeing
Date: Wed, 22 Aug 2012 14:27:03 -0700
Message-ID: <1345670823.10190.21.camel@haakon2.linux-iscsi.org>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
	 <1345655050-28199-2-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345655050-28199-2-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: dm-devel.ids

On Wed, 2012-08-22 at 10:03 -0700, Kent Overstreet wrote:
> With the old code, when you allocate a bio from a bio pool you have to
> implement your own destructor that knows how to find the bio pool the
> bio was originally allocated from.
> 
> This adds a new field to struct bio (bi_pool) and changes
> bio_alloc_bioset() to use it. This makes various bio destructors
> unnecessary, so they're then deleted.
> 
> v6: Explain the temporary if statement in bio_put
> 
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> CC: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
> CC: Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
> CC: Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/block/drbd/drbd_main.c      | 13 +------------
>  drivers/md/dm-crypt.c               |  9 ---------
>  drivers/md/dm-io.c                  | 11 -----------
>  drivers/md/dm.c                     | 20 --------------------
>  drivers/md/md.c                     | 28 ++++------------------------
>  drivers/target/target_core_iblock.c |  9 ---------
>  fs/bio.c                            | 31 +++++++++++++------------------
>  include/linux/blk_types.h           |  3 +++
>  8 files changed, 21 insertions(+), 103 deletions(-)
> 

<SNIP>

> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index 76db75e..e58cd7d 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -543,14 +543,6 @@ static void iblock_complete_cmd(struct se_cmd *cmd)
>  	kfree(ibr);
>  }
>  
> -static void iblock_bio_destructor(struct bio *bio)
> -{
> -	struct se_cmd *cmd = bio->bi_private;
> -	struct iblock_dev *ib_dev = cmd->se_dev->dev_ptr;
> -
> -	bio_free(bio, ib_dev->ibd_bio_set);
> -}
> -
>  static struct bio *
>  iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num)
>  {
> @@ -572,7 +564,6 @@ iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num)
>  
>  	bio->bi_bdev = ib_dev->ibd_bd;
>  	bio->bi_private = cmd;
> -	bio->bi_destructor = iblock_bio_destructor;
>  	bio->bi_end_io = &iblock_bio_done;
>  	bio->bi_sector = lba;
>  	return bio;

The change to drop iblock_bio_destructor() looks fine to me.  For the
drivers/target/ bit, feel free to add:

Acked-by: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>

Nice work Kent!
