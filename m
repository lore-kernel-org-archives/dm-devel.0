From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] dm thin metadata: Add support for a
 pre-commit callback
Date: Thu, 5 Dec 2019 14:40:49 -0500
Message-ID: <20191205193157.GA95063@lobo>
References: <20191204140742.26273-1-ntsironis@arrikto.com>
	<20191204140742.26273-2-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191204140742.26273-2-ntsironis@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Nikos Tsironis <ntsironis@arrikto.com>
Cc: dm-devel@redhat.com, thornber@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Wed, Dec 04 2019 at  9:07P -0500,
Nikos Tsironis <ntsironis@arrikto.com> wrote:

> Add support for one pre-commit callback which is run right before the
> metadata are committed.
> 
> This allows the thin provisioning target to run a callback before the
> metadata are committed and is required by the next commit.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
> ---
>  drivers/md/dm-thin-metadata.c | 29 +++++++++++++++++++++++++++++
>  drivers/md/dm-thin-metadata.h |  7 +++++++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
> index 4c68a7b93d5e..b88d6d701f5b 100644
> --- a/drivers/md/dm-thin-metadata.c
> +++ b/drivers/md/dm-thin-metadata.c
> @@ -189,6 +189,15 @@ struct dm_pool_metadata {
>  	sector_t data_block_size;
>  
>  	/*
> +	 * Pre-commit callback.
> +	 *
> +	 * This allows the thin provisioning target to run a callback before
> +	 * the metadata are committed.
> +	 */
> +	dm_pool_pre_commit_fn pre_commit_fn;
> +	void *pre_commit_context;
> +
> +	/*
>  	 * We reserve a section of the metadata for commit overhead.
>  	 * All reported space does *not* include this.
>  	 */
> @@ -826,6 +835,14 @@ static int __commit_transaction(struct dm_pool_metadata *pmd)
>  	if (unlikely(!pmd->in_service))
>  		return 0;
>  
> +	if (pmd->pre_commit_fn) {
> +		r = pmd->pre_commit_fn(pmd->pre_commit_context);
> +		if (r < 0) {
> +			DMERR("pre-commit callback failed");
> +			return r;
> +		}
> +	}
> +
>  	r = __write_changed_details(pmd);
>  	if (r < 0)
>  		return r;
> @@ -892,6 +909,8 @@ struct dm_pool_metadata *dm_pool_metadata_open(struct block_device *bdev,
>  	pmd->in_service = false;
>  	pmd->bdev = bdev;
>  	pmd->data_block_size = data_block_size;
> +	pmd->pre_commit_fn = NULL;
> +	pmd->pre_commit_context = NULL;
>  
>  	r = __create_persistent_data_objects(pmd, format_device);
>  	if (r) {
> @@ -2044,6 +2063,16 @@ int dm_pool_register_metadata_threshold(struct dm_pool_metadata *pmd,
>  	return r;
>  }
>  
> +void dm_pool_register_pre_commit_callback(struct dm_pool_metadata *pmd,
> +					  dm_pool_pre_commit_fn fn,
> +					  void *context)
> +{
> +	pmd_write_lock_in_core(pmd);
> +	pmd->pre_commit_fn = fn;
> +	pmd->pre_commit_context = context;
> +	pmd_write_unlock(pmd);
> +}
> +
>  int dm_pool_metadata_set_needs_check(struct dm_pool_metadata *pmd)
>  {
>  	int r = -EINVAL;
> diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
> index f6be0d733c20..7ef56bd2a7e3 100644
> --- a/drivers/md/dm-thin-metadata.h
> +++ b/drivers/md/dm-thin-metadata.h
> @@ -230,6 +230,13 @@ bool dm_pool_metadata_needs_check(struct dm_pool_metadata *pmd);
>   */
>  void dm_pool_issue_prefetches(struct dm_pool_metadata *pmd);
>  
> +/* Pre-commit callback */
> +typedef int (*dm_pool_pre_commit_fn)(void *context);
> +
> +void dm_pool_register_pre_commit_callback(struct dm_pool_metadata *pmd,
> +					  dm_pool_pre_commit_fn fn,
> +					  void *context);
> +
>  /*----------------------------------------------------------------*/
>  
>  #endif
> -- 
> 2.11.0
> 

I have this incremental, not seeing need to avoid using blkdev_issue_flush

---
 drivers/md/dm-thin.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 9c9a323c0c30..255a52f7bbf0 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3203,18 +3203,8 @@ static void metadata_low_callback(void *context)
 static int metadata_pre_commit_callback(void *context)
 {
 	struct pool_c *pt = context;
-	struct bio bio;
-	int r;
-
-	bio_init(&bio, NULL, 0);
-	bio_set_dev(&bio, pt->data_dev->bdev);
-	bio.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
-
-	r = submit_bio_wait(&bio);
 
-	bio_uninit(&bio);
-
-	return r;
+	return blkdev_issue_flush(pt->data_dev->bdev, GFP_NOIO, NULL);
 }
 
 static sector_t get_dev_size(struct block_device *bdev)
-- 
2.15.0
